"""
reset_data.py — Safe data reset script
Deletes ALL records EXCEPT admin user accounts and the roles table.

Usage (run from your project root):
    flask shell < reset_data.py
  OR
    python reset_data.py   (if you set up app context manually)
"""
from app import create_app

app = create_app()
ctx = app.app_context()
ctx.push()

from extensions import db
from models.user import User, Role, Student, Teacher, ClassTeacher
from models.exam import (
    Exam, Question, QuestionOption,
    StudentAnswer, ExamResult, ExamSession, ProctoringLog
)

# ── Import optional models safely ────────────────────────────────────────────
try:
    from models.class_model import (
        Class, StudentClass, AcademicTerm,
        TeacherSubjectClass, Subject, PromotionHistory
    )
    has_class_models = True
except ImportError:
    has_class_models = False

try:
    from models.student_class import StudentClassAssignment
    has_sca = True
except ImportError:
    has_sca = False

# ── Identify admin role ───────────────────────────────────────────────────────
admin_role = Role.query.filter(Role.name.ilike('admin')).first()
if not admin_role:
    print("ERROR: No 'admin' role found in the database. Aborting.")
    raise SystemExit(1)

admin_user_ids = [u.id for u in User.query.filter_by(role_id=admin_role.id).all()]
if not admin_user_ids:
    print("ERROR: No admin users found. Aborting to prevent full lockout.")
    raise SystemExit(1)

print(f"Found {len(admin_user_ids)} admin user(s) — these will be KEPT.")
print("Deleting all other data...\n")

# ── Delete in dependency order (children before parents) ─────────────────────

# 1. Proctoring logs
count = ProctoringLog.query.delete()
print(f"  Deleted {count} proctoring log(s)")

# 2. Student answers
count = StudentAnswer.query.delete()
print(f"  Deleted {count} student answer(s)")

# 3. Exam results
count = ExamResult.query.delete()
print(f"  Deleted {count} exam result(s)")

# 4. Exam sessions
count = ExamSession.query.delete()
print(f"  Deleted {count} exam session(s)")

# 5. Question options
count = QuestionOption.query.delete()
print(f"  Deleted {count} question option(s)")

# 6. Questions
count = Question.query.delete()
print(f"  Deleted {count} question(s)")

# 7. Exams
count = Exam.query.delete()
print(f"  Deleted {count} exam(s)")

# 8. Class / academic structure
if has_class_models:
    try:
        count = db.session.execute(db.text("DELETE FROM class_teacher")).rowcount
        print(f"  Deleted {count} class_teacher link(s)")
    except Exception as e:
        print(f"  Skipped class_teacher: {e}")

    try:
        count = PromotionHistory.query.delete()
        print(f"  Deleted {count} promotion history record(s)")
    except Exception:
        pass

    try:
        count = StudentClass.query.delete()
        print(f"  Deleted {count} student_class record(s)")
    except Exception:
        pass

    if has_sca:
        try:
            count = StudentClassAssignment.query.delete()
            print(f"  Deleted {count} student_class_assignment(s)")
        except Exception:
            pass

    try:
        count = TeacherSubjectClass.query.delete()
        print(f"  Deleted {count} teacher_subject_class record(s)")
    except Exception:
        pass

    try:
        count = Subject.query.delete()
        print(f"  Deleted {count} subject(s)")
    except Exception:
        pass

    try:
        count = AcademicTerm.query.delete()
        print(f"  Deleted {count} academic term(s)")
    except Exception:
        pass

    try:
        count = Class.query.delete()
        print(f"  Deleted {count} class(es)")
    except Exception:
        pass

# 9. Teacher profiles (non-admin)
non_admin_teacher_user_ids = [
    u.id for u in User.query.filter(
        ~User.id.in_(admin_user_ids)
    ).all()
]
if non_admin_teacher_user_ids:
    count = Teacher.query.filter(
        Teacher.user_id.in_(non_admin_teacher_user_ids)
    ).delete(synchronize_session=False)
    print(f"  Deleted {count} teacher profile(s)")

# 10. Student profiles (non-admin)
if non_admin_teacher_user_ids:
    count = Student.query.filter(
        Student.user_id.in_(non_admin_teacher_user_ids)
    ).delete(synchronize_session=False)
    print(f"  Deleted {count} student profile(s)")

# 11. Non-admin users
count = User.query.filter(~User.id.in_(admin_user_ids)).delete(synchronize_session=False)
print(f"  Deleted {count} non-admin user(s)")

# ── Commit ────────────────────────────────────────────────────────────────────
db.session.commit()
print("\n✅ Done. All data cleared. Admin login(s) preserved.")
print(f"   Kept admin user IDs: {admin_user_ids}")
