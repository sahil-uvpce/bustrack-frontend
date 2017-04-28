--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bustrack; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE bustrack WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_IN' LC_CTYPE = 'en_IN';


ALTER DATABASE bustrack OWNER TO postgres;

\connect bustrack

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: add_organization(character varying, character varying, text, character varying, hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_organization(email character varying, name character varying, address text, password character varying, contact hstore) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
      INSERT INTO organization(email, name, address, password, contact) VALUES (email, name, address, password, contact);
    END;
    $$;


ALTER FUNCTION public.add_organization(email character varying, name character varying, address text, password character varying, contact hstore) OWNER TO postgres;

--
-- Name: bus_trip_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bus_trip_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE bus SET current_trip_id=NEW.trip_id WHERE bus_id=NEW.bus_id;
  RETURN NEW;
END$$;


ALTER FUNCTION public.bus_trip_insert() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE bus (
    bus_id integer NOT NULL,
    vendor_id integer NOT NULL,
    current_trip_id integer DEFAULT 0,
    vehicle_no character varying(15) NOT NULL
);


ALTER TABLE bus OWNER TO postgres;

--
-- Name: bus_bus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE bus_bus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bus_bus_id_seq OWNER TO postgres;

--
-- Name: bus_bus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE bus_bus_id_seq OWNED BY bus.bus_id;


--
-- Name: driver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE driver (
    driver_id integer NOT NULL,
    email character varying(254) NOT NULL,
    vendor_id integer NOT NULL,
    name character varying(50) NOT NULL,
    address text NOT NULL,
    password character varying(25),
    contact hstore NOT NULL
);


ALTER TABLE driver OWNER TO postgres;

--
-- Name: driver_driver_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE driver_driver_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE driver_driver_id_seq OWNER TO postgres;

--
-- Name: driver_driver_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE driver_driver_id_seq OWNED BY driver.driver_id;


--
-- Name: organization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE organization (
    organization_id integer NOT NULL,
    email character varying(254) NOT NULL,
    name character varying(50) NOT NULL,
    address text NOT NULL,
    password character varying(25) NOT NULL,
    contact hstore NOT NULL
);


ALTER TABLE organization OWNER TO postgres;

--
-- Name: organization_organization_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE organization_organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE organization_organization_id_seq OWNER TO postgres;

--
-- Name: organization_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE organization_organization_id_seq OWNED BY organization.organization_id;


--
-- Name: permittedusers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE permittedusers (
    organization_id integer NOT NULL,
    email character varying(254) NOT NULL
);


ALTER TABLE permittedusers OWNER TO postgres;

--
-- Name: route; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE route (
    route_id integer NOT NULL,
    organization_id integer NOT NULL,
    source character varying(50) NOT NULL,
    destination character varying(50) NOT NULL,
    coords text
);


ALTER TABLE route OWNER TO postgres;

--
-- Name: route_route_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE route_route_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE route_route_id_seq OWNER TO postgres;

--
-- Name: route_route_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE route_route_id_seq OWNED BY route.route_id;


--
-- Name: testh; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE testh (
    trip_id integer NOT NULL,
    detailsw hstore[]
);


ALTER TABLE testh OWNER TO postgres;

--
-- Name: testh_trip_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE testh_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE testh_trip_id_seq OWNER TO postgres;

--
-- Name: testh_trip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE testh_trip_id_seq OWNED BY testh.trip_id;


--
-- Name: trip; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trip (
    trip_id integer NOT NULL,
    route_id integer NOT NULL,
    driver_id integer NOT NULL,
    bus_id integer NOT NULL,
    details hstore[]
);


ALTER TABLE trip OWNER TO postgres;

--
-- Name: trip_trip_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE trip_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE trip_trip_id_seq OWNER TO postgres;

--
-- Name: trip_trip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE trip_trip_id_seq OWNED BY trip.trip_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    user_id integer NOT NULL,
    email character varying(254) NOT NULL,
    password character varying(25) NOT NULL,
    organization_id integer NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_user_id_seq OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_user_id_seq OWNED BY users.user_id;


--
-- Name: vendor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE vendor (
    vendor_id integer NOT NULL,
    email character varying(254) NOT NULL,
    name character varying(50) NOT NULL,
    address text NOT NULL,
    contact hstore NOT NULL,
    organization_id integer
);


ALTER TABLE vendor OWNER TO postgres;

--
-- Name: vendor_vendor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vendor_vendor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vendor_vendor_id_seq OWNER TO postgres;

--
-- Name: vendor_vendor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE vendor_vendor_id_seq OWNED BY vendor.vendor_id;


--
-- Name: bus_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bus ALTER COLUMN bus_id SET DEFAULT nextval('bus_bus_id_seq'::regclass);


--
-- Name: driver_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY driver ALTER COLUMN driver_id SET DEFAULT nextval('driver_driver_id_seq'::regclass);


--
-- Name: organization_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY organization ALTER COLUMN organization_id SET DEFAULT nextval('organization_organization_id_seq'::regclass);


--
-- Name: route_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY route ALTER COLUMN route_id SET DEFAULT nextval('route_route_id_seq'::regclass);


--
-- Name: trip_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY testh ALTER COLUMN trip_id SET DEFAULT nextval('testh_trip_id_seq'::regclass);


--
-- Name: trip_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip ALTER COLUMN trip_id SET DEFAULT nextval('trip_trip_id_seq'::regclass);


--
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN user_id SET DEFAULT nextval('user_user_id_seq'::regclass);


--
-- Name: vendor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vendor ALTER COLUMN vendor_id SET DEFAULT nextval('vendor_vendor_id_seq'::regclass);


--
-- Data for Name: bus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bus (bus_id, vendor_id, current_trip_id, vehicle_no) FROM stdin;
22	3	0	Gj01-JE-6008
21	3	3	Gj01-MG-5180
\.


--
-- Name: bus_bus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('bus_bus_id_seq', 22, true);


--
-- Data for Name: driver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY driver (driver_id, email, vendor_id, name, address, password, contact) FROM stdin;
11	kal@gmail.com	3	kalubhai	Ahmedabad	kalubhai@123	"mobile"=>"9025465847"
12	sahil.uvpce@gmail.com	3	sahil	Ahmedabad	sahilpatel	"mobile"=>"9099469243"
\.


--
-- Name: driver_driver_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('driver_driver_id_seq', 15, true);


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY organization (organization_id, email, name, address, password, contact) FROM stdin;
1	org@local.com	test organization	asdafdf	12345678	"mobile"=>"789", "office"=>"123"
7	uvpce23@gmail.com	uvpce	KHERVA-MEHSANA	uvpce123	"office"=>"960178952"
8	uvpce24@gmail.com	uvpce	KHERVA-MEHSANA	uvpce123	"office"=>"960178973"
9	uvpce251@gmail.com	uvpce	KHERVA-MEHSANA	uvpce123	"office"=>"860458963"
11	skpatel@gmail.com	skpatel	Ahmedabad	skpatel123	"office"=>"155648569"
2	ldce@gmail.com	LDCE	Ahmedabad	LdCE123	"office"=>"25648569"
17	bussupport1@ldrp.ac.in	LDRP1	Gandhinagar	ldrp1	"office"=>"21265478"
19	ies@gmail.com	Ignite Education Service	vijay cross road, ahmedabad	ies@sahil	"mobile"=>"8866512770"
21	support@vgecg.ac.in	VGEC	gandhinagar	vgec@123	"Phone"=>"079-29099903"
22	support@vpmp.ac.in	vpmp	kherva	vpmp@321	"office"=>"079-27473354"
23	abc	abc	abc	abc	"office"=>"1234567889"
24	aaa@gmail.com	aaaaa	kherva	aaaaaaa	"office"=>"1234355522"
33	aa@gmail.com	aa	kherva	aa	"office"=>"9601789124"
41	bbc@gmail.com	bb	kherva	bb	"office"=>"837366142"
43	xyz@gmail.com	xyz	xyz	xyz	"office"=>"2215455"
44	zzz@gmail.com	zzz	zzz	zzz	"office"=>"12457896"
\.


--
-- Name: organization_organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('organization_organization_id_seq', 50, true);


--
-- Data for Name: permittedusers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY permittedusers (organization_id, email) FROM stdin;
2	saumil@gmail.com
2	nilayjha99@gmail.com
\.


--
-- Data for Name: route; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY route (route_id, organization_id, source, destination, coords) FROM stdin;
4	2	ahmedabad	Mehsana	map/Map1.kml
\.


--
-- Name: route_route_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('route_route_id_seq', 5, true);


--
-- Data for Name: testh; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY testh (trip_id, detailsw) FROM stdin;
19	\N
20	\N
22	\N
23	\N
24	\N
25	\N
21	\N
2	{"\\"lat:lon\\"=>\\"12.27:3.212\\"","\\"lat:lon\\"=>\\"12.272:3.212\\""}
1	{"\\"lat:lon\\"=>\\"12.27:3.212\\"","\\"lat:lon\\"=>\\"12.272:3.212\\"","\\"lat:lon\\"=>\\"12.27:3.212\\"","\\"lat:lon\\"=>\\"12.272:3.212\\""}
\.


--
-- Name: testh_trip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('testh_trip_id_seq', 2, true);


--
-- Data for Name: trip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trip (trip_id, route_id, driver_id, bus_id, details) FROM stdin;
1	4	11	21	\N
2	4	11	21	{"\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\"","\\"lat:lon\\"=>\\"0.0:0.0\\""}
3	4	11	21	{"\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99794413:72.62295208\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99794601:72.62296738\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99795441:72.62297561\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99799009:72.62295692\\"","\\"lat:lon\\"=>\\"22.99793981:72.6229411\\""}
\.


--
-- Name: trip_trip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trip_trip_id_seq', 3, true);


--
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_user_id_seq', 4, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (user_id, email, password, organization_id) FROM stdin;
\.


--
-- Data for Name: vendor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vendor (vendor_id, email, name, address, contact, organization_id) FROM stdin;
3	akshar_travels@gmail.com	Akshar travels	ahmedabad	"office"=>"27556463"	11
\.


--
-- Name: vendor_vendor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vendor_vendor_id_seq', 3, true);


--
-- Name: bus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bus
    ADD CONSTRAINT bus_pkey PRIMARY KEY (bus_id);


--
-- Name: driver_driver_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY driver
    ADD CONSTRAINT driver_driver_id_pk PRIMARY KEY (driver_id);


--
-- Name: organization_organization_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT organization_organization_id_pk PRIMARY KEY (organization_id);


--
-- Name: route_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_pkey PRIMARY KEY (route_id);


--
-- Name: testh_trip_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY testh
    ADD CONSTRAINT testh_trip_id_pk PRIMARY KEY (trip_id);


--
-- Name: trip_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_pkey PRIMARY KEY (trip_id);


--
-- Name: user_user_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT user_user_id_pk PRIMARY KEY (user_id);


--
-- Name: vendor_vendor_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vendor
    ADD CONSTRAINT vendor_vendor_id_pk PRIMARY KEY (vendor_id);


--
-- Name: bus_vehicle_no_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX bus_vehicle_no_uindex ON bus USING btree (vehicle_no);


--
-- Name: bus_vendor_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bus_vendor_index ON bus USING btree (bus_id);


--
-- Name: driver_contact_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX driver_contact_uindex ON driver USING btree (contact);


--
-- Name: driver_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX driver_email_uindex ON driver USING btree (email);


--
-- Name: organization_contact_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX organization_contact_uindex ON organization USING btree (contact);


--
-- Name: organization_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX organization_email_uindex ON organization USING btree (email);


--
-- Name: permittedUsers_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "permittedUsers_email_uindex" ON permittedusers USING btree (email);


--
-- Name: permittedUsers_org_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "permittedUsers_org_index" ON permittedusers USING btree (organization_id);


--
-- Name: route_coords_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX route_coords_uindex ON route USING btree (coords);


--
-- Name: users_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_uindex ON users USING btree (email);


--
-- Name: users_org_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_org_index ON users USING btree (organization_id);


--
-- Name: vendor_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX vendor_email_uindex ON vendor USING btree (email);


--
-- Name: vendor_name_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX vendor_name_uindex ON vendor USING btree (name);


--
-- Name: vendor_vendor_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX vendor_vendor_id_uindex ON vendor USING btree (vendor_id);


--
-- Name: inject_bus_trip; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER inject_bus_trip AFTER INSERT OR UPDATE ON trip FOR EACH ROW EXECUTE PROCEDURE bus_trip_insert();


--
-- Name: bus_vendor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bus
    ADD CONSTRAINT bus_vendor_fk FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id) ON DELETE CASCADE;


--
-- Name: driver_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY driver
    ADD CONSTRAINT driver_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id) ON DELETE CASCADE;


--
-- Name: permittedusers_org_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permittedusers
    ADD CONSTRAINT permittedusers_org_fk FOREIGN KEY (organization_id) REFERENCES organization(organization_id) ON DELETE CASCADE;


--
-- Name: route_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_organization_fk FOREIGN KEY (organization_id) REFERENCES organization(organization_id) ON DELETE CASCADE;


--
-- Name: trip_bus_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_bus_fk FOREIGN KEY (bus_id) REFERENCES bus(bus_id) ON DELETE CASCADE;


--
-- Name: trip_driver_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_driver_fk FOREIGN KEY (driver_id) REFERENCES driver(driver_id) ON DELETE CASCADE;


--
-- Name: trip_route_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_route_fk FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- Name: users_email_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_fk FOREIGN KEY (email) REFERENCES permittedusers(email) ON DELETE CASCADE;


--
-- Name: users_org_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_org_fk FOREIGN KEY (organization_id) REFERENCES organization(organization_id) ON DELETE CASCADE;


--
-- Name: vendor_org_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vendor
    ADD CONSTRAINT vendor_org_fk FOREIGN KEY (organization_id) REFERENCES organization(organization_id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

