"""Add profile_picture field

Revision ID: e549fe7a1eee
Revises: 5fd65f8569f5
Create Date: 2026-02-03 10:49:50.505738
"""
from alembic import op
import sqlalchemy as sa


revision = 'e549fe7a1eee'
down_revision = '5fd65f8569f5'
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table('users') as batch_op:
        batch_op.add_column(
            sa.Column('profile_picture', sa.String(length=255), nullable=True)
        )


def downgrade():
    with op.batch_alter_table('users') as batch_op:
        batch_op.drop_column('profile_picture')
