from alembic import op
import sqlalchemy as sa
import uuid

# revision identifiers, used by Alembic.
revision = '42808a59013b'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # 1️⃣ Add column as NULLABLE
    with op.batch_alter_table('exam_sessions') as batch_op:
        batch_op.add_column(
            sa.Column('session_code', sa.String(length=50), nullable=True)
        )

    # 2️⃣ Populate existing rows with unique values
    op.execute("""
        UPDATE exam_sessions
        SET session_code = 'SES-' || id::text
        WHERE session_code IS NULL
    """)

    # 3️⃣ Enforce NOT NULL + UNIQUE
    with op.batch_alter_table('exam_sessions') as batch_op:
        batch_op.alter_column(
            'session_code',
            nullable=False
        )
        batch_op.create_unique_constraint(
            'uq_exam_sessions_session_code', ['session_code']
        )


def downgrade():
    with op.batch_alter_table('exam_sessions') as batch_op:
        batch_op.drop_constraint(
            'uq_exam_sessions_session_code', type_='unique'
        )
        batch_op.drop_column('session_code')
