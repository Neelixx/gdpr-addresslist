--
-- PostgreSQL database dump
--

\restrict PgK0INEMG36GcqzhovDmULksXTPf9oXJRdMukmv68lgs7mLsjC772kVpJEVpHvY

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
564	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260819_150335.sql	172.21.0.2	2026-08-19 15:03:35.99169+00
565	1	UPDATE	password_hash	\N	Password changed	172.21.0.2	2026-08-19 15:04:06.905027+00
566	\N	BACKUP	all	\N	Database backup created: /app/backups/backup_20260819_150412.sql	172.21.0.2	2026-08-19 15:04:12.518147+00
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
1	Max	Datenschutzverantwortlicher	ll					+49 1234 5678		+49 173 2345 6789	email	naboo61@gmail.com		t	Ich bin der Admin	t	t	f	f	f	2026-08-16 16:13:52.627838+00	2026-08-19 15:04:06.905027+00	$2b$12$bBHdgm0Iy/q5AHS6rdIBTOSFn0kQJJ293Vwxz9rCpsXlYP5PMNEOu	admin	2
\.


--
-- Data for Name: privacy_policy; Type: TABLE DATA; Schema: public; Owner: alumni_admin
--

COPY public.privacy_policy (id, zweck, updated_at, title, verantwortlicher, alumni_website) FROM stdin;
1	Die Daten werden verwendet zur Organisation und Durchführung von Alumni-Veranstaltungen.	2026-08-19 15:11:01.872518+00	Test	Max Mustermann..	https://my-alumni.de
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alumni_admin
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 566, true);


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

\unrestrict PgK0INEMG36GcqzhovDmULksXTPf9oXJRdMukmv68lgs7mLsjC772kVpJEVpHvY

