from extensions import db
from datetime import datetime

class Teacher(db.Model):
    __tablename__ = 'teachers'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), unique=True, nullable=False)
    
    # Teacher Information
    employee_id = db.Column(db.String(50), unique=True, nullable=False)
    subject = db.Column(db.String(100))
    qualification = db.Column(db.String(100))
    specialization = db.Column(db.String(100))
    
    # Contact Information
    contact_number = db.Column(db.String(20))
    
    # Timestamps
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    user = db.relationship('User', backref=db.backref('teacher_profile', uselist=False))
    
    def __repr__(self):
        return f'<Teacher {self.employee_id}>'