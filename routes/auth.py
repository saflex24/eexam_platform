from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required, current_user
from models.user import User
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
        
        return render_template('auth/login.html')
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
    """Register new user (if enabled)"""
    flash('Registration is currently disabled. Please contact the administrator.', 'warning')
    return redirect(url_for('auth.login'))