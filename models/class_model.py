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
    is_active    = db.Column(db.Boolean, default=True)
    level        = db.Column(db.Integer, default=0)    # promotion order (1=lowest, higher=senior)
    is_terminal  = db.Column(db.Boolean, default=False) # True = graduation class (e.g. SS3)
    next_class_id = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=True)  # explicit next class
    created_at   = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at   = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    exams      = db.relationship('Exam', backref='class_info', lazy=True)
    next_class = db.relationship('Class', foreign_keys=[next_class_id], remote_side='Class.id')
    
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


class AcademicTerm(db.Model):
    """Stores current academic term/session info for the school."""
    __tablename__ = 'academic_terms'

    id            = db.Column(db.Integer, primary_key=True)
    session_name  = db.Column(db.String(50), nullable=False)   # e.g. "2025/2026"
    term          = db.Column(db.String(20), nullable=False)   # "First", "Second", "Third"
    is_current    = db.Column(db.Boolean, default=False)
    start_date    = db.Column(db.Date, nullable=True)
    end_date      = db.Column(db.Date, nullable=True)
    created_at    = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at    = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f'<AcademicTerm {self.session_name} – {self.term} Term>'


class TeacherSubjectClass(db.Model):
    """Admin assigns specific subject(s) to a teacher for a class."""
    __tablename__ = 'teacher_subject_classes'

    id         = db.Column(db.Integer, primary_key=True)
    teacher_id = db.Column(db.Integer, db.ForeignKey('teachers.id'), nullable=False)
    class_id   = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=False)
    subject    = db.Column(db.String(100), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    teacher    = db.relationship('Teacher', backref='subject_classes')
    class_info = db.relationship('Class', backref='subject_assignments')

    __table_args__ = (
        db.UniqueConstraint('teacher_id', 'class_id', 'subject',
                            name='unique_teacher_class_subject'),
    )

    def __repr__(self):
        return f'<TeacherSubjectClass t={self.teacher_id} c={self.class_id} s={self.subject}>'


class Subject(db.Model):
    """Master subject list managed by admin."""
    __tablename__ = 'subjects'

    id          = db.Column(db.Integer, primary_key=True)
    name        = db.Column(db.String(100), unique=True, nullable=False)
    code        = db.Column(db.String(20), unique=True, nullable=True)   # e.g. MTH, ENG
    category    = db.Column(db.String(50), nullable=True)               # Core, Elective, Vocational…
    description = db.Column(db.Text, nullable=True)
    is_active   = db.Column(db.Boolean, default=True)
    created_at  = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at  = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f'<Subject {self.name}>'


class PromotionHistory(db.Model):
    """Records every promotion event for audit and rollback capability."""
    __tablename__ = 'promotion_history'

    id               = db.Column(db.Integer, primary_key=True)
    student_id       = db.Column(db.Integer, db.ForeignKey('students.id'), nullable=False)
    from_class_id    = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=True)
    to_class_id      = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=True)
    session_name     = db.Column(db.String(50), nullable=False)   # e.g. "2024/2025"
    promotion_type   = db.Column(db.String(20), nullable=False)   # promoted / graduated / repeated
    promoted_by      = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    note             = db.Column(db.Text, nullable=True)
    created_at       = db.Column(db.DateTime, default=datetime.utcnow)

    student          = db.relationship('Student', backref='promotion_history')
    from_class       = db.relationship('Class', foreign_keys=[from_class_id])
    to_class         = db.relationship('Class', foreign_keys=[to_class_id])

    def __repr__(self):
        return f'<PromotionHistory student={self.student_id} {self.promotion_type} {self.session_name}>'
