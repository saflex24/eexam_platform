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
app = create_app()


# ================================
# ENTRY POINT - PYINSTALLER COMPATIBLE
# ================================
if __name__ == "__main__":
    
    if getattr(sys, 'frozen', False):
        # ================================
        # RUNNING AS PYINSTALLER EXE
        # ================================
        print("=" * 70)
        print("E-EXAM PORTAL - PRODUCTION MODE".center(70))
        print("=" * 70)
        print()
        print(f"Application Path: {application_path}")
        
        # Determine database type
        db_uri = app.config.get('SQLALCHEMY_DATABASE_URI', '')
        if 'sqlite' in db_uri:
            print(f"Database: SQLite - {os.path.join(application_path, 'eexam.db')}")
        elif 'postgresql' in db_uri:
            print(f"Database: PostgreSQL - {db_uri.split('@')[1] if '@' in db_uri else 'configured'}")
        else:
            print(f"Database: {db_uri.split(':')[0] if ':' in db_uri else 'configured'}")
        
        print(f"Uploads: {app.config['UPLOAD_FOLDER']}")
        print(f"Logs: {os.path.join(log_folder, 'app.log')}")
        print()
        print("Server starting at: http://localhost:5000")
        print()
        print("⚠️  To stop the server, press Ctrl+C")
        print("=" * 70)
        print()
        
        logger.info("=" * 70)
        logger.info("E-EXAM PORTAL - PRODUCTION MODE STARTING")
        logger.info("=" * 70)
        logger.info(f"Application Path: {application_path}")
        logger.info(f"Python Version: {sys.version}")
        logger.info(f"Database URI: {app.config.get('SQLALCHEMY_DATABASE_URI', 'Not set')}")
        logger.info("Starting production server (Waitress)...")
        
        # Auto-open browser
        import webbrowser
        import threading
        import time
        
        def open_browser():
            """Open browser after server starts"""
            time.sleep(3)  # Wait for server to fully start
            try:
                webbrowser.open('http://localhost:5000')
                logger.info("Browser opened automatically")
            except Exception as e:
                logger.error(f"Failed to open browser: {e}")
                print("⚠️  Could not open browser automatically")
                print("   Please open http://localhost:5000 manually")
        
        # Start browser in background thread
        browser_thread = threading.Thread(target=open_browser, daemon=True)
        browser_thread.start()
        
        # Use Waitress production WSGI server
        try:
            from waitress import serve
            logger.info("Waitress server starting on 0.0.0.0:5000")
            print("✓ Starting Waitress production server...")
            print()
            serve(
                app,
                host='0.0.0.0',
                port=5000,
                threads=4,
                channel_timeout=300,
                cleanup_interval=30,
                log_socket_errors=True
            )
        except ImportError:
            print()
            print("=" * 70)
            print("❌ ERROR: Waitress not installed!".center(70))
            print("=" * 70)
            print()
            print("Waitress is required for production mode.")
            print("To install, run: pip install waitress")
            print()
            logger.error("Waitress not installed - cannot start production server")
            input("Press Enter to exit...")
            sys.exit(1)
        except KeyboardInterrupt:
            print()
            print("=" * 70)
            print("Server stopped by user".center(70))
            print("=" * 70)
            logger.info("Server stopped by user (Ctrl+C)")
            sys.exit(0)
        except Exception as e:
            print()
            print("=" * 70)
            print("❌ ERROR STARTING SERVER".center(70))
            print("=" * 70)
            print()
            print(f"Error: {e}")
            print()
            print("Check logs/app.log for details")
            logger.exception("Server failed to start")
            input("Press Enter to exit...")
            sys.exit(1)
    
    else:
        # ================================
        # RUNNING AS SCRIPT (DEVELOPMENT)
        # ================================
        print("=" * 70)
        print("E-EXAM PORTAL - DEVELOPMENT MODE".center(70))
        print("=" * 70)
        print()
        print("Server starting at: http://localhost:5000")
        print()
        print("⚠️  Debug mode is ON")
        print("⚠️  Auto-reloader is ON")
        print()
        print("To stop the server, press Ctrl+C")
        print("=" * 70)
        print()
        
        logger.info("Starting development server (Flask)...")
        
        # Use Flask development server
        app.run(
            host="0.0.0.0",
            port=5000,
            debug=True,
            use_reloader=True
        )