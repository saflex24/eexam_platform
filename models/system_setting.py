from datetime import datetime
from extensions import db


class SystemSetting(db.Model):
    """
    Singleton settings row for platform-wide toggles that need to persist
    in the database (as opposed to the school branding fields on the
    Settings page, which are handled separately).

    Only one row is ever expected to exist — always fetch it via
    get_instance() rather than querying the table directly.
    """
    __tablename__ = 'system_settings'

    id               = db.Column(db.Integer, primary_key=True)
    enrollment_open  = db.Column(db.Boolean, default=False, nullable=False)

    # School information
    school_name       = db.Column(db.String(150), default='')
    school_short_name = db.Column(db.String(50), default='')
    school_email      = db.Column(db.String(150), default='')
    school_phone      = db.Column(db.String(50), default='')
    school_website    = db.Column(db.String(200), default='')
    school_address    = db.Column(db.Text, default='')

    # Branding
    school_logo     = db.Column(db.String(255), default='')
    school_favicon  = db.Column(db.String(255), default='')
    primary_color   = db.Column(db.String(20), default='#6366f1')
    secondary_color = db.Column(db.String(20), default='#8b5cf6')

    # System behaviour
    maintenance_mode = db.Column(db.Boolean, default=False, nullable=False)
    timezone          = db.Column(db.String(50), default='UTC')

    # Footer
    footer_text    = db.Column(db.Text, default='')
    copyright_text = db.Column(db.String(255), default='')

    updated_at       = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    @classmethod
    def get_instance(cls):
        """Fetch the single settings row, creating it with defaults if missing."""
        instance = cls.query.first()
        if not instance:
            instance = cls(enrollment_open=False)
            db.session.add(instance)
            db.session.commit()
        return instance

    def to_dict(self):
        """Serialize for the admin settings template."""
        return {
            'school_name':                self.school_name,
            'school_short_name':          self.school_short_name,
            'school_email':                self.school_email,
            'school_phone':                self.school_phone,
            'school_website':              self.school_website,
            'school_address':              self.school_address,
            'school_logo':                 self.school_logo,
            'school_favicon':              self.school_favicon,
            'primary_color':               self.primary_color or '#6366f1',
            'secondary_color':             self.secondary_color or '#8b5cf6',
            'allow_student_registration':  self.enrollment_open,
            'maintenance_mode':            self.maintenance_mode,
            'timezone':                    self.timezone or 'UTC',
            'footer_text':                 self.footer_text,
            'copyright_text':              self.copyright_text,
        }

    @classmethod
    def is_enrollment_open(cls):
        """Safe read used by public-facing routes (e.g. registration page)."""
        try:
            return cls.get_instance().enrollment_open
        except Exception:
            # If the table hasn't been migrated yet, fail closed.
            return False