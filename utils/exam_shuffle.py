"""
utils/exam_shuffle.py

Single source of truth for exam question/option randomization.

Design (unchanged from the working approach, now consolidated in one place):
  1. When a student first opens an exam (take_exam), and the exam has
     randomization enabled, generate a shuffled question order and a
     shuffled option order ONCE, and persist both to the ExamSession
     (question_order / option_order columns, JSON-encoded).
  2. Every subsequent read (page reload, AJAX save, review screen, admin
     grading view) reads back through get_ordered_questions() /
     get_ordered_options(), which use the persisted order if present and
     fall back to the exam's natural Question.order / option_label order
     otherwise.
  3. New questions/options added to the exam AFTER a student's snapshot
     was taken are appended at the end automatically ("extras" logic) —
     they're never silently dropped.

Why this lives in its own module instead of routes/student.py or
routes/admin.py: it was previously split across both files, requiring
routes/student.py to import from routes/admin.py. That's a fragile,
one-directional coupling between two blueprints that have no other
reason to depend on each other. Centralizing it here means both
blueprints import from a shared, neutral location, and the shuffle logic
can be unit-tested in isolation without spinning up either blueprint.
"""

import json
import random


def generate_shuffle_for_session(exam, all_questions):
    """
    Build a fresh randomized question_order / option_order pair for a new
    exam session. Does NOT touch the database — caller is responsible for
    assigning the results to exam_session.question_order /
    exam_session.option_order and committing.

    Args:
        exam: Exam model instance (reads shuffle_questions / shuffle_options
              / randomize_per_student flags from it).
        all_questions: list of Question objects for this exam, in their
              natural Question.order.

    Returns:
        (question_order_json, option_order_json) — both JSON strings ready
        to store directly on an ExamSession row. If exam.randomize_per_student
        is False, returns (None, None) and the caller should leave the
        session's order columns unset, so get_ordered_questions/
        get_ordered_options fall back to natural order on every read.
    """
    if not exam.randomize_per_student:
        return None, None

    ordered_questions = list(all_questions)
    if exam.shuffle_questions:
        random.shuffle(ordered_questions)

    option_order_map = {}
    if exam.shuffle_options:
        for q in ordered_questions:
            # Only MCQ / true-false have selectable options; theory
            # questions have none and are skipped automatically since
            # q.options will be empty for them.
            if q.question_type in ('mcq', 'true_false') and q.options:
                opt_ids = [o.id for o in q.options]
                random.shuffle(opt_ids)
                option_order_map[str(q.id)] = opt_ids

    question_order_json = json.dumps([q.id for q in ordered_questions])
    option_order_json   = json.dumps(option_order_map)
    return question_order_json, option_order_json


def ensure_shuffle_persisted(db, exam, exam_session, all_questions):
    """
    Idempotent entry point for take_exam(): generates and persists the
    shuffle ONLY if it hasn't been generated yet for this session. Safe to
    call on every request — it's a no-op once exam_session.question_order
    is set, which is what keeps question/option order stable across page
    reloads instead of re-shuffling on every GET/POST.

    Args:
        db: the SQLAlchemy db instance (for db.session.commit()).
        exam: Exam model instance.
        exam_session: ExamSession model instance (mutated in place).
        all_questions: list of Question objects for this exam.
    """
    if exam_session.question_order:
        return  # already generated for this session — do nothing

    question_order_json, option_order_json = generate_shuffle_for_session(exam, all_questions)
    if question_order_json is None:
        return  # randomize_per_student is off — leave order columns null

    exam_session.question_order = question_order_json
    exam_session.option_order   = option_order_json
    db.session.commit()


def get_ordered_questions(Question, exam_id, exam_session=None):
    """
    Return Question objects in the order the student actually saw them.

    If exam_session has a persisted question_order, use that order, and
    append any questions not in the snapshot (e.g. added to the exam after
    the student's session started) at the end in natural order — they are
    never dropped.

    Otherwise (no session, or randomization was off) falls back to natural
    Question.order / Question.id ordering.

    Args:
        Question: the Question model class (passed in to avoid a model
                  import here, keeping this module free of app-specific
                  imports beyond json/random).
        exam_id: int.
        exam_session: ExamSession instance or None.
    """
    base_qs = {q.id: q for q in Question.query.filter_by(exam_id=exam_id).all()}

    if exam_session and getattr(exam_session, 'question_order', None):
        try:
            ordered_ids = json.loads(exam_session.question_order)
            ordered = [base_qs[qid] for qid in ordered_ids if qid in base_qs]
            listed = set(ordered_ids)
            extras = sorted(
                [q for q in base_qs.values() if q.id not in listed],
                key=lambda q: (q.order or 0, q.id)
            )
            return ordered + extras
        except (json.JSONDecodeError, KeyError, TypeError):
            pass  # malformed snapshot — fall through to natural order below

    return sorted(base_qs.values(), key=lambda q: (q.order or 0, q.id))


def get_ordered_options(question, exam_session=None):
    """
    Return QuestionOption objects in the order the student actually saw
    them for a given question.

    If exam_session has a persisted option_order entry for this question,
    use that order, appending any options not in the snapshot (e.g. an
    option added to the question after the student's session started) at
    the end — never dropped.

    Otherwise falls back to sorting by option_label (A, B, C, D).
    """
    options = list(question.options)

    if exam_session and getattr(exam_session, 'option_order', None):
        try:
            option_order_map = json.loads(exam_session.option_order)
            ordered_ids = option_order_map.get(str(question.id))
            if ordered_ids:
                opt_by_id = {o.id: o for o in options}
                ordered = [opt_by_id[oid] for oid in ordered_ids if oid in opt_by_id]
                listed = set(ordered_ids)
                extras = [o for o in options if o.id not in listed]
                return ordered + extras
        except (json.JSONDecodeError, KeyError, TypeError):
            pass  # malformed snapshot — fall through to label-sort below

    return sorted(options, key=lambda o: o.option_label or '')


def build_ordered_options_map(questions, exam_session=None):
    """
    Convenience helper: builds {question.id: [ordered options]} for a list
    of questions in one call, so routes don't need to loop manually.
    """
    return {q.id: get_ordered_options(q, exam_session) for q in questions}
