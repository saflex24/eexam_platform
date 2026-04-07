from extensions import db
from datetime import datetime

class Class(db.Model):
    __tablename__ = 'classes'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, index=True)
    code = db.Column(db.String(50), unique=True, nullable=False)
    section = db.Column(db.String(10), nullable=True)
    academic_year = db.Column(db.String(20), nullable=False)
    description = db.Column(db.Text, nullable=True)
    total_strength = db.Column(db.Integer, default=0)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    exams = db.relationship('Exam', backref='class_info', lazy=True)
    
    def __repr__(self):
        return f'<Class {self.name} - {self.section}>'
    
    @property
    def full_name(self):
        return f'{self.name} - {self.section}' if self.section else self.name

class StudentClass(db.Model):
    __tablename__ = 'student_classes'
    
    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('students.id'), nullable=False)
    class_id = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=False)
    enrollment_date = db.Column(db.DateTime, default=datetime.utcnow)
    is_active = db.Column(db.Boolean, default=True)
    
    student = db.relationship('Student', backref='class_enrollments')
    class_info = db.relationship('Class', backref='student_enrollments')
    
    __table_args__ = (
        db.UniqueConstraint('student_id', 'class_id', name='unique_student_class'),
    )
