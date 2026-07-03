from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required, current_user
from sqlalchemy.exc import IntegrityError
from models.user import User
from models.system_setting import SystemSetting
from extensions import db


auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    try:
        if current_user.is_authenticated:
            # Redirect based on role
            if current_user.role.name == 'Admin':
                return redirect(url_for('admin.dashboard'))
            elif current_user.role.name == 'Teacher':
                return redirect(url_for('teacher.dashboard'))
            elif current_user.role.name == 'Student':
                return redirect(url_for('student.dashboard'))
        
        if request.method == 'POST':
            print("=== LOGIN ATTEMPT ===")
            username = request.form.get('username')
            password = request.form.get('password')
            remember = request.form.get('remember', False)
            
            print(f"Username: {username}")
            print(f"Password received: {'Yes' if password else 'No'}")
            
            user = User.query.filter_by(username=username).first()
            print(f"User found: {user is not None}")
            
            if user and user.check_password(password):
                if not user.is_active:
                    flash('Your account has been deactivated.', 'danger')
                    return redirect(url_for('auth.login'))
                
                login_user(user, remember=remember)
                flash(f'Welcome back, {user.full_name}!', 'success')
                
                # Redirect based on role
                if user.role.name == 'Admin':
                    return redirect(url_for('admin.dashboard'))
                elif user.role.name == 'Teacher':
                    return redirect(url_for('teacher.dashboard'))
                elif user.role.name == 'Student':
                    return redirect(url_for('student.dashboard'))
            else:
                flash('Invalid username or password.', 'danger')
        
        return render_template('auth/login.html', enrollment_open=SystemSetting.is_enrollment_open())
    except Exception as e:
        print(f"=== ERROR IN LOGIN ===")
        print(f"Error: {str(e)}")
        import traceback
        traceback.print_exc()
        raise

@auth_bp.route('/logout')
@login_required
def logout():
    """Logout user and clear session"""
    username = current_user.username
    logout_user()
    flash(f'You have been logged out successfully. Goodbye!', 'info')
    return redirect(url_for('auth.login'))


@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    """Self-service student registration, controlled by the admin's
    'Allow student registration' toggle (SystemSetting.enrollment_open).
    """
    from models.user import Student, Role
    from models.class_model import Class
    from utils.validators import validate_email

    try:
        if current_user.is_authenticated:
            return redirect(url_for('auth.login'))

        # Re-check on every request (including POST) so the toggle can't be
        # bypassed by posting directly to this route while it's closed.
        if not SystemSetting.is_enrollment_open():
            flash('Registration is currently disabled. Please contact the administrator.', 'warning')
            return redirect(url_for('auth.login'))

        classes = Class.query.filter_by(is_active=True).order_by(Class.name).all()

        if request.method == 'POST':
            first_name       = request.form.get('first_name', '').strip()
            last_name        = request.form.get('last_name', '').strip()
            admission_number = request.form.get('admission_number', '').strip()
            class_id         = request.form.get('class_id', '').strip()
            username         = request.form.get('username', '').strip()
            email            = request.form.get('email', '').strip()
            gender           = request.form.get('gender', 'Other').strip()
            password         = request.form.get('password', '')
            confirm_password = request.form.get('confirm_password', '')

            errors = []
            if not first_name or not last_name:
                errors.append('First and last name are required.')
            if not admission_number:
                errors.append('Admission number is required.')
            if not class_id:
                errors.append('Please select your class.')
            if not username:
                errors.append('Username is required.')
            if email and not validate_email(email):
                errors.append('Please enter a valid email address.')
            if password != confirm_password:
                errors.append('Passwords do not match.')
            elif len(password) < 6:
                errors.append('Password must be at least 6 characters long.')

            if not errors:
                if User.query.filter_by(username=username).first():
                    errors.append(f'Username "{username}" is already taken.')
                if Student.query.filter_by(admission_number=admission_number).first():
                    errors.append(f'Admission number "{admission_number}" is already registered.')
                if class_id and not Class.query.get(int(class_id)):
                    errors.append('Selected class is invalid.')

            if errors:
                for error in errors:
                    flash(error, 'danger')
                return render_template('auth/register.html', classes=classes, form=request.form)

            try:
                role = Role.query.filter_by(name='Student').first()
                user = User(
                    username=username,
                    email=email or None,
                    first_name=first_name,
                    last_name=last_name,
                    gender=gender,
                    role_id=role.id
                )
                user.set_password(password)
                db.session.add(user)
                db.session.flush()

                student = Student(
                    user_id=user.id,
                    admission_number=admission_number,
                    class_id=int(class_id)
                )
                db.session.add(student)
                db.session.commit()

                flash('Registration successful! You can now log in.', 'success')
                return redirect(url_for('auth.login'))
            except IntegrityError:
                # Most likely a double-submit: two requests for the same
                # username/admission number raced past the uniqueness check
                # above and one of them already succeeded and committed.
                db.session.rollback()
                existing_user = User.query.filter_by(username=username).first()
                if existing_user and existing_user.check_password(password):
                    flash('Looks like this account was already created. Please log in.', 'info')
                    return redirect(url_for('auth.login'))
                flash('That username or admission number was just taken. Please choose a different one.', 'danger')
                return render_template('auth/register.html', classes=classes, form=request.form)
            except Exception as e:
                db.session.rollback()
                print(f"ERROR in register: {str(e)}")
                import traceback
                traceback.print_exc()
                flash('Something went wrong creating your account. Please try again.', 'danger')
                return render_template('auth/register.html', classes=classes, form=request.form)

        return render_template('auth/register.html', classes=classes, form={})
    except Exception as e:
        print(f"ERROR in register: {str(e)}")
        import traceback
        traceback.print_exc()
        flash('Error loading registration page.', 'danger')
        return redirect(url_for('auth.login'))