from app import create_app, db
from models.user import Role, User, Student, Teacher
from models.class_model import Class
from models.exam import Exam, Question, QuestionOption, ExamResult, ExamSession, ProctoringLog
from datetime import datetime, timedelta
import random

def drop_and_create_tables():
    print("\n" + "="*60)
    print("⚠️ DROPPING ALL TABLES...")
    print("="*60)
    db.drop_all()
    print("✓ All tables dropped successfully")
    
    print("\n" + "="*60)
    print("⚡ CREATING ALL TABLES...")
    print("="*60)
    db.create_all()
    print("✓ All tables created successfully")

def seed_roles():
    roles_data = [
        {'name': 'Admin', 'description': 'System administrator with full access'},
        {'name': 'Teacher', 'description': 'Can create and manage exams and questions'},
        {'name': 'Student', 'description': 'Can take exams and view results'}
    ]
    for role_data in roles_data:
        role = Role(**role_data)
        db.session.add(role)
    db.session.commit()
    print("✓ Roles seeded")

def seed_admin():
    admin_role = Role.query.filter_by(name='Admin').first()
    admin = User(username='admin', email='admin@mawoschool.edu.ng', first_name='System', last_name='Administrator', gender='Other', role_id=admin_role.id, is_active=True)
    admin.set_password('admin123')
    db.session.add(admin)
    db.session.commit()
    print("✓ Admin user seeded (admin / admin123)")

def main():
    app = create_app()
    with app.app_context():
        drop_and_create_tables()
        seed_roles()
        seed_admin()
        print("\n✅ DATABASE RESET & SEED COMPLETE!")

if __name__ == '__main__':
    main()