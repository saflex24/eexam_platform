# seed_data.py - correct imports for your project structure

import sys
import os
from datetime import datetime, timedelta
from werkzeug.security import generate_password_hash

# Ensure project root is in Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Flask app and DB
from app import app, db

# Models
from models.user import User, Role
from models.class_model import Class
from models.student_class import StudentClass      # if used
from models.teacher import Teacher                  # if used
from models.exam import Exam, ExamResult, ExamSession, Question, QuestionOption, StudentAnswer
def clear_database():
    """Clear all existing data"""
    print("🗑️  Clearing existing data...")
    
    with app.app_context():
        # Delete in correct order to respect foreign keys
        StudentAnswer.query.delete()
        Result.query.delete()
        ExamSession.query.delete()
        QuestionOption.query.delete()
        Question.query.delete()
        Exam.query.delete()
        Subject.query.delete()
        Class.query.delete()
        User.query.delete()
        Role.query.delete()
        
        db.session.commit()
    
    print("✅ Database cleared!")


def create_roles():
    """Create user roles"""
    print("\n👥 Creating roles...")
    
    roles_data = [
        {'name': 'Admin', 'description': 'System Administrator'},
        {'name': 'Teacher', 'description': 'Teacher/Instructor'},
        {'name': 'Student', 'description': 'Student'}
    ]
    
    roles = {}
    for role_data in roles_data:
        role = Role(
            name=role_data['name'],
            description=role_data['description']
        )
        db.session.add(role)
        roles[role_data['name']] = role
        print(f"  ✓ {role_data['name']}")
    
    db.session.commit()
    return roles


def create_users(roles):
    """Create admin, teachers, and students"""
    print("\n👤 Creating users...")
    
    # Admin
    admin = User(
        username='admin',
        email='admin@exam.com',
        full_name='System Administrator',
        password_hash=generate_password_hash('admin123'),
        role=roles['Admin'],
        is_active=True
    )
    db.session.add(admin)
    print(f"  ✓ Admin: {admin.username} (password: admin123)")
    
    # Teachers
    teachers_data = [
        {
            'username': 'teacher1',
            'email': 'teacher1@exam.com',
            'full_name': 'Dr. Sarah Johnson',
            'password': 'teacher123',
            'specialization': 'Mathematics & Physics'
        },
        {
            'username': 'teacher2',
            'email': 'teacher2@exam.com',
            'full_name': 'Prof. Michael Chen',
            'password': 'teacher123',
            'specialization': 'Chemistry & Biology'
        },
        {
            'username': 'teacher3',
            'email': 'teacher3@exam.com',
            'full_name': 'Mrs. Emily Williams',
            'password': 'teacher123',
            'specialization': 'English & Literature'
        },
        {
            'username': 'teacher4',
            'email': 'teacher4@exam.com',
            'full_name': 'Mr. David Brown',
            'password': 'teacher123',
            'specialization': 'Computer Science'
        }
    ]
    
    teachers = []
    for t_data in teachers_data:
        teacher = User(
            username=t_data['username'],
            email=t_data['email'],
            full_name=t_data['full_name'],
            password_hash=generate_password_hash(t_data['password']),
            role=roles['Teacher'],
            is_active=True
        )
        db.session.add(teacher)
        teachers.append(teacher)
        print(f"  ✓ Teacher: {teacher.username} - {teacher.full_name}")
    
    # Students
    students_data = [
        # Class 10A Students
        {'username': 'student1', 'email': 'student1@exam.com', 'full_name': 'Alice Anderson', 'admission': 'ADM001', 'class': '10A'},
        {'username': 'student2', 'email': 'student2@exam.com', 'full_name': 'Bob Baker', 'admission': 'ADM002', 'class': '10A'},
        {'username': 'student3', 'email': 'student3@exam.com', 'full_name': 'Charlie Cooper', 'admission': 'ADM003', 'class': '10A'},
        {'username': 'student4', 'email': 'student4@exam.com', 'full_name': 'Diana Davis', 'admission': 'ADM004', 'class': '10A'},
        {'username': 'student5', 'email': 'student5@exam.com', 'full_name': 'Emma Evans', 'admission': 'ADM005', 'class': '10A'},
        
        # Class 10B Students
        {'username': 'student6', 'email': 'student6@exam.com', 'full_name': 'Frank Foster', 'admission': 'ADM006', 'class': '10B'},
        {'username': 'student7', 'email': 'student7@exam.com', 'full_name': 'Grace Garcia', 'admission': 'ADM007', 'class': '10B'},
        {'username': 'student8', 'email': 'student8@exam.com', 'full_name': 'Henry Harris', 'admission': 'ADM008', 'class': '10B'},
        {'username': 'student9', 'email': 'student9@exam.com', 'full_name': 'Ivy Ibrahim', 'admission': 'ADM009', 'class': '10B'},
        {'username': 'student10', 'email': 'student10@exam.com', 'full_name': 'Jack Johnson', 'admission': 'ADM010', 'class': '10B'},
        
        # Class 11A Students
        {'username': 'student11', 'email': 'student11@exam.com', 'full_name': 'Kate King', 'admission': 'ADM011', 'class': '11A'},
        {'username': 'student12', 'email': 'student12@exam.com', 'full_name': 'Liam Lee', 'admission': 'ADM012', 'class': '11A'},
        {'username': 'student13', 'email': 'student13@exam.com', 'full_name': 'Mia Martinez', 'admission': 'ADM013', 'class': '11A'},
        {'username': 'student14', 'email': 'student14@exam.com', 'full_name': 'Noah Nelson', 'admission': 'ADM014', 'class': '11A'},
        {'username': 'student15', 'email': 'student15@exam.com', 'full_name': 'Olivia Okafor', 'admission': 'ADM015', 'class': '11A'},
        
        # Class 12A Students
        {'username': 'student16', 'email': 'student16@exam.com', 'full_name': 'Peter Parker', 'admission': 'ADM016', 'class': '12A'},
        {'username': 'student17', 'email': 'student17@exam.com', 'full_name': 'Quinn Roberts', 'admission': 'ADM017', 'class': '12A'},
        {'username': 'student18', 'email': 'student18@exam.com', 'full_name': 'Rachel Ross', 'admission': 'ADM018', 'class': '12A'},
        {'username': 'student19', 'email': 'student19@exam.com', 'full_name': 'Sam Smith', 'admission': 'ADM019', 'class': '12A'},
        {'username': 'student20', 'email': 'student20@exam.com', 'full_name': 'Tina Taylor', 'admission': 'ADM020', 'class': '12A'},
    ]
    
    students = []
    for s_data in students_data:
        student = User(
            username=s_data['username'],
            email=s_data['email'],
            full_name=s_data['full_name'],
            password_hash=generate_password_hash('student123'),
            role=roles['Student'],
            admission_number=s_data['admission'],
            is_active=True
        )
        db.session.add(student)
        students.append(student)
        print(f"  ✓ Student: {student.username} - {student.full_name} ({s_data['class']})")
    
    db.session.commit()
    return admin, teachers, students


def create_classes():
    """Create classes"""
    print("\n🏫 Creating classes...")
    
    classes_data = [
        {'name': '10A', 'description': 'Grade 10 Section A', 'year': 2024},
        {'name': '10B', 'description': 'Grade 10 Section B', 'year': 2024},
        {'name': '11A', 'description': 'Grade 11 Section A', 'year': 2024},
        {'name': '12A', 'description': 'Grade 12 Section A', 'year': 2024},
    ]
    
    classes = {}
    for c_data in classes_data:
        class_obj = Class(
            name=c_data['name'],
            description=c_data['description'],
            year=c_data['year']
        )
        db.session.add(class_obj)
        classes[c_data['name']] = class_obj
        print(f"  ✓ {c_data['name']}")
    
    db.session.commit()
    return classes


def assign_students_to_classes(students, classes):
    """Assign students to their respective classes"""
    print("\n📚 Assigning students to classes...")
    
    # Get all students from database
    all_students = User.query.filter_by(role_id=3).all()  # Role ID 3 = Student
    
    for student in all_students:
        if student.admission_number:
            adm_num = int(student.admission_number.replace('ADM', ''))
            
            if adm_num <= 5:
                student.class_obj = classes['10A']
                print(f"  ✓ {student.full_name} → 10A")
            elif adm_num <= 10:
                student.class_obj = classes['10B']
                print(f"  ✓ {student.full_name} → 10B")
            elif adm_num <= 15:
                student.class_obj = classes['11A']
                print(f"  ✓ {student.full_name} → 11A")
            else:
                student.class_obj = classes['12A']
                print(f"  ✓ {student.full_name} → 12A")
    
    db.session.commit()


def create_subjects(teachers):
    """Create subjects"""
    print("\n📖 Creating subjects...")
    
    subjects_data = [
        {'name': 'Mathematics', 'code': 'MATH', 'description': 'General Mathematics', 'teacher': teachers[0]},
        {'name': 'Physics', 'code': 'PHY', 'description': 'General Physics', 'teacher': teachers[0]},
        {'name': 'Chemistry', 'code': 'CHEM', 'description': 'General Chemistry', 'teacher': teachers[1]},
        {'name': 'Biology', 'code': 'BIO', 'description': 'General Biology', 'teacher': teachers[1]},
        {'name': 'English', 'code': 'ENG', 'description': 'English Language', 'teacher': teachers[2]},
        {'name': 'Literature', 'code': 'LIT', 'description': 'Literature in English', 'teacher': teachers[2]},
        {'name': 'Computer Science', 'code': 'CS', 'description': 'Introduction to Computer Science', 'teacher': teachers[3]},
    ]
    
    subjects = []
    for s_data in subjects_data:
        subject = Subject(
            name=s_data['name'],
            code=s_data['code'],
            description=s_data['description'],
            teacher=s_data['teacher']
        )
        db.session.add(subject)
        subjects.append(subject)
        print(f"  ✓ {subject.code} - {subject.name} (Teacher: {subject.teacher.full_name})")
    
    db.session.commit()
    return subjects


def create_exams(subjects, classes, teachers):
    """Create sample exams"""
    print("\n📝 Creating exams...")
    
    # Get subjects
    math_subject = Subject.query.filter_by(code='MATH').first()
    physics_subject = Subject.query.filter_by(code='PHY').first()
    chemistry_subject = Subject.query.filter_by(code='CHEM').first()
    english_subject = Subject.query.filter_by(code='ENG').first()
    cs_subject = Subject.query.filter_by(code='CS').first()
    
    exams_data = [
        {
            'title': 'Mathematics Mid-Term Exam',
            'description': 'Grade 10 Mathematics Mid-Term Assessment',
            'subject': math_subject,
            'class': classes['10A'],
            'teacher': teachers[0],
            'duration': 90,
            'total_marks': 100,
            'passing_marks': 40,
            'scheduled_at': datetime.now() + timedelta(days=7),
            'published': True,
            'enable_proctoring': True,
            'randomize_questions': False,
            'show_results_immediately': False
        },
        {
            'title': 'Physics Quiz - Motion',
            'description': 'Quick assessment on Laws of Motion',
            'subject': physics_subject,
            'class': classes['10A'],
            'teacher': teachers[0],
            'duration': 30,
            'total_marks': 50,
            'passing_marks': 20,
            'scheduled_at': datetime.now() + timedelta(days=3),
            'published': True,
            'enable_proctoring': False,
            'randomize_questions': True,
            'show_results_immediately': True
        },
        {
            'title': 'Chemistry Final Exam',
            'description': 'Comprehensive Chemistry Final Assessment',
            'subject': chemistry_subject,
            'class': classes['11A'],
            'teacher': teachers[1],
            'duration': 120,
            'total_marks': 100,
            'passing_marks': 50,
            'scheduled_at': datetime.now() + timedelta(days=14),
            'published': True,
            'enable_proctoring': True,
            'randomize_questions': False,
            'show_results_immediately': False
        },
        {
            'title': 'English Comprehension Test',
            'description': 'Reading comprehension and grammar assessment',
            'subject': english_subject,
            'class': classes['12A'],
            'teacher': teachers[2],
            'duration': 60,
            'total_marks': 75,
            'passing_marks': 30,
            'scheduled_at': datetime.now() + timedelta(days=5),
            'published': True,
            'enable_proctoring': False,
            'randomize_questions': False,
            'show_results_immediately': True
        },
        {
            'title': 'Introduction to Python',
            'description': 'Python Programming Basics Test',
            'subject': cs_subject,
            'class': classes['12A'],
            'teacher': teachers[3],
            'duration': 45,
            'total_marks': 50,
            'passing_marks': 25,
            'scheduled_at': datetime.now() + timedelta(days=2),
            'published': True,
            'enable_proctoring': True,
            'randomize_questions': True,
            'show_results_immediately': True
        }
    ]
    
    exams = []
    for e_data in exams_data:
        exam = Exam(
            title=e_data['title'],
            description=e_data['description'],
            subject=e_data['subject'],
            class_obj=e_data['class'],
            teacher=e_data['teacher'],
            duration_minutes=e_data['duration'],
            total_marks=e_data['total_marks'],
            passing_marks=e_data['passing_marks'],
            scheduled_at=e_data['scheduled_at'],
            is_published=e_data['published'],
            enable_proctoring=e_data['enable_proctoring'],
            randomize_questions=e_data['randomize_questions'],
            show_results_immediately=e_data['show_results_immediately']
        )
        db.session.add(exam)
        exams.append(exam)
        print(f"  ✓ {exam.title} ({exam.subject.name})")
    
    db.session.commit()
    return exams


def create_questions(exams):
    """Create questions for exams"""
    print("\n❓ Creating questions...")
    
    # Mathematics questions
    math_exam = Exam.query.filter_by(title='Mathematics Mid-Term Exam').first()
    if math_exam:
        math_questions = [
            {
                'text': 'What is the value of x in the equation: 2x + 5 = 15?',
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': 'x = 5', 'is_correct': True},
                    {'label': 'B', 'text': 'x = 10', 'is_correct': False},
                    {'label': 'C', 'text': 'x = 7.5', 'is_correct': False},
                    {'label': 'D', 'text': 'x = 3', 'is_correct': False}
                ]
            },
            {
                'text': 'Simplify: (3x² + 2x - 5) + (x² - 3x + 7)',
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': '4x² - x + 2', 'is_correct': True},
                    {'label': 'B', 'text': '4x² + 5x + 2', 'is_correct': False},
                    {'label': 'C', 'text': '2x² - x + 12', 'is_correct': False},
                    {'label': 'D', 'text': '4x² - 5x - 2', 'is_correct': False}
                ]
            },
            {
                'text': 'What is the area of a circle with radius 7 cm? (Use π = 22/7)',
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': '154 cm²', 'is_correct': True},
                    {'label': 'B', 'text': '144 cm²', 'is_correct': False},
                    {'label': 'C', 'text': '308 cm²', 'is_correct': False},
                    {'label': 'D', 'text': '44 cm²', 'is_correct': False}
                ]
            },
            {
                'text': 'The sum of two consecutive integers is 47. What are the integers?',
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': '23 and 24', 'is_correct': True},
                    {'label': 'B', 'text': '22 and 25', 'is_correct': False},
                    {'label': 'C', 'text': '24 and 25', 'is_correct': False},
                    {'label': 'D', 'text': '21 and 26', 'is_correct': False}
                ]
            },
            {
                'text': 'Explain the Pythagorean theorem and provide an example of its application.',
                'type': 'theory',
                'marks': 10,
                'options': []
            }
        ]
        
        for q_data in math_questions:
            question = Question(
                exam=math_exam,
                question_text=q_data['text'],
                question_type=q_data['type'],
                marks=q_data['marks']
            )
            db.session.add(question)
            db.session.flush()
            
            for opt_data in q_data['options']:
                option = QuestionOption(
                    question=question,
                    option_label=opt_data['label'],
                    option_text=opt_data['text'],
                    is_correct=opt_data['is_correct']
                )
                db.session.add(option)
            
            print(f"  ✓ Question: {q_data['text'][:50]}...")
    
    # Physics questions
    physics_exam = Exam.query.filter_by(title='Physics Quiz - Motion').first()
    if physics_exam:
        physics_questions = [
            {
                'text': "Newton's First Law states that:",
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': 'An object at rest stays at rest unless acted upon by an external force', 'is_correct': True},
                    {'label': 'B', 'text': 'Force equals mass times acceleration', 'is_correct': False},
                    {'label': 'C', 'text': 'Every action has an equal and opposite reaction', 'is_correct': False},
                    {'label': 'D', 'text': 'Energy cannot be created or destroyed', 'is_correct': False}
                ]
            },
            {
                'text': 'If a car travels 120 km in 2 hours, what is its average speed?',
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': '60 km/h', 'is_correct': True},
                    {'label': 'B', 'text': '120 km/h', 'is_correct': False},
                    {'label': 'C', 'text': '240 km/h', 'is_correct': False},
                    {'label': 'D', 'text': '30 km/h', 'is_correct': False}
                ]
            },
            {
                'text': 'Acceleration is defined as:',
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': 'Rate of change of velocity', 'is_correct': True},
                    {'label': 'B', 'text': 'Rate of change of position', 'is_correct': False},
                    {'label': 'C', 'text': 'Total distance traveled', 'is_correct': False},
                    {'label': 'D', 'text': 'Force applied to an object', 'is_correct': False}
                ]
            }
        ]
        
        for q_data in physics_questions:
            question = Question(
                exam=physics_exam,
                question_text=q_data['text'],
                question_type=q_data['type'],
                marks=q_data['marks']
            )
            db.session.add(question)
            db.session.flush()
            
            for opt_data in q_data['options']:
                option = QuestionOption(
                    question=question,
                    option_label=opt_data['label'],
                    option_text=opt_data['text'],
                    is_correct=opt_data['is_correct']
                )
                db.session.add(option)
            
            print(f"  ✓ Question: {q_data['text'][:50]}...")
    
    # Chemistry questions
    chem_exam = Exam.query.filter_by(title='Chemistry Final Exam').first()
    if chem_exam:
        chem_questions = [
            {
                'text': 'What is the chemical formula for water?',
                'type': 'mcq',
                'marks': 2,
                'options': [
                    {'label': 'A', 'text': 'H₂O', 'is_correct': True},
                    {'label': 'B', 'text': 'CO₂', 'is_correct': False},
                    {'label': 'C', 'text': 'O₂', 'is_correct': False},
                    {'label': 'D', 'text': 'H₂O₂', 'is_correct': False}
                ]
            },
            {
                'text': 'The pH of pure water at 25°C is:',
                'type': 'mcq',
                'marks': 3,
                'options': [
                    {'label': 'A', 'text': '7', 'is_correct': True},
                    {'label': 'B', 'text': '0', 'is_correct': False},
                    {'label': 'C', 'text': '14', 'is_correct': False},
                    {'label': 'D', 'text': '1', 'is_correct': False}
                ]
            },
            {
                'text': 'An acid turns blue litmus paper:',
                'type': 'mcq',
                'marks': 2,
                'options': [
                    {'label': 'A', 'text': 'Red', 'is_correct': True},
                    {'label': 'B', 'text': 'Blue', 'is_correct': False},
                    {'label': 'C', 'text': 'Green', 'is_correct': False},
                    {'label': 'D', 'text': 'Yellow', 'is_correct': False}
                ]
            },
            {
                'text': 'Explain the process of photosynthesis and write the balanced chemical equation.',
                'type': 'theory',
                'marks': 15,
                'options': []
            }
        ]
        
        for q_data in chem_questions:
            question = Question(
                exam=chem_exam,
                question_text=q_data['text'],
                question_type=q_data['type'],
                marks=q_data['marks']
            )
            db.session.add(question)
            db.session.flush()
            
            for opt_data in q_data['options']:
                option = QuestionOption(
                    question=question,
                    option_label=opt_data['label'],
                    option_text=opt_data['text'],
                    is_correct=opt_data['is_correct']
                )
                db.session.add(option)
            
            print(f"  ✓ Question: {q_data['text'][:50]}...")
    
    # Computer Science questions
    cs_exam = Exam.query.filter_by(title='Introduction to Python').first()
    if cs_exam:
        cs_questions = [
            {
                'text': 'Which keyword is used to define a function in Python?',
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': 'def', 'is_correct': True},
                    {'label': 'B', 'text': 'function', 'is_correct': False},
                    {'label': 'C', 'text': 'define', 'is_correct': False},
                    {'label': 'D', 'text': 'func', 'is_correct': False}
                ]
            },
            {
                'text': 'What will be the output of: print(type([1, 2, 3]))?',
                'type': 'mcq',
                'marks': 5,
                'options': [
                    {'label': 'A', 'text': "<class 'list'>", 'is_correct': True},
                    {'label': 'B', 'text': "<class 'tuple'>", 'is_correct': False},
                    {'label': 'C', 'text': "<class 'dict'>", 'is_correct': False},
                    {'label': 'D', 'text': "<class 'array'>", 'is_correct': False}
                ]
            },
            {
                'text': 'Python is case-sensitive',
                'type': 'true_false',
                'marks': 5,
                'options': [
                    {'label': 'True', 'text': 'True', 'is_correct': True},
                    {'label': 'False', 'text': 'False', 'is_correct': False}
                ]
            }
        ]
        
        for q_data in cs_questions:
            question = Question(
                exam=cs_exam,
                question_text=q_data['text'],
                question_type=q_data['type'],
                marks=q_data['marks']
            )
            db.session.add(question)
            db.session.flush()
            
            for opt_data in q_data['options']:
                option = QuestionOption(
                    question=question,
                    option_label=opt_data['label'],
                    option_text=opt_data['text'],
                    is_correct=opt_data['is_correct']
                )
                db.session.add(option)
            
            print(f"  ✓ Question: {q_data['text'][:50]}...")
    
    db.session.commit()


def update_exam_totals():
    """Update total questions and marks for all exams"""
    print("\n🔄 Updating exam totals...")
    
    exams = Exam.query.all()
    for exam in exams:
        exam.total_questions = len(exam.questions)
        total_marks = sum(q.marks for q in exam.questions)
        exam.total_marks = total_marks
        print(f"  ✓ {exam.title}: {exam.total_questions} questions, {exam.total_marks} marks")
    
    db.session.commit()


def create_sample_sessions_and_results():
    """Create some completed exam sessions with results"""
    print("\n📊 Creating sample exam sessions and results...")
    
    # Get a physics exam (already completed)
    physics_exam = Exam.query.filter_by(title='Physics Quiz - Motion').first()
    if not physics_exam:
        return
    
    # Get some students from class 10A
    students = User.query.join(Class).filter(
        Class.name == '10A',
        User.role_id == 3
    ).limit(5).all()
    
    for student in students:
        # Create exam session
        session = ExamSession(
            exam=physics_exam,
            student=student,
            status='completed',
            start_time=datetime.now() - timedelta(hours=2),
            end_time=datetime.now() - timedelta(hours=1, minutes=30),
            time_spent=1800  # 30 minutes
        )
        db.session.add(session)
        db.session.flush()
        
        # Create answers and calculate score
        total_score = 0
        max_score = 0
        
        for question in physics_exam.questions:
            max_score += question.marks
            
            # Get correct option
            correct_option = QuestionOption.query.filter_by(
                question_id=question.id,
                is_correct=True
            ).first()
            
            # Randomly assign correct or incorrect answers
            import random
            is_correct = random.choice([True, True, False])  # 66% chance of correct
            
            selected_option = correct_option if is_correct else QuestionOption.query.filter_by(
                question_id=question.id,
                is_correct=False
            ).first()
            
            if selected_option:
                answer = StudentAnswer(
                    session=session,
                    question=question,
                    selected_option=selected_option,
                    is_correct=is_correct,
                    marks_obtained=question.marks if is_correct else 0
                )
                db.session.add(answer)
                
                if is_correct:
                    total_score += question.marks
        
        # Create result
        percentage = (total_score / max_score * 100) if max_score > 0 else 0
        status = 'pass' if total_score >= physics_exam.passing_marks else 'fail'
        
        result = Result(
            exam=physics_exam,
            student=student,
            session=session,
            total_marks=max_score,
            marks_obtained=total_score,
            percentage=percentage,
            status=status
        )
        db.session.add(result)
        
        print(f"  ✓ {student.full_name}: {total_score}/{max_score} ({percentage:.1f}%) - {status.upper()}")
    
    db.session.commit()


def print_summary():
    """Print database summary"""
    print("\n" + "="*60)
    print("📈 DATABASE SUMMARY")
    print("="*60)
    
    roles = Role.query.count()
    users = User.query.count()
    admins = User.query.filter_by(role_id=1).count()
    teachers = User.query.filter_by(role_id=2).count()
    students = User.query.filter_by(role_id=3).count()
    classes = Class.query.count()
    subjects = Subject.query.count()
    exams = Exam.query.count()
    questions = Question.query.count()
    sessions = ExamSession.query.count()
    results = Result.query.count()
    
    print(f"\n👥 Users:")
    print(f"  • Total: {users}")
    print(f"  • Admins: {admins}")
    print(f"  • Teachers: {teachers}")
    print(f"  • Students: {students}")
    
    print(f"\n🏫 Academic:")
    print(f"  • Classes: {classes}")
    print(f"  • Subjects: {subjects}")
    print(f"  • Exams: {exams}")
    print(f"  • Questions: {questions}")
    
    print(f"\n📊 Activity:")
    print(f"  • Exam Sessions: {sessions}")
    print(f"  • Results: {results}")
    
    print("\n" + "="*60)
    print("🔑 LOGIN CREDENTIALS")
    print("="*60)
    print("\nAdmin:")
    print("  Username: admin")
    print("  Password: admin123")
    print("\nTeachers:")
    print("  Username: teacher1, teacher2, teacher3, teacher4")
    print("  Password: teacher123")
    print("\nStudents:")
    print("  Username: student1 through student20")
    print("  Password: student123")
    print("\n" + "="*60)


def main():
    """Main seeding function"""
    print("="*60)
    print("🌱 E-EXAM PLATFORM SEED DATA")
    print("="*60)
    
    with app.app_context():
        try:
            # Clear existing data
            response = input("\n⚠️  This will delete all existing data. Continue? (yes/no): ")
            if response.lower() != 'yes':
                print("❌ Seeding cancelled.")
                return
            
            clear_database()
            
            # Create data
            roles = create_roles()
            admin, teachers, students = create_users(roles)
            classes = create_classes()
            assign_students_to_classes(students, classes)
            subjects = create_subjects(teachers)
            exams = create_exams(subjects, classes, teachers)
            create_questions(exams)
            update_exam_totals()
            create_sample_sessions_and_results()
            
            # Print summary
            print_summary()
            
            print("\n✅ Seeding completed successfully!")
            print("🚀 You can now run the application: python app.py")
            
        except Exception as e:
            print(f"\n❌ Error during seeding: {str(e)}")
            import traceback
            traceback.print_exc()
            db.session.rollback()


if __name__ == '__main__':
    main()
