import os
import sys
from datetime import timedelta
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


# ================================
# PYINSTALLER PATH DETECTION
# ================================
def get_application_path():
    """
    Get the path where the application is running from
    
    Returns:
        str: Application directory path
            - When running as script: Directory containing the script
            - When running as PyInstaller exe: Directory containing the exe
    """
    if getattr(sys, 'frozen', False):
        # Running as compiled exe
        return os.path.dirname(sys.executable)
    else:
        # Running as script
        return os.path.dirname(os.path.abspath(__file__))


# Base directory for file operations
basedir = get_application_path()


class Config:
    """Base configuration"""
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    
    # Database
    # Default to PostgreSQL, but allow override
    default_db_uri = 'postgresql://postgres:320660@localhost:5432/eexam_db'
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', default_db_uri)
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_size': 10,
        'pool_recycle': 3600,
        'pool_pre_ping': True,
    }
    
    # Session
    PERMANENT_SESSION_LIFETIME = timedelta(hours=1)
    SESSION_COOKIE_SECURE = False
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'
    
    # Upload - use absolute path based on application location
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024
    UPLOAD_FOLDER = os.path.join(
        basedir,
        os.getenv('UPLOAD_FOLDER', 'uploads')
    )
    ALLOWED_EXTENSIONS = set(
        os.getenv('ALLOWED_EXTENSIONS', 'csv,xlsx,xls,jpg,jpeg,png,gif').split(',')
    )
    
    # Pagination
    ITEMS_PER_PAGE = int(os.getenv('ITEMS_PER_PAGE', 20))
    
    # Exam Settings
    EXAM_SESSION_TIMEOUT = int(os.getenv('EXAM_SESSION_TIMEOUT', 7200))
    
    # Proctoring
    ENABLE_WEBCAM = os.getenv('ENABLE_WEBCAM', 'True') == 'True'
    ENABLE_TAB_DETECTION = os.getenv('ENABLE_TAB_DETECTION', 'True') == 'True'
    ENABLE_COPY_PASTE_PREVENTION = os.getenv('ENABLE_COPY_PASTE_PREVENTION', 'True') == 'True'
    
    # Ensure upload folder exists
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)


class DevelopmentConfig(Config):
    """Development configuration"""
    DEBUG = True
    TESTING = False


class TestingConfig(Config):
    """Testing configuration"""
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'
    WTF_CSRF_ENABLED = False


class ProductionConfig(Config):
    """Production configuration"""
    DEBUG = False
    SESSION_COOKIE_SECURE = True
    
    # ================================
    # PYINSTALLER PRODUCTION OVERRIDES
    # ================================
    # When running as exe, override database to use local SQLite
    if getattr(sys, 'frozen', False):
        # Use SQLite database in exe directory for standalone deployment
        db_path = os.path.join(basedir, 'eexam.db')
        SQLALCHEMY_DATABASE_URI = f'sqlite:///{db_path}'
        
        # Note: If you want to keep PostgreSQL in production exe,
        # make sure PostgreSQL is installed on target machines and
        # comment out the above lines


config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}