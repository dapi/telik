--
-- PostgreSQL database dump
--

-- Dumped from database version 13.10 (Ubuntu 13.10-1.pgdg22.04+1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    project_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    url character varying NOT NULL,
    host character varying NOT NULL,
    key character varying NOT NULL,
    host_confirmed_at timestamp without time zone,
    owner_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    telegram_group_id bigint
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying,
    crypted_password character varying,
    salt character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    remember_me_token character varying,
    remember_me_token_expires_at timestamp(6) without time zone DEFAULT NULL::timestamp without time zone,
    last_login_at timestamp(6) without time zone DEFAULT NULL::timestamp without time zone,
    last_logout_at timestamp(6) without time zone DEFAULT NULL::timestamp without time zone,
    last_activity_at timestamp(6) without time zone DEFAULT NULL::timestamp without time zone,
    last_login_from_ip_address character varying,
    telegram_id bigint NOT NULL,
    telegram_data jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: visitors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.visitors (
    id bigint NOT NULL,
    cookie_id character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    project_id bigint NOT NULL,
    telegram_message_thread_id bigint,
    telegram_cached_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    username character varying,
    telegram_id bigint,
    first_visit_id bigint,
    last_visit_id bigint,
    topic_data jsonb
);


--
-- Name: visitors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.visitors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visitors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.visitors_id_seq OWNED BY public.visitors.id;


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.visits (
    id bigint NOT NULL,
    key character varying NOT NULL,
    visitor_id bigint NOT NULL,
    remote_ip inet NOT NULL,
    location jsonb NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    chat jsonb,
    referrer character varying,
    registered_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.visits_id_seq OWNED BY public.visits.id;


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: visitors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visitors ALTER COLUMN id SET DEFAULT nextval('public.visitors_id_seq'::regclass);


--
-- Name: visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visits ALTER COLUMN id SET DEFAULT nextval('public.visits_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2023-05-10 17:00:41.001549	2023-05-10 17:00:41.001549
\.


--
-- Data for Name: memberships; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.memberships (id, user_id, project_id, created_at, updated_at) FROM stdin;
1	1	1	2023-05-10 18:56:07.355425	2023-05-10 18:56:07.355425
2	1	2	2023-05-11 16:22:26.998723	2023-05-11 16:22:26.998723
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.projects (id, url, host, key, host_confirmed_at, owner_id, created_at, updated_at, telegram_group_id) FROM stdin;
1	http://localhost	localhost	zfiS2-6OW7GXcEnylkdri	\N	1	2023-05-10 18:56:07.340853	2023-05-10 18:56:07.340853	-1001854699958
2	https://nuichat.ru/	nuichat.ru	7OYpRzriF6cOx-wv4EvZW	\N	1	2023-05-11 16:22:26.985512	2023-05-11 16:22:26.985512	-1001854699958
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (version) FROM stdin;
20230503145329
20230503145330
20230503145331
20230507133646
20230507133844
20230507154444
20230507154540
20230507171021
20230508105457
20230508144559
20230509064852
20230509065033
20230511115100
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, crypted_password, salt, created_at, updated_at, remember_me_token, remember_me_token_expires_at, last_login_at, last_logout_at, last_activity_at, last_login_from_ip_address, telegram_id, telegram_data) FROM stdin;
1	\N	\N	\N	2023-05-10 18:56:07.319438	2023-05-10 18:56:07.319438	\N	\N	\N	\N	2023-05-11 16:50:00.32203	\N	943084337	{"id": "943084337", "username": "pismenny", "auth_date": "1683466550", "last_name": "Pismenny", "photo_url": "https://t.me/i/userpic/320/3CYhSyogI0OC2gV3vV5rziFJFXlsStR4yi692YM-rGU.jpg", "first_name": "Danil"}
\.


--
-- Data for Name: visitors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.visitors (id, cookie_id, created_at, updated_at, project_id, telegram_message_thread_id, telegram_cached_at, first_name, last_name, username, telegram_id, first_visit_id, last_visit_id, topic_data) FROM stdin;
1	qkW8AWZZDDJwHCee9Xo5w	2023-05-10 22:15:59.605694	2023-05-10 22:15:59.605694	1	\N	\N	\N	\N	\N	\N	1	1	\N
2	Y2NlsXq4ezEmo-NU9Cl9O	2023-05-10 22:29:09.242962	2023-05-10 22:29:09.242962	1	\N	\N	\N	\N	\N	\N	2	2	\N
3	G9_NN3bDl5j_BcFrram-3	2023-05-10 22:45:57.750602	2023-05-10 22:45:57.750602	1	\N	\N	\N	\N	\N	\N	3	3	\N
16	nde3mP8Dr9_r_yOFyrDwI	2023-05-11 16:20:44.18452	2023-05-11 16:20:44.18452	1	\N	\N	\N	\N	\N	\N	16	16	\N
4	4z6lxcUKvhOheFbSHTZYd	2023-05-11 04:30:47.786142	2023-05-11 16:36:39.283344	1	\N	\N	Danil	Pismenny	pismenny	943084337	4	15	\N
17	AmHkPCX2ePhfDnzqAJPOl	2023-05-11 16:22:44.304438	2023-05-11 16:57:36.063486	2	60	2023-05-11 16:57:36.062856	Danil	Pismenny	pismenny	943084337	17	18	{"name": "@ по имени из Domodedovo (Moscow Oblast/RU)", "icon_color": 7322096, "message_thread_id": 60}
\.


--
-- Data for Name: visits; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.visits (id, key, visitor_id, remote_ip, location, data, chat, referrer, registered_at, created_at, updated_at) FROM stdin;
1	dr-yMqQ0_Xl4_FcnpfRcc	1	95.108.213.102	{"data": {"ip": "95.108.213.102", "loc": "55.7522,37.6156", "org": "AS208722 Global DC Oy", "city": "Moscow", "postal": "101000", "readme": "https://ipinfo.io/missingauth", "region": "Moscow", "country": "RU", "hostname": "95-108-213-102.spider.yandex.com", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	\N	\N	2023-05-10 22:15:59.789299	2023-05-10 22:15:59.789299
2	t_L8MSDBaY19IUCYibKkF	2	213.180.203.114	{"data": {"ip": "213.180.203.114", "loc": "55.7522,37.6156", "org": "AS208722 Global DC Oy", "city": "Moscow", "postal": "101000", "readme": "https://ipinfo.io/missingauth", "region": "Moscow", "country": "RU", "hostname": "213-180-203-114.spider.yandex.com", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	\N	\N	2023-05-10 22:29:09.389019	2023-05-10 22:29:09.389019
3	EOIaQgZ3cQ1yzeVFwh3nP	3	213.180.203.32	{"data": {"ip": "213.180.203.32", "loc": "55.7522,37.6156", "org": "AS208722 Global DC Oy", "city": "Moscow", "postal": "101000", "readme": "https://ipinfo.io/missingauth", "region": "Moscow", "country": "RU", "hostname": "213-180-203-32.spider.yandex.com", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	\N	\N	2023-05-10 22:45:57.912573	2023-05-10 22:45:57.912573
4	TefoY9Ku_SZoHvfdsZQy2	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:30:47.928878	2023-05-11 04:30:47.928878
6	S_FgUwuXrLzrs0AS9PhpR	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:25.756099	2023-05-11 04:33:25.756099
7	XJ_XY4OMBllZuX7J_s5LC	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:26.180096	2023-05-11 04:33:26.180096
8	26u0v1wyffv3MOE2BIQVD	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:26.843049	2023-05-11 04:33:26.843049
9	wvkWWeBqgXK_YDWthVj3A	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:27.218013	2023-05-11 04:33:27.218013
10	pprI2eaUfGos3FK588ruc	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:29.696549	2023-05-11 04:33:29.696549
11	5nQPfwvf6XT9u8hCqgIHr	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:30.103104	2023-05-11 04:33:30.103104
12	NttswqlwHlYnwgWaz_owZ	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:30.628879	2023-05-11 04:33:30.628879
13	5cwB9b8GvAaYzvWvsA889	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:31.010144	2023-05-11 04:33:31.010144
14	1prK0KqXlyV4_xNqegEiG	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:31.678478	2023-05-11 04:33:31.678478
15	7AWYH6Q6ArwfirTZ8TuVt	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	\N	https://telikbot.ru/	\N	2023-05-11 04:33:31.986831	2023-05-11 04:33:31.986831
16	_c1RlQPSvqhfCYRs_Amdp	16	64.43.91.177	{"data": {"ip": "64.43.91.177", "loc": "51.5018,-0.1328", "org": "AS9009 M247 Europe SRL", "city": "London", "postal": "SW1A", "readme": "https://ipinfo.io/missingauth", "region": "England", "country": "GB", "timezone": "Europe/London"}, "cache_hit": null}	{}	\N	\N	\N	2023-05-11 16:20:44.383153	2023-05-11 16:20:44.383153
17	4cI9zfiVo0QfdWEGAOZ0Q	17	62.117.96.30	{"ip": "62.117.96.30", "loc": "55.4413,37.7537", "org": "AS48922 Domodedovo_IT_Services", "city": "Domodedovo", "postal": "140162", "readme": "https://ipinfo.io/missingauth", "region": "Moscow Oblast", "country": "RU", "timezone": "Europe/Moscow"}	{}	\N	https://nuichat.ru/	\N	2023-05-11 16:22:44.467056	2023-05-11 16:22:44.467056
5	Qfsxgkp5UHPR7fe6-sDPh	4	94.232.63.42	{"data": {"ip": "94.232.63.42", "loc": "56.1322,47.2519", "org": "AS48089 Infanet Ltd.", "city": "Cheboksary", "postal": "428000", "readme": "https://ipinfo.io/missingauth", "region": "Chuvashia", "country": "RU", "hostname": "slot042.pool01.dynmic-ppp.orionet.ru", "timezone": "Europe/Moscow"}, "cache_hit": null}	{}	{"id": 943084337, "type": "private", "username": "pismenny", "last_name": "Pismenny", "first_name": "Danil"}	https://telikbot.ru/	2023-05-11 16:36:39.291218	2023-05-11 04:30:49.892486	2023-05-11 16:36:39.292496
18	FQAh8x9m11tLBPRIRMVAB	17	62.117.96.30	{"ip": "62.117.96.30", "loc": "55.4413,37.7537", "org": "AS48922 Domodedovo_IT_Services", "city": "Domodedovo", "postal": "140162", "readme": "https://ipinfo.io/missingauth", "region": "Moscow Oblast", "country": "RU", "timezone": "Europe/Moscow"}	{}	{"id": 943084337, "type": "private", "username": "pismenny", "last_name": "Pismenny", "first_name": "Danil"}	https://nuichat.ru/	2023-05-11 16:57:35.828137	2023-05-11 16:50:00.298874	2023-05-11 16:57:35.828499
\.


--
-- Name: memberships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.memberships_id_seq', 2, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.projects_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: visitors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.visitors_id_seq', 18, true);


--
-- Name: visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.visits_id_seq', 18, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visitors visitors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visitors
    ADD CONSTRAINT visitors_pkey PRIMARY KEY (id);


--
-- Name: visits visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: index_memberships_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_project_id ON public.memberships USING btree (project_id);


--
-- Name: index_memberships_on_project_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_memberships_on_project_id_and_user_id ON public.memberships USING btree (project_id, user_id);


--
-- Name: index_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_user_id ON public.memberships USING btree (user_id);


--
-- Name: index_projects_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_projects_on_key ON public.projects USING btree (key);


--
-- Name: index_projects_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_owner_id ON public.projects USING btree (owner_id);


--
-- Name: index_projects_on_owner_id_and_host; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_projects_on_owner_id_and_host ON public.projects USING btree (owner_id, host);


--
-- Name: index_projects_on_url_and_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_projects_on_url_and_owner_id ON public.projects USING btree (url, owner_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_last_logout_at_and_last_activity_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_last_logout_at_and_last_activity_at ON public.users USING btree (last_logout_at, last_activity_at);


--
-- Name: index_users_on_remember_me_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_remember_me_token ON public.users USING btree (remember_me_token);


--
-- Name: index_users_on_telegram_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_telegram_id ON public.users USING btree (telegram_id);


--
-- Name: index_visitors_on_first_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_visitors_on_first_visit_id ON public.visitors USING btree (first_visit_id);


--
-- Name: index_visitors_on_last_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_visitors_on_last_visit_id ON public.visitors USING btree (last_visit_id);


--
-- Name: index_visitors_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_visitors_on_project_id ON public.visitors USING btree (project_id);


--
-- Name: index_visitors_on_project_id_and_cookie_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_visitors_on_project_id_and_cookie_id ON public.visitors USING btree (project_id, cookie_id);


--
-- Name: index_visits_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_visits_on_key ON public.visits USING btree (key);


--
-- Name: index_visits_on_visitor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_visits_on_visitor_id ON public.visits USING btree (visitor_id);


--
-- Name: projects fk_rails_219ef9bf7d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_rails_219ef9bf7d FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: memberships fk_rails_99326fb65d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_99326fb65d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: memberships fk_rails_9a720d61e2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_9a720d61e2 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: visits fk_rails_b156c396f4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT fk_rails_b156c396f4 FOREIGN KEY (visitor_id) REFERENCES public.visitors(id);


--
-- PostgreSQL database dump complete
--

