-- ═══════════════════════════════════════════════════════════════
-- Migration: persist randomized question/option order per exam session
--
-- Fixes the question-shuffling bug where:
--   1. Question/option order was re-shuffled on EVERY page load (GET
--      reload, AJAX answer save, POST submit), desyncing the question
--      palette, localStorage-cached navigation state, and flagged
--      questions between requests.
--   2. The take_exam.html template re-sorted MCQ options by
--      option_label, silently undoing the shuffle on every render.
--   3. The result/review screen showed questions in default order
--      instead of the order the student actually saw during the exam.
--
-- These columns are read by get_ordered_questions()/get_ordered_options()
-- in routes/admin.py and now also written once (on first exam load) by
-- routes/student.py's take_exam(), then reused consistently everywhere.
-- ═══════════════════════════════════════════════════════════════

ALTER TABLE exam_sessions
    ADD COLUMN IF NOT EXISTS question_order TEXT,  -- JSON list of question IDs
    ADD COLUMN IF NOT EXISTS option_order   TEXT;  -- JSON dict: {"<question_id>": [option_id, ...]}
