"""Make email optional

Revision ID: 5fd65f8569f5
Revises: 894c8187af2d
Create Date: 2026-01-31 10:42:27.580513
"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '5fd65f8569f5'
down_revision = '894c8187af2d'
branch_labels = None
depends_on = None


def upgrade():
    # Make users.email nullable and remove old index
    with op.batch_alter_table('users') as batch_op:
        batch_op.alter_column(
            'email',
            existing_type=sa.VARCHAR(length=120),
            nullable=True
        )
        batch_op.drop_index('ix_users_email')


def downgrade():
    # Revert users.email to NOT NULL and restore index
    with op.batch_alter_table('users') as batch_op:
        batch_op.alter_column(
            'email',
            existing_type=sa.VARCHAR(length=120),
            nullable=False
        )
        batch_op.create_index(
            'ix_users_email',
            ['email'],
            unique=False
        )
