import re
from functools import wraps
from flask import flash, redirect, url_for
from flask_login import current_user

def validate_email(email):
    """Validate email format"""
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(pattern, email) is not None

def validate_phone(phone):
    """Validate phone number"""
    pattern = r'^[0-9\-\+\s\(\)]{10,}$'
    return re.match(pattern, phone) is not None

def validate_password(password):
    """
    Password requirements:
    - Minimum 8 characters
    - At least one uppercase letter
    - At least one lowercase letter
    - At least one digit
    - At least one special character
    """
    if len(password) < 8:
        return False, "Password must be at least 8 characters long"
    
    if not re.search(r'[A-Z]', password):
        return False, "Password must contain at least one uppercase letter"
    
    if not re.search(r'[a-z]', password):
        return False, "Password must contain at least one lowercase letter"
    
    if not re.search(r'[0-9]', password):
        return False, "Password must contain at least one digit"
    
    if not re.search(r'[!@#$%^&*()_\-+=\[\]{};:\'",.<>?/\\]', password):
        return False, "Password must contain at least one special character"
    
    return True, "Password is strong"

def require_role(*roles):
    """Decorator to check if user has required role"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not current_user.is_authenticated:
                flash('You must be logged in to access this page.', 'danger')
                return redirect(url_for('auth.login'))
            
            if current_user.role.name not in roles:
                flash('You do not have permission to access this page.', 'danger')
                return redirect(url_for('auth.login'))
            
            return f(*args, **kwargs)
        return decorated_function
    return decorator

def validate_marks(marks, total_marks):
    """Validate exam marks"""
    try:
        marks = float(marks)
        total_marks = float(total_marks)
        
        if marks < 0:
            return False, "Marks cannot be negative"
        
        if marks > total_marks:
            return False, f"Marks cannot exceed total marks ({total_marks})"
        
        return True, "Marks are valid"
    except (ValueError, TypeError):
        return False, "Marks must be numeric"

def validate_exam_dates(start_date, end_date):
    """Validate exam start and end dates"""
    if start_date >= end_date:
        return False, "End date must be after start date"
    
    return True, "Dates are valid"
