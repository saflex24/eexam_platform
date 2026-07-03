--
-- PostgreSQL database dump
--

\restrict mF7iuUnvkLSsca5d9DWwGCNKTAVfawNrM5tcX0WeIzbWIbqAzaDaR2jNNapU8Q4

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-07-02 22:10:36

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 248 (class 1259 OID 84313)
-- Name: academic_terms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.academic_terms (
    id integer NOT NULL,
    session_name character varying(50) NOT NULL,
    term character varying(20) NOT NULL,
    is_current boolean,
    start_date date,
    end_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.academic_terms OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 84312)
-- Name: academic_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.academic_terms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.academic_terms_id_seq OWNER TO postgres;

--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 247
-- Name: academic_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.academic_terms_id_seq OWNED BY public.academic_terms.id;


--
-- TOC entry 246 (class 1259 OID 17895)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17693)
-- Name: class_teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_teacher (
    class_id integer NOT NULL,
    teacher_id integer NOT NULL,
    is_primary boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.class_teacher OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17584)
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(50) NOT NULL,
    section character varying(10),
    academic_year character varying(20) NOT NULL,
    description text,
    total_strength integer,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    level integer DEFAULT 0,
    is_terminal boolean DEFAULT false,
    next_class_id integer
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17583)
-- Name: classes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.classes_id_seq OWNER TO postgres;

--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 221
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
-- TOC entry 241 (class 1259 OID 17798)
-- Name: exam_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exam_results (
    id integer NOT NULL,
    exam_id integer NOT NULL,
    student_id integer NOT NULL,
    exam_session_id integer,
    total_marks double precision NOT NULL,
    marks_obtained double precision NOT NULL,
    percentage double precision NOT NULL,
    pass_marks double precision NOT NULL,
    is_passed boolean,
    grade character varying(5),
    submitted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.exam_results OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17797)
-- Name: exam_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exam_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exam_results_id_seq OWNER TO postgres;

--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 240
-- Name: exam_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exam_results_id_seq OWNED BY public.exam_results.id;


--
-- TOC entry 237 (class 1259 OID 17752)
-- Name: exam_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exam_sessions (
    id integer NOT NULL,
    session_code character varying(50) NOT NULL,
    exam_id integer NOT NULL,
    student_id integer NOT NULL,
    session_token character varying(100) NOT NULL,
    status character varying(20),
    start_time timestamp without time zone,
    last_activity timestamp without time zone,
    end_time timestamp without time zone,
    auto_submitted boolean,
    tab_switches integer,
    copy_attempts integer,
    paste_attempts integer,
    face_violations integer,
    fullscreen_exits integer,
    webcam_captures integer,
    user_agent character varying(500),
    ip_address character varying(50),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    question_order text,
    option_order text
);


ALTER TABLE public.exam_sessions OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17751)
-- Name: exam_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exam_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exam_sessions_id_seq OWNER TO postgres;

--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 236
-- Name: exam_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exam_sessions_id_seq OWNED BY public.exam_sessions.id;


--
-- TOC entry 230 (class 1259 OID 17667)
-- Name: exams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exams (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    subject character varying(100) NOT NULL,
    class_id integer,
    created_by integer NOT NULL,
    passcode character varying(50),
    show_results_immediately boolean,
    allow_review boolean,
    show_correct_answers boolean,
    allow_student_view_result boolean,
    total_questions integer,
    total_marks double precision,
    pass_marks double precision,
    duration_minutes integer,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    published boolean,
    published_at timestamp without time zone,
    shuffle_questions boolean,
    shuffle_options boolean,
    randomize_per_student boolean,
    enable_proctoring boolean,
    enable_webcam boolean,
    enable_tab_detection boolean,
    enable_copy_paste_prevention boolean,
    is_active boolean,
    is_deleted boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.exams OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17666)
-- Name: exams_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exams_id_seq OWNER TO postgres;

--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 229
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exams_id_seq OWNED BY public.exams.id;


--
-- TOC entry 243 (class 1259 OID 17827)
-- Name: proctoring_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proctoring_logs (
    id integer NOT NULL,
    exam_session_id integer NOT NULL,
    exam_id integer NOT NULL,
    student_id integer NOT NULL,
    event_type character varying(50) NOT NULL,
    violation_type character varying(50),
    severity character varying(20),
    details text,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.proctoring_logs OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17826)
-- Name: proctoring_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proctoring_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proctoring_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 242
-- Name: proctoring_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proctoring_logs_id_seq OWNED BY public.proctoring_logs.id;


--
-- TOC entry 254 (class 1259 OID 84361)
-- Name: promotion_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_history (
    id integer NOT NULL,
    student_id integer NOT NULL,
    from_class_id integer,
    to_class_id integer,
    session_name character varying(50) NOT NULL,
    promotion_type character varying(20) NOT NULL,
    promoted_by integer,
    note text,
    created_at timestamp without time zone
);


ALTER TABLE public.promotion_history OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 84360)
-- Name: promotion_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotion_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotion_history_id_seq OWNER TO postgres;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 253
-- Name: promotion_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotion_history_id_seq OWNED BY public.promotion_history.id;


--
-- TOC entry 239 (class 1259 OID 17780)
-- Name: question_options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_options (
    id integer NOT NULL,
    question_id integer NOT NULL,
    option_text text NOT NULL,
    option_label character varying(10) NOT NULL,
    is_correct boolean,
    latex_formula text,
    created_at timestamp without time zone
);


ALTER TABLE public.question_options OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17779)
-- Name: question_options_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.question_options_id_seq OWNER TO postgres;

--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 238
-- Name: question_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_options_id_seq OWNED BY public.question_options.id;


--
-- TOC entry 235 (class 1259 OID 17733)
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    exam_id integer NOT NULL,
    question_text text NOT NULL,
    question_type character varying(20) NOT NULL,
    marks double precision,
    "order" integer NOT NULL,
    instructions text,
    image character varying(255),
    latex_support boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17732)
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questions_id_seq OWNER TO postgres;

--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 234
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- TOC entry 220 (class 1259 OID 17573)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    created_at timestamp without time zone
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17572)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 245 (class 1259 OID 17856)
-- Name: student_answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_answers (
    id integer NOT NULL,
    exam_session_id integer NOT NULL,
    question_id integer NOT NULL,
    student_id integer NOT NULL,
    selected_option_id integer,
    theory_answer text,
    is_correct boolean,
    marks_obtained double precision,
    time_spent_seconds integer,
    marked_for_review boolean,
    visited_count integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.student_answers OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 17855)
-- Name: student_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_answers_id_seq OWNER TO postgres;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 244
-- Name: student_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_answers_id_seq OWNED BY public.student_answers.id;


--
-- TOC entry 233 (class 1259 OID 17711)
-- Name: student_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_classes (
    id integer NOT NULL,
    student_id integer NOT NULL,
    class_id integer NOT NULL,
    enrollment_date timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.student_classes OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17710)
-- Name: student_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_classes_id_seq OWNER TO postgres;

--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 232
-- Name: student_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_classes_id_seq OWNED BY public.student_classes.id;


--
-- TOC entry 226 (class 1259 OID 17621)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    id integer NOT NULL,
    user_id integer NOT NULL,
    admission_number character varying(50) NOT NULL,
    roll_number character varying(50),
    class_id integer,
    contact_number character varying(20),
    address text,
    date_of_birth date,
    guardian_name character varying(150),
    guardian_contact character varying(20),
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying(20) DEFAULT 'active'::character varying,
    graduation_session character varying(50)
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17620)
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_id_seq OWNER TO postgres;

--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 225
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- TOC entry 252 (class 1259 OID 84346)
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20),
    category character varying(50),
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 84345)
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subjects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subjects_id_seq OWNER TO postgres;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 251
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subjects_id_seq OWNED BY public.subjects.id;


--
-- TOC entry 256 (class 1259 OID 85102)
-- Name: system_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    enrollment_open boolean NOT NULL,
    updated_at timestamp without time zone,
    school_name character varying(150),
    school_short_name character varying(50),
    school_email character varying(150),
    school_phone character varying(50),
    school_website character varying(200),
    school_address text,
    school_logo character varying(255),
    school_favicon character varying(255),
    primary_color character varying(20),
    secondary_color character varying(20),
    maintenance_mode boolean DEFAULT false NOT NULL,
    timezone character varying(50),
    footer_text text,
    copyright_text character varying(255)
);


ALTER TABLE public.system_settings OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 85101)
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_id_seq OWNER TO postgres;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 255
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- TOC entry 250 (class 1259 OID 84323)
-- Name: teacher_subject_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_subject_classes (
    id integer NOT NULL,
    teacher_id integer NOT NULL,
    class_id integer NOT NULL,
    subject character varying(100) NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.teacher_subject_classes OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 84322)
-- Name: teacher_subject_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teacher_subject_classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teacher_subject_classes_id_seq OWNER TO postgres;

--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 249
-- Name: teacher_subject_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teacher_subject_classes_id_seq OWNED BY public.teacher_subject_classes.id;


--
-- TOC entry 228 (class 1259 OID 17646)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    id integer NOT NULL,
    user_id integer NOT NULL,
    teacher_id character varying(50) NOT NULL,
    subject character varying(100) NOT NULL,
    qualification character varying(255),
    specialization character varying(255),
    contact_number character varying(20),
    address text,
    joining_date date,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17645)
-- Name: teachers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teachers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teachers_id_seq OWNER TO postgres;

--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 227
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_id_seq OWNED BY public.teachers.id;


--
-- TOC entry 224 (class 1259 OID 17600)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(80) NOT NULL,
    email character varying(120),
    password_hash character varying(255) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    gender character varying(10),
    profile_picture character varying(255),
    is_active boolean,
    is_deleted boolean,
    role_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17599)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 223
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4848 (class 2604 OID 84316)
-- Name: academic_terms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academic_terms ALTER COLUMN id SET DEFAULT nextval('public.academic_terms_id_seq'::regclass);


--
-- TOC entry 4833 (class 2604 OID 17587)
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- TOC entry 4845 (class 2604 OID 17801)
-- Name: exam_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results ALTER COLUMN id SET DEFAULT nextval('public.exam_results_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 17755)
-- Name: exam_sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions ALTER COLUMN id SET DEFAULT nextval('public.exam_sessions_id_seq'::regclass);


--
-- TOC entry 4840 (class 2604 OID 17670)
-- Name: exams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams ALTER COLUMN id SET DEFAULT nextval('public.exams_id_seq'::regclass);


--
-- TOC entry 4846 (class 2604 OID 17830)
-- Name: proctoring_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs ALTER COLUMN id SET DEFAULT nextval('public.proctoring_logs_id_seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 84364)
-- Name: promotion_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_history ALTER COLUMN id SET DEFAULT nextval('public.promotion_history_id_seq'::regclass);


--
-- TOC entry 4844 (class 2604 OID 17783)
-- Name: question_options id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_options ALTER COLUMN id SET DEFAULT nextval('public.question_options_id_seq'::regclass);


--
-- TOC entry 4842 (class 2604 OID 17736)
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- TOC entry 4832 (class 2604 OID 17576)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4847 (class 2604 OID 17859)
-- Name: student_answers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers ALTER COLUMN id SET DEFAULT nextval('public.student_answers_id_seq'::regclass);


--
-- TOC entry 4841 (class 2604 OID 17714)
-- Name: student_classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes ALTER COLUMN id SET DEFAULT nextval('public.student_classes_id_seq'::regclass);


--
-- TOC entry 4837 (class 2604 OID 17624)
-- Name: students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 84349)
-- Name: subjects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects ALTER COLUMN id SET DEFAULT nextval('public.subjects_id_seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 85105)
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 84326)
-- Name: teacher_subject_classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subject_classes ALTER COLUMN id SET DEFAULT nextval('public.teacher_subject_classes_id_seq'::regclass);


--
-- TOC entry 4839 (class 2604 OID 17649)
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 17603)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5126 (class 0 OID 84313)
-- Dependencies: 248
-- Data for Name: academic_terms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.academic_terms (id, session_name, term, is_current, start_date, end_date, created_at, updated_at) FROM stdin;
2	2025/2026	First	t	2026-06-20	2026-06-26	2026-06-20 20:21:10.529145	2026-06-20 20:21:10.529145
\.


--
-- TOC entry 5124 (class 0 OID 17895)
-- Dependencies: 246
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
4efb27e784ee
\.


--
-- TOC entry 5109 (class 0 OID 17693)
-- Dependencies: 231
-- Data for Name: class_teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class_teacher (class_id, teacher_id, is_primary, created_at) FROM stdin;
\.


--
-- TOC entry 5100 (class 0 OID 17584)
-- Dependencies: 222
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (id, name, code, section, academic_year, description, total_strength, is_active, created_at, updated_at, level, is_terminal, next_class_id) FROM stdin;
3	Grade 6	sapphire		2024/2025		0	t	2026-06-20 20:22:10.877337	2026-06-20 20:22:10.877337	0	f	\N
\.


--
-- TOC entry 5119 (class 0 OID 17798)
-- Dependencies: 241
-- Data for Name: exam_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_results (id, exam_id, student_id, exam_session_id, total_marks, marks_obtained, percentage, pass_marks, is_passed, grade, submitted_at, created_at, updated_at) FROM stdin;
25	8	10	30	60	38	63.33333333333333	15	t	C	2026-06-20 21:38:29.987903	2026-06-20 21:38:29.989929	2026-06-20 21:38:29.989929
33	7	10	40	200	2	1	50	f	F	2026-06-21 13:27:46.527884	2026-06-21 13:27:46.527884	2026-06-21 13:27:46.527884
35	12	10	42	50	0	0	25	f	F	2026-06-24 22:19:26.354228	2026-06-24 22:19:26.354228	2026-06-24 22:19:26.354228
36	13	10	43	100	5	5	40	f	F	2026-06-30 20:40:00.476399	2026-06-30 20:40:00.483987	2026-06-30 20:40:00.483987
37	13	17	44	100	3	3	40	f	F	2026-07-03 05:00:57.099457	2026-07-03 05:00:57.099457	2026-07-03 05:00:57.099457
\.


--
-- TOC entry 5115 (class 0 OID 17752)
-- Dependencies: 237
-- Data for Name: exam_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_sessions (id, session_code, exam_id, student_id, session_token, status, start_time, last_activity, end_time, auto_submitted, tab_switches, copy_attempts, paste_attempts, face_violations, fullscreen_exits, webcam_captures, user_agent, ip_address, created_at, updated_at, question_order, option_order) FROM stdin;
30	SESSION-8-10-1782016269	8	10	dM0S99asGfy5cqFgyyXvoj1Zb4LdioyS	submitted	2026-06-20 21:31:09.738314	2026-06-20 21:38:30.310536	2026-06-20 21:38:30.030374	f	1	0	0	1	0	0	\N	\N	2026-06-20 21:31:09.741312	2026-06-20 21:38:30.310536	\N	\N
40	SESSION-7-10-1782073543	7	10	SUALfag3DLB16geNM6xLKoioGOBQRfnI	submitted	2026-06-21 13:25:43.331839	2026-06-21 13:27:46.672387	2026-06-21 13:27:46.527884	f	1	0	0	1	0	0	\N	\N	2026-06-21 13:25:43.331839	2026-06-21 13:27:46.672387	[551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650]	{}
44	SESSION-13-17-1783079966	13	17	j7qFR9cLRYbPfJijv41Tlz24cGz2gQyG	submitted	2026-07-03 04:59:26.266887	2026-07-03 05:00:57.381594	2026-07-03 05:00:57.132561	f	1	0	0	1	1	0	\N	\N	2026-07-03 04:59:26.271883	2026-07-03 05:00:57.381594	[1043, 995, 1011, 1064, 1009, 1018, 1028, 985, 986, 1063, 994, 999, 983, 1041, 984, 1016, 997, 1060, 996, 1010, 1024, 1020, 1007, 1025, 1047, 1045, 1069, 1038, 976, 1067, 1052, 989, 1040, 1012, 1004, 1035, 1071, 1062, 988, 1058, 1061, 1044, 975, 982, 1017, 1006, 974, 1046, 1048, 993, 1036, 1000, 1027, 1068, 1021, 1037, 1015, 1023, 1049, 1032, 978, 998, 1005, 1050, 1070, 1034, 991, 1026, 1056, 1055, 981, 1019, 1039, 1059, 992, 1051, 987, 1029, 1053, 980, 1033, 1003, 979, 1042, 1002, 1054, 990, 1013, 1001, 1014, 973, 1065, 1008, 977, 1022, 1030, 1066, 1072, 1031, 1057]	{"1043": [3747, 3745, 3746], "995": [3573, 3575, 3576, 3574], "1011": [3637, 3640, 3638, 3639], "1064": [3809, 3808, 3810], "1009": [3631, 3632, 3630, 3629], "1018": [3665, 3667, 3666, 3668], "1028": [3700, 3702, 3701], "985": [3534, 3535, 3533, 3536], "986": [3537, 3539, 3538, 3540], "1063": [3807, 3806, 3805], "994": [3569, 3572, 3571, 3570], "999": [3592, 3591, 3589, 3590], "983": [3528, 3527, 3525, 3526], "1041": [3741, 3739, 3740], "984": [3530, 3529, 3532, 3531], "1016": [3659, 3658, 3657, 3660], "997": [3583, 3581, 3584, 3582], "1060": [3798, 3797, 3796], "996": [3577, 3580, 3579, 3578], "1010": [3633, 3636, 3635, 3634], "1024": [3688, 3689, 3690], "1020": [3674, 3673, 3676, 3675], "1007": [3622, 3623, 3624, 3621], "1025": [3693, 3691, 3692], "1047": [3759, 3757, 3758], "1045": [3753, 3752, 3751], "1069": [3825, 3823, 3824], "1038": [3730, 3732, 3731], "976": [3500, 3497, 3499, 3498], "1067": [3819, 3818, 3817], "1052": [3774, 3773, 3772], "989": [3550, 3552, 3549, 3551], "1040": [3737, 3738, 3736], "1012": [3643, 3644, 3641, 3642], "1004": [3612, 3611, 3610, 3609], "1035": [3721, 3723, 3722], "1071": [3830, 3831, 3829], "1062": [3802, 3804, 3803], "988": [3548, 3546, 3545, 3547], "1058": [3790, 3791, 3792], "1061": [3800, 3799, 3801], "1044": [3748, 3750, 3749], "975": [3495, 3494, 3493, 3496], "982": [3523, 3521, 3524, 3522], "1017": [3661, 3664, 3662, 3663], "1006": [3619, 3618, 3620, 3617], "974": [3492, 3489, 3491, 3490], "1046": [3755, 3754, 3756], "1048": [3761, 3760, 3762], "993": [3566, 3567, 3565, 3568], "1036": [3726, 3724, 3725], "1000": [3594, 3596, 3593, 3595], "1027": [3698, 3699, 3697], "1068": [3822, 3820, 3821], "1021": [3677, 3679, 3680, 3678], "1037": [3729, 3727, 3728], "1015": [3656, 3653, 3655, 3654], "1023": [3687, 3685, 3686], "1049": [3763, 3764, 3765], "1032": [3712, 3714, 3713], "978": [3507, 3506, 3505, 3508], "998": [3586, 3588, 3585, 3587], "1005": [3614, 3615, 3613, 3616], "1050": [3767, 3768, 3766], "1070": [3826, 3828, 3827], "1034": [3720, 3718, 3719], "991": [3558, 3559, 3560, 3557], "1026": [3696, 3695, 3694], "1056": [3784, 3786, 3785], "1055": [3782, 3781, 3783], "981": [3517, 3520, 3518, 3519], "1019": [3669, 3670, 3672, 3671], "1039": [3735, 3733, 3734], "1059": [3795, 3794, 3793], "992": [3562, 3561, 3563, 3564], "1051": [3771, 3770, 3769], "987": [3542, 3541, 3544, 3543], "1029": [3703, 3704, 3705], "1053": [3777, 3775, 3776], "980": [3516, 3514, 3513, 3515], "1033": [3715, 3717, 3716], "1003": [3606, 3608, 3605, 3607], "979": [3510, 3512, 3509, 3511], "1042": [3743, 3742, 3744], "1002": [3602, 3604, 3601, 3603], "1054": [3780, 3779, 3778], "990": [3555, 3553, 3556, 3554], "1013": [3645, 3646, 3648, 3647], "1001": [3600, 3597, 3598, 3599], "1014": [3650, 3649, 3652, 3651], "973": [3487, 3488, 3485, 3486], "1065": [3813, 3811, 3812], "1008": [3627, 3628, 3625, 3626], "977": [3503, 3502, 3501, 3504], "1022": [3682, 3684, 3681, 3683], "1030": [3708, 3707, 3706], "1066": [3816, 3815, 3814], "1072": [3833, 3832, 3834], "1031": [3710, 3709, 3711], "1057": [3789, 3787, 3788]}
39	SESSION-7-12-1782073537	7	12	RP2oT6cB8CY6gv67RuypBKIVIqHcnedS	in_progress	2026-06-21 13:25:37.042411	2026-06-21 13:26:02.431234	\N	f	1	0	0	1	0	0	\N	\N	2026-06-21 13:25:37.042411	2026-06-21 13:26:02.431234	[551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650]	{}
43	SESSION-13-10-1782877146	13	10	TPXf3XuRRq4m4YgvXwVLEM8edoQraCIJ	submitted	2026-06-30 20:39:06.439194	2026-06-30 20:40:01.166856	2026-06-30 20:40:00.550475	f	1	0	0	0	0	0	\N	\N	2026-06-30 20:39:06.447197	2026-06-30 20:40:01.171983	[1070, 979, 1052, 1055, 985, 1044, 994, 978, 1028, 1071, 1012, 1060, 1018, 1000, 1009, 983, 1008, 1022, 982, 1006, 975, 997, 1062, 1069, 1037, 1067, 1020, 1059, 1063, 1066, 1024, 1047, 1036, 995, 989, 1005, 1026, 1004, 1014, 1048, 1017, 1039, 1068, 984, 1019, 1021, 1064, 986, 992, 1035, 1032, 1072, 1041, 1043, 1053, 991, 1011, 1042, 980, 1027, 1034, 1057, 1046, 1003, 1030, 1051, 974, 993, 990, 1056, 1010, 1001, 1007, 1065, 988, 998, 987, 1040, 976, 1016, 981, 1031, 973, 1029, 1033, 1050, 1002, 1025, 1058, 1023, 1015, 977, 1038, 999, 1061, 1049, 1013, 1054, 996, 1045]	{"1070": [3827, 3828, 3826], "979": [3512, 3511, 3510, 3509], "1052": [3774, 3772, 3773], "1055": [3781, 3783, 3782], "985": [3534, 3535, 3536, 3533], "1044": [3748, 3749, 3750], "994": [3572, 3571, 3569, 3570], "978": [3508, 3507, 3506, 3505], "1028": [3701, 3702, 3700], "1071": [3831, 3830, 3829], "1012": [3644, 3641, 3642, 3643], "1060": [3798, 3797, 3796], "1018": [3668, 3667, 3665, 3666], "1000": [3593, 3594, 3595, 3596], "1009": [3632, 3629, 3630, 3631], "983": [3527, 3526, 3525, 3528], "1008": [3628, 3626, 3625, 3627], "1022": [3683, 3682, 3681, 3684], "982": [3522, 3523, 3521, 3524], "1006": [3619, 3620, 3618, 3617], "975": [3494, 3496, 3495, 3493], "997": [3583, 3584, 3581, 3582], "1062": [3802, 3804, 3803], "1069": [3825, 3824, 3823], "1037": [3728, 3729, 3727], "1067": [3817, 3819, 3818], "1020": [3674, 3676, 3673, 3675], "1059": [3794, 3793, 3795], "1063": [3806, 3807, 3805], "1066": [3816, 3815, 3814], "1024": [3690, 3688, 3689], "1047": [3757, 3758, 3759], "1036": [3724, 3725, 3726], "995": [3573, 3575, 3576, 3574], "989": [3550, 3549, 3551, 3552], "1005": [3614, 3613, 3615, 3616], "1026": [3694, 3696, 3695], "1004": [3609, 3610, 3611, 3612], "1014": [3649, 3651, 3652, 3650], "1048": [3760, 3762, 3761], "1017": [3662, 3663, 3664, 3661], "1039": [3733, 3734, 3735], "1068": [3821, 3820, 3822], "984": [3531, 3530, 3532, 3529], "1019": [3669, 3672, 3671, 3670], "1021": [3677, 3679, 3680, 3678], "1064": [3808, 3810, 3809], "986": [3539, 3537, 3540, 3538], "992": [3563, 3564, 3562, 3561], "1035": [3723, 3721, 3722], "1032": [3712, 3713, 3714], "1072": [3834, 3833, 3832], "1041": [3741, 3740, 3739], "1043": [3747, 3745, 3746], "1053": [3775, 3777, 3776], "991": [3557, 3559, 3558, 3560], "1011": [3640, 3639, 3637, 3638], "1042": [3742, 3743, 3744], "980": [3516, 3514, 3515, 3513], "1027": [3699, 3697, 3698], "1034": [3719, 3718, 3720], "1057": [3789, 3788, 3787], "1046": [3754, 3756, 3755], "1003": [3606, 3607, 3608, 3605], "1030": [3706, 3707, 3708], "1051": [3769, 3770, 3771], "974": [3492, 3489, 3490, 3491], "993": [3565, 3567, 3566, 3568], "990": [3555, 3554, 3553, 3556], "1056": [3784, 3785, 3786], "1010": [3635, 3634, 3636, 3633], "1001": [3599, 3598, 3600, 3597], "1007": [3623, 3622, 3624, 3621], "1065": [3812, 3813, 3811], "988": [3548, 3545, 3547, 3546], "998": [3588, 3586, 3587, 3585], "987": [3541, 3544, 3543, 3542], "1040": [3738, 3737, 3736], "976": [3498, 3497, 3500, 3499], "1016": [3659, 3660, 3657, 3658], "981": [3518, 3517, 3520, 3519], "1031": [3709, 3711, 3710], "973": [3485, 3486, 3487, 3488], "1029": [3703, 3704, 3705], "1033": [3717, 3715, 3716], "1050": [3767, 3766, 3768], "1002": [3601, 3603, 3604, 3602], "1025": [3692, 3691, 3693], "1058": [3792, 3790, 3791], "1023": [3685, 3687, 3686], "1015": [3653, 3654, 3656, 3655], "977": [3502, 3503, 3501, 3504], "1038": [3730, 3731, 3732], "999": [3592, 3591, 3590, 3589], "1061": [3801, 3799, 3800], "1049": [3765, 3764, 3763], "1013": [3646, 3645, 3648, 3647], "1054": [3780, 3779, 3778], "996": [3578, 3579, 3580, 3577], "1045": [3753, 3751, 3752]}
35	SESSION-7-12-1782041094	7	12	YucyHXZhPInw19OHqY1csk9tjHp1caZm	in_progress	2026-06-21 04:24:54.977884	2026-06-21 04:25:09.306801	\N	f	1	0	0	1	0	0	\N	\N	2026-06-21 04:24:54.977884	2026-06-21 04:25:09.306801	\N	\N
42	SESSION-12-10-1782364705	12	10	8M1HC796mtiZWN0EbBnSqNwwIKFfQboR	submitted	2026-06-24 22:18:25.198335	2026-06-24 22:19:26.457016	2026-06-24 22:19:26.354228	f	1	0	0	0	0	0	\N	\N	2026-06-24 22:18:25.199334	2026-06-24 22:19:26.457016	\N	\N
\.


--
-- TOC entry 5108 (class 0 OID 17667)
-- Dependencies: 230
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exams (id, title, code, description, subject, class_id, created_by, passcode, show_results_immediately, allow_review, show_correct_answers, allow_student_view_result, total_questions, total_marks, pass_marks, duration_minutes, start_date, end_date, published, published_at, shuffle_questions, shuffle_options, randomize_per_student, enable_proctoring, enable_webcam, enable_tab_detection, enable_copy_paste_prevention, is_active, is_deleted, created_at, updated_at) FROM stdin;
13	First Term Exams	J3RWURPKN6		Mathematics	3	11	12345	f	t	f	t	100	100	40	4	2026-06-24 11:23:00	2026-07-03 11:23:00	t	2026-06-30 20:38:08.421566	t	t	t	t	f	t	t	t	f	2026-06-25 18:24:30.934523	2026-06-30 20:38:08.421566
8	FIRST TERM	AGL8XUA6IH		Mathematics	3	11	12345	f	t	f	t	30	60	15	60	2026-06-18 14:29:00	2026-06-25 14:29:00	t	2026-06-20 21:30:37.094473	t	t	f	t	f	t	t	t	f	2026-06-20 21:29:46.811902	2026-06-20 21:30:37.095474
7	Practice	0AKH5SJ94R		Mathematics	3	11	12345	f	t	f	t	100	200	50	5	2026-06-19 13:30:00	2026-06-23 13:30:00	t	2026-06-21 13:25:09.471271	f	f	t	t	f	t	t	t	f	2026-06-20 20:31:18.213554	2026-06-21 13:25:09.473269
9	Third Term Exam	XVK2WTY4TJ		Mathematics	3	11	12345	f	t	f	t	50	50	20	5	2026-06-23 14:39:00	2026-07-01 14:39:00	f	\N	t	t	t	t	f	t	t	t	t	2026-06-24 21:40:04.119572	2026-06-24 21:50:34.644598
10	First Term Examination	M4YU7UEGH2		Mathematics	3	11	12345	f	t	f	t	20	20	20	60	2026-06-23 14:51:00	2026-07-09 14:51:00	f	\N	t	t	t	t	f	t	t	t	t	2026-06-24 21:51:31.521254	2026-06-24 21:53:50.423459
11	FIRST TERM EXAM	CII2LGQ6ON		Mathematics	3	11	12345	f	t	f	t	70	70	20	60	2026-06-23 14:54:00	2026-07-03 14:54:00	f	\N	t	t	t	t	f	t	t	t	t	2026-06-24 21:54:36.126584	2026-06-24 22:02:39.206084
12	Third Term Exam	TO0QWQDESL		Mathematics	3	11	12345	f	t	f	t	50	50	25	10	2026-06-23 15:03:00	2026-07-10 15:03:00	t	2026-06-24 22:08:41.204955	t	t	f	t	f	t	t	t	f	2026-06-24 22:04:00.653707	2026-06-24 22:17:28.917801
\.


--
-- TOC entry 5121 (class 0 OID 17827)
-- Dependencies: 243
-- Data for Name: proctoring_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proctoring_logs (id, exam_session_id, exam_id, student_id, event_type, violation_type, severity, details, "timestamp") FROM stdin;
127	42	12	10	tab_switch	tab_switch	medium	{"count": 1, "timestamp": "2026-06-24T22:19:26.456Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-06-24 22:19:26.457016
81	30	8	10	face_not_visible	face_not_visible	medium	{"duration": 5481, "warningCount": 1, "timestamp": "2026-06-20T21:31:27.009Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-06-20 21:31:27.011755
82	30	8	10	tab_switch	tab_switch	medium	{"count": 1, "timestamp": "2026-06-20T21:38:30.297Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-06-20 21:38:30.310536
128	43	13	10	tab_switch	tab_switch	medium	{"count": 1, "timestamp": "2026-06-30T20:40:01.161Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-06-30 20:40:01.166856
129	44	13	17	face_not_visible	face_not_visible	medium	{"duration": 39527, "warningCount": 1, "timestamp": "2026-07-03T05:00:16.140Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-07-03 05:00:16.145077
130	44	13	17	fullscreen_exit	fullscreen_exit	medium	{"count": 1, "timestamp": "2026-07-03T05:00:56.529Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-07-03 05:00:56.54038
131	44	13	17	tab_switch	tab_switch	medium	{"count": 1, "timestamp": "2026-07-03T05:00:57.386Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-07-03 05:00:57.381594
113	35	7	12	camera_access_denied	camera_access_denied	high	{"error": "Cannot read properties of undefined (reading 'getUserMedia')", "timestamp": "2026-06-20T20:26:37.066Z", "userAgent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36", "screenResolution": "360x806"}	2026-06-21 04:25:00.259849
114	35	7	12	tab_switch	tab_switch	medium	{"count": 1, "timestamp": "2026-06-20T20:26:46.108Z", "userAgent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36", "screenResolution": "360x806"}	2026-06-21 04:25:09.306801
122	39	7	12	camera_access_denied	camera_access_denied	high	{"error": "Cannot read properties of undefined (reading 'getUserMedia')", "timestamp": "2026-06-21T05:27:26.408Z", "userAgent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36", "screenResolution": "360x806"}	2026-06-21 13:25:49.770216
123	39	7	12	tab_switch	tab_switch	medium	{"count": 1, "timestamp": "2026-06-21T05:27:39.006Z", "userAgent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36", "screenResolution": "360x806"}	2026-06-21 13:26:02.431234
124	40	7	10	face_not_visible	face_not_visible	medium	{"duration": 5051, "warningCount": 1, "timestamp": "2026-06-21T13:26:02.431Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-06-21 13:26:02.495925
125	40	7	10	tab_switch	tab_switch	medium	{"count": 1, "timestamp": "2026-06-21T13:27:46.671Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-06-21 13:27:46.672387
\.


--
-- TOC entry 5132 (class 0 OID 84361)
-- Dependencies: 254
-- Data for Name: promotion_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_history (id, student_id, from_class_id, to_class_id, session_name, promotion_type, promoted_by, note, created_at) FROM stdin;
\.


--
-- TOC entry 5117 (class 0 OID 17780)
-- Dependencies: 239
-- Data for Name: question_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question_options (id, question_id, option_text, option_label, is_correct, latex_formula, created_at) FROM stdin;
1885	551	Central Processing Unit	A	t	\N	2026-06-20 20:33:31.883922
1886	551	Computer Processing Utility	B	f	\N	2026-06-20 20:33:31.883922
1887	551	Core Processing Unit	C	f	\N	2026-06-20 20:33:31.883922
1888	551	Central Program Utility	D	f	\N	2026-06-20 20:33:31.883922
1889	552	RAM	A	f	\N	2026-06-20 20:33:31.900861
1890	552	Hard Drive	B	f	\N	2026-06-20 20:33:31.900861
1891	552	CPU	C	t	\N	2026-06-20 20:33:31.900861
1892	552	Monitor	D	f	\N	2026-06-20 20:33:31.900861
1893	553	Permanent data storage	A	f	\N	2026-06-20 20:33:31.917373
1894	553	Running the operating system	B	f	\N	2026-06-20 20:33:31.917373
1895	553	Temporary data storage	C	t	\N	2026-06-20 20:33:31.917373
1896	553	Displaying graphics	D	f	\N	2026-06-20 20:33:31.917373
1897	554	Monitor	A	f	\N	2026-06-20 20:33:31.917373
1898	554	Printer	B	f	\N	2026-06-20 20:33:31.917373
1899	554	Keyboard	C	t	\N	2026-06-20 20:33:31.917373
1900	554	Speaker	D	f	\N	2026-06-20 20:33:31.917373
1901	555	Keyboard	A	f	\N	2026-06-20 20:33:31.917373
1902	555	Scanner	B	f	\N	2026-06-20 20:33:31.917373
1903	555	Mouse	C	f	\N	2026-06-20 20:33:31.917373
1904	555	Printer	D	t	\N	2026-06-20 20:33:31.917373
1905	556	USB Flash Drive	A	f	\N	2026-06-20 20:33:31.917373
1906	556	CD-ROM	B	f	\N	2026-06-20 20:33:31.917373
1907	556	Hard Disk Drive	C	t	\N	2026-06-20 20:33:31.917373
1908	556	Floppy Disk	D	f	\N	2026-06-20 20:33:31.917373
1909	557	Application software	A	f	\N	2026-06-20 20:33:31.933837
1910	557	System software	B	t	\N	2026-06-20 20:33:31.933837
1911	557	Utility software	C	f	\N	2026-06-20 20:33:31.933837
1912	557	Programming software	D	f	\N	2026-06-20 20:33:31.933837
1913	558	Windows OS	A	f	\N	2026-06-20 20:33:31.934263
1914	558	BIOS	B	f	\N	2026-06-20 20:33:31.934263
1915	558	Microsoft Word	C	t	\N	2026-06-20 20:33:31.934263
1916	558	Device Driver	D	f	\N	2026-06-20 20:33:31.934263
1917	559	Random Output Memory	A	f	\N	2026-06-20 20:33:31.934263
1918	559	Read Only Memory	B	t	\N	2026-06-20 20:33:31.934263
1919	559	Rewritable Output Media	C	f	\N	2026-06-20 20:33:31.934263
1920	559	Read Open Memory	D	f	\N	2026-06-20 20:33:31.934263
1921	560	Gigabytes	A	f	\N	2026-06-20 20:33:31.934263
1922	560	Megapixels	B	f	\N	2026-06-20 20:33:31.934263
1923	560	Gigahertz	C	t	\N	2026-06-20 20:33:31.934263
1924	560	Terabytes	D	f	\N	2026-06-20 20:33:31.934263
1925	561	Ctrl+P	A	f	\N	2026-06-20 20:33:31.934263
1926	561	Ctrl+S	B	t	\N	2026-06-20 20:33:31.934263
1927	561	Ctrl+Z	C	f	\N	2026-06-20 20:33:31.934263
1928	561	Ctrl+C	D	f	\N	2026-06-20 20:33:31.934263
1929	562	#	A	f	\N	2026-06-20 20:33:31.95072
1930	562	@	B	f	\N	2026-06-20 20:33:31.95072
1931	562	=	C	t	\N	2026-06-20 20:33:31.95072
1932	562	$	D	f	\N	2026-06-20 20:33:31.95072
1933	563	Finds the average	A	f	\N	2026-06-20 20:33:31.95072
1934	563	Adds all selected values	B	t	\N	2026-06-20 20:33:31.95072
1935	563	Counts filled cells	C	f	\N	2026-06-20 20:33:31.95072
1936	563	Finds the highest value	D	f	\N	2026-06-20 20:33:31.95072
1937	564	Sorts data alphabetically	A	f	\N	2026-06-20 20:33:31.95072
1938	564	Sends personalized letters to multiple recipients	B	t	\N	2026-06-20 20:33:31.95072
1939	564	Creates graphs	C	f	\N	2026-06-20 20:33:31.95072
1940	564	Formats tables	D	f	\N	2026-06-20 20:33:31.95072
1941	565	Delete files automatically	A	f	\N	2026-06-20 20:33:31.95072
1942	565	Automate repetitive tasks	B	t	\N	2026-06-20 20:33:31.95072
1943	565	Connect to the internet	C	f	\N	2026-06-20 20:33:31.95072
1944	565	Format hard drives	D	f	\N	2026-06-20 20:33:31.95072
1945	566	A type of chart	A	f	\N	2026-06-20 20:33:31.95072
1946	566	A tool to summarize and analyze large data	B	t	\N	2026-06-20 20:33:31.95072
1947	566	A formula for multiplication	C	f	\N	2026-06-20 20:33:31.95072
1948	566	A database table	D	f	\N	2026-06-20 20:33:31.95072
1949	567	SUM	A	f	\N	2026-06-20 20:33:31.967489
1950	567	MAX	B	f	\N	2026-06-20 20:33:31.967489
1951	567	AVERAGE	C	t	\N	2026-06-20 20:33:31.967489
1952	567	COUNT	D	f	\N	2026-06-20 20:33:31.967489
1953	568	.xls	A	f	\N	2026-06-20 20:33:31.967489
1954	568	.ppt	B	f	\N	2026-06-20 20:33:31.967489
1955	568	.docx	C	t	\N	2026-06-20 20:33:31.967489
1956	568	.pdf	D	f	\N	2026-06-20 20:33:31.967489
1957	569	Microsoft Excel	A	f	\N	2026-06-20 20:33:31.967489
1958	569	Microsoft Access	B	t	\N	2026-06-20 20:33:31.967489
1959	569	Microsoft Word	C	f	\N	2026-06-20 20:33:31.967489
1960	569	Notepad	D	f	\N	2026-06-20 20:33:31.967489
1961	570	A key used to lock the database	A	f	\N	2026-06-20 20:33:31.967489
1962	570	A unique identifier for each record	B	t	\N	2026-06-20 20:33:31.967489
1963	570	A password for the database	C	f	\N	2026-06-20 20:33:31.967489
1964	570	A foreign table link	D	f	\N	2026-06-20 20:33:31.967489
1965	571	Large Area Network	A	f	\N	2026-06-20 20:33:31.967489
1966	571	Local Area Network	B	t	\N	2026-06-20 20:33:31.967489
1967	571	Light Area Network	C	f	\N	2026-06-20 20:33:31.967489
1968	571	Linked Access Node	D	f	\N	2026-06-20 20:33:31.967489
1969	572	LAN	A	f	\N	2026-06-20 20:33:31.983924
1970	572	MAN	B	f	\N	2026-06-20 20:33:31.983924
1971	572	PAN	C	f	\N	2026-06-20 20:33:31.983924
1972	572	WAN	D	t	\N	2026-06-20 20:33:31.983924
1973	573	Multiple Access Node	A	f	\N	2026-06-20 20:33:31.983924
1974	573	Metropolitan Area Network	B	t	\N	2026-06-20 20:33:31.983924
1975	573	Managed Access Network	C	f	\N	2026-06-20 20:33:31.983924
1976	573	Main Area Node	D	f	\N	2026-06-20 20:33:31.983924
1977	574	Switch	A	f	\N	2026-06-20 20:33:31.983924
1978	574	Hub	B	f	\N	2026-06-20 20:33:31.983924
1979	574	Router	C	t	\N	2026-06-20 20:33:31.983924
1980	574	Repeater	D	f	\N	2026-06-20 20:33:31.983924
1981	575	Layer 1 – Physical	A	f	\N	2026-06-20 20:33:31.983924
1982	575	Layer 2 – Data Link	B	t	\N	2026-06-20 20:33:31.983924
1983	575	Layer 3 – Network	C	f	\N	2026-06-20 20:33:31.983924
1984	575	Layer 4 – Transport	D	f	\N	2026-06-20 20:33:31.983924
1985	576	Router	A	f	\N	2026-06-20 20:33:31.983924
1986	576	Switch	B	f	\N	2026-06-20 20:33:31.983924
1987	576	Hub	C	t	\N	2026-06-20 20:33:31.983924
1988	576	Firewall	D	f	\N	2026-06-20 20:33:31.983924
1989	577	Speed up internet connection	A	f	\N	2026-06-20 20:33:31.999409
1990	577	Block unauthorized network access	B	t	\N	2026-06-20 20:33:31.999409
1991	577	Store network data	C	f	\N	2026-06-20 20:33:31.999409
1992	577	Assign IP addresses	D	f	\N	2026-06-20 20:33:31.999409
1993	578	Copper wire	A	f	\N	2026-06-20 20:33:32.004406
1994	578	Coaxial cable	B	f	\N	2026-06-20 20:33:32.004406
1995	578	Fibre optic cable	C	t	\N	2026-06-20 20:33:32.004406
1996	578	Radio waves	D	f	\N	2026-06-20 20:33:32.004406
1997	579	Fibre optic cables	A	f	\N	2026-06-20 20:33:32.007404
1998	579	Infrared light	B	f	\N	2026-06-20 20:33:32.007404
1999	579	Radio waves	C	t	\N	2026-06-20 20:33:32.007404
2000	579	Telephone lines	D	f	\N	2026-06-20 20:33:32.007404
2001	580	Ring	A	f	\N	2026-06-20 20:33:32.009402
2002	580	Bus	B	f	\N	2026-06-20 20:33:32.009402
2003	580	Star	C	t	\N	2026-06-20 20:33:32.009402
2004	580	Mesh	D	f	\N	2026-06-20 20:33:32.009402
2005	581	5	A	f	\N	2026-06-20 20:33:32.012401
2006	581	6	B	f	\N	2026-06-20 20:33:32.012401
2007	581	7	C	t	\N	2026-06-20 20:33:32.012401
2008	581	8	D	f	\N	2026-06-20 20:33:32.012401
2009	582	Data Link Layer	A	f	\N	2026-06-20 20:33:32.016547
2010	582	Physical Layer	B	t	\N	2026-06-20 20:33:32.016547
2011	582	Network Layer	C	f	\N	2026-06-20 20:33:32.016547
2012	582	Application Layer	D	f	\N	2026-06-20 20:33:32.016547
2013	583	Data encryption	A	f	\N	2026-06-20 20:33:32.016547
2014	583	Logical addressing and routing	B	t	\N	2026-06-20 20:33:32.016547
2015	583	Physical data transmission	C	f	\N	2026-06-20 20:33:32.016547
2016	583	Session management	D	f	\N	2026-06-20 20:33:32.016547
2017	584	Network Layer	A	f	\N	2026-06-20 20:33:32.016547
2018	584	Data Link Layer	B	f	\N	2026-06-20 20:33:32.016547
2019	584	Transport Layer	C	t	\N	2026-06-20 20:33:32.016547
2020	584	Session Layer	D	f	\N	2026-06-20 20:33:32.016547
2021	585	Application Layer	A	f	\N	2026-06-20 20:33:32.016547
2022	585	Presentation Layer	B	t	\N	2026-06-20 20:33:32.016547
2023	585	Session Layer	C	f	\N	2026-06-20 20:33:32.016547
2024	585	Transport Layer	D	f	\N	2026-06-20 20:33:32.016547
2025	586	Routing packets	A	f	\N	2026-06-20 20:33:32.016547
2026	586	Managing and controlling connections between computers	B	t	\N	2026-06-20 20:33:32.016547
2027	586	Converting data to bits	C	f	\N	2026-06-20 20:33:32.016547
2028	586	Error detection in frames	D	f	\N	2026-06-20 20:33:32.016547
2029	587	Bit transmission	A	f	\N	2026-06-20 20:33:32.03334
2030	587	Routing	B	f	\N	2026-06-20 20:33:32.03334
2031	587	Providing network services to end users	C	t	\N	2026-06-20 20:33:32.03334
2032	587	Error correction	D	f	\N	2026-06-20 20:33:32.03334
2033	588	Layer 1	A	f	\N	2026-06-20 20:33:32.03334
2034	588	Layer 2	B	f	\N	2026-06-20 20:33:32.03334
2035	588	Layer 3	C	t	\N	2026-06-20 20:33:32.03334
2036	588	Layer 4	D	f	\N	2026-06-20 20:33:32.03334
2037	589	Physical Layer	A	f	\N	2026-06-20 20:33:32.03334
2038	589	Data Link Layer	B	t	\N	2026-06-20 20:33:32.03334
2039	589	Network Layer	C	f	\N	2026-06-20 20:33:32.03334
2040	589	Transport Layer	D	f	\N	2026-06-20 20:33:32.03334
2041	590	Session Layer	A	f	\N	2026-06-20 20:33:32.03334
2042	590	Transport Layer	B	f	\N	2026-06-20 20:33:32.03334
2043	590	Presentation Layer	C	t	\N	2026-06-20 20:33:32.03334
2044	590	Network Layer	D	f	\N	2026-06-20 20:33:32.03334
2045	591	Transfer Communication Protocol	A	f	\N	2026-06-20 20:33:32.03334
2046	591	Transmission Control Protocol	B	t	\N	2026-06-20 20:33:32.03334
2047	591	Transport Connection Program	C	f	\N	2026-06-20 20:33:32.03334
2048	591	Terminal Control Process	D	f	\N	2026-06-20 20:33:32.03334
2049	592	HTTP	A	f	\N	2026-06-20 20:33:32.051533
2050	592	FTP	B	f	\N	2026-06-20 20:33:32.051533
2051	592	IP	C	t	\N	2026-06-20 20:33:32.051533
2052	592	TCP	D	f	\N	2026-06-20 20:33:32.051533
2053	593	Hyper Text Transfer Protocol	A	t	\N	2026-06-20 20:33:32.055529
2054	593	High Transfer Text Program	B	f	\N	2026-06-20 20:33:32.055529
2055	593	Hyper Tool Transfer Process	C	f	\N	2026-06-20 20:33:32.055529
2056	593	Home Text Transfer Protocol	D	f	\N	2026-06-20 20:33:32.055529
2057	594	FTP	A	f	\N	2026-06-20 20:33:32.059528
2058	594	HTTP	B	f	\N	2026-06-20 20:33:32.059528
2059	594	HTTPS	C	t	\N	2026-06-20 20:33:32.059528
2060	594	SMTP	D	f	\N	2026-06-20 20:33:32.059528
2061	595	Assigns IP addresses automatically	A	f	\N	2026-06-20 20:33:32.062526
2062	595	Translates domain names to IP addresses	B	t	\N	2026-06-20 20:33:32.062526
2063	595	Encrypts web traffic	C	f	\N	2026-06-20 20:33:32.062526
2064	595	Filters spam emails	D	f	\N	2026-06-20 20:33:32.062526
2065	596	Dynamic Host Control Protocol	A	f	\N	2026-06-20 20:33:32.066044
2066	596	Dynamic Host Configuration Protocol	B	t	\N	2026-06-20 20:33:32.066044
2067	596	Direct Host Connection Program	C	f	\N	2026-06-20 20:33:32.066044
2068	596	Data Handling Control Process	D	f	\N	2026-06-20 20:33:32.066044
2069	597	FTP	A	f	\N	2026-06-20 20:33:32.066354
2070	597	HTTP	B	f	\N	2026-06-20 20:33:32.066354
2071	597	SMTP	C	t	\N	2026-06-20 20:33:32.066354
2072	597	DHCP	D	f	\N	2026-06-20 20:33:32.066354
2073	598	Is slower than TCP	A	f	\N	2026-06-20 20:33:32.066354
2074	598	Guarantees data delivery	B	f	\N	2026-06-20 20:33:32.066354
2075	598	Does not guarantee data delivery	C	t	\N	2026-06-20 20:33:32.066354
2076	598	Requires a connection first	D	f	\N	2026-06-20 20:33:32.066354
2077	599	16	A	f	\N	2026-06-20 20:33:32.066354
2078	599	32	B	t	\N	2026-06-20 20:33:32.066354
2079	599	64	C	f	\N	2026-06-20 20:33:32.066354
2080	599	128	D	f	\N	2026-06-20 20:33:32.066354
2081	600	IPv4 was too slow	A	f	\N	2026-06-20 20:33:32.066354
2082	600	IPv4 addresses were running out	B	t	\N	2026-06-20 20:33:32.066354
2083	600	IPv6 is cheaper	C	f	\N	2026-06-20 20:33:32.066354
2084	600	IPv4 was insecure	D	f	\N	2026-06-20 20:33:32.066354
2085	601	Internet Speed Provider	A	f	\N	2026-06-20 20:33:32.08284
2086	601	Internet Service Provider	B	t	\N	2026-06-20 20:33:32.08284
2087	601	Internal System Protocol	C	f	\N	2026-06-20 20:33:32.08284
2088	601	Integrated Server Program	D	f	\N	2026-06-20 20:33:32.08284
2089	602	Google Drive	A	f	\N	2026-06-20 20:33:32.085836
2090	602	Microsoft Access	B	f	\N	2026-06-20 20:33:32.085836
2091	602	Google Chrome	C	t	\N	2026-06-20 20:33:32.085836
2092	602	Windows Explorer	D	f	\N	2026-06-20 20:33:32.085836
2093	603	A device that connects to the internet	A	f	\N	2026-06-20 20:33:32.089835
2094	603	Software that searches for information on the web	B	t	\N	2026-06-20 20:33:32.089835
2095	603	A type of web browser plugin	C	f	\N	2026-06-20 20:33:32.089835
2096	603	A network security tool	D	f	\N	2026-06-20 20:33:32.089835
2097	604	Universal Resource Locator	A	f	\N	2026-06-20 20:33:32.092833
2098	604	Uniform Resource Locator	B	t	\N	2026-06-20 20:33:32.092833
2099	604	United Resource Link	C	f	\N	2026-06-20 20:33:32.092833
2100	604	Universal Remote Link	D	f	\N	2026-06-20 20:33:32.092833
2101	605	USB flash drive	A	f	\N	2026-06-20 20:33:32.095831
2102	605	External hard drive	B	f	\N	2026-06-20 20:33:32.095831
2103	605	Google Drive	C	t	\N	2026-06-20 20:33:32.095831
2104	605	DVD-ROM	D	f	\N	2026-06-20 20:33:32.095831
2105	606	It is always faster	A	f	\N	2026-06-20 20:33:32.099661
2106	606	Data can be accessed from anywhere with internet	B	t	\N	2026-06-20 20:33:32.099661
2107	606	It never requires internet	C	f	\N	2026-06-20 20:33:32.099661
2108	606	It stores data permanently without power	D	f	\N	2026-06-20 20:33:32.099661
2109	607	File Transfer Protocol	A	t	\N	2026-06-20 20:33:32.102658
2110	607	Fast Transfer Program	B	f	\N	2026-06-20 20:33:32.102658
2111	607	File Text Protocol	C	f	\N	2026-06-20 20:33:32.102658
2112	607	Fibre Transfer Process	D	f	\N	2026-06-20 20:33:32.102658
2113	608	Writing emails in all caps	A	f	\N	2026-06-20 20:33:32.106656
2114	608	Using appropriate language and format in emails	B	t	\N	2026-06-20 20:33:32.106656
2115	608	Sending chain emails	C	f	\N	2026-06-20 20:33:32.106656
2116	608	Ignoring reply-all messages	D	f	\N	2026-06-20 20:33:32.106656
2117	609	A type of hardware	A	f	\N	2026-06-20 20:33:32.109653
2118	609	Software designed to harm a computer system	B	t	\N	2026-06-20 20:33:32.109653
2119	609	A network protocol	C	f	\N	2026-06-20 20:33:32.109653
2120	609	A programming language	D	f	\N	2026-06-20 20:33:32.109653
2121	610	Antivirus	A	f	\N	2026-06-20 20:33:32.112651
2122	610	Firewall	B	f	\N	2026-06-20 20:33:32.112651
2123	610	Trojan Horse	C	t	\N	2026-06-20 20:33:32.112651
2124	610	Encryption	D	f	\N	2026-06-20 20:33:32.112651
2125	611	A method of speeding up internet	A	f	\N	2026-06-20 20:33:32.114926
2126	611	A cyber attack that tricks users into revealing personal information	B	t	\N	2026-06-20 20:33:32.114926
2127	611	A type of firewall	C	f	\N	2026-06-20 20:33:32.114926
2128	611	A form of data compression	D	f	\N	2026-06-20 20:33:32.114926
2129	612	Only letters	A	f	\N	2026-06-20 20:33:32.114926
2130	612	Only numbers	B	f	\N	2026-06-20 20:33:32.114926
2131	612	A mix of letters, numbers, and special characters	C	t	\N	2026-06-20 20:33:32.114926
2132	612	Your date of birth	D	f	\N	2026-06-20 20:33:32.114926
2133	613	Speed up the computer	A	f	\N	2026-06-20 20:33:32.114926
2134	613	Detect and remove malicious software	B	t	\N	2026-06-20 20:33:32.114926
2135	613	Create backups	C	f	\N	2026-06-20 20:33:32.114926
2136	613	Manage network settings	D	f	\N	2026-06-20 20:33:32.114926
2137	614	Stealing passwords from a website	A	f	\N	2026-06-20 20:33:32.114926
2138	614	Overloading a server with excessive traffic to make it unavailable	B	t	\N	2026-06-20 20:33:32.114926
2139	614	Installing spyware on a computer	C	f	\N	2026-06-20 20:33:32.114926
2140	614	Sending phishing emails	D	f	\N	2026-06-20 20:33:32.114926
2141	615	Deletes viruses	A	f	\N	2026-06-20 20:33:32.114926
2142	615	Adds an extra layer of security beyond a password	B	t	\N	2026-06-20 20:33:32.114926
2143	615	Speeds up login	C	f	\N	2026-06-20 20:33:32.114926
2144	615	Encrypts your hard drive	D	f	\N	2026-06-20 20:33:32.114926
2145	616	Speeds up your computer	A	f	\N	2026-06-20 20:33:32.133144
2146	616	Locks or encrypts your files and demands payment	B	t	\N	2026-06-20 20:33:32.133144
2147	616	Improves network speed	C	f	\N	2026-06-20 20:33:32.133144
2148	616	Backs up your data	D	f	\N	2026-06-20 20:33:32.133144
2149	617	General Data Protection Regulation	A	t	\N	2026-06-20 20:33:32.133144
2150	617	Global Digital Privacy Rights	B	f	\N	2026-06-20 20:33:32.133144
2151	617	Government Data Processing Rules	C	f	\N	2026-06-20 20:33:32.133144
2152	617	General Device Protection Registry	D	f	\N	2026-06-20 20:33:32.133144
2153	618	Physical bullying in schools	A	f	\N	2026-06-20 20:33:32.133144
2154	618	Bullying that takes place over digital devices and platforms	B	t	\N	2026-06-20 20:33:32.133144
2155	618	Hacking into social media accounts	C	f	\N	2026-06-20 20:33:32.133144
2156	618	Spreading viruses online	D	f	\N	2026-06-20 20:33:32.133144
2157	619	Sharing others' passwords	A	f	\N	2026-06-20 20:33:32.133144
2158	619	Posting harmful content anonymously	B	f	\N	2026-06-20 20:33:32.133144
2159	619	Respecting others' privacy online	C	t	\N	2026-06-20 20:33:32.133144
2160	619	Downloading pirated software	D	f	\N	2026-06-20 20:33:32.133144
2161	620	Increase internet speed	A	f	\N	2026-06-20 20:33:32.133144
2162	620	Protect individuals' personal information from misuse	B	t	\N	2026-06-20 20:33:32.133144
2163	620	Allow governments to monitor all internet activity	C	f	\N	2026-06-20 20:33:32.133144
2164	620	Block social media platforms	D	f	\N	2026-06-20 20:33:32.133144
2165	621	Hyper Text Markup Language	A	t	\N	2026-06-20 20:33:32.150477
2166	621	High Transfer Machine Language	B	f	\N	2026-06-20 20:33:32.150477
2167	621	Hyper Transfer Mode Link	C	f	\N	2026-06-20 20:33:32.150477
2168	621	Home Tool Markup Language	D	f	\N	2026-06-20 20:33:32.150477
2169	622	Adding database functionality	A	f	\N	2026-06-20 20:33:32.153471
2170	622	Controlling the style and layout of web pages	B	t	\N	2026-06-20 20:33:32.153471
2171	622	Writing server-side scripts	C	f	\N	2026-06-20 20:33:32.153471
2172	622	Securing web pages	D	f	\N	2026-06-20 20:33:32.153471
2173	623	<link>	A	f	\N	2026-06-20 20:33:32.15647
2174	623	<href>	B	f	\N	2026-06-20 20:33:32.15647
2175	623	<a>	C	t	\N	2026-06-20 20:33:32.15647
2176	623	<url>	D	f	\N	2026-06-20 20:33:32.15647
2177	624	A type of network cable	A	f	\N	2026-06-20 20:33:32.15947
2178	624	The address of a website on the Internet	B	t	\N	2026-06-20 20:33:32.15947
2179	624	A web browser	C	f	\N	2026-06-20 20:33:32.15947
2180	624	A type of server	D	f	\N	2026-06-20 20:33:32.15947
2181	625	Designing a website	A	f	\N	2026-06-20 20:33:32.162468
2182	625	Storing website files on a server accessible via the internet	B	t	\N	2026-06-20 20:33:32.162468
2183	625	Registering a domain name	C	f	\N	2026-06-20 20:33:32.162468
2184	625	Writing HTML code	D	f	\N	2026-06-20 20:33:32.162468
2185	626	A type of computer virus	A	f	\N	2026-06-20 20:33:32.165194
2186	626	A step-by-step solution to a problem	B	t	\N	2026-06-20 20:33:32.165194
2187	626	A programming language	C	f	\N	2026-06-20 20:33:32.165194
2188	626	A network protocol	D	f	\N	2026-06-20 20:33:32.165194
2189	627	Machine Code	A	f	\N	2026-06-20 20:33:32.168193
2190	627	Assembly Language	B	f	\N	2026-06-20 20:33:32.168193
2191	627	Python	C	t	\N	2026-06-20 20:33:32.168193
2192	627	Binary Code	D	f	\N	2026-06-20 20:33:32.168193
2193	628	Run the operating system	A	f	\N	2026-06-20 20:33:32.170191
2194	628	Store data that can change	B	t	\N	2026-06-20 20:33:32.170191
2195	628	Connect to the internet	C	f	\N	2026-06-20 20:33:32.170191
2196	628	Format documents	D	f	\N	2026-06-20 20:33:32.170191
2197	629	Rectangle	A	f	\N	2026-06-20 20:33:32.173189
2198	629	Oval	B	f	\N	2026-06-20 20:33:32.173189
2199	629	Diamond	C	t	\N	2026-06-20 20:33:32.173189
2200	629	Parallelogram	D	f	\N	2026-06-20 20:33:32.173189
2201	630	53	A	f	\N	2026-06-20 20:33:32.176188
2202	630	2	B	f	\N	2026-06-20 20:33:32.176188
2203	630	8	C	t	\N	2026-06-20 20:33:32.176188
2204	630	35	D	f	\N	2026-06-20 20:33:32.176188
2205	631	if statement	A	f	\N	2026-06-20 20:33:32.179185
2206	631	for loop	B	f	\N	2026-06-20 20:33:32.179185
2207	631	while loop	C	t	\N	2026-06-20 20:33:32.179185
2208	631	function	D	f	\N	2026-06-20 20:33:32.179185
2209	632	A type of variable	A	f	\N	2026-06-20 20:33:32.181584
2210	632	A reusable block of code	B	t	\N	2026-06-20 20:33:32.181584
2211	632	A loop structure	C	f	\N	2026-06-20 20:33:32.181584
2212	632	A data type	D	f	\N	2026-06-20 20:33:32.181584
2213	633	Repeats code a set number of times	A	f	\N	2026-06-20 20:33:32.181584
2214	633	Executes code only when a condition is true	B	t	\N	2026-06-20 20:33:32.181584
2215	633	Defines a function	C	f	\N	2026-06-20 20:33:32.181584
2216	633	Stores a value	D	f	\N	2026-06-20 20:33:32.181584
2217	634	A type of computer hardware	A	f	\N	2026-06-20 20:33:32.181584
2218	634	The simulation of human intelligence by machines	B	t	\N	2026-06-20 20:33:32.181584
2219	634	A programming language	C	f	\N	2026-06-20 20:33:32.181584
2220	634	A type of database	D	f	\N	2026-06-20 20:33:32.181584
2221	635	USB storage devices	A	f	\N	2026-06-20 20:33:32.181584
2222	635	Voice recognition systems like Siri	B	t	\N	2026-06-20 20:33:32.181584
2223	635	Cable networks	C	f	\N	2026-06-20 20:33:32.181584
2224	635	Keyboard input	D	f	\N	2026-06-20 20:33:32.181584
2225	636	Teaching humans to use computers	A	f	\N	2026-06-20 20:33:32.181584
2226	636	A system that learns from data to make predictions	B	t	\N	2026-06-20 20:33:32.181584
2227	636	A method of data encryption	C	f	\N	2026-06-20 20:33:32.181584
2228	636	A type of computer hardware	D	f	\N	2026-06-20 20:33:32.181584
2229	637	Deleting unwanted files	A	f	\N	2026-06-20 20:33:32.181584
2230	637	Gathering raw information for analysis	B	t	\N	2026-06-20 20:33:32.181584
2231	637	Designing user interfaces	C	f	\N	2026-06-20 20:33:32.181584
2232	637	Compressing data for storage	D	f	\N	2026-06-20 20:33:32.181584
2233	638	Software as a Service	A	t	\N	2026-06-20 20:33:32.199575
2234	638	System and Security	B	f	\N	2026-06-20 20:33:32.199575
2235	638	Storage and Sync	C	f	\N	2026-06-20 20:33:32.199575
2236	638	Server Application System	D	f	\N	2026-06-20 20:33:32.199575
2237	639	Internet as a System	A	f	\N	2026-06-20 20:33:32.199575
2238	639	Infrastructure as a Service	B	t	\N	2026-06-20 20:33:32.199575
2239	639	Integrated Application Software	C	f	\N	2026-06-20 20:33:32.199575
2240	639	Internet Application and Security	D	f	\N	2026-06-20 20:33:32.199575
2241	640	A type of antivirus software	A	f	\N	2026-06-20 20:33:32.199575
2242	640	A decentralized digital ledger of transactions	B	t	\N	2026-06-20 20:33:32.199575
2243	640	A cloud storage service	C	f	\N	2026-06-20 20:33:32.199575
2244	640	A programming language	D	f	\N	2026-06-20 20:33:32.199575
2245	641	Physical coins stored in a bank	A	f	\N	2026-06-20 20:33:32.199575
2246	641	A digital currency based on cryptographic technology	B	t	\N	2026-06-20 20:33:32.199575
2247	641	A type of credit card	C	f	\N	2026-06-20 20:33:32.199575
2248	641	Government-issued digital money	D	f	\N	2026-06-20 20:33:32.199575
2249	642	Hacking for financial gain	A	f	\N	2026-06-20 20:33:32.199575
2250	642	Legally testing systems to find and fix vulnerabilities	B	t	\N	2026-06-20 20:33:32.199575
2251	642	Spreading viruses for research	C	f	\N	2026-06-20 20:33:32.199575
2252	642	Accessing private data without permission	D	f	\N	2026-06-20 20:33:32.199575
2253	643	Electronic communication between offices	A	f	\N	2026-06-20 20:33:32.199575
2254	643	Buying and selling goods and services online	B	t	\N	2026-06-20 20:33:32.199575
2255	643	A type of social media platform	C	f	\N	2026-06-20 20:33:32.199575
2256	643	A hardware component for networking	D	f	\N	2026-06-20 20:33:32.199575
2257	644	Only Android	A	f	\N	2026-06-20 20:33:32.21811
2258	644	Only iOS	B	f	\N	2026-06-20 20:33:32.21811
2259	644	Both Android and iOS	C	t	\N	2026-06-20 20:33:32.21811
2260	644	Only Windows	D	f	\N	2026-06-20 20:33:32.21811
2261	645	Microsoft Word	A	f	\N	2026-06-20 20:33:32.221108
2262	645	Jumia	B	t	\N	2026-06-20 20:33:32.221108
2263	645	VLC Media Player	C	f	\N	2026-06-20 20:33:32.221108
2264	645	Adobe Photoshop	D	f	\N	2026-06-20 20:33:32.221108
2265	646	A single computer working alone	A	f	\N	2026-06-20 20:33:32.224109
2266	646	Two or more computers connected to share resources	B	t	\N	2026-06-20 20:33:32.224109
2267	646	A collection of software programs	C	f	\N	2026-06-20 20:33:32.224109
2268	646	A type of storage device	D	f	\N	2026-06-20 20:33:32.224109
2269	647	Assigns IP addresses	A	f	\N	2026-06-20 20:33:32.226107
2270	647	Regenerates and amplifies weak signals	B	t	\N	2026-06-20 20:33:32.226107
2271	647	Filters network traffic	C	f	\N	2026-06-20 20:33:32.226107
2272	647	Connects two different networks	D	f	\N	2026-06-20 20:33:32.226107
2273	648	Network Layer	A	f	\N	2026-06-20 20:33:32.229106
2274	648	Physical Layer	B	f	\N	2026-06-20 20:33:32.229106
2275	648	Transport Layer	C	t	\N	2026-06-20 20:33:32.229106
2276	648	Data Link Layer	D	f	\N	2026-06-20 20:33:32.229106
2277	649	The physical size of a network cable	A	f	\N	2026-06-20 20:33:32.231891
2278	649	The maximum data transfer rate of a network	B	t	\N	2026-06-20 20:33:32.231891
2279	649	The number of devices on a network	C	f	\N	2026-06-20 20:33:32.231891
2280	649	The security level of a network	D	f	\N	2026-06-20 20:33:32.231891
2281	650	Physical Layer	A	f	\N	2026-06-20 20:33:32.234889
2282	650	Network Layer	B	f	\N	2026-06-20 20:33:32.234889
2283	650	Data Link Layer	C	t	\N	2026-06-20 20:33:32.234889
2284	650	Transport Layer	D	f	\N	2026-06-20 20:33:32.234889
2285	651	Food	A	f	\N	2026-06-20 21:30:02.068459
2286	651	Sounds	B	t	\N	2026-06-20 21:30:02.068459
2287	651	Clothes	C	f	\N	2026-06-20 21:30:02.068459
2288	651	Books	D	f	\N	2026-06-20 21:30:02.068459
2289	652	It causes sickness	A	f	\N	2026-06-20 21:30:02.085151
2290	652	It entertains people	B	t	\N	2026-06-20 21:30:02.085151
2291	652	It destroys culture	C	f	\N	2026-06-20 21:30:02.085151
2292	652	It wastes time	D	f	\N	2026-06-20 21:30:02.085151
2293	653	Communication	A	t	\N	2026-06-20 21:30:02.118439
2294	653	Fighting	B	f	\N	2026-06-20 21:30:02.118439
2295	653	Sleeping only	C	f	\N	2026-06-20 21:30:02.118439
2296	653	Hiding	D	f	\N	2026-06-20 21:30:02.118439
2297	654	Culture	A	t	\N	2026-06-20 21:30:02.123437
2298	654	Farm	B	f	\N	2026-06-20 21:30:02.123437
2299	654	Market	C	f	\N	2026-06-20 21:30:02.123437
2300	654	Road	D	f	\N	2026-06-20 21:30:02.123437
2301	655	Traditional music	A	t	\N	2026-06-20 21:30:02.125466
2302	655	Mathematics	B	f	\N	2026-06-20 21:30:02.125466
2303	655	Science	C	f	\N	2026-06-20 21:30:02.125466
2304	655	Agriculture	D	f	\N	2026-06-20 21:30:02.125466
2305	656	Worship	A	t	\N	2026-06-20 21:30:02.125466
2306	656	Farming	B	f	\N	2026-06-20 21:30:02.125466
2307	656	Driving	C	f	\N	2026-06-20 21:30:02.125466
2308	656	Fishing	D	f	\N	2026-06-20 21:30:02.125466
2309	657	Percussion	A	t	\N	2026-06-20 21:30:02.133154
2310	657	Wind	B	f	\N	2026-06-20 21:30:02.133154
2311	657	String	C	f	\N	2026-06-20 21:30:02.133154
2312	657	Electronic	D	f	\N	2026-06-20 21:30:02.133154
2313	658	Flute	A	t	\N	2026-06-20 21:30:02.134316
2314	658	Spoon	B	f	\N	2026-06-20 21:30:02.134316
2315	658	Plate	C	f	\N	2026-06-20 21:30:02.134316
2316	658	Cup	D	f	\N	2026-06-20 21:30:02.134316
2317	659	Music	A	t	\N	2026-06-20 21:30:02.134316
2318	659	Water	B	f	\N	2026-06-20 21:30:02.134316
2319	659	Smoke	C	f	\N	2026-06-20 21:30:02.134316
2320	659	Fire	D	f	\N	2026-06-20 21:30:02.134316
2321	660	Flute	A	t	\N	2026-06-20 21:30:02.134316
2322	660	Drum	B	f	\N	2026-06-20 21:30:02.134316
2323	660	Guitar	C	f	\N	2026-06-20 21:30:02.134316
2324	660	Bell	D	f	\N	2026-06-20 21:30:02.134316
2325	661	Acting	A	t	\N	2026-06-20 21:30:02.134316
2326	661	Cooking	B	f	\N	2026-06-20 21:30:02.134316
2327	661	Reading only	C	f	\N	2026-06-20 21:30:02.134316
2328	661	Farming	D	f	\N	2026-06-20 21:30:02.134316
2329	662	Actor	A	t	\N	2026-06-20 21:30:02.134316
2330	662	Driver	B	f	\N	2026-06-20 21:30:02.134316
2331	662	Farmer	C	f	\N	2026-06-20 21:30:02.134316
2332	662	Trader	D	f	\N	2026-06-20 21:30:02.134316
2333	663	Plot	A	t	\N	2026-06-20 21:30:02.151232
2334	663	Farm	B	f	\N	2026-06-20 21:30:02.151232
2335	663	Road	C	f	\N	2026-06-20 21:30:02.151232
2336	663	Class	D	f	\N	2026-06-20 21:30:02.151232
2337	664	Character	A	t	\N	2026-06-20 21:30:02.151232
2338	664	Table	B	f	\N	2026-06-20 21:30:02.151232
2339	664	Bag	C	f	\N	2026-06-20 21:30:02.151232
2340	664	Pencil	D	f	\N	2026-06-20 21:30:02.151232
2341	665	Stage	A	t	\N	2026-06-20 21:30:02.151232
2342	665	Garden	B	f	\N	2026-06-20 21:30:02.151232
2343	665	Market	C	f	\N	2026-06-20 21:30:02.151232
2344	665	Kitchen	D	f	\N	2026-06-20 21:30:02.151232
2345	666	Way of life	A	t	\N	2026-06-20 21:30:02.151232
2346	666	Food only	B	f	\N	2026-06-20 21:30:02.151232
2347	666	Clothes only	C	f	\N	2026-06-20 21:30:02.151232
2348	666	Houses only	D	f	\N	2026-06-20 21:30:02.151232
2349	667	Value	A	t	\N	2026-06-20 21:30:02.167058
2350	667	Toy	B	f	\N	2026-06-20 21:30:02.167058
2351	667	Instrument	C	f	\N	2026-06-20 21:30:02.167058
2352	667	Food	D	f	\N	2026-06-20 21:30:02.167058
2353	668	Value	A	t	\N	2026-06-20 21:30:02.167807
2354	668	Dance	B	f	\N	2026-06-20 21:30:02.167807
2355	668	Festival	C	f	\N	2026-06-20 21:30:02.167807
2356	668	Costume	D	f	\N	2026-06-20 21:30:02.167807
2357	669	Identity	A	t	\N	2026-06-20 21:30:02.167807
2358	669	Toys	B	f	\N	2026-06-20 21:30:02.167807
2359	669	Roads	C	f	\N	2026-06-20 21:30:02.167807
2360	669	Vehicles	D	f	\N	2026-06-20 21:30:02.167807
2361	670	Celebration	A	t	\N	2026-06-20 21:30:02.167807
2362	670	Punishment	B	f	\N	2026-06-20 21:30:02.167807
2363	670	Examination	C	f	\N	2026-06-20 21:30:02.167807
2364	670	Work	D	f	\N	2026-06-20 21:30:02.167807
2365	671	Unity	A	t	\N	2026-06-20 21:30:02.167807
2366	671	Quarrel	B	f	\N	2026-06-20 21:30:02.167807
2367	671	Hatred	C	f	\N	2026-06-20 21:30:02.167807
2368	671	Laziness	D	f	\N	2026-06-20 21:30:02.167807
2369	672	Folk dance	A	t	\N	2026-06-20 21:30:02.18448
2370	672	Football only	B	f	\N	2026-06-20 21:30:02.18448
2371	672	Sleeping	C	f	\N	2026-06-20 21:30:02.18448
2372	672	Reading	D	f	\N	2026-06-20 21:30:02.18448
2373	673	Storytelling	A	t	\N	2026-06-20 21:30:02.18448
2374	673	Typing	B	f	\N	2026-06-20 21:30:02.18448
2375	673	Printing	C	f	\N	2026-06-20 21:30:02.18448
2376	673	Sewing	D	f	\N	2026-06-20 21:30:02.18448
2377	674	Heritage	A	t	\N	2026-06-20 21:30:02.18448
2378	674	Vehicles	B	f	\N	2026-06-20 21:30:02.18448
2379	674	Roads	C	f	\N	2026-06-20 21:30:02.18448
2380	674	Computers	D	f	\N	2026-06-20 21:30:02.18448
2381	675	Ideas and feelings	A	t	\N	2026-06-20 21:30:02.18448
2382	675	Hunger only	B	f	\N	2026-06-20 21:30:02.18448
2383	675	Anger only	C	f	\N	2026-06-20 21:30:02.18448
2384	675	Sleep	D	f	\N	2026-06-20 21:30:02.18448
2385	676	Valuing and enjoying it	A	t	\N	2026-06-20 21:30:02.18448
2386	676	Destroying it	B	f	\N	2026-06-20 21:30:02.18448
2387	676	Ignoring it	C	f	\N	2026-06-20 21:30:02.18448
2388	676	Hiding it	D	f	\N	2026-06-20 21:30:02.18448
2389	677	Paint	A	t	\N	2026-06-20 21:30:02.200875
2390	677	Rice	B	f	\N	2026-06-20 21:30:02.200875
2391	677	Salt	C	f	\N	2026-06-20 21:30:02.200875
2392	677	Water	D	f	\N	2026-06-20 21:30:02.200875
2393	678	Music	A	t	\N	2026-06-20 21:30:02.200875
2394	678	Silence	B	f	\N	2026-06-20 21:30:02.200875
2395	678	Sleep	C	f	\N	2026-06-20 21:30:02.200875
2396	678	Reading	D	f	\N	2026-06-20 21:30:02.200875
2397	679	String	A	t	\N	2026-06-20 21:30:02.200875
2398	679	Wind	B	f	\N	2026-06-20 21:30:02.200875
2399	679	Percussion	C	f	\N	2026-06-20 21:30:02.200875
2400	679	Brass	D	f	\N	2026-06-20 21:30:02.200875
2401	680	Teaching it to children	A	t	\N	2026-06-20 21:30:02.200875
2402	680	Forgetting it	B	f	\N	2026-06-20 21:30:02.200875
2403	680	Destroying artworks	C	f	\N	2026-06-20 21:30:02.200875
2404	680	Avoiding festivals	D	f	\N	2026-06-20 21:30:02.200875
2405	681	read	A	f	\N	2026-06-24 21:40:25.927507
2406	681	reading	B	f	\N	2026-06-24 21:40:25.927507
2407	681	to read	C	t	\N	2026-06-24 21:40:25.927507
2408	681	reads	D	f	\N	2026-06-24 21:40:25.927507
2409	682	have	A	f	\N	2026-06-24 21:40:26.114156
2410	682	had	B	t	\N	2026-06-24 21:40:26.114156
2411	682	has	C	f	\N	2026-06-24 21:40:26.114156
2412	682	having	D	f	\N	2026-06-24 21:40:26.114156
2413	683	for	A	f	\N	2026-06-24 21:40:26.126063
2414	683	since	B	t	\N	2026-06-24 21:40:26.126063
2415	683	from	C	f	\N	2026-06-24 21:40:26.126063
2416	683	by	D	f	\N	2026-06-24 21:40:26.126063
2417	684	was	A	f	\N	2026-06-24 21:40:26.132059
2418	684	were	B	t	\N	2026-06-24 21:40:26.132059
2419	684	is	C	f	\N	2026-06-24 21:40:26.132059
2420	684	has	D	f	\N	2026-06-24 21:40:26.132059
2421	685	in	A	f	\N	2026-06-24 21:40:26.134611
2422	685	at	B	t	\N	2026-06-24 21:40:26.134611
2423	685	on	C	f	\N	2026-06-24 21:40:26.134611
2424	685	into	D	f	\N	2026-06-24 21:40:26.134611
2425	686	in	A	t	\N	2026-06-24 21:40:26.134611
2426	686	on	B	f	\N	2026-06-24 21:40:26.134611
2427	686	at	C	f	\N	2026-06-24 21:40:26.134611
2428	686	for	D	f	\N	2026-06-24 21:40:26.134611
2429	687	are	A	f	\N	2026-06-24 21:40:26.134611
2430	687	were	B	f	\N	2026-06-24 21:40:26.134611
2431	687	is	C	t	\N	2026-06-24 21:40:26.134611
2432	687	have	D	f	\N	2026-06-24 21:40:26.134611
2433	688	than	A	t	\N	2026-06-24 21:40:26.153473
2434	688	then	B	f	\N	2026-06-24 21:40:26.153473
2435	688	that	C	f	\N	2026-06-24 21:40:26.153473
2436	688	as	D	f	\N	2026-06-24 21:40:26.153473
2437	689	escaped	A	f	\N	2026-06-24 21:40:26.153473
2438	689	had escaped	B	t	\N	2026-06-24 21:40:26.153473
2439	689	escape	C	f	\N	2026-06-24 21:40:26.153473
2440	689	have escaped	D	f	\N	2026-06-24 21:40:26.153473
2441	690	in	A	t	\N	2026-06-24 21:40:26.153473
2442	690	on	B	f	\N	2026-06-24 21:40:26.153473
2443	690	at	C	f	\N	2026-06-24 21:40:26.153473
2444	690	into	D	f	\N	2026-06-24 21:40:26.153473
2445	691	are	A	f	\N	2026-06-24 21:40:26.171327
2446	691	were	B	f	\N	2026-06-24 21:40:26.171327
2447	691	is	C	t	\N	2026-06-24 21:40:26.171327
2448	691	have	D	f	\N	2026-06-24 21:40:26.171327
2449	692	for	A	f	\N	2026-06-24 21:40:26.176323
2450	692	of	B	t	\N	2026-06-24 21:40:26.176323
2451	692	with	C	f	\N	2026-06-24 21:40:26.176323
2452	692	by	D	f	\N	2026-06-24 21:40:26.176323
2453	693	pass	A	f	\N	2026-06-24 21:40:26.182321
2454	693	passed	B	f	\N	2026-06-24 21:40:26.182321
2455	693	would pass	C	f	\N	2026-06-24 21:40:26.182321
2456	693	would have passed	D	t	\N	2026-06-24 21:40:26.182321
2457	694	close	A	f	\N	2026-06-24 21:40:26.186294
2458	694	closing	B	f	\N	2026-06-24 21:40:26.186294
2459	694	to close	C	t	\N	2026-06-24 21:40:26.186294
2460	694	closed	D	f	\N	2026-06-24 21:40:26.186294
2461	695	for	A	f	\N	2026-06-24 21:40:26.189291
2462	695	since	B	t	\N	2026-06-24 21:40:26.189291
2463	695	by	C	f	\N	2026-06-24 21:40:26.189291
2464	695	from	D	f	\N	2026-06-24 21:40:26.189291
2465	696	shortage	A	f	\N	2026-06-24 21:40:26.19229
2466	696	abundance	B	t	\N	2026-06-24 21:40:26.19229
2467	696	poverty	C	f	\N	2026-06-24 21:40:26.19229
2468	696	weakness	D	f	\N	2026-06-24 21:40:26.19229
2469	697	lazy	A	f	\N	2026-06-24 21:40:26.194289
2470	697	hardworking	B	t	\N	2026-06-24 21:40:26.194289
2471	697	careless	C	f	\N	2026-06-24 21:40:26.194289
2472	697	weak	D	f	\N	2026-06-24 21:40:26.194289
2473	698	with	A	t	\N	2026-06-24 21:40:26.197287
2474	698	for	B	f	\N	2026-06-24 21:40:26.197287
2475	698	by	C	f	\N	2026-06-24 21:40:26.197287
2476	698	at	D	f	\N	2026-06-24 21:40:26.197287
2477	699	for	A	f	\N	2026-06-24 21:40:26.200285
2478	699	with	B	f	\N	2026-06-24 21:40:26.200285
2479	699	of	C	t	\N	2026-06-24 21:40:26.200285
2480	699	by	D	f	\N	2026-06-24 21:40:26.200285
2481	700	badly	A	t	\N	2026-06-24 21:40:26.201138
2482	700	bad	B	f	\N	2026-06-24 21:40:26.201138
2483	700	worse	C	f	\N	2026-06-24 21:40:26.201138
2484	700	worst	D	f	\N	2026-06-24 21:40:26.201138
2485	701	from	A	f	\N	2026-06-24 21:40:26.201138
2486	701	for	B	f	\N	2026-06-24 21:40:26.201138
2487	701	since	C	t	\N	2026-06-24 21:40:26.201138
2488	701	during	D	f	\N	2026-06-24 21:40:26.201138
2489	702	because	A	f	\N	2026-06-24 21:40:26.201138
2490	702	because of	B	t	\N	2026-06-24 21:40:26.201138
2491	702	despite	C	f	\N	2026-06-24 21:40:26.201138
2492	702	although	D	f	\N	2026-06-24 21:40:26.201138
2493	703	were	A	f	\N	2026-06-24 21:40:26.201138
2494	703	are	B	f	\N	2026-06-24 21:40:26.201138
2495	703	is	C	t	\N	2026-06-24 21:40:26.201138
2496	703	have	D	f	\N	2026-06-24 21:40:26.201138
2497	704	by	A	f	\N	2026-06-24 21:40:26.201138
2498	704	with	B	t	\N	2026-06-24 21:40:26.201138
2499	704	from	C	f	\N	2026-06-24 21:40:26.201138
2500	704	on	D	f	\N	2026-06-24 21:40:26.201138
2501	705	than	A	f	\N	2026-06-24 21:40:26.24385
2502	705	to	B	t	\N	2026-06-24 21:40:26.24385
2503	705	with	C	f	\N	2026-06-24 21:40:26.24385
2504	705	over	D	f	\N	2026-06-24 21:40:26.24385
2505	706	hear	A	f	\N	2026-06-24 21:40:26.245848
2506	706	heard	B	f	\N	2026-06-24 21:40:26.245848
2507	706	hearing	C	t	\N	2026-06-24 21:40:26.245848
2508	706	hears	D	f	\N	2026-06-24 21:40:26.245848
2509	707	arrest	A	f	\N	2026-06-24 21:40:26.248844
2510	707	arrested	B	f	\N	2026-06-24 21:40:26.248844
2511	707	being arrested	C	t	\N	2026-06-24 21:40:26.248844
2512	707	arresting	D	f	\N	2026-06-24 21:40:26.248844
2513	708	slow	A	f	\N	2026-06-24 21:40:26.251522
2514	708	quick	B	t	\N	2026-06-24 21:40:26.251522
2515	708	weak	C	f	\N	2026-06-24 21:40:26.251522
2516	708	dull	D	f	\N	2026-06-24 21:40:26.251522
2517	709	in	A	f	\N	2026-06-24 21:40:26.254523
2518	709	on	B	t	\N	2026-06-24 21:40:26.254523
2519	709	at	C	f	\N	2026-06-24 21:40:26.254523
2520	709	for	D	f	\N	2026-06-24 21:40:26.254523
2521	710	on	A	t	\N	2026-06-24 21:40:26.256522
2522	710	for	B	f	\N	2026-06-24 21:40:26.256522
2523	710	at	C	f	\N	2026-06-24 21:40:26.256522
2524	710	by	D	f	\N	2026-06-24 21:40:26.256522
2525	711	school	A	f	\N	2026-06-24 21:40:26.259518
2526	711	library	B	f	\N	2026-06-24 21:40:26.259518
2527	711	mind	C	t	\N	2026-06-24 21:40:26.259518
2528	711	classroom	D	f	\N	2026-06-24 21:40:26.259518
2529	712	appearance	A	f	\N	2026-06-24 21:40:26.262518
2530	712	vocabulary	B	t	\N	2026-06-24 21:40:26.262518
2531	712	handwriting	C	f	\N	2026-06-24 21:40:26.262518
2532	712	height	D	f	\N	2026-06-24 21:40:26.262518
2533	713	poorly	A	f	\N	2026-06-24 21:40:26.264517
2534	713	badly	B	f	\N	2026-06-24 21:40:26.264517
2535	713	better	C	t	\N	2026-06-24 21:40:26.264517
2536	713	worse	D	f	\N	2026-06-24 21:40:26.264517
2537	714	critically	A	t	\N	2026-06-24 21:40:26.267756
2538	714	slowly	B	f	\N	2026-06-24 21:40:26.267756
2539	714	carelessly	C	f	\N	2026-06-24 21:40:26.267756
2540	714	negatively	D	f	\N	2026-06-24 21:40:26.267756
2541	715	poorly	A	f	\N	2026-06-24 21:40:26.267756
2542	715	effectively	B	t	\N	2026-06-24 21:40:26.267756
2543	715	carelessly	C	f	\N	2026-06-24 21:40:26.267756
2544	715	quietly	D	f	\N	2026-06-24 21:40:26.267756
2545	716	ancient	A	f	\N	2026-06-24 21:40:26.267756
2546	716	rural	B	f	\N	2026-06-24 21:40:26.267756
2547	716	modern	C	t	\N	2026-06-24 21:40:26.267756
2548	716	primitive	D	f	\N	2026-06-24 21:40:26.267756
2549	717	burden	A	f	\N	2026-06-24 21:40:26.267756
2550	717	tool	B	t	\N	2026-06-24 21:40:26.267756
2551	717	problem	C	f	\N	2026-06-24 21:40:26.267756
2552	717	challenge	D	f	\N	2026-06-24 21:40:26.267756
2553	718	disadvantages	A	f	\N	2026-06-24 21:40:26.267756
2554	718	history	B	f	\N	2026-06-24 21:40:26.267756
2555	718	benefits	C	t	\N	2026-06-24 21:40:26.267756
2556	718	cost	D	f	\N	2026-06-24 21:40:26.267756
2557	719	Improving vocabulary	A	f	\N	2026-06-24 21:40:26.267756
2558	719	Critical thinking	B	f	\N	2026-06-24 21:40:26.267756
2559	719	Effective communication	C	f	\N	2026-06-24 21:40:26.267756
2560	719	Physical strength	D	t	\N	2026-06-24 21:40:26.267756
2561	720	School Life	A	f	\N	2026-06-24 21:40:26.283381
2562	720	Modern Society	B	f	\N	2026-06-24 21:40:26.283381
2563	720	The Importance of Reading	C	t	\N	2026-06-24 21:40:26.283381
2564	720	Academic Failure	D	f	\N	2026-06-24 21:40:26.283381
2565	721	laziness	A	f	\N	2026-06-24 21:40:26.285853
2566	721	productivity	B	t	\N	2026-06-24 21:40:26.285853
2567	721	confusion	C	f	\N	2026-06-24 21:40:26.285853
2568	721	failure	D	f	\N	2026-06-24 21:40:26.285853
2569	722	stress	A	t	\N	2026-06-24 21:40:26.285853
2570	722	joy	B	f	\N	2026-06-24 21:40:26.285853
2571	722	energy	C	f	\N	2026-06-24 21:40:26.285853
2572	722	success	D	f	\N	2026-06-24 21:40:26.285853
2573	723	neighbours	A	f	\N	2026-06-24 21:40:26.285853
2574	723	friends	B	f	\N	2026-06-24 21:40:26.285853
2575	723	deadlines	C	t	\N	2026-06-24 21:40:26.285853
2576	723	teachers	D	f	\N	2026-06-24 21:40:26.285853
2577	724	organization	A	t	\N	2026-06-24 21:40:26.285853
2578	724	weakness	B	f	\N	2026-06-24 21:40:26.285853
2579	724	poverty	C	f	\N	2026-06-24 21:40:26.285853
2580	724	illness	D	f	\N	2026-06-24 21:40:26.285853
2581	725	punishment	A	f	\N	2026-06-24 21:40:26.285853
2582	725	leisure	B	t	\N	2026-06-24 21:40:26.285853
2583	725	farming	C	f	\N	2026-06-24 21:40:26.285853
2584	725	study	D	f	\N	2026-06-24 21:40:26.285853
2585	726	productive	A	t	\N	2026-06-24 21:40:26.285853
2586	726	careless	B	f	\N	2026-06-24 21:40:26.285853
2587	726	confused	C	f	\N	2026-06-24 21:40:26.285853
2588	726	weak	D	f	\N	2026-06-24 21:40:26.285853
2589	727	dangers	A	f	\N	2026-06-24 21:40:26.304391
2590	727	problems	B	f	\N	2026-06-24 21:40:26.304391
2591	727	benefits	C	t	\N	2026-06-24 21:40:26.304391
2592	727	causes	D	f	\N	2026-06-24 21:40:26.304391
2593	728	planning	A	t	\N	2026-06-24 21:40:26.307373
2594	728	failure	B	f	\N	2026-06-24 21:40:26.307373
2595	728	delay	C	f	\N	2026-06-24 21:40:26.307373
2596	728	stress	D	f	\N	2026-06-24 21:40:26.307373
2597	729	organization	A	f	\N	2026-06-24 21:40:26.309371
2598	729	productivity	B	f	\N	2026-06-24 21:40:26.309371
2599	729	missed deadlines	C	t	\N	2026-06-24 21:40:26.309371
2600	729	balance	D	f	\N	2026-06-24 21:40:26.309371
2601	730	Leisure Activities	A	f	\N	2026-06-24 21:40:26.31137
2602	730	Managing Time Effectively	B	t	\N	2026-06-24 21:40:26.31137
2603	730	School Subjects	C	f	\N	2026-06-24 21:40:26.31137
2604	730	Social Problems	D	f	\N	2026-06-24 21:40:26.31137
3005	833	read	A	f	\N	2026-06-24 22:00:51.215665
3006	833	reading	B	f	\N	2026-06-24 22:00:51.215665
3007	833	to read	C	t	\N	2026-06-24 22:00:51.215665
3008	833	reads	D	f	\N	2026-06-24 22:00:51.215665
3009	834	have	A	f	\N	2026-06-24 22:00:51.264581
3010	834	had	B	t	\N	2026-06-24 22:00:51.264581
3011	834	has	C	f	\N	2026-06-24 22:00:51.264581
3012	834	having	D	f	\N	2026-06-24 22:00:51.264581
3013	835	for	A	f	\N	2026-06-24 22:00:51.264581
3014	835	since	B	t	\N	2026-06-24 22:00:51.264581
3015	835	from	C	f	\N	2026-06-24 22:00:51.264581
3016	835	by	D	f	\N	2026-06-24 22:00:51.264581
3017	836	was	A	f	\N	2026-06-24 22:00:51.264581
3018	836	were	B	t	\N	2026-06-24 22:00:51.264581
3019	836	is	C	f	\N	2026-06-24 22:00:51.264581
3020	836	has	D	f	\N	2026-06-24 22:00:51.264581
3021	837	in	A	f	\N	2026-06-24 22:00:51.264581
3022	837	at	B	t	\N	2026-06-24 22:00:51.264581
3023	837	on	C	f	\N	2026-06-24 22:00:51.264581
3024	837	into	D	f	\N	2026-06-24 22:00:51.264581
3025	838	in	A	t	\N	2026-06-24 22:00:51.264581
3026	838	on	B	f	\N	2026-06-24 22:00:51.264581
3027	838	at	C	f	\N	2026-06-24 22:00:51.264581
3028	838	for	D	f	\N	2026-06-24 22:00:51.264581
3029	839	are	A	f	\N	2026-06-24 22:00:51.281615
3030	839	were	B	f	\N	2026-06-24 22:00:51.281615
3031	839	is	C	t	\N	2026-06-24 22:00:51.281615
3032	839	have	D	f	\N	2026-06-24 22:00:51.281615
3033	840	than	A	t	\N	2026-06-24 22:00:51.281615
3034	840	then	B	f	\N	2026-06-24 22:00:51.281615
3035	840	that	C	f	\N	2026-06-24 22:00:51.281615
3036	840	as	D	f	\N	2026-06-24 22:00:51.281615
3037	841	escaped	A	f	\N	2026-06-24 22:00:51.281615
3038	841	had escaped	B	t	\N	2026-06-24 22:00:51.281615
3039	841	escape	C	f	\N	2026-06-24 22:00:51.281615
3040	841	have escaped	D	f	\N	2026-06-24 22:00:51.281615
3041	842	in	A	t	\N	2026-06-24 22:00:51.281615
3042	842	on	B	f	\N	2026-06-24 22:00:51.281615
3043	842	at	C	f	\N	2026-06-24 22:00:51.281615
3044	842	into	D	f	\N	2026-06-24 22:00:51.281615
3045	843	are	A	f	\N	2026-06-24 22:00:51.298729
3046	843	were	B	f	\N	2026-06-24 22:00:51.298729
3047	843	is	C	t	\N	2026-06-24 22:00:51.298729
3048	843	have	D	f	\N	2026-06-24 22:00:51.298729
3049	844	for	A	f	\N	2026-06-24 22:00:51.298729
3050	844	of	B	t	\N	2026-06-24 22:00:51.298729
3051	844	with	C	f	\N	2026-06-24 22:00:51.298729
3052	844	by	D	f	\N	2026-06-24 22:00:51.298729
3053	845	pass	A	f	\N	2026-06-24 22:00:51.298729
3054	845	passed	B	f	\N	2026-06-24 22:00:51.298729
3055	845	would pass	C	f	\N	2026-06-24 22:00:51.298729
3056	845	would have passed	D	t	\N	2026-06-24 22:00:51.298729
3057	846	close	A	f	\N	2026-06-24 22:00:51.312568
3058	846	closing	B	f	\N	2026-06-24 22:00:51.312568
3059	846	to close	C	t	\N	2026-06-24 22:00:51.312568
3060	846	closed	D	f	\N	2026-06-24 22:00:51.312568
3061	847	for	A	f	\N	2026-06-24 22:00:51.315002
3062	847	since	B	t	\N	2026-06-24 22:00:51.315002
3063	847	by	C	f	\N	2026-06-24 22:00:51.315002
3064	847	from	D	f	\N	2026-06-24 22:00:51.315002
3065	848	shortage	A	f	\N	2026-06-24 22:00:51.315002
3066	848	abundance	B	t	\N	2026-06-24 22:00:51.315002
3067	848	poverty	C	f	\N	2026-06-24 22:00:51.315002
3068	848	weakness	D	f	\N	2026-06-24 22:00:51.315002
3069	849	lazy	A	f	\N	2026-06-24 22:00:51.315002
3070	849	hardworking	B	t	\N	2026-06-24 22:00:51.315002
3071	849	careless	C	f	\N	2026-06-24 22:00:51.315002
3072	849	weak	D	f	\N	2026-06-24 22:00:51.315002
3073	850	with	A	t	\N	2026-06-24 22:00:51.315002
3074	850	for	B	f	\N	2026-06-24 22:00:51.315002
3075	850	by	C	f	\N	2026-06-24 22:00:51.315002
3076	850	at	D	f	\N	2026-06-24 22:00:51.315002
3077	851	for	A	f	\N	2026-06-24 22:00:51.329188
3078	851	with	B	f	\N	2026-06-24 22:00:51.329188
3079	851	of	C	t	\N	2026-06-24 22:00:51.329188
3080	851	by	D	f	\N	2026-06-24 22:00:51.329188
3081	852	badly	A	t	\N	2026-06-24 22:00:51.331665
3082	852	bad	B	f	\N	2026-06-24 22:00:51.331665
3083	852	worse	C	f	\N	2026-06-24 22:00:51.331665
3084	852	worst	D	f	\N	2026-06-24 22:00:51.331665
3085	853	from	A	f	\N	2026-06-24 22:00:51.331665
3086	853	for	B	f	\N	2026-06-24 22:00:51.331665
3087	853	since	C	t	\N	2026-06-24 22:00:51.331665
3088	853	during	D	f	\N	2026-06-24 22:00:51.331665
3089	854	because	A	f	\N	2026-06-24 22:00:51.331665
3090	854	because of	B	t	\N	2026-06-24 22:00:51.331665
3091	854	despite	C	f	\N	2026-06-24 22:00:51.331665
3092	854	although	D	f	\N	2026-06-24 22:00:51.331665
3093	855	were	A	f	\N	2026-06-24 22:00:51.331665
3094	855	are	B	f	\N	2026-06-24 22:00:51.331665
3095	855	is	C	t	\N	2026-06-24 22:00:51.331665
3096	855	have	D	f	\N	2026-06-24 22:00:51.331665
3097	856	by	A	f	\N	2026-06-24 22:00:51.345786
3098	856	with	B	t	\N	2026-06-24 22:00:51.345786
3099	856	from	C	f	\N	2026-06-24 22:00:51.345786
3100	856	on	D	f	\N	2026-06-24 22:00:51.345786
3101	857	than	A	f	\N	2026-06-24 22:00:51.3479
3102	857	to	B	t	\N	2026-06-24 22:00:51.3479
3103	857	with	C	f	\N	2026-06-24 22:00:51.3479
3104	857	over	D	f	\N	2026-06-24 22:00:51.3479
3105	858	hear	A	f	\N	2026-06-24 22:00:51.3479
3106	858	heard	B	f	\N	2026-06-24 22:00:51.3479
3107	858	hearing	C	t	\N	2026-06-24 22:00:51.3479
3108	858	hears	D	f	\N	2026-06-24 22:00:51.3479
3109	859	arrest	A	f	\N	2026-06-24 22:00:51.3479
3110	859	arrested	B	f	\N	2026-06-24 22:00:51.3479
3111	859	being arrested	C	t	\N	2026-06-24 22:00:51.3479
3112	859	arresting	D	f	\N	2026-06-24 22:00:51.3479
3113	860	slow	A	f	\N	2026-06-24 22:00:51.3479
3114	860	quick	B	t	\N	2026-06-24 22:00:51.3479
3115	860	weak	C	f	\N	2026-06-24 22:00:51.3479
3116	860	dull	D	f	\N	2026-06-24 22:00:51.3479
3117	861	in	A	f	\N	2026-06-24 22:00:51.362492
3118	861	on	B	t	\N	2026-06-24 22:00:51.362492
3119	861	at	C	f	\N	2026-06-24 22:00:51.362492
3120	861	for	D	f	\N	2026-06-24 22:00:51.362492
3121	862	on	A	t	\N	2026-06-24 22:00:51.364864
3122	862	for	B	f	\N	2026-06-24 22:00:51.364864
3123	862	at	C	f	\N	2026-06-24 22:00:51.364864
3124	862	by	D	f	\N	2026-06-24 22:00:51.364864
2725	762	school	A	f	\N	2026-06-24 21:51:49.043487
2726	762	library	B	f	\N	2026-06-24 21:51:49.043487
2727	762	mind	C	t	\N	2026-06-24 21:51:49.043487
2728	762	classroom	D	f	\N	2026-06-24 21:51:49.043487
2729	763	appearance	A	f	\N	2026-06-24 21:51:49.043487
2730	763	vocabulary	B	t	\N	2026-06-24 21:51:49.043487
2731	763	handwriting	C	f	\N	2026-06-24 21:51:49.043487
2732	763	height	D	f	\N	2026-06-24 21:51:49.043487
2733	764	poorly	A	f	\N	2026-06-24 21:51:49.043487
2734	764	badly	B	f	\N	2026-06-24 21:51:49.043487
2735	764	better	C	t	\N	2026-06-24 21:51:49.043487
2736	764	worse	D	f	\N	2026-06-24 21:51:49.043487
2737	765	critically	A	t	\N	2026-06-24 21:51:49.043487
2738	765	slowly	B	f	\N	2026-06-24 21:51:49.043487
2739	765	carelessly	C	f	\N	2026-06-24 21:51:49.043487
2740	765	negatively	D	f	\N	2026-06-24 21:51:49.043487
2741	766	poorly	A	f	\N	2026-06-24 21:51:49.043487
2742	766	effectively	B	t	\N	2026-06-24 21:51:49.043487
2743	766	carelessly	C	f	\N	2026-06-24 21:51:49.043487
2744	766	quietly	D	f	\N	2026-06-24 21:51:49.043487
2745	767	ancient	A	f	\N	2026-06-24 21:51:49.060021
2746	767	rural	B	f	\N	2026-06-24 21:51:49.060021
2747	767	modern	C	t	\N	2026-06-24 21:51:49.060021
2748	767	primitive	D	f	\N	2026-06-24 21:51:49.060021
2749	768	burden	A	f	\N	2026-06-24 21:51:49.060021
2750	768	tool	B	t	\N	2026-06-24 21:51:49.060021
2751	768	problem	C	f	\N	2026-06-24 21:51:49.060021
2752	768	challenge	D	f	\N	2026-06-24 21:51:49.060021
2753	769	disadvantages	A	f	\N	2026-06-24 21:51:49.060021
2754	769	history	B	f	\N	2026-06-24 21:51:49.060021
2755	769	benefits	C	t	\N	2026-06-24 21:51:49.060021
2756	769	cost	D	f	\N	2026-06-24 21:51:49.060021
2757	770	Improving vocabulary	A	f	\N	2026-06-24 21:51:49.060021
2758	770	Critical thinking	B	f	\N	2026-06-24 21:51:49.060021
2759	770	Effective communication	C	f	\N	2026-06-24 21:51:49.060021
2760	770	Physical strength	D	t	\N	2026-06-24 21:51:49.060021
2761	771	School Life	A	f	\N	2026-06-24 21:51:49.060021
2762	771	Modern Society	B	f	\N	2026-06-24 21:51:49.060021
2763	771	The Importance of Reading	C	t	\N	2026-06-24 21:51:49.060021
2764	771	Academic Failure	D	f	\N	2026-06-24 21:51:49.060021
2765	772	laziness	A	f	\N	2026-06-24 21:51:49.076381
2766	772	productivity	B	t	\N	2026-06-24 21:51:49.076381
2767	772	confusion	C	f	\N	2026-06-24 21:51:49.076381
2768	772	failure	D	f	\N	2026-06-24 21:51:49.076381
2769	773	stress	A	t	\N	2026-06-24 21:51:49.079381
2770	773	joy	B	f	\N	2026-06-24 21:51:49.079381
2771	773	energy	C	f	\N	2026-06-24 21:51:49.079381
2772	773	success	D	f	\N	2026-06-24 21:51:49.079381
2773	774	neighbours	A	f	\N	2026-06-24 21:51:49.082401
2774	774	friends	B	f	\N	2026-06-24 21:51:49.082401
2775	774	deadlines	C	t	\N	2026-06-24 21:51:49.082401
2776	774	teachers	D	f	\N	2026-06-24 21:51:49.082401
2777	775	organization	A	t	\N	2026-06-24 21:51:49.085377
2778	775	weakness	B	f	\N	2026-06-24 21:51:49.085377
2779	775	poverty	C	f	\N	2026-06-24 21:51:49.085377
2780	775	illness	D	f	\N	2026-06-24 21:51:49.085377
2781	776	punishment	A	f	\N	2026-06-24 21:51:49.089373
2782	776	leisure	B	t	\N	2026-06-24 21:51:49.089373
2783	776	farming	C	f	\N	2026-06-24 21:51:49.089373
2784	776	study	D	f	\N	2026-06-24 21:51:49.089373
2785	777	productive	A	t	\N	2026-06-24 21:51:49.091433
2786	777	careless	B	f	\N	2026-06-24 21:51:49.091433
2787	777	confused	C	f	\N	2026-06-24 21:51:49.091433
2788	777	weak	D	f	\N	2026-06-24 21:51:49.091433
2789	778	dangers	A	f	\N	2026-06-24 21:51:49.091433
2790	778	problems	B	f	\N	2026-06-24 21:51:49.091433
2791	778	benefits	C	t	\N	2026-06-24 21:51:49.091433
2792	778	causes	D	f	\N	2026-06-24 21:51:49.091433
2793	779	planning	A	t	\N	2026-06-24 21:51:49.091433
2794	779	failure	B	f	\N	2026-06-24 21:51:49.091433
2795	779	delay	C	f	\N	2026-06-24 21:51:49.091433
2796	779	stress	D	f	\N	2026-06-24 21:51:49.091433
2797	780	organization	A	f	\N	2026-06-24 21:51:49.091433
2798	780	productivity	B	f	\N	2026-06-24 21:51:49.091433
2799	780	missed deadlines	C	t	\N	2026-06-24 21:51:49.091433
2800	780	balance	D	f	\N	2026-06-24 21:51:49.091433
2801	781	Leisure Activities	A	f	\N	2026-06-24 21:51:49.091433
2802	781	Managing Time Effectively	B	t	\N	2026-06-24 21:51:49.091433
2803	781	School Subjects	C	f	\N	2026-06-24 21:51:49.091433
2804	781	Social Problems	D	f	\N	2026-06-24 21:51:49.091433
3125	863	school	A	f	\N	2026-06-24 22:00:51.364864
3126	863	library	B	f	\N	2026-06-24 22:00:51.364864
3127	863	mind	C	t	\N	2026-06-24 22:00:51.364864
3128	863	classroom	D	f	\N	2026-06-24 22:00:51.364864
3129	864	appearance	A	f	\N	2026-06-24 22:00:51.364864
3130	864	vocabulary	B	t	\N	2026-06-24 22:00:51.364864
3131	864	handwriting	C	f	\N	2026-06-24 22:00:51.364864
3132	864	height	D	f	\N	2026-06-24 22:00:51.364864
3133	865	poorly	A	f	\N	2026-06-24 22:00:51.364864
3134	865	badly	B	f	\N	2026-06-24 22:00:51.364864
3135	865	better	C	t	\N	2026-06-24 22:00:51.364864
3136	865	worse	D	f	\N	2026-06-24 22:00:51.364864
3137	866	critically	A	t	\N	2026-06-24 22:00:51.364864
3138	866	slowly	B	f	\N	2026-06-24 22:00:51.364864
3139	866	carelessly	C	f	\N	2026-06-24 22:00:51.364864
3140	866	negatively	D	f	\N	2026-06-24 22:00:51.364864
3141	867	poorly	A	f	\N	2026-06-24 22:00:51.381554
3142	867	effectively	B	t	\N	2026-06-24 22:00:51.381554
3143	867	carelessly	C	f	\N	2026-06-24 22:00:51.381554
3144	867	quietly	D	f	\N	2026-06-24 22:00:51.381554
3145	868	ancient	A	f	\N	2026-06-24 22:00:51.381554
3146	868	rural	B	f	\N	2026-06-24 22:00:51.381554
3147	868	modern	C	t	\N	2026-06-24 22:00:51.381554
3148	868	primitive	D	f	\N	2026-06-24 22:00:51.381554
3149	869	burden	A	f	\N	2026-06-24 22:00:51.381554
3150	869	tool	B	t	\N	2026-06-24 22:00:51.381554
3151	869	problem	C	f	\N	2026-06-24 22:00:51.381554
3152	869	challenge	D	f	\N	2026-06-24 22:00:51.381554
3153	870	disadvantages	A	f	\N	2026-06-24 22:00:51.381554
3154	870	history	B	f	\N	2026-06-24 22:00:51.381554
3155	870	benefits	C	t	\N	2026-06-24 22:00:51.381554
3156	870	cost	D	f	\N	2026-06-24 22:00:51.381554
3157	871	Improving vocabulary	A	f	\N	2026-06-24 22:00:51.381554
3158	871	Critical thinking	B	f	\N	2026-06-24 22:00:51.381554
3159	871	Effective communication	C	f	\N	2026-06-24 22:00:51.381554
3160	871	Physical strength	D	t	\N	2026-06-24 22:00:51.381554
3161	872	School Life	A	f	\N	2026-06-24 22:00:51.398058
3162	872	Modern Society	B	f	\N	2026-06-24 22:00:51.398058
3163	872	The Importance of Reading	C	t	\N	2026-06-24 22:00:51.398058
3164	872	Academic Failure	D	f	\N	2026-06-24 22:00:51.398058
3165	873	laziness	A	f	\N	2026-06-24 22:00:51.398058
3166	873	productivity	B	t	\N	2026-06-24 22:00:51.398058
3167	873	confusion	C	f	\N	2026-06-24 22:00:51.398058
3168	873	failure	D	f	\N	2026-06-24 22:00:51.398058
3169	874	stress	A	t	\N	2026-06-24 22:00:51.398058
3170	874	joy	B	f	\N	2026-06-24 22:00:51.398058
3171	874	energy	C	f	\N	2026-06-24 22:00:51.398058
3172	874	success	D	f	\N	2026-06-24 22:00:51.398058
3173	875	neighbours	A	f	\N	2026-06-24 22:00:51.398058
3174	875	friends	B	f	\N	2026-06-24 22:00:51.398058
3175	875	deadlines	C	t	\N	2026-06-24 22:00:51.398058
3176	875	teachers	D	f	\N	2026-06-24 22:00:51.398058
3177	876	organization	A	t	\N	2026-06-24 22:00:51.398058
3178	876	weakness	B	f	\N	2026-06-24 22:00:51.398058
3179	876	poverty	C	f	\N	2026-06-24 22:00:51.398058
3180	876	illness	D	f	\N	2026-06-24 22:00:51.398058
3181	877	punishment	A	f	\N	2026-06-24 22:00:51.413434
3182	877	leisure	B	t	\N	2026-06-24 22:00:51.413434
3183	877	farming	C	f	\N	2026-06-24 22:00:51.413434
3184	877	study	D	f	\N	2026-06-24 22:00:51.413434
3185	878	productive	A	t	\N	2026-06-24 22:00:51.414965
3186	878	careless	B	f	\N	2026-06-24 22:00:51.414965
3187	878	confused	C	f	\N	2026-06-24 22:00:51.414965
3188	878	weak	D	f	\N	2026-06-24 22:00:51.414965
3189	879	dangers	A	f	\N	2026-06-24 22:00:51.414965
3190	879	problems	B	f	\N	2026-06-24 22:00:51.414965
3191	879	benefits	C	t	\N	2026-06-24 22:00:51.414965
3192	879	causes	D	f	\N	2026-06-24 22:00:51.414965
3193	880	planning	A	t	\N	2026-06-24 22:00:51.414965
3194	880	failure	B	f	\N	2026-06-24 22:00:51.414965
3195	880	delay	C	f	\N	2026-06-24 22:00:51.414965
3196	880	stress	D	f	\N	2026-06-24 22:00:51.414965
3197	881	organization	A	f	\N	2026-06-24 22:00:51.414965
3198	881	productivity	B	f	\N	2026-06-24 22:00:51.414965
3199	881	missed deadlines	C	t	\N	2026-06-24 22:00:51.414965
3200	881	balance	D	f	\N	2026-06-24 22:00:51.414965
3201	882	Leisure Activities	A	f	\N	2026-06-24 22:00:51.414965
3202	882	Managing Time Effectively	B	t	\N	2026-06-24 22:00:51.414965
3203	882	School Subjects	C	f	\N	2026-06-24 22:00:51.414965
3204	882	Social Problems	D	f	\N	2026-06-24 22:00:51.414965
3265	898	shortage	A	f	\N	2026-06-24 22:04:37.606816
3266	898	abundance	B	t	\N	2026-06-24 22:04:37.606816
3267	898	poverty	C	f	\N	2026-06-24 22:04:37.606816
3268	898	weakness	D	f	\N	2026-06-24 22:04:37.606816
3269	899	lazy	A	f	\N	2026-06-24 22:04:37.606816
3270	899	hardworking	B	t	\N	2026-06-24 22:04:37.606816
3271	899	careless	C	f	\N	2026-06-24 22:04:37.606816
3272	899	weak	D	f	\N	2026-06-24 22:04:37.606816
3273	900	with	A	t	\N	2026-06-24 22:04:37.606816
3274	900	for	B	f	\N	2026-06-24 22:04:37.606816
3275	900	by	C	f	\N	2026-06-24 22:04:37.606816
3276	900	at	D	f	\N	2026-06-24 22:04:37.606816
3277	901	for	A	f	\N	2026-06-24 22:04:37.606816
3278	901	with	B	f	\N	2026-06-24 22:04:37.606816
3279	901	of	C	t	\N	2026-06-24 22:04:37.606816
3280	901	by	D	f	\N	2026-06-24 22:04:37.606816
3281	902	badly	A	t	\N	2026-06-24 22:04:37.623726
3282	902	bad	B	f	\N	2026-06-24 22:04:37.623726
3283	902	worse	C	f	\N	2026-06-24 22:04:37.623726
3284	902	worst	D	f	\N	2026-06-24 22:04:37.623726
3285	903	from	A	f	\N	2026-06-24 22:04:37.623726
3286	903	for	B	f	\N	2026-06-24 22:04:37.623726
3287	903	since	C	t	\N	2026-06-24 22:04:37.623726
3288	903	during	D	f	\N	2026-06-24 22:04:37.623726
3289	904	because	A	f	\N	2026-06-24 22:04:37.623726
3290	904	because of	B	t	\N	2026-06-24 22:04:37.623726
3291	904	despite	C	f	\N	2026-06-24 22:04:37.623726
3292	904	although	D	f	\N	2026-06-24 22:04:37.623726
3293	905	were	A	f	\N	2026-06-24 22:04:37.623726
3294	905	are	B	f	\N	2026-06-24 22:04:37.623726
3295	905	is	C	t	\N	2026-06-24 22:04:37.623726
2925	813	school	A	f	\N	2026-06-24 21:54:52.332105
2926	813	library	B	f	\N	2026-06-24 21:54:52.332105
2927	813	mind	C	t	\N	2026-06-24 21:54:52.332105
2928	813	classroom	D	f	\N	2026-06-24 21:54:52.332105
2929	814	appearance	A	f	\N	2026-06-24 21:54:52.332105
2930	814	vocabulary	B	t	\N	2026-06-24 21:54:52.332105
2931	814	handwriting	C	f	\N	2026-06-24 21:54:52.332105
2932	814	height	D	f	\N	2026-06-24 21:54:52.332105
2933	815	poorly	A	f	\N	2026-06-24 21:54:52.332105
2934	815	badly	B	f	\N	2026-06-24 21:54:52.332105
2935	815	better	C	t	\N	2026-06-24 21:54:52.332105
2936	815	worse	D	f	\N	2026-06-24 21:54:52.332105
2937	816	critically	A	t	\N	2026-06-24 21:54:52.346481
2938	816	slowly	B	f	\N	2026-06-24 21:54:52.346481
2939	816	carelessly	C	f	\N	2026-06-24 21:54:52.346481
2940	816	negatively	D	f	\N	2026-06-24 21:54:52.346481
2941	817	poorly	A	f	\N	2026-06-24 21:54:52.350221
2942	817	effectively	B	t	\N	2026-06-24 21:54:52.350221
2943	817	carelessly	C	f	\N	2026-06-24 21:54:52.350221
2944	817	quietly	D	f	\N	2026-06-24 21:54:52.350221
2945	818	ancient	A	f	\N	2026-06-24 21:54:52.350221
2946	818	rural	B	f	\N	2026-06-24 21:54:52.350221
2947	818	modern	C	t	\N	2026-06-24 21:54:52.350221
2948	818	primitive	D	f	\N	2026-06-24 21:54:52.350221
2949	819	burden	A	f	\N	2026-06-24 21:54:52.367155
2950	819	tool	B	t	\N	2026-06-24 21:54:52.367155
2951	819	problem	C	f	\N	2026-06-24 21:54:52.367155
2952	819	challenge	D	f	\N	2026-06-24 21:54:52.367155
2953	820	disadvantages	A	f	\N	2026-06-24 21:54:52.368757
2954	820	history	B	f	\N	2026-06-24 21:54:52.368757
2955	820	benefits	C	t	\N	2026-06-24 21:54:52.368757
2956	820	cost	D	f	\N	2026-06-24 21:54:52.368757
2957	821	Improving vocabulary	A	f	\N	2026-06-24 21:54:52.381935
2958	821	Critical thinking	B	f	\N	2026-06-24 21:54:52.381935
2959	821	Effective communication	C	f	\N	2026-06-24 21:54:52.381935
2960	821	Physical strength	D	t	\N	2026-06-24 21:54:52.381935
2961	822	School Life	A	f	\N	2026-06-24 21:54:52.388936
2962	822	Modern Society	B	f	\N	2026-06-24 21:54:52.388936
2963	822	The Importance of Reading	C	t	\N	2026-06-24 21:54:52.388936
2964	822	Academic Failure	D	f	\N	2026-06-24 21:54:52.388936
2965	823	laziness	A	f	\N	2026-06-24 21:54:52.394935
2966	823	productivity	B	t	\N	2026-06-24 21:54:52.394935
2967	823	confusion	C	f	\N	2026-06-24 21:54:52.394935
2968	823	failure	D	f	\N	2026-06-24 21:54:52.394935
2969	824	stress	A	t	\N	2026-06-24 21:54:52.402924
2970	824	joy	B	f	\N	2026-06-24 21:54:52.402924
2971	824	energy	C	f	\N	2026-06-24 21:54:52.402924
2972	824	success	D	f	\N	2026-06-24 21:54:52.402924
2973	825	neighbours	A	f	\N	2026-06-24 21:54:52.40592
2974	825	friends	B	f	\N	2026-06-24 21:54:52.40592
2975	825	deadlines	C	t	\N	2026-06-24 21:54:52.40592
2976	825	teachers	D	f	\N	2026-06-24 21:54:52.40592
2977	826	organization	A	t	\N	2026-06-24 21:54:52.408918
2978	826	weakness	B	f	\N	2026-06-24 21:54:52.408918
2979	826	poverty	C	f	\N	2026-06-24 21:54:52.408918
2980	826	illness	D	f	\N	2026-06-24 21:54:52.408918
2981	827	punishment	A	f	\N	2026-06-24 21:54:52.411917
2982	827	leisure	B	t	\N	2026-06-24 21:54:52.411917
2983	827	farming	C	f	\N	2026-06-24 21:54:52.411917
2984	827	study	D	f	\N	2026-06-24 21:54:52.411917
2985	828	productive	A	t	\N	2026-06-24 21:54:52.41525
2986	828	careless	B	f	\N	2026-06-24 21:54:52.41525
2987	828	confused	C	f	\N	2026-06-24 21:54:52.41525
2988	828	weak	D	f	\N	2026-06-24 21:54:52.41525
2989	829	dangers	A	f	\N	2026-06-24 21:54:52.418248
2990	829	problems	B	f	\N	2026-06-24 21:54:52.418248
2991	829	benefits	C	t	\N	2026-06-24 21:54:52.418248
2992	829	causes	D	f	\N	2026-06-24 21:54:52.418248
2993	830	planning	A	t	\N	2026-06-24 21:54:52.421247
2994	830	failure	B	f	\N	2026-06-24 21:54:52.421247
2995	830	delay	C	f	\N	2026-06-24 21:54:52.421247
2996	830	stress	D	f	\N	2026-06-24 21:54:52.421247
2997	831	organization	A	f	\N	2026-06-24 21:54:52.423246
2998	831	productivity	B	f	\N	2026-06-24 21:54:52.423246
2999	831	missed deadlines	C	t	\N	2026-06-24 21:54:52.423246
3000	831	balance	D	f	\N	2026-06-24 21:54:52.423246
3001	832	Leisure Activities	A	f	\N	2026-06-24 21:54:52.426244
3002	832	Managing Time Effectively	B	t	\N	2026-06-24 21:54:52.426244
3003	832	School Subjects	C	f	\N	2026-06-24 21:54:52.426244
3004	832	Social Problems	D	f	\N	2026-06-24 21:54:52.426244
3205	883	read	A	f	\N	2026-06-24 22:04:37.540216
3206	883	reading	B	f	\N	2026-06-24 22:04:37.540216
3207	883	to read	C	t	\N	2026-06-24 22:04:37.540216
3208	883	reads	D	f	\N	2026-06-24 22:04:37.540216
3209	884	have	A	f	\N	2026-06-24 22:04:37.556774
3210	884	had	B	t	\N	2026-06-24 22:04:37.556774
3211	884	has	C	f	\N	2026-06-24 22:04:37.556774
3212	884	having	D	f	\N	2026-06-24 22:04:37.556774
3213	885	for	A	f	\N	2026-06-24 22:04:37.556774
3214	885	since	B	t	\N	2026-06-24 22:04:37.556774
3215	885	from	C	f	\N	2026-06-24 22:04:37.556774
3216	885	by	D	f	\N	2026-06-24 22:04:37.556774
3217	886	was	A	f	\N	2026-06-24 22:04:37.556774
3218	886	were	B	t	\N	2026-06-24 22:04:37.556774
3219	886	is	C	f	\N	2026-06-24 22:04:37.556774
3220	886	has	D	f	\N	2026-06-24 22:04:37.556774
3221	887	in	A	f	\N	2026-06-24 22:04:37.556774
3222	887	at	B	t	\N	2026-06-24 22:04:37.556774
3223	887	on	C	f	\N	2026-06-24 22:04:37.556774
3224	887	into	D	f	\N	2026-06-24 22:04:37.556774
3225	888	in	A	t	\N	2026-06-24 22:04:37.556774
3226	888	on	B	f	\N	2026-06-24 22:04:37.556774
3227	888	at	C	f	\N	2026-06-24 22:04:37.556774
3228	888	for	D	f	\N	2026-06-24 22:04:37.556774
3229	889	are	A	f	\N	2026-06-24 22:04:37.573844
3230	889	were	B	f	\N	2026-06-24 22:04:37.573844
3231	889	is	C	t	\N	2026-06-24 22:04:37.573844
3232	889	have	D	f	\N	2026-06-24 22:04:37.573844
3233	890	than	A	t	\N	2026-06-24 22:04:37.573844
3234	890	then	B	f	\N	2026-06-24 22:04:37.573844
3235	890	that	C	f	\N	2026-06-24 22:04:37.573844
3236	890	as	D	f	\N	2026-06-24 22:04:37.573844
3237	891	escaped	A	f	\N	2026-06-24 22:04:37.573844
3238	891	had escaped	B	t	\N	2026-06-24 22:04:37.573844
3239	891	escape	C	f	\N	2026-06-24 22:04:37.573844
3240	891	have escaped	D	f	\N	2026-06-24 22:04:37.573844
3241	892	in	A	t	\N	2026-06-24 22:04:37.573844
3242	892	on	B	f	\N	2026-06-24 22:04:37.573844
3243	892	at	C	f	\N	2026-06-24 22:04:37.573844
3244	892	into	D	f	\N	2026-06-24 22:04:37.573844
3245	893	are	A	f	\N	2026-06-24 22:04:37.573844
3246	893	were	B	f	\N	2026-06-24 22:04:37.573844
3247	893	is	C	t	\N	2026-06-24 22:04:37.573844
3248	893	have	D	f	\N	2026-06-24 22:04:37.573844
3249	894	for	A	f	\N	2026-06-24 22:04:37.587932
3250	894	of	B	t	\N	2026-06-24 22:04:37.587932
3251	894	with	C	f	\N	2026-06-24 22:04:37.587932
3252	894	by	D	f	\N	2026-06-24 22:04:37.587932
3253	895	pass	A	f	\N	2026-06-24 22:04:37.590222
3254	895	passed	B	f	\N	2026-06-24 22:04:37.590222
3255	895	would pass	C	f	\N	2026-06-24 22:04:37.590222
3256	895	would have passed	D	t	\N	2026-06-24 22:04:37.590222
3257	896	close	A	f	\N	2026-06-24 22:04:37.606816
3258	896	closing	B	f	\N	2026-06-24 22:04:37.606816
3259	896	to close	C	t	\N	2026-06-24 22:04:37.606816
3260	896	closed	D	f	\N	2026-06-24 22:04:37.606816
3261	897	for	A	f	\N	2026-06-24 22:04:37.606816
3262	897	since	B	t	\N	2026-06-24 22:04:37.606816
3263	897	by	C	f	\N	2026-06-24 22:04:37.606816
3264	897	from	D	f	\N	2026-06-24 22:04:37.606816
3296	905	have	D	f	\N	2026-06-24 22:04:37.623726
3297	906	by	A	f	\N	2026-06-24 22:04:37.623726
3298	906	with	B	t	\N	2026-06-24 22:04:37.623726
3299	906	from	C	f	\N	2026-06-24 22:04:37.623726
3300	906	on	D	f	\N	2026-06-24 22:04:37.623726
3301	907	than	A	f	\N	2026-06-24 22:04:37.640127
3302	907	to	B	t	\N	2026-06-24 22:04:37.640127
3303	907	with	C	f	\N	2026-06-24 22:04:37.640127
3304	907	over	D	f	\N	2026-06-24 22:04:37.640127
3305	908	hear	A	f	\N	2026-06-24 22:04:37.640127
3306	908	heard	B	f	\N	2026-06-24 22:04:37.640127
3307	908	hearing	C	t	\N	2026-06-24 22:04:37.640127
3308	908	hears	D	f	\N	2026-06-24 22:04:37.640127
3309	909	arrest	A	f	\N	2026-06-24 22:04:37.640127
3310	909	arrested	B	f	\N	2026-06-24 22:04:37.640127
3311	909	being arrested	C	t	\N	2026-06-24 22:04:37.640127
3312	909	arresting	D	f	\N	2026-06-24 22:04:37.640127
3313	910	slow	A	f	\N	2026-06-24 22:04:37.640127
3314	910	quick	B	t	\N	2026-06-24 22:04:37.640127
3315	910	weak	C	f	\N	2026-06-24 22:04:37.640127
3316	910	dull	D	f	\N	2026-06-24 22:04:37.640127
3317	911	in	A	f	\N	2026-06-24 22:04:37.640127
3318	911	on	B	t	\N	2026-06-24 22:04:37.640127
3319	911	at	C	f	\N	2026-06-24 22:04:37.640127
3320	911	for	D	f	\N	2026-06-24 22:04:37.640127
3321	912	on	A	t	\N	2026-06-24 22:04:37.654537
3322	912	for	B	f	\N	2026-06-24 22:04:37.654537
3323	912	at	C	f	\N	2026-06-24 22:04:37.654537
3324	912	by	D	f	\N	2026-06-24 22:04:37.654537
3325	913	school	A	f	\N	2026-06-24 22:04:37.656697
3326	913	library	B	f	\N	2026-06-24 22:04:37.656697
3327	913	mind	C	t	\N	2026-06-24 22:04:37.656697
3328	913	classroom	D	f	\N	2026-06-24 22:04:37.656697
3329	914	appearance	A	f	\N	2026-06-24 22:04:37.656697
3332	914	height	D	f	\N	2026-06-24 22:04:37.656697
3333	915	poorly	A	f	\N	2026-06-24 22:04:37.656697
3334	915	badly	B	f	\N	2026-06-24 22:04:37.656697
3335	915	better	C	t	\N	2026-06-24 22:04:37.656697
3336	915	worse	D	f	\N	2026-06-24 22:04:37.656697
3337	916	critically	A	t	\N	2026-06-24 22:04:37.656697
3338	916	slowly	B	f	\N	2026-06-24 22:04:37.656697
3339	916	carelessly	C	f	\N	2026-06-24 22:04:37.656697
3340	916	negatively	D	f	\N	2026-06-24 22:04:37.656697
3341	917	poorly	A	f	\N	2026-06-24 22:04:37.656697
3342	917	effectively	B	t	\N	2026-06-24 22:04:37.656697
3343	917	carelessly	C	f	\N	2026-06-24 22:04:37.656697
3344	917	quietly	D	f	\N	2026-06-24 22:04:37.656697
3345	918	ancient	A	f	\N	2026-06-24 22:04:37.672743
3346	918	rural	B	f	\N	2026-06-24 22:04:37.672743
3347	918	modern	C	t	\N	2026-06-24 22:04:37.672743
3348	918	primitive	D	f	\N	2026-06-24 22:04:37.672743
3349	919	burden	A	f	\N	2026-06-24 22:04:37.67348
3350	919	tool	B	t	\N	2026-06-24 22:04:37.67348
3351	919	problem	C	f	\N	2026-06-24 22:04:37.67348
3352	919	challenge	D	f	\N	2026-06-24 22:04:37.67348
3353	920	disadvantages	A	f	\N	2026-06-24 22:04:37.67348
3354	920	history	B	f	\N	2026-06-24 22:04:37.67348
3355	920	benefits	C	t	\N	2026-06-24 22:04:37.67348
3356	920	cost	D	f	\N	2026-06-24 22:04:37.67348
3357	921	Improving vocabulary	A	f	\N	2026-06-24 22:04:37.67348
3358	921	Critical thinking	B	f	\N	2026-06-24 22:04:37.67348
3359	921	Effective communication	C	f	\N	2026-06-24 22:04:37.67348
3360	921	Physical strength	D	t	\N	2026-06-24 22:04:37.67348
3361	922	School Life	A	f	\N	2026-06-24 22:04:37.67348
3362	922	Modern Society	B	f	\N	2026-06-24 22:04:37.67348
3363	922	The Importance of Reading	C	t	\N	2026-06-24 22:04:37.67348
3364	922	Academic Failure	D	f	\N	2026-06-24 22:04:37.67348
3365	923	laziness	A	f	\N	2026-06-24 22:04:37.67348
3366	923	productivity	B	t	\N	2026-06-24 22:04:37.67348
3367	923	confusion	C	f	\N	2026-06-24 22:04:37.67348
3368	923	failure	D	f	\N	2026-06-24 22:04:37.67348
3369	924	stress	A	t	\N	2026-06-24 22:04:37.689858
3370	924	joy	B	f	\N	2026-06-24 22:04:37.689858
3371	924	energy	C	f	\N	2026-06-24 22:04:37.689858
3372	924	success	D	f	\N	2026-06-24 22:04:37.689858
3373	925	neighbours	A	f	\N	2026-06-24 22:04:37.689858
3374	925	friends	B	f	\N	2026-06-24 22:04:37.689858
3375	925	deadlines	C	t	\N	2026-06-24 22:04:37.689858
3376	925	teachers	D	f	\N	2026-06-24 22:04:37.689858
3377	926	organization	A	t	\N	2026-06-24 22:04:37.696865
3378	926	weakness	B	f	\N	2026-06-24 22:04:37.696865
3379	926	poverty	C	f	\N	2026-06-24 22:04:37.696865
3380	926	illness	D	f	\N	2026-06-24 22:04:37.696865
3381	927	punishment	A	f	\N	2026-06-24 22:04:37.696865
3382	927	leisure	B	t	\N	2026-06-24 22:04:37.696865
3383	927	farming	C	f	\N	2026-06-24 22:04:37.696865
3384	927	study	D	f	\N	2026-06-24 22:04:37.696865
3385	928	productive	A	t	\N	2026-06-24 22:04:37.696865
3386	928	careless	B	f	\N	2026-06-24 22:04:37.696865
3387	928	confused	C	f	\N	2026-06-24 22:04:37.696865
3388	928	weak	D	f	\N	2026-06-24 22:04:37.696865
3389	929	dangers	A	f	\N	2026-06-24 22:04:37.704683
3390	929	problems	B	f	\N	2026-06-24 22:04:37.704683
3391	929	benefits	C	t	\N	2026-06-24 22:04:37.704683
3392	929	causes	D	f	\N	2026-06-24 22:04:37.704683
3393	930	planning	A	t	\N	2026-06-24 22:04:37.708683
3394	930	failure	B	f	\N	2026-06-24 22:04:37.708683
3395	930	delay	C	f	\N	2026-06-24 22:04:37.708683
3396	930	stress	D	f	\N	2026-06-24 22:04:37.708683
3397	931	organization	A	f	\N	2026-06-24 22:04:37.712681
3398	931	productivity	B	f	\N	2026-06-24 22:04:37.712681
3399	931	missed deadlines	C	t	\N	2026-06-24 22:04:37.712681
3400	931	balance	D	f	\N	2026-06-24 22:04:37.712681
3401	932	Leisure Activities	A	f	\N	2026-06-24 22:04:37.71468
3402	932	Managing Time Effectively	B	t	\N	2026-06-24 22:04:37.71468
3403	932	School Subjects	C	f	\N	2026-06-24 22:04:37.71468
3404	932	Social Problems	D	f	\N	2026-06-24 22:04:37.71468
3330	914	vocabulary	B	f	\N	2026-06-24 22:04:37.656697
3331	914	handwriting	C	t	\N	2026-06-24 22:04:37.656697
3485	973	Were built last year	A	f	\N	2026-06-30 20:06:48.006112
3486	973	Have cultural, archaeological, or historical importance	B	t	\N	2026-06-30 20:06:48.006112
3487	973	Are used only for farming	C	f	\N	2026-06-30 20:06:48.006112
3488	973	Have no connection to the past	D	f	\N	2026-06-30 20:06:48.006112
3489	974	Enugu State	A	f	\N	2026-06-30 20:06:48.139966
3490	974	Adamawa State	B	t	\N	2026-06-30 20:06:48.139966
3491	974	Oyo State	C	f	\N	2026-06-30 20:06:48.139966
3492	974	Lagos State	D	f	\N	2026-06-30 20:06:48.139966
3493	975	Yankari Game Reserve	A	f	\N	2026-06-30 20:06:48.143963
3494	975	Igbo Ukwu	B	t	\N	2026-06-30 20:06:48.143963
3495	975	Olumo Rock	C	f	\N	2026-06-30 20:06:48.143963
3496	975	Aso Rock	D	f	\N	2026-06-30 20:06:48.143963
3497	976	Kano	A	f	\N	2026-06-30 20:06:48.14896
3498	976	Abeokuta, Ogun State	B	t	\N	2026-06-30 20:06:48.14896
3499	976	Benin City	C	f	\N	2026-06-30 20:06:48.14896
3500	976	Calabar	D	f	\N	2026-06-30 20:06:48.14896
3501	977	Terracotta sculptures	A	t	\N	2026-06-30 20:06:48.152955
3502	977	Oil drilling	B	f	\N	2026-06-30 20:06:48.152955
3503	977	Modern skyscrapers	C	f	\N	2026-06-30 20:06:48.152955
3504	977	Railway lines	D	f	\N	2026-06-30 20:06:48.152955
3505	978	Swimming competition	A	f	\N	2026-06-30 20:06:48.154119
3506	978	Water supply and defense	B	t	\N	2026-06-30 20:06:48.154119
3507	978	Gold mining	C	f	\N	2026-06-30 20:06:48.154119
3508	978	Car parking	D	f	\N	2026-06-30 20:06:48.154119
3509	979	A modern market	A	f	\N	2026-06-30 20:06:48.154119
3510	979	Ancient Islamic architecture/learning center	B	t	\N	2026-06-30 20:06:48.154119
3511	979	A football stadium	C	f	\N	2026-06-30 20:06:48.154119
3512	979	A seaport	D	f	\N	2026-06-30 20:06:48.154119
3513	980	They waste government money	A	f	\N	2026-06-30 20:06:48.154119
3514	980	They help us learn about our past and attract tourism	B	t	\N	2026-06-30 20:06:48.154119
3515	980	They should be forgotten	C	f	\N	2026-06-30 20:06:48.154119
3516	980	Only foreigners like them	D	f	\N	2026-06-30 20:06:48.154119
3517	981	Decoration only	A	f	\N	2026-06-30 20:06:48.154119
3518	981	Defense and protection	B	t	\N	2026-06-30 20:06:48.154119
3519	981	Farming	C	f	\N	2026-06-30 20:06:48.154119
3520	981	Airplane landing	D	f	\N	2026-06-30 20:06:48.154119
3521	982	National Museum Lagos	A	f	\N	2026-06-30 20:06:48.154119
3522	982	Newly built shopping mall	B	t	\N	2026-06-30 20:06:48.154119
3523	982	Badagry Slave Port	C	f	\N	2026-06-30 20:06:48.154119
3524	982	Kano City Walls	D	f	\N	2026-06-30 20:06:48.154119
3525	983	Kano State	A	f	\N	2026-06-30 20:06:48.172314
3526	983	Anambra State	B	t	\N	2026-06-30 20:06:48.172314
3527	983	Rivers State	C	f	\N	2026-06-30 20:06:48.172314
3528	983	Oyo State	D	f	\N	2026-06-30 20:06:48.172314
3529	984	Coal	A	f	\N	2026-06-30 20:06:48.172314
3530	984	Ancient bronze, copper and iron artifacts in 1938	B	t	\N	2026-06-30 20:06:48.172314
3531	984	Crude oil	C	f	\N	2026-06-30 20:06:48.172314
3532	984	Gold bars	D	f	\N	2026-06-30 20:06:48.172314
3533	985	No culture before Europeans came	A	f	\N	2026-06-30 20:06:48.172314
3534	985	Advanced metal technology and art over 1000 years ago	B	t	\N	2026-06-30 20:06:48.172314
3535	985	Only farming tools	C	f	\N	2026-06-30 20:06:48.172314
3536	985	No trade with others	D	f	\N	2026-06-30 20:06:48.172314
3537	986	Mungo Park	A	f	\N	2026-06-30 20:06:48.172314
3538	986	Isaiah Anozie, a local man digging a cistern	B	t	\N	2026-06-30 20:06:48.172314
3539	986	Lord Lugard	C	f	\N	2026-06-30 20:06:48.172314
3540	986	Nnamdi Azikiwe	D	f	\N	2026-06-30 20:06:48.172314
3541	987	Fishing only	A	f	\N	2026-06-30 20:06:48.172314
3542	987	Title taking like “Ozo” and “Ichie”	B	t	\N	2026-06-30 20:06:48.172314
3543	987	Camel riding	C	f	\N	2026-06-30 20:06:48.172314
3544	987	Cattle rearing only	D	f	\N	2026-06-30 20:06:48.172314
3545	988	New Yam Festival	A	t	\N	2026-06-30 20:06:48.172314
3546	988	Marriage ceremony	B	f	\N	2026-06-30 20:06:48.172314
3547	988	Burial rite	C	f	\N	2026-06-30 20:06:48.172314
3548	988	War dance	D	f	\N	2026-06-30 20:06:48.172314
3549	989	Centralized kingdom with one king	A	f	\N	2026-06-30 20:06:48.190378
3550	989	Decentralized, based on village groups and elders	B	t	\N	2026-06-30 20:06:48.190378
3551	989	Military rule only	C	f	\N	2026-06-30 20:06:48.190378
3552	989	No government at all	D	f	\N	2026-06-30 20:06:48.190378
3553	990	Comedy only	A	f	\N	2026-06-30 20:06:48.193376
3554	990	Entertainment, discipline, and religious rites	B	t	\N	2026-06-30 20:06:48.193376
3555	990	Farming	C	f	\N	2026-06-30 20:06:48.193376
3556	990	Writing letters	D	f	\N	2026-06-30 20:06:48.193376
3557	991	War songs	A	f	\N	2026-06-30 20:06:48.196372
3558	991	Proverbs used for wise sayings	B	t	\N	2026-06-30 20:06:48.196372
3559	991	Cooking pots	C	f	\N	2026-06-30 20:06:48.196372
3560	991	Market days	D	f	\N	2026-06-30 20:06:48.196372
3561	992	War	A	f	\N	2026-06-30 20:06:48.200371
3562	992	Peace, hospitality, and blessing	B	t	\N	2026-06-30 20:06:48.200371
3563	992	Poverty	C	f	\N	2026-06-30 20:06:48.200371
3564	992	Divorce	D	f	\N	2026-06-30 20:06:48.200371
3565	993	Worship of one God called Chukwu and other deities	A	t	\N	2026-06-30 20:06:48.203369
3566	993	No religion at all	B	f	\N	2026-06-30 20:06:48.203369
3567	993	Worship of only ancestors	C	f	\N	2026-06-30 20:06:48.203369
3568	993	Islam only	D	f	\N	2026-06-30 20:06:48.203369
3569	994	Poor and isolated	A	f	\N	2026-06-30 20:06:48.206485
3570	994	Rich and connected to other regions	B	t	\N	2026-06-30 20:06:48.206485
3571	994	Dependent on Europe only	C	f	\N	2026-06-30 20:06:48.206485
3572	994	Enemies of all neighbors	D	f	\N	2026-06-30 20:06:48.206485
3573	995	River, Hill, and Forest	A	f	\N	2026-06-30 20:06:48.209481
3574	995	Igbo Isaiah, Igbo Richard, and Igbo Jonah	B	t	\N	2026-06-30 20:06:48.209481
3575	995	North, South, East	C	f	\N	2026-06-30 20:06:48.209481
3576	995	Palace, Market, Church	D	f	\N	2026-06-30 20:06:48.209481
3577	996	Laziness	A	f	\N	2026-06-30 20:06:48.212482
3578	996	Hard work and “Igba mbo” apprenticeship	B	t	\N	2026-06-30 20:06:48.212482
3579	996	Begging	C	f	\N	2026-06-30 20:06:48.212482
3580	996	Cheating	D	f	\N	2026-06-30 20:06:48.212482
3581	997	British Museum only	A	f	\N	2026-06-30 20:06:48.218483
3582	997	National Museum, Lagos and Enugu	B	t	\N	2026-06-30 20:06:48.218483
3583	997	Aso Rock Villa	C	f	\N	2026-06-30 20:06:48.218483
3584	997	Burned and destroyed	D	f	\N	2026-06-30 20:06:48.218483
3585	998	Nigeria after 1960 independence	A	f	\N	2026-06-30 20:06:48.220865
3586	998	Nigeria before the arrival and rule of British colonial masters	B	t	\N	2026-06-30 20:06:48.220865
3587	998	Nigeria during civil war	C	f	\N	2026-06-30 20:06:48.220865
3588	998	Nigeria in year 2026	D	f	\N	2026-06-30 20:06:48.220865
3589	999	Has no ruler or government	A	f	\N	2026-06-30 20:06:48.220865
3590	999	Has a strong central authority, king/emir, and organized administration	B	t	\N	2026-06-30 20:06:48.220865
3591	999	Is divided into 100 small villages with no connection	C	f	\N	2026-06-30 20:06:48.220865
3592	999	Exists only today	D	f	\N	2026-06-30 20:06:48.220865
3593	1000	No laws or rules	A	f	\N	2026-06-30 20:06:48.23964
3594	1000	Presence of a king/emir, army, and taxation system	B	t	\N	2026-06-30 20:06:48.23964
3595	1000	Every village is independent	C	f	\N	2026-06-30 20:06:48.23964
3596	1000	No trade	D	f	\N	2026-06-30 20:06:48.23964
3597	1001	Written laws	A	f	\N	2026-06-30 20:06:48.240225
3598	1001	Standing army	B	f	\N	2026-06-30 20:06:48.240225
3599	1001	Total absence of authority	C	t	\N	2026-06-30 20:06:48.240225
3600	1001	System of tribute/tax	D	f	\N	2026-06-30 20:06:48.240225
3601	1002	Igbo village groups	A	f	\N	2026-06-30 20:06:48.240225
3602	1002	Sokoto Caliphate	B	t	\N	2026-06-30 20:06:48.240225
3603	1002	Ijaw clans	C	f	\N	2026-06-30 20:06:48.240225
3604	1002	Tiv communities	D	f	\N	2026-06-30 20:06:48.240225
3605	1003	Eastern Nigeria	A	f	\N	2026-06-30 20:06:48.258735
3606	1003	Western/Yoruba land	B	t	\N	2026-06-30 20:06:48.258735
3607	1003	Niger Delta	C	f	\N	2026-06-30 20:06:48.258735
3608	1003	Middle Belt only	D	f	\N	2026-06-30 20:06:48.258735
3609	1004	Emir	A	f	\N	2026-06-30 20:06:48.265724
3610	1004	Obi	B	f	\N	2026-06-30 20:06:48.265724
3611	1004	Oba	C	t	\N	2026-06-30 20:06:48.265724
3612	1004	Ezeship	D	f	\N	2026-06-30 20:06:48.265724
3613	1005	Lake Chad region	A	t	\N	2026-06-30 20:06:48.272507
3614	1005	Atlantic Ocean coast	B	f	\N	2026-06-30 20:06:48.272507
3615	1005	Sahara Desert center	C	f	\N	2026-06-30 20:06:48.272507
3616	1005	Benue Valley only	D	f	\N	2026-06-30 20:06:48.272507
3617	1006	Children	A	f	\N	2026-06-30 20:06:48.276501
3618	1006	The king/emir and his council of chiefs	B	t	\N	2026-06-30 20:06:48.276501
3619	1006	Foreign traders	C	f	\N	2026-06-30 20:06:48.276501
3620	1006	No one	D	f	\N	2026-06-30 20:06:48.276501
3621	1007	Buying cars for citizens	A	f	\N	2026-06-30 20:06:48.305421
3622	1007	Maintaining the army, palace, and public works	B	t	\N	2026-06-30 20:06:48.305421
3623	1007	Wasting on festivals only	C	f	\N	2026-06-30 20:06:48.305421
3624	1007	Sending to Europe	D	f	\N	2026-06-30 20:06:48.305421
3625	1008	Benin Kingdom	A	f	\N	2026-06-30 20:06:48.305421
3626	1008	Kano under the Hausa States	B	t	\N	2026-06-30 20:06:48.305421
3627	1008	Igbo Ukwu	C	f	\N	2026-06-30 20:06:48.305421
3628	1008	Ibibio clans	D	f	\N	2026-06-30 20:06:48.305421
3629	1009	Dancing only	A	f	\N	2026-06-30 20:06:48.305421
3630	1009	Defense, conquest, and maintaining peace	B	t	\N	2026-06-30 20:06:48.305421
3631	1009	Farming alone	C	f	\N	2026-06-30 20:06:48.305421
3632	1009	No reason	D	f	\N	2026-06-30 20:06:48.305421
3633	1010	One powerful king over all Igbos	A	f	\N	2026-06-30 20:06:48.305421
3634	1010	Many autonomous villages ruled by elders and “Ozo” titled men	B	t	\N	2026-06-30 20:06:48.305421
3635	1010	An emir	C	f	\N	2026-06-30 20:06:48.305421
3636	1010	No culture	D	f	\N	2026-06-30 20:06:48.305421
3637	1011	Present-day Niger/Kwara State area	A	t	\N	2026-06-30 20:06:48.32274
3638	1011	Cross River	B	f	\N	2026-06-30 20:06:48.32274
3639	1011	Borno	C	f	\N	2026-06-30 20:06:48.32274
3640	1011	Delta	D	f	\N	2026-06-30 20:06:48.32274
3641	1012	Fishing method	A	f	\N	2026-06-30 20:06:48.325738
3642	1012	Royal princes sent to rule provinces	B	t	\N	2026-06-30 20:06:48.325738
3643	1012	A type of food	C	f	\N	2026-06-30 20:06:48.325738
3644	1012	A dance	D	f	\N	2026-06-30 20:06:48.325738
3645	1013	Poverty	A	f	\N	2026-06-30 20:06:48.328736
3646	1013	Wealth, urbanization, and contact with foreigners	B	t	\N	2026-06-30 20:06:48.328736
3647	1013	Closure of all markets	C	f	\N	2026-06-30 20:06:48.328736
3648	1013	No development	D	f	\N	2026-06-30 20:06:48.328736
3649	1014	Hausa	A	f	\N	2026-06-30 20:06:48.330735
3650	1014	Yoruba	B	f	\N	2026-06-30 20:06:48.330735
3651	1014	Igbo	C	t	\N	2026-06-30 20:06:48.330735
3652	1014	Fulani	D	f	\N	2026-06-30 20:06:48.330735
3653	1015	Constant war among villages	A	f	\N	2026-06-30 20:06:48.333733
3654	1015	Common language, laws, and symbols like royal regalia	B	t	\N	2026-06-30 20:06:48.333733
3655	1015	Banning all trade	C	f	\N	2026-06-30 20:06:48.333733
3656	1015	Having no capital city	D	f	\N	2026-06-30 20:06:48.333733
3657	1016	Too much peace	A	f	\N	2026-06-30 20:06:48.33772
3658	1016	Internal wars and Fulani jihad	B	t	\N	2026-06-30 20:06:48.33772
3659	1016	Lack of rain	C	f	\N	2026-06-30 20:06:48.33772
3660	1016	Invention of cars	D	f	\N	2026-06-30 20:06:48.33772
3661	1017	Only one ethnic group	A	f	\N	2026-06-30 20:06:48.34072
3793	1059	l'église	A	t	\N	2026-06-30 20:37:17.134694
3662	1017	Many different kingdoms, empires, and stateless societies	B	t	\N	2026-06-30 20:06:48.34072
3663	1017	No people at all	C	f	\N	2026-06-30 20:06:48.34072
3664	1017	Only British colonies	D	f	\N	2026-06-30 20:06:48.34072
3665	1018	No government structure	A	f	\N	2026-06-30 20:06:48.343718
3666	1018	Land divided into emirates ruled by emirs under the Sultan	B	t	\N	2026-06-30 20:06:48.343718
3667	1018	Rule by women only	C	f	\N	2026-06-30 20:06:48.343718
3668	1018	Rule by children	D	f	\N	2026-06-30 20:06:48.343718
3669	1019	Decoration	A	f	\N	2026-06-30 20:06:48.345717
3670	1019	Defense against invaders	B	t	\N	2026-06-30 20:06:48.346717
3671	1019	Football pitch	C	f	\N	2026-06-30 20:06:48.346717
3672	1019	Swimming pools	D	f	\N	2026-06-30 20:06:48.346717
3673	1020	Hausa	A	f	\N	2026-06-30 20:06:48.348721
3674	1020	Yoruba	B	f	\N	2026-06-30 20:06:48.348721
3675	1020	Igbo	C	t	\N	2026-06-30 20:06:48.348721
3676	1020	Kanuri	D	f	\N	2026-06-30 20:06:48.348721
3677	1021	Lagos	A	f	\N	2026-06-30 20:06:48.351712
3678	1021	Birni Gazargamu/Ndjamena area	B	t	\N	2026-06-30 20:06:48.351712
3679	1021	Ibadan	C	f	\N	2026-06-30 20:06:48.351712
3680	1021	Enugu	D	f	\N	2026-06-30 20:06:48.351712
3681	1022	Hate our past	A	f	\N	2026-06-30 20:06:48.35403
3682	1022	Understand our culture, politics, and how Nigeria was formed	B	t	\N	2026-06-30 20:06:48.35403
3683	1022	Forget our traditions	C	f	\N	2026-06-30 20:06:48.35403
3684	1022	Copy only European history	D	f	\N	2026-06-30 20:06:48.35403
3685	1023	christianity	A	t	\N	2026-06-30 20:37:16.81768
3686	1023	islam	B	f	\N	2026-06-30 20:37:16.81768
3687	1023	traditional religion	C	f	\N	2026-06-30 20:37:16.81768
3688	1024	Niger	A	t	\N	2026-06-30 20:37:16.850495
3689	1024	Lagos	B	f	\N	2026-06-30 20:37:16.850495
3690	1024	Abuja	C	f	\N	2026-06-30 20:37:16.850495
3691	1025	street	A	f	\N	2026-06-30 20:37:16.850495
3692	1025	highway	B	t	\N	2026-06-30 20:37:16.850495
3693	1025	footpath	C	f	\N	2026-06-30 20:37:16.850495
3694	1026	newspaper	A	f	\N	2026-06-30 20:37:16.850495
3695	1026	radio	B	t	\N	2026-06-30 20:37:16.850495
3696	1026	textbook	C	f	\N	2026-06-30 20:37:16.850495
3697	1027	school	A	f	\N	2026-06-30 20:37:16.850495
3698	1027	house	B	f	\N	2026-06-30 20:37:16.850495
3699	1027	industry	C	t	\N	2026-06-30 20:37:16.850495
3700	1028	come here	A	f	\N	2026-06-30 20:37:16.869035
3701	1028	go out	B	f	\N	2026-06-30 20:37:16.869035
3702	1028	sit-down	C	t	\N	2026-06-30 20:37:16.869035
3703	1029	restaurant	A	t	\N	2026-06-30 20:37:16.869035
3704	1029	toilettes	B	f	\N	2026-06-30 20:37:16.869035
3705	1029	cinéma	C	f	\N	2026-06-30 20:37:16.869035
3706	1030	thank you so much	A	t	\N	2026-06-30 20:37:16.886076
3707	1030	good morning	B	f	\N	2026-06-30 20:37:16.886076
3708	1030	welcome	C	f	\N	2026-06-30 20:37:16.886076
3709	1031	les journaux	A	f	\N	2026-06-30 20:37:16.886076
3710	1031	le téléphone portable	B	t	\N	2026-06-30 20:37:16.886076
3711	1031	le grand marché	C	f	\N	2026-06-30 20:37:16.886076
3712	1032	une chemise	A	f	\N	2026-06-30 20:37:16.902769
3713	1032	un pantalon	B	t	\N	2026-06-30 20:37:16.902769
3714	1032	un chapeau	C	f	\N	2026-06-30 20:37:16.902769
3715	1033	field	A	f	\N	2026-06-30 20:37:16.902769
3716	1033	farm	B	f	\N	2026-06-30 20:37:16.902769
3717	1033	industry	C	t	\N	2026-06-30 20:37:16.902769
3718	1034	a boy	A	f	\N	2026-06-30 20:37:16.918904
3719	1034	a girl	B	f	\N	2026-06-30 20:37:16.918904
3720	1034	a friend	C	t	\N	2026-06-30 20:37:16.918904
3721	1035	un chapeau	A	t	\N	2026-06-30 20:37:16.918904
3722	1035	le sac	B	f	\N	2026-06-30 20:37:16.918904
3723	1035	le bœuf	C	f	\N	2026-06-30 20:37:16.918904
3724	1036	le marché	A	t	\N	2026-06-30 20:37:16.936134
3725	1036	la maison	B	f	\N	2026-06-30 20:37:16.936134
3726	1036	la chambre	C	f	\N	2026-06-30 20:37:16.936134
3727	1037	customer	A	f	\N	2026-06-30 20:37:16.936134
3728	1037	mother in-law	B	t	\N	2026-06-30 20:37:16.936134
3729	1037	neighbor	C	f	\N	2026-06-30 20:37:16.936134
3730	1038	mamie	A	f	\N	2026-06-30 20:37:16.952675
3731	1038	le beau-père	B	t	\N	2026-06-30 20:37:16.952675
3732	1038	personne	C	f	\N	2026-06-30 20:37:16.952675
3733	1039	la chemise	A	f	\N	2026-06-30 20:37:16.964856
3734	1039	le pantalon	B	f	\N	2026-06-30 20:37:16.964856
3735	1039	le frère	C	t	\N	2026-06-30 20:37:16.964856
3736	1040	la salle	A	f	\N	2026-06-30 20:37:16.969325
3737	1040	la sieste	B	f	\N	2026-06-30 20:37:16.969325
3738	1040	la sœur	C	t	\N	2026-06-30 20:37:16.969325
3739	1041	to love	A	t	\N	2026-06-30 20:37:16.981553
3740	1041	to eat	B	f	\N	2026-06-30 20:37:16.981553
3741	1041	to drink	C	f	\N	2026-06-30 20:37:16.981553
3742	1042	un ami	A	t	\N	2026-06-30 20:37:16.986708
3743	1042	un voisin	B	f	\N	2026-06-30 20:37:16.986708
3744	1042	un camarade	C	f	\N	2026-06-30 20:37:16.986708
3745	1043	to go	A	f	\N	2026-06-30 20:37:16.998162
3746	1043	to sweep	B	t	\N	2026-06-30 20:37:16.998162
3747	1043	to come	C	f	\N	2026-06-30 20:37:16.998162
3748	1044	il fait portent	A	f	\N	2026-06-30 20:37:17.006166
3749	1044	porte	B	t	\N	2026-06-30 20:37:17.006166
3750	1044	portons	C	f	\N	2026-06-30 20:37:17.006166
3751	1045	neck	A	f	\N	2026-06-30 20:37:17.017854
3752	1045	finger	B	f	\N	2026-06-30 20:37:17.017854
3753	1045	clothes	C	t	\N	2026-06-30 20:37:17.017854
3754	1046	leg	A	f	\N	2026-06-30 20:37:17.017854
3755	1046	shirt	B	f	\N	2026-06-30 20:37:17.017854
3756	1046	shoes	C	t	\N	2026-06-30 20:37:17.017854
3757	1047	market	A	t	\N	2026-06-30 20:37:17.036147
3758	1047	farm	B	f	\N	2026-06-30 20:37:17.036147
3759	1047	house	C	f	\N	2026-06-30 20:37:17.036147
3760	1048	sit-down	A	t	\N	2026-06-30 20:37:17.036147
3761	1048	go out	B	f	\N	2026-06-30 20:37:17.036147
3762	1048	come over	C	f	\N	2026-06-30 20:37:17.036147
3763	1049	to clean	A	f	\N	2026-06-30 20:37:17.050349
3764	1049	to teach	B	t	\N	2026-06-30 20:37:17.050349
3765	1049	to write	C	f	\N	2026-06-30 20:37:17.050349
3766	1050	parlour	A	f	\N	2026-06-30 20:37:17.058354
3767	1050	highway	B	t	\N	2026-06-30 20:37:17.058354
3768	1050	room	C	f	\N	2026-06-30 20:37:17.058354
3769	1051	porter	A	f	\N	2026-06-30 20:37:17.068031
3770	1051	portons	B	f	\N	2026-06-30 20:37:17.068031
3771	1051	porte	C	t	\N	2026-06-30 20:37:17.068031
3772	1052	partir	A	f	\N	2026-06-30 20:37:17.068031
3773	1052	boire	B	f	\N	2026-06-30 20:37:17.068031
3774	1052	marcher	C	t	\N	2026-06-30 20:37:17.068031
3775	1053	le restaurant	A	t	\N	2026-06-30 20:37:17.0814
3776	1053	le cahier	B	f	\N	2026-06-30 20:37:17.0814
3777	1053	l'avion	C	f	\N	2026-06-30 20:37:17.0814
3778	1054	une chemise	A	t	\N	2026-06-30 20:37:17.089399
3779	1054	la cantine	B	f	\N	2026-06-30 20:37:17.089399
3780	1054	la voiture	C	f	\N	2026-06-30 20:37:17.089399
3781	1055	la tête	A	f	\N	2026-06-30 20:37:17.098889
3782	1055	le marché	B	t	\N	2026-06-30 20:37:17.098889
3783	1055	les cheveux	C	f	\N	2026-06-30 20:37:17.098889
3784	1056	come here	A	f	\N	2026-06-30 20:37:17.106895
3785	1056	keep quiet	B	t	\N	2026-06-30 20:37:17.106895
3786	1056	sit-down	C	f	\N	2026-06-30 20:37:17.106895
3787	1057	we	A	f	\N	2026-06-30 20:37:17.114547
3788	1057	you	B	f	\N	2026-06-30 20:37:17.114547
3789	1057	again	C	t	\N	2026-06-30 20:37:17.114547
3790	1058	get up	A	f	\N	2026-06-30 20:37:17.114547
3791	1058	sleep	B	f	\N	2026-06-30 20:37:17.114547
3792	1058	stand up	C	t	\N	2026-06-30 20:37:17.114547
3794	1059	le marché	B	f	\N	2026-06-30 20:37:17.134694
3795	1059	l'école	C	f	\N	2026-06-30 20:37:17.134694
3796	1060	la mosquée	A	t	\N	2026-06-30 20:37:17.148624
3797	1060	le bois	B	f	\N	2026-06-30 20:37:17.148624
3798	1060	le sac	C	f	\N	2026-06-30 20:37:17.148624
3799	1061	l'amie	A	f	\N	2026-06-30 20:37:17.156634
3800	1061	la mère	B	t	\N	2026-06-30 20:37:17.156634
3801	1061	la reine	C	f	\N	2026-06-30 20:37:17.156634
3802	1062	la mosquée	A	f	\N	2026-06-30 20:37:17.165456
3803	1062	le stade	B	t	\N	2026-06-30 20:37:17.165456
3804	1062	la main	C	f	\N	2026-06-30 20:37:17.165456
3805	1063	portent	A	f	\N	2026-06-30 20:37:17.173465
3806	1063	porte	B	f	\N	2026-06-30 20:37:17.173465
3807	1063	portons	C	t	\N	2026-06-30 20:37:17.173465
3808	1064	to drink	A	f	\N	2026-06-30 20:37:17.181185
3809	1064	to eat	B	f	\N	2026-06-30 20:37:17.181185
3810	1064	to treat	C	t	\N	2026-06-30 20:37:17.181185
3811	1065	des	A	t	\N	2026-06-30 20:37:17.181185
3812	1065	un	B	f	\N	2026-06-30 20:37:17.181185
3813	1065	une	C	f	\N	2026-06-30 20:37:17.181185
3814	1066	parlons	A	t	\N	2026-06-30 20:37:17.19789
3815	1066	parler	B	f	\N	2026-06-30 20:37:17.19789
3816	1066	parle	C	f	\N	2026-06-30 20:37:17.19789
3817	1067	Lagos	A	f	\N	2026-06-30 20:37:17.200737
3818	1067	Abuja	B	t	\N	2026-06-30 20:37:17.200737
3819	1067	Kano	C	f	\N	2026-06-30 20:37:17.200737
3820	1068	Kaduna	A	f	\N	2026-06-30 20:37:17.21469
3821	1068	Minna	B	t	\N	2026-06-30 20:37:17.21469
3822	1068	Tunga	C	f	\N	2026-06-30 20:37:17.21469
3823	1069	zero	A	f	\N	2026-06-30 20:37:17.222694
3824	1069	un	B	f	\N	2026-06-30 20:37:17.222694
3825	1069	sept	C	t	\N	2026-06-30 20:37:17.222694
3826	1070	vingt	A	f	\N	2026-06-30 20:37:17.232092
3827	1070	dix	B	f	\N	2026-06-30 20:37:17.232092
3828	1070	douze	C	t	\N	2026-06-30 20:37:17.232092
3829	1071	aller	A	t	\N	2026-06-30 20:37:17.240097
3830	1071	vas	B	f	\N	2026-06-30 20:37:17.240097
3831	1071	vais	C	f	\N	2026-06-30 20:37:17.240097
3832	1072	er	A	t	\N	2026-06-30 20:37:17.240097
3833	1072	ir	B	f	\N	2026-06-30 20:37:17.240097
3834	1072	re	C	f	\N	2026-06-30 20:37:17.240097
\.


--
-- TOC entry 5113 (class 0 OID 17733)
-- Dependencies: 235
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, exam_id, question_text, question_type, marks, "order", instructions, image, latex_support, created_at, updated_at) FROM stdin;
551	7	What does CPU stand for?	mcq	2	1	\N	\N	t	2026-06-20 20:33:31.867794	2026-06-20 20:33:31.867794
552	7	Which part of the computer is called the 'brain'?	mcq	2	2	\N	\N	t	2026-06-20 20:33:31.883922	2026-06-20 20:33:31.883922
553	7	What is the function of RAM in a computer?	mcq	2	3	\N	\N	t	2026-06-20 20:33:31.900861	2026-06-20 20:33:31.900861
554	7	Which of the following is an input device?	mcq	2	4	\N	\N	t	2026-06-20 20:33:31.917373	2026-06-20 20:33:31.917373
555	7	Which of the following is an output device?	mcq	2	5	\N	\N	t	2026-06-20 20:33:31.917373	2026-06-20 20:33:31.917373
556	7	Which storage device has the largest storage capacity?	mcq	2	6	\N	\N	t	2026-06-20 20:33:31.917373	2026-06-20 20:33:31.917373
557	7	What type of software is Microsoft Windows?	mcq	2	7	\N	\N	t	2026-06-20 20:33:31.917373	2026-06-20 20:33:31.917373
558	7	Which of the following is an example of application software?	mcq	2	8	\N	\N	t	2026-06-20 20:33:31.93184	2026-06-20 20:33:31.93184
559	7	What does ROM stand for?	mcq	2	9	\N	\N	t	2026-06-20 20:33:31.934263	2026-06-20 20:33:31.934263
560	7	The speed of a CPU is measured in?	mcq	2	10	\N	\N	t	2026-06-20 20:33:31.934263	2026-06-20 20:33:31.934263
561	7	Which keyboard shortcut saves a document in Microsoft Word?	mcq	2	11	\N	\N	t	2026-06-20 20:33:31.934263	2026-06-20 20:33:31.934263
562	7	In Microsoft Excel, which symbol must begin a formula?	mcq	2	12	\N	\N	t	2026-06-20 20:33:31.934263	2026-06-20 20:33:31.934263
563	7	What does the SUM function do in Excel?	mcq	2	13	\N	\N	t	2026-06-20 20:33:31.95072	2026-06-20 20:33:31.95072
564	7	What is the function of mail merge in word processing?	mcq	2	14	\N	\N	t	2026-06-20 20:33:31.95072	2026-06-20 20:33:31.95072
565	7	A macro in Microsoft Office is used to?	mcq	2	15	\N	\N	t	2026-06-20 20:33:31.95072	2026-06-20 20:33:31.95072
566	7	What is a pivot table in Excel?	mcq	2	16	\N	\N	t	2026-06-20 20:33:31.95072	2026-06-20 20:33:31.95072
567	7	Which Excel function calculates the mean of a range of values?	mcq	2	17	\N	\N	t	2026-06-20 20:33:31.95072	2026-06-20 20:33:31.95072
568	7	What file extension does a Microsoft Word document use?	mcq	2	18	\N	\N	t	2026-06-20 20:33:31.95072	2026-06-20 20:33:31.95072
569	7	Which of the following is a database management system?	mcq	2	19	\N	\N	t	2026-06-20 20:33:31.967489	2026-06-20 20:33:31.967489
570	7	What is a primary key in a database?	mcq	2	20	\N	\N	t	2026-06-20 20:33:31.967489	2026-06-20 20:33:31.967489
571	7	What does LAN stand for?	mcq	2	21	\N	\N	t	2026-06-20 20:33:31.967489	2026-06-20 20:33:31.967489
572	7	Which network covers the largest geographical area?	mcq	2	22	\N	\N	t	2026-06-20 20:33:31.967489	2026-06-20 20:33:31.967489
573	7	What does MAN stand for in networking?	mcq	2	23	\N	\N	t	2026-06-20 20:33:31.983154	2026-06-20 20:33:31.983154
574	7	Which device connects multiple networks together and directs traffic?	mcq	2	24	\N	\N	t	2026-06-20 20:33:31.983924	2026-06-20 20:33:31.983924
575	7	A switch operates at which layer of the OSI model?	mcq	2	25	\N	\N	t	2026-06-20 20:33:31.983924	2026-06-20 20:33:31.983924
576	7	Which device broadcasts data to all devices on a network?	mcq	2	26	\N	\N	t	2026-06-20 20:33:31.983924	2026-06-20 20:33:31.983924
577	7	What is the primary function of a network firewall?	mcq	2	27	\N	\N	t	2026-06-20 20:33:31.983924	2026-06-20 20:33:31.983924
578	7	Which transmission medium offers the fastest data transfer speed?	mcq	2	28	\N	\N	t	2026-06-20 20:33:31.983924	2026-06-20 20:33:31.983924
579	7	What does Wi-Fi use to transmit data?	mcq	2	29	\N	\N	t	2026-06-20 20:33:32.003405	2026-06-20 20:33:32.003405
580	7	Which network topology connects all devices to a central hub?	mcq	2	30	\N	\N	t	2026-06-20 20:33:32.006405	2026-06-20 20:33:32.006405
581	7	How many layers does the OSI model have?	mcq	2	31	\N	\N	t	2026-06-20 20:33:32.009402	2026-06-20 20:33:32.009402
582	7	Which OSI layer is responsible for physical transmission of data as bits?	mcq	2	32	\N	\N	t	2026-06-20 20:33:32.012401	2026-06-20 20:33:32.012401
583	7	What is the function of the Network Layer in the OSI model?	mcq	2	33	\N	\N	t	2026-06-20 20:33:32.015256	2026-06-20 20:33:32.015256
584	7	Which OSI layer is responsible for end-to-end communication and error recovery?	mcq	2	34	\N	\N	t	2026-06-20 20:33:32.016547	2026-06-20 20:33:32.016547
585	7	Which OSI layer handles data formatting, encryption, and compression?	mcq	2	35	\N	\N	t	2026-06-20 20:33:32.016547	2026-06-20 20:33:32.016547
586	7	What is the role of the Session Layer in the OSI model?	mcq	2	36	\N	\N	t	2026-06-20 20:33:32.016547	2026-06-20 20:33:32.016547
587	7	The Application Layer of the OSI model is responsible for?	mcq	2	37	\N	\N	t	2026-06-20 20:33:32.016547	2026-06-20 20:33:32.016547
588	7	Which OSI layer does a router operate at?	mcq	2	38	\N	\N	t	2026-06-20 20:33:32.03334	2026-06-20 20:33:32.03334
589	7	At which OSI layer does the MAC address operate?	mcq	2	39	\N	\N	t	2026-06-20 20:33:32.03334	2026-06-20 20:33:32.03334
590	7	Which layer of the OSI model converts data into a format suitable for the application layer?	mcq	2	40	\N	\N	t	2026-06-20 20:33:32.03334	2026-06-20 20:33:32.03334
591	7	What does TCP stand for?	mcq	2	41	\N	\N	t	2026-06-20 20:33:32.03334	2026-06-20 20:33:32.03334
592	7	Which protocol operates at the Network Layer of the OSI model?	mcq	2	42	\N	\N	t	2026-06-20 20:33:32.03334	2026-06-20 20:33:32.03334
593	7	What does HTTP stand for?	mcq	2	43	\N	\N	t	2026-06-20 20:33:32.050534	2026-06-20 20:33:32.050534
594	7	Which protocol is used to securely transfer data over the web?	mcq	2	44	\N	\N	t	2026-06-20 20:33:32.054534	2026-06-20 20:33:32.054534
595	7	What is the purpose of the DNS?	mcq	2	45	\N	\N	t	2026-06-20 20:33:32.058529	2026-06-20 20:33:32.058529
596	7	What does DHCP stand for?	mcq	2	46	\N	\N	t	2026-06-20 20:33:32.061527	2026-06-20 20:33:32.061527
597	7	Which protocol is used to send emails?	mcq	2	47	\N	\N	t	2026-06-20 20:33:32.065043	2026-06-20 20:33:32.065043
598	7	UDP differs from TCP in that UDP?	mcq	2	48	\N	\N	t	2026-06-20 20:33:32.066354	2026-06-20 20:33:32.066354
599	7	An IPv4 address consists of how many bits?	mcq	2	49	\N	\N	t	2026-06-20 20:33:32.066354	2026-06-20 20:33:32.066354
600	7	IPv6 was introduced primarily because?	mcq	2	50	\N	\N	t	2026-06-20 20:33:32.066354	2026-06-20 20:33:32.066354
601	7	What does ISP stand for?	mcq	2	51	\N	\N	t	2026-06-20 20:33:32.066354	2026-06-20 20:33:32.066354
602	7	Which of the following is a web browser?	mcq	2	52	\N	\N	t	2026-06-20 20:33:32.066354	2026-06-20 20:33:32.066354
603	7	What is a search engine?	mcq	2	53	\N	\N	t	2026-06-20 20:33:32.084838	2026-06-20 20:33:32.084838
604	7	What does URL stand for?	mcq	2	54	\N	\N	t	2026-06-20 20:33:32.088838	2026-06-20 20:33:32.088838
605	7	Which of the following is an example of cloud storage?	mcq	2	55	\N	\N	t	2026-06-20 20:33:32.091835	2026-06-20 20:33:32.091835
606	7	What is the advantage of cloud computing over local storage?	mcq	2	56	\N	\N	t	2026-06-20 20:33:32.095831	2026-06-20 20:33:32.095831
607	7	What does FTP stand for?	mcq	2	57	\N	\N	t	2026-06-20 20:33:32.098658	2026-06-20 20:33:32.098658
608	7	Which of the following best describes email etiquette?	mcq	2	58	\N	\N	t	2026-06-20 20:33:32.102658	2026-06-20 20:33:32.102658
609	7	What is malware?	mcq	2	59	\N	\N	t	2026-06-20 20:33:32.105656	2026-06-20 20:33:32.105656
610	7	Which of the following is a type of malware?	mcq	2	60	\N	\N	t	2026-06-20 20:33:32.108652	2026-06-20 20:33:32.108652
611	7	What is phishing?	mcq	2	61	\N	\N	t	2026-06-20 20:33:32.111651	2026-06-20 20:33:32.111651
612	7	What is a strong password characterized by?	mcq	2	62	\N	\N	t	2026-06-20 20:33:32.114926	2026-06-20 20:33:32.114926
613	7	What is the function of antivirus software?	mcq	2	63	\N	\N	t	2026-06-20 20:33:32.114926	2026-06-20 20:33:32.114926
614	7	Which of the following best describes a DDoS attack?	mcq	2	64	\N	\N	t	2026-06-20 20:33:32.114926	2026-06-20 20:33:32.114926
615	7	What does two-factor authentication (2FA) do?	mcq	2	65	\N	\N	t	2026-06-20 20:33:32.114926	2026-06-20 20:33:32.114926
616	7	Ransomware is a type of malware that?	mcq	2	66	\N	\N	t	2026-06-20 20:33:32.114926	2026-06-20 20:33:32.114926
617	7	What does GDPR stand for?	mcq	2	67	\N	\N	t	2026-06-20 20:33:32.133144	2026-06-20 20:33:32.133144
618	7	Cyberbullying is defined as?	mcq	2	68	\N	\N	t	2026-06-20 20:33:32.133144	2026-06-20 20:33:32.133144
619	7	Which of the following is an example of responsible digital citizenship?	mcq	2	69	\N	\N	t	2026-06-20 20:33:32.133144	2026-06-20 20:33:32.133144
620	7	Data privacy laws are designed to?	mcq	2	70	\N	\N	t	2026-06-20 20:33:32.133144	2026-06-20 20:33:32.133144
621	7	What does HTML stand for?	mcq	2	71	\N	\N	t	2026-06-20 20:33:32.133144	2026-06-20 20:33:32.133144
622	7	What is CSS used for in web design?	mcq	2	72	\N	\N	t	2026-06-20 20:33:32.149476	2026-06-20 20:33:32.149476
623	7	Which HTML tag is used to create a hyperlink?	mcq	2	73	\N	\N	t	2026-06-20 20:33:32.152474	2026-06-20 20:33:32.152474
624	7	What is a domain name?	mcq	2	74	\N	\N	t	2026-06-20 20:33:32.155472	2026-06-20 20:33:32.155472
625	7	Web hosting refers to?	mcq	2	75	\N	\N	t	2026-06-20 20:33:32.15847	2026-06-20 20:33:32.15847
626	7	What is an algorithm?	mcq	2	76	\N	\N	t	2026-06-20 20:33:32.161469	2026-06-20 20:33:32.161469
627	7	Which of the following is a high-level programming language?	mcq	2	77	\N	\N	t	2026-06-20 20:33:32.164467	2026-06-20 20:33:32.164467
628	7	In programming, a variable is used to?	mcq	2	78	\N	\N	t	2026-06-20 20:33:32.167193	2026-06-20 20:33:32.167193
629	7	A flowchart uses which shape to represent a decision?	mcq	2	79	\N	\N	t	2026-06-20 20:33:32.170191	2026-06-20 20:33:32.170191
630	7	What is the output of: x = 5; y = 3; print(x + y) in Python?	mcq	2	80	\N	\N	t	2026-06-20 20:33:32.17219	2026-06-20 20:33:32.17219
631	7	Which control structure repeats code while a condition is true?	mcq	2	81	\N	\N	t	2026-06-20 20:33:32.175189	2026-06-20 20:33:32.175189
632	7	What is a function in programming?	mcq	2	82	\N	\N	t	2026-06-20 20:33:32.178186	2026-06-20 20:33:32.178186
633	7	What does the 'if' statement do in programming?	mcq	2	83	\N	\N	t	2026-06-20 20:33:32.181584	2026-06-20 20:33:32.181584
634	7	What is artificial intelligence?	mcq	2	84	\N	\N	t	2026-06-20 20:33:32.181584	2026-06-20 20:33:32.181584
635	7	Which of the following is an application of AI?	mcq	2	85	\N	\N	t	2026-06-20 20:33:32.181584	2026-06-20 20:33:32.181584
636	7	What is machine learning?	mcq	2	86	\N	\N	t	2026-06-20 20:33:32.181584	2026-06-20 20:33:32.181584
637	7	What is data collection in the context of data science?	mcq	2	87	\N	\N	t	2026-06-20 20:33:32.181584	2026-06-20 20:33:32.181584
638	7	What does SaaS stand for?	mcq	2	88	\N	\N	t	2026-06-20 20:33:32.181584	2026-06-20 20:33:32.181584
639	7	What does IaaS stand for in cloud computing?	mcq	2	89	\N	\N	t	2026-06-20 20:33:32.199269	2026-06-20 20:33:32.199269
640	7	What is blockchain technology?	mcq	2	90	\N	\N	t	2026-06-20 20:33:32.199575	2026-06-20 20:33:32.199575
641	7	Cryptocurrency is best described as?	mcq	2	91	\N	\N	t	2026-06-20 20:33:32.199575	2026-06-20 20:33:32.199575
642	7	What is ethical hacking?	mcq	2	92	\N	\N	t	2026-06-20 20:33:32.199575	2026-06-20 20:33:32.199575
643	7	E-commerce refers to?	mcq	2	93	\N	\N	t	2026-06-20 20:33:32.199575	2026-06-20 20:33:32.199575
644	7	Mobile apps can be developed for which of the following platforms?	mcq	2	94	\N	\N	t	2026-06-20 20:33:32.199575	2026-06-20 20:33:32.199575
645	7	Which of the following is an example of an e-commerce platform?	mcq	2	95	\N	\N	t	2026-06-20 20:33:32.217114	2026-06-20 20:33:32.217114
646	7	Which of the following best describes a computer network?	mcq	2	96	\N	\N	t	2026-06-20 20:33:32.220111	2026-06-20 20:33:32.220111
647	7	What is the purpose of a repeater in a network?	mcq	2	97	\N	\N	t	2026-06-20 20:33:32.223109	2026-06-20 20:33:32.223109
648	7	Which layer of the OSI model is responsible for breaking data into segments?	mcq	2	98	\N	\N	t	2026-06-20 20:33:32.226107	2026-06-20 20:33:32.226107
649	7	What does the term 'bandwidth' refer to in networking?	mcq	2	99	\N	\N	t	2026-06-20 20:33:32.228106	2026-06-20 20:33:32.228106
650	7	In the OSI model, which layer adds source and destination MAC addresses to a frame?	mcq	2	100	\N	\N	t	2026-06-20 20:33:32.231104	2026-06-20 20:33:32.231104
651	8	Music is the arrangement of ______.	mcq	2	1	\N	\N	t	2026-06-20 21:30:02.05205	2026-06-20 21:30:02.05205
652	8	Which of these is an importance of music?	mcq	2	2	\N	\N	t	2026-06-20 21:30:02.068459	2026-06-20 21:30:02.068459
653	8	Music can be used for ______.	mcq	2	3	\N	\N	t	2026-06-20 21:30:02.085151	2026-06-20 21:30:02.085151
654	8	Traditional music belongs to a people's ______.	mcq	2	4	\N	\N	t	2026-06-20 21:30:02.11644	2026-06-20 21:30:02.11644
655	8	Which of these is a type of music?	mcq	2	5	\N	\N	t	2026-06-20 21:30:02.122437	2026-06-20 21:30:02.122437
656	8	Gospel music is used mainly for ______.	mcq	2	6	\N	\N	t	2026-06-20 21:30:02.125466	2026-06-20 21:30:02.125466
657	8	A drum is a ______ instrument.	mcq	2	7	\N	\N	t	2026-06-20 21:30:02.125466	2026-06-20 21:30:02.125466
658	8	Which of these is a musical instrument?	mcq	2	8	\N	\N	t	2026-06-20 21:30:02.132155	2026-06-20 21:30:02.132155
659	8	The piano is used to produce ______.	mcq	2	9	\N	\N	t	2026-06-20 21:30:02.134316	2026-06-20 21:30:02.134316
660	8	Which of these is a wind instrument?	mcq	2	10	\N	\N	t	2026-06-20 21:30:02.134316	2026-06-20 21:30:02.134316
661	8	Drama is the art of ______.	mcq	2	11	\N	\N	t	2026-06-20 21:30:02.134316	2026-06-20 21:30:02.134316
662	8	A person who acts in a drama is called an ______.	mcq	2	12	\N	\N	t	2026-06-20 21:30:02.134316	2026-06-20 21:30:02.134316
663	8	The story in a drama is called the ______.	mcq	2	13	\N	\N	t	2026-06-20 21:30:02.134316	2026-06-20 21:30:02.134316
664	8	Which is an element of drama?	mcq	2	14	\N	\N	t	2026-06-20 21:30:02.151232	2026-06-20 21:30:02.151232
665	8	The place where a drama is performed is called a ______.	mcq	2	15	\N	\N	t	2026-06-20 21:30:02.151232	2026-06-20 21:30:02.151232
666	8	Culture refers to the ______ of a people.	mcq	2	16	\N	\N	t	2026-06-20 21:30:02.151232	2026-06-20 21:30:02.151232
667	8	Respect for elders is a cultural ______.	mcq	2	17	\N	\N	t	2026-06-20 21:30:02.151232	2026-06-20 21:30:02.151232
668	8	Honesty is an example of a cultural ______.	mcq	2	18	\N	\N	t	2026-06-20 21:30:02.165462	2026-06-20 21:30:02.165462
669	8	Culture helps to preserve people's ______.	mcq	2	19	\N	\N	t	2026-06-20 21:30:02.167807	2026-06-20 21:30:02.167807
670	8	A festival is a period of ______.	mcq	2	20	\N	\N	t	2026-06-20 21:30:02.167807	2026-06-20 21:30:02.167807
671	8	Festivals promote ______ among people.	mcq	2	21	\N	\N	t	2026-06-20 21:30:02.167807	2026-06-20 21:30:02.167807
672	8	Traditional entertainment includes ______.	mcq	2	22	\N	\N	t	2026-06-20 21:30:02.167807	2026-06-20 21:30:02.167807
673	8	Which of these is a traditional entertainment activity?	mcq	2	23	\N	\N	t	2026-06-20 21:30:02.183741	2026-06-20 21:30:02.183741
674	8	Cultural festivals showcase people's ______.	mcq	2	24	\N	\N	t	2026-06-20 21:30:02.18448	2026-06-20 21:30:02.18448
675	8	Art is used to express ______.	mcq	2	25	\N	\N	t	2026-06-20 21:30:02.18448	2026-06-20 21:30:02.18448
676	8	Appreciating art means ______.	mcq	2	26	\N	\N	t	2026-06-20 21:30:02.18448	2026-06-20 21:30:02.18448
677	8	Which of these is an art material?	mcq	2	27	\N	\N	t	2026-06-20 21:30:02.18448	2026-06-20 21:30:02.18448
678	8	Dance is often accompanied by ______.	mcq	2	28	\N	\N	t	2026-06-20 21:30:02.200875	2026-06-20 21:30:02.200875
679	8	The guitar belongs to the ______ family of instruments.	mcq	2	29	\N	\N	t	2026-06-20 21:30:02.200875	2026-06-20 21:30:02.200875
680	8	One way to preserve culture is by ______.	mcq	2	30	\N	\N	t	2026-06-20 21:30:02.200875	2026-06-20 21:30:02.200875
681	9	The principal advised the students ______ hard for the examination.	mcq	1	1	\N	\N	t	2026-06-24 21:40:25.842128	2026-06-24 21:40:25.842128
682	9	If I ______ enough money, I would buy a new laptop.	mcq	1	2	\N	\N	t	2026-06-24 21:40:25.92351	2026-06-24 21:40:25.92351
683	9	The boys have been playing football ______ morning.	mcq	1	3	\N	\N	t	2026-06-24 21:40:26.111158	2026-06-24 21:40:26.111158
684	9	Neither John nor his friends ______ present at the meeting.	mcq	1	4	\N	\N	t	2026-06-24 21:40:26.124079	2026-06-24 21:40:26.124079
685	9	We arrived ______ the airport before noon.	mcq	1	5	\N	\N	t	2026-06-24 21:40:26.13006	2026-06-24 21:40:26.13006
686	9	My sister is interested ______ music.	mcq	1	6	\N	\N	t	2026-06-24 21:40:26.134611	2026-06-24 21:40:26.134611
687	9	The teacher, together with his students, ______ attending the seminar.	mcq	1	7	\N	\N	t	2026-06-24 21:40:26.134611	2026-06-24 21:40:26.134611
688	9	She speaks English more fluently ______ her brother.	mcq	1	8	\N	\N	t	2026-06-24 21:40:26.134611	2026-06-24 21:40:26.134611
689	9	The robbers ______ before the police arrived.	mcq	1	9	\N	\N	t	2026-06-24 21:40:26.153473	2026-06-24 21:40:26.153473
690	9	He is one of the best players ______ the team.	mcq	1	10	\N	\N	t	2026-06-24 21:40:26.153473	2026-06-24 21:40:26.153473
691	9	The news ______ surprising.	mcq	1	11	\N	\N	t	2026-06-24 21:40:26.153473	2026-06-24 21:40:26.153473
692	9	We should always be proud ______ our country.	mcq	1	12	\N	\N	t	2026-06-24 21:40:26.170328	2026-06-24 21:40:26.170328
693	9	Had he studied harder, he ______ the examination.	mcq	1	13	\N	\N	t	2026-06-24 21:40:26.175324	2026-06-24 21:40:26.175324
694	9	The teacher asked me ______ the window.	mcq	1	14	\N	\N	t	2026-06-24 21:40:26.180324	2026-06-24 21:40:26.180324
695	9	She has lived here ______ 2018.	mcq	1	15	\N	\N	t	2026-06-24 21:40:26.185293	2026-06-24 21:40:26.185293
696	9	The opposite of "scarcity" is ______.	mcq	1	16	\N	\N	t	2026-06-24 21:40:26.188293	2026-06-24 21:40:26.188293
697	9	The word nearest in meaning to "diligent" is ______.	mcq	1	17	\N	\N	t	2026-06-24 21:40:26.191291	2026-06-24 21:40:26.191291
698	9	The manager was angry ______ the workers.	mcq	1	18	\N	\N	t	2026-06-24 21:40:26.194289	2026-06-24 21:40:26.194289
699	9	He was accused ______ stealing the money.	mcq	1	19	\N	\N	t	2026-06-24 21:40:26.196288	2026-06-24 21:40:26.196288
700	9	The students were punished because they behaved ______.	mcq	1	20	\N	\N	t	2026-06-24 21:40:26.199286	2026-06-24 21:40:26.199286
701	9	We have not seen him ______ last week.	mcq	1	21	\N	\N	t	2026-06-24 21:40:26.201138	2026-06-24 21:40:26.201138
702	9	The meeting was postponed ______ the heavy rain.	mcq	1	22	\N	\N	t	2026-06-24 21:40:26.201138	2026-06-24 21:40:26.201138
703	9	Everybody in the class ______ happy.	mcq	1	23	\N	\N	t	2026-06-24 21:40:26.201138	2026-06-24 21:40:26.201138
704	9	The house was built ______ bricks.	mcq	1	24	\N	\N	t	2026-06-24 21:40:26.201138	2026-06-24 21:40:26.201138
705	9	She prefers tea ______ coffee.	mcq	1	25	\N	\N	t	2026-06-24 21:40:26.201138	2026-06-24 21:40:26.201138
706	9	We look forward to ______ from you soon.	mcq	1	26	\N	\N	t	2026-06-24 21:40:26.24285	2026-06-24 21:40:26.24285
707	9	The thief ran away to avoid ______.	mcq	1	27	\N	\N	t	2026-06-24 21:40:26.245848	2026-06-24 21:40:26.245848
708	9	The synonym of "rapid" is ______.	mcq	1	28	\N	\N	t	2026-06-24 21:40:26.247848	2026-06-24 21:40:26.247848
709	9	The doctor advised him to cut down ______ sugar.	mcq	1	29	\N	\N	t	2026-06-24 21:40:26.250846	2026-06-24 21:40:26.250846
710	9	The students congratulated themselves ______ their success.	mcq	1	30	\N	\N	t	2026-06-24 21:40:26.253524	2026-06-24 21:40:26.253524
711	9	According to the passage, reading broadens the ______.	mcq	1	31	\N	\N	t	2026-06-24 21:40:26.256522	2026-06-24 21:40:26.256522
712	9	Reading improves ______.	mcq	1	32	\N	\N	t	2026-06-24 21:40:26.25852	2026-06-24 21:40:26.25852
713	9	Students who read regularly often perform ______ academically.	mcq	1	33	\N	\N	t	2026-06-24 21:40:26.261519	2026-06-24 21:40:26.261519
714	9	Reading helps individuals think ______.	mcq	1	34	\N	\N	t	2026-06-24 21:40:26.264517	2026-06-24 21:40:26.264517
715	9	Reading also helps people communicate ______.	mcq	1	35	\N	\N	t	2026-06-24 21:40:26.266515	2026-06-24 21:40:26.266515
716	9	Information is readily available in ______ society.	mcq	1	36	\N	\N	t	2026-06-24 21:40:26.267756	2026-06-24 21:40:26.267756
717	9	Reading is described as an essential ______.	mcq	1	37	\N	\N	t	2026-06-24 21:40:26.267756	2026-06-24 21:40:26.267756
718	9	The passage mainly discusses the ______ of reading.	mcq	1	38	\N	\N	t	2026-06-24 21:40:26.267756	2026-06-24 21:40:26.267756
719	9	Which of the following is NOT mentioned as a benefit of reading?	mcq	1	39	\N	\N	t	2026-06-24 21:40:26.267756	2026-06-24 21:40:26.267756
720	9	A suitable title for the passage is:	mcq	1	40	\N	\N	t	2026-06-24 21:40:26.267756	2026-06-24 21:40:26.267756
721	9	Good time management increases ______.	mcq	1	41	\N	\N	t	2026-06-24 21:40:26.267756	2026-06-24 21:40:26.267756
722	9	It helps to reduce ______.	mcq	1	42	\N	\N	t	2026-06-24 21:40:26.285853	2026-06-24 21:40:26.285853
723	9	Time management helps people meet ______.	mcq	1	43	\N	\N	t	2026-06-24 21:40:26.285853	2026-06-24 21:40:26.285853
724	9	It improves ______.	mcq	1	44	\N	\N	t	2026-06-24 21:40:26.285853	2026-06-24 21:40:26.285853
725	9	Good time management creates balance between work and ______.	mcq	1	45	\N	\N	t	2026-06-24 21:40:26.285853	2026-06-24 21:40:26.285853
726	9	A person who manages time well is likely to be more ______.	mcq	1	46	\N	\N	t	2026-06-24 21:40:26.285853	2026-06-24 21:40:26.285853
727	9	The main idea of the passage is the ______ of time management.	mcq	1	47	\N	\N	t	2026-06-24 21:40:26.285853	2026-06-24 21:40:26.285853
728	9	Time management contributes to better ______.	mcq	1	48	\N	\N	t	2026-06-24 21:40:26.303375	2026-06-24 21:40:26.303375
729	9	One result of poor time management is likely to be ______.	mcq	1	49	\N	\N	t	2026-06-24 21:40:26.306373	2026-06-24 21:40:26.306373
730	9	The summary can best be titled:	mcq	1	50	\N	\N	t	2026-06-24 21:40:26.309371	2026-06-24 21:40:26.309371
762	10	According to the passage, reading broadens the ______.	mcq	1	31	\N	\N	t	2026-06-24 21:51:49.041106	2026-06-24 21:51:49.041106
763	10	Reading improves ______.	mcq	1	32	\N	\N	t	2026-06-24 21:51:49.043487	2026-06-24 21:51:49.043487
764	10	Students who read regularly often perform ______ academically.	mcq	1	33	\N	\N	t	2026-06-24 21:51:49.043487	2026-06-24 21:51:49.043487
765	10	Reading helps individuals think ______.	mcq	1	34	\N	\N	t	2026-06-24 21:51:49.043487	2026-06-24 21:51:49.043487
766	10	Reading also helps people communicate ______.	mcq	1	35	\N	\N	t	2026-06-24 21:51:49.043487	2026-06-24 21:51:49.043487
767	10	Information is readily available in ______ society.	mcq	1	36	\N	\N	t	2026-06-24 21:51:49.043487	2026-06-24 21:51:49.043487
768	10	Reading is described as an essential ______.	mcq	1	37	\N	\N	t	2026-06-24 21:51:49.059728	2026-06-24 21:51:49.059728
769	10	The passage mainly discusses the ______ of reading.	mcq	1	38	\N	\N	t	2026-06-24 21:51:49.060021	2026-06-24 21:51:49.060021
770	10	Which of the following is NOT mentioned as a benefit of reading?	mcq	1	39	\N	\N	t	2026-06-24 21:51:49.060021	2026-06-24 21:51:49.060021
771	10	A suitable title for the passage is:	mcq	1	40	\N	\N	t	2026-06-24 21:51:49.060021	2026-06-24 21:51:49.060021
772	10	Good time management increases ______.	mcq	1	41	\N	\N	t	2026-06-24 21:51:49.060021	2026-06-24 21:51:49.060021
773	10	It helps to reduce ______.	mcq	1	42	\N	\N	t	2026-06-24 21:51:49.075383	2026-06-24 21:51:49.075383
774	10	Time management helps people meet ______.	mcq	1	43	\N	\N	t	2026-06-24 21:51:49.078382	2026-06-24 21:51:49.078382
775	10	It improves ______.	mcq	1	44	\N	\N	t	2026-06-24 21:51:49.08138	2026-06-24 21:51:49.08138
776	10	Good time management creates balance between work and ______.	mcq	1	45	\N	\N	t	2026-06-24 21:51:49.084378	2026-06-24 21:51:49.084378
777	10	A person who manages time well is likely to be more ______.	mcq	1	46	\N	\N	t	2026-06-24 21:51:49.088373	2026-06-24 21:51:49.088373
778	10	The main idea of the passage is the ______ of time management.	mcq	1	47	\N	\N	t	2026-06-24 21:51:49.091433	2026-06-24 21:51:49.091433
779	10	Time management contributes to better ______.	mcq	1	48	\N	\N	t	2026-06-24 21:51:49.091433	2026-06-24 21:51:49.091433
780	10	One result of poor time management is likely to be ______.	mcq	1	49	\N	\N	t	2026-06-24 21:51:49.091433	2026-06-24 21:51:49.091433
781	10	The summary can best be titled:	mcq	1	50	\N	\N	t	2026-06-24 21:51:49.091433	2026-06-24 21:51:49.091433
813	11	According to the passage, reading broadens the ______.	mcq	1	31	\N	\N	t	2026-06-24 21:54:52.298928	2026-06-24 21:54:52.298928
814	11	Reading improves ______.	mcq	1	32	\N	\N	t	2026-06-24 21:54:52.332105	2026-06-24 21:54:52.332105
815	11	Students who read regularly often perform ______ academically.	mcq	1	33	\N	\N	t	2026-06-24 21:54:52.332105	2026-06-24 21:54:52.332105
816	11	Reading helps individuals think ______.	mcq	1	34	\N	\N	t	2026-06-24 21:54:52.332105	2026-06-24 21:54:52.332105
817	11	Reading also helps people communicate ______.	mcq	1	35	\N	\N	t	2026-06-24 21:54:52.332105	2026-06-24 21:54:52.332105
818	11	Information is readily available in ______ society.	mcq	1	36	\N	\N	t	2026-06-24 21:54:52.350221	2026-06-24 21:54:52.350221
819	11	Reading is described as an essential ______.	mcq	1	37	\N	\N	t	2026-06-24 21:54:52.350221	2026-06-24 21:54:52.350221
820	11	The passage mainly discusses the ______ of reading.	mcq	1	38	\N	\N	t	2026-06-24 21:54:52.365203	2026-06-24 21:54:52.365203
821	11	Which of the following is NOT mentioned as a benefit of reading?	mcq	1	39	\N	\N	t	2026-06-24 21:54:52.368757	2026-06-24 21:54:52.368757
822	11	A suitable title for the passage is:	mcq	1	40	\N	\N	t	2026-06-24 21:54:52.379939	2026-06-24 21:54:52.379939
823	11	Good time management increases ______.	mcq	1	41	\N	\N	t	2026-06-24 21:54:52.386936	2026-06-24 21:54:52.386936
824	11	It helps to reduce ______.	mcq	1	42	\N	\N	t	2026-06-24 21:54:52.393932	2026-06-24 21:54:52.393932
825	11	Time management helps people meet ______.	mcq	1	43	\N	\N	t	2026-06-24 21:54:52.400928	2026-06-24 21:54:52.400928
826	11	It improves ______.	mcq	1	44	\N	\N	t	2026-06-24 21:54:52.40592	2026-06-24 21:54:52.40592
827	11	Good time management creates balance between work and ______.	mcq	1	45	\N	\N	t	2026-06-24 21:54:52.407919	2026-06-24 21:54:52.407919
828	11	A person who manages time well is likely to be more ______.	mcq	1	46	\N	\N	t	2026-06-24 21:54:52.410917	2026-06-24 21:54:52.410917
829	11	The main idea of the passage is the ______ of time management.	mcq	1	47	\N	\N	t	2026-06-24 21:54:52.414252	2026-06-24 21:54:52.414252
830	11	Time management contributes to better ______.	mcq	1	48	\N	\N	t	2026-06-24 21:54:52.41725	2026-06-24 21:54:52.41725
831	11	One result of poor time management is likely to be ______.	mcq	1	49	\N	\N	t	2026-06-24 21:54:52.420249	2026-06-24 21:54:52.420249
832	11	The summary can best be titled:	mcq	1	50	\N	\N	t	2026-06-24 21:54:52.423246	2026-06-24 21:54:52.423246
833	11	The principal advised the students ______ hard for the examination.	mcq	1	21	\N	\N	t	2026-06-24 22:00:51.215665	2026-06-24 22:00:51.215665
834	11	If I ______ enough money, I would buy a new laptop.	mcq	1	22	\N	\N	t	2026-06-24 22:00:51.215665	2026-06-24 22:00:51.215665
835	11	The boys have been playing football ______ morning.	mcq	1	23	\N	\N	t	2026-06-24 22:00:51.262536	2026-06-24 22:00:51.262536
836	11	Neither John nor his friends ______ present at the meeting.	mcq	1	24	\N	\N	t	2026-06-24 22:00:51.264581	2026-06-24 22:00:51.264581
837	11	We arrived ______ the airport before noon.	mcq	1	25	\N	\N	t	2026-06-24 22:00:51.264581	2026-06-24 22:00:51.264581
838	11	My sister is interested ______ music.	mcq	1	26	\N	\N	t	2026-06-24 22:00:51.264581	2026-06-24 22:00:51.264581
839	11	The teacher, together with his students, ______ attending the seminar.	mcq	1	27	\N	\N	t	2026-06-24 22:00:51.264581	2026-06-24 22:00:51.264581
840	11	She speaks English more fluently ______ her brother.	mcq	1	28	\N	\N	t	2026-06-24 22:00:51.28022	2026-06-24 22:00:51.28022
841	11	The robbers ______ before the police arrived.	mcq	1	29	\N	\N	t	2026-06-24 22:00:51.281615	2026-06-24 22:00:51.281615
842	11	He is one of the best players ______ the team.	mcq	1	30	\N	\N	t	2026-06-24 22:00:51.281615	2026-06-24 22:00:51.281615
843	11	The news ______ surprising.	mcq	1	31	\N	\N	t	2026-06-24 22:00:51.281615	2026-06-24 22:00:51.281615
844	11	We should always be proud ______ our country.	mcq	1	32	\N	\N	t	2026-06-24 22:00:51.298729	2026-06-24 22:00:51.298729
845	11	Had he studied harder, he ______ the examination.	mcq	1	33	\N	\N	t	2026-06-24 22:00:51.298729	2026-06-24 22:00:51.298729
846	11	The teacher asked me ______ the window.	mcq	1	34	\N	\N	t	2026-06-24 22:00:51.298729	2026-06-24 22:00:51.298729
847	11	She has lived here ______ 2018.	mcq	1	35	\N	\N	t	2026-06-24 22:00:51.298729	2026-06-24 22:00:51.298729
848	11	The opposite of "scarcity" is ______.	mcq	1	36	\N	\N	t	2026-06-24 22:00:51.315002	2026-06-24 22:00:51.315002
849	11	The word nearest in meaning to "diligent" is ______.	mcq	1	37	\N	\N	t	2026-06-24 22:00:51.315002	2026-06-24 22:00:51.315002
850	11	The manager was angry ______ the workers.	mcq	1	38	\N	\N	t	2026-06-24 22:00:51.315002	2026-06-24 22:00:51.315002
851	11	He was accused ______ stealing the money.	mcq	1	39	\N	\N	t	2026-06-24 22:00:51.315002	2026-06-24 22:00:51.315002
852	11	The students were punished because they behaved ______.	mcq	1	40	\N	\N	t	2026-06-24 22:00:51.315002	2026-06-24 22:00:51.315002
853	11	We have not seen him ______ last week.	mcq	1	41	\N	\N	t	2026-06-24 22:00:51.331665	2026-06-24 22:00:51.331665
854	11	The meeting was postponed ______ the heavy rain.	mcq	1	42	\N	\N	t	2026-06-24 22:00:51.331665	2026-06-24 22:00:51.331665
855	11	Everybody in the class ______ happy.	mcq	1	43	\N	\N	t	2026-06-24 22:00:51.331665	2026-06-24 22:00:51.331665
856	11	The house was built ______ bricks.	mcq	1	44	\N	\N	t	2026-06-24 22:00:51.331665	2026-06-24 22:00:51.331665
857	11	She prefers tea ______ coffee.	mcq	1	45	\N	\N	t	2026-06-24 22:00:51.331665	2026-06-24 22:00:51.331665
858	11	We look forward to ______ from you soon.	mcq	1	46	\N	\N	t	2026-06-24 22:00:51.3479	2026-06-24 22:00:51.3479
859	11	The thief ran away to avoid ______.	mcq	1	47	\N	\N	t	2026-06-24 22:00:51.3479	2026-06-24 22:00:51.3479
860	11	The synonym of "rapid" is ______.	mcq	1	48	\N	\N	t	2026-06-24 22:00:51.3479	2026-06-24 22:00:51.3479
861	11	The doctor advised him to cut down ______ sugar.	mcq	1	49	\N	\N	t	2026-06-24 22:00:51.3479	2026-06-24 22:00:51.3479
862	11	The students congratulated themselves ______ their success.	mcq	1	50	\N	\N	t	2026-06-24 22:00:51.3479	2026-06-24 22:00:51.3479
863	11	Read the passage carefully and answer the questions that follow.\n\nReading is one of the most rewarding habits a student can develop. It broadens the mind, improves vocabulary, and exposes learners to new ideas. Students who cultivate the habit of reading regularly often perform better academically than those who do not. Reading also helps individuals to think critically and communicate effectively. In modern society, where information is readily available, reading remains an essential tool for personal and academic development.According to the passage, reading broadens the ______.	mcq	1	51	\N	\N	t	2026-06-24 22:00:51.364864	2026-06-24 22:00:51.364864
864	11	Reading improves ______.	mcq	1	52	\N	\N	t	2026-06-24 22:00:51.364864	2026-06-24 22:00:51.364864
865	11	Students who read regularly often perform ______ academically.	mcq	1	53	\N	\N	t	2026-06-24 22:00:51.364864	2026-06-24 22:00:51.364864
866	11	Reading helps individuals think ______.	mcq	1	54	\N	\N	t	2026-06-24 22:00:51.364864	2026-06-24 22:00:51.364864
867	11	Reading also helps people communicate ______.	mcq	1	55	\N	\N	t	2026-06-24 22:00:51.364864	2026-06-24 22:00:51.364864
868	11	Information is readily available in ______ society.	mcq	1	56	\N	\N	t	2026-06-24 22:00:51.381554	2026-06-24 22:00:51.381554
869	11	Reading is described as an essential ______.	mcq	1	57	\N	\N	t	2026-06-24 22:00:51.381554	2026-06-24 22:00:51.381554
870	11	The passage mainly discusses the ______ of reading.	mcq	1	58	\N	\N	t	2026-06-24 22:00:51.381554	2026-06-24 22:00:51.381554
871	11	Which of the following is NOT mentioned as a benefit of reading?	mcq	1	59	\N	\N	t	2026-06-24 22:00:51.381554	2026-06-24 22:00:51.381554
872	11	A suitable title for the passage is:	mcq	1	60	\N	\N	t	2026-06-24 22:00:51.381554	2026-06-24 22:00:51.381554
873	11	Good time management increases ______.	mcq	1	61	\N	\N	t	2026-06-24 22:00:51.397316	2026-06-24 22:00:51.397316
874	11	It helps to reduce ______.	mcq	1	62	\N	\N	t	2026-06-24 22:00:51.398058	2026-06-24 22:00:51.398058
875	11	Time management helps people meet ______.	mcq	1	63	\N	\N	t	2026-06-24 22:00:51.398058	2026-06-24 22:00:51.398058
876	11	It improves ______.	mcq	1	64	\N	\N	t	2026-06-24 22:00:51.398058	2026-06-24 22:00:51.398058
877	11	Good time management creates balance between work and ______.	mcq	1	65	\N	\N	t	2026-06-24 22:00:51.398058	2026-06-24 22:00:51.398058
878	11	A person who manages time well is likely to be more ______.	mcq	1	66	\N	\N	t	2026-06-24 22:00:51.412435	2026-06-24 22:00:51.412435
879	11	The main idea of the passage is the ______ of time management.	mcq	1	67	\N	\N	t	2026-06-24 22:00:51.414965	2026-06-24 22:00:51.414965
880	11	Time management contributes to better ______.	mcq	1	68	\N	\N	t	2026-06-24 22:00:51.414965	2026-06-24 22:00:51.414965
881	11	One result of poor time management is likely to be ______.	mcq	1	69	\N	\N	t	2026-06-24 22:00:51.414965	2026-06-24 22:00:51.414965
882	11	The summary can best be titled:	mcq	1	70	\N	\N	t	2026-06-24 22:00:51.414965	2026-06-24 22:00:51.414965
883	12	The principal advised the students ______ hard for the examination.	mcq	1	1	\N	\N	t	2026-06-24 22:04:37.49091	2026-06-24 22:04:37.49091
884	12	If I ______ enough money, I would buy a new laptop.	mcq	1	2	\N	\N	t	2026-06-24 22:04:37.540216	2026-06-24 22:04:37.540216
885	12	The boys have been playing football ______ morning.	mcq	1	3	\N	\N	t	2026-06-24 22:04:37.555619	2026-06-24 22:04:37.555619
886	12	Neither John nor his friends ______ present at the meeting.	mcq	1	4	\N	\N	t	2026-06-24 22:04:37.556774	2026-06-24 22:04:37.556774
887	12	We arrived ______ the airport before noon.	mcq	1	5	\N	\N	t	2026-06-24 22:04:37.556774	2026-06-24 22:04:37.556774
888	12	My sister is interested ______ music.	mcq	1	6	\N	\N	t	2026-06-24 22:04:37.556774	2026-06-24 22:04:37.556774
889	12	The teacher, together with his students, ______ attending the seminar.	mcq	1	7	\N	\N	t	2026-06-24 22:04:37.556774	2026-06-24 22:04:37.556774
890	12	She speaks English more fluently ______ her brother.	mcq	1	8	\N	\N	t	2026-06-24 22:04:37.57228	2026-06-24 22:04:37.57228
891	12	The robbers ______ before the police arrived.	mcq	1	9	\N	\N	t	2026-06-24 22:04:37.573844	2026-06-24 22:04:37.573844
892	12	He is one of the best players ______ the team.	mcq	1	10	\N	\N	t	2026-06-24 22:04:37.573844	2026-06-24 22:04:37.573844
893	12	The news ______ surprising.	mcq	1	11	\N	\N	t	2026-06-24 22:04:37.573844	2026-06-24 22:04:37.573844
894	12	We should always be proud ______ our country.	mcq	1	12	\N	\N	t	2026-06-24 22:04:37.573844	2026-06-24 22:04:37.573844
895	12	Had he studied harder, he ______ the examination.	mcq	1	13	\N	\N	t	2026-06-24 22:04:37.573844	2026-06-24 22:04:37.573844
896	12	The teacher asked me ______ the window.	mcq	1	14	\N	\N	t	2026-06-24 22:04:37.590222	2026-06-24 22:04:37.590222
897	12	She has lived here ______ 2018.	mcq	1	15	\N	\N	t	2026-06-24 22:04:37.606319	2026-06-24 22:04:37.606319
898	12	The opposite of "scarcity" is ______.	mcq	1	16	\N	\N	t	2026-06-24 22:04:37.606816	2026-06-24 22:04:37.606816
899	12	The word nearest in meaning to "diligent" is ______.	mcq	1	17	\N	\N	t	2026-06-24 22:04:37.606816	2026-06-24 22:04:37.606816
900	12	The manager was angry ______ the workers.	mcq	1	18	\N	\N	t	2026-06-24 22:04:37.606816	2026-06-24 22:04:37.606816
901	12	He was accused ______ stealing the money.	mcq	1	19	\N	\N	t	2026-06-24 22:04:37.606816	2026-06-24 22:04:37.606816
902	12	The students were punished because they behaved ______.	mcq	1	20	\N	\N	t	2026-06-24 22:04:37.606816	2026-06-24 22:04:37.606816
903	12	We have not seen him ______ last week.	mcq	1	21	\N	\N	t	2026-06-24 22:04:37.623726	2026-06-24 22:04:37.623726
904	12	The meeting was postponed ______ the heavy rain.	mcq	1	22	\N	\N	t	2026-06-24 22:04:37.623726	2026-06-24 22:04:37.623726
905	12	Everybody in the class ______ happy.	mcq	1	23	\N	\N	t	2026-06-24 22:04:37.623726	2026-06-24 22:04:37.623726
906	12	The house was built ______ bricks.	mcq	1	24	\N	\N	t	2026-06-24 22:04:37.623726	2026-06-24 22:04:37.623726
907	12	She prefers tea ______ coffee.	mcq	1	25	\N	\N	t	2026-06-24 22:04:37.623726	2026-06-24 22:04:37.623726
908	12	We look forward to ______ from you soon.	mcq	1	26	\N	\N	t	2026-06-24 22:04:37.639438	2026-06-24 22:04:37.639438
909	12	The thief ran away to avoid ______.	mcq	1	27	\N	\N	t	2026-06-24 22:04:37.640127	2026-06-24 22:04:37.640127
910	12	The synonym of "rapid" is ______.	mcq	1	28	\N	\N	t	2026-06-24 22:04:37.640127	2026-06-24 22:04:37.640127
911	12	The doctor advised him to cut down ______ sugar.	mcq	1	29	\N	\N	t	2026-06-24 22:04:37.640127	2026-06-24 22:04:37.640127
912	12	The students congratulated themselves ______ their success.	mcq	1	30	\N	\N	t	2026-06-24 22:04:37.640127	2026-06-24 22:04:37.640127
980	13	Preserving historical sites is important because:	mcq	1	8	\N	\N	t	2026-06-30 20:06:48.154119	2026-06-30 20:06:48.154119
981	13	The Benin City Walls were built mainly for:	mcq	1	9	\N	\N	t	2026-06-30 20:06:48.154119	2026-06-30 20:06:48.154119
982	13	Which is NOT a historical site?	mcq	1	10	\N	\N	t	2026-06-30 20:06:48.154119	2026-06-30 20:06:48.154119
913	12	Read the passage carefully and answer the questions that follow.\n\nReading is one of the most rewarding habits a student can develop. It broadens the mind, improves vocabulary, and exposes learners to new ideas. Students who cultivate the habit of reading regularly often perform better academically than those who do not. Reading also helps individuals to think critically and communicate effectively. In modern society, where information is readily available, reading remains an essential tool for personal and academic development.According to the passage, reading broadens the ______.	mcq	1	31	\N	\N	t	2026-06-24 22:04:37.640127	2026-06-24 22:04:37.640127
915	12	Students who read regularly often perform ______ academically.	mcq	1	33	\N	\N	t	2026-06-24 22:04:37.656697	2026-06-24 22:04:37.656697
916	12	Reading helps individuals think ______.	mcq	1	34	\N	\N	t	2026-06-24 22:04:37.656697	2026-06-24 22:04:37.656697
917	12	Reading also helps people communicate ______.	mcq	1	35	\N	\N	t	2026-06-24 22:04:37.656697	2026-06-24 22:04:37.656697
918	12	Information is readily available in ______ society.	mcq	1	36	\N	\N	t	2026-06-24 22:04:37.656697	2026-06-24 22:04:37.656697
919	12	Reading is described as an essential ______.	mcq	1	37	\N	\N	t	2026-06-24 22:04:37.671189	2026-06-24 22:04:37.671189
920	12	The passage mainly discusses the ______ of reading.	mcq	1	38	\N	\N	t	2026-06-24 22:04:37.67348	2026-06-24 22:04:37.67348
921	12	Which of the following is NOT mentioned as a benefit of reading?	mcq	1	39	\N	\N	t	2026-06-24 22:04:37.67348	2026-06-24 22:04:37.67348
922	12	A suitable title for the passage is:	mcq	1	40	\N	\N	t	2026-06-24 22:04:37.67348	2026-06-24 22:04:37.67348
923	12	Good time management increases ______.	mcq	1	41	\N	\N	t	2026-06-24 22:04:37.67348	2026-06-24 22:04:37.67348
924	12	It helps to reduce ______.	mcq	1	42	\N	\N	t	2026-06-24 22:04:37.67348	2026-06-24 22:04:37.67348
925	12	Time management helps people meet ______.	mcq	1	43	\N	\N	t	2026-06-24 22:04:37.688844	2026-06-24 22:04:37.688844
926	12	It improves ______.	mcq	1	44	\N	\N	t	2026-06-24 22:04:37.689858	2026-06-24 22:04:37.689858
927	12	Good time management creates balance between work and ______.	mcq	1	45	\N	\N	t	2026-06-24 22:04:37.689858	2026-06-24 22:04:37.689858
928	12	A person who manages time well is likely to be more ______.	mcq	1	46	\N	\N	t	2026-06-24 22:04:37.696865	2026-06-24 22:04:37.696865
929	12	The main idea of the passage is the ______ of time management.	mcq	1	47	\N	\N	t	2026-06-24 22:04:37.696865	2026-06-24 22:04:37.696865
930	12	Time management contributes to better ______.	mcq	1	48	\N	\N	t	2026-06-24 22:04:37.696865	2026-06-24 22:04:37.696865
931	12	One result of poor time management is likely to be ______.	mcq	1	49	\N	\N	t	2026-06-24 22:04:37.707684	2026-06-24 22:04:37.707684
932	12	The summary can best be titled:	mcq	1	50	\N	\N	t	2026-06-24 22:04:37.711685	2026-06-24 22:04:37.711685
914	12	Read the passage carefully and answer the questions that follow.\r\n\r\nReading is one of the most rewarding habits a student can develop. It broadens the mind, improves vocabulary, and exposes learners to new ideas. Students who cultivate the habit of reading regularly often perform better academically than those who do not. Reading also helps individuals to think critically and communicate effectively. In modern society, where information is readily available, reading remains an essential tool for personal and academic development.\r\nReading improves ______.	mcq	1	32	None	\N	t	2026-06-24 22:04:37.656697	2026-06-24 22:07:42.797646
973	13	Historical sites are places that:	mcq	1	1	\N	\N	t	2026-06-30 20:06:47.82126	2026-06-30 20:06:47.82126
974	13	Sukur Cultural Landscape is located in:	mcq	1	2	\N	\N	t	2026-06-30 20:06:48.000354	2026-06-30 20:06:48.000354
975	13	Which site is known for ancient bronze and iron works?	mcq	1	3	\N	\N	t	2026-06-30 20:06:48.137965	2026-06-30 20:06:48.137965
976	13	Olumo Rock is a historical site found in:	mcq	1	4	\N	\N	t	2026-06-30 20:06:48.142964	2026-06-30 20:06:48.142964
977	13	The Nok Culture is famous for:	mcq	1	5	\N	\N	t	2026-06-30 20:06:48.147961	2026-06-30 20:06:48.147961
978	13	Rijiyar Zaki Well in Kano was built for:	mcq	1	6	\N	\N	t	2026-06-30 20:06:48.151959	2026-06-30 20:06:48.151959
979	13	Gobarau Minaret in Katsina is an example of:	mcq	1	7	\N	\N	t	2026-06-30 20:06:48.154119	2026-06-30 20:06:48.154119
983	13	Igbo Ukwu is located in present-day:	mcq	1	11	\N	\N	t	2026-06-30 20:06:48.154119	2026-06-30 20:06:48.154119
984	13	Igbo Ukwu became famous due to the discovery of:	mcq	1	12	\N	\N	t	2026-06-30 20:06:48.169744	2026-06-30 20:06:48.169744
985	13	The artifacts at Igbo Ukwu prove that the Igbo had:	mcq	1	13	\N	\N	t	2026-06-30 20:06:48.172314	2026-06-30 20:06:48.172314
986	13	Who discovered the Igbo Ukwu artifacts?	mcq	1	14	\N	\N	t	2026-06-30 20:06:48.172314	2026-06-30 20:06:48.172314
987	13	A major tradition of the Igbo people is:	mcq	1	15	\N	\N	t	2026-06-30 20:06:48.172314	2026-06-30 20:06:48.172314
988	13	“Iri Ji” in Igbo culture means:	mcq	1	16	\N	\N	t	2026-06-30 20:06:48.172314	2026-06-30 20:06:48.172314
989	13	The Igbo traditional system of government before colonialism was mainly:	mcq	1	17	\N	\N	t	2026-06-30 20:06:48.172314	2026-06-30 20:06:48.172314
990	13	Masquerades in Igbo culture are used for:	mcq	1	18	\N	\N	t	2026-06-30 20:06:48.189378	2026-06-30 20:06:48.189378
991	13	“Ilu” in Igbo tradition refers to:	mcq	1	19	\N	\N	t	2026-06-30 20:06:48.192377	2026-06-30 20:06:48.192377
992	13	Kola nut in Igbo culture symbolizes:	mcq	1	20	\N	\N	t	2026-06-30 20:06:48.195375	2026-06-30 20:06:48.195375
993	13	Igbo traditional religion before Christianity was:	mcq	1	21	\N	\N	t	2026-06-30 20:06:48.199372	2026-06-30 20:06:48.199372
994	13	Aro long-distance trade made Igbo Ukwu people:	mcq	1	22	\N	\N	t	2026-06-30 20:06:48.20237	2026-06-30 20:06:48.20237
995	13	The three excavation sites at Igbo Ukwu are:	mcq	1	23	\N	\N	t	2026-06-30 20:06:48.205486	2026-06-30 20:06:48.205486
996	13	One value promoted by Igbo culture is:	mcq	1	24	\N	\N	t	2026-06-30 20:06:48.208484	2026-06-30 20:06:48.208484
997	13	Igbo Ukwu artifacts are now mainly kept at:	mcq	1	25	\N	\N	t	2026-06-30 20:06:48.211483	2026-06-30 20:06:48.211483
998	13	“Precolonial Nigeria” means:	mcq	1	26	\N	\N	t	2026-06-30 20:06:48.217483	2026-06-30 20:06:48.217483
999	13	A centralized state is one that:	mcq	1	27	\N	\N	t	2026-06-30 20:06:48.220865	2026-06-30 20:06:48.220865
1000	13	One characteristic of a centralized state is:	mcq	1	28	\N	\N	t	2026-06-30 20:06:48.220865	2026-06-30 20:06:48.220865
1001	13	Which of these is NOT a feature of centralized states?	mcq	1	29	\N	\N	t	2026-06-30 20:06:48.236496	2026-06-30 20:06:48.236496
1002	13	An example of a centralized state in precolonial Northern Nigeria was:	mcq	1	30	\N	\N	t	2026-06-30 20:06:48.240225	2026-06-30 20:06:48.240225
1003	13	The Oyo Empire was a centralized state in:	mcq	1	31	\N	\N	t	2026-06-30 20:06:48.240225	2026-06-30 20:06:48.240225
1004	13	The head of the Benin Kingdom was called:	mcq	1	32	\N	\N	t	2026-06-30 20:06:48.257733	2026-06-30 20:06:48.257733
1005	13	The Kanem-Bornu Empire was located around:	mcq	1	33	\N	\N	t	2026-06-30 20:06:48.263731	2026-06-30 20:06:48.263731
1006	13	In a centralized state, laws were made by:	mcq	1	34	\N	\N	t	2026-06-30 20:06:48.270722	2026-06-30 20:06:48.270722
1007	13	Tax/tribute in precolonial centralized states was used for:	mcq	1	35	\N	\N	t	2026-06-30 20:06:48.275502	2026-06-30 20:06:48.275502
1008	13	Which state was ruled by an “Emir”?	mcq	1	36	\N	\N	t	2026-06-30 20:06:48.305421	2026-06-30 20:06:48.305421
1009	13	The army in precolonial centralized states was important for:	mcq	1	37	\N	\N	t	2026-06-30 20:06:48.305421	2026-06-30 20:06:48.305421
1010	13	Decentralized states like Igbo had:	mcq	1	38	\N	\N	t	2026-06-30 20:06:48.305421	2026-06-30 20:06:48.305421
1011	13	Nupe Kingdom was a centralized state found in:	mcq	1	39	\N	\N	t	2026-06-30 20:06:48.305421	2026-06-30 20:06:48.305421
1012	13	The “Iwefa” system in Benin Kingdom was about:	mcq	1	40	\N	\N	t	2026-06-30 20:06:48.321741	2026-06-30 20:06:48.321741
1013	13	Trade in precolonial centralized states led to:	mcq	1	41	\N	\N	t	2026-06-30 20:06:48.324738	2026-06-30 20:06:48.324738
1014	13	“Eze” was the title of a king among:	mcq	1	42	\N	\N	t	2026-06-30 20:06:48.327736	2026-06-30 20:06:48.327736
1015	13	One way centralized states maintained unity was through:	mcq	1	43	\N	\N	t	2026-06-30 20:06:48.330735	2026-06-30 20:06:48.330735
1016	13	The fall of Oyo Empire was partly caused by:	mcq	1	44	\N	\N	t	2026-06-30 20:06:48.333733	2026-06-30 20:06:48.333733
1017	13	Precolonial Nigeria was made up of:	mcq	1	45	\N	\N	t	2026-06-30 20:06:48.336729	2026-06-30 20:06:48.336729
1018	13	“Emirate system” under Sokoto Caliphate meant:	mcq	1	46	\N	\N	t	2026-06-30 20:06:48.339721	2026-06-30 20:06:48.339721
1019	13	Walls and moats in cities like Benin and Kano served as:	mcq	1	47	\N	\N	t	2026-06-30 20:06:48.342719	2026-06-30 20:06:48.342719
1020	13	Which group had NO centralized state before colonialism?	mcq	1	48	\N	\N	t	2026-06-30 20:06:48.345717	2026-06-30 20:06:48.345717
1021	13	The capital of Kanem-Bornu Empire was:	mcq	1	49	\N	\N	t	2026-06-30 20:06:48.347716	2026-06-30 20:06:48.347716
1022	13	Studying precolonial Nigeria helps us to:	mcq	1	50	\N	\N	t	2026-06-30 20:06:48.350714	2026-06-30 20:06:48.350714
1023	13	"Christianisme" means .........	mcq	1	51	\N	\N	t	2026-06-30 20:37:16.800845	2026-06-30 20:37:16.800845
1024	13	Minna est la capitale de l'état de/d' ...........	mcq	1	52	\N	\N	t	2026-06-30 20:37:16.81768	2026-06-30 20:37:16.81768
1025	13	'Les grandes routes' means ..........	mcq	1	53	\N	\N	t	2026-06-30 20:37:16.849806	2026-06-30 20:37:16.849806
1026	13	What is 'la radio' in English?	mcq	1	54	\N	\N	t	2026-06-30 20:37:16.850495	2026-06-30 20:37:16.850495
1027	13	What is "l'usine" in English?	mcq	1	55	\N	\N	t	2026-06-30 20:37:16.850495	2026-06-30 20:37:16.850495
1028	13	'asseyez-vous' means .........	mcq	1	56	\N	\N	t	2026-06-30 20:37:16.850495	2026-06-30 20:37:16.850495
1029	13	On mange au .........	mcq	1	57	\N	\N	t	2026-06-30 20:37:16.864728	2026-06-30 20:37:16.864728
1030	13	'Merci beaucoup' means ...........	mcq	1	58	\N	\N	t	2026-06-30 20:37:16.869035	2026-06-30 20:37:16.869035
1031	13	'Handset' is called ...........	mcq	1	59	\N	\N	t	2026-06-30 20:37:16.88157	2026-06-30 20:37:16.88157
1032	13	'trouser' is called .........in French.	mcq	1	60	\N	\N	t	2026-06-30 20:37:16.886076	2026-06-30 20:37:16.886076
1033	13	"L'usine" means ..........	mcq	1	61	\N	\N	t	2026-06-30 20:37:16.901526	2026-06-30 20:37:16.901526
1034	13	"Un ami" means .........	mcq	1	62	\N	\N	t	2026-06-30 20:37:16.902769	2026-06-30 20:37:16.902769
1035	13	"Hat" is called ........... in French	mcq	1	63	\N	\N	t	2026-06-30 20:37:16.918904	2026-06-30 20:37:16.918904
1036	13	......... is a place where buying and selling take place	mcq	1	64	\N	\N	t	2026-06-30 20:37:16.918904	2026-06-30 20:37:16.918904
1037	13	Who is 'la belle-mère'?	mcq	1	65	\N	\N	t	2026-06-30 20:37:16.936134	2026-06-30 20:37:16.936134
1038	13	"Father in-law" is called .......... in French	mcq	1	66	\N	\N	t	2026-06-30 20:37:16.936134	2026-06-30 20:37:16.936134
1039	13	......... is a member of the family	mcq	1	67	\N	\N	t	2026-06-30 20:37:16.952675	2026-06-30 20:37:16.952675
1040	13	"Sister" in French is ..........	mcq	1	68	\N	\N	t	2026-06-30 20:37:16.952675	2026-06-30 20:37:16.952675
1041	13	"Aimer" means ..........	mcq	1	69	\N	\N	t	2026-06-30 20:37:16.969325	2026-06-30 20:37:16.969325
1042	13	"A friend" is called ........... in French	mcq	1	70	\N	\N	t	2026-06-30 20:37:16.969325	2026-06-30 20:37:16.969325
1043	13	"Balayer" means .........	mcq	1	71	\N	\N	t	2026-06-30 20:37:16.986708	2026-06-30 20:37:16.986708
1044	13	Je ........ un pantalon	mcq	1	72	\N	\N	t	2026-06-30 20:37:16.998162	2026-06-30 20:37:16.998162
1045	13	'Les vêtements' means ..........	mcq	1	73	\N	\N	t	2026-06-30 20:37:17.006166	2026-06-30 20:37:17.006166
1046	13	What is ''des chaussures'' in English?	mcq	1	74	\N	\N	t	2026-06-30 20:37:17.015303	2026-06-30 20:37:17.015303
1047	13	What is "le marché" in English?	mcq	1	75	\N	\N	t	2026-06-30 20:37:17.017854	2026-06-30 20:37:17.017854
1048	13	What is "asseyez-vous"?	mcq	1	76	\N	\N	t	2026-06-30 20:37:17.03145	2026-06-30 20:37:17.03145
1049	13	"enseigner" means .........	mcq	1	77	\N	\N	t	2026-06-30 20:37:17.036147	2026-06-30 20:37:17.036147
1050	13	"Grande route" means ...........	mcq	1	78	\N	\N	t	2026-06-30 20:37:17.050349	2026-06-30 20:37:17.050349
1051	13	Mon père ......... une chemise	mcq	1	79	\N	\N	t	2026-06-30 20:37:17.058354	2026-06-30 20:37:17.058354
1052	13	......... is a 1st group verb	mcq	1	80	\N	\N	t	2026-06-30 20:37:17.065404	2026-06-30 20:37:17.065404
1053	13	"Restaurant" is called ......... in French	mcq	1	81	\N	\N	t	2026-06-30 20:37:17.068031	2026-06-30 20:37:17.068031
1054	13	"Shirt" is called ........ in French	mcq	1	82	\N	\N	t	2026-06-30 20:37:17.0814	2026-06-30 20:37:17.0814
1055	13	"Market" is called ......... in French	mcq	1	83	\N	\N	t	2026-06-30 20:37:17.089399	2026-06-30 20:37:17.089399
1056	13	"Silence" means .........	mcq	1	84	\N	\N	t	2026-06-30 20:37:17.098889	2026-06-30 20:37:17.098889
1057	13	"Encore'" means .........	mcq	1	85	\N	\N	t	2026-06-30 20:37:17.106895	2026-06-30 20:37:17.106895
1058	13	"Levez-vous" means .........	mcq	1	86	\N	\N	t	2026-06-30 20:37:17.114547	2026-06-30 20:37:17.114547
1059	13	What do we call 'church' in French?	mcq	1	87	\N	\N	t	2026-06-30 20:37:17.114547	2026-06-30 20:37:17.114547
1060	13	What do we call "Mosque" in French	mcq	1	88	\N	\N	t	2026-06-30 20:37:17.134694	2026-06-30 20:37:17.134694
1061	13	What do we call ''mother'' in French?	mcq	1	89	\N	\N	t	2026-06-30 20:37:17.134694	2026-06-30 20:37:17.134694
1062	13	'Stadium' is called .......... in French	mcq	1	90	\N	\N	t	2026-06-30 20:37:17.148624	2026-06-30 20:37:17.148624
1063	13	Nous ......... des chaussures	mcq	1	91	\N	\N	t	2026-06-30 20:37:17.156634	2026-06-30 20:37:17.156634
1064	13	"Soigner" means ........	mcq	1	92	\N	\N	t	2026-06-30 20:37:17.165456	2026-06-30 20:37:17.165456
1065	13	Amaka porte .......... chaussures	mcq	1	93	\N	\N	t	2026-06-30 20:37:17.173465	2026-06-30 20:37:17.173465
1066	13	Nous .......... Hausa	mcq	1	94	\N	\N	t	2026-06-30 20:37:17.181185	2026-06-30 20:37:17.181185
1067	13	Le capitale du Nigéria est .........	mcq	1	95	\N	\N	t	2026-06-30 20:37:17.196815	2026-06-30 20:37:17.196815
1068	13	......... est le capitale de l'état de Niger	mcq	1	96	\N	\N	t	2026-06-30 20:37:17.200737	2026-06-30 20:37:17.200737
1069	13	Il y a ......... jours dans la semaine	mcq	1	97	\N	\N	t	2026-06-30 20:37:17.200737	2026-06-30 20:37:17.200737
1070	13	Il y a ......... mois dans l'année	mcq	1	98	\N	\N	t	2026-06-30 20:37:17.222694	2026-06-30 20:37:17.222694
1071	13	Je voudrais ......... aux toilettes	mcq	1	99	\N	\N	t	2026-06-30 20:37:17.230693	2026-06-30 20:37:17.230693
1072	13	The 1st group verbs end with .........	mcq	1	100	\N	\N	t	2026-06-30 20:37:17.232092	2026-06-30 20:37:17.232092
\.


--
-- TOC entry 5098 (class 0 OID 17573)
-- Dependencies: 220
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, created_at) FROM stdin;
1	Admin	System Administrator	2026-05-10 18:09:09.621787
2	Teacher	Teacher role	2026-05-10 18:09:09.621787
3	Student	Student role	2026-05-10 18:09:09.621787
\.


--
-- TOC entry 5123 (class 0 OID 17856)
-- Dependencies: 245
-- Data for Name: student_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_answers (id, exam_session_id, question_id, student_id, selected_option_id, theory_answer, is_correct, marks_obtained, time_spent_seconds, marked_for_review, visited_count, created_at, updated_at) FROM stdin;
526	30	651	10	2286	\N	t	2	0	f	0	2026-06-20 21:38:29.603058	2026-06-20 21:38:29.778096
601	42	883	10	3205	\N	f	0	0	f	0	2026-06-24 22:19:26.221357	2026-06-24 22:19:26.253169
602	42	884	10	3209	\N	f	0	0	f	0	2026-06-24 22:19:26.236329	2026-06-24 22:19:26.253169
603	42	895	10	3255	\N	f	0	0	f	0	2026-06-24 22:19:26.237458	2026-06-24 22:19:26.270318
604	42	901	10	3278	\N	f	0	0	f	0	2026-06-24 22:19:26.237458	2026-06-24 22:19:26.286423
605	43	978	10	3506	\N	t	1	0	f	0	2026-06-30 20:39:59.452238	2026-06-30 20:39:59.719042
606	43	979	10	3510	\N	t	1	0	f	0	2026-06-30 20:39:59.556325	2026-06-30 20:39:59.738423
607	43	985	10	3535	\N	f	0	0	f	0	2026-06-30 20:39:59.568674	2026-06-30 20:39:59.769689
527	30	663	10	2333	\N	t	2	0	f	0	2026-06-20 21:38:29.651033	2026-06-20 21:38:29.834244
528	30	664	10	2337	\N	t	2	0	f	0	2026-06-20 21:38:29.656869	2026-06-20 21:38:29.844734
529	30	665	10	2341	\N	t	2	0	f	0	2026-06-20 21:38:29.661719	2026-06-20 21:38:29.8543
530	30	666	10	2345	\N	t	2	0	f	0	2026-06-20 21:38:29.672609	2026-06-20 21:38:29.864305
531	30	667	10	2349	\N	t	2	0	f	0	2026-06-20 21:38:29.682601	2026-06-20 21:38:29.872277
532	30	668	10	2353	\N	t	2	0	f	0	2026-06-20 21:38:29.692662	2026-06-20 21:38:29.878072
533	30	669	10	2357	\N	t	2	0	f	0	2026-06-20 21:38:29.694873	2026-06-20 21:38:29.888149
534	30	670	10	2361	\N	t	2	0	f	0	2026-06-20 21:38:29.702932	2026-06-20 21:38:29.898322
535	30	671	10	2365	\N	t	2	0	f	0	2026-06-20 21:38:29.702932	2026-06-20 21:38:29.906411
536	30	672	10	2369	\N	t	2	0	f	0	2026-06-20 21:38:29.71302	2026-06-20 21:38:29.910815
608	43	994	10	3571	\N	f	0	0	f	0	2026-06-30 20:39:59.568674	2026-06-30 20:39:59.850855
609	43	1028	10	3702	\N	t	1	0	f	0	2026-06-30 20:39:59.588307	2026-06-30 20:40:00.119158
610	43	1044	10	3748	\N	f	0	0	f	0	2026-06-30 20:39:59.602458	2026-06-30 20:40:00.234709
611	43	1052	10	3774	\N	t	1	0	f	0	2026-06-30 20:39:59.602458	2026-06-30 20:40:00.317621
612	43	1055	10	3783	\N	f	0	0	f	0	2026-06-30 20:39:59.619215	2026-06-30 20:40:00.34353
613	43	1070	10	3828	\N	t	1	0	f	0	2026-06-30 20:39:59.619215	2026-06-30 20:40:00.450873
537	30	673	10	2373	\N	t	2	0	f	0	2026-06-20 21:38:29.721054	2026-06-20 21:38:29.918393
538	30	674	10	2377	\N	t	2	0	f	0	2026-06-20 21:38:29.723078	2026-06-20 21:38:29.926375
539	30	675	10	2381	\N	t	2	0	f	0	2026-06-20 21:38:29.733164	2026-06-20 21:38:29.934374
540	30	676	10	2385	\N	t	2	0	f	0	2026-06-20 21:38:29.733164	2026-06-20 21:38:29.942376
541	30	677	10	2389	\N	t	2	0	f	0	2026-06-20 21:38:29.741196	2026-06-20 21:38:29.949318
580	40	551	10	1885	\N	t	2	0	f	0	2026-06-21 13:27:46.309425	2026-06-21 13:27:46.340686
542	30	678	10	2393	\N	t	2	0	f	0	2026-06-20 21:38:29.744685	2026-06-20 21:38:29.961181
543	30	679	10	2397	\N	t	2	0	f	0	2026-06-20 21:38:29.753246	2026-06-20 21:38:29.969741
544	30	680	10	2401	\N	t	2	0	f	0	2026-06-20 21:38:29.753246	2026-06-20 21:38:29.979869
614	44	985	17	3535	\N	f	0	0	f	0	2026-07-03 05:00:56.683158	2026-07-03 05:00:56.858871
615	44	986	17	3539	\N	f	0	0	f	0	2026-07-03 05:00:56.782967	2026-07-03 05:00:56.862915
616	44	989	17	3549	\N	f	0	0	f	0	2026-07-03 05:00:56.782967	2026-07-03 05:00:56.866067
617	44	995	17	3573	\N	f	0	0	f	0	2026-07-03 05:00:56.798662	2026-07-03 05:00:56.882729
618	44	1007	17	3624	\N	f	0	0	f	0	2026-07-03 05:00:56.798662	2026-07-03 05:00:56.8996
619	44	1009	17	3632	\N	f	0	0	f	0	2026-07-03 05:00:56.798662	2026-07-03 05:00:56.8996
620	44	1011	17	3640	\N	f	0	0	f	0	2026-07-03 05:00:56.798662	2026-07-03 05:00:56.918724
621	44	1018	17	3665	\N	f	0	0	f	0	2026-07-03 05:00:56.798662	2026-07-03 05:00:56.932708
622	44	1028	17	3700	\N	f	0	0	f	0	2026-07-03 05:00:56.798662	2026-07-03 05:00:56.948482
623	44	1043	17	3747	\N	f	0	0	f	0	2026-07-03 05:00:56.798662	2026-07-03 05:00:56.981681
624	44	1049	17	3764	\N	t	1	0	f	0	2026-07-03 05:00:56.816432	2026-07-03 05:00:56.981681
625	44	1062	17	3803	\N	t	1	0	f	0	2026-07-03 05:00:56.820427	2026-07-03 05:00:57.073971
626	44	1064	17	3808	\N	f	0	0	f	0	2026-07-03 05:00:56.822425	2026-07-03 05:00:57.082558
627	44	1071	17	3829	\N	t	1	0	f	0	2026-07-03 05:00:56.824424	2026-07-03 05:00:57.099457
\.


--
-- TOC entry 5111 (class 0 OID 17711)
-- Dependencies: 233
-- Data for Name: student_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_classes (id, student_id, class_id, enrollment_date, is_active) FROM stdin;
\.


--
-- TOC entry 5104 (class 0 OID 17621)
-- Dependencies: 226
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (id, user_id, admission_number, roll_number, class_id, contact_number, address, date_of_birth, guardian_name, guardian_contact, is_active, created_at, updated_at, status, graduation_session) FROM stdin;
5	10	PTIS/2026/001	\N	3	\N	\N	\N	\N	\N	t	2026-06-20 20:24:23.11663	2026-06-20 20:24:23.11663	active	\N
6	12	4456677	\N	3	\N	\N	\N	\N	\N	t	2026-06-21 04:05:05.57603	2026-06-21 04:05:05.57603	active	\N
7	13	MIS/2021/007	\N	3	\N	\N	\N	\N	\N	t	2026-07-03 04:43:57.859325	2026-07-03 04:43:57.859325	active	\N
8	14	MIS/2022/234	\N	3	\N	\N	\N	\N	\N	t	2026-07-03 04:50:36.118318	2026-07-03 04:50:36.118318	active	\N
9	16	MIS/2022/456	\N	3	\N	\N	\N	\N	\N	t	2026-07-03 04:51:00.199302	2026-07-03 04:51:00.199302	active	\N
10	17	MIS/2021/0087	\N	3	\N	\N	\N	\N	\N	t	2026-07-03 04:59:01.546939	2026-07-03 04:59:01.546939	active	\N
\.


--
-- TOC entry 5130 (class 0 OID 84346)
-- Dependencies: 252
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects (id, name, code, category, description, is_active, created_at, updated_at) FROM stdin;
4	Mathematics	MTH	\N	\N	t	2026-06-20 20:26:21.067414	2026-06-20 20:26:21.067414
\.


--
-- TOC entry 5134 (class 0 OID 85102)
-- Dependencies: 256
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, enrollment_open, updated_at, school_name, school_short_name, school_email, school_phone, school_website, school_address, school_logo, school_favicon, primary_color, secondary_color, maintenance_mode, timezone, footer_text, copyright_text) FROM stdin;
1	t	2026-07-03 04:49:47.499151	PREMIUM TOWERS INTERNATIONAL SCHOOL, MINNA	PRETIS					\N	\N	#0b0c56	#f75f5f	f	UTC		
\.


--
-- TOC entry 5128 (class 0 OID 84323)
-- Dependencies: 250
-- Data for Name: teacher_subject_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_subject_classes (id, teacher_id, class_id, subject, created_at) FROM stdin;
\.


--
-- TOC entry 5106 (class 0 OID 17646)
-- Dependencies: 228
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers (id, user_id, teacher_id, subject, qualification, specialization, contact_number, address, joining_date, is_active, created_at, updated_at) FROM stdin;
3	11	STD/2026/001	Mathematics	Math	\N	\N	\N	\N	t	2026-06-20 20:27:17.195586	2026-06-20 20:27:17.195586
\.


--
-- TOC entry 5102 (class 0 OID 17600)
-- Dependencies: 224
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, first_name, last_name, gender, profile_picture, is_active, is_deleted, role_id, created_at, updated_at) FROM stdin;
1	admin	admin@example.com	scrypt:32768:8:1$c8Actna6qyQYpk01$233f20af14bec04ccc76ccee582ca5cb8430754298527297f6e554307fd578bf4b45bfee031f79c2793f5e4e5c94816330799fe53d80ac3f45bbe78958c44b6a	System	Admin	male	\N	t	f	1	2026-05-10 18:09:55.386519	2026-05-11 01:30:41.464047
10	ST001	\N	scrypt:32768:8:1$281s4Ujare1o3w9y$bac16e218c4d9d19ea073eb70b68820e481b8afaec49cc11ab37be02452d83415d6d5aadb8822ffc9fdc6281e8933172c44c735726c03c3f24fec2e442c1ea95	ABDULLAHI	Musa	Male	\N	t	f	3	2026-06-20 20:24:23.100874	2026-06-20 20:24:23.100874
11	TS001	\N	scrypt:32768:8:1$pt9nKZImthWcCYaL$c8bfe913c6641287af5d03a9ebcc17ba1531e3dd33962439a78911c7f8b0f195db134082c8bcda595a916534ef9ea42c0ba0674efa4a376aa5504d717eee0363	Hamza	Ado	Male	\N	t	f	2	2026-06-20 20:27:17.195586	2026-06-20 20:27:17.195586
12	ST002	\N	scrypt:32768:8:1$FqbLhkh7asZCWGGy$f23bc4ff6f38706fc0bac4b5f5d288a8c1882c984d6635fa6597f0e05a1c9e7a7c151911d65830864673318454c4229d887ecf508501f5ce24ffece7d180c852	Haruna	Musa	Male	\N	t	f	3	2026-06-21 04:05:05.57603	2026-06-21 04:05:05.57603
13	ST003	\N	scrypt:32768:8:1$bMBIYbWhHIR1ZxD6$cc9df27e6100caf881ceb37d77bb7cb289f63068d34a92d55612f1f34732dbd71843ccd627b85bc927d4627aa81866050de92a78f4bcd8bc0495ed40b9967489	FAVOUR	ONOJA	Male	\N	t	f	3	2026-07-03 04:43:57.659368	2026-07-03 04:43:57.659368
14	ST004	saflex24@gmail.com	scrypt:32768:8:1$oOE97pBpl1pKvTD5$e177756337c0a7209075de4ab9b14b7a518e206e204304e336d818d7cd88ad31c873c03337efbb355a6374486e20cf9f3e5f9c263f17c5fbb1d34b7175483cf7	Saheed	Oyedeji	Male	\N	t	f	3	2026-07-03 04:50:36.114128	2026-07-03 04:50:36.114128
16	ST005	saflex24@gmail.com	scrypt:32768:8:1$yZtPfy8SIjFhpc2s$2cf4fd9f129607b0a9eed95cd478d3dc49b3c9e8923a12c0bffba739e152dce433715bfe28d374016e40e8a30924125877dd54fea817b0460c103bca748715b6	Saheed	Oyedeji	Male	\N	t	f	3	2026-07-03 04:51:00.199302	2026-07-03 04:51:00.199302
17	ST006	saflex24@gmail.com	scrypt:32768:8:1$6JhKI23VRBzPZogd$01e5d2e515cc64a5706a716e215ca326e5c323732ba093115681975938159274661741545a1a0c60b1641fe7e953c40ef086f6771088cfedeeebf02bf212c2cb	Saheed	Oyedeji	Male	\N	t	f	3	2026-07-03 04:59:01.52992	2026-07-03 04:59:01.52992
\.


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 247
-- Name: academic_terms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.academic_terms_id_seq', 2, true);


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 221
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classes_id_seq', 3, true);


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 240
-- Name: exam_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exam_results_id_seq', 37, true);


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 236
-- Name: exam_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exam_sessions_id_seq', 44, true);


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 229
-- Name: exams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exams_id_seq', 13, true);


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 242
-- Name: proctoring_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proctoring_logs_id_seq', 131, true);


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 253
-- Name: promotion_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotion_history_id_seq', 1, true);


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 238
-- Name: question_options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_options_id_seq', 3834, true);


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 234
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_id_seq', 1072, true);


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 244
-- Name: student_answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_answers_id_seq', 627, true);


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 232
-- Name: student_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_classes_id_seq', 1, false);


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 225
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_id_seq', 10, true);


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 251
-- Name: subjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subjects_id_seq', 4, true);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 255
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 33, true);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 249
-- Name: teacher_subject_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_subject_classes_id_seq', 3, true);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 227
-- Name: teachers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teachers_id_seq', 3, true);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 223
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 17, true);


--
-- TOC entry 4904 (class 2606 OID 84321)
-- Name: academic_terms academic_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academic_terms
    ADD CONSTRAINT academic_terms_pkey PRIMARY KEY (id);


--
-- TOC entry 4902 (class 2606 OID 17900)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 4880 (class 2606 OID 17699)
-- Name: class_teacher class_teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_teacher
    ADD CONSTRAINT class_teacher_pkey PRIMARY KEY (class_id, teacher_id);


--
-- TOC entry 4859 (class 2606 OID 17597)
-- Name: classes classes_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_code_key UNIQUE (code);


--
-- TOC entry 4861 (class 2606 OID 17595)
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- TOC entry 4896 (class 2606 OID 17810)
-- Name: exam_results exam_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_pkey PRIMARY KEY (id);


--
-- TOC entry 4888 (class 2606 OID 17764)
-- Name: exam_sessions exam_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4890 (class 2606 OID 17766)
-- Name: exam_sessions exam_sessions_session_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_session_code_key UNIQUE (session_code);


--
-- TOC entry 4892 (class 2606 OID 17768)
-- Name: exam_sessions exam_sessions_session_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_session_token_key UNIQUE (session_token);


--
-- TOC entry 4877 (class 2606 OID 17681)
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- TOC entry 4898 (class 2606 OID 17839)
-- Name: proctoring_logs proctoring_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs
    ADD CONSTRAINT proctoring_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4916 (class 2606 OID 84372)
-- Name: promotion_history promotion_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_history
    ADD CONSTRAINT promotion_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 17791)
-- Name: question_options question_options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_options
    ADD CONSTRAINT question_options_pkey PRIMARY KEY (id);


--
-- TOC entry 4886 (class 2606 OID 17745)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 17582)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 4857 (class 2606 OID 17580)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4900 (class 2606 OID 17867)
-- Name: student_answers student_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_pkey PRIMARY KEY (id);


--
-- TOC entry 4882 (class 2606 OID 17719)
-- Name: student_classes student_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes
    ADD CONSTRAINT student_classes_pkey PRIMARY KEY (id);


--
-- TOC entry 4868 (class 2606 OID 17631)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- TOC entry 4870 (class 2606 OID 17633)
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- TOC entry 4910 (class 2606 OID 84359)
-- Name: subjects subjects_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_code_key UNIQUE (code);


--
-- TOC entry 4912 (class 2606 OID 84357)
-- Name: subjects subjects_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_name_key UNIQUE (name);


--
-- TOC entry 4914 (class 2606 OID 84355)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- TOC entry 4918 (class 2606 OID 85109)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 4906 (class 2606 OID 84332)
-- Name: teacher_subject_classes teacher_subject_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subject_classes
    ADD CONSTRAINT teacher_subject_classes_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 2606 OID 17657)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- TOC entry 4875 (class 2606 OID 17659)
-- Name: teachers teachers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_key UNIQUE (user_id);


--
-- TOC entry 4884 (class 2606 OID 17721)
-- Name: student_classes unique_student_class; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes
    ADD CONSTRAINT unique_student_class UNIQUE (student_id, class_id);


--
-- TOC entry 4908 (class 2606 OID 84334)
-- Name: teacher_subject_classes unique_teacher_class_subject; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subject_classes
    ADD CONSTRAINT unique_teacher_class_subject UNIQUE (teacher_id, class_id, subject);


--
-- TOC entry 4865 (class 2606 OID 17613)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4862 (class 1259 OID 17598)
-- Name: ix_classes_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_classes_name ON public.classes USING btree (name);


--
-- TOC entry 4878 (class 1259 OID 17692)
-- Name: ix_exams_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_exams_code ON public.exams USING btree (code);


--
-- TOC entry 4866 (class 1259 OID 17644)
-- Name: ix_students_admission_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_students_admission_number ON public.students USING btree (admission_number);


--
-- TOC entry 4871 (class 1259 OID 17665)
-- Name: ix_teachers_teacher_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_teachers_teacher_id ON public.teachers USING btree (teacher_id);


--
-- TOC entry 4863 (class 1259 OID 17619)
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);


--
-- TOC entry 4926 (class 2606 OID 17700)
-- Name: class_teacher class_teacher_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_teacher
    ADD CONSTRAINT class_teacher_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- TOC entry 4927 (class 2606 OID 17705)
-- Name: class_teacher class_teacher_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_teacher
    ADD CONSTRAINT class_teacher_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id);


--
-- TOC entry 4919 (class 2606 OID 85110)
-- Name: classes classes_next_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_next_class_id_fkey FOREIGN KEY (next_class_id) REFERENCES public.classes(id);


--
-- TOC entry 4934 (class 2606 OID 17811)
-- Name: exam_results exam_results_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- TOC entry 4935 (class 2606 OID 17821)
-- Name: exam_results exam_results_exam_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_exam_session_id_fkey FOREIGN KEY (exam_session_id) REFERENCES public.exam_sessions(id);


--
-- TOC entry 4936 (class 2606 OID 17816)
-- Name: exam_results exam_results_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- TOC entry 4931 (class 2606 OID 17769)
-- Name: exam_sessions exam_sessions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- TOC entry 4932 (class 2606 OID 17774)
-- Name: exam_sessions exam_sessions_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- TOC entry 4924 (class 2606 OID 17682)
-- Name: exams exams_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- TOC entry 4925 (class 2606 OID 17687)
-- Name: exams exams_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 4937 (class 2606 OID 17845)
-- Name: proctoring_logs proctoring_logs_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs
    ADD CONSTRAINT proctoring_logs_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- TOC entry 4938 (class 2606 OID 17840)
-- Name: proctoring_logs proctoring_logs_exam_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs
    ADD CONSTRAINT proctoring_logs_exam_session_id_fkey FOREIGN KEY (exam_session_id) REFERENCES public.exam_sessions(id);


--
-- TOC entry 4939 (class 2606 OID 17850)
-- Name: proctoring_logs proctoring_logs_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs
    ADD CONSTRAINT proctoring_logs_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- TOC entry 4946 (class 2606 OID 84378)
-- Name: promotion_history promotion_history_from_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_history
    ADD CONSTRAINT promotion_history_from_class_id_fkey FOREIGN KEY (from_class_id) REFERENCES public.classes(id);


--
-- TOC entry 4947 (class 2606 OID 84388)
-- Name: promotion_history promotion_history_promoted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_history
    ADD CONSTRAINT promotion_history_promoted_by_fkey FOREIGN KEY (promoted_by) REFERENCES public.users(id);


--
-- TOC entry 4948 (class 2606 OID 84373)
-- Name: promotion_history promotion_history_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_history
    ADD CONSTRAINT promotion_history_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- TOC entry 4949 (class 2606 OID 84383)
-- Name: promotion_history promotion_history_to_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_history
    ADD CONSTRAINT promotion_history_to_class_id_fkey FOREIGN KEY (to_class_id) REFERENCES public.classes(id);


--
-- TOC entry 4933 (class 2606 OID 17792)
-- Name: question_options question_options_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_options
    ADD CONSTRAINT question_options_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- TOC entry 4930 (class 2606 OID 17746)
-- Name: questions questions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- TOC entry 4940 (class 2606 OID 17868)
-- Name: student_answers student_answers_exam_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_exam_session_id_fkey FOREIGN KEY (exam_session_id) REFERENCES public.exam_sessions(id);


--
-- TOC entry 4941 (class 2606 OID 17873)
-- Name: student_answers student_answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- TOC entry 4942 (class 2606 OID 17883)
-- Name: student_answers student_answers_selected_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_selected_option_id_fkey FOREIGN KEY (selected_option_id) REFERENCES public.question_options(id);


--
-- TOC entry 4943 (class 2606 OID 17878)
-- Name: student_answers student_answers_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- TOC entry 4928 (class 2606 OID 17727)
-- Name: student_classes student_classes_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes
    ADD CONSTRAINT student_classes_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- TOC entry 4929 (class 2606 OID 17722)
-- Name: student_classes student_classes_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes
    ADD CONSTRAINT student_classes_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- TOC entry 4921 (class 2606 OID 17639)
-- Name: students students_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- TOC entry 4922 (class 2606 OID 17634)
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4944 (class 2606 OID 84340)
-- Name: teacher_subject_classes teacher_subject_classes_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subject_classes
    ADD CONSTRAINT teacher_subject_classes_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- TOC entry 4945 (class 2606 OID 84335)
-- Name: teacher_subject_classes teacher_subject_classes_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subject_classes
    ADD CONSTRAINT teacher_subject_classes_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id);


--
-- TOC entry 4923 (class 2606 OID 17660)
-- Name: teachers teachers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4920 (class 2606 OID 17614)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-07-02 22:10:39

--
-- PostgreSQL database dump complete
--

\unrestrict mF7iuUnvkLSsca5d9DWwGCNKTAVfawNrM5tcX0WeIzbWIbqAzaDaR2jNNapU8Q4

