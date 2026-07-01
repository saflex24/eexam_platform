-- ═══════════════════════════════════════════════════════════════
-- Migration: add promotion support columns + promotion_history table
-- ═══════════════════════════════════════════════════════════════

-- 1. Add columns to classes table
ALTER TABLE classes
    ADD COLUMN IF NOT EXISTS level          INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS is_terminal    BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS next_class_id  INTEGER REFERENCES classes(id) ON DELETE SET NULL;

-- 2. Add columns to students table
ALTER TABLE students
    ADD COLUMN IF NOT EXISTS status             VARCHAR(20) NOT NULL DEFAULT 'active',
    ADD COLUMN IF NOT EXISTS graduation_session VARCHAR(50);

-- 3. Promotion history table
CREATE TABLE IF NOT EXISTS promotion_history (
    id               SERIAL PRIMARY KEY,
    student_id       INTEGER NOT NULL REFERENCES students(id)  ON DELETE CASCADE,
    from_class_id    INTEGER          REFERENCES classes(id)   ON DELETE SET NULL,
    to_class_id      INTEGER          REFERENCES classes(id)   ON DELETE SET NULL,
    session_name     VARCHAR(50) NOT NULL,
    promotion_type   VARCHAR(20) NOT NULL,   -- promoted | graduated | repeated | transferred
    promoted_by      INTEGER          REFERENCES users(id)     ON DELETE SET NULL,
    note             TEXT,
    created_at       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_promo_history_student  ON promotion_history(student_id);
CREATE INDEX IF NOT EXISTS idx_promo_history_session  ON promotion_history(session_name);

-- 4. Typical Nigerian secondary school level seed (adjust class IDs to match your data)
-- UPDATE classes SET level=1, is_terminal=false WHERE name ILIKE 'JSS 1%';
-- UPDATE classes SET level=2, is_terminal=false WHERE name ILIKE 'JSS 2%';
-- UPDATE classes SET level=3, is_terminal=false WHERE name ILIKE 'JSS 3%';
-- UPDATE classes SET level=4, is_terminal=false WHERE name ILIKE 'SS 1%';
-- UPDATE classes SET level=5, is_terminal=false WHERE name ILIKE 'SS 2%';
-- UPDATE classes SET level=6, is_terminal=true  WHERE name ILIKE 'SS 3%';
