from app import create_app, db
from models.user import User, Role

def initialize_database():
    """Initialize database with default roles and admin user"""
    app = create_app()
    
    with app.app_context():
        # Create all tables
        db.create_all()
        
        # Create default roles
        roles = ['Admin', 'Teacher', 'Student']
        for role_name in roles:
            if not Role.query.filter_by(name=role_name).first():
                role = Role(name=role_name, description=f'{role_name} role')
                db.session.add(role)
        
        db.session.commit()
        
        # Create admin user if not exists
        admin_role = Role.query.filter_by(name='Admin').first()
        if not User.query.filter_by(username='admin').first():
            admin = User(
                username='admin',
                email='admin@eexam.com',
                first_name='System',
                last_name='Administrator',
                role_id=admin_role.id,
                is_active=True
            )
            admin.set_password('password123')
            db.session.add(admin)
            db.session.commit()
            print('✓ Admin user created (username: admin, password: password123)')
        else:
            print('✓ Admin user already exists')
        
        print('✓ Database initialized successfully!')

if __name__ == '__main__':
    initialize_database()