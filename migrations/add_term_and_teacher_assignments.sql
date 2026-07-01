-- ═══════════════════════════════════════════════════════════════
-- Migration: add academic_terms + teacher_subject_classes tables
-- Run once against your eExam database
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS academic_terms (
    id           SERIAL PRIMARY KEY,
    session_name VARCHAR(50)  NOT NULL,
    term         VARCHAR(20)  NOT NULL,
    is_current   BOOLEAN      NOT NULL DEFAULT FALSE,
    start_date   DATE,
    end_date     DATE,
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS teacher_subject_classes (
    id         SERIAL PRIMARY KEY,
    teacher_id INTEGER NOT NULL REFERENCES teachers(id)  ON DELETE CASCADE,
    class_id   INTEGER NOT NULL REFERENCES classes(id)   ON DELETE CASCADE,
    subject    VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_teacher_class_subject UNIQUE (teacher_id, class_id, subject)
);

-- Optional: seed first term if you want one immediately
-- INSERT INTO academic_terms (session_name, term, is_current)
-- VALUES ('2025/2026', 'First', TRUE);


-- ═══════════════════════════════════════════════════════════════
-- Migration: add subjects master table
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS subjects (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    code        VARCHAR(20)  UNIQUE,
    category    VARCHAR(50),
    description TEXT,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Optional: seed common Nigerian secondary school subjects
-- INSERT INTO subjects (name, code, category) VALUES
--   ('Mathematics',          'MTH', 'Core'),
--   ('English Language',     'ENG', 'Core'),
--   ('Biology',              'BIO', 'Sciences'),
--   ('Chemistry',            'CHE', 'Sciences'),
--   ('Physics',              'PHY', 'Sciences'),
--   ('Government',           'GOV', 'Social Sciences'),
--   ('Economics',            'ECO', 'Social Sciences'),
--   ('Geography',            'GEO', 'Social Sciences'),
--   ('Agricultural Science', 'AGR', 'Vocational'),
--   ('Computer Science',     'CSC', 'Technology'),
--   ('Digital Technology',   'DIT', 'Technology'),
--   ('Civic Education',      'CIV', 'Core'),
--   ('Literature in English','LIT', 'Arts'),
--   ('Christian Religious Studies','CRS','Arts'),
--   ('Islamic Religious Studies',  'IRS','Arts')
-- ON CONFLICT (name) DO NOTHING;
