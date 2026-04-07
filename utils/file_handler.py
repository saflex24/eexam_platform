import os
import csv
from io import StringIO
from werkzeug.utils import secure_filename
from werkzeug.exceptions import BadRequest
import pandas as pd
from extensions import db
from models.user import Student, Teacher, User, Role
from models.class_model import Class
from datetime import datetime
from config import Config

def allowed_file(filename):
    """Check if file extension is allowed"""
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in Config.ALLOWED_EXTENSIONS

def save_upload_file(file, folder=''):
    """Save uploaded file"""
    if not file or not allowed_file(file.filename):
        raise BadRequest('File type not allowed')
    
    filename = secure_filename(file.filename)
    timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S_')
    filename = timestamp + filename
    
    upload_path = os.path.join(Config.UPLOAD_FOLDER, folder)
    os.makedirs(upload_path, exist_ok=True)
    
    file_path = os.path.join(upload_path, filename)
    file.save(file_path)
    
    return filename, file_path

def import_students_from_csv(file_path, class_id=None):
    """Import students from CSV file"""
    results = {'success': 0, 'failed': 0, 'errors': []}
    
    try:
        # Try multiple encodings and handle bad lines
        try:
            df = pd.read_csv(file_path, encoding='utf-8', on_bad_lines='skip')
        except:
            try:
                df = pd.read_csv(file_path, encoding='latin-1', on_bad_lines='skip')
            except:
                df = pd.read_csv(file_path, encoding='cp1252', on_bad_lines='skip')
        
        # Strip whitespace from column names
        df.columns = df.columns.str.strip()
        
        required_columns = ['admission_number', 'first_name', 'last_name', 'username', 'email', 'gender', 'password']
        
        if not all(col in df.columns for col in required_columns):
            results['errors'].append(f'CSV must contain columns: {", ".join(required_columns)}. Found: {", ".join(df.columns)}')
            return results
        
        for index, row in df.iterrows():
            try:
                # Skip empty rows
                if pd.isna(row.get('username')) or str(row.get('username')).strip() == '':
                    continue
                
                # Check if user already exists
                existing_user = User.query.filter_by(username=str(row['username']).strip()).first()
                if existing_user:
                    results['errors'].append(f'Row {index + 2}: Username {row["username"]} already exists')
                    results['failed'] += 1
                    continue
                
                # Create user
                role = Role.query.filter_by(name='Student').first()
                user = User(
                    username=str(row['username']).strip(),
                    email=str(row['email']).strip(),
                    first_name=str(row['first_name']).strip(),
                    last_name=str(row['last_name']).strip(),
                    gender=str(row.get('gender', 'Other')).strip(),
                    role_id=role.id
                )
                user.set_password(str(row['password']))
                
                db.session.add(user)
                db.session.flush()
                
                # Create student profile
                student = Student(
                    user_id=user.id,
                    admission_number=str(row['admission_number']).strip(),
                    class_id=class_id,
                    contact_number=str(row.get('contact_number', '')).strip(),
                    date_of_birth=pd.to_datetime(row['date_of_birth']) if 'date_of_birth' in df.columns and pd.notna(row.get('date_of_birth')) else None
                )
                db.session.add(student)
                results['success'] += 1
                
            except Exception as e:
                db.session.rollback()
                results['errors'].append(f'Row {index + 2}: {str(e)}')
                results['failed'] += 1
                continue
        
        if results['success'] > 0:
            db.session.commit()
        
    except Exception as e:
        db.session.rollback()
        results['errors'].append(f'File processing error: {str(e)}')
    
    return results

def import_teachers_from_csv(file_path):
    """Import teachers from CSV file"""
    results = {'success': 0, 'failed': 0, 'errors': []}
    
    try:
        # Try multiple encodings and handle bad lines
        try:
            df = pd.read_csv(file_path, encoding='utf-8', on_bad_lines='skip')
        except:
            try:
                df = pd.read_csv(file_path, encoding='latin-1', on_bad_lines='skip')
            except:
                df = pd.read_csv(file_path, encoding='cp1252', on_bad_lines='skip')
        
        # Strip whitespace from column names
        df.columns = df.columns.str.strip()
        
        required_columns = ['teacher_id', 'first_name', 'last_name', 'username', 'email', 'subject', 'gender', 'password']
        
        if not all(col in df.columns for col in required_columns):
            results['errors'].append(f'CSV must contain columns: {", ".join(required_columns)}. Found: {", ".join(df.columns)}')
            return results
        
        for index, row in df.iterrows():
            try:
                # Skip empty rows
                if pd.isna(row.get('username')) or str(row.get('username')).strip() == '':
                    continue
                
                # Check if user already exists
                existing_user = User.query.filter_by(username=str(row['username']).strip()).first()
                if existing_user:
                    results['errors'].append(f'Row {index + 2}: Username {row["username"]} already exists')
                    results['failed'] += 1
                    continue
                
                # Create user
                role = Role.query.filter_by(name='Teacher').first()
                user = User(
                    username=str(row['username']).strip(),
                    email=str(row['email']).strip(),
                    first_name=str(row['first_name']).strip(),
                    last_name=str(row['last_name']).strip(),
                    gender=str(row.get('gender', 'Other')).strip(),
                    role_id=role.id
                )
                user.set_password(str(row['password']))
                
                db.session.add(user)
                db.session.flush()
                
                # Create teacher profile
                teacher = Teacher(
                    user_id=user.id,
                    teacher_id=str(row['teacher_id']).strip(),
                    subject=str(row['subject']).strip(),
                    qualification=str(row.get('qualification', '')).strip(),
                    contact_number=str(row.get('contact_number', '')).strip()
                )
                db.session.add(teacher)
                results['success'] += 1
                
            except Exception as e:
                db.session.rollback()
                results['errors'].append(f'Row {index + 2}: {str(e)}')
                results['failed'] += 1
                continue
        
        if results['success'] > 0:
            db.session.commit()
            
    except Exception as e:
        db.session.rollback()
        results['errors'].append(f'File processing error: {str(e)}')
    
    return results

def import_teachers_from_csv(file_path):
    """Import teachers from CSV file"""
    results = {'success': 0, 'failed': 0, 'errors': []}
    
    try:
        df = pd.read_csv(file_path)
        required_columns = ['teacher_id', 'first_name', 'last_name', 'username', 'email', 'subject', 'gender', 'password']
        
        if not all(col in df.columns for col in required_columns):
            results['errors'].append(f'CSV must contain columns: {", ".join(required_columns)}')
            return results
        
        for index, row in df.iterrows():
            try:
                # Check if user already exists
                existing_user = User.query.filter_by(username=row['username']).first()
                if existing_user:
                    results['errors'].append(f'Row {index + 1}: Username {row["username"]} already exists')
                    results['failed'] += 1
                    continue
                
                # Create user
                role = Role.query.filter_by(name='Teacher').first()
                user = User(
                    username=row['username'],
                    email=row['email'],
                    first_name=row['first_name'],
                    last_name=row['last_name'],
                    gender=row.get('gender', 'Other'),
                    role_id=role.id
                )
                user.set_password(row['password'])
                
                db.session.add(user)
                db.session.flush()
                
                # Create teacher profile
                teacher = Teacher(
                    user_id=user.id,
                    teacher_id=row['teacher_id'],
                    subject=row['subject'],
                    qualification=row.get('qualification', ''),
                    contact_number=row.get('contact_number', '')
                )
                db.session.add(teacher)
                results['success'] += 1
                
            except Exception as e:
                results['errors'].append(f'Row {index + 1}: {str(e)}')
                results['failed'] += 1
        
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        results['errors'].append(f'File processing error: {str(e)}')
    
    return results

def import_questions_from_csv(file_path, exam_id):
    """Import questions from CSV file with LaTeX support"""
    from models.exam import Question, QuestionOption
    
    results = {'success': 0, 'failed': 0, 'errors': []}
    
    try:
        # Try multiple encodings
        try:
            df = pd.read_csv(file_path, encoding='utf-8', on_bad_lines='skip')
        except:
            try:
                df = pd.read_csv(file_path, encoding='latin-1', on_bad_lines='skip')
            except:
                df = pd.read_csv(file_path, encoding='cp1252', on_bad_lines='skip')
        
        # Strip whitespace from column names
        df.columns = df.columns.str.strip()
        
        required_columns = ['question_text', 'question_type', 'marks']
        missing = [col for col in required_columns if col not in df.columns]
        
        if missing:
            results['errors'].append(f'Missing required columns: {", ".join(missing)}')
            return results
        
        for index, row in df.iterrows():
            try:
                # Skip empty rows
                if pd.isna(row.get('question_text')) or str(row.get('question_text')).strip() == '':
                    continue
                
                question_type = str(row.get('question_type', 'mcq')).lower().strip()
                if question_type not in ['mcq', 'true_false', 'theory']:
                    results['errors'].append(f'Row {index + 2}: Invalid question type "{question_type}"')
                    results['failed'] += 1
                    continue
                
                # Create question
                question = Question(
                    exam_id=exam_id,
                    question_text=str(row['question_text']).strip(),
                    question_type=question_type,
                    marks=float(row.get('marks', 1)),
                    order=index + 1,
                    instructions=str(row.get('instructions', '')).strip() if pd.notna(row.get('instructions')) else '',
                    latex_support=True  # Enable LaTeX support by default
                )
                db.session.add(question)
                db.session.flush()
                
                # Add options for MCQ
                if question_type == 'mcq':
                    correct_answer = str(row.get('correct_answer', '')).strip().upper()
                    
                    for label in ['A', 'B', 'C', 'D']:
                        option_text = row.get(f'option_{label}', '')
                        if pd.notna(option_text) and str(option_text).strip():
                            option = QuestionOption(
                                question_id=question.id,
                                option_text=str(option_text).strip(),
                                option_label=label,
                                is_correct=(correct_answer == label),
                                latex_formula=str(row.get(f'latex_{label}', '')).strip() if pd.notna(row.get(f'latex_{label}')) else None
                            )
                            db.session.add(option)
                
                # Add options for True/False
                elif question_type == 'true_false':
                    correct_answer = str(row.get('correct_answer', 'True')).strip().lower()
                    
                    for label, text in [('A', 'True'), ('B', 'False')]:
                        option = QuestionOption(
                            question_id=question.id,
                            option_text=text,
                            option_label=label,
                            is_correct=(text.lower() == correct_answer)
                        )
                        db.session.add(option)
                
                db.session.commit()
                results['success'] += 1
                
            except Exception as e:
                db.session.rollback()
                results['errors'].append(f'Row {index + 2}: {str(e)}')
                results['failed'] += 1
                continue
        
    except Exception as e:
        db.session.rollback()
        results['errors'].append(f'File processing error: {str(e)}')
    
    return results

def generate_questions_template():
    """Generate questions import template with LaTeX examples"""
    data = {
        'question_text': [
            'Solve the equation: $x^2 + 5x + 6 = 0$',
            'What is the derivative of $f(x) = x^3$?',
            'The quadratic formula is: $$x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}$$',
            'Is the following statement true or false?',
            'Explain the Pythagorean theorem.'
        ],
        'question_type': ['mcq', 'mcq', 'mcq', 'true_false', 'theory'],
        'marks': [2, 2, 3, 1, 5],
        'instructions': [
            'Choose the correct factorization',
            'Select the correct derivative',
            'Identify the correct formula',
            'Select True or False',
            'Write a detailed explanation'
        ],
        'option_A': ['$(x+2)(x+3)$', '$3x^2$', 'Correct', 'True', ''],
        'option_B': ['$(x-2)(x-3)$', '$x^2$', 'Incorrect', 'False', ''],
        'option_C': ['$(x+1)(x+6)$', '$2x^3$', 'Maybe', '', ''],
        'option_D': ['$(x-1)(x-6)$', '$3x^4$', 'Not sure', '', ''],
        'correct_answer': ['A', 'A', 'A', 'True', ''],
        'latex_formula': [
            'x^2 + 5x + 6 = 0',
            'f(x) = x^3',
            'x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}',
            '',
            'a^2 + b^2 = c^2'
        ]
    }
    return pd.DataFrame(data)

def generate_questions_template():
    """Generate questions import template with LaTeX examples"""
    data = {
        'question_text': [
            'Solve the equation: $x^2 + 5x + 6 = 0$',
            'What is the derivative of $f(x) = x^3$?',
            'The quadratic formula is: $$x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}$$',
            'Is the following statement true or false?',
            'Explain the Pythagorean theorem.'
        ],
        'question_type': ['mcq', 'mcq', 'mcq', 'true_false', 'theory'],
        'marks': [2, 2, 3, 1, 5],
        'instructions': [
            'Choose the correct factorization',
            'Select the correct derivative',
            'Identify the correct formula',
            'Select True or False',
            'Write a detailed explanation'
        ],
        'option_A': ['$(x+2)(x+3)$', '$3x^2$', 'Correct', 'True', ''],
        'option_B': ['$(x-2)(x-3)$', '$x^2$', 'Incorrect', 'False', ''],
        'option_C': ['$(x+1)(x+6)$', '$2x^3$', 'Maybe', '', ''],
        'option_D': ['$(x-1)(x-6)$', '$3x^4$', 'Not sure', '', ''],
        'correct_answer': ['A', 'A', 'A', 'True', ''],
        'latex_formula': [
            'x^2 + 5x + 6 = 0',
            'f(x) = x^3',
            'x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}',
            '',
            'a^2 + b^2 = c^2'
        ]
    }
    return pd.DataFrame(data)

def generate_student_template():
    """Generate student import template"""
    template = {
        'admission_number': 'ADM001',
        'first_name': 'John',
        'last_name': 'Doe',
        'username': 'johndoe',
        'email': 'john@example.com',
        'gender': 'Male',
        'password': 'SecurePass123!',
        'contact_number': '1234567890',
        'date_of_birth': '2005-01-15'
    }
    return pd.DataFrame([template])

def generate_teacher_template():
    """Generate teacher import template"""
    template = {
        'teacher_id': 'TCH001',
        'first_name': 'Jane',
        'last_name': 'Smith',
        'username': 'janesmith',
        'email': 'jane@example.com',
        'subject': 'Mathematics',
        'gender': 'Female',
        'password': 'SecurePass123!',
        'qualification': 'M.Sc',
        'contact_number': '9876543210'
    }
    return pd.DataFrame([template])

def generate_questions_template():
    """Generate questions import template"""
    template = {
        'question_text': 'What is 2+2?',
        'question_type': 'mcq',
        'marks': 1,
        'instructions': 'Select the correct answer',
        'option_A': '3',
        'option_B': '4',
        'option_C': '5',
        'option_D': '6',
        'correct_answer': 'B'
    }
    return pd.DataFrame([template])
