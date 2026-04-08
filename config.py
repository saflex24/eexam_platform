import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import config  # your config.py

db = SQLAlchemy()


def create_app(config_name=None):
    """Create Flask app with proper config"""
    
    # 1️⃣ Determine environment
    if not config_name:
        config_name = os.getenv('FLASK_ENV', 'development')
    
    # Ensure lowercase to match config dict keys
    config_name = config_name.lower()
    
    # 2️⃣ Create app
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    
    # 3️⃣ Initialize extensions
    db.init_app(app)
    
    # 4️⃣ Ensure upload folder exists
    os.makedirs(app.config.get('UPLOAD_FOLDER', 'uploads'), exist_ok=True)
    
    # 5️⃣ Register blueprints (example)
    # from yourapp.routes import main_blueprint
    # app.register_blueprint(main_blueprint)
    
    @app.route("/health")
    def health_check():
        return {"status": "ok", "env": config_name}, 200
    
    return app


# ===============================
# Entry point for gunicorn
# ===============================
app = create_app()

if __name__ == "__main__":
    # Only for local development
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 5000)), debug=app.config.get("DEBUG", True))