"""Fix duplicate fields

Revision ID: 3cc56a015acb
Revises: 2b9b06af739f
"""
from alembic import op


revision = '3cc56a015acb'
down_revision = '2b9b06af739f'
branch_labels = None
depends_on = None


def upgrade():
    # Intentionally left blank.
    # This migration exists to align model definitions
    # without altering existing production data.
    pass


def downgrade():
    pass
