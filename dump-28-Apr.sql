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

SET search_path = public, pg_catalog;

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
-- Data for Name: vendor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vendor (vendor_id, email, name, address, contact, organization_id) FROM stdin;
3	akshar_travels@gmail.com	Akshar travels	ahmedabad	"office"=>"27556463"	11
\.


--
-- Data for Name: bus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bus (bus_id, vendor_id, current_trip_id, vehicle_no) FROM stdin;
21	3	0	Gj01-MG-5180
22	3	0	Gj01-JE-6008
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

SELECT pg_catalog.setval('driver_driver_id_seq', 12, true);


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
-- Data for Name: trip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trip (trip_id, route_id, driver_id, bus_id, details) FROM stdin;
\.


--
-- Name: trip_trip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trip_trip_id_seq', 18, true);


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
-- Name: vendor_vendor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vendor_vendor_id_seq', 3, true);


--
-- PostgreSQL database dump complete
--

