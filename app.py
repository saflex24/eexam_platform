import os
import sys
import logging
from flask import Flask, render_template, redirect, url_for
from flask_login import current_user
from werkzeug.exceptions import HTTPException

from config import config
from extensions import db, login_manager, migrate


# ================================
# PATH HELPERS
# ================================
def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)


def get_application_path():
    if getattr(sys, 'frozen', False):
        return os.path.dirname(sys.executable)
    return os.path.dirname(os.path.abspath(__file__))


application_path = get_application_path()

# ================================
# LOGGING
# ================================
log_folder = os.path.join(application_path, 'logs')
os.makedirs(log_folder, exist_ok=True)

logging.basicConfig(
    filename=os.path.join(log_folder, "app.log"),
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    encoding="utf-8"
)

logger = logging.getLogger(__name__)


# ================================
# APPLICATION FACTORY
# ================================
def create_app(config_name=None):

    # SAFE CONFIG
    if not config_name:
        config_name = os.getenv("FLASK_CONFIG", "production")

    config_key = config_name.lower()
    if config_key not in config:
        logger.warning(f"Invalid config '{config_name}', using default")
        config_key = "default"

    app = Flask(
        __name__,
        template_folder="templates",   # safer for Render
        static_folder="static"
    )

    app.config.from_object(config[config_key])

    # ================================
    # DATABASE FIX (RENDER)
    # ================================
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        if database_url.startswith("postgres://"):
            database_url = database_url.replace("postgres://", "postgresql://", 1)
        app.config["SQLALCHEMY_DATABASE_URI"] = database_url
        logger.info("Using DATABASE_URL")

    # ================================
    # PYINSTALLER MODE
    # ================================
    if getattr(sys, 'frozen', False):
        db_path = os.path.join(application_path, 'eexam.db')
        app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{db_path}'
        app.config['UPLOAD_FOLDER'] = os.path.join(application_path, 'uploads')
        app.config['DEBUG'] = False

    # ================================
    # EXTENSIONS
    # ================================
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)

    login_manager.login_view = "auth.login"
    login_manager.login_message = "Please log in to access this page."

    os.makedirs(app.config.get("UPLOAD_FOLDER", "uploads"), exist_ok=True)

    register_error_handlers(app)

    # ================================
    # MODELS
    # ================================
    from models.user import User

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
    # 🔥 TEMP FIX ADMIN PASSWORD
    # ================================
    @app.route("/fix-admin")
    def fix_admin():
        from models.user import User
        from werkzeug.security import generate_password_hash

        user = User.query.filter_by(username='admin').first()

        if not user:
            return "❌ Admin user not found"

        user.password_hash = generate_password_hash("admin123@")
        db.session.commit()

        return "✅ Admin password reset successfully!"

    # ================================
    # SAFE DB INIT
    # ================================
    with app.app_context():
        try:
            db.create_all()
            logger.info("Database initialized")
        except Exception as e:
            logger.error(f"DB init error: {e}")

    return app


# ================================
# ERROR HANDLERS
# ================================
def register_error_handlers(app):

    @app.errorhandler(404)
    def not_found(e):
        return render_template("errors/404.html"), 404

    @app.errorhandler(500)
    def server_error(e):
        db.session.rollback()
        logger.exception("500 Error")
        return render_template("errors/500.html"), 500

    @app.errorhandler(Exception)
    def handle_exception(e):
        if isinstance(e, HTTPException):
            return render_template("errors/http_error.html", code=e.code), e.code

        db.session.rollback()
        logger.exception("Unhandled Exception")
        return render_template("errors/500.html"), 500


# ================================
# GLOBAL APP (REQUIRED FOR RENDER)
# ================================
app = create_app()


# ================================
# LOCAL RUN ONLY
# ================================
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)