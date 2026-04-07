"""
E-Exam Platform - Database Schema & Seed Data Generator
This script creates all tables and populates them with sample data
"""

from app import create_app, db
from models.user import Role, User, Student, Teacher
from models.class_model import Class
from models.exam import Exam, Question, QuestionOption, ExamResult, ExamSession, ProctoringLog
from datetime import datetime, timedelta
import random

def drop_all_tables():
    """Drop all existing tables"""
    print("=" * 60)
    print("DROPPING ALL TABLES...")
    print("=" * 60)
    db.drop_all()
    print("✓ All tables dropped successfully")

def create_all_tables():
    """Create all tables from models"""
    print("\n" + "=" * 60)
    print("CREATING ALL TABLES...")
    print("=" * 60)
    db.create_all()
    print("✓ All tables created successfully")

def seed_roles():
    """Seed roles"""
    print("\n" + "=" * 60)
    print("SEEDING ROLES...")
    print("=" * 60)
    
    roles_data = [
        {
            'name': 'Admin',
            'description': 'System administrator with full access'
        },
        {
            'name': 'Teacher',
            'description': 'Can create and manage exams and questions'
        },
        {
            'name': 'Student',
            'description': 'Can take exams and view results'
        }
    ]
    
    for role_data in roles_data:
        role = Role.query.filter_by(name=role_data['name']).first()
        if not role:
            role = Role(**role_data)
            db.session.add(role)
            print(f"  → Created role: {role_data['name']}")
        else:
            print(f"  → Role already exists: {role_data['name']}")
    
    db.session.commit()
    print("✓ Roles seeded successfully")

def seed_admin_user():
    """Seed admin user"""
    print("\n" + "=" * 60)
    print("SEEDING ADMIN USER...")
    print("=" * 60)
    
    admin_role = Role.query.filter_by(name='Admin').first()
    
    admin = User.query.filter_by(username='admin').first()
    if not admin:
        admin = User(
            username='admin',
            email='admin@mawoschool.edu.ng',
            first_name='System',
            last_name='Administrator',
            gender='Other',
            role_id=admin_role.id,
            is_active=True
        )
        admin.set_password('admin123')
        db.session.add(admin)
        db.session.commit()
        print(f"  → Created admin user: admin / admin123")
    else:
        print(f"  → Admin user already exists")
    
    print("✓ Admin user seeded successfully")

def seed_classes():
    """Seed classes"""
    print("\n" + "=" * 60)
    print("SEEDING CLASSES...")
    print("=" * 60)
    
    classes_data = [
        # Primary Classes
        {'name': 'Primary 1', 'code': 'PRI1', 'section': 'A', 'academic_year': '2024/2025'},
        {'name': 'Primary 2', 'code': 'PRI2', 'section': 'A', 'academic_year': '2024/2025'},
        {'name': 'Primary 3', 'code': 'PRI3', 'section': 'A', 'academic_year': '2024/2025'},
        {'name': 'Primary 4', 'code': 'PRI4', 'section': 'A', 'academic_year': '2024/2025'},
        {'name': 'Primary 5', 'code': 'PRI5', 'section': 'A', 'academic_year': '2024/2025'},
        {'name': 'Primary 6', 'code': 'PRI6', 'section': 'A', 'academic_year': '2024/2025'},
        
        # Junior Secondary
        {'name': 'JSS 1', 'code': 'JSS1', 'section': 'A', 'academic_year': '2024/2025'},
        {'name': 'JSS 2', 'code': 'JSS2', 'section': 'A', 'academic_year': '2024/2025'},
        {'name': 'JSS 3', 'code': 'JSS3', 'section': 'A', 'academic_year': '2024/2025'},
        
        # Senior Secondary
        {'name': 'SS 1 Science', 'code': 'SS1S', 'section': 'Science', 'academic_year': '2024/2025'},
        {'name': 'SS 1 Arts', 'code': 'SS1A', 'section': 'Arts', 'academic_year': '2024/2025'},
        {'name': 'SS 2 Science', 'code': 'SS2S', 'section': 'Science', 'academic_year': '2024/2025'},
        {'name': 'SS 2 Arts', 'code': 'SS2A', 'section': 'Arts', 'academic_year': '2024/2025'},
        {'name': 'SS 3 Science', 'code': 'SS3S', 'section': 'Science', 'academic_year': '2024/2025'},
        {'name': 'SS 3 Arts', 'code': 'SS3A', 'section': 'Arts', 'academic_year': '2024/2025'},
    ]
    
    created_classes = []
    for class_data in classes_data:
        existing = Class.query.filter_by(code=class_data['code']).first()
        if not existing:
            class_obj = Class(
                name=class_data['name'],
                code=class_data['code'],
                section=class_data['section'],
                academic_year=class_data['academic_year'],
                description=f"Class {class_data['name']} for academic year {class_data['academic_year']}"
            )
            db.session.add(class_obj)
            created_classes.append(class_obj)
            print(f"  → Created class: {class_data['name']} ({class_data['code']})")
        else:
            created_classes.append(existing)
            print(f"  → Class already exists: {class_data['name']}")
    
    db.session.commit()
    print("✓ Classes seeded successfully")
    return created_classes

def seed_teachers():
    """Seed teachers"""
    print("\n" + "=" * 60)
    print("SEEDING TEACHERS...")
    print("=" * 60)
    
    teacher_role = Role.query.filter_by(name='Teacher').first()
    
    teachers_data = [
        {'first_name': 'Ibrahim', 'last_name': 'Abubakar', 'subject': 'Mathematics', 'gender': 'Male'},
        {'first_name': 'Fatima', 'last_name': 'Mohammed', 'subject': 'English Language', 'gender': 'Female'},
        {'first_name': 'Yusuf', 'last_name': 'Hassan', 'subject': 'Physics', 'gender': 'Male'},
        {'first_name': 'Zainab', 'last_name': 'Suleiman', 'subject': 'Chemistry', 'gender': 'Female'},
        {'first_name': 'Ahmed', 'last_name': 'Bello', 'subject': 'Biology', 'gender': 'Male'},
        {'first_name': 'Hauwa', 'last_name': 'Usman', 'subject': 'Economics', 'gender': 'Female'},
        {'first_name': 'Musa', 'last_name': 'Garba', 'subject': 'Government', 'gender': 'Male'},
        {'first_name': 'Aisha', 'last_name': 'Aliyu', 'subject': 'Literature', 'gender': 'Female'},
        {'first_name': 'Umar', 'last_name': 'Abdullahi', 'subject': 'Computer Science', 'gender': 'Male'},
        {'first_name': 'Halima', 'last_name': 'Ibrahim', 'subject': 'Geography', 'gender': 'Female'},
    ]
    
    created_teachers = []
    for i, teacher_data in enumerate(teachers_data, start=1):
        username = f"teacher{i}"
        existing = User.query.filter_by(username=username).first()
        
        if not existing:
            # Create user
            user = User(
                username=username,
                email=f"{teacher_data['first_name'].lower()}.{teacher_data['last_name'].lower()}@mawoschool.edu.ng",
                first_name=teacher_data['first_name'],
                last_name=teacher_data['last_name'],
                gender=teacher_data['gender'],
                role_id=teacher_role.id,
                is_active=True
            )
            user.set_password('teacher123')
            db.session.add(user)
            db.session.flush()
            
            # Create teacher profile
            teacher = Teacher(
                user_id=user.id,
                teacher_id=f'TCH{str(i).zfill(3)}',
                subject=teacher_data['subject'],
                qualification=random.choice(['B.Ed', 'M.Ed', 'B.Sc', 'M.Sc']),
                specialization=teacher_data['subject'],
                contact_number=f'+234{random.randint(8000000000, 9099999999)}',
                joining_date=datetime.now() - timedelta(days=random.randint(365, 1825))
            )
            db.session.add(teacher)
            created_teachers.append(teacher)
            print(f"  → Created teacher: {teacher_data['first_name']} {teacher_data['last_name']} ({username} / teacher123)")
        else:
            teacher = Teacher.query.filter_by(user_id=existing.id).first()
            if teacher:
                created_teachers.append(teacher)
            print(f"  → Teacher already exists: {username}")
    
    db.session.commit()
    print("✓ Teachers seeded successfully")
    return created_teachers

def seed_students(classes):
    """Seed students"""
    print("\n" + "=" * 60)
    print("SEEDING STUDENTS...")
    print("=" * 60)
    
    student_role = Role.query.filter_by(name='Student').first()
    
    first_names = [
        'Ibrahim', 'Fatima', 'Yusuf', 'Zainab', 'Ahmed', 'Hauwa', 'Musa', 'Aisha',
        'Umar', 'Halima', 'Suleiman', 'Khadija', 'Bashir', 'Amina', 'Aliyu', 'Maryam',
        'Hassan', 'Hafsat', 'Abdullahi', 'Safiyya', 'Garba', 'Salamatu', 'Bello', 'Rahma'
    ]
    
    last_names = [
        'Abubakar', 'Mohammed', 'Hassan', 'Suleiman', 'Bello', 'Usman', 'Garba', 'Aliyu',
        'Abdullahi', 'Ibrahim', 'Ahmad', 'Yusuf', 'Isa', 'Musa', 'Yakubu', 'Adamu'
    ]
    
    created_students = []
    student_count = 1
    
    for class_obj in classes:
        # Create 10-15 students per class
        num_students = random.randint(10, 15)
        
        for i in range(num_students):
            username = f"student{student_count}"
            existing = User.query.filter_by(username=username).first()
            
            if not existing:
                first_name = random.choice(first_names)
                last_name = random.choice(last_names)
                
                # Create user
                user = User(
                    username=username,
                    email=f"student{student_count}@mawoschool.edu.ng",
                    first_name=first_name,
                    last_name=last_name,
                    gender=random.choice(['Male', 'Female']),
                    role_id=student_role.id,
                    is_active=True
                )
                user.set_password('student123')
                db.session.add(user)
                db.session.flush()
                
                # Create student profile
                student = Student(
                    user_id=user.id,
                    admission_number=f'MAWO{datetime.now().year}{str(student_count).zfill(4)}',
                    roll_number=str(i + 1),
                    class_id=class_obj.id,
                    contact_number=f'+234{random.randint(8000000000, 9099999999)}',
                    date_of_birth=datetime.now() - timedelta(days=random.randint(3650, 7300)),
                    guardian_name=f"{random.choice(first_names)} {random.choice(last_names)}",
                    guardian_contact=f'+234{random.randint(8000000000, 9099999999)}'
                )
                db.session.add(student)
                created_students.append(student)
                
                if student_count % 20 == 0:
                    print(f"  → Created {student_count} students...")
                
            student_count += 1
    
    db.session.commit()
    print(f"✓ Total students seeded: {len(created_students)}")
    return created_students

def seed_exams(teachers, classes):
    """Seed exams"""
    print("\n" + "=" * 60)
    print("SEEDING EXAMS...")
    print("=" * 60)
    
    subjects = [
        'Mathematics', 'English Language', 'Physics', 'Chemistry', 'Biology',
        'Economics', 'Government', 'Literature', 'Computer Science', 'Geography'
    ]
    
    exam_titles = {
        'Mathematics': ['First Term Exam', 'Mid-Term Test', 'Final Exam'],
        'English Language': ['Grammar and Composition', 'Literature Review', 'Final Assessment'],
        'Physics': ['Mechanics Test', 'Electricity and Magnetism', 'Final Exam'],
        'Chemistry': ['Organic Chemistry Quiz', 'Periodic Table Test', 'Final Exam'],
        'Biology': ['Cell Biology Test', 'Ecology Assessment', 'Final Exam'],
        'Computer Science': ['Programming Basics', 'Database Design', 'Final Project'],
    }
    
    created_exams = []
    
    for teacher in teachers[:6]:  # Use first 6 teachers
        subject = teacher.subject
        titles = exam_titles.get(subject, ['First Term Exam', 'Mid-Term Test', 'Final Exam'])
        
        for title in titles:
            # Select appropriate classes for the exam
            if 'SS' in random.choice([c.name for c in classes]):
                exam_classes = [c for c in classes if 'SS' in c.name]
            else:
                exam_classes = [c for c in classes if 'JSS' in c.name or 'Primary' in c.name]
            
            selected_class = random.choice(exam_classes)
            
            exam = Exam(
                title=f"{subject} - {title}",
                code=Exam.generate_code(),
                description=f"{title} for {subject}",
                subject=subject,
                class_id=selected_class.id,
                created_by=teacher.user_id,
                total_questions=random.randint(20, 40),
                total_marks=random.randint(50, 100),
                pass_marks=random.randint(30, 50),
                duration_minutes=random.choice([45, 60, 90, 120]),
                start_date=datetime.now() - timedelta(days=random.randint(1, 30)),
                end_date=datetime.now() + timedelta(days=random.randint(7, 60)),
                published=random.choice([True, True, True, False]),  # 75% published
                published_at=datetime.now() - timedelta(days=random.randint(1, 20)) if random.random() > 0.25 else None,
                shuffle_questions=True,
                shuffle_options=True,
                show_results_immediately=random.choice([True, False]),
                allow_review=True,
                show_correct_answers=random.choice([True, False]),
                enable_proctoring=True,
                enable_tab_detection=True,
                enable_copy_paste_prevention=True
            )
            db.session.add(exam)
            created_exams.append(exam)
            print(f"  → Created exam: {exam.title} by {teacher.user.full_name}")
    
    db.session.commit()
    print(f"✓ Total exams seeded: {len(created_exams)}")
    return created_exams

def seed_questions(exams):
    """Seed questions for exams"""
    print("\n" + "=" * 60)
    print("SEEDING QUESTIONS...")
    print("=" * 60)
    
    mcq_templates = [
        {
            'text': 'What is the capital of Nigeria?',
            'options': [
                {'label': 'A', 'text': 'Lagos', 'is_correct': False},
                {'label': 'B', 'text': 'Abuja', 'is_correct': True},
                {'label': 'C', 'text': 'Kano', 'is_correct': False},
                {'label': 'D', 'text': 'Port Harcourt', 'is_correct': False}
            ]
        },
        {
            'text': 'What is 15 + 27?',
            'options': [
                {'label': 'A', 'text': '40', 'is_correct': False},
                {'label': 'B', 'text': '42', 'is_correct': True},
                {'label': 'C', 'text': '45', 'is_correct': False},
                {'label': 'D', 'text': '52', 'is_correct': False}
            ]
        },
        {
            'text': 'Which of the following is a programming language?',
            'options': [
                {'label': 'A', 'text': 'HTML', 'is_correct': False},
                {'label': 'B', 'text': 'CSS', 'is_correct': False},
                {'label': 'C', 'text': 'Python', 'is_correct': True},
                {'label': 'D', 'text': 'HTTP', 'is_correct': False}
            ]
        },
        {
            'text': 'What is the chemical symbol for water?',
            'options': [
                {'label': 'A', 'text': 'O2', 'is_correct': False},
                {'label': 'B', 'text': 'H2O', 'is_correct': True},
                {'label': 'C', 'text': 'CO2', 'is_correct': False},
                {'label': 'D', 'text': 'H2', 'is_correct': False}
            ]
        },
        {
            'text': 'Who wrote "Things Fall Apart"?',
            'options': [
                {'label': 'A', 'text': 'Wole Soyinka', 'is_correct': False},
                {'label': 'B', 'text': 'Chinua Achebe', 'is_correct': True},
                {'label': 'C', 'text': 'Chimamanda Adichie', 'is_correct': False},
                {'label': 'D', 'text': 'Ben Okri', 'is_correct': False}
            ]
        }
    ]
    
    theory_templates = [
        'Explain the process of photosynthesis in plants.',
        'Describe the water cycle and its importance to the environment.',
        'Discuss the causes and effects of climate change.',
        'Explain the concept of democracy and its principles.',
        'Describe the role of enzymes in biological processes.'
    ]
    
    total_questions = 0
    
    for exam in exams:
        num_questions = exam.total_questions or random.randint(15, 25)
        
        # 80% MCQ, 20% Theory
        num_mcq = int(num_questions * 0.8)
        num_theory = num_questions - num_mcq
        
        # Add MCQ questions
        for i in range(num_mcq):
            template = random.choice(mcq_templates)
            
            question = Question(
                exam_id=exam.id,
                question_text=template['text'],
                question_type='mcq',
                marks=random.choice([1, 2, 3]),
                order=i + 1
            )
            db.session.add(question)
            db.session.flush()
            
            # Add options
            for opt in template['options']:
                option = QuestionOption(
                    question_id=question.id,
                    option_text=opt['text'],
                    option_label=opt['label'],
                    is_correct=opt['is_correct']
                )
                db.session.add(option)
            
            total_questions += 1
        
        # Add theory questions
        for i in range(num_theory):
            theory_text = random.choice(theory_templates)
            
            question = Question(
                exam_id=exam.id,
                question_text=theory_text,
                question_type='theory',
                marks=random.choice([5, 10, 15]),
                order=num_mcq + i + 1
            )
            db.session.add(question)
            total_questions += 1
        
        if total_questions % 50 == 0:
            print(f"  → Created {total_questions} questions...")
    
    db.session.commit()
    print(f"✓ Total questions seeded: {total_questions}")

def seed_exam_results(exams, students):
    """Seed exam results and sessions"""
    print("\n" + "=" * 60)
    print("SEEDING EXAM RESULTS AND SESSIONS...")
    print("=" * 60)
    
    total_results = 0
    total_sessions = 0
    
    for exam in exams:
        if not exam.published:
            continue  # Skip unpublished exams
        
        # Get students from the same class
        class_students = [s for s in students if s.class_id == exam.class_id]
        
        # 60-80% of students take the exam
        num_attempts = int(len(class_students) * random.uniform(0.6, 0.8))
        selected_students = random.sample(class_students, min(num_attempts, len(class_students)))
        
        for student in selected_students:
            # Create exam session
            session = ExamSession(
                session_code=ExamSession.generate_session_code(),
                exam_id=exam.id,
                student_id=student.user_id,
                session_token=ExamSession.generate_token(),
                status='submitted',
                start_time=datetime.now() - timedelta(hours=random.randint(1, 720)),
                end_time=datetime.now() - timedelta(hours=random.randint(0, 720)),
                auto_submitted=random.choice([True, False]),
                tab_switches=random.randint(0, 5),
                copy_attempts=random.randint(0, 3),
                paste_attempts=random.randint(0, 3),
                ip_address=f'192.168.1.{random.randint(1, 254)}'
            )
            db.session.add(session)
            db.session.flush()
            total_sessions += 1
            
            # Create exam result
            marks_obtained = random.uniform(exam.pass_marks * 0.5, exam.total_marks)
            percentage = (marks_obtained / exam.total_marks) * 100
            
            result = ExamResult(
                exam_id=exam.id,
                student_id=student.user_id,
                exam_session_id=session.id,
                total_marks=exam.total_marks,
                marks_obtained=round(marks_obtained, 2),
                percentage=round(percentage, 2),
                pass_marks=exam.pass_marks,
                is_passed=marks_obtained >= exam.pass_marks,
                submitted_at=session.end_time
            )
            
            # Calculate grade
            result.calculate_result()
            
            db.session.add(result)
            total_results += 1
            
            # Add some proctoring logs for sessions with violations
            if session.tab_switches > 2 or session.copy_attempts > 1:
                for _ in range(random.randint(1, 3)):
                    log = ProctoringLog(
                        exam_id=exam.id,
                        student_id=student.user_id,
                        exam_session_id=session.id,
                        violation_type=random.choice([
                            'tab_switch', 'copy', 'paste', 
                            'face_not_visible', 'multiple_faces'
                        ]),
                        severity=random.choice(['low', 'medium', 'high']),
                        timestamp=session.start_time + timedelta(minutes=random.randint(5, 60)),
                        details=f"Proctoring violation detected during exam"
                    )
                    db.session.add(log)
            
            if total_results % 50 == 0:
                print(f"  → Created {total_results} results and {total_sessions} sessions...")
    
    db.session.commit()
    print(f"✓ Total exam results seeded: {total_results}")
    print(f"✓ Total exam sessions seeded: {total_sessions}")

def main():
    """Main function to run all seeding operations"""
    print("\n" + "=" * 60)
    print("E-EXAM PLATFORM - DATABASE SCHEMA & SEED DATA")
    print("=" * 60)
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    app = create_app()
    
    with app.app_context():
        try:
            # Step 1: Drop existing tables
            drop_all_tables()
            
            # Step 2: Create all tables
            create_all_tables()
            
            # Step 3: Seed roles
            seed_roles()
            
            # Step 4: Seed admin user
            seed_admin_user()
            
            # Step 5: Seed classes
            classes = seed_classes()
            
            # Step 6: Seed teachers
            teachers = seed_teachers()
            
            # Step 7: Seed students
            students = seed_students(classes)
            
            # Step 8: Seed exams
            exams = seed_exams(teachers, classes)
            
            # Step 9: Seed questions
            seed_questions(exams)
            
            # Step 10: Seed exam results
            seed_exam_results(exams, students)
            
            print("\n" + "=" * 60)
            print("DATABASE SEEDING COMPLETED SUCCESSFULLY!")
            print("=" * 60)
            print("\n📊 SUMMARY:")
            print(f"  • Roles: 3")
            print(f"  • Admin Users: 1")
            print(f"  • Classes: {len(classes)}")
            print(f"  • Teachers: {len(teachers)}")
            print(f"  • Students: {len(students)}")
            print(f"  • Exams: {len(exams)}")
            
            print("\n🔐 DEFAULT CREDENTIALS:")
            print("  • Admin: admin / admin123")
            print("  • Teachers: teacher1 to teacher10 / teacher123")
            print("  • Students: student1 to student200+ / student123")
            
            print(f"\n✅ Completed at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
            print("=" * 60)
            
        except Exception as e:
            print("\n" + "=" * 60)
            print("❌ ERROR OCCURRED DURING SEEDING!")
            print("=" * 60)
            print(f"Error: {str(e)}")
            import traceback
            traceback.print_exc()
            db.session.rollback()

if __name__ == '__main__':
    main()
