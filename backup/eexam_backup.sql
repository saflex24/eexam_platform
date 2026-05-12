--
-- PostgreSQL database dump
--

\restrict xXNe8d7BPZa1jhdcsQh10on9hEJXYrA9wzA83JXtffop6bNP0xmbnvi5L2nWKVr

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
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
    updated_at timestamp without time zone
);


ALTER TABLE public.classes OWNER TO postgres;

--
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
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
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
-- Name: exam_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exam_results_id_seq OWNED BY public.exam_results.id;


--
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
    updated_at timestamp without time zone
);


ALTER TABLE public.exam_sessions OWNER TO postgres;

--
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
-- Name: exam_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exam_sessions_id_seq OWNED BY public.exam_sessions.id;


--
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
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exams_id_seq OWNED BY public.exams.id;


--
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
-- Name: proctoring_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proctoring_logs_id_seq OWNED BY public.proctoring_logs.id;


--
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
-- Name: question_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_options_id_seq OWNED BY public.question_options.id;


--
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
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
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
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
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
-- Name: student_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_answers_id_seq OWNED BY public.student_answers.id;


--
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
-- Name: student_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_classes_id_seq OWNED BY public.student_classes.id;


--
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
    updated_at timestamp without time zone
);


ALTER TABLE public.students OWNER TO postgres;

--
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
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
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
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_id_seq OWNED BY public.teachers.id;


--
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
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- Name: exam_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results ALTER COLUMN id SET DEFAULT nextval('public.exam_results_id_seq'::regclass);


--
-- Name: exam_sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions ALTER COLUMN id SET DEFAULT nextval('public.exam_sessions_id_seq'::regclass);


--
-- Name: exams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams ALTER COLUMN id SET DEFAULT nextval('public.exams_id_seq'::regclass);


--
-- Name: proctoring_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs ALTER COLUMN id SET DEFAULT nextval('public.proctoring_logs_id_seq'::regclass);


--
-- Name: question_options id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_options ALTER COLUMN id SET DEFAULT nextval('public.question_options_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: student_answers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers ALTER COLUMN id SET DEFAULT nextval('public.student_answers_id_seq'::regclass);


--
-- Name: student_classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes ALTER COLUMN id SET DEFAULT nextval('public.student_classes_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
3cc56a015acb
\.


--
-- Data for Name: class_teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class_teacher (class_id, teacher_id, is_primary, created_at) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (id, name, code, section, academic_year, description, total_strength, is_active, created_at, updated_at) FROM stdin;
1	JSS 1	Opal		2024/2025		0	t	2026-05-11 04:07:56.120789	2026-05-11 04:07:56.120789
\.


--
-- Data for Name: exam_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_results (id, exam_id, student_id, exam_session_id, total_marks, marks_obtained, percentage, pass_marks, is_passed, grade, submitted_at, created_at, updated_at) FROM stdin;
1	1	4	1	120	16	13.333333333333334	40	f	F	2026-05-11 15:18:34.969832	2026-05-11 15:18:34.970831	2026-05-11 15:18:34.970831
\.


--
-- Data for Name: exam_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_sessions (id, session_code, exam_id, student_id, session_token, status, start_time, last_activity, end_time, auto_submitted, tab_switches, copy_attempts, paste_attempts, face_violations, fullscreen_exits, webcam_captures, user_agent, ip_address, created_at, updated_at) FROM stdin;
1	SESSION-1-4-1778498309	1	4	PC60Op3nLltPLJMKtj1MqtlgLKJHPI8e	submitted	2026-05-11 04:18:29.108598	2026-05-11 04:19:54.872883	2026-05-11 15:18:34.827455	f	1	0	0	0	0	0	\N	\N	2026-05-11 04:18:29.116595	2026-05-11 15:18:34.828458
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exams (id, title, code, description, subject, class_id, created_by, passcode, show_results_immediately, allow_review, show_correct_answers, allow_student_view_result, total_questions, total_marks, pass_marks, duration_minutes, start_date, end_date, published, published_at, shuffle_questions, shuffle_options, randomize_per_student, enable_proctoring, enable_webcam, enable_tab_detection, enable_copy_paste_prevention, is_active, is_deleted, created_at, updated_at) FROM stdin;
1	GENERAL STUDIES	I1M9Y5MGHC	MATH, ENG, PHY	General Studies	1	5	12345	f	t	f	t	60	120	40	5	2026-05-10 21:13:00	2026-05-30 21:13:00	t	2026-05-11 04:18:02.168753	t	t	f	t	f	t	t	t	f	2026-05-11 04:13:54.908608	2026-05-11 04:18:02.168753
\.


--
-- Data for Name: proctoring_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proctoring_logs (id, exam_session_id, exam_id, student_id, event_type, violation_type, severity, details, "timestamp") FROM stdin;
1	1	1	4	tab_switch	tab_switch	medium	{"count": 1, "timestamp": "2026-05-11T04:19:54.860Z", "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36", "screenResolution": "1366x768"}	2026-05-11 04:19:54.872883
\.


--
-- Data for Name: question_options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question_options (id, question_id, option_text, option_label, is_correct, latex_formula, created_at) FROM stdin;
1	4	50 per cent	A	f	\N	2026-05-11 04:15:50.14335
2	4	60 per cent	B	f	\N	2026-05-11 04:15:50.14335
3	4	70 per cent	C	t	\N	2026-05-11 04:15:50.14335
4	4	80 per cent	D	f	\N	2026-05-11 04:15:50.14335
5	5	Traffic congestion	A	f	\N	2026-05-11 04:15:50.191045
6	5	Loss of green spaces	B	f	\N	2026-05-11 04:15:50.191045
7	5	Inadequate housing	C	f	\N	2026-05-11 04:15:50.191045
8	5	Food insecurity	D	t	\N	2026-05-11 04:15:50.191045
9	6	Accelerating	A	f	\N	2026-05-11 04:15:50.202205
10	6	Reducing	B	t	\N	2026-05-11 04:15:50.202205
11	6	Ignoring	C	f	\N	2026-05-11 04:15:50.202205
12	6	Exaggerating	D	f	\N	2026-05-11 04:15:50.202205
13	7	Cities are becoming increasingly beautiful	A	f	\N	2026-05-11 04:15:50.219051
14	7	Urban opportunities may remain out of reach for the poor	B	t	\N	2026-05-11 04:15:50.219051
15	7	Deserts are expanding into urban areas	C	f	\N	2026-05-11 04:15:50.219051
16	7	City planners are making false promises	D	f	\N	2026-05-11 04:15:50.219051
17	8	Suburbs	A	f	\N	2026-05-11 04:15:50.22409
18	8	Satellites	B	f	\N	2026-05-11 04:15:50.22409
19	8	Slums	C	t	\N	2026-05-11 04:15:50.22409
20	8	Enclaves	D	f	\N	2026-05-11 04:15:50.22409
21	9	Centre	A	f	\N	2026-05-11 04:15:50.235512
22	9	Outskirts	B	t	\N	2026-05-11 04:15:50.235512
23	9	Interior	C	f	\N	2026-05-11 04:15:50.235512
24	9	Foundation	D	f	\N	2026-05-11 04:15:50.235512
25	10	Urbanisation should be halted to preserve the environment	A	f	\N	2026-05-11 04:15:50.252439
26	10	Rural life is superior to urban life in every respect	B	f	\N	2026-05-11 04:15:50.252439
27	10	Urbanisation offers great opportunities but creates serious challenges that require careful management	C	t	\N	2026-05-11 04:15:50.252439
28	10	Informal settlements are the direct cause of all urban problems	D	f	\N	2026-05-11 04:15:50.252439
29	11	It becomes purer and more prestigious	A	f	\N	2026-05-11 04:15:50.257651
30	11	It spreads more widely across the globe	B	f	\N	2026-05-11 04:15:50.257651
31	11	It becomes a dead language	C	t	\N	2026-05-11 04:15:50.257651
32	11	It acquires more borrowed words	D	f	\N	2026-05-11 04:15:50.257651
33	12	Permanence	A	f	\N	2026-05-11 04:15:50.268845
34	12	Confusion	B	f	\N	2026-05-11 04:15:50.268845
35	12	Continuous change	C	t	\N	2026-05-11 04:15:50.268845
36	12	Decline	D	f	\N	2026-05-11 04:15:50.268845
37	13	Alarmed	A	f	\N	2026-05-11 04:15:50.285799
38	13	Approving	B	t	\N	2026-05-11 04:15:50.285799
39	13	Indifferent	C	f	\N	2026-05-11 04:15:50.285799
40	13	Hostile	D	f	\N	2026-05-11 04:15:50.285799
41	14	Latin	A	f	\N	2026-05-11 04:15:50.29074
42	14	French	B	f	\N	2026-05-11 04:15:50.29074
43	14	German	C	t	\N	2026-05-11 04:15:50.29074
44	14	Arabic	D	f	\N	2026-05-11 04:15:50.29074
45	15	Every day	A	f	\N	2026-05-11 04:15:50.302133
46	15	Every week	B	f	\N	2026-05-11 04:15:50.302133
47	15	Every two weeks	C	t	\N	2026-05-11 04:15:50.302133
48	15	Every month	D	f	\N	2026-05-11 04:15:50.302133
49	16	A language spoken only in France	A	f	\N	2026-05-11 04:15:50.318148
50	16	A language used as a common medium among speakers of different native languages	B	t	\N	2026-05-11 04:15:50.318148
51	16	An ancient dead language	C	f	\N	2026-05-11 04:15:50.318148
52	16	A dialect of Latin	D	f	\N	2026-05-11 04:15:50.318148
53	17	Teach English as the only medium of instruction	A	f	\N	2026-05-11 04:15:50.326126
54	17	Discourage the use of indigenous languages	B	f	\N	2026-05-11 04:15:50.326126
55	17	Nurture multilingualism rather than treating it as an obstacle	C	t	\N	2026-05-11 04:15:50.326126
56	17	Prioritise written language over spoken language	D	f	\N	2026-05-11 04:15:50.326126
57	18	Clear	A	f	\N	2026-05-11 04:15:50.335791
58	18	Vague	B	t	\N	2026-05-11 04:15:50.335791
59	18	Persuasive	C	f	\N	2026-05-11 04:15:50.335791
60	18	Aggressive	D	f	\N	2026-05-11 04:15:50.335791
61	19	Flooded	A	t	\N	2026-05-11 04:15:50.35232
62	19	Deprived	B	f	\N	2026-05-11 04:15:50.35232
63	19	Satisfied	C	f	\N	2026-05-11 04:15:50.35232
64	19	Threatened	D	f	\N	2026-05-11 04:15:50.35232
65	20	Weak	A	f	\N	2026-05-11 04:15:50.357172
66	20	Careless	B	f	\N	2026-05-11 04:15:50.357172
67	20	Persistent	C	t	\N	2026-05-11 04:15:50.357172
68	20	Temporary	D	f	\N	2026-05-11 04:15:50.357172
69	21	Praised	A	t	\N	2026-05-11 04:15:50.373187
70	21	Criticised	B	f	\N	2026-05-11 04:15:50.373187
71	21	Dismissed	C	f	\N	2026-05-11 04:15:50.373187
72	21	Interrogated	D	f	\N	2026-05-11 04:15:50.373187
73	22	Silent	A	f	\N	2026-05-11 04:15:50.381177
74	22	Talkative	B	t	\N	2026-05-11 04:15:50.381177
75	22	Nervous	C	f	\N	2026-05-11 04:15:50.381177
76	22	Hostile	D	f	\N	2026-05-11 04:15:50.381177
77	23	Beneficial	A	f	\N	2026-05-11 04:15:50.388841
78	23	Harmful	B	t	\N	2026-05-11 04:15:50.388841
79	23	Irrelevant	C	f	\N	2026-05-11 04:15:50.388841
80	23	Encouraging	D	f	\N	2026-05-11 04:15:50.388841
81	24	Biased	A	f	\N	2026-05-11 04:15:50.402019
82	24	Secretive	B	f	\N	2026-05-11 04:15:50.402019
83	24	Frank	C	t	\N	2026-05-11 04:15:50.402019
84	24	Lengthy	D	f	\N	2026-05-11 04:15:50.402019
85	25	Clear	A	f	\N	2026-05-11 04:15:50.418033
86	25	Incoherent	B	t	\N	2026-05-11 04:15:50.418033
87	25	Detailed	C	f	\N	2026-05-11 04:15:50.418033
88	25	Lengthy	D	f	\N	2026-05-11 04:15:50.418033
89	26	have	A	f	\N	2026-05-11 04:15:50.422285
90	26	are	B	f	\N	2026-05-11 04:15:50.422285
91	26	is	C	t	\N	2026-05-11 04:15:50.422285
92	26	were	D	f	\N	2026-05-11 04:15:50.422285
93	27	was	A	f	\N	2026-05-11 04:15:50.435399
94	27	were	B	t	\N	2026-05-11 04:15:50.435399
95	27	is	C	f	\N	2026-05-11 04:15:50.435399
96	27	has been	D	f	\N	2026-05-11 04:15:50.435399
97	28	was	A	f	\N	2026-05-11 04:15:50.452598
98	28	is	B	f	\N	2026-05-11 04:15:50.452598
99	28	were	C	t	\N	2026-05-11 04:15:50.452598
100	28	has	D	f	\N	2026-05-11 04:15:50.452598
101	29	has	A	f	\N	2026-05-11 04:15:50.455915
102	29	have	B	f	\N	2026-05-11 04:15:50.455915
103	29	had	C	t	\N	2026-05-11 04:15:50.455915
104	29	was	D	f	\N	2026-05-11 04:15:50.455915
105	30	works	A	f	\N	2026-05-11 04:15:50.468707
106	30	worked	B	f	\N	2026-05-11 04:15:50.468707
107	30	has been working	C	t	\N	2026-05-11 04:15:50.468707
108	30	had worked	D	f	\N	2026-05-11 04:15:50.468707
109	31	of	A	f	\N	2026-05-11 04:15:50.489004
110	31	for	B	f	\N	2026-05-11 04:15:50.489004
111	31	with	C	t	\N	2026-05-11 04:15:50.489004
112	31	about	D	f	\N	2026-05-11 04:15:50.489004
113	32	at	A	f	\N	2026-05-11 04:15:50.489004
114	32	by	B	f	\N	2026-05-11 04:15:50.489004
115	32	with	C	f	\N	2026-05-11 04:15:50.489004
116	32	in	D	t	\N	2026-05-11 04:15:50.489004
117	33	Each of the boys have submitted their assignments.	A	f	\N	2026-05-11 04:15:50.510055
118	33	Each of the boys has submitted his assignment.	B	t	\N	2026-05-11 04:15:50.510055
119	33	Each of the boys have submitted his assignment.	C	f	\N	2026-05-11 04:15:50.510055
120	33	Each of the boys has submitted their assignments.	D	f	\N	2026-05-11 04:15:50.510055
121	34	Simile	A	f	\N	2026-05-11 04:15:50.522279
122	34	Personification	B	f	\N	2026-05-11 04:15:50.522279
123	34	Metaphor	C	t	\N	2026-05-11 04:15:50.522279
124	34	Hyperbole	D	f	\N	2026-05-11 04:15:50.522279
125	35	Simile	A	f	\N	2026-05-11 04:15:50.535328
126	35	Personification	B	t	\N	2026-05-11 04:15:50.535328
127	35	Metaphor	C	f	\N	2026-05-11 04:15:50.535328
128	35	Irony	D	f	\N	2026-05-11 04:15:50.535328
129	36	Metaphor	A	f	\N	2026-05-11 04:15:50.543347
130	36	Simile	B	t	\N	2026-05-11 04:15:50.543347
131	36	Hyperbole	C	f	\N	2026-05-11 04:15:50.543347
132	36	Alliteration	D	f	\N	2026-05-11 04:15:50.543347
133	37	The informations given were incorrect.	A	f	\N	2026-05-11 04:15:50.555216
134	37	One of the equipments is missing.	B	f	\N	2026-05-11 04:15:50.555216
135	37	The luggage was left at the airport.	C	t	\N	2026-05-11 04:15:50.555216
136	37	The staffs are on strike.	D	f	\N	2026-05-11 04:15:50.555216
137	38	He said that he will come the next day.	A	f	\N	2026-05-11 04:15:50.568601
138	38	He said that he would come tomorrow.	B	f	\N	2026-05-11 04:15:50.568601
139	38	He said that he would come the next day.	C	t	\N	2026-05-11 04:15:50.568601
140	38	He said that he will come tomorrow.	D	f	\N	2026-05-11 04:15:50.568601
141	39	Start reading a new book	A	f	\N	2026-05-11 04:15:50.576615
142	39	Change his behaviour for the better	B	t	\N	2026-05-11 04:15:50.576615
143	39	Move to a new location	C	f	\N	2026-05-11 04:15:50.576615
144	39	Become involved in farming	D	f	\N	2026-05-11 04:15:50.576615
145	40	He enjoyed eating large meals	A	f	\N	2026-05-11 04:15:50.589221
146	40	He underestimated the cost of the project	B	f	\N	2026-05-11 04:15:50.589221
147	40	He took on more responsibility than he could handle	C	t	\N	2026-05-11 04:15:50.589221
148	40	He refused to delegate work to his staff	D	f	\N	2026-05-11 04:15:50.589221
149	41	Protect the voters from the cold	A	f	\N	2026-05-11 04:15:50.601926
150	41	Deceive the voters	B	t	\N	2026-05-11 04:15:50.601926
151	41	Comfort the voters after a loss	C	f	\N	2026-05-11 04:15:50.601926
152	41	Expose the voters to the truth	D	f	\N	2026-05-11 04:15:50.601926
153	42	bread	A	f	\N	2026-05-11 04:15:50.609932
154	42	dead	B	f	\N	2026-05-11 04:15:50.609932
155	42	head	C	f	\N	2026-05-11 04:15:50.609932
156	42	bead	D	t	\N	2026-05-11 04:15:50.609932
157	43	phone	A	f	\N	2026-05-11 04:15:50.6221
158	43	smile	B	f	\N	2026-05-11 04:15:50.6221
159	43	recipe	C	t	\N	2026-05-11 04:15:50.6221
160	43	stripe	D	f	\N	2026-05-11 04:15:50.6221
161	44	CONduct (noun)	A	f	\N	2026-05-11 04:15:50.635284
162	44	PROtest (noun)	B	f	\N	2026-05-11 04:15:50.635284
163	44	reCORD (verb)	C	t	\N	2026-05-11 04:15:50.635284
164	44	OBject (noun)	D	f	\N	2026-05-11 04:15:50.635284
165	45	plain / plan	A	f	\N	2026-05-11 04:15:50.643298
166	45	right / write	B	f	\N	2026-05-11 04:15:50.643298
167	45	sight / site	C	f	\N	2026-05-11 04:15:50.643298
168	45	B and C only	D	t	\N	2026-05-11 04:15:50.643298
169	46	/p/	A	f	\N	2026-05-11 04:15:50.655317
170	46	/ps/	B	f	\N	2026-05-11 04:15:50.655317
171	46	/s/	C	t	\N	2026-05-11 04:15:50.655317
172	46	/sy/	D	f	\N	2026-05-11 04:15:50.655317
173	47	strong	A	f	\N	2026-05-11 04:15:50.668579
174	47	knife	B	t	\N	2026-05-11 04:15:50.668579
175	47	train	C	f	\N	2026-05-11 04:15:50.668579
176	47	claim	D	f	\N	2026-05-11 04:15:50.668579
177	48	church	A	f	\N	2026-05-11 04:15:50.685139
178	48	chef	B	t	\N	2026-05-11 04:15:50.685381
179	48	chair	C	f	\N	2026-05-11 04:15:50.685381
180	48	check	D	f	\N	2026-05-11 04:15:50.685381
181	49	com-pre-hen-si-ble	A	t	\N	2026-05-11 04:15:50.688855
182	49	comp-re-hen-si-ble	B	f	\N	2026-05-11 04:15:50.688855
183	49	com-pre-hens-ible	C	f	\N	2026-05-11 04:15:50.688855
184	49	compreh-en-sible	D	f	\N	2026-05-11 04:15:50.688855
185	50	pho-TO-gra-phy	A	f	\N	2026-05-11 04:15:50.701889
186	50	PHO-to-gra-phy	B	f	\N	2026-05-11 04:15:50.701889
187	50	pho-to-GRA-phy	C	t	\N	2026-05-11 04:15:50.701889
188	50	pho-to-gra-PHY	D	f	\N	2026-05-11 04:15:50.701889
189	51	She passed all her examinations.	A	f	\N	2026-05-11 04:15:50.717891
190	51	What time does the bus leave?	B	t	\N	2026-05-11 04:15:50.717891
191	51	Please sit down.	C	f	\N	2026-05-11 04:15:50.717891
192	51	He refused to apologise.	D	f	\N	2026-05-11 04:15:50.717891
193	52	The teacher marked all the scripts.	A	f	\N	2026-05-11 04:15:50.722645
194	52	All the scripts were marked by the teacher.	B	t	\N	2026-05-11 04:15:50.722645
195	52	The teacher has marked all the scripts.	C	f	\N	2026-05-11 04:15:50.722645
196	52	The teacher will mark all the scripts.	D	f	\N	2026-05-11 04:15:50.722645
197	53	The budget was being approved by the committee last Tuesday.	A	f	\N	2026-05-11 04:15:50.7352
198	53	The budget has been approved by the committee last Tuesday.	B	f	\N	2026-05-11 04:15:50.7352
199	53	The budget was approved by the committee last Tuesday.	C	t	\N	2026-05-11 04:15:50.7352
200	53	The budget is approved by the committee last Tuesday.	D	f	\N	2026-05-11 04:15:50.7352
201	54	She sang beautifully.	A	f	\N	2026-05-11 04:15:50.751945
202	54	Although it was raining, they continued the match.	B	f	\N	2026-05-11 04:15:50.751945
203	54	She sang beautifully, and the audience applauded.	C	t	\N	2026-05-11 04:15:50.751945
204	54	The girl who won the prize is my sister.	D	f	\N	2026-05-11 04:15:50.751945
205	55	He came because he was invited.	A	f	\N	2026-05-11 04:15:50.755167
206	55	The doctor who treated her is my uncle.	B	t	\N	2026-05-11 04:15:50.755167
207	55	She left before the party ended.	C	f	\N	2026-05-11 04:15:50.755167
208	55	They arrived after we had eaten.	D	f	\N	2026-05-11 04:15:50.755167
209	56	Running (as in 'a running tap')	A	f	\N	2026-05-11 04:15:50.776502
210	56	Run	B	f	\N	2026-05-11 04:15:50.776502
211	56	Swimming (as in 'Swimming is good exercise')	C	t	\N	2026-05-11 04:15:50.776502
212	56	Swam	D	f	\N	2026-05-11 04:15:50.776502
213	57	However, I disagree with your analysis.	A	t	\N	2026-05-11 04:15:50.788588
214	57	However I disagree, with your analysis.	B	f	\N	2026-05-11 04:15:50.788588
215	57	However I, disagree with your analysis.	C	f	\N	2026-05-11 04:15:50.788588
216	57	However I disagree with, your analysis.	D	f	\N	2026-05-11 04:15:50.788588
217	58	Running down the street, the dog bit the man.	A	t	\N	2026-05-11 04:15:50.788588
218	58	Running down the street, the man was bitten by the dog.	B	f	\N	2026-05-11 04:15:50.788588
219	58	The man running down the street was bitten by the dog.	C	f	\N	2026-05-11 04:15:50.788588
220	58	While running down the street, the man was bitten.	D	f	\N	2026-05-11 04:15:50.788588
221	59	The student's books are on the table. (one student)	A	t	\N	2026-05-11 04:15:50.812113
222	59	The students books are on the table.	B	f	\N	2026-05-11 04:15:50.812113
223	59	The student's' books are on the table.	C	f	\N	2026-05-11 04:15:50.812113
224	59	The students's books are on the table.	D	f	\N	2026-05-11 04:15:50.812113
225	60	Whom is coming to the party?	A	f	\N	2026-05-11 04:15:50.822036
226	60	I do not know whom called.	B	f	\N	2026-05-11 04:15:50.822036
227	60	To whom should I address the letter?	C	t	\N	2026-05-11 04:15:50.822036
228	60	Whom did go to the market?	D	f	\N	2026-05-11 04:15:50.822036
229	61	phenomenons	A	f	\N	2026-05-11 04:15:50.83511
230	61	phenomenas	B	f	\N	2026-05-11 04:15:50.83511
231	61	phenomena	C	t	\N	2026-05-11 04:15:50.83511
232	61	phenomenes	D	f	\N	2026-05-11 04:15:50.83511
233	62	I have not seen him since Monday.	A	f	\N	2026-05-11 04:15:50.843126
234	62	It has been raining since morning.	B	f	\N	2026-05-11 04:15:50.843126
235	62	Since you are here, let us begin the meeting.	C	t	\N	2026-05-11 04:15:50.843126
236	62	He left since an hour ago.	D	f	\N	2026-05-11 04:15:50.843126
237	63	intoxicated	A	f	\N	2026-05-11 04:15:50.855241
238	63	very happy	B	t	\N	2026-05-11 04:15:50.855241
239	63	deeply shocked	C	f	\N	2026-05-11 04:15:50.855241
240	63	surprisingly calm	D	f	\N	2026-05-11 04:15:50.855241
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, exam_id, question_text, question_type, marks, "order", instructions, image, latex_support, created_at, updated_at) FROM stdin;
4	1	PASSAGE A\n\nThe phenomenon of urbanisation is a global trend that has reshaped human civilisation over the past two centuries. By 2050, it is projected that nearly 70 per cent of the world's population will reside in urban areas. While cities offer unparalleled opportunities for economic advancement, education, and cultural exchange, they also generate serious challenges. Overcrowding leads to inadequate housing, strained public services, and deteriorating sanitation. Traffic congestion, pollution, and the loss of green spaces further erode quality of life. Planners and policymakers must therefore strike a delicate balance: harnessing the productive energy of cities while mitigating the social and environmental costs that unchecked growth inevitably brings.\n\nFurthermore, rapid urbanisation tends to widen the gap between the affluent and the disadvantaged. Informal settlements, commonly known as slums, spring up on the periphery of major cities as rural migrants arrive in search of better prospects. These communities frequently lack access to clean water, electricity, and healthcare. Paradoxically, the very economic vitality that draws people to cities can render them inaccessible to those at the bottom of the social ladder. Without deliberate and inclusive urban planning, the promise of the city risks becoming a mirage for millions.\n\n1. According to the passage, what percentage of the world's population is projected to live in urban areas by 2050?	mcq	2	1	\N	\N	t	2026-05-11 04:15:50.135349	2026-05-11 04:15:50.135349
5	1	2. Which of the following is NOT listed in the passage as a challenge of urbanisation?	mcq	2	2	\N	\N	t	2026-05-11 04:15:50.135349	2026-05-11 04:15:50.135349
6	1	3. The word 'mitigating' as used in the passage most nearly means:	mcq	2	3	\N	\N	t	2026-05-11 04:15:50.191045	2026-05-11 04:15:50.191045
7	1	4. The expression 'the promise of the city risks becoming a mirage' suggests that:	mcq	2	4	\N	\N	t	2026-05-11 04:15:50.202205	2026-05-11 04:15:50.202205
8	1	5. According to the passage, what are informal settlements also called?	mcq	2	5	\N	\N	t	2026-05-11 04:15:50.21021	2026-05-11 04:15:50.21021
9	1	6. The word 'periphery' as used in the second paragraph is closest in meaning to:	mcq	2	6	\N	\N	t	2026-05-11 04:15:50.22409	2026-05-11 04:15:50.22409
10	1	7. Which of the following best states the main idea of the passage?	mcq	2	7	\N	\N	t	2026-05-11 04:15:50.235512	2026-05-11 04:15:50.235512
11	1	PASSAGE B\n\nLanguage is the most powerful instrument of human expression, yet it is perpetually in flux. Every generation introduces new words, discards old ones, and subtly shifts the meanings of those that survive. This dynamism is not a sign of linguistic decay, as purists sometimes lament, but rather evidence of vitality. A language that ceases to evolve is a language that has ceased to live. English, in particular, has demonstrated a remarkable capacity for absorption and adaptation, borrowing freely from Latin, French, Arabic, and numerous African and Asian languages to create one of the richest vocabularies on Earth.\n\nYet the spread of English as a global lingua franca raises legitimate concerns. When smaller languages are displaced by a dominant tongue, unique systems of thought, cultural memory, and indigenous knowledge may be irretrievably lost. Linguists estimate that one language disappears somewhere on Earth roughly every two weeks. The challenge for the twenty-first century is to celebrate linguistic diversity while acknowledging the practical utility of a shared medium of communication. Education systems have a pivotal role to play in nurturing multilingualism rather than treating it as an obstacle to be overcome.\n\n8. According to the passage, what happens to a language that ceases to evolve?	mcq	2	8	\N	\N	t	2026-05-11 04:15:50.243528	2026-05-11 04:15:50.243528
12	1	9. The word 'flux' as used in the passage means:	mcq	2	9	\N	\N	t	2026-05-11 04:15:50.257651	2026-05-11 04:15:50.257651
13	1	10. The author's attitude towards the evolution of language can best be described as:	mcq	2	10	\N	\N	t	2026-05-11 04:15:50.268845	2026-05-11 04:15:50.268845
14	1	11. Which of the following is NOT given in the passage as a source from which English has borrowed?	mcq	2	11	\N	\N	t	2026-05-11 04:15:50.276851	2026-05-11 04:15:50.276851
15	1	12. According to the passage, how often does a language disappear from the Earth?	mcq	2	12	\N	\N	t	2026-05-11 04:15:50.29074	2026-05-11 04:15:50.29074
16	1	13. The phrase 'lingua franca' as used in the passage refers to:	mcq	2	13	\N	\N	t	2026-05-11 04:15:50.302133	2026-05-11 04:15:50.302133
17	1	14. What does the author suggest education systems should do?	mcq	2	14	\N	\N	t	2026-05-11 04:15:50.31013	2026-05-11 04:15:50.31013
18	1	15. Choose the option nearest in meaning to the underlined word:\nThe governor's speech was deliberately AMBIGUOUS so as not to offend any group.	mcq	2	15	\N	\N	t	2026-05-11 04:15:50.326126	2026-05-11 04:15:50.326126
19	1	16. Choose the option nearest in meaning to the underlined word:\nThe charity was INUNDATED with donations after the flood disaster.	mcq	2	16	\N	\N	t	2026-05-11 04:15:50.335791	2026-05-11 04:15:50.335791
20	1	17. Choose the option nearest in meaning to the underlined word:\nHer TENACIOUS grip on the project ensured its completion despite all setbacks.	mcq	2	17	\N	\N	t	2026-05-11 04:15:50.347823	2026-05-11 04:15:50.347823
21	1	18. Choose the option OPPOSITE in meaning to the underlined word:\nThe minister was CENSURED for his handling of public funds.	mcq	2	18	\N	\N	t	2026-05-11 04:15:50.357172	2026-05-11 04:15:50.357172
22	1	19. Choose the option OPPOSITE in meaning to the underlined word:\nThe chairman remained TACITURN throughout the entire meeting.	mcq	2	19	\N	\N	t	2026-05-11 04:15:50.365191	2026-05-11 04:15:50.365191
23	1	20. Choose the option nearest in meaning to the underlined word:\nThe new policy was seen as DETRIMENTAL to small businesses.	mcq	2	20	\N	\N	t	2026-05-11 04:15:50.381177	2026-05-11 04:15:50.381177
24	1	21. Choose the option nearest in meaning to the underlined word:\nThe journalist's CANDID report exposed the corruption in the ministry.	mcq	2	21	\N	\N	t	2026-05-11 04:15:50.388841	2026-05-11 04:15:50.388841
25	1	22. Choose the option OPPOSITE in meaning to the underlined word:\nThe defendant gave a COHERENT account of events on the night in question.	mcq	2	22	\N	\N	t	2026-05-11 04:15:50.402019	2026-05-11 04:15:50.402019
26	1	23. Choose the option that correctly fills the gap:\nThe committee _______ yet to reach a decision on the matter.	mcq	2	23	\N	\N	t	2026-05-11 04:15:50.410015	2026-05-11 04:15:50.410015
27	1	24. Choose the option that correctly fills the gap:\nNeither the principal nor the teachers _______ aware of the examination timetable.	mcq	2	24	\N	\N	t	2026-05-11 04:15:50.422285	2026-05-11 04:15:50.422285
28	1	25. Choose the option that correctly fills the gap:\nA number of students _______ absent from the lecture.	mcq	2	25	\N	\N	t	2026-05-11 04:15:50.435399	2026-05-11 04:15:50.435399
29	1	26. Choose the option that correctly fills the gap:\nBy the time the ambulance arrived, the patient _______ already died.	mcq	2	26	\N	\N	t	2026-05-11 04:15:50.443394	2026-05-11 04:15:50.443394
30	1	27. Choose the option that correctly fills the gap:\nShe _______ for this company since she graduated from university in 2015.	mcq	2	27	\N	\N	t	2026-05-11 04:15:50.455915	2026-05-11 04:15:50.455915
31	1	28. Choose the option that correctly fills the gap:\nThe suspect was charged _______ armed robbery.	mcq	2	28	\N	\N	t	2026-05-11 04:15:50.468707	2026-05-11 04:15:50.468707
32	1	29. Choose the option that correctly fills the gap:\nHe was so engrossed _______ his work that he forgot to eat.	mcq	2	29	\N	\N	t	2026-05-11 04:15:50.476723	2026-05-11 04:15:50.476723
33	1	30. Identify the sentence with CORRECT usage:	mcq	2	30	\N	\N	t	2026-05-11 04:15:50.489004	2026-05-11 04:15:50.489004
34	1	31. Identify the figure of speech in the following sentence:\n"Life is a journey with no guaranteed destination."	mcq	2	31	\N	\N	t	2026-05-11 04:15:50.50206	2026-05-11 04:15:50.50206
35	1	32. Identify the figure of speech in:\n"The trees bowed their heads in grief as the rain fell."	mcq	2	32	\N	\N	t	2026-05-11 04:15:50.519242	2026-05-11 04:15:50.519242
36	1	33. "He ran as fast as the wind." The figure of speech used is:	mcq	2	33	\N	\N	t	2026-05-11 04:15:50.522279	2026-05-11 04:15:50.522279
37	1	34. Choose the option that has NO grammatical error:	mcq	2	34	\N	\N	t	2026-05-11 04:15:50.543347	2026-05-11 04:15:50.543347
38	1	35. Choose the option that correctly rewrites the sentence in indirect speech:\nHe said, "I will come tomorrow."	mcq	2	35	\N	\N	t	2026-05-11 04:15:50.555216	2026-05-11 04:15:50.555216
39	1	36. Choose the option that gives the correct meaning of the underlined expression:\n"The old man decided to TURN OVER A NEW LEAF after his release from prison."	mcq	2	36	\N	\N	t	2026-05-11 04:15:50.555216	2026-05-11 04:15:50.568601
40	1	37. Choose the option that gives the correct meaning of the underlined expression:\n"The director bit off more than he could chew with that project."	mcq	2	37	\N	\N	t	2026-05-11 04:15:50.576615	2026-05-11 04:15:50.576615
41	1	38. Choose the option that gives the correct meaning of the underlined expression:\n"The politician tried to PULL THE WOOL OVER the voters' eyes."	mcq	2	38	\N	\N	t	2026-05-11 04:15:50.589221	2026-05-11 04:15:50.589221
42	1	39. Which of the following words has a different vowel sound from the others?	mcq	2	39	\N	\N	t	2026-05-11 04:15:50.601926	2026-05-11 04:15:50.601926
43	1	40. In which of the following words is the final 'e' pronounced?	mcq	2	40	\N	\N	t	2026-05-11 04:15:50.609932	2026-05-11 04:15:50.609932
44	1	41. Which of the following words has the stress on the SECOND syllable?	mcq	2	41	\N	\N	t	2026-05-11 04:15:50.6221	2026-05-11 04:15:50.6221
45	1	42. Which pair of words are HOMOPHONES?	mcq	2	42	\N	\N	t	2026-05-11 04:15:50.635284	2026-05-11 04:15:50.635284
46	1	43. The word 'psychology' begins with the sound:	mcq	2	43	\N	\N	t	2026-05-11 04:15:50.643298	2026-05-11 04:15:50.643298
47	1	44. Which of the following words contains a SILENT letter?	mcq	2	44	\N	\N	t	2026-05-11 04:15:50.655317	2026-05-11 04:15:50.655317
48	1	45. Choose the word in which the underlined letters are pronounced differently from the others:\nA. ch_ur_ch   B. ch_ef_   C. ch_air_   D. ch_eck_	mcq	2	45	\N	\N	t	2026-05-11 04:15:50.668579	2026-05-11 04:15:50.668579
49	1	46. Which of the following words is correctly SYLLABIFIED?	mcq	2	46	\N	\N	t	2026-05-11 04:15:50.676594	2026-05-11 04:15:50.676594
50	1	47. Choose the option in which the word in capital letters carries the PRIMARY stress on the correct syllable:	mcq	2	47	\N	\N	t	2026-05-11 04:15:50.688855	2026-05-11 04:15:50.688855
51	1	48. Which of the following sentences uses RISING intonation?	mcq	2	48	\N	\N	t	2026-05-11 04:15:50.701889	2026-05-11 04:15:50.701889
52	1	49. Which of the following sentences is written in the PASSIVE voice?	mcq	2	49	\N	\N	t	2026-05-11 04:15:50.709907	2026-05-11 04:15:50.709907
53	1	50. Choose the option that correctly REWRITES the sentence in the passive voice:\n"The committee approved the budget last Tuesday."	mcq	2	50	\N	\N	t	2026-05-11 04:15:50.722645	2026-05-11 04:15:50.722645
54	1	51. Which of the following is a COMPOUND sentence?	mcq	2	51	\N	\N	t	2026-05-11 04:15:50.7352	2026-05-11 04:15:50.7352
55	1	52. Choose the sentence that contains a RELATIVE clause:	mcq	2	52	\N	\N	t	2026-05-11 04:15:50.743197	2026-05-11 04:15:50.743197
56	1	53. Which of the following words is a GERUND?	mcq	2	53	\N	\N	t	2026-05-11 04:15:50.755167	2026-05-11 04:15:50.755167
57	1	54. Choose the option that CORRECTLY uses a comma:	mcq	2	54	\N	\N	t	2026-05-11 04:15:50.768489	2026-05-11 04:15:50.768489
58	1	55. Which of the following contains a DANGLING MODIFIER?	mcq	2	55	\N	\N	t	2026-05-11 04:15:50.785276	2026-05-11 04:15:50.785276
59	1	56. Choose the sentence in which the apostrophe is used CORRECTLY:	mcq	2	56	\N	\N	t	2026-05-11 04:15:50.788588	2026-05-11 04:15:50.788588
60	1	57. The word 'whom' is correctly used in which of the following sentences?	mcq	2	57	\N	\N	t	2026-05-11 04:15:50.804116	2026-05-11 04:15:50.804116
61	1	58. Choose the option that gives the PLURAL of the word 'phenomenon':	mcq	2	58	\N	\N	t	2026-05-11 04:15:50.818637	2026-05-11 04:15:50.818637
62	1	59. In which of the following sentences is the word 'since' used as a CONJUNCTION?	mcq	2	59	\N	\N	t	2026-05-11 04:15:50.822036	2026-05-11 04:15:50.822036
63	1	60. Choose the option that best REPLACES the underlined expression without changing the meaning:\n"He was IN HIGH SPIRITS after receiving his promotion letter."	mcq	2	60	\N	\N	t	2026-05-11 04:15:50.843126	2026-05-11 04:15:50.843126
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, created_at) FROM stdin;
1	Admin	System Administrator	2026-05-10 18:09:09.621787
2	Teacher	Teacher role	2026-05-10 18:09:09.621787
3	Student	Student role	2026-05-10 18:09:09.621787
\.


--
-- Data for Name: student_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_answers (id, exam_session_id, question_id, student_id, selected_option_id, theory_answer, is_correct, marks_obtained, time_spent_seconds, marked_for_review, visited_count, created_at, updated_at) FROM stdin;
1	1	4	4	2	\N	f	0	0	f	0	2026-05-11 15:18:34.719881	2026-05-11 15:18:34.845676
2	1	5	4	6	\N	f	0	0	f	0	2026-05-11 15:18:34.744158	2026-05-11 15:18:34.849754
3	1	6	4	9	\N	f	0	0	f	0	2026-05-11 15:18:34.74724	2026-05-11 15:18:34.853748
4	1	16	4	51	\N	f	0	0	f	0	2026-05-11 15:18:34.752381	2026-05-11 15:18:34.867984
5	1	17	4	54	\N	f	0	0	f	0	2026-05-11 15:18:34.755376	2026-05-11 15:18:34.870985
6	1	18	4	58	\N	t	2	0	f	0	2026-05-11 15:18:34.759376	2026-05-11 15:18:34.874983
7	1	20	4	67	\N	t	2	0	f	0	2026-05-11 15:18:34.763374	2026-05-11 15:18:34.87898
8	1	21	4	72	\N	f	0	0	f	0	2026-05-11 15:18:34.767419	2026-05-11 15:18:34.882051
9	1	22	4	73	\N	f	0	0	f	0	2026-05-11 15:18:34.771419	2026-05-11 15:18:34.886051
10	1	23	4	77	\N	f	0	0	f	0	2026-05-11 15:18:34.774417	2026-05-11 15:18:34.889047
11	1	25	4	86	\N	t	2	0	f	0	2026-05-11 15:18:34.777416	2026-05-11 15:18:34.893048
12	1	26	4	90	\N	f	0	0	f	0	2026-05-11 15:18:34.780445	2026-05-11 15:18:34.897132
13	1	27	4	94	\N	t	2	0	f	0	2026-05-11 15:18:34.784665	2026-05-11 15:18:34.9002
14	1	28	4	99	\N	t	2	0	f	0	2026-05-11 15:18:34.787661	2026-05-11 15:18:34.903197
15	1	29	4	104	\N	f	0	0	f	0	2026-05-11 15:18:34.791662	2026-05-11 15:18:34.906193
16	1	30	4	106	\N	f	0	0	f	0	2026-05-11 15:18:34.794656	2026-05-11 15:18:34.909194
17	1	31	4	111	\N	t	2	0	f	0	2026-05-11 15:18:34.799285	2026-05-11 15:18:34.912189
18	1	32	4	113	\N	f	0	0	f	0	2026-05-11 15:18:34.803282	2026-05-11 15:18:34.915937
19	1	33	4	120	\N	f	0	0	f	0	2026-05-11 15:18:34.80628	2026-05-11 15:18:34.919935
20	1	34	4	123	\N	t	2	0	f	0	2026-05-11 15:18:34.809277	2026-05-11 15:18:34.922936
21	1	35	4	125	\N	f	0	0	f	0	2026-05-11 15:18:34.813276	2026-05-11 15:18:34.925933
22	1	36	4	131	\N	f	0	0	f	0	2026-05-11 15:18:34.817465	2026-05-11 15:18:34.928932
23	1	37	4	135	\N	t	2	0	f	0	2026-05-11 15:18:34.82146	2026-05-11 15:18:34.931749
24	1	38	4	137	\N	f	0	0	f	0	2026-05-11 15:18:34.824457	2026-05-11 15:18:34.934747
\.


--
-- Data for Name: student_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_classes (id, student_id, class_id, enrollment_date, is_active) FROM stdin;
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (id, user_id, admission_number, roll_number, class_id, contact_number, address, date_of_birth, guardian_name, guardian_contact, is_active, created_at, updated_at) FROM stdin;
1	4	MAWO/2023/075	\N	1	\N	\N	\N	\N	\N	t	2026-05-11 04:06:27.247339	2026-05-11 04:08:12.258193
\.


--
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers (id, user_id, teacher_id, subject, qualification, specialization, contact_number, address, joining_date, is_active, created_at, updated_at) FROM stdin;
1	5	TCH001	computer	\N	\N	\N	\N	\N	t	2026-05-11 04:11:23.672322	2026-05-11 04:11:23.672322
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, first_name, last_name, gender, profile_picture, is_active, is_deleted, role_id, created_at, updated_at) FROM stdin;
1	admin	admin@example.com	scrypt:32768:8:1$c8Actna6qyQYpk01$233f20af14bec04ccc76ccee582ca5cb8430754298527297f6e554307fd578bf4b45bfee031f79c2793f5e4e5c94816330799fe53d80ac3f45bbe78958c44b6a	System	Admin	male	\N	t	f	1	2026-05-10 18:09:55.386519	2026-05-11 01:30:41.464047
4	ST001	\N	scrypt:32768:8:1$2bexBVv4KQ316FGD$c47dc48d778671acce918dcd5faed99c3c258f82db46e60da91147576becb4ac95839b8a5dea211c57056fd43da619c7f0d646ac2b65d35ecd36408ce4b93443	Fatima	Muhammed	Female	\N	t	f	3	2026-05-11 04:06:26.952809	2026-05-11 04:08:12.110043
5	TS001	samuel@mawoschools.edu.ng	scrypt:32768:8:1$871XteLFKX36qJjY$ec02f65565fd99516ee4cf42c067dafdb2f9acabdeeb6f9e82b34ff75f80080b6ddd6217aea0f11da3de565a42b3d2c66ef4e79486f5a86ff70261adf93f344a	Saheed	Oyedeji	Male	\N	t	f	2	2026-05-11 04:11:23.672322	2026-05-11 04:11:23.672322
\.


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classes_id_seq', 1, true);


--
-- Name: exam_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exam_results_id_seq', 1, true);


--
-- Name: exam_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exam_sessions_id_seq', 1, true);


--
-- Name: exams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exams_id_seq', 1, true);


--
-- Name: proctoring_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proctoring_logs_id_seq', 1, true);


--
-- Name: question_options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_options_id_seq', 240, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_id_seq', 63, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- Name: student_answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_answers_id_seq', 24, true);


--
-- Name: student_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_classes_id_seq', 1, false);


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_id_seq', 1, true);


--
-- Name: teachers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teachers_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: class_teacher class_teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_teacher
    ADD CONSTRAINT class_teacher_pkey PRIMARY KEY (class_id, teacher_id);


--
-- Name: classes classes_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_code_key UNIQUE (code);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: exam_results exam_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_pkey PRIMARY KEY (id);


--
-- Name: exam_sessions exam_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_pkey PRIMARY KEY (id);


--
-- Name: exam_sessions exam_sessions_session_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_session_code_key UNIQUE (session_code);


--
-- Name: exam_sessions exam_sessions_session_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_session_token_key UNIQUE (session_token);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: proctoring_logs proctoring_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs
    ADD CONSTRAINT proctoring_logs_pkey PRIMARY KEY (id);


--
-- Name: question_options question_options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_options
    ADD CONSTRAINT question_options_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: student_answers student_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_pkey PRIMARY KEY (id);


--
-- Name: student_classes student_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes
    ADD CONSTRAINT student_classes_pkey PRIMARY KEY (id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- Name: teachers teachers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_key UNIQUE (user_id);


--
-- Name: student_classes unique_student_class; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes
    ADD CONSTRAINT unique_student_class UNIQUE (student_id, class_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_classes_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_classes_name ON public.classes USING btree (name);


--
-- Name: ix_exams_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_exams_code ON public.exams USING btree (code);


--
-- Name: ix_students_admission_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_students_admission_number ON public.students USING btree (admission_number);


--
-- Name: ix_teachers_teacher_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_teachers_teacher_id ON public.teachers USING btree (teacher_id);


--
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);


--
-- Name: class_teacher class_teacher_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_teacher
    ADD CONSTRAINT class_teacher_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: class_teacher class_teacher_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_teacher
    ADD CONSTRAINT class_teacher_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(id);


--
-- Name: exam_results exam_results_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: exam_results exam_results_exam_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_exam_session_id_fkey FOREIGN KEY (exam_session_id) REFERENCES public.exam_sessions(id);


--
-- Name: exam_results exam_results_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: exam_sessions exam_sessions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: exam_sessions exam_sessions_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_sessions
    ADD CONSTRAINT exam_sessions_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: exams exams_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: exams exams_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: proctoring_logs proctoring_logs_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs
    ADD CONSTRAINT proctoring_logs_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: proctoring_logs proctoring_logs_exam_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs
    ADD CONSTRAINT proctoring_logs_exam_session_id_fkey FOREIGN KEY (exam_session_id) REFERENCES public.exam_sessions(id);


--
-- Name: proctoring_logs proctoring_logs_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proctoring_logs
    ADD CONSTRAINT proctoring_logs_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: question_options question_options_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_options
    ADD CONSTRAINT question_options_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: questions questions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id);


--
-- Name: student_answers student_answers_exam_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_exam_session_id_fkey FOREIGN KEY (exam_session_id) REFERENCES public.exam_sessions(id);


--
-- Name: student_answers student_answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: student_answers student_answers_selected_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_selected_option_id_fkey FOREIGN KEY (selected_option_id) REFERENCES public.question_options(id);


--
-- Name: student_answers student_answers_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_answers
    ADD CONSTRAINT student_answers_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: student_classes student_classes_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes
    ADD CONSTRAINT student_classes_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: student_classes student_classes_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_classes
    ADD CONSTRAINT student_classes_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: students students_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: teachers teachers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict xXNe8d7BPZa1jhdcsQh10on9hEJXYrA9wzA83JXtffop6bNP0xmbnvi5L2nWKVr

