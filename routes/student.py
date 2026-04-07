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
    
    # Total exams taken
    total_exams_taken = ExamResult.query.filter_by(
        student_id=current_user.id
    ).count()
    
    # All results for this student
    results = ExamResult.query.filter_by(
        student_id=current_user.id
    ).all()
    
    # Average score
    if results:
        avg_score = round(sum(r.percentage for r in results) / len(results), 1)
    else:
        avg_score = 0.0
    
    # Class rank - safely handle missing student_profile
    class_rank = None
    class_students_count = 0
    
    # Fix: student_profile can be a list or None, handle both cases
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
    
    # Available exams (published and within date range)
    available_exams = Exam.query.filter(
        Exam.published == True,
        Exam.start_date <= now,
        Exam.end_date >= now
    ).all()
    
    # Remove exams already taken
    taken_exam_ids = [r.exam_id for r in results]
    available_exams = [e for e in available_exams if e.id not in taken_exam_ids]
    
    # Recent results (last 5)
    recent_results = ExamResult.query.filter_by(
        student_id=current_user.id
    ).order_by(ExamResult.submitted_at.desc()).limit(5).all()
    
    # Upcoming exams (not yet started)
    upcoming_exams = Exam.query.filter(
        Exam.published == True,
        Exam.start_date > now
    ).all()
    
    # Completed exams
    completed_exams = results
    
    # Past exams (ended)
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
    """Display passcode entry page before exam"""
    exam_session = ExamSession.query.get_or_404(session_id)
    
    # Verify this session belongs to current student
    if exam_session.student_id != current_user.id:
        flash('You do not have permission to access this exam.', 'danger')
        return redirect(url_for('student.dashboard'))
    
    # Check if already completed
    if exam_session.status == 'completed':
        flash('You have already completed this exam.', 'warning')
        return redirect(url_for('student.exam_result', session_id=session_id))
    
    # Check if passcode already verified in this session
    if flask_session.get(f'passcode_verified_{session_id}'):
        return redirect(url_for('student.take_exam', session_id=session_id))
    
    exam = exam_session.exam
    
    return render_template('student/exam_passcode.html', 
                         exam=exam, 
                         session=exam_session)


@student_bp.route('/exam/<int:session_id>/verify-passcode', methods=['POST', 'POST'])
@login_required
def verify_passcode(session_id):
    """Verify exam passcode and grant access"""
    exam_session = ExamSession.query.get_or_404(session_id)
    
    # Verify this session belongs to current student
    if exam_session.student_id != current_user.id:
        flash('You do not have permission to access this exam.', 'danger')
        return redirect(url_for('student.dashboard'))
    
    exam = exam_session.exam
    passcode_entered = request.form.get('passcode', '').strip()
    
    # Check if exam has a passcode set
    if not exam.passcode:
        # No passcode required, grant access
        flask_session[f'passcode_verified_{session_id}'] = True
        return redirect(url_for('student.take_exam', session_id=session_id))
    
    # Verify passcode
    if passcode_entered == exam.passcode:
        # Correct passcode
        flask_session[f'passcode_verified_{session_id}'] = True
        flash('Passcode verified! You may now begin the exam.', 'success')
        return redirect(url_for('student.take_exam', session_id=session_id))
    else:
        # Incorrect passcode
        flash('Incorrect passcode. Please try again or contact your instructor.', 'danger')
        return redirect(url_for('student.exam_passcode', session_id=session_id))

# ==================== EXAM TAKING ====================

@student_bp.route('/exam/<int:exam_id>/start', methods=['GET', 'POST'])
@login_required
@student_required
def start_exam(exam_id):
    """Start taking an exam"""
    try:
        print(f"\n=== START EXAM ===")
        print(f"Student ID (current_user): {current_user.id}")
        print(f"Exam ID: {exam_id}")
        
        # Get the exam
        exam = Exam.query.get_or_404(exam_id)
        print(f"Exam found: {exam.title}")
        
        # Check if exam is published
        if not exam.published:
            flash('This exam is not yet available.', 'warning')
            return redirect(url_for('student.dashboard'))
        
        # Check exam time window
        now = datetime.utcnow()
        if exam.start_date and now < exam.start_date:
            flash('This exam has not started yet.', 'warning')
            return redirect(url_for('student.dashboard'))
        
        if exam.end_date and now > exam.end_date:
            flash('This exam has already ended.', 'warning')
            return redirect(url_for('student.dashboard'))
        
        # Get student profile
        student = Student.query.filter_by(user_id=current_user.id).first()
        if not student:
            flash('Student profile not found.', 'danger')
            return redirect(url_for('student.dashboard'))
        
        print(f"Student profile found: {student.id} (user_id: {student.user_id})")
        
        # Check for existing result
        existing_result = ExamResult.query.filter_by(
            exam_id=exam_id,
            student_id=current_user.id
        ).first()
        
        if existing_result:
            flash('You have already taken this exam.', 'warning')
            return redirect(url_for('student.view_result', result_id=existing_result.id))
        
        # Get questions for this exam
        questions = Question.query.filter_by(exam_id=exam_id).order_by(Question.order).all()
        if not questions:
            flash('This exam has no questions yet.', 'danger')
            return redirect(url_for('student.dashboard'))
        
        print(f"Questions found: {len(questions)}")
        
        if request.method == 'POST':
            # Generate session code and token
            session_code = f"SESSION-{exam_id}-{student.user_id}-{int(datetime.utcnow().timestamp())}"
            session_token = ''.join(random.choices(string.ascii_letters + string.digits, k=32))
            
            # Create exam session
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
            
            print(f"Exam session created: {exam_session.id} (token: {exam_session.session_token})")
            print(f"DEBUG: Exam passcode: '{exam.passcode}'")
            
            # Store session ID in Flask session
            flask_session[f'exam_{exam_id}_session_id'] = exam_session.id
            
            # Check if exam requires passcode
            if exam.passcode:
                print(f"DEBUG: Redirecting to passcode page")
                return redirect(url_for('student.exam_passcode', session_id=exam_session.id))
            else:
                print(f"DEBUG: No passcode, going to exam")
                flask_session[f'passcode_verified_{exam_session.id}'] = True
                return redirect(url_for('student.take_exam', session_id=exam_session.id))
        
        # GET request - show exam instructions/start page
        return render_template('student/start_exam.html', exam=exam, questions=questions)
        
    except Exception as e:
        print(f"\n=== ERROR IN START_EXAM ===")
        print(f"Error: {str(e)}")
        import traceback
        traceback.print_exc()
        flash(f'Error starting exam: {str(e)}', 'danger')
        return redirect(url_for('student.dashboard'))

@student_bp.route('/exam/<int:session_id>/take', methods=['GET', 'POST'])
@login_required
def take_exam(session_id):
    """Take exam page - requires passcode verification"""
    try:
        print(f"\n=== TAKE EXAM ===")
        print(f"Session ID: {session_id}")
        
        exam_session = ExamSession.query.get_or_404(session_id)
        
        # Verify this session belongs to current student
        if exam_session.student_id != current_user.id:
            flash('You do not have permission to access this exam.', 'danger')
            return redirect(url_for('student.dashboard'))
        
        # CHECK PASSCODE VERIFICATION - Redirect to passcode page if not verified
        if not flask_session.get(f'passcode_verified_{session_id}'):
            return redirect(url_for('student.exam_passcode', session_id=session_id))
        
        # Check if already completed
        if exam_session.status == 'completed' or exam_session.status == 'submitted':
            flash('You have already completed this exam.', 'warning')
            return redirect(url_for('student.dashboard'))
        
        exam = exam_session.exam
        questions = Question.query.filter_by(exam_id=exam.id).order_by(Question.order).all()
        
        # Update session to 'in_progress' if not already
        if exam_session.status == 'pending' or exam_session.status == 'started':
            exam_session.status = 'in_progress'
            if not exam_session.start_time:
                exam_session.start_time = datetime.utcnow()
            exam_session.last_activity = datetime.utcnow()
            db.session.commit()
        
        # Check time remaining
        if exam_session.start_time:
            elapsed_time = (datetime.utcnow() - exam_session.start_time).total_seconds() / 60
            if elapsed_time > exam.duration_minutes:
                flash('Time has expired for this exam.', 'warning')
                return redirect(url_for('student.submit_exam', session_id=session_id))
        
        if request.method == 'POST':
            # Handle exam submission
            try:
                print(f"\n=== PROCESSING ANSWERS ===")
                answers_saved = 0
                
                # Process answers
                for question in questions:
                    answer_key = f'question_{question.id}'
                    
                    if question.question_type in ['mcq', 'true_false']:
                        # Get selected option ID
                        selected_option_id = request.form.get(answer_key, type=int)
                        
                        print(f"Question {question.id}: selected_option_id = {selected_option_id}")
                        
                        if selected_option_id:
                            # Check if answer already exists
                            existing_answer = StudentAnswer.query.filter_by(
                                exam_session_id=session_id,
                                question_id=question.id,
                                student_id=current_user.id
                            ).first()
                            
                            if existing_answer:
                                existing_answer.selected_option_id = selected_option_id
                                existing_answer.updated_at = datetime.utcnow()
                                print(f"Updated existing answer for question {question.id}")
                            else:
                                answer = StudentAnswer(
                                    exam_session_id=session_id,
                                    question_id=question.id,
                                    student_id=current_user.id,
                                    selected_option_id=selected_option_id
                                )
                                db.session.add(answer)
                                print(f"Created new answer for question {question.id}")
                            
                            answers_saved += 1
                    
                    elif question.question_type == 'theory':
                        # Get text answer
                        answer_text = request.form.get(answer_key, '').strip()
                        
                        print(f"Question {question.id} (theory): answer_text = {answer_text[:50] if answer_text else 'None'}...")
                        
                        if answer_text:
                            existing_answer = StudentAnswer.query.filter_by(
                                exam_session_id=session_id,
                                question_id=question.id,
                                student_id=current_user.id
                            ).first()
                            
                            if existing_answer:
                                existing_answer.theory_answer = answer_text
                                existing_answer.updated_at = datetime.utcnow()
                                print(f"Updated existing theory answer for question {question.id}")
                            else:
                                answer = StudentAnswer(
                                    exam_session_id=session_id,
                                    question_id=question.id,
                                    student_id=current_user.id,
                                    theory_answer=answer_text
                                )
                                db.session.add(answer)
                                print(f"Created new theory answer for question {question.id}")
                            
                            answers_saved += 1
                
                # COMMIT THE ANSWERS BEFORE MARKING AS COMPLETED
                db.session.commit()
                print(f"Committed {answers_saved} answers to database")
                
                # Mark exam as completed
                exam_session.status = 'completed'
                exam_session.end_time = datetime.utcnow()
                
                # Calculate time taken
                if exam_session.start_time:
                    time_taken = (exam_session.end_time - exam_session.start_time).total_seconds() / 60
                    exam_session.time_taken = int(time_taken)
                
                db.session.commit()
                print(f"Exam session marked as completed")
                
                # Clear passcode verification after submission
                flask_session.pop(f'passcode_verified_{session_id}', None)
                
                # Calculate results and redirect
                return redirect(url_for('student.submit_exam', session_id=session_id))
                
            except Exception as e:
                db.session.rollback()
                flash(f'Error submitting exam: {str(e)}', 'danger')
                print(f"ERROR saving answers: {str(e)}")
                import traceback
                traceback.print_exc()
        
        # Update last activity
        exam_session.last_activity = datetime.utcnow()
        db.session.commit()
        
        return render_template('student/take_exam.html',
                             exam=exam,
                             session=exam_session,
                             questions=questions)
                             
    except Exception as e:
        print(f"ERROR in take_exam: {str(e)}")
        import traceback
        traceback.print_exc()
        flash(f'Error loading exam: {str(e)}', 'danger')
        return redirect(url_for('student.dashboard'))


@student_bp.route('/exam/session/<int:session_id>/submit', methods=['GET', 'POST'])
@login_required
@student_required
def submit_exam(session_id):
    """Submit exam answers and calculate results"""
    try:
        print(f"\n=== SUBMITTING EXAM ===")
        print(f"Session ID: {session_id}")
        print(f"Request Method: {request.method}")
        db.session.commit()
        print(f" Exam submitted successfully. Score: {total_marks_obtained}/{total_marks} ({percentage:.2f}%)")
        print(f" Correct: {correct_count}, Incorrect: {incorrect_count}, Unattempted: {unattempted_count}")
        # CHECK IF RESULTS ARE VIEWABLE
        if exam.allow_student_view_result:
            flash(f'Exam submitted successfully! Score: {percentage:.2f}%', 'success')
            return redirect(url_for('student.view_result', result_id=result.id))
        else:
            flash('Exam submitted successfully! Results will be published by your teacher soon.', 'info')
            return redirect(url_for('student.dashboard'))
        
    except Exception as e:
        # ... error handling ...
        
        # Get session
        exam_session = ExamSession.query.get_or_404(session_id)
        exam = exam_session.exam
        
        # Verify ownership
        if exam_session.student_id != current_user.id:
            flash('Invalid exam session.', 'danger')
            return redirect(url_for('student.dashboard'))
        
        # Check if already submitted
        existing_result = ExamResult.query.filter_by(
            exam_session_id=session_id
        ).first()
        
        if existing_result:
            flash('This exam has already been submitted.', 'info')
            return redirect(url_for('student.view_result', result_id=existing_result.id))
        
        # Get all questions
        questions = Question.query.filter_by(exam_id=exam.id).all()
        
        # IF POST REQUEST - SAVE ANSWERS FIRST
        if request.method == 'POST':
            print(f"\n=== SAVING ANSWERS FROM FORM ===")
            answers_saved = 0
            
            for question in questions:
                answer_key = f'question_{question.id}'
                
                if question.question_type in ['mcq', 'true_false']:
                    selected_option_id = request.form.get(answer_key, type=int)
                    print(f"Question {question.id}: selected_option_id = {selected_option_id}")
                    
                    if selected_option_id:
                        existing_answer = StudentAnswer.query.filter_by(
                            exam_session_id=session_id,
                            question_id=question.id,
                            student_id=current_user.id
                        ).first()
                        
                        if existing_answer:
                            existing_answer.selected_option_id = selected_option_id
                            existing_answer.updated_at = datetime.utcnow()
                            print(f"Updated existing answer for question {question.id}")
                        else:
                            answer = StudentAnswer(
                                exam_session_id=session_id,
                                question_id=question.id,
                                student_id=current_user.id,
                                selected_option_id=selected_option_id
                            )
                            db.session.add(answer)
                            print(f"Created new answer for question {question.id}")
                        answers_saved += 1
                
                elif question.question_type == 'theory':
                    answer_text = request.form.get(answer_key, '').strip()
                    print(f"Question {question.id} (theory): {answer_text[:50] if answer_text else 'None'}...")
                    
                    if answer_text:
                        existing_answer = StudentAnswer.query.filter_by(
                            exam_session_id=session_id,
                            question_id=question.id,
                            student_id=current_user.id
                        ).first()
                        
                        if existing_answer:
                            existing_answer.theory_answer = answer_text
                            existing_answer.updated_at = datetime.utcnow()
                            print(f"Updated existing theory answer for question {question.id}")
                        else:
                            answer = StudentAnswer(
                                exam_session_id=session_id,
                                question_id=question.id,
                                student_id=current_user.id,
                                theory_answer=answer_text
                            )
                            db.session.add(answer)
                            print(f"Created new theory answer for question {question.id}")
                        answers_saved += 1
            
            # Commit answers before processing
            db.session.commit()
            print(f" Saved {answers_saved} answers to database")
        
        # Process answers and calculate score
        total_marks_obtained = 0
        correct_count = 0
        incorrect_count = 0
        
        for question in questions:
            answer = StudentAnswer.query.filter_by(
                exam_session_id=session_id,
                question_id=question.id
            ).first()
            
            if answer and question.question_type in ['mcq', 'true_false']:
                selected_option = QuestionOption.query.get(answer.selected_option_id)
                
                if selected_option:
                    answer.is_correct = selected_option.is_correct
                    answer.marks_obtained = question.marks if selected_option.is_correct else 0
                    
                    if selected_option.is_correct:
                        total_marks_obtained += question.marks
                        correct_count += 1
                    else:
                        incorrect_count += 1
        
        # Calculate unanswered
        answered_questions = StudentAnswer.query.filter_by(
            exam_session_id=session_id
        ).count()
        unattempted = len(questions) - answered_questions
        
        print(f" Answers in DB: {answered_questions}, Unattempted: {unattempted}")
        
        # Safe calculation with None checks
        total_marks = exam.total_marks or 0
        pass_marks = exam.pass_marks or 0
        
        # Calculate percentage safely
        if total_marks > 0:
            percentage = (total_marks_obtained / total_marks) * 100
            is_passed = total_marks_obtained >= pass_marks
        else:
            percentage = 0
            is_passed = False
        
        # Create exam result with all required fields
        result = ExamResult(
            exam_id=exam.id,
            student_id=current_user.id,
            exam_session_id=session_id,
            total_marks=total_marks,
            marks_obtained=total_marks_obtained,
            percentage=round(percentage, 2),
            pass_marks=pass_marks,
            is_passed=is_passed,
            submitted_at=datetime.utcnow()
        )
        
        # Calculate grade using the model method
        result.calculate_result()
        
        db.session.add(result)
        
        # Update session status
        exam_session.status = 'submitted'
        if not exam_session.end_time:
            exam_session.end_time = datetime.utcnow()
        
        db.session.commit()
        
        print(f"Exam submitted successfully. Score: {total_marks_obtained}/{total_marks} ({percentage:.2f}%)")
        print(f" Correct: {correct_count}, Incorrect: {incorrect_count}, Unattempted: {unattempted}")
        
        flash(f'Exam submitted successfully! Score: {percentage:.2f}%', 'success')
        return redirect(url_for('student.view_result', result_id=result.id))
        
    except Exception as e:
        db.session.rollback()
        print(f" ERROR submitting exam: {str(e)}")
        import traceback
        traceback.print_exc()
        flash(f'Error submitting exam: {str(e)}', 'danger')
        return redirect(url_for('student.dashboard'))

        
  # ── ADD THESE TWO ROUTES TO routes/student.py ────────────────────────────────
# 1. A simple ping to confirm the URL is reachable at all
# 2. The fixed auto-submit route with maximum debug output
# ─────────────────────────────────────────────────────────────────────────────

# TEST ROUTE — visit /student/api/test in the browser to confirm routing works
@student_bp.route('/api/test', methods=['GET', 'POST'])
def api_test():
    """Quick connectivity test - open /student/api/test in browser"""
    return jsonify({
        'ok': True,
        'method': request.method,
        'message': 'student blueprint is reachable'
    })


# AUTO-SUBMIT ROUTE
@student_bp.route('/api/exam/session/<int:session_id>/auto-submit', methods=['POST', 'GET'])
def auto_submit_exam(session_id):
    """
    Auto-submit when student leaves exam page.
    No @login_required — beacon requests may not carry session cookies.
    Auth done via student_id in the POST body.
    """
    print(f"\n{'='*50}")
    print(f"AUTO-SUBMIT HIT  session_id={session_id}")
    print(f"Method : {request.method}")
    print(f"Headers: {dict(request.headers)}")
    print(f"Content-Type: {request.content_type}")

    # ── Parse body ────────────────────────────────────────────
    data = {}
    raw  = None
    try:
        raw  = request.get_data(as_text=True)
        print(f"Raw body: {raw[:300]}")
        import json as _json
        data = _json.loads(raw) if raw else {}
    except Exception as parse_err:
        print(f"Body parse error: {parse_err}")

    student_id = data.get('student_id')
    reason     = data.get('reason', 'unknown')
    print(f"student_id={student_id}  reason={reason}")

    # ── Auth fallback: try flask-login current_user ───────────
    if not student_id:
        try:
            from flask_login import current_user as cu
            if cu and cu.is_authenticated:
                student_id = cu.id
                print(f"student_id resolved from flask-login: {student_id}")
        except Exception as auth_err:
            print(f"flask-login fallback error: {auth_err}")

    if not student_id:
        print("FAIL: no student_id")
        return jsonify({'success': False, 'message': 'No student_id provided'}), 400

    # ── Fetch session ─────────────────────────────────────────
    exam_session = ExamSession.query.get(session_id)
    if not exam_session:
        print(f"FAIL: ExamSession {session_id} not found")
        return jsonify({'success': False, 'message': f'Session {session_id} not found'}), 404

    print(f"ExamSession found: status={exam_session.status}  student_id={exam_session.student_id}")

    # Ownership check
    if exam_session.student_id != int(student_id):
        print(f"FAIL: ownership mismatch session.student_id={exam_session.student_id} vs {student_id}")
        return jsonify({'success': False, 'message': 'Unauthorised'}), 403

    # ── Already submitted? ────────────────────────────────────
    if exam_session.status in ('submitted', 'completed'):
        existing = ExamResult.query.filter_by(exam_session_id=session_id).first()
        print(f"Already submitted. existing_result={existing.id if existing else None}")
        return jsonify({
            'success'   : True,
            'already_done': True,
            'result_id' : existing.id if existing else None,
            'allow_view': getattr(exam_session.exam, 'allow_student_view_result', True)
        })

    exam = exam_session.exam
    print(f"Exam: {exam.title}  total_marks={exam.total_marks}")

    # ── Mark session submitted ────────────────────────────────
    exam_session.status   = 'submitted'
    exam_session.end_time = datetime.utcnow()
    if exam_session.start_time:
        elapsed = (exam_session.end_time - exam_session.start_time).total_seconds() / 60
        if not getattr(exam_session, 'time_taken', None):
            exam_session.time_taken = int(elapsed)

    # ── Score answers ─────────────────────────────────────────
    questions            = Question.query.filter_by(exam_id=exam.id).all()
    total_marks_obtained = 0
    correct_count        = 0
    incorrect_count      = 0

    print(f"Questions: {len(questions)}")

    for question in questions:
        answer = StudentAnswer.query.filter_by(
            exam_session_id=session_id,
            question_id=question.id
        ).first()

        if not answer:
            continue

        if question.question_type in ('mcq', 'true_false'):
            if answer.selected_option_id:
                option = QuestionOption.query.get(answer.selected_option_id)
                if option:
                    answer.is_correct     = option.is_correct
                    answer.marks_obtained = question.marks if option.is_correct else 0
                    if option.is_correct:
                        total_marks_obtained += question.marks
                        correct_count        += 1
                    else:
                        incorrect_count      += 1
        elif question.question_type == 'theory':
            raw_ans = answer.theory_answer
            if raw_ans and str(raw_ans).strip().lower() != 'none':
                answer.marks_obtained = 0  # teacher grades manually

    db.session.commit()
    print(f"Scoring done: {total_marks_obtained} marks, {correct_count} correct")

    # ── Guard duplicate result ────────────────────────────────
    existing_result = ExamResult.query.filter_by(exam_session_id=session_id).first()
    if existing_result:
        print(f"Duplicate guard: result {existing_result.id} already exists")
        return jsonify({
            'success'   : True,
            'result_id' : existing_result.id,
            'allow_view': getattr(exam, 'allow_student_view_result', True)
        })

    # ── Create ExamResult ─────────────────────────────────────
    total_marks = exam.total_marks or 0
    pass_marks  = exam.pass_marks  or 0
    percentage  = round((total_marks_obtained / total_marks) * 100, 2) if total_marks > 0 else 0
    is_passed   = total_marks_obtained >= pass_marks

    result = ExamResult(
        exam_id         = exam.id,
        student_id      = int(student_id),
        exam_session_id = session_id,
        total_marks     = total_marks,
        marks_obtained  = total_marks_obtained,
        percentage      = percentage,
        pass_marks      = pass_marks,
        is_passed       = is_passed,
        submitted_at    = datetime.utcnow()
    )
    result.calculate_result()
    db.session.add(result)
    db.session.commit()

    print(f"Result created: id={result.id}  {total_marks_obtained}/{total_marks} ({percentage}%)")
    print('='*50)

    return jsonify({
        'success'   : True,
        'result_id' : result.id,
        'percentage': percentage,
        'allow_view': getattr(exam, 'allow_student_view_result', True)
    })
# ==================== PROCTORING ====================

@student_bp.route('/api/exam/<int:exam_id>/mark-review', methods=['POST'])
@student_required
def mark_for_review(exam_id):
    """Mark question for review"""
    data = request.get_json()
    question_id = data.get('question_id')
    marked = data.get('marked')
    
    exam_session_id = flask_session.get(f'exam_{exam_id}_session_id')
    
    if not exam_session_id:
        return jsonify({'success': False, 'message': 'Invalid session'}), 400
    
    try:
        student_answer = StudentAnswer.query.filter_by(
            exam_session_id=exam_session_id,
            question_id=question_id,
            student_id=current_user.id
        ).first()
        
        if not student_answer:
            student_answer = StudentAnswer(
                exam_session_id=exam_session_id,
                question_id=question_id,
                student_id=current_user.id
            )
            db.session.add(student_answer)
        
        student_answer.marked_for_review = marked
        db.session.commit()
        
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': str(e)}), 500


# Updated Student Routes - Proctoring Section
# Add this to routes/student.py




# ==================== PROCTORING ROUTES ====================

# Updated Student Routes - Proctoring Section (CORRECTED)
# Replace the proctoring_event function in routes/student.py

@student_bp.route('/api/exam/<int:exam_id>/proctoring-event', methods=['POST'])
@login_required
@student_required
def proctoring_event(exam_id):
    """
    Log proctoring event/violation
    Handles: face detection, tab switching, copy/paste, fullscreen, etc.
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({
                'success': False, 
                'message': 'No data provided'
            }), 400
        
        event_type = data.get('event_type')
        event_data = data.get('event_data', {})
        
        if not event_type:
            return jsonify({
                'success': False,
                'message': 'Event type is required'
            }), 400
        
        # Get exam session ID from flask session
        exam_session_id = flask_session.get(f'exam_{exam_id}_session_id')
        
        if not exam_session_id:
            # Try to get the most recent active session for this student and exam
            exam_session = ExamSession.query.filter_by(
                exam_id=exam_id,
                student_id=current_user.id,
                status='in_progress'
            ).order_by(ExamSession.start_time.desc()).first()
            
            if not exam_session:
                return jsonify({
                    'success': False,
                    'message': 'No active exam session found'
                }), 400
            
            exam_session_id = exam_session.id
        
        # Get the exam session
        exam_session = ExamSession.query.get(exam_session_id)
        
        if not exam_session:
            return jsonify({
                'success': False,
                'message': 'Exam session not found'
            }), 404
        
        # Verify the session belongs to the current student
        if exam_session.student_id != current_user.id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized access to exam session'
            }), 403
        
        # Update violation counters in exam session
        if event_type == 'tab_switch':
            exam_session.tab_switches = (exam_session.tab_switches or 0) + 1
        elif event_type == 'copy_attempt':
            exam_session.copy_attempts = (exam_session.copy_attempts or 0) + 1
        elif event_type == 'paste_attempt':
            exam_session.paste_attempts = (exam_session.paste_attempts or 0) + 1
        elif event_type in ['face_not_visible', 'multiple_faces', 'camera_access_denied']:
            # Track face-related violations (if column exists)
            if hasattr(exam_session, 'face_violations'):
                exam_session.face_violations = (exam_session.face_violations or 0) + 1
        elif event_type == 'fullscreen_exit':
            # Track fullscreen exits (if column exists)
            if hasattr(exam_session, 'fullscreen_exits'):
                exam_session.fullscreen_exits = (exam_session.fullscreen_exits or 0) + 1
        
        # Determine violation severity
        severity = determine_violation_severity(event_type, event_data)
        
        # Convert event_data to JSON string for details field
        import json
        details_json = json.dumps(event_data)
        
        # Create log entry - ONLY use fields that exist in your model
        log_entry = ProctoringLog(
            exam_session_id=exam_session_id,
            event_type=event_type,
            timestamp=datetime.utcnow()
        )
        
        # Add optional fields if they exist in your model
        if hasattr(ProctoringLog, 'exam_id'):
            log_entry.exam_id = exam_id
        
        if hasattr(ProctoringLog, 'student_id'):
            log_entry.student_id = current_user.id
        
        if hasattr(ProctoringLog, 'violation_type'):
            log_entry.violation_type = event_type if is_violation(event_type) else None
        
        if hasattr(ProctoringLog, 'severity'):
            log_entry.severity = severity
        
        if hasattr(ProctoringLog, 'details'):
            log_entry.details = details_json
        
        db.session.add(log_entry)
        
        # Update session last activity
        exam_session.last_activity = datetime.utcnow()
        
        # Commit all changes
        db.session.commit()
        
        # Log to console for debugging
        print(f" Proctoring event logged: {event_type} for student {current_user.id}")
        
        return jsonify({
            'success': True,
            'message': 'Event logged successfully',
            'violation_count': get_total_violations(exam_session)
        }), 200
        
    except Exception as e:
        db.session.rollback()
        print(f" Error logging proctoring event: {str(e)}")
        import traceback
        traceback.print_exc()
        
        return jsonify({
            'success': False,
            'message': f'Error logging event: {str(e)}'
        }), 500


def determine_violation_severity(event_type, event_data):
    """
    Determine the severity of a violation
    Returns: 'low', 'medium', or 'high'
    """
    high_severity = [
        'multiple_faces',
        'camera_access_denied',
        'excessive_violations',
        'dev_tools_attempt'
    ]
    
    medium_severity = [
        'face_not_visible',
        'tab_switch',
        'fullscreen_exit'
    ]
    
    if event_type in high_severity:
        return 'high'
    elif event_type in medium_severity:
        return 'medium'
    else:
        return 'low'


def is_violation(event_type):
    """
    Check if an event type is considered a violation
    """
    non_violations = [
        'exam_started',
        'exam_submitted',
        'question_answered',
        'session_initialized'
    ]
    
    return event_type not in non_violations


def get_total_violations(exam_session):
    """
    Get total violation count for a session
    """
    total = 0
    
    if hasattr(exam_session, 'tab_switches') and exam_session.tab_switches:
        total += exam_session.tab_switches
    
    if hasattr(exam_session, 'copy_attempts') and exam_session.copy_attempts:
        total += exam_session.copy_attempts
    
    if hasattr(exam_session, 'paste_attempts') and exam_session.paste_attempts:
        total += exam_session.paste_attempts
    
    if hasattr(exam_session, 'face_violations') and exam_session.face_violations:
        total += exam_session.face_violations
    
    if hasattr(exam_session, 'fullscreen_exits') and exam_session.fullscreen_exits:
        total += exam_session.fullscreen_exits
    
    return total


@student_bp.route('/api/exam/<int:exam_id>/proctoring-status', methods=['GET'])
@login_required
@student_required
def proctoring_status(exam_id):
    """
    Get current proctoring status and violation counts
    """
    try:
        exam_session_id = flask_session.get(f'exam_{exam_id}_session_id')
        
        if not exam_session_id:
            return jsonify({
                'success': False,
                'message': 'No active session'
            }), 400
        
        exam_session = ExamSession.query.get(exam_session_id)
        
        if not exam_session or exam_session.student_id != current_user.id:
            return jsonify({
                'success': False,
                'message': 'Invalid session'
            }), 403
        
        violations = {}
        
        if hasattr(exam_session, 'tab_switches'):
            violations['tab_switches'] = exam_session.tab_switches or 0
        
        if hasattr(exam_session, 'copy_attempts'):
            violations['copy_attempts'] = exam_session.copy_attempts or 0
        
        if hasattr(exam_session, 'paste_attempts'):
            violations['paste_attempts'] = exam_session.paste_attempts or 0
        
        if hasattr(exam_session, 'face_violations'):
            violations['face_violations'] = exam_session.face_violations or 0
        
        if hasattr(exam_session, 'fullscreen_exits'):
            violations['fullscreen_exits'] = exam_session.fullscreen_exits or 0
        
        return jsonify({
            'success': True,
            'violations': violations,
            'total_violations': get_total_violations(exam_session)
        }), 200
        
    except Exception as e:
        print(f"Error getting proctoring status: {str(e)}")
        return jsonify({
            'success': False,
            'message': str(e)
        }), 500
# ==================== RESULTS ====================

@student_bp.route('/results', methods=['GET'])
@student_required
def my_results():
    """View my results"""
    page = request.args.get('page', 1, type=int)
    sort_by = request.args.get('sort', 'submitted_at', type=str)
    
    query = ExamResult.query.filter_by(student_id=current_user.id)
    
    if sort_by == 'submitted_at':
        query = query.order_by(ExamResult.submitted_at.desc())
    elif sort_by == 'percentage':
        query = query.order_by(ExamResult.percentage.desc())
    elif sort_by == 'title':
        query = query.join(Exam).order_by(Exam.title)
    
    results = query.paginate(page=page, per_page=20)
    
    return render_template('student/my_results.html',
                         results=results,
                         sort_by=sort_by)


@student_bp.route('/result/<int:result_id>')
@student_required
def view_result(result_id):
    """View result details"""
    try:
        print(f"\n=== VIEW RESULT ===")
        print(f"Result ID: {result_id}")
        
        result = ExamResult.query.get_or_404(result_id)
        print(f"Result found: Exam {result.exam.title}, Score: {result.percentage}%")
        
        # Check ownership
        if result.student_id != current_user.id:
            flash('You do not have permission to view this result.', 'danger')
            return redirect(url_for('student.dashboard'))
        
        # CHECK IF TEACHER ALLOWS STUDENTS TO VIEW RESULTS (with safe default)
        allow_view = getattr(result.exam, 'allow_student_view_result', True)
        print(f"Allow view result: {allow_view}")
        
        if not allow_view:
            flash('Results for this exam are not yet available. Please check back later or contact your teacher.', 'warning')
            return redirect(url_for('student.dashboard'))
        
        # Get student profile
        from models.user import User
        student_user = User.query.get(result.student_id)
        student_profile = Student.query.filter_by(user_id=result.student_id).first()
        
        # Get all answers for this session
        answers = StudentAnswer.query.filter_by(
            exam_session_id=result.exam_session_id
        ).all()
        
        # Get all questions for this exam
        all_questions = Question.query.filter_by(exam_id=result.exam_id).all()
        total_questions = len(all_questions)
        
        # Calculate statistics
        answered_count = len(answers)
        unattempted_count = total_questions - answered_count
        
        # Calculate correct and incorrect (only for MCQ/True-False)
        correct_count = 0
        incorrect_count = 0
        
        for answer in answers:
            if answer.is_correct == True:
                correct_count += 1
            elif answer.is_correct == False:
                incorrect_count += 1
        
        # Get exam session
        exam_session = ExamSession.query.get(result.exam_session_id)
        
        print(f"Answers found: {answered_count}")
        print(f"Correct: {correct_count}, Incorrect: {incorrect_count}, Unattempted: {unattempted_count}")
        
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
        import traceback
        traceback.print_exc()
        flash(f'Error loading result: {str(e)}', 'danger')
        return redirect(url_for('student.dashboard'))

# ==================== CLASS RANKING ====================

@student_bp.route('/class-ranking')
@student_required
def class_ranking():
    """View class ranking"""
    try:
        student = Student.query.filter_by(user_id=current_user.id).first_or_404()
        
        student_class = None
        rankings = []
        your_rank = None
        total_students = 0
        your_average = 0
        
        if student.class_id:
            # Get the class info
            student_class = Class.query.get(student.class_id)
            
            # Get all students in the same class with their results
            class_students = Student.query.filter_by(class_id=student.class_id).all()
            total_students = len(class_students)
            
            # Calculate rankings
            ranking_data = []
            for s in class_students:
                # Get user info
                user = s.user
                
                # Get all exam results for this student
                results = ExamResult.query.filter_by(student_id=user.id).all()
                
                if results:
                    total_marks = sum(r.marks_obtained or 0 for r in results)
                    total_possible = sum(r.total_marks or 0 for r in results)
                    exam_count = len(results)
                    average_percentage = (total_marks / total_possible * 100) if total_possible > 0 else 0
                else:
                    total_marks = 0
                    average_percentage = 0
                    exam_count = 0
                
                ranking_data.append({
                    'student_id': s.id,
                    'user_id': user.id,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                    'admission_number': s.admission_number,
                    'average_percentage': average_percentage,
                    'total_marks': total_marks,
                    'exam_count': exam_count
                })
                
                # Track current student's average
                if user.id == current_user.id:
                    your_average = average_percentage
            
            # Sort by average percentage (descending)
            rankings = sorted(ranking_data, key=lambda x: x['average_percentage'], reverse=True)
            
            # Find current student's rank
            for idx, rank_data in enumerate(rankings, 1):
                if rank_data['user_id'] == current_user.id:
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
        import traceback
        traceback.print_exc()
        flash('Error loading class ranking.', 'danger')
        return redirect(url_for('student.dashboard'))

# ==================== API ENDPOINTS ====================

@student_bp.route('/api/exam/<int:exam_id>/time-remaining', methods=['GET'])
@student_required
def time_remaining(exam_id):
    """Get remaining time for exam"""
    exam = Exam.query.get_or_404(exam_id)
    exam_session_id = flask_session.get(f'exam_{exam_id}_session_id')
    
    if not exam_session_id:
        return jsonify({'error': 'Invalid session'}), 400
    
    exam_session = ExamSession.query.get_or_404(exam_session_id)
    
    if exam_session.end_time:
        remaining = 0
    else:
        elapsed = (datetime.utcnow() - exam_session.start_time).total_seconds()
        total_seconds = exam.duration_minutes * 60
        remaining = max(0, total_seconds - elapsed)
    
    return jsonify({'remaining': int(remaining)})


@student_bp.route('/api/exam/<int:exam_id>/questions', methods=['GET'])
@student_required
def get_questions(exam_id):
    """Get exam questions"""
    exam = Exam.query.get_or_404(exam_id)
    questions = Question.query.filter_by(exam_id=exam_id).order_by(Question.order).all()
    
    return jsonify({
        'questions': [{
            'id': q.id,
            'text': q.question_text,
            'type': q.question_type,
            'marks': q.marks,
            'options': [{'id': o.id, 'label': o.option_label, 'text': o.option_text} 
                       for o in q.options]
        } for q in quzestions]
    })