"""Add face violations and enhanced proctoring fields

Revision ID: 2b9b06af739f
Revises: e549fe7a1eee
"""
from alembic import op
import sqlalchemy as sa


revision = '2b9b06af739f'
down_revision = 'e549fe7a1eee'
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table('exam_sessions') as batch_op:
        batch_op.add_column(
            sa.Column(
                'face_violations',
                sa.Integer(),
                nullable=False,
                server_default='0'
            )
        )
        batch_op.add_column(
            sa.Column(
                'fullscreen_exits',
                sa.Integer(),
                nullable=False,
                server_default='0'
            )
        )


def downgrade():
    with op.batch_alter_table('exam_sessions') as batch_op:
        batch_op.drop_column('fullscreen_exits')
        batch_op.drop_column('face_violations')
