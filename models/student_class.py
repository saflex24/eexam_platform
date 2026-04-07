from extensions import db
from datetime import datetime

class StudentClass(db.Model):
    __tablename__ = 'student_class_assignments'
    
    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('students.id'), nullable=False)
    class_id = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=False)
    assigned_date = db.Column(db.DateTime, default=datetime.utcnow)
    is_active = db.Column(db.Boolean, default=True)
    
    student = db.relationship('Student', backref='class_assignments')
    class_assigned = db.relationship('Class', backref='student_assignments')
    
    __table_args__ = (
        db.UniqueConstraint('student_id', 'class_id', name='unique_student_class_assignment'),
    )
