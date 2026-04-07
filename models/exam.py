from extensions import db
from datetime import datetime
import random
import string


class Exam(db.Model):
    __tablename__ = 'exams'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    code = db.Column(db.String(50), unique=True, nullable=False, index=True)
    description = db.Column(db.Text, nullable=True)
    subject = db.Column(db.String(100), nullable=False)
    class_id = db.Column(db.Integer, db.ForeignKey('classes.id'), nullable=True)
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    passcode = db.Column(db.String(50), nullable=True)
    
    # Results and review settings
    show_results_immediately = db.Column(db.Boolean, default=False)
    allow_review = db.Column(db.Boolean, default=True)
    show_correct_answers = db.Column(db.Boolean, default=False)
    allow_student_view_result = db.Column(db.Boolean, default=True)

    # Exam metrics
    total_questions = db.Column(db.Integer, default=0)
    total_marks = db.Column(db.Float, default=0)
    pass_marks = db.Column(db.Float, default=0)
    duration_minutes = db.Column(db.Integer, default=60)

    # Exam schedule
    start_date = db.Column(db.DateTime, nullable=False)
    end_date = db.Column(db.DateTime, nullable=False)
    published = db.Column(db.Boolean, default=False)
    published_at = db.Column(db.DateTime, nullable=True)

    # Question/Option randomization
    shuffle_questions = db.Column(db.Boolean, default=True)
    shuffle_options = db.Column(db.Boolean, default=True)
    randomize_per_student = db.Column(db.Boolean, default=True)

    # Proctoring settings
    enable_proctoring = db.Column(db.Boolean, default=True)
    enable_webcam = db.Column(db.Boolean, default=False)
    enable_tab_detection = db.Column(db.Boolean, default=True)
    enable_copy_paste_prevention = db.Column(db.Boolean, default=True)

    # Status fields
    is_active = db.Column(db.Boolean, default=True)
    is_deleted = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    questions = db.relationship('Question', backref='exam', lazy=True, cascade='all, delete-orphan')
    results = db.relationship('ExamResult', backref='exam', lazy=True, cascade='all, delete-orphan')
    sessions = db.relationship('ExamSession', backref='exam', lazy=True, cascade='all, delete-orphan')

    @staticmethod
    def generate_code():
        return ''.join(random.choices(string.ascii_uppercase + string.digits, k=10))

    def __repr__(self):
        return f'<Exam {self.title}>'


class Question(db.Model):
    __tablename__ = 'questions'
    
    id = db.Column(db.Integer, primary_key=True)
    exam_id = db.Column(db.Integer, db.ForeignKey('exams.id'), nullable=False)
    question_text = db.Column(db.Text, nullable=False)
    question_type = db.Column(db.String(20), nullable=False)
    marks = db.Column(db.Float, default=1)
    order = db.Column(db.Integer, nullable=False)
    instructions = db.Column(db.Text, nullable=True)
    image = db.Column(db.String(255), nullable=True)
    latex_support = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    options = db.relationship('QuestionOption', backref='question', lazy=True, cascade='all, delete-orphan')
    answers = db.relationship('StudentAnswer', backref='question', lazy=True, cascade='all, delete-orphan')

    def __repr__(self):
        return f'<Question {self.id}>'


class QuestionOption(db.Model):
    __tablename__ = 'question_options'
    
    id = db.Column(db.Integer, primary_key=True)
    question_id = db.Column(db.Integer, db.ForeignKey('questions.id'), nullable=False)
    option_text = db.Column(db.Text, nullable=False)
    option_label = db.Column(db.String(10), nullable=False)
    is_correct = db.Column(db.Boolean, default=False)
    latex_formula = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def __repr__(self):
        return f'<Option {self.option_label}>'


class StudentAnswer(db.Model):
    __tablename__ = 'student_answers'
    
    id = db.Column(db.Integer, primary_key=True)
    exam_session_id = db.Column(db.Integer, db.ForeignKey('exam_sessions.id'), nullable=False)
    question_id = db.Column(db.Integer, db.ForeignKey('questions.id'), nullable=False)
    student_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    selected_option_id = db.Column(db.Integer, db.ForeignKey('question_options.id'), nullable=True)
    theory_answer = db.Column(db.Text, nullable=True)
    is_correct = db.Column(db.Boolean, nullable=True)
    marks_obtained = db.Column(db.Float, default=0)

    time_spent_seconds = db.Column(db.Integer, default=0)
    marked_for_review = db.Column(db.Boolean, default=False)
    visited_count = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    session = db.relationship('ExamSession', backref='answers')
    selected_option = db.relationship('QuestionOption', backref='student_selections')

    def __repr__(self):
        return f'<Answer {self.id}>'


class ExamResult(db.Model):
    __tablename__ = 'exam_results'
    
    id = db.Column(db.Integer, primary_key=True)
    exam_id = db.Column(db.Integer, db.ForeignKey('exams.id'), nullable=False)
    student_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    exam_session_id = db.Column(db.Integer, db.ForeignKey('exam_sessions.id'), nullable=True)
    
    total_marks = db.Column(db.Float, default=0, nullable=False)
    marks_obtained = db.Column(db.Float, default=0, nullable=False)
    percentage = db.Column(db.Float, default=0, nullable=False)
    pass_marks = db.Column(db.Float, default=0, nullable=False)
    is_passed = db.Column(db.Boolean, default=False)
    grade = db.Column(db.String(5), nullable=True)

    submitted_at = db.Column(db.DateTime, default=datetime.utcnow)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    @property
    def total_time_seconds(self):
        """Calculate total time taken from exam session"""
        if self.exam_session_id:
            try:
                session = ExamSession.query.get(self.exam_session_id)
                if session and session.end_time and session.start_time:
                    return int((session.end_time - session.start_time).total_seconds())
            except Exception as e:
                print(f"Error calculating time: {e}")
                pass
        return 0
    
    @property
    def total_time_minutes(self):
        """Get time in minutes"""
        try:
            seconds = self.total_time_seconds
            if seconds:
                return round(seconds / 60, 1)
            return 0.0
        except Exception as e:
            print(f"Error calculating minutes: {e}")
            return 0.0
    
    def calculate_percentage(self):
        """Safely calculate percentage"""
        if self.total_marks and self.total_marks > 0:
            self.percentage = (self.marks_obtained or 0) / self.total_marks * 100
        else:
            self.percentage = 0
        return self.percentage
    
    def calculate_result(self):
        """Calculate all result metrics safely"""
        self.calculate_percentage()
        self.is_passed = (self.marks_obtained or 0) >= (self.pass_marks or 0)
        
        # Assign grade based on percentage
        if self.percentage >= 90:
            self.grade = 'A+'
        elif self.percentage >= 80:
            self.grade = 'A'
        elif self.percentage >= 70:
            self.grade = 'B'
        elif self.percentage >= 60:
            self.grade = 'C'
        elif self.percentage >= 50:
            self.grade = 'D'
        else:
            self.grade = 'F'

    def __repr__(self):
        return f'<Result {self.id}>'


class ExamSession(db.Model):
    __tablename__ = 'exam_sessions'
    
    id = db.Column(db.Integer, primary_key=True)
    session_code = db.Column(db.String(50), unique=True, nullable=False)

    exam_id = db.Column(db.Integer, db.ForeignKey('exams.id'), nullable=False)
    student_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    session_token = db.Column(db.String(100), unique=True, nullable=False)
    status = db.Column(db.String(20), default='started')

    start_time = db.Column(db.DateTime, default=datetime.utcnow)
    last_activity = db.Column(db.DateTime, default=datetime.utcnow)
    end_time = db.Column(db.DateTime, nullable=True)
    auto_submitted = db.Column(db.Boolean, default=False)

    # Proctoring violation counters
    tab_switches = db.Column(db.Integer, default=0)
    copy_attempts = db.Column(db.Integer, default=0)
    paste_attempts = db.Column(db.Integer, default=0)
    face_violations = db.Column(db.Integer, default=0)
    fullscreen_exits = db.Column(db.Integer, default=0)
    webcam_captures = db.Column(db.Integer, default=0)

    user_agent = db.Column(db.String(500), nullable=True)
    ip_address = db.Column(db.String(50), nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    student = db.relationship('User', backref='exam_sessions')

    @staticmethod
    def generate_session_code():
        return 'ES-' + ''.join(
            random.choices(string.ascii_uppercase + string.digits, k=8)
        )

    @staticmethod
    def generate_token():
        return ''.join(random.choices(string.ascii_letters + string.digits, k=32))

    def __repr__(self):
        return f'<Session {self.id}>'


class ProctoringLog(db.Model):
    __tablename__ = 'proctoring_logs'
    
    id = db.Column(db.Integer, primary_key=True)
    exam_session_id = db.Column(db.Integer, db.ForeignKey('exam_sessions.id'), nullable=False)
    exam_id = db.Column(db.Integer, db.ForeignKey('exams.id'), nullable=False)
    student_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    
    event_type = db.Column(db.String(50), nullable=False)
    violation_type = db.Column(db.String(50))
    severity = db.Column(db.String(20))  # 'low', 'medium', 'high'
    details = db.Column(db.Text)  # JSON string
    
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationships
    exam_session = db.relationship('ExamSession', backref='proctoring_logs')
    exam = db.relationship('Exam', backref='proctoring_logs')
    student = db.relationship('User', backref='proctoring_logs', foreign_keys=[student_id])
    
    def __repr__(self):
        return f'<ProctoringLog {self.id}: {self.event_type}>'