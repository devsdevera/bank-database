--
-- PostgreSQL database dump
--

-- Dumped from database version 14.12
-- Dumped by pg_dump version 14.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: gradelevel; Type: TYPE; Schema: public; Owner: deveremma
--

CREATE TYPE public.gradelevel AS ENUM (
    'C',
    'C+',
    'B',
    'B+',
    'A',
    'A+'
);


ALTER TYPE public.gradelevel OWNER TO deveremma;

--
-- Name: securitylevel; Type: TYPE; Schema: public; Owner: deveremma
--

CREATE TYPE public.securitylevel AS ENUM (
    'weak',
    'good',
    'very good',
    'excellent'
);


ALTER TYPE public.securitylevel OWNER TO deveremma;

--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION public.plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';


ALTER FUNCTION public.plpgsql_call_handler() OWNER TO pgsql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accomplices; Type: TABLE; Schema: public; Owner: deveremma
--

CREATE TABLE public.accomplices (
    robberid integer NOT NULL,
    bankname character varying(50) NOT NULL,
    city character varying(50) NOT NULL,
    date date NOT NULL,
    share numeric(15,2) DEFAULT 0 NOT NULL,
    CONSTRAINT accomplices_share_check CHECK ((share >= (0)::numeric))
);


ALTER TABLE public.accomplices OWNER TO deveremma;

--
-- Name: accomplices_robberid_seq; Type: SEQUENCE; Schema: public; Owner: deveremma
--

CREATE SEQUENCE public.accomplices_robberid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accomplices_robberid_seq OWNER TO deveremma;

--
-- Name: accomplices_robberid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deveremma
--

ALTER SEQUENCE public.accomplices_robberid_seq OWNED BY public.accomplices.robberid;


--
-- Name: banks; Type: TABLE; Schema: public; Owner: deveremma
--

CREATE TABLE public.banks (
    bankname character varying(50) NOT NULL,
    city character varying(50) NOT NULL,
    noaccounts integer DEFAULT 0 NOT NULL,
    security public.securitylevel NOT NULL,
    CONSTRAINT banks_noaccounts_check CHECK ((noaccounts >= 0))
);


ALTER TABLE public.banks OWNER TO deveremma;

--
-- Name: hasaccounts; Type: TABLE; Schema: public; Owner: deveremma
--

CREATE TABLE public.hasaccounts (
    robberid integer NOT NULL,
    bankname character varying(50) NOT NULL,
    city character varying(50) NOT NULL
);


ALTER TABLE public.hasaccounts OWNER TO deveremma;

--
-- Name: hasaccounts_robberid_seq; Type: SEQUENCE; Schema: public; Owner: deveremma
--

CREATE SEQUENCE public.hasaccounts_robberid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hasaccounts_robberid_seq OWNER TO deveremma;

--
-- Name: hasaccounts_robberid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deveremma
--

ALTER SEQUENCE public.hasaccounts_robberid_seq OWNED BY public.hasaccounts.robberid;


--
-- Name: hasskills; Type: TABLE; Schema: public; Owner: deveremma
--

CREATE TABLE public.hasskills (
    robberid integer NOT NULL,
    skillid integer NOT NULL,
    preference integer DEFAULT 1 NOT NULL,
    grade public.gradelevel NOT NULL,
    CONSTRAINT hasskills_preference_check CHECK ((preference = ANY (ARRAY[1, 2, 3])))
);


ALTER TABLE public.hasskills OWNER TO deveremma;

--
-- Name: hasskills_robberid_seq; Type: SEQUENCE; Schema: public; Owner: deveremma
--

CREATE SEQUENCE public.hasskills_robberid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hasskills_robberid_seq OWNER TO deveremma;

--
-- Name: hasskills_robberid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deveremma
--

ALTER SEQUENCE public.hasskills_robberid_seq OWNED BY public.hasskills.robberid;


--
-- Name: hasskills_skillid_seq; Type: SEQUENCE; Schema: public; Owner: deveremma
--

CREATE SEQUENCE public.hasskills_skillid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hasskills_skillid_seq OWNER TO deveremma;

--
-- Name: hasskills_skillid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deveremma
--

ALTER SEQUENCE public.hasskills_skillid_seq OWNED BY public.hasskills.skillid;


--
-- Name: robberies; Type: TABLE; Schema: public; Owner: deveremma
--

CREATE TABLE public.robberies (
    bankname character varying(50) NOT NULL,
    city character varying(50) NOT NULL,
    date date NOT NULL,
    amount numeric(15,2) DEFAULT 0 NOT NULL,
    CONSTRAINT robberies_amount_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.robberies OWNER TO deveremma;

--
-- Name: maxrobberyamount; Type: VIEW; Schema: public; Owner: deveremma
--

CREATE VIEW public.maxrobberyamount AS
 SELECT max(robberies.amount) AS maxamount
   FROM public.robberies;


ALTER TABLE public.maxrobberyamount OWNER TO deveremma;

--
-- Name: maxrobberydetails; Type: VIEW; Schema: public; Owner: deveremma
--

CREATE VIEW public.maxrobberydetails AS
 SELECT r.bankname,
    r.city,
    r.date
   FROM (public.robberies r
     JOIN public.maxrobberyamount m ON ((m.maxamount = r.amount)));


ALTER TABLE public.maxrobberydetails OWNER TO deveremma;

--
-- Name: robbers; Type: TABLE; Schema: public; Owner: deveremma
--

CREATE TABLE public.robbers (
    robberid integer NOT NULL,
    nickname character varying(50) NOT NULL,
    age integer NOT NULL,
    noyears integer DEFAULT 0 NOT NULL,
    CONSTRAINT robbers_age_check CHECK ((age >= 0)),
    CONSTRAINT robbers_check CHECK (((noyears >= 0) AND (noyears <= age)))
);


ALTER TABLE public.robbers OWNER TO deveremma;

--
-- Name: maxrobberyrobbers; Type: VIEW; Schema: public; Owner: deveremma
--

CREATE VIEW public.maxrobberyrobbers AS
 SELECT r.robberid,
    r.nickname
   FROM ((public.accomplices a
     JOIN public.robbers r ON ((r.robberid = a.robberid)))
     JOIN public.maxrobberydetails b ON ((((b.bankname)::text = (a.bankname)::text) AND ((b.city)::text = (a.city)::text) AND (b.date = a.date))));


ALTER TABLE public.maxrobberyrobbers OWNER TO deveremma;

--
-- Name: plans; Type: TABLE; Schema: public; Owner: deveremma
--

CREATE TABLE public.plans (
    bankname character varying(50) NOT NULL,
    city character varying(50) NOT NULL,
    planneddate date NOT NULL,
    norobbers integer DEFAULT 1 NOT NULL,
    CONSTRAINT plans_norobbers_check CHECK ((norobbers > 0))
);


ALTER TABLE public.plans OWNER TO deveremma;

--
-- Name: robberiesinplanned; Type: VIEW; Schema: public; Owner: deveremma
--

CREATE VIEW public.robberiesinplanned AS
 SELECT DISTINCT r.bankname,
    r.city,
    EXTRACT(year FROM r.date) AS year
   FROM (public.robberies r
     JOIN public.plans p ON ((((p.bankname)::text = (r.bankname)::text) AND ((p.city)::text = (r.city)::text) AND (EXTRACT(year FROM p.planneddate) = EXTRACT(year FROM r.date)))));


ALTER TABLE public.robberiesinplanned OWNER TO deveremma;

--
-- Name: robberieswithsecurity; Type: VIEW; Schema: public; Owner: deveremma
--

CREATE VIEW public.robberieswithsecurity AS
 SELECT b.security,
    r.amount
   FROM (public.robberies r
     JOIN public.banks b ON ((((r.bankname)::text = (b.bankname)::text) AND ((r.city)::text = (b.city)::text))));


ALTER TABLE public.robberieswithsecurity OWNER TO deveremma;

--
-- Name: robbers_robberid_seq; Type: SEQUENCE; Schema: public; Owner: deveremma
--

CREATE SEQUENCE public.robbers_robberid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.robbers_robberid_seq OWNER TO deveremma;

--
-- Name: robbers_robberid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deveremma
--

ALTER SEQUENCE public.robbers_robberid_seq OWNED BY public.robbers.robberid;


--
-- Name: robbersrobaccount; Type: VIEW; Schema: public; Owner: deveremma
--

CREATE VIEW public.robbersrobaccount AS
 SELECT DISTINCT h.robberid
   FROM (public.hasaccounts h
     JOIN public.accomplices a ON (((a.robberid = h.robberid) AND ((a.bankname)::text = (h.bankname)::text) AND ((a.city)::text = (h.city)::text))));


ALTER TABLE public.robbersrobaccount OWNER TO deveremma;

--
-- Name: robberswithskills; Type: VIEW; Schema: public; Owner: deveremma
--

CREATE VIEW public.robberswithskills AS
 SELECT hasskills.robberid
   FROM public.hasskills
  GROUP BY hasskills.robberid
 HAVING (count(*) >= 2);


ALTER TABLE public.robberswithskills OWNER TO deveremma;

--
-- Name: robberyshareaverage; Type: VIEW; Schema: public; Owner: deveremma
--

CREATE VIEW public.robberyshareaverage AS
SELECT
    NULL::character varying(50) AS bankname,
    NULL::character varying(50) AS city,
    NULL::date AS date,
    NULL::numeric(15,2) AS amount,
    NULL::bigint AS count,
    NULL::numeric AS avg;


ALTER TABLE public.robberyshareaverage OWNER TO deveremma;

--
-- Name: skills; Type: TABLE; Schema: public; Owner: deveremma
--

CREATE TABLE public.skills (
    skillid integer NOT NULL,
    description character varying(50) NOT NULL
);


ALTER TABLE public.skills OWNER TO deveremma;

--
-- Name: skills_skillid_seq; Type: SEQUENCE; Schema: public; Owner: deveremma
--

CREATE SEQUENCE public.skills_skillid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.skills_skillid_seq OWNER TO deveremma;

--
-- Name: skills_skillid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: deveremma
--

ALTER SEQUENCE public.skills_skillid_seq OWNED BY public.skills.skillid;


--
-- Name: accomplices robberid; Type: DEFAULT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.accomplices ALTER COLUMN robberid SET DEFAULT nextval('public.accomplices_robberid_seq'::regclass);


--
-- Name: hasaccounts robberid; Type: DEFAULT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasaccounts ALTER COLUMN robberid SET DEFAULT nextval('public.hasaccounts_robberid_seq'::regclass);


--
-- Name: hasskills robberid; Type: DEFAULT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasskills ALTER COLUMN robberid SET DEFAULT nextval('public.hasskills_robberid_seq'::regclass);


--
-- Name: hasskills skillid; Type: DEFAULT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasskills ALTER COLUMN skillid SET DEFAULT nextval('public.hasskills_skillid_seq'::regclass);


--
-- Name: robbers robberid; Type: DEFAULT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.robbers ALTER COLUMN robberid SET DEFAULT nextval('public.robbers_robberid_seq'::regclass);


--
-- Name: skills skillid; Type: DEFAULT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.skills ALTER COLUMN skillid SET DEFAULT nextval('public.skills_skillid_seq'::regclass);


--
-- Data for Name: accomplices; Type: TABLE DATA; Schema: public; Owner: deveremma
--

COPY public.accomplices (robberid, bankname, city, date, share) FROM stdin;
1	Bad Bank	Chicago	2017-02-02	3010.00
1	NXP Bank	Chicago	2019-01-08	6406.00
1	Loanshark Bank	Evanston	2019-02-28	4997.00
1	Loanshark Bank	Chicago	2019-03-30	4201.00
1	Inter-Gang Bank	Evanston	2016-02-16	12103.00
1	Inter-Gang Bank	Evanston	2018-02-14	8769.00
2	NXP Bank	Chicago	2019-01-08	2300.00
3	Penny Pinchers	Evanston	2016-08-30	16500.00
3	Loanshark Bank	Evanston	2019-02-28	4997.00
3	Loanshark Bank	Chicago	2017-11-09	8200.00
3	Loanshark Bank	Chicago	2019-03-30	4201.00
3	Inter-Gang Bank	Evanston	2018-02-14	8769.00
4	Penny Pinchers	Evanston	2016-08-30	16500.00
4	NXP Bank	Chicago	2019-01-08	6408.32
4	Loanshark Bank	Chicago	2019-03-30	4201.00
4	Inter-Gang Bank	Evanston	2018-02-14	8769.00
4	Gun Chase Bank	Evanston	2016-04-30	3291.30
5	Inter-Gang Bank	Evanston	2017-03-13	60000.00
5	Loanshark Bank	Evanston	2016-04-20	10000.00
7	Penny Pinchers	Chicago	2016-08-30	450.00
7	Loanshark Bank	Evanston	2017-04-20	2749.00
7	Inter-Gang Bank	Evanston	2018-02-14	8769.00
7	Gun Chase Bank	Evanston	2016-04-30	3282.00
8	Penny Pinchers	Evanston	2016-08-30	16500.00
8	Penny Pinchers	Chicago	2016-08-30	450.00
8	Loanshark Bank	Evanston	2017-04-20	2747.00
8	Inter-Gang Bank	Evanston	2016-02-16	12103.00
10	Penny Pinchers	Evanston	2016-08-30	16500.00
10	Loanshark Bank	Chicago	2017-11-09	8200.00
10	Inter-Gang Bank	Evanston	2016-02-16	12103.00
10	Gun Chase Bank	Evanston	2016-04-30	3282.00
11	Penny Pinchers	Evanston	2017-10-30	3000.00
12	PickPocket Bank	Evanston	2016-03-30	31.99
13	Dollar Grabbers	Evanston	2017-11-08	2000.00
14	Dollar Grabbers	Evanston	2017-06-28	1790.00
15	Inter-Gang Bank	Evanston	2017-03-13	30000.00
15	PickPocket Bank	Chicago	2018-02-28	119.00
15	Penny Pinchers	Evanston	2017-10-30	3000.50
15	Penny Pinchers	Evanston	2019-05-30	3250.10
15	Loanshark Bank	Chicago	2019-03-30	4201.01
15	Inter-Gang Bank	Evanston	2016-02-16	12103.00
15	Inter-Gang Bank	Evanston	2018-02-14	8774.00
16	Gun Chase Bank	Evanston	2016-04-30	5000.00
16	Penny Pinchers	Evanston	2016-08-30	16500.80
16	NXP Bank	Chicago	2019-01-08	6406.00
16	Loanshark Bank	Evanston	2016-04-20	2747.00
16	Loanshark Bank	Chicago	2017-11-09	8200.00
16	Inter-Gang Bank	Evanston	2016-02-16	12103.00
16	Inter-Gang Bank	Evanston	2018-02-14	8769.00
17	Loanshark Bank	Evanston	2016-04-20	12880.00
17	PickPocket Bank	Chicago	2018-02-28	120.00
17	Penny Pinchers	Evanston	2016-08-30	16500.00
17	Penny Pinchers	Evanston	2019-05-30	3250.10
17	Loanshark Bank	Evanston	2017-04-20	2747.00
17	Loanshark Bank	Evanston	2019-02-28	4999.00
17	Inter-Gang Bank	Evanston	2016-02-16	12105.00
18	Dollar Grabbers	Evanston	2017-06-28	1790.00
18	Bad Bank	Chicago	2017-02-02	3010.00
18	Dollar Grabbers	Evanston	2017-11-08	2000.00
20	PickPocket Bank	Evanston	2018-01-30	42.99
20	NXP Bank	Chicago	2019-01-08	6406.00
20	Loanshark Bank	Chicago	2017-11-09	8200.00
21	Penny Pinchers	Evanston	2019-05-30	3250.10
21	Loanshark Bank	Evanston	2019-02-28	4997.00
21	Loanshark Bank	Chicago	2017-11-09	8200.00
22	Inter-Gang Bank	Evanston	2017-03-13	2620.00
22	PickPocket Bank	Chicago	2015-09-21	679.00
22	Penny Pinchers	Evanston	2019-05-30	3250.10
23	PickPocket Bank	Chicago	2015-09-21	679.00
23	NXP Bank	Chicago	2019-01-08	6406.00
24	PickPocket Bank	Evanston	2018-01-30	500.00
24	PickPocket Bank	Evanston	2016-03-30	2000.00
24	PickPocket Bank	Chicago	2015-09-21	681.00
24	Penny Pinchers	Evanston	2017-10-30	3000.00
24	Loanshark Bank	Chicago	2019-03-30	4201.00
24	Gun Chase Bank	Evanston	2016-04-30	3282.00
\.


--
-- Data for Name: banks; Type: TABLE DATA; Schema: public; Owner: deveremma
--

COPY public.banks (bankname, city, noaccounts, security) FROM stdin;
NXP Bank	Chicago	1593311	very good
Bankrupt Bank	Evanston	444000	weak
Loanshark Bank	Evanston	7654321	excellent
Loanshark Bank	Deerfield	3456789	very good
Loanshark Bank	Chicago	121212	excellent
Inter-Gang Bank	Chicago	100000	excellent
Inter-Gang Bank	Evanston	555555	excellent
NXP Bank	Evanston	656565	excellent
Penny Pinchers	Chicago	156165	weak
Dollar Grabbers	Chicago	56005	very good
Penny Pinchers	Evanston	130013	excellent
Dollar Grabbers	Evanston	909090	good
Gun Chase Bank	Evanston	656565	excellent
Gun Chase Bank	Burbank	1999	weak
PickPocket Bank	Evanston	2000	very good
PickPocket Bank	Deerfield	6565	excellent
PickPocket Bank	Chicago	130013	weak
Hidden Treasure	Chicago	999999	excellent
Bad Bank	Chicago	6000	weak
Outside Bank	Chicago	5000	good
\.


--
-- Data for Name: hasaccounts; Type: TABLE DATA; Schema: public; Owner: deveremma
--

COPY public.hasaccounts (robberid, bankname, city) FROM stdin;
1	Bad Bank	Chicago
1	Inter-Gang Bank	Evanston
1	NXP Bank	Chicago
2	Loanshark Bank	Chicago
2	Loanshark Bank	Deerfield
3	NXP Bank	Chicago
3	Bankrupt Bank	Evanston
4	Loanshark Bank	Evanston
5	Inter-Gang Bank	Evanston
5	Loanshark Bank	Evanston
7	Inter-Gang Bank	Chicago
8	Penny Pinchers	Evanston
9	PickPocket Bank	Chicago
9	PickPocket Bank	Evanston
9	Bad Bank	Chicago
9	Dollar Grabbers	Chicago
11	Penny Pinchers	Evanston
12	Dollar Grabbers	Evanston
12	Gun Chase Bank	Evanston
13	Gun Chase Bank	Burbank
14	PickPocket Bank	Evanston
15	PickPocket Bank	Deerfield
17	PickPocket Bank	Chicago
18	Bad Bank	Chicago
18	Gun Chase Bank	Evanston
19	Gun Chase Bank	Burbank
20	PickPocket Bank	Evanston
21	PickPocket Bank	Evanston
22	PickPocket Bank	Chicago
23	Hidden Treasure	Chicago
24	Hidden Treasure	Chicago
\.


--
-- Data for Name: hasskills; Type: TABLE DATA; Schema: public; Owner: deveremma
--

COPY public.hasskills (robberid, skillid, preference, grade) FROM stdin;
18	4	2	A
17	9	1	A+
3	9	2	B+
5	9	2	C
23	9	1	A
7	9	2	C+
20	9	1	C
6	10	1	B+
18	10	3	A+
24	1	1	B
2	1	1	A
4	2	1	A
17	2	2	C+
23	2	2	C
9	5	1	B
21	5	1	C
8	6	1	C+
3	6	1	B+
7	6	1	A+
22	6	2	C
24	6	3	B
13	12	1	B+
14	12	1	B
19	12	1	C
15	3	1	A+
8	3	3	C
5	3	1	A+
1	3	1	A+
16	3	1	A
22	8	1	A+
10	8	1	B
1	8	3	A+
1	7	2	C+
24	7	2	C+
12	7	1	A
11	7	1	A+
8	11	2	C+
18	11	1	B+
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: deveremma
--

COPY public.plans (bankname, city, planneddate, norobbers) FROM stdin;
NXP Bank	Chicago	2019-10-30	5
Loanshark Bank	Deerfield	2019-11-15	4
Inter-Gang Bank	Evanston	2019-12-31	4
Dollar Grabbers	Chicago	2019-12-10	3
Gun Chase Bank	Evanston	2019-10-30	6
PickPocket Bank	Deerfield	2019-12-15	6
PickPocket Bank	Chicago	2020-03-10	2
Hidden Treasure	Chicago	2020-01-11	5
NXP Bank	Chicago	2019-10-10	5
Bad Bank	Chicago	2020-02-02	2
PickPocket Bank	Deerfield	2019-11-30	6
\.


--
-- Data for Name: robberies; Type: TABLE DATA; Schema: public; Owner: deveremma
--

COPY public.robberies (bankname, city, date, amount) FROM stdin;
NXP Bank	Chicago	2019-01-08	34302.30
Loanshark Bank	Evanston	2019-02-28	19990.00
Loanshark Bank	Chicago	2019-03-30	21005.00
Inter-Gang Bank	Evanston	2018-02-14	52619.00
Penny Pinchers	Chicago	2016-08-30	900.00
Penny Pinchers	Evanston	2016-08-30	99000.80
Gun Chase Bank	Evanston	2016-04-30	18131.30
PickPocket Bank	Evanston	2016-03-30	2031.99
PickPocket Bank	Chicago	2018-02-28	239.00
Loanshark Bank	Evanston	2017-04-20	10990.00
Inter-Gang Bank	Evanston	2016-02-16	72620.00
Penny Pinchers	Evanston	2017-10-30	9000.50
PickPocket Bank	Evanston	2018-01-30	542.99
Loanshark Bank	Chicago	2017-11-09	41000.00
Penny Pinchers	Evanston	2019-05-30	13000.40
PickPocket Bank	Chicago	2015-09-21	2039.00
Loanshark Bank	Evanston	2016-04-20	20880.00
Inter-Gang Bank	Evanston	2017-03-13	92620.00
Dollar Grabbers	Evanston	2017-11-08	4380.00
Dollar Grabbers	Evanston	2017-06-28	3580.00
Bad Bank	Chicago	2017-02-02	6020.00
\.


--
-- Data for Name: robbers; Type: TABLE DATA; Schema: public; Owner: deveremma
--

COPY public.robbers (robberid, nickname, age, noyears) FROM stdin;
1	Al Capone	31	2
2	Bugsy Malone	42	15
3	Lucky Luchiano	42	15
4	Anastazia	48	15
5	Mimmy The Mau Mau	18	0
6	Tony Genovese	28	16
7	Dutch Schulz	64	31
8	Clyde	20	0
9	Calamity Jane	44	3
10	Bonnie	19	0
11	Meyer Lansky	34	6
12	Moe Dalitz	41	3
13	Mickey Cohen	24	3
14	Kid Cann	14	0
15	Boo Boo Hoff	54	13
16	King Solomon	74	43
17	Bugsy Siegel	48	13
18	Vito Genovese	66	0
19	Mike Genovese	35	0
20	Longy Zwillman	35	6
21	Waxey Gordon	15	0
22	Greasy Guzik	25	1
23	Lepke Buchalter	25	1
24	Sonny Genovese	39	0
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: deveremma
--

COPY public.skills (skillid, description) FROM stdin;
1	Explosives
2	Guarding
3	Planning
4	Cooking
5	Gun-Shooting
6	Lock-Picking
7	Safe-Cracking
8	Preaching
9	Driving
10	Eating
11	Scouting
12	Money Counting
\.


--
-- Name: accomplices_robberid_seq; Type: SEQUENCE SET; Schema: public; Owner: deveremma
--

SELECT pg_catalog.setval('public.accomplices_robberid_seq', 1, false);


--
-- Name: hasaccounts_robberid_seq; Type: SEQUENCE SET; Schema: public; Owner: deveremma
--

SELECT pg_catalog.setval('public.hasaccounts_robberid_seq', 1, false);


--
-- Name: hasskills_robberid_seq; Type: SEQUENCE SET; Schema: public; Owner: deveremma
--

SELECT pg_catalog.setval('public.hasskills_robberid_seq', 1, false);


--
-- Name: hasskills_skillid_seq; Type: SEQUENCE SET; Schema: public; Owner: deveremma
--

SELECT pg_catalog.setval('public.hasskills_skillid_seq', 1, false);


--
-- Name: robbers_robberid_seq; Type: SEQUENCE SET; Schema: public; Owner: deveremma
--

SELECT pg_catalog.setval('public.robbers_robberid_seq', 24, true);


--
-- Name: skills_skillid_seq; Type: SEQUENCE SET; Schema: public; Owner: deveremma
--

SELECT pg_catalog.setval('public.skills_skillid_seq', 12, true);


--
-- Name: accomplices accomplices_pkey; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.accomplices
    ADD CONSTRAINT accomplices_pkey PRIMARY KEY (robberid, bankname, city, date);


--
-- Name: banks banks_pkey; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.banks
    ADD CONSTRAINT banks_pkey PRIMARY KEY (bankname, city);


--
-- Name: hasaccounts hasaccounts_pkey; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasaccounts
    ADD CONSTRAINT hasaccounts_pkey PRIMARY KEY (robberid, bankname, city);


--
-- Name: hasskills hasskills_pkey; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasskills
    ADD CONSTRAINT hasskills_pkey PRIMARY KEY (robberid, skillid);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (bankname, city, planneddate);


--
-- Name: robberies robberies_pkey; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.robberies
    ADD CONSTRAINT robberies_pkey PRIMARY KEY (bankname, city, date);


--
-- Name: robbers robbers_pkey; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.robbers
    ADD CONSTRAINT robbers_pkey PRIMARY KEY (robberid);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (skillid);


--
-- Name: skills unique_description; Type: CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT unique_description UNIQUE (description);


--
-- Name: robberyshareaverage _RETURN; Type: RULE; Schema: public; Owner: deveremma
--

CREATE OR REPLACE VIEW public.robberyshareaverage AS
 SELECT r.bankname,
    r.city,
    r.date,
    r.amount,
    count(*) AS count,
    (r.amount / (count(*))::numeric) AS avg
   FROM (public.robberies r
     JOIN public.accomplices a ON ((((a.bankname)::text = (r.bankname)::text) AND ((a.city)::text = (r.city)::text) AND (a.date = r.date))))
  GROUP BY r.bankname, r.city, r.date;


--
-- Name: accomplices accomplices_bankname_city_date_fkey; Type: FK CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.accomplices
    ADD CONSTRAINT accomplices_bankname_city_date_fkey FOREIGN KEY (bankname, city, date) REFERENCES public.robberies(bankname, city, date) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: accomplices accomplices_robberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.accomplices
    ADD CONSTRAINT accomplices_robberid_fkey FOREIGN KEY (robberid) REFERENCES public.robbers(robberid) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hasaccounts hasaccounts_bankname_city_fkey; Type: FK CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasaccounts
    ADD CONSTRAINT hasaccounts_bankname_city_fkey FOREIGN KEY (bankname, city) REFERENCES public.banks(bankname, city) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hasaccounts hasaccounts_robberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasaccounts
    ADD CONSTRAINT hasaccounts_robberid_fkey FOREIGN KEY (robberid) REFERENCES public.robbers(robberid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hasskills hasskills_robberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasskills
    ADD CONSTRAINT hasskills_robberid_fkey FOREIGN KEY (robberid) REFERENCES public.robbers(robberid) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hasskills hasskills_skillid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.hasskills
    ADD CONSTRAINT hasskills_skillid_fkey FOREIGN KEY (skillid) REFERENCES public.skills(skillid) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plans plans_bankname_city_fkey; Type: FK CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_bankname_city_fkey FOREIGN KEY (bankname, city) REFERENCES public.banks(bankname, city) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: robberies robberies_bankname_city_fkey; Type: FK CONSTRAINT; Schema: public; Owner: deveremma
--

ALTER TABLE ONLY public.robberies
    ADD CONSTRAINT robberies_bankname_city_fkey FOREIGN KEY (bankname, city) REFERENCES public.banks(bankname, city) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

