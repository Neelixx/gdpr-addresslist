--
-- PostgreSQL database dump
--

\restrict TTAULhGJ04ZnpICzvQcliYBeS2DV1eaXfl8AgSLT1Jhoyu4oMdo1iJUtj5gm5kG

-- Dumped from database version 15.19
-- Dumped by pg_dump version 17.11 (Debian 17.11-0+deb13u1)

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: alumni_admin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO alumni_admin;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: alumni_admin
--

COMMENT ON SCHEMA public IS '';


--
-- Name: persongroup; Type: TYPE; Schema: public; Owner: alumni_admin
--

CREATE TYPE public.persongroup AS ENUM (
    'student',
    'teacher',
    'classmate'
);


ALTER TYPE public.persongroup OWNER TO alumni_admin;

--
-- Name: reachability; Type: TYPE; Schema: public; Owner: alumni_admin
--

CREATE TYPE public.reachability AS ENUM (
    'unknown',
    'email',
    'whatsapp',
    'landline',
    'deceased'
);


ALTER TYPE public.reachability OWNER TO alumni_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: alumni_admin
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    person_id integer,
    action character varying NOT NULL,
    field_changed character varying,
    old_value text,
    new_value text,
    ip_address character varying,
    "timestamp" timestamp with time zone DEFAULT now()
);


ALTER TABLE public.audit_logs OWNER TO alumni_admin;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: alumni_admin
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO alumni_admin;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumni_admin
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: alumni_admin
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.groups OWNER TO alumni_admin;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: alumni_admin
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO alumni_admin;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumni_admin
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: magic_tokens; Type: TABLE; Schema: public; Owner: alumni_admin
--

CREATE TABLE public.magic_tokens (
    id integer NOT NULL,
    email character varying NOT NULL,
    token character varying NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.magic_tokens OWNER TO alumni_admin;

--
-- Name: magic_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: alumni_admin
--

CREATE SEQUENCE public.magic_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.magic_tokens_id_seq OWNER TO alumni_admin;

--
-- Name: magic_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumni_admin
--

ALTER SEQUENCE public.magic_tokens_id_seq OWNED BY public.magic_tokens.id;


--
-- Name: persons; Type: TABLE; Schema: public; Owner: alumni_admin
--

CREATE TABLE public.persons (
    id integer NOT NULL,
    vorname character varying NOT NULL,
    nachname character varying NOT NULL,
    geburtsname character varying,
    adresse character varying,
    land character varying,
    ort character varying,
    plz character varying,
    telefon_1 character varying,
    telefon_2 character varying,
    mobil character varying,
    erreichbarkeit public.reachability NOT NULL,
    email_1 character varying,
    email_2 character varying,
    admin boolean,
    notizen text,
    consent_storage boolean,
    consent_sharing boolean,
    consent_photos boolean,
    is_deleted boolean,
    is_blocked boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    password_hash character varying,
    username character varying,
    gruppe_id integer NOT NULL
);


ALTER TABLE public.persons OWNER TO alumni_admin;

--
-- Name: persons_id_seq; Type: SEQUENCE; Schema: public; Owner: alumni_admin
--

CREATE SEQUENCE public.persons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.persons_id_seq OWNER TO alumni_admin;

--
-- Name: persons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumni_admin
--

ALTER SEQUENCE public.persons_id_seq OWNED BY public.persons.id;


--
-- Name: privacy_policy; Type: TABLE; Schema: public; Owner: alumni_admin
--

CREATE TABLE public.privacy_policy (
    id integer NOT NULL,
    zweck text NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    title character varying DEFAULT 'Datenschutzerklärung für die Abiturientenliste'::character varying NOT NULL,
    verantwortlicher text,
    alumni_website text
);


ALTER TABLE public.privacy_policy OWNER TO alumni_admin;

--
-- Name: privacy_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: alumni_admin
--

CREATE SEQUENCE public.privacy_policy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.privacy_policy_id_seq OWNER TO alumni_admin;

--
-- Name: privacy_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumni_admin
--

ALTER SEQUENCE public.privacy_policy_id_seq OWNED BY public.privacy_policy.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: magic_tokens id; Type: DEFAULT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.magic_tokens ALTER COLUMN id SET DEFAULT nextval('public.magic_tokens_id_seq'::regclass);


--
-- Name: persons id; Type: DEFAULT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.persons ALTER COLUMN id SET DEFAULT nextval('public.persons_id_seq'::regclass);


--
-- Name: privacy_policy id; Type: DEFAULT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.privacy_policy ALTER COLUMN id SET DEFAULT nextval('public.privacy_policy_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: alumni_admin
--

COPY public.audit_logs (id, person_id, action, field_changed, old_value, new_value, ip_address, "timestamp") FROM stdin;
1	1	UPDATE	consent_photos	\N	True	172.21.0.4	2026-08-16 16:40:43.784881+00
2	1	UPDATE	vorname	Admin	Frank	172.21.0.4	2026-08-16 16:41:51.865505+00
3	1	UPDATE	nachname	Default	Wachtmeister	172.21.0.4	2026-08-16 16:41:51.865505+00
4	1	UPDATE	adresse	\N	Bonner Ring 124	172.21.0.4	2026-08-16 16:41:51.865505+00
5	1	UPDATE	land	\N	D	172.21.0.4	2026-08-16 16:41:51.865505+00
6	1	UPDATE	ort	\N	Erftstadt	172.21.0.4	2026-08-16 16:41:51.865505+00
7	1	UPDATE	plz	\N	50374	172.21.0.4	2026-08-16 16:41:51.865505+00
8	1	UPDATE	telefon_1	\N		172.21.0.4	2026-08-16 16:41:51.865505+00
9	1	UPDATE	telefon_2	\N		172.21.0.4	2026-08-16 16:41:51.865505+00
10	1	UPDATE	mobil	\N	+491736251646	172.21.0.4	2026-08-16 16:41:51.865505+00
11	1	UPDATE	email_1	admin@example.com	wachtmeister@web.de	172.21.0.4	2026-08-16 16:41:51.865505+00
12	1	UPDATE	email_2	\N		172.21.0.4	2026-08-16 16:41:51.865505+00
13	1	UPDATE	notizen	\N		172.21.0.4	2026-08-16 16:41:51.865505+00
14	1	UPDATE	password_hash	\N	Password changed	172.21.0.4	2026-08-16 16:49:38.299566+00
15	\N	EXPORT	all	\N	Admin export performed	172.21.0.1	2026-08-16 16:52:04.000255+00
16	\N	EXPORT	all	\N	Admin export performed	172.21.0.4	2026-08-16 16:53:54.3223+00
17	\N	EXPORT	all	\N	Admin export performed	172.21.0.1	2026-08-16 16:55:27.433063+00
18	\N	EXPORT	all	\N	Admin export performed	172.21.0.1	2026-08-16 16:56:37.176275+00
19	\N	EXPORT	all	\N	Admin export performed	172.21.0.1	2026-08-16 16:57:11.561595+00
20	\N	EXPORT	all	\N	Admin export performed	172.21.0.4	2026-08-16 16:57:39.104527+00
21	1	UPDATE	telefon_1	\N	+492235690605	172.21.0.4	2026-08-16 16:59:44.5247+00
22	1	UPDATE	telefon_2	\N	+492235440013	172.21.0.4	2026-08-16 16:59:44.5247+00
23	1	UPDATE	email_2	\N	info@frank-wachtmeister.de	172.21.0.4	2026-08-16 16:59:44.5247+00
24	1	UPDATE	notizen	\N	Ich bin Admin	172.21.0.4	2026-08-16 16:59:44.5247+00
25	\N	EXPORT	all	\N	Admin export performed	172.21.0.4	2026-08-16 16:59:49.841071+00
26	1	UPDATE	geburtsname	\N	Wachtmeister	172.21.0.4	2026-08-16 17:02:18.573784+00
27	\N	EXPORT	all	\N	Admin export performed	172.21.0.4	2026-08-16 17:02:22.796892+00
28	1	UPDATE	erreichbarkeit	Reachability.unknown	Reachability.email	172.21.0.4	2026-08-16 17:15:09.621271+00
29	1	UPDATE	email_2	info@frank-wachtmeister.de		172.21.0.4	2026-08-16 17:15:44.842098+00
30	1	UPDATE	telefon_2	+492235440013		172.21.0.4	2026-08-16 17:15:58.238786+00
31	1	UPDATE	erreichbarkeit	Reachability.email	Reachability.landline	172.21.0.4	2026-08-16 17:15:58.238786+00
32	1	UPDATE	telefon_1	+492235690605	+49223569065	172.21.0.4	2026-08-16 17:16:24.256398+00
33	1	UPDATE	password_hash	\N	Password changed	172.21.0.4	2026-08-16 17:19:09.089819+00
127	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260816_174036.sql	172.21.0.1	2026-08-16 17:40:36.422009+00
314	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
315	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
316	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
317	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
318	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
319	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
320	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
321	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
322	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
323	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
324	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
325	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
326	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
327	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
328	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
329	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
330	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
331	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
332	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
333	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
334	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
335	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
336	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
337	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
338	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
339	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
340	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
341	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
342	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
343	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
344	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
345	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
346	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
347	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
348	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
349	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
350	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
351	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
352	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
353	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
354	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
355	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
356	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
357	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
358	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
359	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
360	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
361	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
362	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
363	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
364	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
365	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
366	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
367	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
368	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
369	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
370	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
371	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
372	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
373	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
374	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
375	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
376	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
377	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
378	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
379	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
380	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
381	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
382	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
383	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
384	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
385	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
386	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
387	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
388	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
389	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
390	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
391	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
392	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
393	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
394	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
395	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
396	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
397	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
398	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
399	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
400	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
401	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
402	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
403	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
404	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
405	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
406	\N	IMPORT_CREATE	all	\N	Created via import	172.21.0.1	2026-08-16 17:42:05.036631+00
407	\N	IMPORT	all	\N	Imported 93 persons from CSV	172.21.0.1	2026-08-16 17:42:05.076853+00
408	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260816_195938.sql	172.21.0.4	2026-08-16 19:59:38.523336+00
409	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260816_195958.sql	172.21.0.4	2026-08-16 19:59:58.249256+00
410	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260816_200006.sql	172.21.0.4	2026-08-16 20:00:07.024338+00
411	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260816_200046.sql	172.21.0.4	2026-08-16 20:00:46.649278+00
412	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260816_200048.sql	172.21.0.4	2026-08-16 20:00:48.673611+00
413	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260816_200134.sql	172.21.0.1	2026-08-16 20:01:34.985925+00
414	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260816_200321.sql	172.21.0.4	2026-08-16 20:03:21.28316+00
415	1000	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
416	1001	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
417	1002	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
418	1003	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
419	1004	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
420	1005	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
421	1006	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
422	1007	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
423	1008	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
424	1009	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
425	1010	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
426	1011	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
427	1012	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
428	1013	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
429	1014	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
430	1015	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
431	1016	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
432	1017	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
433	1018	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
434	1019	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
435	1020	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
436	1021	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
437	1022	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
438	1023	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
439	1024	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
440	1025	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
441	1026	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
442	1027	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
443	1028	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
444	1029	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
445	1030	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
446	1031	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
447	1032	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
448	1033	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
449	1034	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
450	1035	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
451	1036	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
452	1037	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
453	1038	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
454	1039	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
455	1040	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
456	1041	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
457	1042	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
458	1043	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
459	1044	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
460	1045	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
461	1046	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
462	1047	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
463	1048	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
464	1049	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
465	1050	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
466	1051	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
467	1052	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
468	1053	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
469	1054	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
470	1055	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
471	1056	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
472	1057	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
473	1058	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
474	1059	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
475	1060	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
476	1061	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
477	1062	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
478	1063	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
479	1064	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
480	1065	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
481	1066	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
482	1067	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
483	1068	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
484	1069	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
485	1070	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
486	1071	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
487	1072	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
488	1073	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
489	1074	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
490	1075	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
491	1076	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
492	1077	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
493	1078	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
494	1079	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
495	1080	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
496	1081	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
497	1082	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
498	1083	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
499	1084	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
500	1085	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
501	1086	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
502	1087	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
503	1088	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
504	1089	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
505	1090	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
506	1091	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
507	1092	IMPORT_UPDATE	all	\N	Updated via import	172.21.0.4	2026-08-16 20:05:14.854375+00
508	\N	IMPORT	all	\N	Imported 0 persons from CSV	172.21.0.4	2026-08-16 20:05:14.895629+00
509	\N	EXPORT_ALL	all	\N	Exported all data with magic links (94 persons)	172.21.0.4	2026-08-16 20:08:55.430308+00
510	\N	EXPORT_ALL	all	\N	Exported all data with magic links (94 persons)	172.21.0.1	2026-08-16 20:10:47.251927+00
511	\N	EXPORT_ALL	all	\N	Exported all data with magic links (94 persons)	172.21.0.4	2026-08-16 20:12:25.63992+00
512	1061	DELETE	all	\N	Person deleted (right to be forgotten)	172.21.0.4	2026-08-16 20:15:03.405986+00
513	1000	UPDATE	consent_storage	\N	True	172.21.0.4	2026-08-16 20:25:26.893473+00
514	1000	UPDATE	consent_sharing	\N	True	172.21.0.4	2026-08-16 20:25:28.43662+00
515	1007	UPDATE	consent_sharing	\N	True	172.21.0.4	2026-08-16 20:27:00.802794+00
516	1000	UPDATE	admin	\N	True	172.21.0.4	2026-08-16 20:43:22.289634+00
517	1000	UPDATE	nachname	Wagner	WagnerIn	172.21.0.4	2026-08-16 20:44:06.090794+00
518	1000	UPDATE	nachname	WagnerIn	Wagner	172.21.0.4	2026-08-16 20:44:11.280322+00
519	1000	UPDATE	username	ute.wagner	ute12.wagner	172.21.0.4	2026-08-16 20:44:27.225456+00
520	1000	UPDATE	username	ute12.wagner	ute.wagner	172.21.0.4	2026-08-16 20:44:34.72581+00
521	1000	UPDATE	email_1	ute.wagner94@example.com	ute.wagner94@web.de	172.21.0.4	2026-08-16 20:44:56.370736+00
522	1025	UPDATE	gruppe	PersonGroup.teacher	PersonGroup.student	172.21.0.4	2026-08-16 20:49:48.857919+00
523	3	CREATE	all	\N	Person created	\N	2026-08-16 20:57:55.687173+00
524	1092	UPDATE	telefon_2	\N		172.21.0.4	2026-08-16 21:12:50.781308+00
525	1092	UPDATE	erreichbarkeit	Reachability.whatsapp	Reachability.deceased	172.21.0.4	2026-08-16 21:12:50.781308+00
526	1092	UPDATE	email_2	\N		172.21.0.4	2026-08-16 21:12:50.781308+00
527	1092	UPDATE	consent_sharing	\N	True	172.21.0.4	2026-08-16 21:14:14.314283+00
528	3	DELETE	all	\N	Person deleted (right to be forgotten)	172.21.0.4	2026-08-16 21:32:53.943174+00
529	3	DELETE	all	\N	Person deleted (right to be forgotten)	172.21.0.4	2026-08-16 21:33:22.774067+00
530	3	DELETE	all	\N	Person deleted (right to be forgotten)	172.21.0.1	2026-08-16 21:34:32.106777+00
531	7	CREATE	all	\N	Person created	\N	2026-08-16 21:39:30.614384+00
532	7	DELETE	all	\N	Person deleted (right to be forgotten)	172.21.0.4	2026-08-16 21:40:04.527043+00
533	1	UPDATE	consent_photos	True	False	172.21.0.4	2026-08-16 22:10:15.625364+00
534	1	UPDATE	consent_sharing	True	False	172.21.0.4	2026-08-16 22:11:00.536293+00
535	1	UPDATE	vorname	Frank	Mr	172.21.0.4	2026-08-16 22:12:08.315388+00
536	1	UPDATE	nachname	Wachtmeister	Admin	172.21.0.4	2026-08-16 22:12:08.315388+00
537	1	UPDATE	geburtsname	Wachtmeister		172.21.0.4	2026-08-16 22:12:08.315388+00
538	1	UPDATE	adresse	Bonner Ring 124		172.21.0.4	2026-08-16 22:12:08.315388+00
539	1	UPDATE	land	D		172.21.0.4	2026-08-16 22:12:08.315388+00
540	1	UPDATE	ort	Erftstadt		172.21.0.4	2026-08-16 22:12:08.315388+00
541	1	UPDATE	plz	50374		172.21.0.4	2026-08-16 22:12:08.315388+00
542	1	UPDATE	telefon_1	+49223569065		172.21.0.4	2026-08-16 22:12:08.315388+00
543	1	UPDATE	mobil	+491736251646		172.21.0.4	2026-08-16 22:12:08.315388+00
544	1	UPDATE	erreichbarkeit	Reachability.landline	Reachability.email	172.21.0.4	2026-08-16 22:12:08.315388+00
545	1	UPDATE	email_1	wachtmeister@web.de	myadmin@example.com	172.21.0.4	2026-08-16 22:12:08.315388+00
546	1	UPDATE	notizen	Ich bin Admin	Ich bin der Admin	172.21.0.4	2026-08-16 22:12:08.315388+00
547	1	UPDATE	consent_sharing	\N	True	172.21.0.4	2026-08-16 22:12:22.500393+00
548	1	UPDATE	consent_sharing	True	False	172.21.0.4	2026-08-16 22:12:54.277607+00
549	1	UPDATE	vorname	Mr	Max	172.21.0.4	2026-08-16 22:16:53.889911+00
550	1	UPDATE	nachname	Admin	Datenschutzverantwortlicher	172.21.0.4	2026-08-16 22:16:53.889911+00
551	1	UPDATE	telefon_1	\N	+49 1234 5678	172.21.0.4	2026-08-16 22:16:53.889911+00
552	1	UPDATE	mobil	\N	+49 173 2345 6789	172.21.0.4	2026-08-16 22:16:53.889911+00
553	1	UPDATE	consent_sharing	\N	True	172.21.0.4	2026-08-16 23:02:39.609687+00
554	1	UPDATE	email_1	myadmin@example.com	naboo61@gmail.com	172.21.0.3	2026-08-18 16:21:39.498127+00
555	1	UPDATE	consent_photos	\N	True	172.21.0.2	2026-08-18 20:32:19.985451+00
556	1	UPDATE	consent_photos	True	False	172.21.0.2	2026-08-18 20:32:58.026333+00
557	1	UPDATE	geburtsname	\N	ll	172.21.0.2	2026-08-18 20:33:19.29811+00
558	1	UPDATE	consent_sharing	True	False	172.21.0.2	2026-08-18 20:51:38.772229+00
559	1	UPDATE	consent_sharing	\N	True	172.21.0.2	2026-08-18 20:51:56.622536+00
560	1	UPDATE	consent_sharing	True	False	172.21.0.2	2026-08-18 20:55:28.942464+00
561	1	UPDATE	consent_sharing	\N	True	172.21.0.2	2026-08-18 21:10:39.67203+00
562	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260818_224734.sql	172.21.0.2	2026-08-18 22:47:34.785317+00
563	\N	EXPORT_ALL	all	\N	Exported all data with magic links (96 persons)	172.21.0.2	2026-08-18 22:48:04.077509+00
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: alumni_admin
--

COPY public.groups (id, name, created_at) FROM stdin;
1	SchülerIn	2026-08-16 21:44:14.809979
2	LehrerIn	2026-08-16 21:44:14.809979
3	MitschülerIn	2026-08-16 21:44:14.809979
\.


--
-- Data for Name: magic_tokens; Type: TABLE DATA; Schema: public; Owner: alumni_admin
--

COPY public.magic_tokens (id, email, token, expires_at, used, created_at) FROM stdin;
1	wachtmeister@web.de	sLaq2sRcD2cg3yVHiv_mCkFZ1Z5buVZzU0knOAQlkds	2026-08-17 20:08:55.43127+00	f	2026-08-16 20:08:55.434149+00
2	ute.wagner94@example.com	Qt7Iq5uc-eertnbMGLwHlYZLFeNJZUT7TwWsBVFrLsc	2026-08-17 20:08:55.442641+00	f	2026-08-16 20:08:55.442786+00
3	günter.koch16@example.com	STxVM-N9VQxdFVR_UZyWqWthCJegFwutcRa3bBnOkZ4	2026-08-17 20:08:55.445474+00	f	2026-08-16 20:08:55.44565+00
4	petra.koch8@example.com	P-N-KS5xTEh30bNyawXJPJu540LxQW7p4gVHXsGS6Ow	2026-08-17 20:08:55.448369+00	f	2026-08-16 20:08:55.448512+00
5	monika.schulz58@example.com	nbcWMV4vOpSpKjslqz-SVbQFhNeRIYrIXfdfPQJuL44	2026-08-17 20:08:55.451274+00	f	2026-08-16 20:08:55.451396+00
6	max.hoffmann67@example.com	AkWMJUEHzhGO70SUrC8dKADVPuEXEM9cTELBoflceLI	2026-08-17 20:08:55.453433+00	f	2026-08-16 20:08:55.453551+00
7	ingrid.bauer1@example.com	EwE6ByLPkS1E4IoQrdylnqA3vWyF7ndek5ItCLo5dLI	2026-08-17 20:08:55.456222+00	f	2026-08-16 20:08:55.456325+00
8	ute.schulz91@example.com	6OCquBeBiYsNrTT8LxIHZK3YOirm4zE4u9mA7cDc7QQ	2026-08-17 20:08:55.459368+00	f	2026-08-16 20:08:55.459474+00
9	hans.hoffmann39@example.com	O03I8MvVJIwHHuTcygFaEWZZZ_k0_T3xRoIN1I5E1Ro	2026-08-17 20:08:55.462421+00	f	2026-08-16 20:08:55.462517+00
10	wolfgang.schneider18@example.com	yx9mxHRTgQIm93RZnRB56jxnMBWL8OlwY8mhLWGv1u4	2026-08-17 20:08:55.465452+00	f	2026-08-16 20:08:55.465564+00
11	andreas.meyer86@example.com	-Kluqy2X0Df7N32GWAbxply1IQ5AWZ7qho4FO_MrrvY	2026-08-17 20:08:55.468444+00	f	2026-08-16 20:08:55.468548+00
12	petra.weber99@example.com	KeR75inpHIBusZIuAOjB7O-YetBJExe09qzVauHyVIo	2026-08-17 20:08:55.471226+00	f	2026-08-16 20:08:55.47133+00
13	wolfgang.schäfer62@example.com	eMNHYHhk4PhqscdN72W7SXo_AWwXdD2g-o_FffExxmY	2026-08-17 20:08:55.473476+00	f	2026-08-16 20:08:55.473579+00
14	hans.schulz54@example.com	P7_wCWghmpxTsHXDyoEotd7hXQaYX-u36G0A7QhBjCs	2026-08-17 20:08:55.476234+00	f	2026-08-16 20:08:55.476334+00
15	ingrid.hoffmann1@example.com	gj-1CLmalMH73V9G7ppOxsLJVP0WUvArzdgqhIClR9Y	2026-08-17 20:08:55.479543+00	f	2026-08-16 20:08:55.479655+00
16	sabine.schneider62@example.com	_KPUh2K-hjzYewOMIuMF-PkV9nV2DmKP1pv82DUSdOk	2026-08-17 20:08:55.482349+00	f	2026-08-16 20:08:55.482456+00
17	ute.schäfer95@example.com	D4Tp-82Zt_nIXu1vGCzd6UbXcxZrsXzMq3n7sLvGHFo	2026-08-17 20:08:55.48544+00	f	2026-08-16 20:08:55.485542+00
18	petra.richter20@example.com	TLqEeZeITNq7t036_vwE9uYyII80VYD8c4EpX7ZIUBU	2026-08-17 20:08:55.488199+00	f	2026-08-16 20:08:55.488299+00
19	max.mustermann90@example.com	Nv0_vOl25UwpfrqrK-KrMvx2-Of1z1G3sEmpXENOXF8	2026-08-17 20:08:55.491303+00	f	2026-08-16 20:08:55.491404+00
20	karl.meyer13@example.com	kEhtofzVixws16v8sYW4QuE4-T_MXEYjgQ6ozXf8ils	2026-08-17 20:08:55.494392+00	f	2026-08-16 20:08:55.494491+00
21	karl.bauer75@example.com	CquYtT38oyf98GaG1C6NkYatHTVLz9naKuHsSSzHUO4	2026-08-17 20:08:55.497266+00	f	2026-08-16 20:08:55.497364+00
22	max.fischer7@example.com	m9Xm5F58p08LMhLrGkJBhpQmqV2aIG7nId4okzIj4mE	2026-08-17 20:08:55.49943+00	f	2026-08-16 20:08:55.499528+00
23	karl.meyer57@example.com	M4o-H2UdkvQSv-MOP9LH5xiQdTSJhErBjNqZRmjm1lw	2026-08-17 20:08:55.502246+00	f	2026-08-16 20:08:55.502346+00
24	hans.müller8@example.com	dq_vJQ5g1YKKwVLU80XE2yTmlt8saby5_FjPbLhFIAY	2026-08-17 20:08:55.505589+00	f	2026-08-16 20:08:55.505689+00
25	max.richter31@example.com	n3EZl4gZKKVVzze22jNWvFdCSdfY8jzZm8J55lPd-CI	2026-08-17 20:08:55.508419+00	f	2026-08-16 20:08:55.508517+00
26	günter.schulz64@example.com	jP2CwC3EO4FYI_1jT87ZVyyK-HJ3kjka4AIHDmKefMo	2026-08-17 20:08:55.511464+00	f	2026-08-16 20:08:55.511572+00
27	andreas.schneider39@example.com	2SxBa_r3aJcuaCXSvmIxF_iOchVtWa4jpJgVtjbZk0c	2026-08-17 20:08:55.514248+00	f	2026-08-16 20:08:55.514341+00
28	karl.weber69@example.com	zo7JbqzLIZAf-QbqEdNausPskN1tJHOcDpIi3POXqjk	2026-08-17 20:08:55.517335+00	f	2026-08-16 20:08:55.517425+00
29	andreas.weber27@example.com	pmImAuxuPsVCnSLSZVvfO-vlo5ALjtOzU3W1U5b2TPY	2026-08-17 20:08:55.520426+00	f	2026-08-16 20:08:55.520523+00
30	erika.wagner30@example.com	ssw5wvYkeBga4HvrgSWNBd0s0W-WawnTLyBE0mHIbOM	2026-08-17 20:08:55.523436+00	f	2026-08-16 20:08:55.523547+00
31	günter.weber46@example.com	5xtzP8Uv8GnfOQ7Zl537kXaH4y9KITX7CvlimJs_-ho	2026-08-17 20:08:55.526639+00	f	2026-08-16 20:08:55.526744+00
32	stefan.schneider51@example.com	S186JjUXm33ADbNK6nZ6otEyYVgZTHsbqw8YHpmEtPk	2026-08-17 20:08:55.529219+00	f	2026-08-16 20:08:55.529322+00
33	wolfgang.bauer15@example.com	bMoTpJLoev6pMalggYRnaTG-cjVX0iKJeqq4pXCDRhY	2026-08-17 20:08:55.531445+00	f	2026-08-16 20:08:55.531535+00
34	nicole.koch93@example.com	oYzJL_qERaEq6aPTGEJPNAQQ1NrmWIkaMOc7TVy3gbA	2026-08-17 20:08:55.534252+00	f	2026-08-16 20:08:55.534343+00
35	karl.schäfer88@example.com	hmYIr-lvZ8Q9pWsv4VJh8PpwA6hnN3KFJbZKd6hz2Hc	2026-08-17 20:08:55.537551+00	f	2026-08-16 20:08:55.537649+00
36	helga.schulz69@example.com	PEQk4EcIth-Mm9XB9sDlAqjamumWk33CIFU0DL3COos	2026-08-17 20:08:55.540349+00	f	2026-08-16 20:08:55.540438+00
37	helga.wagner35@example.com	kSRXCrvfIePBr9TS5rP7lTqwXBKSJ7FCiQmqePG0Y08	2026-08-17 20:08:55.543469+00	f	2026-08-16 20:08:55.543568+00
38	monika.meyer34@example.com	ZL-OKbXgi6-dWxxPPNN5RzYfZLaEC-fNLS3RyyaSIWs	2026-08-17 20:08:55.546217+00	f	2026-08-16 20:08:55.546307+00
39	helga.mustermann93@example.com	1bfw7jmI7I3sdh1sinoPcrzLkoicsM3S86SNNkDGPPE	2026-08-17 20:08:55.549317+00	f	2026-08-16 20:08:55.549415+00
40	karl.fischer37@example.com	eNZ3qx0crh0IsJCbi9cqOfcg7vIrfa-wBaBqgJh7llo	2026-08-17 20:08:55.552369+00	f	2026-08-16 20:08:55.552469+00
41	erika.schmidt61@example.com	j99SpZk2cpTbGs5DCovGwNIXOASpg6u7m5aGOZPof9o	2026-08-17 20:08:55.55527+00	f	2026-08-16 20:08:55.555362+00
42	karl.fischer40@example.com	q0XJjLEHsGH1zutscQmY5nNzRK0-4MYpqNNPvyZYXGc	2026-08-17 20:08:55.557396+00	f	2026-08-16 20:08:55.557487+00
43	erika.richter33@example.com	NU6gsFG7yaKKpjGIi6oqVL7i0IZNYKuSV0-2eXHrjaw	2026-08-17 20:08:55.560435+00	f	2026-08-16 20:08:55.560535+00
44	hans.meyer53@example.com	GKXOGgsW6pW072PF6sn7EZOIWjKCkU6bHZfy5p54B7k	2026-08-17 20:08:55.563447+00	f	2026-08-16 20:08:55.56354+00
45	nicole.mustermann87@example.com	8pIaKCrMMTRYeJNhpooxO1w2aqyEcazReqUgRObhoaE	2026-08-17 20:08:55.566272+00	f	2026-08-16 20:08:55.566371+00
46	andreas.fischer67@example.com	fRXmM1kbLjV_V5dO6qa_9w9XlKeIux7ePTEU70l1anc	2026-08-17 20:08:55.569363+00	f	2026-08-16 20:08:55.569456+00
47	christian.müller19@example.com	VM6s7lHI2PbT6E8HIaEsZj-qAaQ8-xmsMzIrWA6Q89c	2026-08-17 20:08:55.572208+00	f	2026-08-16 20:08:55.57231+00
48	karl.wagner70@example.com	m5QJKt6wRWZLE4QEhEx-NAe6CBKdZTD7dZFEPQMxZ6s	2026-08-17 20:08:55.575303+00	f	2026-08-16 20:08:55.575394+00
49	sabine.koch69@example.com	ok3Dr1QiitJPUY5pK2m8OuVD-9Unz_oFmS7lxkuaE98	2026-08-17 20:08:55.57832+00	f	2026-08-16 20:08:55.578419+00
50	sabine.müller24@example.com	NqOySlVuuXLcPLgmri6E2CJvoTpD1wsNnXUTvC5SOlM	2026-08-17 20:08:55.581385+00	f	2026-08-16 20:08:55.581476+00
51	erika.schulz89@example.com	VKvoqCD74lGGtgeJreHLAv7xNtWxEDZE9KaAefea5o4	2026-08-17 20:08:55.584412+00	f	2026-08-16 20:08:55.584511+00
52	karl.koch22@example.com	hcZzxP3Ny8O3p9psK8hvyGbwfVsAidI304G9bah8wVY	2026-08-17 20:08:55.587246+00	f	2026-08-16 20:08:55.587336+00
53	hans.becker76@example.com	v2RLqzktTbbgcNNuDA3kOpJdFCVomO0yueyVcJxkbK4	2026-08-17 20:08:55.590346+00	f	2026-08-16 20:08:55.590445+00
54	andreas.schäfer77@example.com	rCfAvpxTZ4NFGOOCW08-6cXy_OImopdWXWeQ7gupwD4	2026-08-17 20:08:55.593182+00	f	2026-08-16 20:08:55.593279+00
55	max.becker99@example.com	e2SyaIRNVRjgcyneD0EMyYd9Ca446ONUu4iFdloQY9g	2026-08-17 20:08:55.596295+00	f	2026-08-16 20:08:55.596394+00
56	ute.wagner46@example.com	AZz74Nm9hsqye1HCurDMD1Z2n96a51F8Ah87PGgfeO4	2026-08-17 20:08:55.59935+00	f	2026-08-16 20:08:55.599441+00
57	karl.mustermann11@example.com	5ynz6Lt2Xx7dX6CgUyop23O2sZpqfPhcJvagFejM-9I	2026-08-17 20:08:55.602206+00	f	2026-08-16 20:08:55.602305+00
58	max.schäfer42@example.com	UA1j9q2W5KJI7VBLuWPq-FDHASQTVdQIoevE1FTy1Pc	2026-08-17 20:08:55.604596+00	f	2026-08-16 20:08:55.604684+00
59	andreas.richter81@example.com	OAPEYNbGr1RnFvWu4Ks2VBXEYNKDLOXlQhNFhtX7Rcs	2026-08-17 20:08:55.607593+00	f	2026-08-16 20:08:55.607689+00
60	andreas.hoffmann88@example.com	ojdWAkZqYeHpisdzXV4GAJmwCpwyr1lSRaXaSlxXMn0	2026-08-17 20:08:55.61056+00	f	2026-08-16 20:08:55.610652+00
61	helga.becker76@example.com	AlHxVs4DbHOxvfKFgBcg_HBOzyhaIjANuSVgmtgS8LA	2026-08-17 20:08:55.613559+00	f	2026-08-16 20:08:55.613648+00
62	max.schäfer73@example.com	NswtFnyxx6oZOPA30oVlAwJ5M03cFss1Zzndpc3vPpA	2026-08-17 20:08:55.616352+00	f	2026-08-16 20:08:55.61645+00
63	wolfgang.müller85@example.com	qc2Y_kuzV8FYmX7Qlua21ZoTYcWn214mMtS5bp6MNvM	2026-08-17 20:08:55.619208+00	f	2026-08-16 20:08:55.619307+00
64	ingrid.richter49@example.com	FuGJqZsZvl8qGdvMINYl3OgbW--uXwSFb9OpU2bht2c	2026-08-17 20:08:55.621411+00	f	2026-08-16 20:08:55.621502+00
65	andreas.schulz13@example.com	yAE9KTQfqPB_G4dNRk9LS92mbcPmV-aqtdYYDvI8VaQ	2026-08-17 20:08:55.624249+00	f	2026-08-16 20:08:55.624348+00
66	stefan.müller3@example.com	g8Vc4MC-QDKTmcC4TQ6BwK1RucSZ03gQnZp3_XNlSmE	2026-08-17 20:08:55.627344+00	f	2026-08-16 20:08:55.627432+00
67	stefan.bauer1@example.com	EkpiTvNJpLGs331nNgkU5jxxF4ENsUj6i0y4EICaG-o	2026-08-17 20:08:55.630184+00	f	2026-08-16 20:08:55.630282+00
68	max.schulz82@example.com	5one_Wx-kJ0hV76Aw7mwJ3OmgQOD4QpbqzTREWN_pik	2026-08-17 20:08:55.633289+00	f	2026-08-16 20:08:55.633378+00
69	erika.fischer58@example.com	EDdFKaG0QJqEXb4pQm7C9aeC2IbP-EaIWqJOK_TK-g4	2026-08-17 20:08:55.636345+00	f	2026-08-16 20:08:55.636442+00
70	nicole.meyer1@example.com	z9weYMPB0a0ayTKnbC8GPr6B-xqwgDIbVH57VhXqIPk	2026-08-17 20:08:55.639207+00	f	2026-08-16 20:08:55.639306+00
71	erika.weber63@example.com	H2AUjmQHWnf-oNLQelZemtmydvHQQHrnKRDg2miLyec	2026-08-17 20:08:55.641402+00	f	2026-08-16 20:08:55.64149+00
72	petra.richter27@example.com	pmKKY3IPUviNcjD86FaGSON0-JVH_SbjfqpBcvnpgzs	2026-08-17 20:08:55.644244+00	f	2026-08-16 20:08:55.644335+00
73	erika.richter77@example.com	JywaBn5ZrF4edpT-wEzvl9ziQc0VFabEJ70kkkVmBaQ	2026-08-17 20:08:55.647349+00	f	2026-08-16 20:08:55.647443+00
74	helga.schulz78@example.com	30MZiw5dxSVWGv02RF6kgzx6ov9gUBU88zFhGMVKAng	2026-08-17 20:08:55.650186+00	f	2026-08-16 20:08:55.650277+00
75	karl.richter6@example.com	6Zds3LMe2HvkuxyytL4-jETDb3nguxpGw1aBLmLAu34	2026-08-17 20:08:55.653299+00	f	2026-08-16 20:08:55.653398+00
76	ute.koch17@example.com	srNuSREUgCHcU-TAQVUPgM9aaFXzgUhQIsdit1M3vAI	2026-08-17 20:08:55.656347+00	f	2026-08-16 20:08:55.656497+00
77	ingrid.schmidt83@example.com	7ZKmJkcIPG0l7xx6gFio6jANzMQn5CMInJvOGgwVlrk	2026-08-17 20:08:55.659402+00	f	2026-08-16 20:08:55.659504+00
78	helga.schäfer44@example.com	xIKCe4rM12gnoWgXVZQzFGT-W9W0HSUjhP6Nbd6vKeM	2026-08-17 20:08:55.662611+00	f	2026-08-16 20:08:55.6627+00
79	karl.wagner24@example.com	tkkut99qJxj5hOaBLSt5NwyXwe-Yc9Gd_L5-VdmGmGI	2026-08-17 20:08:55.665195+00	f	2026-08-16 20:08:55.665286+00
80	wolfgang.bauer79@example.com	2tJ9drMgqwebSs8F9q0Nvb8jj31fYi-mwGNB-OGyVt0	2026-08-17 20:08:55.667398+00	f	2026-08-16 20:08:55.667487+00
81	monika.meyer83@example.com	M0Ii940bZzS5ECqdokZRqT4XEDnMG61YiMsnyxkq61k	2026-08-17 20:08:55.670237+00	f	2026-08-16 20:08:55.670335+00
82	hans.schmidt96@example.com	WGuOLVemWam2rowCvm_7g9tPEWHjYDca7S3a4RgZxs0	2026-08-17 20:08:55.673339+00	f	2026-08-16 20:08:55.673429+00
83	nicole.wagner86@example.com	mPM2rwyF3403w-CXOqmHTj0M5bRKX2ibDIHDv4xGf9s	2026-08-17 20:08:55.676407+00	f	2026-08-16 20:08:55.676534+00
84	max.schneider14@example.com	alHBXpd8fmVqr8DNMfGynw7E1Q6yyeQhnaJmL__Jxw4	2026-08-17 20:08:55.679306+00	f	2026-08-16 20:08:55.679464+00
85	karl.fischer65@example.com	xRWDnWWnyxsLnqu8okTESV50F6lqaJB4JctLsygUdnI	2026-08-17 20:08:55.682552+00	f	2026-08-16 20:08:55.682679+00
86	karl.schulz24@example.com	QFSNQhEq30lJnt32uWSfNzqPwhUkyC6sSs-o7OvXzuw	2026-08-17 20:08:55.685357+00	f	2026-08-16 20:08:55.685464+00
87	andreas.schmidt54@example.com	itz4naBUDHaAjW71yIfpSur0L6uAk00no3GxTbES71M	2026-08-17 20:08:55.688399+00	f	2026-08-16 20:08:55.688504+00
88	karl.schäfer89@example.com	bM7kAfQVSDNUG53cf0N5HZgoStsqShnOE2mt853P5X8	2026-08-17 20:08:55.69143+00	f	2026-08-16 20:08:55.691531+00
89	monika.mustermann85@example.com	bq4J2e14PT_fyXWwA9cUpobX923gspb73yMRZUYTR5Q	2026-08-17 20:08:55.694644+00	f	2026-08-16 20:08:55.694747+00
90	petra.richter40@example.com	8aP-LG0yJ0b1qFk5nXeKNm8shYcSJhU_D03KieEOCAI	2026-08-17 20:08:55.697225+00	f	2026-08-16 20:08:55.697323+00
91	erika.becker72@example.com	x4nEerSZG_3ibfb_cUatc5orAsxUcrvx-2jt8Mwh-2g	2026-08-17 20:08:55.699419+00	f	2026-08-16 20:08:55.699512+00
92	andreas.müller22@example.com	CO4lvrwMu5AeALMMFyADw0kPAogUNV61_8KlqmEXIyM	2026-08-17 20:08:55.702249+00	f	2026-08-16 20:08:55.702343+00
93	günter.bauer22@example.com	yHYM6RrTxQ85gD709Mg8QnpJA74MV0cNwEeKdLgxy_U	2026-08-17 20:08:55.70535+00	f	2026-08-16 20:08:55.705444+00
94	andreas.bauer34@example.com	5GotBPaFADjmWMpZnnVFShPoXi4baOioqqHQn-orf1w	2026-08-17 20:08:55.708188+00	f	2026-08-16 20:08:55.70829+00
95	wachtmeister@web.de	RqV_ldyzkEPGpI3jwNkoCtw3HCh0LNjbxmWlbiG53ko	2026-08-17 20:10:47.252884+00	f	2026-08-16 20:10:47.253119+00
96	ute.wagner94@example.com	DAnNsT0axVLD3wrAUOu__s7Sb8zATXeOdbI4DyxztAw	2026-08-17 20:10:47.258785+00	f	2026-08-16 20:10:47.258913+00
97	günter.koch16@example.com	QGxx7cZpZt6pjo8AG8mVcnAdrpLo5hR-0j3j3NOY35w	2026-08-17 20:10:47.261667+00	f	2026-08-16 20:10:47.261829+00
98	petra.koch8@example.com	0d1LDGSW-Pe-vKNWdXDe8tSIdh74cupqphn0Qww00HE	2026-08-17 20:10:47.264789+00	f	2026-08-16 20:10:47.264941+00
99	monika.schulz58@example.com	26dpaFIYII3E7oxRjQBrhyBByVoEYTjl6hImNqLfSbk	2026-08-17 20:10:47.267846+00	f	2026-08-16 20:10:47.26799+00
100	max.hoffmann67@example.com	hYMGqCFDoQ9soxgQwFeuWFL1aO6jLicQFDi6K3W1fNo	2026-08-17 20:10:47.270681+00	f	2026-08-16 20:10:47.270805+00
101	ingrid.bauer1@example.com	qgirTLBDBSITFhrL_rZBnL3IZETMGHZwdQ6M20tgLUI	2026-08-17 20:10:47.273814+00	f	2026-08-16 20:10:47.273978+00
102	ute.schulz91@example.com	JXoQuMesiZdk4HFwfphqw3rTWmDarNZg74cdmScjsh0	2026-08-17 20:10:47.275084+00	f	2026-08-16 20:10:47.275214+00
103	hans.hoffmann39@example.com	Q--udCYHNmFTDMdFUoOp9wkoEN7HukGHACPtx1vaK3U	2026-08-17 20:10:47.27785+00	f	2026-08-16 20:10:47.27797+00
104	wolfgang.schneider18@example.com	WO47sSReskwB5gbbk-0jtjJJeGUy7WoIvRETCWGPLWs	2026-08-17 20:10:47.280706+00	f	2026-08-16 20:10:47.280819+00
105	andreas.meyer86@example.com	_s6d-_XbonH6JpSbzWbj11XDdjzSisHKqirXSeIu_eg	2026-08-17 20:10:47.284033+00	f	2026-08-16 20:10:47.284198+00
106	petra.weber99@example.com	BU18zau7Nz81Bex1HmCF0P_kOee12a6vqBMGrA1CBrg	2026-08-17 20:10:47.286603+00	f	2026-08-16 20:10:47.28673+00
107	wolfgang.schäfer62@example.com	jo5JDjlGzHV_THfwB2fDchKxzsZaeD_Axc_WZgUVXuo	2026-08-17 20:10:47.288787+00	f	2026-08-16 20:10:47.288893+00
108	hans.schulz54@example.com	TjYLvRRdSqsVRoTZrwYm3kDnYXEVg8JcSM2SCa0tStM	2026-08-17 20:10:47.291629+00	f	2026-08-16 20:10:47.291731+00
109	ingrid.hoffmann1@example.com	Ghcqexs7iH-h0VBYliiXg6n65sXaq1rwoj5x90N3oD0	2026-08-17 20:10:47.294737+00	f	2026-08-16 20:10:47.294844+00
110	sabine.schneider62@example.com	2Vry82hTyaBYShBjGDtCvt4dPk1xVW0a3465q1EzPl4	2026-08-17 20:10:47.297833+00	f	2026-08-16 20:10:47.297974+00
111	ute.schäfer95@example.com	PfUTqbF2G5_e3NJjinTlFONEzulb6NtC8vFiKpyT_NM	2026-08-17 20:10:47.300658+00	f	2026-08-16 20:10:47.300767+00
112	petra.richter20@example.com	BR6QWEynwvXIm8BCT8adH-Pxp8BFBLu8fdGZw4CRFXc	2026-08-17 20:10:47.303765+00	f	2026-08-16 20:10:47.303866+00
113	max.mustermann90@example.com	iGEYFyZIqxd6-eWUFMSo9jZhxt1QUsMdjOVlDQNC19E	2026-08-17 20:10:47.306791+00	f	2026-08-16 20:10:47.306897+00
114	karl.meyer13@example.com	RW6zTh5lTMF78VSsKMQZ9LfsyEJzp-o52UnSjQnD6kk	2026-08-17 20:10:47.310045+00	f	2026-08-16 20:10:47.31014+00
115	karl.bauer75@example.com	TNBFkfNJ5nir4Dx4J50nGDYsFrl5dyABhMTIGemzm6o	2026-08-17 20:10:47.312662+00	f	2026-08-16 20:10:47.312809+00
116	max.fischer7@example.com	KnpNVvyvvBzwedTvJBIDTJ4horDWl2w8hZq4Qjcm7Ww	2026-08-17 20:10:47.315786+00	f	2026-08-16 20:10:47.315932+00
117	karl.meyer57@example.com	9kDxWYmwWQIMEDgM3VlUhA2-UPlDf2ZHeBqIfLCSZeU	2026-08-17 20:10:47.318819+00	f	2026-08-16 20:10:47.318939+00
118	hans.müller8@example.com	JEg5y8wdA4abkmRhKaD5RAZ3q0wh_zen-m8oVG0d-T4	2026-08-17 20:10:47.321658+00	f	2026-08-16 20:10:47.321767+00
119	max.richter31@example.com	zvin3z6zaPxJO6jHhhjrwk2_3VmuZ2nQDBB2OMsFwOU	2026-08-17 20:10:47.324032+00	f	2026-08-16 20:10:47.324144+00
120	günter.schulz64@example.com	7aNYjRnE5QzhDFa9_OT--LgQYchX-xVEAAix6XlQURo	2026-08-17 20:10:47.326833+00	f	2026-08-16 20:10:47.326942+00
121	andreas.schneider39@example.com	E5EqnBQMqxC07lRMVsIDgBS2QGK8_3JkCehqyx20qu8	2026-08-17 20:10:47.329895+00	f	2026-08-16 20:10:47.330055+00
122	karl.weber69@example.com	qAjzvpc37h4iiW-9eHwIvuphnJeSes2Cq92e1nE8e0g	2026-08-17 20:10:47.332737+00	f	2026-08-16 20:10:47.332883+00
123	andreas.weber27@example.com	U0yfWU_d3v22rNpcAn-CKf6zur6sBnXuyMfjpzeP9Fw	2026-08-17 20:10:47.335805+00	f	2026-08-16 20:10:47.335925+00
124	erika.wagner30@example.com	6kcQCxvB8BzmAQfckJWwZoDiq01TfVdtkePUH70vizc	2026-08-17 20:10:47.338651+00	f	2026-08-16 20:10:47.338761+00
125	günter.weber46@example.com	sMoUzF1GyNl5mZLJmrMy-AvdJNLVGBWlb15kLNJH2Wo	2026-08-17 20:10:47.341767+00	f	2026-08-16 20:10:47.341899+00
126	stefan.schneider51@example.com	S38etALsVvlXUVQrMjwLmyyJD5kwwOAsDTK5aWV39fc	2026-08-17 20:10:47.34784+00	f	2026-08-16 20:10:47.347982+00
127	wolfgang.bauer15@example.com	yzDmKgB36HTWmqOPK34FNS37wL1o4O4Zk-8pxg7cScg	2026-08-17 20:10:47.350812+00	f	2026-08-16 20:10:47.350922+00
128	nicole.koch93@example.com	xvKsm0OV3NdevF8oDAQ7CwCLC-qDWzvoUSlIu6mixKo	2026-08-17 20:10:47.353664+00	f	2026-08-16 20:10:47.353774+00
129	karl.schäfer88@example.com	5QB0odYuoCPgaqHN1A2K_26eoT63gXKPJOZJZQYVRNM	2026-08-17 20:10:47.356774+00	f	2026-08-16 20:10:47.35688+00
130	helga.schulz69@example.com	M_fNxMiNOkIupaAhxgBNOqDRdT8LgOfC2aafF4WA660	2026-08-17 20:10:47.359633+00	f	2026-08-16 20:10:47.359752+00
131	helga.wagner35@example.com	FOdF31UjaMEvXkzrdXWzmKtLj-1Lg3wZPt-TD3ogGZk	2026-08-17 20:10:47.36274+00	f	2026-08-16 20:10:47.362848+00
132	monika.meyer34@example.com	WuF17mq28I0-krmIdzLvKZzlGuxdCUAHl-L8Y3eKdWU	2026-08-17 20:10:47.365828+00	f	2026-08-16 20:10:47.365965+00
133	helga.mustermann93@example.com	o-jmuejbtqNIlUtiW4sU0nGSGG8xVDny8X_kbfHCztE	2026-08-17 20:10:47.368847+00	f	2026-08-16 20:10:47.368955+00
134	karl.fischer37@example.com	cm0frOu9j_RyzqkXQbOZLUXQnpzeRls5MxA88WbCwwo	2026-08-17 20:10:47.371878+00	f	2026-08-16 20:10:47.371983+00
135	erika.schmidt61@example.com	Zu0aAtGIXvoGaifAwu7bIH2-pzwPiXi0H4Y4VoX_4Ec	2026-08-17 20:10:47.374924+00	f	2026-08-16 20:10:47.37504+00
136	karl.fischer40@example.com	3FSoWWIN_AY0cxZEO8zJ7gvoZLU-jD_TSloScmw1CeM	2026-08-17 20:10:47.377926+00	f	2026-08-16 20:10:47.378032+00
137	erika.richter33@example.com	FCqONnQQsqTThORAcuyZRHaBUBujlz4H35Htn1j1hYI	2026-08-17 20:10:47.380777+00	f	2026-08-16 20:10:47.380912+00
138	hans.meyer53@example.com	SirWSLEu-Pyr_bEuEQnZvIQWCY8PVpc-lL5BMe1Nam8	2026-08-17 20:10:47.38406+00	f	2026-08-16 20:10:47.384311+00
139	nicole.mustermann87@example.com	fZxKMJi6x10l8uNwSB5znWzTUnFm41cgXNJ3CwiXEF0	2026-08-17 20:10:47.386658+00	f	2026-08-16 20:10:47.386822+00
140	andreas.fischer67@example.com	0VYv1Niq6Tze7gZ2CcwRKezBykkHIc-m8xq8Y6TGBzI	2026-08-17 20:10:47.388808+00	f	2026-08-16 20:10:47.388938+00
141	christian.müller19@example.com	YvVsPtwXSIcliDxd6Sf7HjetWfXKzIDzKhSQTt2vUvM	2026-08-17 20:10:47.391684+00	f	2026-08-16 20:10:47.391832+00
142	karl.wagner70@example.com	ey0hBRU337QfIGIXZn7wHJfx5JAABI9xlTemjx22BHE	2026-08-17 20:10:47.394765+00	f	2026-08-16 20:10:47.394883+00
143	sabine.koch69@example.com	jmDjmejnFqIHyubDmkWGWIRoru3G1LFBYuLCqnyMAVU	2026-08-17 20:10:47.397847+00	f	2026-08-16 20:10:47.397984+00
144	sabine.müller24@example.com	oyKRqIZ6hFkV55zVkLxsUaSrEe0Zqq6EXzCrU4rnqEc	2026-08-17 20:10:47.400675+00	f	2026-08-16 20:10:47.400797+00
145	erika.schulz89@example.com	4LfIzC1zxZpD-k0BPJuaH9PE_2YNodiIAGE8lbnIwCs	2026-08-17 20:10:47.403792+00	f	2026-08-16 20:10:47.403904+00
146	karl.koch22@example.com	x-Z6PpO17iADt3hcsSeOOllSry0RwTNdc3RgAb8lk6E	2026-08-17 20:10:47.406627+00	f	2026-08-16 20:10:47.406732+00
147	hans.becker76@example.com	NFzflBvIvOqdWIC-wro__L1GMgikw2zFRqWFZemqGHo	2026-08-17 20:10:47.40854+00	f	2026-08-16 20:10:47.408644+00
148	andreas.schäfer77@example.com	bEtoaw99eeKUlTECagb1MzssfuLuLQUSbj8zjJCVpIA	2026-08-17 20:10:47.411839+00	f	2026-08-16 20:10:47.411944+00
149	max.becker99@example.com	iguQDE1wQSKjBcxONPo2RWfZ8oC8C8vfHx3hQctXkoM	2026-08-17 20:10:47.414925+00	f	2026-08-16 20:10:47.415066+00
150	ute.wagner46@example.com	f8AO2dNOT0ZCn_vJ0oEUxM6_jK3hbREXTPVbnEYXe-g	2026-08-17 20:10:47.417751+00	f	2026-08-16 20:10:47.417905+00
151	karl.mustermann11@example.com	yFio7tMDmZUJaLPYx-fb2eBgq4Y5r9GDU3gG8AHiHlM	2026-08-17 20:10:47.420827+00	f	2026-08-16 20:10:47.420954+00
152	max.schäfer42@example.com	B8qTCcb8kUFomb4iksDkjCy00e06FYZqjPtx8LdG4QM	2026-08-17 20:10:47.423857+00	f	2026-08-16 20:10:47.423974+00
153	andreas.richter81@example.com	rqHswBy9GYaUMN56hxfV6a4Di6YaDYdBxzinVqfEb5g	2026-08-17 20:10:47.426686+00	f	2026-08-16 20:10:47.426791+00
154	andreas.hoffmann88@example.com	3vR5LUprJWZPmbOT-VPigkJ1cTNf0DKspKUJTA0fcNo	2026-08-17 20:10:47.429986+00	f	2026-08-16 20:10:47.430087+00
155	helga.becker76@example.com	JnbpTyanUdcSz0bFWkGPRLuEl3tOhJH4uKQvvHdCPFM	2026-08-17 20:10:47.432808+00	f	2026-08-16 20:10:47.432927+00
156	max.schäfer73@example.com	N-wbz_o4VQTQPSQoHdDcV0h99adEfFGNYds0J3--y5A	2026-08-17 20:10:47.43583+00	f	2026-08-16 20:10:47.435928+00
157	wolfgang.müller85@example.com	uHMVsNYI7E2sNlfMu5Zk1EmwE3_ucxfYCynDoii9Rr8	2026-08-17 20:10:47.438658+00	f	2026-08-16 20:10:47.438751+00
158	ingrid.richter49@example.com	cOml-6-Lln54VOffBv8iEsp_Wah58MAMMjGiGHG8-p0	2026-08-17 20:10:47.441784+00	f	2026-08-16 20:10:47.441893+00
159	andreas.schulz13@example.com	ROO6ptEtHKgBBOONYV7uvA8w2SQsMhxCRDg2F36mxxA	2026-08-17 20:10:47.444814+00	f	2026-08-16 20:10:47.44492+00
160	stefan.müller3@example.com	ZVwsDyVQXIFcft0eqmEPnQgYoLd_d3ccGnhY6107wgc	2026-08-17 20:10:47.447702+00	f	2026-08-16 20:10:47.447845+00
161	stefan.bauer1@example.com	_GRAC-fvrThgOUbN00ksBytN83LJmKaZalygi5rz3gE	2026-08-17 20:10:47.450775+00	f	2026-08-16 20:10:47.45088+00
162	max.schulz82@example.com	0pDGwoP3Z_iu8kipk6OKYv_mGXwRoIhAVFBUx1BX7U4	2026-08-17 20:10:47.453614+00	f	2026-08-16 20:10:47.453711+00
163	erika.fischer58@example.com	nOIMVsLODCZnS0M1lZzzOzdaS2eVU83fBcar-R7S2Rg	2026-08-17 20:10:47.456716+00	f	2026-08-16 20:10:47.456807+00
164	nicole.meyer1@example.com	a-RPcBbS9W0_Q-3lbkqDW83c3Jhor6ngHXwIL1wPFkE	2026-08-17 20:10:47.459788+00	f	2026-08-16 20:10:47.459894+00
165	erika.weber63@example.com	o21o6eV3nGtdOOL77IdnOYGy_KTEpzN_VCSQNZwTq5c	2026-08-17 20:10:47.46264+00	f	2026-08-16 20:10:47.462739+00
166	petra.richter27@example.com	tVgH1lYY5Ac2euzas9R0pbIoznElQfZUP8DgnRrMMn8	2026-08-17 20:10:47.464869+00	f	2026-08-16 20:10:47.464974+00
167	erika.richter77@example.com	4tkRvFA9aWFlXuIZJ7jrpdAXDHBguOJbri4eRF_o-2I	2026-08-17 20:10:47.467701+00	f	2026-08-16 20:10:47.467791+00
168	helga.schulz78@example.com	8fJJ79FK2MnlC4aGjG2NY6W2aK4VgwyhJ3SFDdlRjls	2026-08-17 20:10:47.47079+00	f	2026-08-16 20:10:47.470883+00
169	karl.richter6@example.com	YGpwCyfff33K4nKA9FBjvBjBPH7QIvdAiu-vBgUD6ds	2026-08-17 20:10:47.473623+00	f	2026-08-16 20:10:47.473711+00
170	ute.koch17@example.com	e8Fn-m72mKmvHx7OVJm7eMQoxoYSmc8bKp90BymbZKU	2026-08-17 20:10:47.475047+00	f	2026-08-16 20:10:47.475148+00
171	ingrid.schmidt83@example.com	tNjoG4OAyoIbu7NbWN-RC3guVUC9k1ofQDZt_QoIh-M	2026-08-17 20:10:47.477805+00	f	2026-08-16 20:10:47.477894+00
172	helga.schäfer44@example.com	rW_1JP4y7skc2iOPURmjTxw1Pjo5ywV3H4CiaMMkKxg	2026-08-17 20:10:47.480899+00	f	2026-08-16 20:10:47.481007+00
173	karl.wagner24@example.com	fCE04Mm9N8wFwIAttvI9oW5v7rxX06GD2WEfqUqMqDI	2026-08-17 20:10:47.483713+00	f	2026-08-16 20:10:47.483805+00
174	wolfgang.bauer79@example.com	OkXFQ1b6pZiZ6uTJ5tGZiaIPC6xlz0pcDLER6eTdUZo	2026-08-17 20:10:47.486782+00	f	2026-08-16 20:10:47.486872+00
175	monika.meyer83@example.com	0lmakA4UV5iy4QxvfCJw389NU3BPz9Y1WLdyTNMbuQM	2026-08-17 20:10:47.489822+00	f	2026-08-16 20:10:47.489914+00
176	hans.schmidt96@example.com	zffKDkSgR8qB2XFdmtB9pNUG3TkqEtJ2uSI-fa6DzZ0	2026-08-17 20:10:47.492861+00	f	2026-08-16 20:10:47.492962+00
177	nicole.wagner86@example.com	fXlv8HzroggFRkb47miN_e5OgUtlsFX7br5dpPUD88w	2026-08-17 20:10:47.49588+00	f	2026-08-16 20:10:47.495974+00
178	max.schneider14@example.com	7RzChqA4PNNGnHAwmLmeJtUcPCL9uyh1ulI8qwgpQT0	2026-08-17 20:10:47.49872+00	f	2026-08-16 20:10:47.498819+00
179	karl.fischer65@example.com	K1OmISF5Z4gBCxPmX2y9mIuYGTgmYtAupoQawF42Mfc	2026-08-17 20:10:47.501802+00	f	2026-08-16 20:10:47.501892+00
180	karl.schulz24@example.com	CaVZaMFjj5LIEUN-B5dyaZaJTZoYwt_Q8aHH-iaJsdc	2026-08-17 20:10:47.504631+00	f	2026-08-16 20:10:47.504718+00
181	andreas.schmidt54@example.com	qt0Gih6uT_fyHHnBCTuSSsXLKymDXh012g8ka2xKwG8	2026-08-17 20:10:47.50794+00	f	2026-08-16 20:10:47.508039+00
182	karl.schäfer89@example.com	5aM_K9h99Hnbeiqo5U55haiqGYsqtRgCpw_shfKsACU	2026-08-17 20:10:47.510735+00	f	2026-08-16 20:10:47.510823+00
183	monika.mustermann85@example.com	bctONprlzRk7DZEMFjiDZqz5BAwx7hEBYKgmkDra4JY	2026-08-17 20:10:47.513836+00	f	2026-08-16 20:10:47.513942+00
184	petra.richter40@example.com	ql6VBinXMvjxynv0Pu8udRHhZBYA-Z-ev87knllJP9Y	2026-08-17 20:10:47.516859+00	f	2026-08-16 20:10:47.516949+00
185	erika.becker72@example.com	nS7FjXjuC9xgJZ9mc5OvcUMP0PX26IIz6lgzks3lhrk	2026-08-17 20:10:47.519649+00	f	2026-08-16 20:10:47.519736+00
186	andreas.müller22@example.com	HyPS_Yz8X0i7p5-qArMu1zMOsFKo2JYGy3QqLIuXmFc	2026-08-17 20:10:47.521839+00	f	2026-08-16 20:10:47.521925+00
187	günter.bauer22@example.com	dVsT6SoyHI-EFyXwYLbjUSBjmGDYaelhKTN5XbiJvP8	2026-08-17 20:10:47.524877+00	f	2026-08-16 20:10:47.524976+00
188	andreas.bauer34@example.com	FVf8c2fdRfNzK8y4l0mijVAonMpo9c1cQ53LXszobCk	2026-08-17 20:10:47.527892+00	f	2026-08-16 20:10:47.528051+00
191	günter.koch16@example.com	aPY9VCxzauZCzCPPAuXhBCu3-7n_tcM7KfsnlpEwISM	2026-08-17 20:12:25.649257+00	f	2026-08-16 20:12:25.649369+00
192	petra.koch8@example.com	QaPDDnUGFQBcg5IPx_MJcHzi4XJPysPsYd8oIyVOj24	2026-08-17 20:12:25.652311+00	f	2026-08-16 20:12:25.652418+00
193	monika.schulz58@example.com	M5K0ot_Afzbm1rd7iewc85aWSQwQ6GDOnP4c5QrWbQg	2026-08-17 20:12:25.655165+00	f	2026-08-16 20:12:25.655271+00
194	max.hoffmann67@example.com	ABSMMrHC-vARCg4KipY95yXjkTPzBuGEI_b_36l3zZc	2026-08-17 20:12:25.658265+00	f	2026-08-16 20:12:25.658413+00
195	ingrid.bauer1@example.com	A45DoIauuJSASnRJ1Rg7kiERn6tB6nKjafkHqWAOYVQ	2026-08-17 20:12:25.661114+00	f	2026-08-16 20:12:25.661228+00
196	ute.schulz91@example.com	OH8wHW6VQuOkB0ISSmXe1Xsx_WSLdulpfl4EGhRVZt0	2026-08-17 20:12:25.663288+00	f	2026-08-16 20:12:25.663389+00
198	wolfgang.schneider18@example.com	0CQwRIAVvrDj2tT1Ya5Hhl2h57tuY-xSKR7j70euSu4	2026-08-17 20:12:25.669328+00	f	2026-08-16 20:12:25.669426+00
199	andreas.meyer86@example.com	XhF7oRDF50m2nJryrIbelL2DFS7DtnNZYD1uikplar4	2026-08-17 20:12:25.672211+00	f	2026-08-16 20:12:25.672354+00
200	petra.weber99@example.com	_tIssVFUUtXztCrpviNtFMo1txW13K-xcdeJvoM2YjE	2026-08-17 20:12:25.675277+00	f	2026-08-16 20:12:25.675395+00
201	wolfgang.schäfer62@example.com	Su5yVttZrhBB6mpMb_7Pu8WCfIy6C0FAc65VxPjlFWk	2026-08-17 20:12:25.678168+00	f	2026-08-16 20:12:25.678329+00
202	hans.schulz54@example.com	2jwvmysk8AlAjNG1QMYbKX-e01GlJUvHhy8tVaHu_J8	2026-08-17 20:12:25.681246+00	f	2026-08-16 20:12:25.681369+00
203	ingrid.hoffmann1@example.com	0XdGIKRXAyf4E4wpxxRuhgJKJuWOAvmp1E8b_yqhcMo	2026-08-17 20:12:25.684484+00	f	2026-08-16 20:12:25.684597+00
204	sabine.schneider62@example.com	e0l0lCA3HNtaiGwyy8H6SuwR5UpQrCY4EOLFb4McOLQ	2026-08-17 20:12:25.687299+00	f	2026-08-16 20:12:25.687398+00
205	ute.schäfer95@example.com	DJZURbO8TdqlhJeYIsmFJ9rsYwLUShEDRD-3vb8fHXM	2026-08-17 20:12:25.690336+00	f	2026-08-16 20:12:25.69044+00
206	petra.richter20@example.com	dsR6KvxAKa82oTLhYbbPD6JboIIFOUU_gpZx4yWvbvo	2026-08-17 20:12:25.693161+00	f	2026-08-16 20:12:25.693338+00
207	max.mustermann90@example.com	DHjTl4m1zweuusZCfG4RWPnxGoyrHDRJuGRLpydQacc	2026-08-17 20:12:25.696518+00	f	2026-08-16 20:12:25.696678+00
208	karl.meyer13@example.com	3ijTwGhqDmpdsdX9W8mF7U1_M5E_vYCd0tXn3Twd9PM	2026-08-17 20:12:25.699096+00	f	2026-08-16 20:12:25.699234+00
209	karl.bauer75@example.com	aV8NMU9JMG7Xh2I66WbH__w1MSo0EBJfrfHWynfsCSA	2026-08-17 20:12:25.70221+00	f	2026-08-16 20:12:25.702332+00
210	max.fischer7@example.com	oH9t2ukrMeeXCwHGPxqClXCwcGI3_SwKrWBeQG0Q9TY	2026-08-17 20:12:25.705252+00	f	2026-08-16 20:12:25.705355+00
211	karl.meyer57@example.com	Yh-BuqEl4J4pxWGNx9pyZTnvYObxytOFLg5BbVRjdOI	2026-08-17 20:12:25.708142+00	f	2026-08-16 20:12:25.708287+00
212	hans.müller8@example.com	tpUlP7Qb1zXxbNVaB8e5riOHu7LI2IzfobNXCQq2cM8	2026-08-17 20:12:25.711239+00	f	2026-08-16 20:12:25.711348+00
213	max.richter31@example.com	OlSqDG73qiJK6dcsQS2BShZ__DqbyMb8OhAAYZLP-40	2026-08-17 20:12:25.714092+00	f	2026-08-16 20:12:25.714206+00
214	günter.schulz64@example.com	PzwNN2CHx_XpBchkFSN9_ZacATDjC07SG7Nd9TJQ4y4	2026-08-17 20:12:25.7172+00	f	2026-08-16 20:12:25.717298+00
215	andreas.schneider39@example.com	A9Ti66tItzcQj9e7CDpNmujQ11KGzKmwhN-jR_5VMGs	2026-08-17 20:12:25.72025+00	f	2026-08-16 20:12:25.720353+00
216	karl.weber69@example.com	BmiOJwt1sGLnSN6TKxCtZN3kqs-4FybeV3BDwNH7Jtw	2026-08-17 20:12:25.723111+00	f	2026-08-16 20:12:25.723205+00
217	andreas.weber27@example.com	Hj7rWiJJ5W00_bVS3mdymG2Y-HgCJ-5RRo_TwsdJ6C8	2026-08-17 20:12:25.726426+00	f	2026-08-16 20:12:25.726527+00
218	erika.wagner30@example.com	jXWc_vTD6ARpaQA6pgbdAcdXNVyXb3nfqK2wca7P61w	2026-08-17 20:12:25.729238+00	f	2026-08-16 20:12:25.729329+00
219	günter.weber46@example.com	KmNaeTki_9VntDabpNpKVtwBx_0zD1Ij2hwgHk4VG_4	2026-08-17 20:12:25.732319+00	f	2026-08-16 20:12:25.73242+00
220	stefan.schneider51@example.com	f8vQ9Eq7uBusY6XurPBjsIAVUd8YvMmRhfI1VHKzr6g	2026-08-17 20:12:25.73514+00	f	2026-08-16 20:12:25.735235+00
221	wolfgang.bauer15@example.com	SINuM5U7ck6a2bxgS8ce3xBmwkDzCVCp6KroPVS9AJs	2026-08-17 20:12:25.738245+00	f	2026-08-16 20:12:25.738335+00
222	nicole.koch93@example.com	Z-qLMTVcp_gS4rWpRGynBrS-WDdLbACGh1VchIU8Pto	2026-08-17 20:12:25.741286+00	f	2026-08-16 20:12:25.741387+00
223	karl.schäfer88@example.com	GwDSdSuRrGf9g9hyo3z_ChunjVJ2mM-7ceAhqlDvbqo	2026-08-17 20:12:25.744328+00	f	2026-08-16 20:12:25.744427+00
224	helga.schulz69@example.com	d4A_1_hbvceZsFaxDesTeWzggSqYuouNT2qdX23RKTI	2026-08-17 20:12:25.747345+00	f	2026-08-16 20:12:25.747443+00
225	helga.wagner35@example.com	MN67s7JLpNzvteOi_4GhR3bK2ZQz0A0tnGTZ8rI6fDo	2026-08-17 20:12:25.750171+00	f	2026-08-16 20:12:25.750263+00
226	monika.meyer34@example.com	NG-WheN_GzfZgGPySSTcHwcmyE3TtbTy1V0D3yKI0fE	2026-08-17 20:12:25.753265+00	f	2026-08-16 20:12:25.753355+00
227	helga.mustermann93@example.com	VSkyqp9qoBj41LjQovT5YpkF61sxbnzDeMhCXkg93PA	2026-08-17 20:12:25.756107+00	f	2026-08-16 20:12:25.756198+00
228	karl.fischer37@example.com	cdkPQfPvggylAlI9LbFo2sRS_ALX3hKdb5cusqxbBb0	2026-08-17 20:12:25.759258+00	f	2026-08-16 20:12:25.759394+00
229	erika.schmidt61@example.com	L4vpEiLlItP-iyT36cj2sIdMggU5XCSwVCyyeCjCT_I	2026-08-17 20:12:25.76229+00	f	2026-08-16 20:12:25.762403+00
230	karl.fischer40@example.com	1Tr5mQMWZGCAPb_F4I6Frc62TfA0FyqWpYMltG38Y34	2026-08-17 20:12:25.765109+00	f	2026-08-16 20:12:25.765218+00
231	erika.richter33@example.com	vjBAwlQbH_ruIROjxXltENgN6OGwSLhJqjkMHdIrxzo	2026-08-17 20:12:25.76822+00	f	2026-08-16 20:12:25.768402+00
232	hans.meyer53@example.com	My1SdhNGS5uvDq9LzAvpLOXza-jPqowOxPC8uwlpWEY	2026-08-17 20:12:25.771081+00	f	2026-08-16 20:12:25.771179+00
233	nicole.mustermann87@example.com	DIAJgOM0gehPRgz4QSFcRjB4t_WzcPsKjnLlk8QaVGA	2026-08-17 20:12:25.774201+00	f	2026-08-16 20:12:25.774306+00
234	andreas.fischer67@example.com	L94i-j7hT4bT0rjCZuZqOEut7TKmfrcgItEjMYuEHBU	2026-08-17 20:12:25.77725+00	f	2026-08-16 20:12:25.777341+00
235	christian.müller19@example.com	L-eYrIi5j0J-y6ylUkgPT-p7ec294o1AIDfhqJjmHlE	2026-08-17 20:12:25.780113+00	f	2026-08-16 20:12:25.780225+00
236	karl.wagner70@example.com	EE2B_VRJzYvYl-54qjJkbX7q5NPDDQMNHzH3Plcindg	2026-08-17 20:12:25.783418+00	f	2026-08-16 20:12:25.783511+00
237	sabine.koch69@example.com	0ib2lDxNAXhgV2Ox6HPm0GQpygamoTIqUzkU6Bu4cME	2026-08-17 20:12:25.786242+00	f	2026-08-16 20:12:25.786337+00
238	sabine.müller24@example.com	u7Di5drGG2dSGU_bdD1n4d2wLu4s4ggCIt-Vdr803Kk	2026-08-17 20:12:25.789317+00	f	2026-08-16 20:12:25.789418+00
239	erika.schulz89@example.com	yikOfXBP4R0mwBUzROV-_pLAQyqXn2YmIBl-oflvbNk	2026-08-17 20:12:25.792141+00	f	2026-08-16 20:12:25.792235+00
240	karl.koch22@example.com	MsFL9wEjAjvwDsAVPSW82-JUiCEHXxmuLDZcc1uAe34	2026-08-17 20:12:25.795243+00	f	2026-08-16 20:12:25.795333+00
241	hans.becker76@example.com	8-B3g4RDkyYiVHMJaBSoK0KefAJuQccacQ5qQBlmVvo	2026-08-17 20:12:25.798509+00	f	2026-08-16 20:12:25.798643+00
242	andreas.schäfer77@example.com	zISU2_IParkvH_ZikoTkTQE5q6bgl0RIBY0x3E38RAc	2026-08-17 20:12:25.801294+00	f	2026-08-16 20:12:25.801394+00
243	max.becker99@example.com	kCqjwhlWfzUBgD1OCcPxqP9LCxfttNcxfYNa2KKoVIo	2026-08-17 20:12:25.804315+00	f	2026-08-16 20:12:25.804407+00
244	ute.wagner46@example.com	GJ5ZU-XuTgIuTVUsZiE56DYwMEQFdCawfInpdIjI70k	2026-08-17 20:12:25.80719+00	f	2026-08-16 20:12:25.807329+00
245	karl.mustermann11@example.com	aqWU5v2VPiML0gL27IXe7reTiPUXk4xrX82TH0i_1Y8	2026-08-17 20:12:25.810246+00	f	2026-08-16 20:12:25.810361+00
246	max.schäfer42@example.com	pHIzDWhhNTM6V3VYjofYznskuBUZQ8nPWPfxmZ2cRLU	2026-08-17 20:12:25.813083+00	f	2026-08-16 20:12:25.813177+00
247	andreas.richter81@example.com	CDwkpvxygx0-PO_V2Csn6WCQpff-GiUnEYNVRnRTCk8	2026-08-17 20:12:25.815245+00	f	2026-08-16 20:12:25.815337+00
248	andreas.hoffmann88@example.com	hOM91Iyi7hNodTKN9-3uq88N_oZh0Aj9TJJEjXV1QCw	2026-08-17 20:12:25.818089+00	f	2026-08-16 20:12:25.818179+00
197	hans.hoffmann39@example.com	EP7Tmoc4Q4K_hEkYv4qwW6ydvSeGCWD8bsaq0vxemaI	2026-08-17 20:12:25.66629+00	t	2026-08-16 20:12:25.666385+00
249	helga.becker76@example.com	iV7PrCkjycPcZH2LdTv13aeO7GOy4PM8bpGxJvLl7IM	2026-08-17 20:12:25.820254+00	f	2026-08-16 20:12:25.820344+00
250	max.schäfer73@example.com	10UCosDfSodOTVwaxlk_uaHb3dGpAOhhPC4ztF6d9ug	2026-08-17 20:12:25.826231+00	f	2026-08-16 20:12:25.82639+00
252	ingrid.richter49@example.com	Ruzz7HqpJrOgvlIUKT74_eMeCoRDSnS5lnEHi9gp3y0	2026-08-17 20:12:25.832353+00	f	2026-08-16 20:12:25.8325+00
253	andreas.schulz13@example.com	FdIL8-b_rN5-z3i1D9aA8j03bJJPMn6_YtGu0f8b22s	2026-08-17 20:12:25.835381+00	f	2026-08-16 20:12:25.835526+00
254	stefan.müller3@example.com	nP_7xwRrGw791EuSkZlRmzpiZcOHHRzbLrS-flkXffk	2026-08-17 20:12:25.838207+00	f	2026-08-16 20:12:25.838375+00
255	stefan.bauer1@example.com	rTZu0jaHa_Lcda9ZjrWYAlYKAqc65UoTuvOK0R0d6ys	2026-08-17 20:12:25.841308+00	f	2026-08-16 20:12:25.841409+00
256	max.schulz82@example.com	TYoiEVzydB8g86J2_hlc_HRlkVEFNNs3HSrpIDfa_gE	2026-08-17 20:12:25.844133+00	f	2026-08-16 20:12:25.844239+00
257	erika.fischer58@example.com	W5DYts9y0xRC_lOGjhtmeHbpf4FYMSfXm7ntShtMc18	2026-08-17 20:12:25.847229+00	f	2026-08-16 20:12:25.84732+00
258	nicole.meyer1@example.com	eCIJ4-F4j6ovJqoSkJEcWscNOSMlhMDiwB2CbkqHLS8	2026-08-17 20:12:25.850288+00	f	2026-08-16 20:12:25.85044+00
259	erika.weber63@example.com	BSIoHkfnouaUaUsPuHGy7Bea5GE60dGishXAgSNy3I0	2026-08-17 20:12:25.853346+00	f	2026-08-16 20:12:25.853473+00
260	petra.richter27@example.com	EQoYVoWWFDvmxD2WxOGKy9UNiQGFHbnexESx7Cz6lQs	2026-08-17 20:12:25.856387+00	f	2026-08-16 20:12:25.856525+00
261	erika.richter77@example.com	TWYZk1KAhtcpgossKaDMUuAruruGDzGPGLMcM1-IzvE	2026-08-17 20:12:25.859111+00	f	2026-08-16 20:12:25.859272+00
262	helga.schulz78@example.com	BQaICleIs4WUE9FXzHHIJ12KVtTyMj7wMCux5ZR731o	2026-08-17 20:12:25.862211+00	f	2026-08-16 20:12:25.862326+00
263	karl.richter6@example.com	hb109akqG4ZcnHvD2YjSlC_pACIAB0HosABaqu5MXv8	2026-08-17 20:12:25.865262+00	f	2026-08-16 20:12:25.865377+00
264	ute.koch17@example.com	T_QfjlIrZJ6a--PEVDHYbUjJA-5wnjHYPF6ozn287Eg	2026-08-17 20:12:25.868308+00	f	2026-08-16 20:12:25.868406+00
265	ingrid.schmidt83@example.com	jOq2VmcK_G2p1H_iuTIcB5umXyEvfrQ7WCWh9qAtzMk	2026-08-17 20:12:25.87134+00	f	2026-08-16 20:12:25.871446+00
266	helga.schäfer44@example.com	5r4MvX-lBUu_X1bHQraydccLTL8gMbAJI6Z6qvLv_W4	2026-08-17 20:12:25.874361+00	f	2026-08-16 20:12:25.874467+00
267	karl.wagner24@example.com	ROeMnl44QE0svZLbttqLf8AlNQxo_nT2gGc6h9Lk1aI	2026-08-17 20:12:25.877375+00	f	2026-08-16 20:12:25.877476+00
268	wolfgang.bauer79@example.com	Me_2bHst0lJ9XB8pkeupvwmwxVsBZydfwY-QhsYIsYc	2026-08-17 20:12:25.880204+00	f	2026-08-16 20:12:25.880305+00
269	monika.meyer83@example.com	o1ynyYMTw3PPOhfIfF4G4hHgPSLIqPDMROdz3T9mWOw	2026-08-17 20:12:25.88329+00	f	2026-08-16 20:12:25.883389+00
270	hans.schmidt96@example.com	TcP0agHt0AOa9z_GtA-m_-qrWbEbTMnuKGq3le2xhio	2026-08-17 20:12:25.886094+00	f	2026-08-16 20:12:25.886221+00
271	nicole.wagner86@example.com	2BbaNLa1eawfQfR7bDrtT-EEHiSXP7_CZhSqcn3pWY8	2026-08-17 20:12:25.889233+00	f	2026-08-16 20:12:25.889378+00
272	max.schneider14@example.com	LEYVjCcv54qohPjWqkdxZeyhVLVVRmlvBaB6QqtqsqU	2026-08-17 20:12:25.892307+00	f	2026-08-16 20:12:25.892439+00
273	karl.fischer65@example.com	2jWuQDWbf4Oij_G6JLQxC3qRuA5sAVq3sDSsYnQblEg	2026-08-17 20:12:25.895162+00	f	2026-08-16 20:12:25.895304+00
274	karl.schulz24@example.com	vbOxPCioi5SHMuB6iXETmPdZ3ou1c_oaCv42Pc2OD7w	2026-08-17 20:12:25.898253+00	f	2026-08-16 20:12:25.898364+00
275	andreas.schmidt54@example.com	WPcTq5xk-4dRt_tBoW_JiiBSxWetwaXj2CXV-ybaEcM	2026-08-17 20:12:25.90113+00	f	2026-08-16 20:12:25.901261+00
276	karl.schäfer89@example.com	8Nhoi5rbiBT9JUMqYxM3KpE9S7gVxvaHQKy_cbcIWvw	2026-08-17 20:12:25.904254+00	f	2026-08-16 20:12:25.904386+00
277	monika.mustermann85@example.com	RLQ96ow0wt2aXJmgb_LLTZbd-B8osCRWv9nIWsin3pc	2026-08-17 20:12:25.907289+00	f	2026-08-16 20:12:25.907421+00
278	petra.richter40@example.com	eASe9TRFhGWR6uFwFIwRtky5wO7ts3CtTN9fBq-glcI	2026-08-17 20:12:25.910137+00	f	2026-08-16 20:12:25.910267+00
279	erika.becker72@example.com	3_Yy8KNi8YmTBioBDENOWGG7kphzwZR5UDjczumGOB0	2026-08-17 20:12:25.913251+00	f	2026-08-16 20:12:25.913362+00
280	andreas.müller22@example.com	xOScyPehzGEeQrALddplmoM5UeWsJyNZ44o2P0D8rd4	2026-08-17 20:12:25.9161+00	f	2026-08-16 20:12:25.916198+00
281	günter.bauer22@example.com	KznWdw__jPYaOPpxVteywIXsSBBNr-WJ85siqZkUAYc	2026-08-17 20:12:25.919216+00	f	2026-08-16 20:12:25.919395+00
251	wolfgang.müller85@example.com	5J3EZcXerTktvdm_d1M6B0Hu9mmEcuoNBZojfBrYC7Y	2026-08-17 20:12:25.829292+00	t	2026-08-16 20:12:25.829439+00
189	wachtmeister@web.de	ViMSH-_F28ncG6-6BFTlLqYTsEIeJV7HQVyAB0GDSK8	2026-08-17 20:12:25.640932+00	t	2026-08-16 20:12:25.641172+00
190	ute.wagner94@example.com	RX2kNfyb28qiFBJsuFjJciasX3BJqZjm5Mo3psRmyZk	2026-08-17 20:12:25.647109+00	t	2026-08-16 20:12:25.647238+00
282	andreas.bauer34@example.com	3Ko0Mxm7N2hKG55kHcJBNuOLVsEjE03TQKL-LrTtelQ	2026-08-17 20:12:25.922291+00	t	2026-08-16 20:12:25.922422+00
283	naboo61@gmail.com	LZaOotjLCPOnrjQ5qUOilj_sxW9y6KcB_Rg8H4JYuUg	2026-08-19 16:22:09.649865+00	t	2026-08-18 16:22:09.650733+00
284	andreas.bauer34@example.com	iJB3pc2GiKPBgdwhCAqBU9RnE87ozBGeu95X7HywM1o	2026-08-19 16:23:42.756146+00	f	2026-08-18 16:23:42.756585+00
285	naboo61@gmail.com	_4Tlky2CK4_fpY1vIiJSHmTdYjQOOrAQrLkDzsNfuBo	2026-08-19 16:25:16.704527+00	f	2026-08-18 16:25:16.704929+00
286	naboo61@gmail.com	wuUH-xoKx_KVge9X5qVhRmb5Qh-9IrTNh3-HnNyZScY	2026-08-19 16:33:16.494003+00	t	2026-08-18 16:33:16.496873+00
287	naboo61@gmail.com	_0N46ktwqXrpuI0cjYZRZn508Yz_C8Xe2IenL7I-YBs	2026-08-19 16:41:30.304033+00	f	2026-08-18 16:41:30.306699+00
288	naboo61@gmail.com	Jk7AfnQrDgpMvNS7CHKVRG3D8WwjlUWJqRJIoexwQzc	2026-08-19 16:48:08.923249+00	t	2026-08-18 16:48:08.925938+00
289	naboo61@gmail.com	GMvAVTIy6a8lM_ZE5VHlj8Lmgzw601WkfwgmfxTQ6lw	2026-08-19 17:24:25.782128+00	f	2026-08-18 17:24:25.784995+00
290	naboo61@gmail.com	8l8mQQTQQczeoOEVlkLI3FA8DMC45C6qVWyh58LBB0k	2026-08-19 20:31:20.718661+00	t	2026-08-18 20:31:20.721699+00
291	andreas.schneider39@example.com	hu5nYp1VQy2PwKLm-WXtAg64QvYHlKGcCjWPBoHCNys	2026-08-19 22:48:04.079393+00	f	2026-08-18 22:48:04.079986+00
292	naboo61@gmail.com	tqCN53DTnrdDK7kKm18jtJum1WjwyqzuEtwUIjZAVaQ	2026-08-19 22:48:04.086249+00	f	2026-08-18 22:48:04.086427+00
293	wolfgang.schäfer62@example.com	_JBR6ESXlFLuAydeJg6NkWggCN9jyduDuLAH8LmlRyQ	2026-08-19 22:48:04.089264+00	f	2026-08-18 22:48:04.08945+00
294	hans.schulz54@example.com	7U2Xl3wT7kpEfES3CzScI_ZL84dYOuQd-fy2f5SWs-I	2026-08-19 22:48:04.092224+00	f	2026-08-18 22:48:04.092353+00
295	ingrid.hoffmann1@example.com	QOgjWo97v9IjGE4VH6sWWvpkUs10k_mWaAGtD3A7pbc	2026-08-19 22:48:04.095394+00	f	2026-08-18 22:48:04.095584+00
296	sabine.schneider62@example.com	Z9auZ9ponHZUrqtI-Hln-E8WvDm3hpdgvac_RQ9gows	2026-08-19 22:48:04.098089+00	f	2026-08-18 22:48:04.098212+00
297	ute.schäfer95@example.com	DKWM19TSeWaDqyreqhcN1M75DghqqQD6DGyuxpp6HKI	2026-08-19 22:48:04.10114+00	f	2026-08-18 22:48:04.101269+00
298	petra.richter20@example.com	EuUJzSDJjoF6SZddfKpuoQ-9FcI1q_sdMd_TT1lnrQs	2026-08-19 22:48:04.104248+00	f	2026-08-18 22:48:04.104366+00
299	max.mustermann90@example.com	RESbtjjqH-27SXWzykgVcCqToBg8gWzjFf09Tviqdpc	2026-08-19 22:48:04.107218+00	f	2026-08-18 22:48:04.107339+00
300	karl.meyer13@example.com	ER44RfyuasD5G1m3ajR6YWlcYCvW73jKCp8utcGVNrs	2026-08-19 22:48:04.110229+00	f	2026-08-18 22:48:04.110338+00
301	karl.bauer75@example.com	2uNhXIRzCGSUxQCMrggElf8JX7L9Mq1Moo8XBUqwHa4	2026-08-19 22:48:04.113126+00	f	2026-08-18 22:48:04.11323+00
302	max.fischer7@example.com	-Gr4MR2LCzG2tzX2ayQIYHv-034_ZolwpN2gcUdChhY	2026-08-19 22:48:04.116189+00	f	2026-08-18 22:48:04.116291+00
303	karl.meyer57@example.com	jkdvtZm8TUqCbIve0reibzvMLVTzjD4X8gl6HtJ6a6w	2026-08-19 22:48:04.119233+00	f	2026-08-18 22:48:04.119331+00
304	hans.müller8@example.com	FydN7FEIh9XvO8t5qRT_NywmuNMRaxFdDh47xhf6wxo	2026-08-19 22:48:04.122477+00	f	2026-08-18 22:48:04.122572+00
305	günter.schulz64@example.com	2ade2td_H1pqUSZ_ust3p2RB_GVMp9fM8squRuH-DaM	2026-08-19 22:48:04.125211+00	f	2026-08-18 22:48:04.125305+00
306	karl.weber69@example.com	BfjRWxuyTAPvtBA9lMPeWCcnoCOy5ujiyV7wXw60KKY	2026-08-19 22:48:04.128086+00	f	2026-08-18 22:48:04.128184+00
307	andreas.weber27@example.com	k7mWrNsdDzzMzG4AqCQAnAeK88-WDlC4QHAmB2gx21Q	2026-08-19 22:48:04.131213+00	f	2026-08-18 22:48:04.131306+00
308	erika.wagner30@example.com	zjCmewSyhCakH-i2kNaXjEeWCQ-XdGbnfJrZTgvf5BI	2026-08-19 22:48:04.134028+00	f	2026-08-18 22:48:04.134119+00
309	günter.weber46@example.com	WJUarhiNXZRz2egc_DvGNmCVV8wY1u_9rOemUx4KTPU	2026-08-19 22:48:04.137147+00	f	2026-08-18 22:48:04.137246+00
310	stefan.schneider51@example.com	vP70Km0dzBww7o1gtG_cYV4wjJjfTcgEP8HNycOrIZA	2026-08-19 22:48:04.140204+00	f	2026-08-18 22:48:04.140303+00
312	nicole.koch93@example.com	x2AAF-7EAYd6FGN1Zdf6ao08_eYPPwXrQGBjHMeW5UU	2026-08-19 22:48:04.146214+00	f	2026-08-18 22:48:04.146304+00
314	helga.schulz69@example.com	O0nDqBNu9BjcRX70m5B5Z8thJTFIt-Ofgakw_rB9gcA	2026-08-19 22:48:04.151215+00	f	2026-08-18 22:48:04.151308+00
316	monika.meyer34@example.com	iuKCLhzfv7KUSZILLYCOEzag_Y2QHScUQ-bYfr6sv_E	2026-08-19 22:48:04.157078+00	f	2026-08-18 22:48:04.157174+00
318	karl.fischer37@example.com	MP2jgdSjAV27JaWuGxV44sg2RIWrIXoL_EMSZ7EAvvM	2026-08-19 22:48:04.163037+00	f	2026-08-18 22:48:04.16314+00
320	karl.fischer40@example.com	l4d9Z5_mFnXm1fbnIng9Q4jjVkbI6iKCSE5WfVBSzn4	2026-08-19 22:48:04.168099+00	f	2026-08-18 22:48:04.168199+00
322	hans.meyer53@example.com	Dsl-BSnBtzebxtkWpYAXPCI3LzHU9Q7tyo_hql81aWA	2026-08-19 22:48:04.174074+00	f	2026-08-18 22:48:04.174164+00
324	andreas.fischer67@example.com	LgzaVJ1xy3AlkbhN0InmH_VNFzJTmbYgQUSRDK0_t_8	2026-08-19 22:48:04.180228+00	f	2026-08-18 22:48:04.180336+00
326	karl.wagner70@example.com	KCtArz5jBM_pufk4n9pGhqF1FpfhVDVlOa1EVjguq_s	2026-08-19 22:48:04.186298+00	f	2026-08-18 22:48:04.186401+00
328	sabine.müller24@example.com	bssNXEt91smvqn3cQ1HOa4usFW4R4LbKQ3H0JKpKfHI	2026-08-19 22:48:04.19222+00	f	2026-08-18 22:48:04.192312+00
330	karl.koch22@example.com	sg-vGB7tuhIjpe8aNfCi6wkwJjC4aeSyBitQlncx01Q	2026-08-19 22:48:04.198163+00	f	2026-08-18 22:48:04.198253+00
332	andreas.schäfer77@example.com	Dm_GGwLoYzeu5MFuBs83faYbyVkkPnzoSKcynntBDw4	2026-08-19 22:48:04.204284+00	f	2026-08-18 22:48:04.204379+00
334	ute.wagner46@example.com	uT9kOzLLS5ZPfT66AqvXGFCh65E052w0gelnDxAn_xw	2026-08-19 22:48:04.210048+00	f	2026-08-18 22:48:04.210139+00
336	max.schäfer42@example.com	XlzfMpHYz4hAxHfdj4YnPMB7B_goE_R0DV5wpkhURsY	2026-08-19 22:48:04.216256+00	f	2026-08-18 22:48:04.216363+00
338	andreas.hoffmann88@example.com	XNa-o7MCGFS2sjQY1eMZIa1Vf1TA72izQzl4EWimj64	2026-08-19 22:48:04.222183+00	f	2026-08-18 22:48:04.222272+00
340	max.schäfer73@example.com	Fcs_KaX0TgMmSpcCqW1ljvRCv-3ItL94AioHuVX6WAQ	2026-08-19 22:48:04.228168+00	f	2026-08-18 22:48:04.228277+00
342	andreas.schulz13@example.com	W-Mfr3HlItuq7SRfV3fTaUi-bUAJnyQMD61pVksHPrw	2026-08-19 22:48:04.233201+00	f	2026-08-18 22:48:04.233305+00
344	stefan.bauer1@example.com	NQYxFp_roxk9-BIghJjBC-3brm5IH4z1BT4-RVGPIn8	2026-08-19 22:48:04.239165+00	f	2026-08-18 22:48:04.239266+00
346	erika.fischer58@example.com	C5JcoCII2H4zDTpJdUpPiv3dQtiRuoaCIR8sC27dgQY	2026-08-19 22:48:04.245078+00	f	2026-08-18 22:48:04.245185+00
348	erika.weber63@example.com	J5LNsGjM5SqZuX_TDyv1vYmQAS-sxexU9vMU33-jnwU	2026-08-19 22:48:04.251044+00	f	2026-08-18 22:48:04.251144+00
350	erika.richter77@example.com	pUITCKNE8w1C6SPzvkhgXmlhSHb4kGMv0ZRRGq9Q680	2026-08-19 22:48:04.257211+00	f	2026-08-18 22:48:04.257312+00
352	karl.richter6@example.com	uLXCgKpzoFw9C6gIpuYoSvcR2zmNUagonfpfEUnimmE	2026-08-19 22:48:04.263178+00	f	2026-08-18 22:48:04.263276+00
354	hans.hoffmann39@example.com	o88FyvzoF5_qzfg68wlffgSXakMw7kFQMW4etUC4NpI	2026-08-19 22:48:04.269149+00	f	2026-08-18 22:48:04.269247+00
356	günter.koch16@example.com	6JlByub2uMUzmSW8KwXXD35Z5AZrgUcN9XfPD7oieSY	2026-08-19 22:48:04.275251+00	f	2026-08-18 22:48:04.27534+00
358	monika.schulz58@example.com	-NZdaB_C_Jv72jqsVwSHR0MwNfc3o1BiGAJr5jQhPzw	2026-08-19 22:48:04.281122+00	f	2026-08-18 22:48:04.28122+00
360	max.richter31@example.com	9T3TBdiBcout7-VQEpyLfpnMzudlwtO9Nw6hnEVyh-k	2026-08-19 22:48:04.28706+00	f	2026-08-18 22:48:04.287159+00
362	ute.schulz91@example.com	rZAdkLv5gqNXZW8WlY1bUYj6wBEHfz8ifqSgT4gLR3E	2026-08-19 22:48:04.293267+00	f	2026-08-18 22:48:04.29342+00
364	andreas.meyer86@example.com	-NdsbxMPXjL4B2jEAE1fEnXRHB6kQxpz3IbCFGX_Aog	2026-08-19 22:48:04.299161+00	f	2026-08-18 22:48:04.299297+00
366	ingrid.schmidt83@example.com	IDLUsDU_6jJqM8zyWGzD-esbqKAl6n7YdSG8v9ats48	2026-08-19 22:48:04.305214+00	f	2026-08-18 22:48:04.305316+00
368	karl.wagner24@example.com	4ZKjC9MqsK1uXOGzm_6HDP-A1m9tUffP5rtqssen7bE	2026-08-19 22:48:04.311338+00	f	2026-08-18 22:48:04.311487+00
370	monika.meyer83@example.com	fNw2pVIxSwXTjUT-tRH87w7k0FpoOI01hTbdePkpnCI	2026-08-19 22:48:04.317145+00	f	2026-08-18 22:48:04.317249+00
372	nicole.wagner86@example.com	G9MR3KjOoz2HRzocs_FfQ9Vm5qgHFbUCKSFp8g9OOC4	2026-08-19 22:48:04.323076+00	f	2026-08-18 22:48:04.323183+00
374	karl.fischer65@example.com	4hmLAa2VG3mR5ER-98YGSn-FOY3gT62fMe3vYkel10k	2026-08-19 22:48:04.329141+00	f	2026-08-18 22:48:04.329244+00
376	andreas.schmidt54@example.com	aDzr3vf6EtufHXs5jz2dtFkK3AnKm0Vz6dQzEWDO-SM	2026-08-19 22:48:04.335211+00	f	2026-08-18 22:48:04.335313+00
378	monika.mustermann85@example.com	-mUHv7bNDi2R_icy11bF2F7yloiKxi5OmApvr7UdZ04	2026-08-19 22:48:04.341175+00	f	2026-08-18 22:48:04.341275+00
380	erika.becker72@example.com	PYVBpsy7N0WEVX4Ap6fVaHYNSGpaEVrHNzAhLHDoPL0	2026-08-19 22:48:04.347139+00	f	2026-08-18 22:48:04.347229+00
382	günter.bauer22@example.com	2tCO5fIehGg1zQhDUug8NCXFFCgLeBAyGCF0TkGRh8w	2026-08-19 22:48:04.353053+00	f	2026-08-18 22:48:04.353143+00
311	wolfgang.bauer15@example.com	L5ZUNtXX4237gTozMXR7DpEI3hrjs9900FbXuoqCflY	2026-08-19 22:48:04.143086+00	f	2026-08-18 22:48:04.143178+00
313	karl.schäfer88@example.com	kkU6GLi11_ewPyQ-XTvPoJGP8NYf6ZHOYnwUPcDR0vc	2026-08-19 22:48:04.148994+00	f	2026-08-18 22:48:04.149084+00
315	helga.wagner35@example.com	YuP21mCmkK3hZfnW8EQytgAYHYGt7fjxVF2N_NXHuCw	2026-08-19 22:48:04.154237+00	f	2026-08-18 22:48:04.154328+00
317	helga.mustermann93@example.com	8Sz0Af_9qcCXcpZT3zpaw-jVUjqsgFOS9PlfR31i77U	2026-08-19 22:48:04.160163+00	f	2026-08-18 22:48:04.160261+00
319	erika.schmidt61@example.com	KxxUVX26IkjP9UYR9tvscJox8MKByIj7D4O8uwlfq4o	2026-08-19 22:48:04.16525+00	f	2026-08-18 22:48:04.16534+00
321	erika.richter33@example.com	M2u6oYoLNRr0khDlrk9iO47xeDwHPLYYhcgkrTcVOkQ	2026-08-19 22:48:04.171201+00	f	2026-08-18 22:48:04.171308+00
323	nicole.mustermann87@example.com	HstZSJXOE-YZALCq3Okrhvl8H7bJL51QIss75W472hk	2026-08-19 22:48:04.177193+00	f	2026-08-18 22:48:04.177313+00
325	christian.müller19@example.com	-xaRaz2qXXnaejlTeuZ6vfOGBCKYpkjek4a8FCzXiBQ	2026-08-19 22:48:04.183272+00	f	2026-08-18 22:48:04.183377+00
327	sabine.koch69@example.com	sZsPJiMg26rD65b0HVfCBRCkO5AiXQfVmSpDGhr1fgU	2026-08-19 22:48:04.189122+00	f	2026-08-18 22:48:04.189214+00
329	erika.schulz89@example.com	OhTIuJfoUlYdPva6EdEPRXSY1KV9NbAYvgcrNF1l578	2026-08-19 22:48:04.195062+00	f	2026-08-18 22:48:04.195161+00
331	hans.becker76@example.com	tUm1GeFAVXjpIizrv8VZB9Ksm4wW0Xc0f65DwYqlkv0	2026-08-19 22:48:04.201221+00	f	2026-08-18 22:48:04.201321+00
333	max.becker99@example.com	zxOzzrYjGolWLpgm176Ct1_4WxDiMYeHlP9H9RP92EI	2026-08-19 22:48:04.207461+00	f	2026-08-18 22:48:04.207554+00
335	karl.mustermann11@example.com	v7STImd12IlXWHHtQ6ZpxhuYPFlBH1FVcv2QL8UU8m8	2026-08-19 22:48:04.213167+00	f	2026-08-18 22:48:04.213258+00
337	andreas.richter81@example.com	WvWTv__o3ptibmjXXQMY9AfP-QfnEFehqB3TOTJ8f7Y	2026-08-19 22:48:04.219101+00	f	2026-08-18 22:48:04.219195+00
339	helga.becker76@example.com	slYe3SpqPtU01uZ0e2mVSG1mFreZlQ0UDmNHncU5Pu4	2026-08-19 22:48:04.22504+00	f	2026-08-18 22:48:04.225137+00
341	ingrid.richter49@example.com	UcHyo3e408cW-2AtIiwpR4mvDr0E34vRqu1YNks_4wI	2026-08-19 22:48:04.231031+00	f	2026-08-18 22:48:04.231134+00
343	stefan.müller3@example.com	Q4sl3lA7Snmhy7HgYzOiJ_54rLGDYA2wQESzhEfnL8w	2026-08-19 22:48:04.236049+00	f	2026-08-18 22:48:04.23615+00
345	max.schulz82@example.com	i1Z7-t0GT2WuMEzYSaKL53-PNEDc2EA18KXfiO1LrBc	2026-08-19 22:48:04.242224+00	f	2026-08-18 22:48:04.242325+00
347	nicole.meyer1@example.com	MdnPFEjetmg_TSW19AQIWXdpX6bE-JWI3l1VTXCxr7M	2026-08-19 22:48:04.248187+00	f	2026-08-18 22:48:04.248277+00
349	petra.richter27@example.com	AnBIz3s0EGw2NMnpvXHmDyy4KeyaG-HisoobWCf4Xic	2026-08-19 22:48:04.254151+00	f	2026-08-18 22:48:04.254242+00
351	helga.schulz78@example.com	dHAFv4-RIrJ3QCqO3_Xul8XnkjcQ3bsD8cFcPaF6NM4	2026-08-19 22:48:04.260074+00	f	2026-08-18 22:48:04.260177+00
353	ute.koch17@example.com	2G1CSdtA7Jei-PRP99o7B9vAnITJL-vq0_x9YmO3xiE	2026-08-19 22:48:04.266032+00	f	2026-08-18 22:48:04.266123+00
355	ute.wagner94@web.de	tK-TtPL6sAlb5Ejbe9Bt5_VV49NkiHUguDbSHQVToFE	2026-08-19 22:48:04.272208+00	f	2026-08-18 22:48:04.27231+00
357	petra.koch8@example.com	nB74IH5sC00HZCyjR6X8yEOnrgPMMB26_2uFl3rrlS0	2026-08-19 22:48:04.27829+00	f	2026-08-18 22:48:04.278389+00
359	max.hoffmann67@example.com	hgpZIQx0MRkmGCvUA413zoIpNgP8iblwNNHQKRPAp_U	2026-08-19 22:48:04.284221+00	f	2026-08-18 22:48:04.284311+00
361	ingrid.bauer1@example.com	T9f7vwMw8vjnvDEr0tvDeVoHyVfzhkoCDd7dHkTNbhY	2026-08-19 22:48:04.290172+00	f	2026-08-18 22:48:04.290275+00
363	wolfgang.schneider18@example.com	X5WNtGNq-7cbyakir5xLtjH2m-FeIaj8UZaDYRphHRA	2026-08-19 22:48:04.296016+00	f	2026-08-18 22:48:04.296147+00
365	petra.weber99@example.com	95ekQVnc_AeM0PjDepgL3fGsQ2oU7s4xLtlHylWoHT0	2026-08-19 22:48:04.30239+00	f	2026-08-18 22:48:04.302519+00
367	helga.schäfer44@example.com	CzoyUSs8S2W64VCgqTMOAh_am3JgIJC2jBxnmhuW-Us	2026-08-19 22:48:04.30822+00	f	2026-08-18 22:48:04.308316+00
369	wolfgang.bauer79@example.com	NRYytBWaggfQvgfMyi_p6HXi0vp_-8MFuNuKPZt_S9g	2026-08-19 22:48:04.314324+00	f	2026-08-18 22:48:04.314452+00
371	hans.schmidt96@example.com	bnibSBiqNx5g30yXQOlgumhwLZL9gWkiDcUFyGF_NFQ	2026-08-19 22:48:04.32023+00	f	2026-08-18 22:48:04.320331+00
373	max.schneider14@example.com	C8LIo2hB-7PYjj5eHx7sblXYMr2g30qQbSfOSP3lZQw	2026-08-19 22:48:04.326375+00	f	2026-08-18 22:48:04.326471+00
375	karl.schulz24@example.com	BxvGW3dbo_oCKlMIgEK7UP2k3FK6tZluwTkD-AYVJzo	2026-08-19 22:48:04.332417+00	f	2026-08-18 22:48:04.332511+00
377	karl.schäfer89@example.com	rY2BLC8DKEdYRJBzw-lAxyPNssf729ELRVtoU0Z8xxQ	2026-08-19 22:48:04.338062+00	f	2026-08-18 22:48:04.338155+00
379	petra.richter40@example.com	5w4BfINrjYKhUbGn2huS28I0T-BZeJ9oMmqsqgG9Wx8	2026-08-19 22:48:04.344029+00	f	2026-08-18 22:48:04.344121+00
381	andreas.müller22@example.com	JJEVcNLE041xfSL2LInuiciuq09t3xqA2tMbZUPrDAo	2026-08-19 22:48:04.350203+00	f	2026-08-18 22:48:04.350301+00
383	andreas.bauer34@example.com	V0zewjqVE-GwRfcu2Hg3WElaKxDDxr92MLeZ3IHgjmk	2026-08-19 22:48:04.356168+00	f	2026-08-18 22:48:04.356258+00
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: alumni_admin
--

COPY public.persons (id, vorname, nachname, geburtsname, adresse, land, ort, plz, telefon_1, telefon_2, mobil, erreichbarkeit, email_1, email_2, admin, notizen, consent_storage, consent_sharing, consent_photos, is_deleted, is_blocked, created_at, updated_at, password_hash, username, gruppe_id) FROM stdin;
1025	Andreas	Schneider	Schneider	Musterweg 78	CH	Berlin	52401	+418413746	\N	+418413746	whatsapp	andreas.schneider39@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:49:48.857919+00	\N	andreas.schneider	1
3	Heinz-Walter	Kühn	\N	\N	\N	\N	\N	\N	\N	\N	unknown	\N	\N	f	\N	f	f	f	t	f	2026-08-16 20:57:55.681105+00	2026-08-16 21:32:53.943174+00	$2b$12$fx2i7QptnmKqKATYrosStuh9CKGHhJPfnDfii99mWT1HICJhs2Ywy	heinz.kuehn	1
1	Max	Datenschutzverantwortlicher	ll					+49 1234 5678		+49 173 2345 6789	email	naboo61@gmail.com		t	Ich bin der Admin	t	t	f	f	f	2026-08-16 16:13:52.627838+00	2026-08-18 21:10:39.67203+00	$2b$12$Lml5TM6gaD003OO5Ui987O5HOgZT6lILvDOeHjCi9pdyFnHxxyEMq	admin	2
1011	Wolfgang	Schäfer	Schäfer	Musterweg 35	D	Essen	19455	+496309759	\N	+496309759	landline	wolfgang.schäfer62@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	wolfgang.schäfer	3
1012	Hans	Schulz	Schulz	Musterweg 130	F	Dortmund	81920	+492625724	\N	+492625724	unknown	hans.schulz54@example.com	hans.schulz9@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	hans.schulz	1
1013	Ingrid	Hoffmann	Hoffmann	Bahnhofstraße 136	F	Dortmund	25289	+439845062	\N	+439845062	whatsapp	ingrid.hoffmann1@example.com	ingrid.hoffmann8@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	ingrid.hoffmann	3
1014	Sabine	Schneider	Schneider	Musterweg 54	D	München	45181	+493607711	\N	+493607711	email	sabine.schneider62@example.com	sabine.schneider25@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	sabine.schneider	1
1015	Ute	Schäfer	Schäfer	Feldstraße 125	CH	Stuttgart	20661	+412621027	\N	+412621027	whatsapp	ute.schäfer95@example.com	ute.schäfer65@example.com	f	Test-Notiz	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	ute.schäfer	3
1016	Petra	Richter	Richter	Ringstraße 115	CH	Düsseldorf	60399	+419939030	\N	+419939030	unknown	petra.richter20@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	petra.richter	1
1017	Max	Mustermann	Mustermann	Bahnhofstraße 42	A	Köln	85714	+439494024	\N	+439494024	email	max.mustermann90@example.com	max.mustermann89@example.com	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.mustermann	3
1018	Karl	Meyer	Meyer	Waldstraße 17	A	Essen	31264	+498390451	\N	+498390451	landline	karl.meyer13@example.com	karl.meyer47@example.com	f	Test-Notiz	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.meyer	1
1019	Karl	Bauer	Bauer	Hauptstraße 15	F	Berlin	14481	+434061121	\N	+434061121	landline	karl.bauer75@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.bauer	1
1020	Max	Fischer	Fischer	Hauptstraße 41	CH	Dortmund	82926	+433406267	\N	+433406267	email	max.fischer7@example.com	max.fischer71@example.com	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.fischer	1
1021	Karl	Meyer	Meyer	Waldstraße 116	F	Leipzig	87160	+494029096	\N	+494029096	unknown	karl.meyer57@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.meyer1	3
1022	Hans	Müller	Müller	Birkenweg 97	D	Essen	98458	+415053909	\N	+415053909	landline	hans.müller8@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	hans.müller	3
1024	Günter	Schulz	Schulz	Birkenweg 70	F	Berlin	15849	+495713908	\N	+495713908	whatsapp	günter.schulz64@example.com	\N	f	Test-Notiz	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	günter.schulz	2
1026	Karl	Weber	Weber	Musterweg 8	F	Frankfurt	25055	+415155149	\N	+415155149	landline	karl.weber69@example.com	karl.weber23@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.weber	1
1027	Andreas	Weber	Weber	Musterweg 47	A	Essen	67544	+432948683	\N	+432948683	email	andreas.weber27@example.com	\N	t	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.weber	1
1028	Erika	Wagner	Wagner	Musterweg 99	CH	Leipzig	13184	+415667278	\N	+415667278	landline	erika.wagner30@example.com	erika.wagner14@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	erika.wagner	2
1029	Günter	Weber	Weber	Birkenweg 91	F	Leipzig	84560	+432172710	\N	+432172710	landline	günter.weber46@example.com	günter.weber19@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	günter.weber	3
1030	Stefan	Schneider	Schneider	Gartenstraße 72	CH	Stuttgart	16284	+419086004	\N	+419086004	whatsapp	stefan.schneider51@example.com	stefan.schneider60@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	stefan.schneider	2
1031	Wolfgang	Bauer	Bauer	Gartenstraße 137	CH	Frankfurt	57138	+492203296	\N	+492203296	landline	wolfgang.bauer15@example.com	wolfgang.bauer63@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	wolfgang.bauer	2
1032	Nicole	Koch	Koch	Ringstraße 124	F	München	86631	+430385568	\N	+430385568	unknown	nicole.koch93@example.com	nicole.koch55@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	nicole.koch	3
1033	Karl	Schäfer	Schäfer	Hauptstraße 59	A	Hamburg	87157	+432005326	\N	+432005326	email	karl.schäfer88@example.com	karl.schäfer20@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.schäfer	2
1034	Helga	Schulz	Schulz	Gartenstraße 128	F	Düsseldorf	12366	+430626881	\N	+430626881	whatsapp	helga.schulz69@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	helga.schulz	3
1035	Helga	Wagner	Wagner	Waldstraße 122	D	Leipzig	99325	+410402136	\N	+410402136	landline	helga.wagner35@example.com	helga.wagner74@example.com	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	helga.wagner	2
1036	Monika	Meyer	Meyer	Ringstraße 71	A	Berlin	15878	+416922846	\N	+416922846	unknown	monika.meyer34@example.com	monika.meyer74@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	monika.meyer	1
1037	Helga	Mustermann	Mustermann	Hauptstraße 106	D	Köln	12956	+493856642	\N	+493856642	whatsapp	helga.mustermann93@example.com	helga.mustermann21@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	helga.mustermann	3
1038	Karl	Fischer	Fischer	Birkenweg 39	F	Essen	96685	+496942132	\N	+496942132	whatsapp	karl.fischer37@example.com	karl.fischer83@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.fischer	3
1039	Erika	Schmidt	Schmidt	Brückenstraße 21	D	Frankfurt	13440	+499833352	\N	+499833352	unknown	erika.schmidt61@example.com	erika.schmidt95@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	erika.schmidt	2
1040	Karl	Fischer	Fischer	Schulstraße 117	F	Essen	56085	+416116825	\N	+416116825	email	karl.fischer40@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.fischer1	2
1041	Erika	Richter	Richter	Brückenstraße 63	A	München	20528	+494514883	\N	+494514883	whatsapp	erika.richter33@example.com	\N	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	erika.richter	2
1042	Hans	Meyer	Meyer	Waldstraße 5	CH	Hamburg	67283	+495953518	\N	+495953518	whatsapp	hans.meyer53@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	hans.meyer	2
7	Hans-Dieter	Kühn	\N	\N	\N	\N	\N	\N	\N	\N	unknown	\N	\N	f	\N	f	f	f	t	f	2026-08-16 21:39:30.608138+00	2026-08-16 21:40:04.527043+00	$2b$12$BLgWvJvl7MmDVHNQrWdjFeiuQmn3Ie/28Agte53kfg0KdqEB5R7Hi	hans.kuehn	1
1043	Nicole	Mustermann	Mustermann	Hauptstraße 107	F	Hamburg	14895	+439627325	\N	+439627325	unknown	nicole.mustermann87@example.com	nicole.mustermann56@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	nicole.mustermann	3
1044	Andreas	Fischer	Fischer	Ringstraße 18	F	Stuttgart	72031	+491804847	\N	+491804847	whatsapp	andreas.fischer67@example.com	\N	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.fischer	1
1045	Christian	Müller	Müller	Schulstraße 95	D	Dortmund	93318	+437294211	\N	+437294211	email	christian.müller19@example.com	christian.müller94@example.com	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	christian.müller	2
1046	Karl	Wagner	Wagner	Gartenstraße 54	D	Berlin	82253	+431209260	\N	+431209260	unknown	karl.wagner70@example.com	\N	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.wagner	3
1047	Sabine	Koch	Koch	Gartenstraße 69	A	Köln	59374	+438758472	\N	+438758472	landline	sabine.koch69@example.com	sabine.koch78@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	sabine.koch	2
1048	Sabine	Müller	Müller	Feldstraße 91	F	Hamburg	49693	+415909085	\N	+415909085	email	sabine.müller24@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	sabine.müller	3
1049	Erika	Schulz	Schulz	Birkenweg 30	D	Frankfurt	68100	+431155351	\N	+431155351	email	erika.schulz89@example.com	\N	f	Test-Notiz	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	erika.schulz	1
1050	Karl	Koch	Koch	Feldstraße 113	F	Frankfurt	58313	+490970586	\N	+490970586	unknown	karl.koch22@example.com	karl.koch53@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.koch	1
1051	Hans	Becker	Becker	Feldstraße 1	F	Stuttgart	43658	+496059822	\N	+496059822	unknown	hans.becker76@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	hans.becker	3
1052	Andreas	Schäfer	Schäfer	Schulstraße 123	CH	Berlin	12659	+413810791	\N	+413810791	email	andreas.schäfer77@example.com	andreas.schäfer95@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.schäfer	2
1053	Max	Becker	Becker	Feldstraße 69	D	Düsseldorf	98214	+490845898	\N	+490845898	email	max.becker99@example.com	max.becker8@example.com	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.becker	2
1054	Ute	Wagner	Wagner	Feldstraße 136	CH	Dortmund	84169	+438721069	\N	+438721069	unknown	ute.wagner46@example.com	ute.wagner58@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	ute.wagner1	1
1055	Karl	Mustermann	Mustermann	Schulstraße 78	CH	Düsseldorf	18861	+418128431	\N	+418128431	landline	karl.mustermann11@example.com	karl.mustermann3@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.mustermann	3
1056	Max	Schäfer	Schäfer	Waldstraße 58	A	Dortmund	10441	+434445077	\N	+434445077	email	max.schäfer42@example.com	max.schäfer31@example.com	t	Test-Notiz	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.schäfer	1
1057	Andreas	Richter	Richter	Birkenweg 93	CH	Frankfurt	74891	+419240525	\N	+419240525	whatsapp	andreas.richter81@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.richter	3
1058	Andreas	Hoffmann	Hoffmann	Bahnhofstraße 43	D	Frankfurt	69938	+432823499	\N	+432823499	landline	andreas.hoffmann88@example.com	andreas.hoffmann86@example.com	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.hoffmann	3
1059	Helga	Becker	Becker	Feldstraße 101	A	Hamburg	68009	+499404052	\N	+499404052	unknown	helga.becker76@example.com	helga.becker99@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	helga.becker	3
1060	Max	Schäfer	Schäfer	Brückenstraße 97	D	Essen	69797	+430948951	\N	+430948951	email	max.schäfer73@example.com	max.schäfer36@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.schäfer1	1
1062	Ingrid	Richter	Richter	Birkenweg 96	D	München	83590	+495168490	\N	+495168490	deceased	ingrid.richter49@example.com	ingrid.richter26@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	ingrid.richter	3
1063	Andreas	Schulz	Schulz	Hauptstraße 64	A	Düsseldorf	81449	+417065909	\N	+417065909	unknown	andreas.schulz13@example.com	andreas.schulz19@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.schulz	3
1064	Stefan	Müller	Müller	Bahnhofstraße 67	A	Köln	65796	+415439082	\N	+415439082	landline	stefan.müller3@example.com	stefan.müller57@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	stefan.müller	2
1065	Stefan	Bauer	Bauer	Gartenstraße 53	D	Dortmund	35826	+435970952	\N	+435970952	landline	stefan.bauer1@example.com	\N	f	Test-Notiz	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	stefan.bauer	3
1066	Max	Schulz	Schulz	Hauptstraße 37	A	Düsseldorf	83593	+431370030	\N	+431370030	landline	max.schulz82@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.schulz	3
1067	Erika	Fischer	Fischer	Hauptstraße 76	F	Dortmund	76213	+490466269	\N	+490466269	landline	erika.fischer58@example.com	\N	f	Test-Notiz	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	erika.fischer	2
1068	Nicole	Meyer	Meyer	Bahnhofstraße 54	F	Dortmund	45403	+491284755	\N	+491284755	email	nicole.meyer1@example.com	nicole.meyer63@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	nicole.meyer	1
1069	Erika	Weber	Weber	Ringstraße 97	CH	Hamburg	11718	+431706588	\N	+431706588	unknown	erika.weber63@example.com	erika.weber27@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	erika.weber	2
1070	Petra	Richter	Richter	Bahnhofstraße 141	F	Dortmund	46656	+411242423	\N	+411242423	landline	petra.richter27@example.com	petra.richter48@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	petra.richter1	1
1071	Erika	Richter	Richter	Feldstraße 121	CH	Frankfurt	90942	+492991019	\N	+492991019	deceased	erika.richter77@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	erika.richter1	3
1072	Helga	Schulz	Schulz	Waldstraße 98	D	München	74389	+431356309	\N	+431356309	whatsapp	helga.schulz78@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	helga.schulz1	2
1073	Karl	Richter	Richter	Bahnhofstraße 12	CH	Frankfurt	59236	+414870662	\N	+414870662	email	karl.richter6@example.com	karl.richter1@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.richter	1
1074	Ute	Koch	Koch	Hauptstraße 105	D	Dortmund	14101	+410554469	\N	+410554469	email	ute.koch17@example.com	\N	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	ute.koch	1
1007	Hans	Hoffmann	Hoffmann	Schulstraße 149	A	Stuttgart	39072	+497822439	\N	+497822439	landline	hans.hoffmann39@example.com	\N	f	\N	t	t	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:27:00.802794+00	\N	hans.hoffmann	1
1000	Ute	Wagner	Wagner	Ringstraße 141	A	Frankfurt	22352	+414155241	\N	+414155241	whatsapp	ute.wagner94@web.de	\N	t	Test-Notiz	t	t	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:44:56.370736+00	\N	ute.wagner	3
1001	Günter	Koch	Koch	Birkenweg 63	D	München	72763	+437740520	\N	+437740520	landline	günter.koch16@example.com	\N	f	Test-Notiz	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	günter.koch	2
1002	Petra	Koch	Koch	Brückenstraße 91	CH	Frankfurt	74574	+414009070	\N	+414009070	whatsapp	petra.koch8@example.com	petra.koch1@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	petra.koch	1
1003	Monika	Schulz	Schulz	Brückenstraße 96	D	Stuttgart	35459	+419389640	\N	+419389640	email	monika.schulz58@example.com	monika.schulz42@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	monika.schulz	3
1004	Max	Hoffmann	Hoffmann	Gartenstraße 8	D	Düsseldorf	67534	+410329967	\N	+410329967	landline	max.hoffmann67@example.com	max.hoffmann36@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.hoffmann	1
1023	Max	Richter	Richter	Birkenweg 61	CH	Dortmund	66442	+410126829	\N	+410126829	email	max.richter31@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.richter	3
1005	Ingrid	Bauer	Bauer	Waldstraße 18	A	Essen	70158	+433900786	\N	+433900786	landline	ingrid.bauer1@example.com	ingrid.bauer48@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	ingrid.bauer	2
1006	Ute	Schulz	Schulz	Schulstraße 59	F	Hamburg	81349	+490717672	\N	+490717672	whatsapp	ute.schulz91@example.com	ute.schulz24@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	ute.schulz	1
1008	Wolfgang	Schneider	Schneider	Brückenstraße 34	D	Berlin	42159	+431655933	\N	+431655933	whatsapp	wolfgang.schneider18@example.com	wolfgang.schneider60@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	wolfgang.schneider	1
1009	Andreas	Meyer	Meyer	Birkenweg 145	A	Leipzig	71728	+432468099	\N	+432468099	unknown	andreas.meyer86@example.com	andreas.meyer72@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.meyer	1
1010	Petra	Weber	Weber	Hauptstraße 23	F	Berlin	60949	+493785057	\N	+493785057	email	petra.weber99@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	petra.weber	3
1061	Wolfgang	Müller	Müller	\N	\N	\N	\N	\N	\N	\N	email	\N	\N	f	\N	f	f	f	t	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:15:03.405986+00	\N	wolfgang.müller	3
1075	Ingrid	Schmidt	Schmidt	Schulstraße 11	CH	Berlin	24432	+415529762	\N	+415529762	whatsapp	ingrid.schmidt83@example.com	ingrid.schmidt41@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	ingrid.schmidt	1
1076	Helga	Schäfer	Schäfer	Musterweg 120	A	München	52109	+434354969	\N	+434354969	email	helga.schäfer44@example.com	helga.schäfer19@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	helga.schäfer	2
1077	Karl	Wagner	Wagner	Bahnhofstraße 139	A	Stuttgart	72538	+417238909	\N	+417238909	unknown	karl.wagner24@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.wagner1	3
1078	Wolfgang	Bauer	Bauer	Bahnhofstraße 146	F	Hamburg	65535	+490597220	\N	+490597220	unknown	wolfgang.bauer79@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	wolfgang.bauer1	3
1079	Monika	Meyer	Meyer	Hauptstraße 141	A	München	43781	+492944214	\N	+492944214	whatsapp	monika.meyer83@example.com	monika.meyer88@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	monika.meyer1	2
1080	Hans	Schmidt	Schmidt	Ringstraße 143	F	Köln	37637	+495883101	\N	+495883101	email	hans.schmidt96@example.com	hans.schmidt64@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	hans.schmidt	2
1081	Nicole	Wagner	Wagner	Ringstraße 62	F	Dortmund	32567	+419617752	\N	+419617752	email	nicole.wagner86@example.com	nicole.wagner55@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	nicole.wagner	3
1082	Max	Schneider	Schneider	Brückenstraße 81	F	Köln	39521	+490235135	\N	+490235135	unknown	max.schneider14@example.com	max.schneider28@example.com	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	max.schneider	1
1083	Karl	Fischer	Fischer	Schulstraße 126	A	Dortmund	94185	+493142789	\N	+493142789	landline	karl.fischer65@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.fischer2	3
1084	Karl	Schulz	Schulz	Waldstraße 32	D	Leipzig	56147	+494088772	\N	+494088772	landline	karl.schulz24@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.schulz	3
1085	Andreas	Schmidt	Schmidt	Brückenstraße 17	D	Berlin	14411	+431726167	\N	+431726167	landline	andreas.schmidt54@example.com	andreas.schmidt52@example.com	f	Test-Notiz	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.schmidt	3
1086	Karl	Schäfer	Schäfer	Feldstraße 4	CH	Leipzig	80640	+491557528	\N	+491557528	email	karl.schäfer89@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	karl.schäfer1	2
1087	Monika	Mustermann	Mustermann	Ringstraße 28	A	Köln	67309	+498533542	\N	+498533542	unknown	monika.mustermann85@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	monika.mustermann	1
1088	Petra	Richter	Richter	Hauptstraße 40	F	Düsseldorf	33154	+418272756	\N	+418272756	unknown	petra.richter40@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	petra.richter2	2
1089	Erika	Becker	Becker	Brückenstraße 16	CH	Berlin	87977	+415378513	\N	+415378513	unknown	erika.becker72@example.com	\N	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	erika.becker	2
1090	Andreas	Müller	Müller	Musterweg 63	A	Hamburg	82999	+418914145	\N	+418914145	landline	andreas.müller22@example.com	andreas.müller51@example.com	f	\N	f	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	andreas.müller	2
1091	Günter	Bauer	Bauer	Schulstraße 128	A	Berlin	32609	+410133202	\N	+410133202	unknown	günter.bauer22@example.com	\N	f	\N	t	f	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 20:05:14.854375+00	\N	günter.bauer	3
1092	Andreas	Bauer	Bauer	Musterweg 140	A	München	36238	+433429880		+433429880	deceased	andreas.bauer34@example.com		f	\N	t	t	f	f	f	2026-08-16 17:42:05.036631+00	2026-08-16 21:14:14.314283+00	\N	andreas.bauer	2
\.


--
-- Data for Name: privacy_policy; Type: TABLE DATA; Schema: public; Owner: alumni_admin
--

COPY public.privacy_policy (id, zweck, updated_at, title, verantwortlicher, alumni_website) FROM stdin;
1	Test	2026-08-19 14:40:35.384863+00	Test	Test.	https://cloud.frank-wachtmeister.de/s/ND7RY8PwYBqaN2x
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumni_admin
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 563, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumni_admin
--

SELECT pg_catalog.setval('public.groups_id_seq', 6, true);


--
-- Name: magic_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumni_admin
--

SELECT pg_catalog.setval('public.magic_tokens_id_seq', 383, true);


--
-- Name: persons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumni_admin
--

SELECT pg_catalog.setval('public.persons_id_seq', 7, true);


--
-- Name: privacy_policy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumni_admin
--

SELECT pg_catalog.setval('public.privacy_policy_id_seq', 1, true);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: groups groups_name_key; Type: CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_name_key UNIQUE (name);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: magic_tokens magic_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.magic_tokens
    ADD CONSTRAINT magic_tokens_pkey PRIMARY KEY (id);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (id);


--
-- Name: persons persons_username_key; Type: CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_username_key UNIQUE (username);


--
-- Name: privacy_policy privacy_policy_pkey; Type: CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.privacy_policy
    ADD CONSTRAINT privacy_policy_pkey PRIMARY KEY (id);


--
-- Name: ix_audit_logs_id; Type: INDEX; Schema: public; Owner: alumni_admin
--

CREATE INDEX ix_audit_logs_id ON public.audit_logs USING btree (id);


--
-- Name: ix_magic_tokens_email; Type: INDEX; Schema: public; Owner: alumni_admin
--

CREATE INDEX ix_magic_tokens_email ON public.magic_tokens USING btree (email);


--
-- Name: ix_magic_tokens_id; Type: INDEX; Schema: public; Owner: alumni_admin
--

CREATE INDEX ix_magic_tokens_id ON public.magic_tokens USING btree (id);


--
-- Name: ix_magic_tokens_token; Type: INDEX; Schema: public; Owner: alumni_admin
--

CREATE UNIQUE INDEX ix_magic_tokens_token ON public.magic_tokens USING btree (token);


--
-- Name: ix_persons_id; Type: INDEX; Schema: public; Owner: alumni_admin
--

CREATE INDEX ix_persons_id ON public.persons USING btree (id);


--
-- Name: ix_privacy_policy_id; Type: INDEX; Schema: public; Owner: alumni_admin
--

CREATE INDEX ix_privacy_policy_id ON public.privacy_policy USING btree (id);


--
-- Name: audit_logs audit_logs_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id);


--
-- Name: persons fk_gruppe; Type: FK CONSTRAINT; Schema: public; Owner: alumni_admin
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT fk_gruppe FOREIGN KEY (gruppe_id) REFERENCES public.groups(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: alumni_admin
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict TTAULhGJ04ZnpICzvQcliYBeS2DV1eaXfl8AgSLT1Jhoyu4oMdo1iJUtj5gm5kG

