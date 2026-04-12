from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify, session as flask_session
from flask_login import current_user, login_required
from extensions import db
from models.user import Student
from models.exam import Exam, ExamSession, StudentAnswer, ExamResult, Question, QuestionOption, ProctoringLog
from models.class_model import Class
from utils.decorators import student_required
from datetime import datetime, timedelta
import random
import string
import json

student_bp = Blueprint('student', __name__)

# ==================== DASHBOARD ====================

@student_bp.route('/dashboard')
@login_required
def dashboard():
    if current_user.role.name != 'Student':
        flash('Access denied.', 'error')
        return redirect(url_for('main.index'))
    
    from datetime import datetime
    now = datetime.utcnow()
    
    total_exams_taken = ExamResult.query.filter_by(student_id=current_user.id).count()
    results = ExamResult.query.filter_by(student_id=current_user.id).all()
    
    if results:
        avg_score = round(sum(r.percentage for r in results) / len(results), 1)
    else:
        avg_score = 0.0
    
    class_rank = None
    class_students_count = 0
    
    student_profile = None
    if hasattr(current_user, 'student_profile'):
        profile = current_user.student_profile
        if isinstance(profile, list):
            student_profile = profile[0] if profile else None
        else:
            student_profile = profile
    
    if student_profile and student_profile.class_id:
        class_id = student_profile.class_id
        class_students = Student.query.filter_by(class_id=class_id).all()
        class_students_count = len(class_students)
        
        student_avgs = []
        for s in class_students:
            s_results = ExamResult.query.filter_by(student_id=s.user_id).all()
            s_avg = sum(r.percentage for r in s_results) / len(s_results) if s_results else 0
            student_avgs.append((s.user_id, s_avg))
        
        student_avgs.sort(key=lambda x: x[1], reverse=True)
        for rank, (uid, _) in enumerate(student_avgs, 1):
            if uid == current_user.id:
                class_rank = rank
                break
    
    available_exams = Exam.query.filter(
        Exam.published == True,
        Exam.start_date <= now,
        Exam.end_date >= now
    ).all()
    
    taken_exam_ids = [r.exam_id for r in results]
    available_exams = [e for e in available_exams if e.id not in taken_exam_ids]
    
    recent_results = ExamResult.query.filter_by(
        student_id=current_user.id
    ).order_by(ExamResult.submitted_at.desc()).limit(5).all()
    
    upcoming_exams = Exam.query.filter(
        Exam.published == True,
        Exam.start_date > now
    ).all()
    
    completed_exams = results
    
    past_exams = Exam.query.filter(
        Exam.published == True,
        Exam.end_date < now
    ).all()
    
    return render_template(
        'student/dashboard.html',
        total_exams_taken=total_exams_taken,
        avg_score=avg_score,
        class_rank=class_rank,
        class_students_count=class_students_count,
        available_exams=available_exams,
        recent_results=recent_results,
        upcoming_exams=upcoming_exams,
        completed_exams=completed_exams,
        past_exams=past_exams
    )

# ==================== EXAM PASSCODE VERIFICATION ====================

@student_bp.route('/exam/<int:session_id>/passcode', methods=['GET'])
@login_required
def exam_passcode(session_id):
    exam_session = ExamSession.query.get_or_404(session_id)
    if exam_session.student_id != current_user.id:
        flash('You do not have permission to access this exam.', 'danger')
        return redirect(url_for('student.dashboard'))
    if exam_session.status == 'completed':
        flash('You have already completed this exam.', 'warning')
        return redirect(url_for('student.exam_result', session_id=session_id))
    if flask_session.get(f'passcode_verified_{session_id}'):
        return redirect(url_for('student.take_exam', session_id=session_id))
    exam = exam_session.exam
    return render_template('student/exam_passcode.html', exam=exam, session=exam_session)


@student_bp.route('/exam/<int:session_id>/verify-passcode', methods=['POST'])
@login_required
def verify_passcode(session_id):
    exam_session = ExamSession.query.get_or_404(session_id)
    if exam_session.student_id != current_user.id:
        flash('You do not have permission to access this exam.', 'danger')
        return redirect(url_for('student.dashboard'))
    exam = exam_session.exam
    passcode_entered = request.form.get('passcode', '').strip()
    if not exam.passcode:
        flask_session[f'passcode_verified_{session_id}'] = True
        return redirect(url_for('student.take_exam', session_id=session_id))
    if passcode_entered == exam.passcode:
        flask_session[f'passcode_verified_{session_id}'] = True
        flash('Passcode verified! You may now begin the exam.', 'success')
        return redirect(url_for('student.take_exam', session_id=session_id))
    else:
        flash('Incorrect passcode. Please try again or contact your instructor.', 'danger')
        return redirect(url_for('student.exam_passcode', session_id=session_id))

# ==================== EXAM TAKING ====================

@student_bp.route('/exam/<int:exam_id>/start', methods=['GET', 'POST'])
@login_required
@student_required
def start_exam(exam_id):
    try:
        print(f"\n=== START EXAM ===")
        print(f"Student ID: {current_user.id}, Exam ID: {exam_id}")
        
        exam = Exam.query.get_or_404(exam_id)
        if not exam.published:
            flash('This exam is not yet available.', 'warning')
            return redirect(url_for('student.dashboard'))
        
        now = datetime.utcnow()
        if exam.start_date and now < exam.start_date:
            flash('This exam has not started yet.', 'warning')
            return redirect(url_for('student.dashboard'))
        if exam.end_date and now > exam.end_date:
            flash('This exam has already ended.', 'warning')
            return redirect(url_for('student.dashboard'))
        
        student = Student.query.filter_by(user_id=current_user.id).first()
        if not student:
            flash('Student profile not found.', 'danger')
            return redirect(url_for('student.dashboard'))
        
        existing_result = ExamResult.query.filter_by(exam_id=exam_id, student_id=current_user.id).first()
        if existing_result:
            flash('You have already taken this exam.', 'warning')
            return redirect(url_for('student.view_result', result_id=existing_result.id))
        
        questions = Question.query.filter_by(exam_id=exam_id).order_by(Question.order).all()
        if not questions:
            flash('This exam has no questions yet.', 'danger')
            return redirect(url_for('student.dashboard'))
        
        if request.method == 'POST':
            session_code = f"SESSION-{exam_id}-{student.user_id}-{int(datetime.utcnow().timestamp())}"
            session_token = ''.join(random.choices(string.ascii_letters + string.digits, k=32))
            
            exam_session = ExamSession(
                exam_id=exam_id,
                student_id=student.user_id,
                session_code=session_code,
                session_token=session_token,
                status='started',
                start_time=datetime.utcnow(),
                last_activity=datetime.utcnow()
            )
            db.session.add(exam_session)
            db.session.commit()
            
            flask_session[f'exam_{exam_id}_session_id'] = exam_session.id
            
            if exam.passcode:
                return redirect(url_for('student.exam_passcode', session_id=exam_session.id))
            else:
                flask_session[f'passcode_verified_{exam_session.id}'] = True
                return redirect(url_for('student.take_exam', session_id=exam_session.id))
        
        return render_template('student/start_exam.html', exam=exam, questions=questions)
        
    except Exception as e:
        print(f"ERROR in start_exam: {str(e)}")
        import traceback; traceback.print_exc()
        flash(f'Error starting exam: {str(e)}', 'danger')
        return redirect(url_for('student.dashboard'))


@student_bp.route('/exam/<int:session_id>/take', methods=['GET', 'POST'])
@login_required
def take_exam(session_id):
    try:
        exam_session = ExamSession.query.get_or_404(session_id)
        if exam_session.student_id != current_user.id:
            flash('You do not have permission to access this exam.', 'danger')
            return redirect(url_for('student.dashboard'))
        if not flask_session.get(f'passcode_verified_{session_id}'):
            return redirect(url_for('student.exam_passcode', session_id=session_id))
        if exam_session.status in ('completed', 'submitted'):
            flash('You have already completed this exam.', 'warning')
            return redirect(url_for('student.dashboard'))
        
        exam = exam_session.exam
        questions = Question.query.filter_by(exam_id=exam.id).order_by(Question.order).all()
        
        if exam_session.status in ('pending', 'started'):
            exam_session.status = 'in_progress'
            if not exam_session.start_time:
                exam_session.start_time = datetime.utcnow()
            exam_session.last_activity = datetime.utcnow()
            db.session.commit()
        
        if exam_session.start_time:
            elapsed_time = (datetime.utcnow() - exam_session.start_time).total_seconds() / 60
            if elapsed_time > exam.duration_minutes:
                flash('Time has expired for this exam.', 'warning')
                return redirect(url_for('student.submit_exam', session_id=session_id))
        
        if request.method == 'POST':
            try:
                answers_saved = 0
                for question in questions:
                    answer_key = f'question_{question.id}'
                    if question.question_type in ['mcq', 'true_false']:
                        selected_option_id = request.form.get(answer_key, type=int)
                        if selected_option_id:
                            existing = StudentAnswer.query.filter_by(
                                exam_session_id=session_id,
                                question_id=question.id,
                                student_id=current_user.id
                            ).first()
                            if existing:
                                existing.selected_option_id = selected_option_id
                                existing.updated_at = datetime.utcnow()
                            else:
                                db.session.add(StudentAnswer(
                                    exam_session_id=session_id,
                                    question_id=question.id,
                                    student_id=current_user.id,
                                    selected_option_id=selected_option_id
                                ))
                            answers_saved += 1
                    elif question.question_type == 'theory':
                        answer_text = request.form.get(answer_key, '').strip()
                        if answer_text:
                            existing = StudentAnswer.query.filter_by(
                                exam_session_id=session_id,
                                question_id=question.id,
                                student_id=current_user.id
                            ).first()
                            if existing:
                                existing.theory_answer = answer_text
                                existing.updated_at = datetime.utcnow()
                            else:
                                db.session.add(StudentAnswer(
                                    exam_session_id=session_id,
                                    question_id=question.id,
                                    student_id=current_user.id,
                                    theory_answer=answer_text
                                ))
                            answers_saved += 1
                
                db.session.commit()
                exam_session.status = 'completed'
                exam_session.end_time = datetime.utcnow()
                if exam_session.start_time and hasattr(exam_session, 'time_taken'):
                    exam_session.time_taken = int(
                        (exam_session.end_time - exam_session.start_time).total_seconds() / 60
                    )
                db.session.commit()
                flask_session.pop(f'passcode_verified_{session_id}', None)
                return redirect(url_for('student.submit_exam', session_id=session_id))
                
            except Exception as e:
                db.session.rollback()
                flash(f'Error submitting exam: {str(e)}', 'danger')
                import traceback; traceback.print_exc()
        
        exam_session.last_activity = datetime.utcnow()
        db.session.commit()
        return render_template('student/take_exam.html', exam=exam, session=exam_session, questions=questions)
        
    except Exception as e:
        print(f"ERROR in take_exam: {str(e)}")
        import traceback; traceback.print_exc()
        flash(f'Error loading exam: {str(e)}', 'danger')
        return redirect(url_for('student.dashboard'))


@student_bp.route('/api/exam/<int:exam_id>/save-answers', methods=['POST'])
@login_required
@student_required
def save_answers_during_exam(exam_id):
    try:
        data = request.get_json()
        session_id = data.get('session_id')
        answers = data.get('answers', {})
        
        if not session_id:
            return jsonify({'success': False, 'message': 'No session ID'}), 400
            
        exam_session = ExamSession.query.get(session_id)
        if not exam_session or exam_session.student_id != current_user.id:
            return jsonify({'success': False, 'message': 'Invalid session'}), 403
            
        saved_count = 0
        for field_name, answer_value in answers.items():
            if not field_name.startswith('question_'):
                continue
            try:
                question_id = int(field_name.replace('question_', ''))
                question = Question.query.get(question_id)
                if not question or question.exam_id != exam_id:
                    continue
                
                student_answer = StudentAnswer.query.filter_by(
                    exam_session_id=session_id,
                    question_id=question_id,
                    student_id=current_user.id
                ).first()
                
                if not student_answer:
                    student_answer = StudentAnswer(
                        exam_session_id=session_id,
                        question_id=question_id,
                        student_id=current_user.id
                    )
                    db.session.add(student_answer)
                
                if question.question_type in ['mcq', 'true_false']:
                    try:
                        student_answer.selected_option_id = int(answer_value)
                    except (ValueError, TypeError):
                        continue
                elif question.question_type == 'theory':
                    if answer_value:
                        student_answer.theory_answer = str(answer_value).strip()
                
                student_answer.updated_at = datetime.utcnow()
                saved_count += 1
            except Exception:
                continue
        
        db.session.commit()
        return jsonify({'success': True, 'saved_count': saved_count})
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': str(e)}), 500


# ==================== SUBMIT EXAM (MANUAL / FORM POST) ====================

@student_bp.route('/exam/session/<int:session_id>/submit', methods=['GET', 'POST'])
@login_required
@student_required
def submit_exam(session_id):
    """
    Score the exam and create the ExamResult record.
    Called after take_exam saves answers (POST path) or directly via GET
    (redirect after auto-save).
    """
    try:
        print(f"\n=== SUBMIT EXAM  session_id={session_id} method={request.method} ===")

        exam_session = ExamSession.query.get_or_404(session_id)
        exam         = exam_session.exam

        # ── Ownership ────────────────────────────────────────────────────
        if exam_session.student_id != current_user.id:
            flash('Invalid exam session.', 'danger')
            return redirect(url_for('student.dashboard'))

        # ── Duplicate-result guard ────────────────────────────────────────
        existing_result = ExamResult.query.filter_by(exam_session_id=session_id).first()
        if existing_result:
            flash('This exam has already been submitted.', 'info')
            return redirect(url_for('student.view_result', result_id=existing_result.id))

        questions = Question.query.filter_by(exam_id=exam.id).all()

        # ── If POST: persist form answers before scoring ──────────────────
        if request.method == 'POST':
            print("=== SAVING ANSWERS FROM FORM ===")
            answers_saved = 0
            for question in questions:
                answer_key = f'question_{question.id}'

                if question.question_type in ['mcq', 'true_false']:
                    selected_option_id = request.form.get(answer_key, type=int)
                    if selected_option_id:
                        existing = StudentAnswer.query.filter_by(
                            exam_session_id=session_id,
                            question_id=question.id,
                            student_id=current_user.id
                        ).first()
                        if existing:
                            existing.selected_option_id = selected_option_id
                            existing.updated_at = datetime.utcnow()
                        else:
                            db.session.add(StudentAnswer(
                                exam_session_id=session_id,
                                question_id=question.id,
                                student_id=current_user.id,
                                selected_option_id=selected_option_id
                            ))
                        answers_saved += 1

                elif question.question_type == 'theory':
                    answer_text = request.form.get(answer_key, '').strip()
                    if answer_text:
                        existing = StudentAnswer.query.filter_by(
                            exam_session_id=session_id,
                            question_id=question.id,
                            student_id=current_user.id
                        ).first()
                        if existing:
                            existing.theory_answer = answer_text
                            existing.updated_at = datetime.utcnow()
                        else:
                            db.session.add(StudentAnswer(
                                exam_session_id=session_id,
                                question_id=question.id,
                                student_id=current_user.id,
                                theory_answer=answer_text
                            ))
                        answers_saved += 1

            db.session.commit()
            print(f"✓ Saved {answers_saved} answers from form")

        # ── Score all answers ─────────────────────────────────────────────
        total_marks_obtained = 0
        correct_count        = 0
        incorrect_count      = 0
        unattempted_count    = 0

        print(f"Scoring {len(questions)} questions...")
        for question in questions:
            answer = StudentAnswer.query.filter_by(
                exam_session_id=session_id,
                question_id=question.id
            ).first()

            if not answer:
                unattempted_count += 1
                print(f"  Q{question.id}: unattempted")
                continue

            if question.question_type in ('mcq', 'true_false'):
                if answer.selected_option_id:
                    option = QuestionOption.query.get(answer.selected_option_id)
                    if option:
                        is_correct = option.is_correct
                        answer.is_correct      = is_correct
                        answer.marks_obtained  = question.marks if is_correct else 0
                        if is_correct:
                            total_marks_obtained += question.marks
                            correct_count        += 1
                            print(f"  Q{question.id}: ✓ correct +{question.marks}")
                        else:
                            incorrect_count += 1
                            print(f"  Q{question.id}: ✗ incorrect")
                    else:
                        answer.is_correct     = False
                        answer.marks_obtained = 0
                        incorrect_count       += 1
                        print(f"  Q{question.id}: option not found")
                else:
                    unattempted_count += 1
                    print(f"  Q{question.id}: no option selected")

            elif question.question_type == 'theory':
                # Teacher grades manually; mark as 0 for now
                if answer.theory_answer and answer.theory_answer.strip():
                    answer.marks_obtained = 0
                    print(f"  Q{question.id}: theory answered (manual grading)")
                else:
                    unattempted_count += 1
                    print(f"  Q{question.id}: theory unattempted")

        db.session.commit()  # Persist is_correct / marks_obtained on each answer

        # ── Calculate totals ──────────────────────────────────────────────
        total_marks = exam.total_marks or 0
        pass_marks  = exam.pass_marks  or 0

        if total_marks > 0:
            percentage = round((total_marks_obtained / total_marks) * 100, 2)
            is_passed  = total_marks_obtained >= pass_marks
        else:
            percentage = 0.0
            is_passed  = False

        print(f"Score: {total_marks_obtained}/{total_marks} = {percentage}%  passed={is_passed}")
        print(f"Correct={correct_count}  Incorrect={incorrect_count}  Unattempted={unattempted_count}")

        # ── Create ExamResult ─────────────────────────────────────────────
        result = ExamResult(
            exam_id          = exam.id,
            student_id       = current_user.id,
            exam_session_id  = session_id,
            total_marks      = total_marks,
            marks_obtained   = total_marks_obtained,
            percentage       = percentage,
            pass_marks       = pass_marks,
            is_passed        = is_passed,
            submitted_at     = datetime.utcnow()
        )
        if hasattr(result, 'calculate_result'):
            result.calculate_result()

        db.session.add(result)

        # ── Finalise session ──────────────────────────────────────────────
        exam_session.status   = 'submitted'
        if not exam_session.end_time:
            exam_session.end_time = datetime.utcnow()
        if exam_session.start_time and hasattr(exam_session, 'time_taken') and not exam_session.time_taken:
            exam_session.time_taken = int(
                (exam_session.end_time - exam_session.start_time).total_seconds() / 60
            )

        db.session.commit()
        print(f"✓ ExamResult created id={result.id}")

        # ── Redirect ──────────────────────────────────────────────────────
        if getattr(exam, 'allow_student_view_result', True):
            flash(f'Exam submitted successfully! Score: {percentage:.2f}%', 'success')
            return redirect(url_for('student.view_result', result_id=result.id))
        else:
            flash('Exam submitted successfully! Results will be published by your teacher soon.', 'info')
            return redirect(url_for('student.dashboard'))

    except Exception as e:
        db.session.rollback()
        print(f"ERROR in submit_exam: {str(e)}")
        import traceback; traceback.print_exc()
        flash(f'Error submitting exam: {str(e)}', 'danger')
        return redirect(url_for('student.dashboard'))


# ==================== AUTO-SUBMIT (timer / tab-switch) ====================

@student_bp.route('/api/test', methods=['GET', 'POST'])
def api_test():
    return jsonify({'ok': True, 'method': request.method, 'message': 'student blueprint is reachable'})


@student_bp.route('/api/exam/session/<int:session_id>/auto-submit', methods=['POST'])
def auto_submit_exam(session_id):
    """
    Auto-submit when timer expires or proctoring limit is reached.
    1. Saves any answers sent from the frontend.
    2. Scores all answers from the database.
    3. Creates ExamResult and returns JSON.
    """
    print(f"\n{'='*50}")
    print(f"AUTO-SUBMIT  session_id={session_id}")

    # ── Parse body ──────────────────────────────────────────────────────────
    # Handles fetch() (Content-Type: application/json) AND sendBeacon()
    # which may arrive as text/plain or with no explicit content-type.
    data = {}
    try:
        # force=True ignores Content-Type so sendBeacon blobs are parsed too
        data = request.get_json(force=True, silent=True) or {}
        raw_preview = str(data)[:300]
        print(f"Parsed body: {raw_preview}")
    except Exception as e:
        print(f"Body parse error: {e}")
    if not data:
        try:
            raw = request.get_data(as_text=True)
            print(f"Raw body fallback: {raw[:500]}")
            data = json.loads(raw) if raw else {}
        except Exception as e2:
            print(f"Raw parse also failed: {e2}")

    student_id         = data.get('student_id')
    reason             = data.get('reason', 'unknown')
    submitted_answers  = data.get('answers', {})
    time_spent         = data.get('time_spent', 0)

    print(f"student_id={student_id}  reason={reason}  incoming_answers={len(submitted_answers)}")

    # ── Auth fallback ─────────────────────────────────────────
    if not student_id:
        try:
            from flask_login import current_user as cu
            if cu and cu.is_authenticated:
                student_id = cu.id
                print(f"student_id from flask-login: {student_id}")
        except Exception as e:
            print(f"flask-login fallback error: {e}")

    if not student_id:
        return jsonify({'success': False, 'message': 'No student_id provided'}), 400

    student_id = int(student_id)

    # ── Fetch session ─────────────────────────────────────────
    exam_session = ExamSession.query.get(session_id)
    if not exam_session:
        return jsonify({'success': False, 'message': f'Session {session_id} not found'}), 404

    if exam_session.student_id != student_id:
        return jsonify({'success': False, 'message': 'Unauthorised'}), 403

    # ── Already submitted? ────────────────────────────────────
    if exam_session.status in ('submitted', 'completed'):
        existing = ExamResult.query.filter_by(exam_session_id=session_id).first()
        print(f"Already submitted. existing_result={existing.id if existing else None}")
        return jsonify({
            'success':    True,
            'already_done': True,
            'result_id':  existing.id if existing else None,
            'allow_view': getattr(exam_session.exam, 'allow_student_view_result', True)
        })

    exam = exam_session.exam
    print(f"Exam: {exam.title}  total_marks={exam.total_marks}")

    # ── 1. SAVE INCOMING ANSWERS ──────────────────────────────
    saved_answer_count = 0
    if submitted_answers:
        print(f"Processing {len(submitted_answers)} incoming answers...")
        for field_name, answer_value in submitted_answers.items():
            if not field_name.startswith('question_'):
                continue
            try:
                question_id = int(field_name.replace('question_', ''))
                # Use a targeted query; do NOT expire_all() here
                question = Question.query.filter_by(id=question_id, exam_id=exam.id).first()
                if not question:
                    print(f"  Skip {field_name}: not in this exam")
                    continue

                student_answer = StudentAnswer.query.filter_by(
                    exam_session_id=session_id,
                    question_id=question_id,
                    student_id=student_id
                ).first()

                if not student_answer:
                    student_answer = StudentAnswer(
                        exam_session_id=session_id,
                        question_id=question_id,
                        student_id=student_id
                    )
                    db.session.add(student_answer)

                if question.question_type in ('mcq', 'true_false'):
                    try:
                        student_answer.selected_option_id = int(answer_value)
                        print(f"  MCQ Q{question_id} → option {answer_value}")
                    except (ValueError, TypeError) as e:
                        print(f"  Skip {field_name}: bad option value ({e})")
                        continue
                elif question.question_type == 'theory':
                    if answer_value and str(answer_value).strip():
                        student_answer.theory_answer = str(answer_value).strip()
                        print(f"  Theory Q{question_id} → saved")

                student_answer.updated_at = datetime.utcnow()
                saved_answer_count += 1

            except Exception as e:
                print(f"Error saving {field_name}: {e}")
                import traceback; traceback.print_exc()
                continue

        try:
            db.session.flush()   # assign PKs to any new StudentAnswer rows
            db.session.commit()
            # Expire the identity map so the scoring queries below hit
            # the database directly rather than returning stale cached objects.
            db.session.expire_all()
            print(f"✓ Committed {saved_answer_count} incoming answers (identity map cleared)")
        except Exception as e:
            db.session.rollback()
            print(f"✗ Commit error: {e}")
            import traceback; traceback.print_exc()

    # ── 2. MARK SESSION SUBMITTED ─────────────────────────────
    # Re-fetch exam_session after expire_all to get a fresh object
    exam_session = ExamSession.query.get(session_id)
    exam_session.status   = 'submitted'
    exam_session.end_time = datetime.utcnow()
    if exam_session.start_time and hasattr(exam_session, 'time_taken') and not exam_session.time_taken:
        elapsed = (exam_session.end_time - exam_session.start_time).total_seconds() / 60
        exam_session.time_taken = int(elapsed)
    if time_spent and hasattr(exam_session, 'time_taken'):
        exam_session.time_taken = int(time_spent / 60)
    db.session.commit()

    # ── 3. SCORE ALL ANSWERS ─────────────────────────────────
    # Fresh query after all commits — identity map is already cleared above.
    questions = Question.query.filter_by(exam_id=exam.id).all()

    total_marks_obtained = 0
    correct_count        = 0
    incorrect_count      = 0
    unattempted_count    = 0
    answered_count       = 0

    # Diagnostic: confirm answers exist in DB before scoring
    db_answer_count = StudentAnswer.query.filter_by(exam_session_id=session_id).count()
    print(f"DB check before scoring: {db_answer_count} answers in DB for session {session_id}")

    print(f"Scoring {len(questions)} questions...")
    for question in questions:
        answer = StudentAnswer.query.filter_by(
            exam_session_id=session_id,
            question_id=question.id
        ).first()

        if not answer:
            unattempted_count += 1
            print(f"  Q{question.id}: no answer in DB")
            continue

        answered_count += 1

        if question.question_type in ('mcq', 'true_false'):
            if answer.selected_option_id:
                option = QuestionOption.query.get(answer.selected_option_id)
                if option:
                    is_correct            = bool(option.is_correct)
                    answer.is_correct     = is_correct
                    answer.marks_obtained = question.marks if is_correct else 0
                    if is_correct:
                        total_marks_obtained += question.marks
                        correct_count        += 1
                        print(f"  Q{question.id}: ✓ +{question.marks}")
                    else:
                        incorrect_count += 1
                        print(f"  Q{question.id}: ✗")
                else:
                    answer.is_correct     = False
                    answer.marks_obtained = 0
                    incorrect_count       += 1
                    print(f"  Q{question.id}: option {answer.selected_option_id} not found")
            else:
                unattempted_count += 1
                print(f"  Q{question.id}: selected_option_id is None")

        elif question.question_type == 'theory':
            if answer.theory_answer and answer.theory_answer.strip():
                answer.marks_obtained = 0  # manual grading
                print(f"  Q{question.id}: theory answered")
            else:
                unattempted_count += 1
                print(f"  Q{question.id}: theory empty")

    db.session.commit()
    print(f"✓ Scoring done: {total_marks_obtained} marks | correct={correct_count} "
          f"incorrect={incorrect_count} unattempted={unattempted_count}")

    # ── 4. DUPLICATE RESULT GUARD ─────────────────────────────
    existing_result = ExamResult.query.filter_by(exam_session_id=session_id).first()
    if existing_result:
        print(f"Duplicate guard triggered: result {existing_result.id} already exists")
        return jsonify({
            'success':    True,
            'result_id':  existing_result.id,
            'allow_view': getattr(exam, 'allow_student_view_result', True)
        })

    # ── 5. CREATE EXAMRESULT ──────────────────────────────────
    total_marks = exam.total_marks or 0
    pass_marks  = exam.pass_marks  or 0

    if total_marks > 0:
        percentage = round((total_marks_obtained / total_marks) * 100, 2)
        is_passed  = total_marks_obtained >= pass_marks
    else:
        percentage = 0.0
        is_passed  = False

    print(f"Creating result: {total_marks_obtained}/{total_marks} = {percentage}%  passed={is_passed}")

    result = ExamResult(
        exam_id         = exam.id,
        student_id      = student_id,
        exam_session_id = session_id,
        total_marks     = total_marks,
        marks_obtained  = total_marks_obtained,
        percentage      = percentage,
        pass_marks      = pass_marks,
        is_passed       = is_passed,
        submitted_at    = datetime.utcnow()
    )
    if hasattr(result, 'calculate_result'):
        result.calculate_result()

    db.session.add(result)
    db.session.commit()

    print(f"✓ Result created id={result.id}")
    print('='*50)

    return jsonify({
        'success':       True,
        'result_id':     result.id,
        'percentage':    percentage,
        'marks_obtained': total_marks_obtained,
        'total_marks':   total_marks,
        'allow_view':    getattr(exam, 'allow_student_view_result', True)
    })


# ==================== PROCTORING ====================

@student_bp.route('/api/exam/<int:exam_id>/mark-review', methods=['POST'])
@student_required
def mark_for_review(exam_id):
    data        = request.get_json()
    question_id = data.get('question_id')
    marked      = data.get('marked')
    exam_session_id = flask_session.get(f'exam_{exam_id}_session_id')
    if not exam_session_id:
        return jsonify({'success': False, 'message': 'Invalid session'}), 400
    try:
        sa = StudentAnswer.query.filter_by(
            exam_session_id=exam_session_id,
            question_id=question_id,
            student_id=current_user.id
        ).first()
        if not sa:
            sa = StudentAnswer(exam_session_id=exam_session_id,
                               question_id=question_id,
                               student_id=current_user.id)
            db.session.add(sa)
        sa.marked_for_review = marked
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': str(e)}), 500


@student_bp.route('/api/exam/<int:exam_id>/proctoring-event', methods=['POST'])
@login_required
@student_required
def proctoring_event(exam_id):
    try:
        data = request.get_json()
        if not data:
            return jsonify({'success': False, 'message': 'No data provided'}), 400

        event_type = data.get('event_type')
        event_data = data.get('event_data', {})
        if not event_type:
            return jsonify({'success': False, 'message': 'Event type is required'}), 400

        exam_session_id = flask_session.get(f'exam_{exam_id}_session_id')
        if not exam_session_id:
            exam_session = ExamSession.query.filter_by(
                exam_id=exam_id, student_id=current_user.id, status='in_progress'
            ).order_by(ExamSession.start_time.desc()).first()
            if not exam_session:
                return jsonify({'success': False, 'message': 'No active exam session found'}), 400
            exam_session_id = exam_session.id

        exam_session = ExamSession.query.get(exam_session_id)
        if not exam_session:
            return jsonify({'success': False, 'message': 'Exam session not found'}), 404
        if exam_session.student_id != current_user.id:
            return jsonify({'success': False, 'message': 'Unauthorized'}), 403

        if event_type == 'tab_switch':
            exam_session.tab_switches = (exam_session.tab_switches or 0) + 1
        elif event_type == 'copy_attempt':
            exam_session.copy_attempts = (exam_session.copy_attempts or 0) + 1
        elif event_type == 'paste_attempt':
            exam_session.paste_attempts = (exam_session.paste_attempts or 0) + 1
        elif event_type in ['face_not_visible', 'multiple_faces', 'camera_access_denied']:
            if hasattr(exam_session, 'face_violations'):
                exam_session.face_violations = (exam_session.face_violations or 0) + 1
        elif event_type == 'fullscreen_exit':
            if hasattr(exam_session, 'fullscreen_exits'):
                exam_session.fullscreen_exits = (exam_session.fullscreen_exits or 0) + 1

        severity     = determine_violation_severity(event_type, event_data)
        details_json = json.dumps(event_data)

        log_entry = ProctoringLog(
            exam_session_id=exam_session_id,
            event_type=event_type,
            timestamp=datetime.utcnow()
        )
        if hasattr(ProctoringLog, 'exam_id'):        log_entry.exam_id        = exam_id
        if hasattr(ProctoringLog, 'student_id'):     log_entry.student_id     = current_user.id
        if hasattr(ProctoringLog, 'violation_type'): log_entry.violation_type = event_type if is_violation(event_type) else None
        if hasattr(ProctoringLog, 'severity'):       log_entry.severity       = severity
        if hasattr(ProctoringLog, 'details'):        log_entry.details        = details_json

        db.session.add(log_entry)
        exam_session.last_activity = datetime.utcnow()
        db.session.commit()

        return jsonify({
            'success':         True,
            'message':         'Event logged successfully',
            'violation_count': get_total_violations(exam_session)
        }), 200

    except Exception as e:
        db.session.rollback()
        print(f"Error logging proctoring event: {str(e)}")
        import traceback; traceback.print_exc()
        return jsonify({'success': False, 'message': str(e)}), 500


def determine_violation_severity(event_type, event_data):
    high   = ['multiple_faces', 'camera_access_denied', 'excessive_violations', 'dev_tools_attempt']
    medium = ['face_not_visible', 'tab_switch', 'fullscreen_exit']
    return 'high' if event_type in high else 'medium' if event_type in medium else 'low'


def is_violation(event_type):
    non_violations = ['exam_started', 'exam_submitted', 'question_answered', 'session_initialized']
    return event_type not in non_violations


def get_total_violations(exam_session):
    total = 0
    for attr in ('tab_switches', 'copy_attempts', 'paste_attempts', 'face_violations', 'fullscreen_exits'):
        if hasattr(exam_session, attr):
            total += getattr(exam_session, attr) or 0
    return total


@student_bp.route('/api/exam/<int:exam_id>/proctoring-status', methods=['GET'])
@login_required
@student_required
def proctoring_status(exam_id):
    try:
        exam_session_id = flask_session.get(f'exam_{exam_id}_session_id')
        if not exam_session_id:
            return jsonify({'success': False, 'message': 'No active session'}), 400
        exam_session = ExamSession.query.get(exam_session_id)
        if not exam_session or exam_session.student_id != current_user.id:
            return jsonify({'success': False, 'message': 'Invalid session'}), 403
        violations = {
            attr: getattr(exam_session, attr) or 0
            for attr in ('tab_switches', 'copy_attempts', 'paste_attempts',
                         'face_violations', 'fullscreen_exits')
            if hasattr(exam_session, attr)
        }
        return jsonify({'success': True, 'violations': violations,
                        'total_violations': get_total_violations(exam_session)}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500


# ==================== RESULTS ====================

@student_bp.route('/results', methods=['GET'])
@student_required
def my_results():
    page    = request.args.get('page', 1, type=int)
    sort_by = request.args.get('sort', 'submitted_at', type=str)
    query   = ExamResult.query.filter_by(student_id=current_user.id)
    if sort_by == 'submitted_at':
        query = query.order_by(ExamResult.submitted_at.desc())
    elif sort_by == 'percentage':
        query = query.order_by(ExamResult.percentage.desc())
    elif sort_by == 'title':
        query = query.join(Exam).order_by(Exam.title)
    results = query.paginate(page=page, per_page=20)
    return render_template('student/my_results.html', results=results, sort_by=sort_by)


@student_bp.route('/result/<int:result_id>')
@student_required
def view_result(result_id):
    try:
        result = ExamResult.query.get_or_404(result_id)
        if result.student_id != current_user.id:
            flash('You do not have permission to view this result.', 'danger')
            return redirect(url_for('student.dashboard'))

        if not getattr(result.exam, 'allow_student_view_result', True):
            flash('Results for this exam are not yet available. Please check back later.', 'warning')
            return redirect(url_for('student.dashboard'))

        from models.user import User
        student_user    = User.query.get(result.student_id)
        student_profile = Student.query.filter_by(user_id=result.student_id).first()
        answers         = StudentAnswer.query.filter_by(exam_session_id=result.exam_session_id).all()
        all_questions   = Question.query.filter_by(exam_id=result.exam_id).all()
        total_questions = len(all_questions)
        answered_count  = len(answers)
        unattempted_count = total_questions - answered_count
        correct_count   = sum(1 for a in answers if a.is_correct is True)
        incorrect_count = sum(1 for a in answers if a.is_correct is False)
        exam_session    = ExamSession.query.get(result.exam_session_id)

        return render_template('student/result_view.html',
                               result=result,
                               student_user=student_user,
                               student_profile=student_profile,
                               student=student_profile,
                               answers=answers,
                               all_questions=all_questions,
                               total_questions=total_questions,
                               answered_count=answered_count,
                               correct_count=correct_count,
                               incorrect_count=incorrect_count,
                               unattempted_count=unattempted_count,
                               exam_session=exam_session)
    except Exception as e:
        print(f"ERROR in view_result: {str(e)}")
        import traceback; traceback.print_exc()
        flash(f'Error loading result: {str(e)}', 'danger')
        return redirect(url_for('student.dashboard'))


# ==================== CLASS RANKING ====================

@student_bp.route('/class-ranking')
@student_required
def class_ranking():
    try:
        student = Student.query.filter_by(user_id=current_user.id).first_or_404()
        student_class = None
        rankings = []
        your_rank = None
        total_students = 0
        your_average = 0

        if student.class_id:
            student_class   = Class.query.get(student.class_id)
            class_students  = Student.query.filter_by(class_id=student.class_id).all()
            total_students  = len(class_students)
            ranking_data    = []

            for s in class_students:
                user    = s.user
                results = ExamResult.query.filter_by(student_id=user.id).all()
                if results:
                    total_m   = sum(r.marks_obtained or 0 for r in results)
                    total_p   = sum(r.total_marks    or 0 for r in results)
                    avg_pct   = (total_m / total_p * 100) if total_p > 0 else 0
                    exam_count = len(results)
                else:
                    total_m = avg_pct = exam_count = 0

                ranking_data.append({
                    'student_id':        s.id,
                    'user_id':           user.id,
                    'first_name':        user.first_name,
                    'last_name':         user.last_name,
                    'admission_number':  s.admission_number,
                    'average_percentage': avg_pct,
                    'total_marks':       total_m,
                    'exam_count':        exam_count
                })
                if user.id == current_user.id:
                    your_average = avg_pct

            rankings = sorted(ranking_data, key=lambda x: x['average_percentage'], reverse=True)
            for idx, rd in enumerate(rankings, 1):
                if rd['user_id'] == current_user.id:
                    your_rank = idx
                    break

        return render_template('student/class_ranking.html',
                               student_class=student_class,
                               rankings=rankings,
                               your_rank=your_rank,
                               total_students=total_students,
                               your_average=your_average)
    except Exception as e:
        print(f"ERROR in class_ranking: {str(e)}")
        import traceback; traceback.print_exc()
        flash('Error loading class ranking.', 'danger')
        return redirect(url_for('student.dashboard'))


# ==================== API ENDPOINTS ====================

@student_bp.route('/api/exam/<int:exam_id>/time-remaining', methods=['GET'])
@student_required
def time_remaining(exam_id):
    exam            = Exam.query.get_or_404(exam_id)
    exam_session_id = flask_session.get(f'exam_{exam_id}_session_id')
    if not exam_session_id:
        return jsonify({'error': 'Invalid session'}), 400
    exam_session = ExamSession.query.get_or_404(exam_session_id)
    if exam_session.end_time:
        remaining = 0
    else:
        elapsed   = (datetime.utcnow() - exam_session.start_time).total_seconds()
        remaining = max(0, exam.duration_minutes * 60 - elapsed)
    return jsonify({'remaining': int(remaining)})


@student_bp.route('/api/exam/<int:exam_id>/questions', methods=['GET'])
@student_required
def get_questions(exam_id):
    exam      = Exam.query.get_or_404(exam_id)
    questions = Question.query.filter_by(exam_id=exam_id).order_by(Question.order).all()
    return jsonify({
        'questions': [{
            'id':      q.id,
            'text':    q.question_text,
            'type':    q.question_type,
            'marks':   q.marks,
            'options': [{'id': o.id, 'label': o.option_label, 'text': o.option_text}
                        for o in q.options]
        } for q in questions]
    })