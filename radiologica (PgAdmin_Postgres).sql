--
-- PostgreSQL database dump
--

\restrict JCyBjpuT7UmR3OhJZWkIAEp7fitJ5fOYO1xs3DgDaKcfqmJvlfzVSKF8I3a95PH

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-03 13:45:34

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
-- TOC entry 226 (class 1259 OID 40996)
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    id_appointment bigint NOT NULL,
    appo_patient_id bigint NOT NULL,
    appo_date date NOT NULL,
    appo_time time without time zone NOT NULL,
    appo_status character varying(50)
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 40995)
-- Name: appointment_id_appointment_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_id_appointment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointment_id_appointment_seq OWNER TO postgres;

--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 225
-- Name: appointment_id_appointment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_id_appointment_seq OWNED BY public.appointment.id_appointment;


--
-- TOC entry 222 (class 1259 OID 40982)
-- Name: doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor (
    id_doctor bigint NOT NULL,
    doct_first_name character varying(100) NOT NULL,
    doct_last_name character varying(100) NOT NULL,
    doct_specialty character varying(100),
    doct_phone character varying(20),
    doct_email character varying(100)
);


ALTER TABLE public.doctor OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 40981)
-- Name: doctor_id_doctor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_id_doctor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doctor_id_doctor_seq OWNER TO postgres;

--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 221
-- Name: doctor_id_doctor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_id_doctor_seq OWNED BY public.doctor.id_doctor;


--
-- TOC entry 220 (class 1259 OID 40975)
-- Name: equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipment (
    id_equipment bigint NOT NULL,
    equi_name character varying(100) NOT NULL,
    equi_brand character varying(50),
    equi_model character varying(50),
    equi_location character varying(100)
);


ALTER TABLE public.equipment OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 40974)
-- Name: equipment_id_equipment_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipment_id_equipment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipment_id_equipment_seq OWNER TO postgres;

--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 219
-- Name: equipment_id_equipment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipment_id_equipment_seq OWNED BY public.equipment.id_equipment;


--
-- TOC entry 230 (class 1259 OID 41045)
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    id_image bigint NOT NULL,
    imag_study_id bigint NOT NULL,
    imag_file_path character varying(200) NOT NULL,
    imag_format character varying(10),
    imag_capture_date timestamp without time zone
);


ALTER TABLE public.image OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 41044)
-- Name: image_id_image_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.image_id_image_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.image_id_image_seq OWNER TO postgres;

--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 229
-- Name: image_id_image_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.image_id_image_seq OWNED BY public.image.id_image;


--
-- TOC entry 218 (class 1259 OID 40968)
-- Name: modality; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modality (
    id_modality bigint NOT NULL,
    moda_name character varying(50) NOT NULL
);


ALTER TABLE public.modality OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 40967)
-- Name: modality_id_modality_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.modality_id_modality_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.modality_id_modality_seq OWNER TO postgres;

--
-- TOC entry 3533 (class 0 OID 0)
-- Dependencies: 217
-- Name: modality_id_modality_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.modality_id_modality_seq OWNED BY public.modality.id_modality;


--
-- TOC entry 216 (class 1259 OID 40961)
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    id_patient bigint NOT NULL,
    pati_first_name character varying(30) NOT NULL,
    pati_last_name character varying(30) NOT NULL,
    pati_birth_date date NOT NULL,
    pati_gender character(1),
    pati_address character varying(100),
    pati_phone character varying(13),
    pati_email character varying(50)
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 40960)
-- Name: patient_id_patient_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patient_id_patient_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_id_patient_seq OWNER TO postgres;

--
-- TOC entry 3536 (class 0 OID 0)
-- Dependencies: 215
-- Name: patient_id_patient_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patient_id_patient_seq OWNED BY public.patient.id_patient;


--
-- TOC entry 233 (class 1259 OID 41069)
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id_payment bigint NOT NULL,
    paym_patient_id bigint NOT NULL,
    paym_study_id bigint NOT NULL,
    paym_amount numeric(10,2) NOT NULL,
    paym_date timestamp without time zone NOT NULL,
    paym_method character varying(50)
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 41068)
-- Name: payment_id_payment_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_id_payment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_id_payment_seq OWNER TO postgres;

--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 232
-- Name: payment_id_payment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_id_payment_seq OWNED BY public.payment.id_payment;


--
-- TOC entry 231 (class 1259 OID 41056)
-- Name: report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report (
    id_report bigint NOT NULL,
    repo_description text,
    repo_diagnosis text,
    repo_date timestamp without time zone
);


ALTER TABLE public.report OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 41008)
-- Name: study; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study (
    id_study bigint NOT NULL,
    stud_patient_id bigint NOT NULL,
    stud_modality_id bigint NOT NULL,
    stud_equipment_id bigint,
    stud_doctor_id bigint,
    stud_technologist_id bigint,
    stud_appointment_id bigint,
    stud_date timestamp without time zone NOT NULL,
    stud_status character varying(50)
);


ALTER TABLE public.study OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 41007)
-- Name: study_id_study_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_id_study_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_id_study_seq OWNER TO postgres;

--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 227
-- Name: study_id_study_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_id_study_seq OWNED BY public.study.id_study;


--
-- TOC entry 236 (class 1259 OID 41092)
-- Name: study_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_tag (
    stta_study_id bigint NOT NULL,
    stta_tag_id bigint NOT NULL
);


ALTER TABLE public.study_tag OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 41086)
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    id_tag bigint NOT NULL,
    tag_name character varying(50) NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 41085)
-- Name: tag_id_tag_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tag_id_tag_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tag_id_tag_seq OWNER TO postgres;

--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 234
-- Name: tag_id_tag_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tag_id_tag_seq OWNED BY public.tag.id_tag;


--
-- TOC entry 224 (class 1259 OID 40989)
-- Name: technologist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.technologist (
    id_technologist bigint NOT NULL,
    tech_first_name character varying(100) NOT NULL,
    tech_last_name character varying(100) NOT NULL,
    tech_phone character varying(20),
    tech_email character varying(100)
);


ALTER TABLE public.technologist OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 40988)
-- Name: technologist_id_technologist_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.technologist_id_technologist_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.technologist_id_technologist_seq OWNER TO postgres;

--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 223
-- Name: technologist_id_technologist_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.technologist_id_technologist_seq OWNED BY public.technologist.id_technologist;


--
-- TOC entry 3307 (class 2604 OID 40999)
-- Name: appointment id_appointment; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN id_appointment SET DEFAULT nextval('public.appointment_id_appointment_seq'::regclass);


--
-- TOC entry 3305 (class 2604 OID 40985)
-- Name: doctor id_doctor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor ALTER COLUMN id_doctor SET DEFAULT nextval('public.doctor_id_doctor_seq'::regclass);


--
-- TOC entry 3304 (class 2604 OID 40978)
-- Name: equipment id_equipment; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment ALTER COLUMN id_equipment SET DEFAULT nextval('public.equipment_id_equipment_seq'::regclass);


--
-- TOC entry 3309 (class 2604 OID 41048)
-- Name: image id_image; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image ALTER COLUMN id_image SET DEFAULT nextval('public.image_id_image_seq'::regclass);


--
-- TOC entry 3303 (class 2604 OID 40971)
-- Name: modality id_modality; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modality ALTER COLUMN id_modality SET DEFAULT nextval('public.modality_id_modality_seq'::regclass);


--
-- TOC entry 3302 (class 2604 OID 40964)
-- Name: patient id_patient; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient ALTER COLUMN id_patient SET DEFAULT nextval('public.patient_id_patient_seq'::regclass);


--
-- TOC entry 3310 (class 2604 OID 41072)
-- Name: payment id_payment; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN id_payment SET DEFAULT nextval('public.payment_id_payment_seq'::regclass);


--
-- TOC entry 3308 (class 2604 OID 41011)
-- Name: study id_study; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study ALTER COLUMN id_study SET DEFAULT nextval('public.study_id_study_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 41089)
-- Name: tag id_tag; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag ALTER COLUMN id_tag SET DEFAULT nextval('public.tag_id_tag_seq'::regclass);


--
-- TOC entry 3306 (class 2604 OID 40992)
-- Name: technologist id_technologist; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technologist ALTER COLUMN id_technologist SET DEFAULT nextval('public.technologist_id_technologist_seq'::regclass);


--
-- TOC entry 3503 (class 0 OID 40996)
-- Dependencies: 226
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointment (id_appointment, appo_patient_id, appo_date, appo_time, appo_status) FROM stdin;
\.


--
-- TOC entry 3499 (class 0 OID 40982)
-- Dependencies: 222
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor (id_doctor, doct_first_name, doct_last_name, doct_specialty, doct_phone, doct_email) FROM stdin;
\.


--
-- TOC entry 3497 (class 0 OID 40975)
-- Dependencies: 220
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipment (id_equipment, equi_name, equi_brand, equi_model, equi_location) FROM stdin;
\.


--
-- TOC entry 3507 (class 0 OID 41045)
-- Dependencies: 230
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (id_image, imag_study_id, imag_file_path, imag_format, imag_capture_date) FROM stdin;
\.


--
-- TOC entry 3495 (class 0 OID 40968)
-- Dependencies: 218
-- Data for Name: modality; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modality (id_modality, moda_name) FROM stdin;
\.


--
-- TOC entry 3493 (class 0 OID 40961)
-- Dependencies: 216
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patient (id_patient, pati_first_name, pati_last_name, pati_birth_date, pati_gender, pati_address, pati_phone, pati_email) FROM stdin;
\.


--
-- TOC entry 3510 (class 0 OID 41069)
-- Dependencies: 233
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id_payment, paym_patient_id, paym_study_id, paym_amount, paym_date, paym_method) FROM stdin;
\.


--
-- TOC entry 3508 (class 0 OID 41056)
-- Dependencies: 231
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report (id_report, repo_description, repo_diagnosis, repo_date) FROM stdin;
\.


--
-- TOC entry 3505 (class 0 OID 41008)
-- Dependencies: 228
-- Data for Name: study; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study (id_study, stud_patient_id, stud_modality_id, stud_equipment_id, stud_doctor_id, stud_technologist_id, stud_appointment_id, stud_date, stud_status) FROM stdin;
\.


--
-- TOC entry 3513 (class 0 OID 41092)
-- Dependencies: 236
-- Data for Name: study_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study_tag (stta_study_id, stta_tag_id) FROM stdin;
\.


--
-- TOC entry 3512 (class 0 OID 41086)
-- Dependencies: 235
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (id_tag, tag_name) FROM stdin;
\.


--
-- TOC entry 3501 (class 0 OID 40989)
-- Dependencies: 224
-- Data for Name: technologist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.technologist (id_technologist, tech_first_name, tech_last_name, tech_phone, tech_email) FROM stdin;
\.


--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 225
-- Name: appointment_id_appointment_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_id_appointment_seq', 1, false);


--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 221
-- Name: doctor_id_doctor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctor_id_doctor_seq', 1, false);


--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 219
-- Name: equipment_id_equipment_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_id_equipment_seq', 1, false);


--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 229
-- Name: image_id_image_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.image_id_image_seq', 1, false);


--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 217
-- Name: modality_id_modality_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.modality_id_modality_seq', 1, false);


--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 215
-- Name: patient_id_patient_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patient_id_patient_seq', 1, false);


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 232
-- Name: payment_id_payment_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_id_payment_seq', 1, false);


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 227
-- Name: study_id_study_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_id_study_seq', 1, false);


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 234
-- Name: tag_id_tag_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_id_tag_seq', 1, false);


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 223
-- Name: technologist_id_technologist_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.technologist_id_technologist_seq', 1, false);


--
-- TOC entry 3323 (class 2606 OID 41001)
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id_appointment);


--
-- TOC entry 3319 (class 2606 OID 40987)
-- Name: doctor doctor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_pkey PRIMARY KEY (id_doctor);


--
-- TOC entry 3317 (class 2606 OID 40980)
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id_equipment);


--
-- TOC entry 3327 (class 2606 OID 41050)
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id_image);


--
-- TOC entry 3315 (class 2606 OID 40973)
-- Name: modality modality_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modality
    ADD CONSTRAINT modality_pkey PRIMARY KEY (id_modality);


--
-- TOC entry 3313 (class 2606 OID 40966)
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (id_patient);


--
-- TOC entry 3331 (class 2606 OID 41074)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id_payment);


--
-- TOC entry 3329 (class 2606 OID 41062)
-- Name: report report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY (id_report);


--
-- TOC entry 3325 (class 2606 OID 41013)
-- Name: study study_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_pkey PRIMARY KEY (id_study);


--
-- TOC entry 3335 (class 2606 OID 41096)
-- Name: study_tag study_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_tag
    ADD CONSTRAINT study_tag_pkey PRIMARY KEY (stta_study_id, stta_tag_id);


--
-- TOC entry 3333 (class 2606 OID 41091)
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id_tag);


--
-- TOC entry 3321 (class 2606 OID 40994)
-- Name: technologist technologist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.technologist
    ADD CONSTRAINT technologist_pkey PRIMARY KEY (id_technologist);


--
-- TOC entry 3336 (class 2606 OID 41002)
-- Name: appointment appointment_appo_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_appo_patient_id_fkey FOREIGN KEY (appo_patient_id) REFERENCES public.patient(id_patient);


--
-- TOC entry 3343 (class 2606 OID 41051)
-- Name: image image_imag_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_imag_study_id_fkey FOREIGN KEY (imag_study_id) REFERENCES public.study(id_study);


--
-- TOC entry 3345 (class 2606 OID 41075)
-- Name: payment payment_paym_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_paym_patient_id_fkey FOREIGN KEY (paym_patient_id) REFERENCES public.patient(id_patient);


--
-- TOC entry 3346 (class 2606 OID 41080)
-- Name: payment payment_paym_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_paym_study_id_fkey FOREIGN KEY (paym_study_id) REFERENCES public.study(id_study);


--
-- TOC entry 3344 (class 2606 OID 41063)
-- Name: report report_id_report_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_id_report_fkey FOREIGN KEY (id_report) REFERENCES public.study(id_study);


--
-- TOC entry 3337 (class 2606 OID 41039)
-- Name: study study_stud_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_stud_appointment_id_fkey FOREIGN KEY (stud_appointment_id) REFERENCES public.appointment(id_appointment);


--
-- TOC entry 3338 (class 2606 OID 41029)
-- Name: study study_stud_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_stud_doctor_id_fkey FOREIGN KEY (stud_doctor_id) REFERENCES public.doctor(id_doctor);


--
-- TOC entry 3339 (class 2606 OID 41024)
-- Name: study study_stud_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_stud_equipment_id_fkey FOREIGN KEY (stud_equipment_id) REFERENCES public.equipment(id_equipment);


--
-- TOC entry 3340 (class 2606 OID 41019)
-- Name: study study_stud_modality_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_stud_modality_id_fkey FOREIGN KEY (stud_modality_id) REFERENCES public.modality(id_modality);


--
-- TOC entry 3341 (class 2606 OID 41014)
-- Name: study study_stud_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_stud_patient_id_fkey FOREIGN KEY (stud_patient_id) REFERENCES public.patient(id_patient);


--
-- TOC entry 3342 (class 2606 OID 41034)
-- Name: study study_stud_technologist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_stud_technologist_id_fkey FOREIGN KEY (stud_technologist_id) REFERENCES public.technologist(id_technologist);


--
-- TOC entry 3347 (class 2606 OID 41097)
-- Name: study_tag study_tag_stta_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_tag
    ADD CONSTRAINT study_tag_stta_study_id_fkey FOREIGN KEY (stta_study_id) REFERENCES public.study(id_study);


--
-- TOC entry 3348 (class 2606 OID 41102)
-- Name: study_tag study_tag_stta_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_tag
    ADD CONSTRAINT study_tag_stta_tag_id_fkey FOREIGN KEY (stta_tag_id) REFERENCES public.tag(id_tag);


--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO salva;


--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE appointment; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.appointment TO salva;


--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE appointment_id_appointment_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.appointment_id_appointment_seq TO salva;


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE doctor; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.doctor TO salva;


--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE doctor_id_doctor_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.doctor_id_doctor_seq TO salva;


--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE equipment; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.equipment TO salva;


--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE equipment_id_equipment_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.equipment_id_equipment_seq TO salva;


--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE image; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.image TO salva;


--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE image_id_image_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.image_id_image_seq TO salva;


--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE modality; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.modality TO salva;


--
-- TOC entry 3534 (class 0 OID 0)
-- Dependencies: 217
-- Name: SEQUENCE modality_id_modality_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.modality_id_modality_seq TO salva;


--
-- TOC entry 3535 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE patient; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.patient TO salva;


--
-- TOC entry 3537 (class 0 OID 0)
-- Dependencies: 215
-- Name: SEQUENCE patient_id_patient_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.patient_id_patient_seq TO salva;


--
-- TOC entry 3538 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE payment; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.payment TO salva;


--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE payment_id_payment_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.payment_id_payment_seq TO salva;


--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE report; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.report TO salva;


--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE study; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.study TO salva;


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE study_id_study_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.study_id_study_seq TO salva;


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE study_tag; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.study_tag TO salva;


--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE tag; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.tag TO salva;


--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE tag_id_tag_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.tag_id_tag_seq TO salva;


--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE technologist; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.technologist TO salva;


--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE technologist_id_technologist_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON SEQUENCE public.technologist_id_technologist_seq TO salva;


--
-- TOC entry 2092 (class 826 OID 41108)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON SEQUENCES TO salva;


--
-- TOC entry 2091 (class 826 OID 41107)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES TO salva;


-- Completed on 2025-09-03 13:45:34

--
-- PostgreSQL database dump complete
--

\unrestrict JCyBjpuT7UmR3OhJZWkIAEp7fitJ5fOYO1xs3DgDaKcfqmJvlfzVSKF8I3a95PH

