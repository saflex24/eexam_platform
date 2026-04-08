import os
import sys
import traceback
import logging
from flask import Flask, render_template, redirect, url_for
from flask_login import current_user
from config import config
from werkzeug.exceptions import HTTPException
from extensions import db, login_manager, migrate


# ================================
# PYINSTALLER UTILITY FUNCTIONS
# ================================
def resource_path(relative_path):
    """
    Get absolute path to resource, works for dev and PyInstaller
    
    Args:
        relative_path: Path relative to application root
        
    Returns:
        str: Absolute path to resource
    """
    try:
        # PyInstaller creates a temp folder and stores path in _MEIPASS
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    
    return os.path.join(base_path, relative_path)


def get_application_path():
    """
    Get the path where the application is running from
    
    Returns:
        str: Application directory path
    """
    if getattr(sys, 'frozen', False):
        # Running as compiled exe
        return os.path.dirname(sys.executable)
    else:
        # Running as script
        return os.path.dirname(os.path.abspath(__file__))


# ================================
# LOGGING CONFIGURATION
# ================================
application_path = get_application_path()

# Create logs directory
log_folder = os.path.join(application_path, 'logs')
os.makedirs(log_folder, exist_ok=True)

# UTF-8 SAFE LOGGING (NO CONSOLE ISSUES)
logging.basicConfig(
    filename=os.path.join(log_folder, "app.log"),
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    encoding="utf-8"
)

logger = logging.getLogger(__name__)


def create_app(config_name=None):
    """Application factory"""

    if config_name is None:
        config_name = os.getenv("FLASK_ENV", "production")

    # Initialize Flask with PyInstaller-compatible paths
    app = Flask(
        __name__,
        template_folder=resource_path("templates"),
        static_folder=resource_path("static")
    )

    app.config.from_object(config[config_name])

    # ================================
    # PYINSTALLER DATABASE OVERRIDE
    # ================================
    # When running as exe, ensure database path is in exe directory
    if getattr(sys, 'frozen', False):
        db_path = os.path.join(application_path, 'eexam.db')
        app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{db_path}'
        
        # Override upload folder to be in exe directory
        app.config['UPLOAD_FOLDER'] = os.path.join(application_path, 'uploads')
        
        # Ensure production settings
        app.config['DEBUG'] = False
        app.config['TESTING'] = False
        
        logger.info('=' * 70)
        logger.info('E-EXAM PORTAL - Running as PyInstaller exe')
        logger.info('=' * 70)
        logger.info(f'Application path: {application_path}')
        logger.info(f'Database path: {db_path}')
        logger.info(f'Upload folder: {app.config["UPLOAD_FOLDER"]}')
        logger.info(f'Log folder: {log_folder}')

    # ================================
    # EXTENSIONS
    # ================================
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    login_manager.login_view = "auth.login"
    login_manager.login_message = "Please log in to access this page."

    # Create upload folder
    os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)

    # Register error handlers
    register_error_handlers(app)

    # ================================
    # MODELS
    # ================================
    from models.class_model import Class, StudentClass
    from models.user import User, Role, Student, Teacher, ClassTeacher
    from models.exam import (
        Exam, Question, QuestionOption,
        StudentAnswer, ExamResult, ExamSession, ProctoringLog
    )

    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    # ================================
    # BLUEPRINTS
    # ================================
    from routes.auth import auth_bp
    from routes.admin import admin_bp
    from routes.teacher import teacher_bp
    from routes.student import student_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(admin_bp, url_prefix="/admin")
    app.register_blueprint(teacher_bp, url_prefix="/teacher")
    app.register_blueprint(student_bp, url_prefix="/student")

    # ================================
    # HOME ROUTE
    # ================================
    @app.route("/")
    def index():
        if current_user.is_authenticated:
            role = current_user.role.name
            if role == "Admin":
                return redirect(url_for("admin.dashboard"))
            elif role == "Teacher":
                return redirect(url_for("teacher.dashboard"))
            elif role == "Student":
                return redirect(url_for("student.dashboard"))
        return redirect(url_for("auth.login"))

    # ================================
    # CREATE TABLES
    # ================================
    with app.app_context():
        try:
            db.create_all()
            logger.info("Database tables created successfully")
        except Exception as e:
            logger.error(f"Error creating database tables: {e}")
            logger.exception("Database creation error details:")

    return app


# ================================
# ERROR HANDLERS (UTF-8 SAFE)
# ================================
def register_error_handlers(app):

    @app.errorhandler(404)
    def not_found(error):
        logger.warning(f"404 Not Found: {error}")
        return render_template("errors/404.html"), 404

    @app.errorhandler(403)
    def forbidden(error):
        logger.warning(f"403 Forbidden: {error}")
        return render_template("errors/403.html"), 403

    @app.errorhandler(500)
    def server_error(error):
        db.session.rollback()
        logger.exception("500 Internal Server Error")
        return render_template("errors/500.html"), 500

    @app.errorhandler(Exception)
    def handle_exception(e):
        if isinstance(e, HTTPException):
            logger.warning(f"HTTP Error {e.code}: {e.description}")
            return (
                render_template(
                    "errors/http_error.html",
                    code=e.code,
                    message=e.description
                ),
                e.code,
            )

        db.session.rollback()
        logger.exception("Unhandled Exception")
        return render_template("errors/500.html"), 500


# ================================
# APP INSTANCE
# ================================
def create_app(config_name=None):
    """Application factory (Render + PyInstaller safe)"""

    # ================================
    # FIX 1: SAFE CONFIG SELECTION
    # ================================
    if not config_name:
        config_name = os.getenv("FLASK_CONFIG", "production")

    config_key = config_name.lower()

    if config_key not in config:
        logger.warning(f"Invalid config '{config_name}', falling back to 'default'")
        config_key = "default"

    # ================================
    # INIT FLASK APP
    # ================================
    app = Flask(
        __name__,
        template_folder=resource_path("templates"),
        static_folder=resource_path("static")
    )

    app.config.from_object(config[config_key])

    # ================================
    # FIX 2: FORCE DATABASE ON RENDER
    # ================================
    database_url = os.getenv("DATABASE_URL")

    if database_url:
        # Render provides postgres URL
        if database_url.startswith("postgres://"):
            database_url = database_url.replace("postgres://", "postgresql://", 1)

        app.config["SQLALCHEMY_DATABASE_URI"] = database_url
        logger.info("Using DATABASE_URL from environment")

    # ================================
    # PYINSTALLER OVERRIDE
    # ================================
    if getattr(sys, 'frozen', False):
        db_path = os.path.join(application_path, 'eexam.db')
        app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{db_path}'

        app.config['UPLOAD_FOLDER'] = os.path.join(application_path, 'uploads')
        app.config['DEBUG'] = False
        app.config['TESTING'] = False

        logger.info("Running as PyInstaller EXE")

    # ================================
    # EXTENSIONS
    # ================================
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)

    login_manager.login_view = "auth.login"
    login_manager.login_message = "Please log in to access this page."

    # Ensure upload folder exists
    os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)

    # ================================
    # ERROR HANDLERS
    # ================================
    register_error_handlers(app)

    # ================================
    # MODELS
    # ================================
    from models.class_model import Class, StudentClass
    from models.user import User, Role, Student, Teacher, ClassTeacher
    from models.exam import (
        Exam, Question, QuestionOption,
        StudentAnswer, ExamResult, ExamSession, ProctoringLog
    )

    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    # ================================
    # BLUEPRINTS
    # ================================
    from routes.auth import auth_bp
    from routes.admin import admin_bp
    from routes.teacher import teacher_bp
    from routes.student import student_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(admin_bp, url_prefix="/admin")
    app.register_blueprint(teacher_bp, url_prefix="/teacher")
    app.register_blueprint(student_bp, url_prefix="/student")

    # ================================
    # HOME ROUTE
    # ================================
    @app.route("/")
    def index():
        if current_user.is_authenticated:
            role = current_user.role.name
            if role == "Admin":
                return redirect(url_for("admin.dashboard"))
            elif role == "Teacher":
                return redirect(url_for("teacher.dashboard"))
            elif role == "Student":
                return redirect(url_for("student.dashboard"))
        return redirect(url_for("auth.login"))

    # ================================
    # FIX 3: SAFE DB INIT (NO CRASH)
    # ================================
    with app.app_context():
        try:
            db.create_all()
            logger.info("Database initialized successfully")
        except Exception as e:
            logger.error(f"Database init failed: {e}")
            logger.exception("DB ERROR")

    return app