from functools import wraps
from flask import flash, redirect, url_for, abort
from flask_login import current_user
from extensions import db  # SAFE: no circular import


def login_required_custom(f):
    """Custom login required decorator"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            flash("Please log in to access this page.", "warning")
            return redirect(url_for("auth.login"))
        return f(*args, **kwargs)
    return decorated_function


def admin_required(f):
    """Require admin role"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            flash("Please log in to access this page.", "warning")
            return redirect(url_for("auth.login"))

        #  DEFENSIVE CHECK (prevents 500)
        if not hasattr(current_user, "role") or not current_user.role:
            abort(403)

        if current_user.role.name != "Admin":
            flash("You do not have permission to access this page.", "danger")
            abort(403)

        return f(*args, **kwargs)
    return decorated_function


def teacher_required(f):
    """Require teacher role"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            flash("Please log in to access this page.", "warning")
            return redirect(url_for("auth.login"))

        if not hasattr(current_user, "role") or not current_user.role:
            abort(403)

        if current_user.role.name != "Teacher":
            flash("You do not have permission to access this page.", "danger")
            abort(403)

        return f(*args, **kwargs)
    return decorated_function


def student_required(f):
    """Require student role"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            flash("Please log in to access this page.", "warning")
            return redirect(url_for("auth.login"))

        if not hasattr(current_user, "role") or not current_user.role:
            abort(403)

        if current_user.role.name != "Student":
            flash("You do not have permission to access this page.", "danger")
            abort(403)

        return f(*args, **kwargs)
    return decorated_function
