--
-- PostgreSQL database dump
--

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
-- Dumped by pg_dump version 17.0

-- Started on 2025-10-16 19:15:46

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: salva
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO salva;

--
-- TOC entry 922 (class 1247 OID 32770)
-- Name: patients_audit_action; Type: TYPE; Schema: public; Owner: salva
--

CREATE TYPE public.patients_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.patients_audit_action OWNER TO salva;

--
-- TOC entry 928 (class 1247 OID 40968)
-- Name: payments_audit_action; Type: TYPE; Schema: public; Owner: salva
--

CREATE TYPE public.payments_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.payments_audit_action OWNER TO salva;

--
-- TOC entry 934 (class 1247 OID 40998)
-- Name: studies_audit_action; Type: TYPE; Schema: public; Owner: salva
--

CREATE TYPE public.studies_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.studies_audit_action OWNER TO salva;

--
-- TOC entry 244 (class 1255 OID 32787)
-- Name: patients_ai_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.patients_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
PERFORM set_config('app.from_patients_trigger','1', true);

  INSERT INTO patients_audit (patient_id, "actionpatient", before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
      'id', NEW.id,
      'pati_first_name', NEW.pati_first_name,
      'pati_last_name', NEW.pati_last_name,
      'pati_birth_date', NEW.pati_birth_date,
      'pati_gender', NEW.pati_gender,
      'pati_address', NEW.pati_address,
      'pati_phone', NEW.pati_phone,
      'pati_email', NEW.pati_email
  );

  PERFORM set_config('app.from_patients_trigger','', true);
  RETURN NEW;
	END;
$$;


ALTER FUNCTION public.patients_ai_audit() OWNER TO salva;

--
-- TOC entry 245 (class 1255 OID 32788)
-- Name: patients_au_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.patients_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
PERFORM set_config('app.from_patients_trigger','1', true);

  INSERT INTO patients_audit (patient_id, "actionpatient", before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'pati_first_name', OLD.pati_first_name,
      'pati_last_name', OLD.pati_last_name,
      'pati_birth_date', OLD.pati_birth_date,
      'pati_gender', OLD.pati_gender,
      'pati_address', OLD.pati_address,
      'pati_phone', OLD.pati_phone,
      'pati_email', OLD.pati_email
    ),
    jsonb_build_object(
      'id', OLD.id,
      'pati_first_name', OLD.pati_first_name,
      'pati_last_name', OLD.pati_last_name,
      'pati_birth_date', OLD.pati_birth_date,
      'pati_gender', OLD.pati_gender,
      'pati_address', OLD.pati_address,
      'pati_phone', OLD.pati_phone,
      'pati_email', OLD.pati_email
    )
  );

  PERFORM set_config('app.from_patients_trigger','', true);
  RETURN NEW;
	END;
$$;


ALTER FUNCTION public.patients_au_audit() OWNER TO salva;

--
-- TOC entry 249 (class 1255 OID 40963)
-- Name: patients_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.patients_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'patients_audit es inmutable: DELETE prohibido.';
  RETURN OLD; -- no se alcanza
END$$;


ALTER FUNCTION public.patients_audit_block_bd() OWNER TO salva;

--
-- TOC entry 248 (class 1255 OID 40962)
-- Name: patients_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.patients_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'patients_audit es inmutable: UPDATE prohibido.';
  RETURN NEW; -- no se alcanza
END$$;


ALTER FUNCTION public.patients_audit_block_bu() OWNER TO salva;

--
-- TOC entry 247 (class 1255 OID 40961)
-- Name: patients_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.patients_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_patients_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en patients_audit solo permitido desde triggers de patients.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.patients_audit_guard_bi() OWNER TO salva;

--
-- TOC entry 246 (class 1255 OID 32792)
-- Name: patients_bd_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.patients_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
  PERFORM set_config('app.from_patients_trigger','1', true);

 INSERT INTO patients_audit (patient_id, "actionpatient", before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'pati_first_name', OLD.pati_first_name,
      'pati_last_name', OLD.pati_last_name,
      'pati_birth_date', OLD.pati_birth_date,
      'pati_gender', OLD.pati_gender,
      'pati_address', OLD.pati_address,
      'pati_phone', OLD.pati_phone,
      'pati_email', OLD.pati_email
    ),
    NULL
  );

  PERFORM set_config('app.from_patients_trigger','', true);
  RETURN OLD;
	END;
$$;


ALTER FUNCTION public.patients_bd_audit() OWNER TO salva;

--
-- TOC entry 250 (class 1255 OID 40985)
-- Name: payments_ai_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.payments_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_payments_trigger','1', true);

  INSERT INTO payments_audit (payment_id, "actionpayment", before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    jsonb_build_object(
      'id', NEW.id,
      'paym_appointment_id', NEW.paym_appointment_id,
      'paym_amount', NEW.paym_amount,
      'paym_date', NEW.paym_date,
      'paym_method', NEW.paym_method
    )
  );

  PERFORM set_config('app.from_payments_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.payments_ai_audit() OWNER TO salva;

--
-- TOC entry 255 (class 1255 OID 40986)
-- Name: payments_au_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.payments_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_payments_trigger','1', true);

  INSERT INTO payments_audit (payment_id, "actionpayment", before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'paym_appointment_id', OLD.paym_appointment_id,
      'paym_amount', OLD.paym_amount,
      'paym_date', OLD.paym_date,
      'paym_method', OLD.paym_method
    ),
    jsonb_build_object(
      'id', NEW.id,
      'paym_appointment_id', NEW.paym_appointment_id,
      'paym_amount', NEW.paym_amount,
      'paym_date', NEW.paym_date,
      'paym_method', NEW.paym_method
    )
  );

  PERFORM set_config('app.from_payments_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.payments_au_audit() OWNER TO salva;

--
-- TOC entry 266 (class 1255 OID 40993)
-- Name: payments_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.payments_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'payments_audit es inmutable: DELETE prohibido.';
  RETURN OLD; -- no se alcanza
END$$;


ALTER FUNCTION public.payments_audit_block_bd() OWNER TO salva;

--
-- TOC entry 265 (class 1255 OID 40992)
-- Name: payments_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.payments_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'payments_audit es inmutable: UPDATE prohibido.';
  RETURN NEW; -- no se alcanza
END$$;


ALTER FUNCTION public.payments_audit_block_bu() OWNER TO salva;

--
-- TOC entry 264 (class 1255 OID 40991)
-- Name: payments_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.payments_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_payments_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en payments_audit solo permitido desde triggers de payments.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.payments_audit_guard_bi() OWNER TO salva;

--
-- TOC entry 263 (class 1255 OID 40987)
-- Name: payments_bd_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.payments_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_payments_trigger','1', true);

  INSERT INTO payments_audit (payment_id, "actionpayment", before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'paym_appointment_id', OLD.paym_appointment_id,
      'paym_amount', OLD.paym_amount,
      'paym_date', OLD.paym_date,
      'paym_method', OLD.paym_method
    ),
    NULL
  );

  PERFORM set_config('app.from_payments_trigger','', true);
  RETURN OLD;
END$$;


ALTER FUNCTION public.payments_bd_audit() OWNER TO salva;

--
-- TOC entry 267 (class 1255 OID 41015)
-- Name: studies_ai_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.studies_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_studies_trigger','1', true);

  INSERT INTO studies_audit (study_id, "actionstudy", before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    jsonb_build_object(
      'id', NEW.id,
      'stud_patient_id', NEW.stud_patient_id,
      'stud_doctor_id', NEW.stud_doctor_id,
      'stud_modality_id', NEW.stud_modality_id,
      'stud_equipment_id', NEW.stud_equipment_id,
      'stud_appointment_id', NEW.stud_appointment_id,
      'stud_date', NEW.stud_date,
      'stud_status', NEW.stud_status
    )
  );

  PERFORM set_config('app.from_studies_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.studies_ai_audit() OWNER TO salva;

--
-- TOC entry 268 (class 1255 OID 41016)
-- Name: studies_au_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.studies_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_studies_trigger','1', true);

  INSERT INTO studies_audit (study_id, "actionstudy", before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'stud_patient_id', OLD.stud_patient_id,
      'stud_doctor_id', OLD.stud_doctor_id,
      'stud_modality_id', OLD.stud_modality_id,
      'stud_equipment_id', OLD.stud_equipment_id,
      'stud_appointment_id', OLD.stud_appointment_id,
      'stud_date', OLD.stud_date,
      'stud_status', OLD.stud_status
    ),
    jsonb_build_object(
      'id', NEW.id,
      'stud_patient_id', NEW.stud_patient_id,
      'stud_doctor_id', NEW.stud_doctor_id,
      'stud_modality_id', NEW.stud_modality_id,
      'stud_equipment_id', NEW.stud_equipment_id,
      'stud_appointment_id', NEW.stud_appointment_id,
      'stud_date', NEW.stud_date,
      'stud_status', NEW.stud_status
    )
  );

  PERFORM set_config('app.from_studies_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.studies_au_audit() OWNER TO salva;

--
-- TOC entry 272 (class 1255 OID 41023)
-- Name: studies_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.studies_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'studies_audit es inmutable: DELETE prohibido.';
  RETURN OLD; -- no se alcanza
END$$;


ALTER FUNCTION public.studies_audit_block_bd() OWNER TO salva;

--
-- TOC entry 271 (class 1255 OID 41022)
-- Name: studies_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.studies_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'studies_audit es inmutable: UPDATE prohibido.';
  RETURN NEW; -- no se alcanza
END$$;


ALTER FUNCTION public.studies_audit_block_bu() OWNER TO salva;

--
-- TOC entry 270 (class 1255 OID 41021)
-- Name: studies_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.studies_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_studies_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en studies_audit solo permitido desde triggers de studies.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.studies_audit_guard_bi() OWNER TO salva;

--
-- TOC entry 269 (class 1255 OID 41017)
-- Name: studies_bd_audit(); Type: FUNCTION; Schema: public; Owner: salva
--

CREATE FUNCTION public.studies_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_studies_trigger','1', true);

  INSERT INTO studies_audit (study_id, "actionstudy", before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'stud_patient_id', OLD.stud_patient_id,
      'stud_doctor_id', OLD.stud_doctor_id,
      'stud_modality_id', OLD.stud_modality_id,
      'stud_equipment_id', OLD.stud_equipment_id,
      'stud_appointment_id', OLD.stud_appointment_id,
      'stud_date', OLD.stud_date,
      'stud_status', OLD.stud_status
    ),
    NULL
  );

  PERFORM set_config('app.from_studies_trigger','', true);
  RETURN OLD;
END$$;


ALTER FUNCTION public.studies_bd_audit() OWNER TO salva;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 24632)
-- Name: appointments; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.appointments (
    id bigint NOT NULL,
    appo_patient_id bigint NOT NULL,
    appo_date timestamp without time zone NOT NULL,
    appo_status character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.appointments OWNER TO salva;

--
-- TOC entry 227 (class 1259 OID 24631)
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.appointments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 24591)
-- Name: doctors; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.doctors (
    id bigint NOT NULL,
    doct_first_name character varying(100) NOT NULL,
    doct_last_name character varying(100) NOT NULL,
    doct_specialty character varying(100) DEFAULT NULL::character varying,
    doct_phone character varying(13) DEFAULT NULL::character varying,
    doct_email character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.doctors OWNER TO salva;

--
-- TOC entry 217 (class 1259 OID 24590)
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.doctors ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.doctors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 24615)
-- Name: equipments; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.equipments (
    id bigint NOT NULL,
    equi_name character varying(50) NOT NULL,
    equi_brand character varying(50) DEFAULT NULL::character varying,
    equi_model character varying(50) DEFAULT NULL::character varying,
    equi_location character varying(100) DEFAULT NULL::character varying
);


ALTER TABLE public.equipments OWNER TO salva;

--
-- TOC entry 223 (class 1259 OID 24614)
-- Name: equipments_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.equipments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.equipments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 24675)
-- Name: images; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.images (
    id bigint NOT NULL,
    imag_study_id bigint NOT NULL,
    imag_date timestamp without time zone NOT NULL
);


ALTER TABLE public.images OWNER TO salva;

--
-- TOC entry 231 (class 1259 OID 24674)
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.images ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 24608)
-- Name: modalities; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.modalities (
    id bigint NOT NULL,
    moda_name character varying(50) NOT NULL,
    moda_description character varying(200) DEFAULT NULL::character varying
);


ALTER TABLE public.modalities OWNER TO salva;

--
-- TOC entry 221 (class 1259 OID 24607)
-- Name: modalities_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.modalities ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.modalities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 24581)
-- Name: patients; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.patients (
    id bigint NOT NULL,
    pati_first_name character varying(30) NOT NULL,
    pati_last_name character varying(30) NOT NULL,
    pati_birth_date date NOT NULL,
    pati_gender character(1) DEFAULT NULL::bpchar,
    pati_address character varying(100) DEFAULT NULL::character varying,
    pati_phone character varying(13) DEFAULT NULL::character varying,
    pati_email character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.patients OWNER TO salva;

--
-- TOC entry 239 (class 1259 OID 32778)
-- Name: patients_audit; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.patients_audit (
    audit_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    actionpatient public.patients_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.patients_audit OWNER TO salva;

--
-- TOC entry 238 (class 1259 OID 32777)
-- Name: patients_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.patients_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.patients_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 24580)
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.patients ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 24706)
-- Name: payments; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    paym_appointment_id bigint NOT NULL,
    paym_amount numeric(10,0) NOT NULL,
    paym_date timestamp without time zone NOT NULL,
    paym_method character varying(30) NOT NULL
);


ALTER TABLE public.payments OWNER TO salva;

--
-- TOC entry 241 (class 1259 OID 40976)
-- Name: payments_audit; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.payments_audit (
    audit_id bigint NOT NULL,
    payment_id bigint NOT NULL,
    actionpayment public.payments_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.payments_audit OWNER TO salva;

--
-- TOC entry 240 (class 1259 OID 40975)
-- Name: payments_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.payments_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.payments_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 24705)
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.payments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 24686)
-- Name: reports; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.reports (
    id bigint NOT NULL,
    repo_study_id bigint NOT NULL,
    repo_text text NOT NULL,
    repo_creation_date timestamp without time zone NOT NULL,
    repo_doctor_id bigint NOT NULL
);


ALTER TABLE public.reports OWNER TO salva;

--
-- TOC entry 233 (class 1259 OID 24685)
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.reports ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 24644)
-- Name: studies; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.studies (
    id bigint NOT NULL,
    stud_patient_id bigint NOT NULL,
    stud_doctor_id bigint NOT NULL,
    stud_modality_id bigint NOT NULL,
    stud_equipment_id bigint NOT NULL,
    stud_appointment_id bigint NOT NULL,
    stud_date timestamp without time zone NOT NULL,
    stud_status character varying(20) NOT NULL
);


ALTER TABLE public.studies OWNER TO salva;

--
-- TOC entry 243 (class 1259 OID 41006)
-- Name: studies_audit; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.studies_audit (
    audit_id bigint NOT NULL,
    study_id bigint NOT NULL,
    actionstudy public.studies_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.studies_audit OWNER TO salva;

--
-- TOC entry 242 (class 1259 OID 41005)
-- Name: studies_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.studies_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.studies_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 24643)
-- Name: studies_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.studies ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 24716)
-- Name: study_tags; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.study_tags (
    stta_study_id bigint NOT NULL,
    stta_tag_id bigint NOT NULL
);


ALTER TABLE public.study_tags OWNER TO salva;

--
-- TOC entry 226 (class 1259 OID 24624)
-- Name: tags; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    tag_name character varying(50) NOT NULL,
    tag_description character varying(150) DEFAULT NULL::character varying
);


ALTER TABLE public.tags OWNER TO salva;

--
-- TOC entry 225 (class 1259 OID 24623)
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.tags ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 24600)
-- Name: technologists; Type: TABLE; Schema: public; Owner: salva
--

CREATE TABLE public.technologists (
    id bigint NOT NULL,
    tech_first_name character varying(100) NOT NULL,
    tech_last_name character varying(100) NOT NULL,
    tech_phone character varying(13) DEFAULT NULL::character varying,
    tech_email character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.technologists OWNER TO salva;

--
-- TOC entry 219 (class 1259 OID 24599)
-- Name: technologists_id_seq; Type: SEQUENCE; Schema: public; Owner: salva
--

ALTER TABLE public.technologists ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.technologists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3601 (class 0 OID 24632)
-- Dependencies: 228
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.appointments (id, appo_patient_id, appo_date, appo_status) FROM stdin;
101	101	2024-01-15 08:30:00	Scheduled
102	102	2024-01-15 09:00:00	Completed
103	103	2024-01-15 09:30:00	Scheduled
104	104	2024-01-15 10:00:00	Cancelled
105	105	2024-01-15 10:30:00	Scheduled
106	106	2024-01-15 11:00:00	Completed
107	107	2024-01-15 11:30:00	Scheduled
108	108	2024-01-15 12:00:00	Scheduled
109	109	2024-01-15 12:30:00	Cancelled
110	110	2024-01-15 13:00:00	Scheduled
111	111	2024-01-15 13:30:00	Completed
112	112	2024-01-15 14:00:00	Scheduled
113	113	2024-01-15 14:30:00	Scheduled
114	114	2024-01-15 15:00:00	Cancelled
115	115	2024-01-15 15:30:00	Scheduled
116	116	2024-01-15 16:00:00	Completed
117	117	2024-01-15 16:30:00	Scheduled
118	118	2024-01-15 17:00:00	Scheduled
119	119	2024-01-15 17:30:00	Cancelled
120	120	2024-01-15 18:00:00	Scheduled
121	121	2024-01-16 08:00:00	Scheduled
122	122	2024-01-16 08:30:00	Completed
123	123	2024-01-16 09:00:00	Scheduled
124	124	2024-01-16 09:30:00	Cancelled
125	125	2024-01-16 10:00:00	Scheduled
126	126	2024-01-16 10:30:00	Completed
127	127	2024-01-16 11:00:00	Scheduled
128	128	2024-01-16 11:30:00	Scheduled
129	129	2024-01-16 12:00:00	Cancelled
130	130	2024-01-16 12:30:00	Scheduled
131	131	2024-01-16 13:00:00	Completed
132	132	2024-01-16 13:30:00	Scheduled
133	133	2024-01-16 14:00:00	Scheduled
134	134	2024-01-16 14:30:00	Cancelled
135	135	2024-01-16 15:00:00	Scheduled
136	136	2024-01-16 15:30:00	Completed
137	137	2024-01-16 16:00:00	Scheduled
138	138	2024-01-16 16:30:00	Scheduled
139	139	2024-01-16 17:00:00	Cancelled
140	140	2024-01-16 17:30:00	Scheduled
141	141	2024-01-17 08:00:00	Scheduled
142	142	2024-01-17 08:30:00	Completed
143	143	2024-01-17 09:00:00	Scheduled
144	144	2024-01-17 09:30:00	Cancelled
145	145	2024-01-17 10:00:00	Scheduled
146	146	2024-01-17 10:30:00	Completed
147	147	2024-01-17 11:00:00	Scheduled
148	148	2024-01-17 11:30:00	Scheduled
149	149	2024-01-17 12:00:00	Cancelled
150	150	2024-01-17 12:30:00	Scheduled
151	151	2024-01-17 13:00:00	Completed
152	152	2024-01-17 13:30:00	Scheduled
153	153	2024-01-17 14:00:00	Scheduled
154	154	2024-01-17 14:30:00	Cancelled
155	155	2024-01-17 15:00:00	Scheduled
156	156	2024-01-17 15:30:00	Completed
157	157	2024-01-17 16:00:00	Scheduled
158	158	2024-01-17 16:30:00	Scheduled
159	159	2024-01-17 17:00:00	Cancelled
160	160	2024-01-17 17:30:00	Scheduled
161	161	2024-01-18 08:00:00	Scheduled
162	162	2024-01-18 08:30:00	Completed
163	163	2024-01-18 09:00:00	Scheduled
164	164	2024-01-18 09:30:00	Cancelled
165	165	2024-01-18 10:00:00	Scheduled
166	166	2024-01-18 10:30:00	Completed
167	167	2024-01-18 11:00:00	Scheduled
168	168	2024-01-18 11:30:00	Scheduled
169	169	2024-01-18 12:00:00	Cancelled
170	170	2024-01-18 12:30:00	Scheduled
171	171	2024-01-18 13:00:00	Completed
172	172	2024-01-18 13:30:00	Scheduled
173	173	2024-01-18 14:00:00	Scheduled
174	174	2024-01-18 14:30:00	Cancelled
175	175	2024-01-18 15:00:00	Scheduled
176	176	2024-01-18 15:30:00	Completed
177	177	2024-01-18 16:00:00	Scheduled
178	178	2024-01-18 16:30:00	Scheduled
179	179	2024-01-18 17:00:00	Cancelled
180	180	2024-01-18 17:30:00	Scheduled
181	181	2024-01-19 08:00:00	Scheduled
182	182	2024-01-19 08:30:00	Completed
183	183	2024-01-19 09:00:00	Scheduled
184	184	2024-01-19 09:30:00	Cancelled
185	185	2024-01-19 10:00:00	Scheduled
186	186	2024-01-19 10:30:00	Completed
187	187	2024-01-19 11:00:00	Scheduled
188	188	2024-01-19 11:30:00	Scheduled
189	189	2024-01-19 12:00:00	Cancelled
190	190	2024-01-19 12:30:00	Scheduled
191	191	2024-01-19 13:00:00	Completed
192	192	2024-01-19 13:30:00	Scheduled
193	193	2024-01-19 14:00:00	Scheduled
194	194	2024-01-19 14:30:00	Cancelled
195	195	2024-01-19 15:00:00	Scheduled
196	196	2024-01-19 15:30:00	Completed
197	197	2024-01-19 16:00:00	Scheduled
198	198	2024-01-19 16:30:00	Scheduled
199	199	2024-01-19 17:00:00	Cancelled
200	200	2024-01-19 17:30:00	Scheduled
\.


--
-- TOC entry 3591 (class 0 OID 24591)
-- Dependencies: 218
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.doctors (id, doct_first_name, doct_last_name, doct_specialty, doct_phone, doct_email) FROM stdin;
101	Carlos	Martínez	Cardiología	3101234567	carlos.martinez@clinic.com
102	Ana	Gómez	Pediatría	3112233445	ana.gomez@clinic.com
103	Luis	Rodríguez	Neurología	3123344556	luis.rodriguez@clinic.com
104	María	Fernández	Dermatología	3134455667	maria.fernandez@clinic.com
105	José	López	Medicina Interna	3145566778	jose.lopez@clinic.com
106	Paola	Torres	Ginecología	3156677889	paola.torres@clinic.com
107	Andrés	Ramírez	Ortopedia	3167788990	andres.ramirez@clinic.com
108	Marta	Castro	Oftalmología	3178899001	marta.castro@clinic.com
109	Fernando	Vargas	Psiquiatría	3189900112	fernando.vargas@clinic.com
110	Claudia	Pérez	Otorrinolaringología	3191001223	claudia.perez@clinic.com
111	Jorge	Moreno	Endocrinología	3202112334	jorge.moreno@clinic.com
112	Patricia	Gutiérrez	Reumatología	3213223445	patricia.gutierrez@clinic.com
113	Hernán	Suárez	Cirugía General	3224334556	hernan.suarez@clinic.com
114	Liliana	Cárdenas	Medicina Familiar	3235445667	liliana.cardenas@clinic.com
115	Camilo	Ortiz	Nefrología	3246556778	camilo.ortiz@clinic.com
116	Marcela	Ríos	Oncología	3257667889	marcela.rios@clinic.com
117	Ricardo	Jiménez	Neumología	3268778990	ricardo.jimenez@clinic.com
118	Sandra	Mendoza	Geriatría	3279889001	sandra.mendoza@clinic.com
119	Mauricio	Ardila	Hematología	3280990112	mauricio.ardila@clinic.com
120	Juliana	Salazar	Infectología	3291101223	juliana.salazar@clinic.com
121	Felipe	Acosta	Cardiología	3102109876	felipe.acosta@clinic.com
122	Natalia	Peña	Pediatría	3113210987	natalia.pena@clinic.com
123	Rodrigo	Mejía	Neurología	3124321098	rodrigo.mejia@clinic.com
124	Clara	Reyes	Dermatología	3135432109	clara.reyes@clinic.com
125	Oscar	Gil	Medicina Interna	3146543210	oscar.gil@clinic.com
126	Valeria	Ruiz	Ginecología	3157654321	valeria.ruiz@clinic.com
127	Santiago	Cruz	Ortopedia	3168765432	santiago.cruz@clinic.com
128	Carolina	Mora	Oftalmología	3179876543	carolina.mora@clinic.com
129	Esteban	Rangel	Psiquiatría	3180987654	esteban.rangel@clinic.com
130	Rosa	Fonseca	Otorrinolaringología	3191098765	rosa.fonseca@clinic.com
131	Diego	Guerrero	Endocrinología	3202109876	diego.guerrero@clinic.com
132	Isabel	Santos	Reumatología	3213210987	isabel.santos@clinic.com
133	Hugo	Cano	Cirugía General	3224321098	hugo.cano@clinic.com
134	Angela	Lozano	Medicina Familiar	3235432109	angela.lozano@clinic.com
135	Rafael	Beltrán	Nefrología	3246543210	rafael.beltran@clinic.com
136	Laura	Espinosa	Oncología	3257654321	laura.espinosa@clinic.com
137	Manuel	Perdomo	Neumología	3268765432	manuel.perdomo@clinic.com
138	Tatiana	Hoyos	Geriatría	3279876543	tatiana.hoyos@clinic.com
139	César	Martínez	Hematología	3280987654	cesar.martinez@clinic.com
140	Gloria	Silva	Infectología	3291098765	gloria.silva@clinic.com
141	Jorge	Camacho	Cardiología	3302109876	jorge.camacho@clinic.com
142	Viviana	Rojas	Pediatría	3313210987	viviana.rojas@clinic.com
143	Mauricio	Cifuentes	Neurología	3324321098	mauricio.cifuentes@clinic.com
144	Patricia	Vargas	Dermatología	3335432109	patricia.vargas@clinic.com
145	Guillermo	Ariza	Medicina Interna	3346543210	guillermo.ariza@clinic.com
146	Juliana	Castillo	Ginecología	3357654321	juliana.castillo@clinic.com
147	David	Moreno	Ortopedia	3368765432	david.moreno@clinic.com
148	Adriana	Valencia	Oftalmología	3379876543	adriana.valencia@clinic.com
149	Hernán	Torres	Psiquiatría	3380987654	hernan.torres@clinic.com
150	Sandra	Gómez	Otorrinolaringología	3391098765	sandra.gomez@clinic.com
151	Luis	Cardona	Endocrinología	3402109876	luis.cardona@clinic.com
152	Mónica	Salazar	Reumatología	3413210987	monica.salazar@clinic.com
153	Andrés	Ortiz	Cirugía General	3424321098	andres.ortiz@clinic.com
154	Beatriz	Navarro	Medicina Familiar	3435432109	beatriz.navarro@clinic.com
155	Camilo	Álvarez	Nefrología	3446543210	camilo.alvarez@clinic.com
156	Liliana	Morales	Oncología	3457654321	liliana.morales@clinic.com
157	Pedro	Quiroga	Neumología	3468765432	pedro.quiroga@clinic.com
158	Marcela	Martín	Geriatría	3479876543	marcela.martin@clinic.com
159	Fernando	Serrano	Hematología	3480987654	fernando.serrano@clinic.com
160	Claudia	Ávila	Infectología	3491098765	claudia.avila@clinic.com
161	Jorge	Camacho	Cardiología	3302109876	jorge.camacho@clinic.com
162	Viviana	Rojas	Pediatría	3313210987	viviana.rojas@clinic.com
163	Mauricio	Cifuentes	Neurología	3324321098	mauricio.cifuentes@clinic.com
164	Patricia	Vargas	Dermatología	3335432109	patricia.vargas@clinic.com
165	Guillermo	Ariza	Medicina Interna	3346543210	guillermo.ariza@clinic.com
166	Juliana	Castillo	Ginecología	3357654321	juliana.castillo@clinic.com
167	David	Moreno	Ortopedia	3368765432	david.moreno@clinic.com
168	Adriana	Valencia	Oftalmología	3379876543	adriana.valencia@clinic.com
169	Hernán	Torres	Psiquiatría	3380987654	hernan.torres@clinic.com
170	Sandra	Gómez	Otorrinolaringología	3391098765	sandra.gomez@clinic.com
171	Luis	Cardona	Endocrinología	3402109876	luis.cardona@clinic.com
172	Mónica	Salazar	Reumatología	3413210987	monica.salazar@clinic.com
173	Andrés	Ortiz	Cirugía General	3424321098	andres.ortiz@clinic.com
174	Beatriz	Navarro	Medicina Familiar	3435432109	beatriz.navarro@clinic.com
175	Camilo	Álvarez	Nefrología	3446543210	camilo.alvarez@clinic.com
176	Liliana	Morales	Oncología	3457654321	liliana.morales@clinic.com
177	Pedro	Quiroga	Neumología	3468765432	pedro.quiroga@clinic.com
178	Marcela	Martín	Geriatría	3479876543	marcela.martin@clinic.com
179	Fernando	Serrano	Hematología	3480987654	fernando.serrano@clinic.com
180	Claudia	Ávila	Infectología	3491098765	claudia.avila@clinic.com
181	Natalia	Morales	Cardiología	3702109876	natalia.morales@clinic.com
182	Santiago	Ramírez	Pediatría	3713210987	santiago.ramirez@clinic.com
183	Valentina	García	Neurología	3724321098	valentina.garcia@clinic.com
184	Mauricio	Pardo	Dermatología	3735432109	mauricio.pardo@clinic.com
185	Daniela	Ocampo	Medicina Interna	3746543210	daniela.ocampo@clinic.com
186	Felipe	Arango	Ginecología	3757654321	felipe.arango@clinic.com
187	Isabel	Quintero	Ortopedia	3768765432	isabel.quintero@clinic.com
188	Camilo	Hernández	Oftalmología	3779876543	camilo.hernandez@clinic.com
189	Adriana	Cruz	Psiquiatría	3780987654	adriana.cruz@clinic.com
190	Jorge	Valencia	Otorrinolaringología	3791098765	jorge.valencia@clinic.com
191	Carolina	Ortiz	Endocrinología	3802109876	carolina.ortiz@clinic.com
192	Pedro	Ríos	Reumatología	3813210987	pedro.rios@clinic.com
193	Liliana	Castaño	Cirugía General	3824321098	liliana.castano@clinic.com
194	Manuel	Torres	Medicina Familiar	3835432109	manuel.torres@clinic.com
195	Gloria	Pérez	Nefrología	3846543210	gloria.perez@clinic.com
196	Fernando	Camacho	Oncología	3857654321	fernando.camacho@clinic.com
197	Ana	Beltrán	Neumología	3868765432	ana.beltran@clinic.com
198	David	Salazar	Geriatría	3879876543	david.salazar@clinic.com
199	Lorena	Mejía	Hematología	3880987654	lorena.mejia@clinic.com
200	Andrés	Córdoba	Infectología	3891098765	andres.cordoba@clinic.com
\.


--
-- TOC entry 3597 (class 0 OID 24615)
-- Dependencies: 224
-- Data for Name: equipments; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.equipments (id, equi_name, equi_brand, equi_model, equi_location) FROM stdin;
1	Tomógrafo Multicorte	Siemens	Somatom Go	Sede Central - Radiología
2	Resonador Magnético	Philips	Ingenia 1.5T	Sede Norte - Resonancia
3	Rayos X Digital	GE Healthcare	Definium 8000	Sede Central - Sala RX 1
4	Rayos X Portátil	Fujifilm	FDR Nano	Hospitalización Piso 2
5	Mamógrafo Digital	Hologic	Selenia Dimensions	Sede Central - Mamografía
6	Ecógrafo Convencional	Mindray	DC-70	Sede Sur - Ecografía
7	Ecógrafo Doppler	Samsung Medison	HS70A	Sede Central - Ecografía
8	Ecógrafo Portátil	SonoSite	Edge II	Urgencias
9	Arco en C	Ziehm Imaging	Vision RFD	Quirófano 1
10	Densitómetro Óseo	GE Healthcare	Lunar iDXA	Sede Central - Densitometría
11	Equipo de Fluoroscopia	Philips	Allura Xper FD20	Sede Central - Hemodinamia
12	Scanner PET-CT	Siemens	Biograph mCT	Sede Central - Medicina Nuclear
13	Cámara Gamma	GE Healthcare	Discovery NM630	Sede Central - Medicina Nuclear
14	Equipo de Radiología Dental	Planmeca	ProMax 3D	Sede Odontología
15	Equipo Panorámico Dental	Carestream	CS 8100	Sede Odontología
16	Rayos X Pediátrico	Fujifilm	FDR D-EVO III	Pediatría - RX
17	Rayos X Móvil	Philips	MobileDiagnost wDR	UCI
18	Equipo de Angiografía	Siemens	Artis Zee	Sede Central - Hemodinamia
19	Tomógrafo Cardiaco	Canon Medical	Aquilion ONE	Sede Norte - Cardiología
20	Resonador 3T	GE Healthcare	Signa Pioneer 3T	Sede Central - Resonancia
21	Ecógrafo Obstétrico	Alpinion	E-CUBE 15	Sede Sur - Ecografía
22	Ecógrafo Vascular	Hitachi	Arietta 850	Sede Central - Ecografía
23	Ecógrafo General	Philips	Affiniti 70	Sede Norte - Ecografía
24	Mamógrafo Analógico	Siemens	Mammomat Select	Sede Sur - Mamografía
25	Equipo de TAC Pediátrico	GE Healthcare	Revolution EVO	Pediatría - TAC
26	Equipo RX de Columna	Canon Medical	Radrex-i	Sede Central - Radiología
27	Equipo RX de Tórax	Philips	DigitalDiagnost C50	Sede Central - Radiología
28	Equipo RX de Abdomen	Carestream	DRX-Evolution	Sede Sur - Radiología
29	Resonador Abierto	Hitachi	Oasis 1.2T	Sede Central - Resonancia
30	Scanner PET	GE Healthcare	Discovery PET/CT 710	Sede Central - Medicina Nuclear
31	Rayos X Veterinario	Fujifilm	Vet Digital X-Ray	Área Experimental
32	Ecógrafo Cardíaco	Philips	EPIQ 7	Sede Central - Cardiología
33	Ecógrafo Neonatal	Samsung Medison	UGEO PT60A	Neonatología
34	Ecógrafo Portátil	Mindray	M7	Urgencias Pediátricas
35	Ecógrafo General	SonoScape	P50	Sede Sur - Ecografía
36	Tomógrafo Dental	Planmeca	ProMax 3D Classic	Sede Odontología
37	Rayos X Digital	Carestream	DRX-Compass	Sede Norte - Radiología
38	Equipo de RX Digital	Siemens	Ysio Max	Sede Central - Radiología
39	Resonador Portátil	Hyperfine	Swoop Portable MRI	UCI
40	Equipo de TAC de Urgencias	Canon Medical	Aquilion Lightning	Urgencias
41	Rayos X de Ortopedia	GE Healthcare	Optima XR646	Trauma-Ortopedia
42	Equipo RX de Cráneo	Philips	DigitalDiagnost C90	Neuroimágenes
43	Ecógrafo Pediátrico	Alpinion	E-CUBE i7	Pediatría
44	Ecógrafo Musculoesquelético	Esaote	MyLab X8	Traumatología
45	Ecógrafo Abdominal	Samsung Medison	RS80A	Sede Central - Ecografía
46	Equipo TAC Oncológico	GE Healthcare	Discovery IQ	Sede Oncología
47	Equipo RX Panorámico	Vatech	PaX-i3D	Sede Odontología
48	Mamógrafo Digital	Siemens	Mammomat Inspiration	Sede Norte - Mamografía
49	Equipo RX General	Philips	Diagnost C	Sede Sur - Radiología
50	Ecógrafo Cardíaco	Hitachi	Lisendo 880	Sede Central - Cardiología
51	Ecógrafo Portátil	Fujifilm	SonoSite iViz	Ambulancia 1
52	Equipo RX de Columna	Canon Medical	Radrex-i Plus	Sede Central - Radiología
53	Resonador Magnético	Philips	Achieva 1.5T	Sede Sur - Resonancia
54	Tomógrafo Multicorte	GE Healthcare	Revolution CT	Sede Central - TAC
55	Equipo de Fluoroscopia	Siemens	Luminos Agile Max	Sede Norte - Radiología
56	Mamógrafo Digital	GE Healthcare	Senographe Pristina	Sede Central - Mamografía
57	Ecógrafo General	Philips	ClearVue 850	Sede Norte - Ecografía
58	Rayos X Portátil	Carestream	DRX-Revolution	Urgencias
59	Arco en C	GE Healthcare	OEC Elite	Quirófano 3
60	Densitómetro Óseo	Hologic	Discovery Wi	Sede Central - Densitometría
61	Ecógrafo Doppler	Hitachi	Arietta 65	Sede Sur - Ecografía
62	Equipo RX Pediátrico	Fujifilm	FDR D-EVO GL	Pediatría - RX
63	Rayos X Móvil	Philips	MobileDiagnost Opta	Hospitalización Piso 3
64	Ecógrafo Vascular	Samsung Medison	HS40	Sede Central - Ecografía
65	Equipo RX de Abdomen	GE Healthcare	Optima XR240amx	Urgencias
66	Equipo TAC Pediátrico	Canon Medical	Aquilion Prime SP	Pediatría
67	Ecógrafo Obstétrico	Philips	Affiniti 50	Sede Sur - Ginecología
68	Ecógrafo Cardíaco	Siemens	Acuson SC2000	Sede Central - Cardiología
69	Equipo RX Digital	Carestream	DRX-Revolution Nano	UCI
70	Resonador Abierto	Esaote	G-Scan Brio	Sede Central - Resonancia
71	Rayos X General	GE Healthcare	Definium Tempo	Sede Norte - Radiología
72	Equipo TAC Cardiaco	Philips	IQon Spectral CT	Sede Cardiología
73	Equipo RX de Cráneo	Canon Medical	Radrex-i Standard	Sede Central - Radiología
74	Ecógrafo Neonatal	Samsung Medison	UGEO PT30	Neonatología
75	Tomógrafo Dental	Vatech	Green CT 2	Sede Odontología
76	Ecógrafo Musculoesquelético	Philips	EPIQ CVx	Traumatología
77	Rayos X Portátil	Fujifilm	FDR Portable	Ambulancia 2
78	Ecógrafo General	Mindray	DC-80A	Sede Central - Ecografía
79	Equipo de Radiología Dental	Carestream	CS 9300	Sede Odontología
80	Equipo RX Digital	Philips	DigitalDiagnost C50 Plus	Sede Sur - Radiología
81	Scanner PET-CT	GE Healthcare	Discovery MI	Sede Central - Medicina Nuclear
82	Rayos X Pediátrico	Siemens	Multix Impact	Pediatría - RX
83	Ecógrafo Obstétrico	Hitachi	Arietta 750	Sede Sur - Ginecología
84	Rayos X General	Philips	Diagnost C90	Sede Central - Radiología
85	Resonador Magnético	Canon Medical	Vantage Orian 1.5T	Sede Norte - Resonancia
86	Equipo TAC Oncológico	Siemens	Biograph Vision	Sede Oncología
87	Ecógrafo Portátil	SonoSite	NanoMaxx	Urgencias Pediátricas
88	Mamógrafo Digital	Fujifilm	Amulet Innovality	Sede Norte - Mamografía
89	Rayos X Veterinario	Canon Medical	CXDI Veterinary	Área Experimental
90	Equipo RX Digital	GE Healthcare	Optima XR646 Pro	Sede Central - Radiología
91	Ecógrafo Abdominal	Philips	EPIQ Elite	Sede Central - Ecografía
92	Rayos X de Columna	Siemens	Multix Fusion Max	Sede Central - Radiología
93	Ecógrafo Cardíaco	Samsung Medison	RS85 Prestige	Sede Central - Cardiología
94	Resonador 3T	Philips	Ingenia Elition 3T	Sede Central - Resonancia
95	Equipo RX Panorámico	Carestream	CS 8100 3D	Sede Odontología
96	Equipo TAC Urgencias	GE Healthcare	Revolution Maxima	Urgencias
97	Ecógrafo General	Alpinion	E-CUBE 8	Sede Sur - Ecografía
98	Equipo RX General	Fujifilm	FDR Clinica	Sede Sur - Radiología
99	Ecógrafo Neonatal	Philips	InnoSight	Neonatología
100	Estación de Trabajo PACS	Barco	Nio 5MP	Sede Central - Post-Procesamiento
\.


--
-- TOC entry 3605 (class 0 OID 24675)
-- Dependencies: 232
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.images (id, imag_study_id, imag_date) FROM stdin;
1	151	2023-03-01 09:30:00
2	152	2023-03-02 10:40:00
3	153	2023-03-03 11:15:00
4	154	2023-03-04 12:00:00
5	155	2023-03-05 14:25:00
6	156	2023-03-06 09:50:00
7	157	2023-03-07 10:35:00
8	158	2023-03-08 11:20:00
9	159	2023-03-09 15:05:00
10	160	2023-03-10 09:15:00
11	161	2023-03-11 10:45:00
12	162	2023-03-12 12:10:00
13	163	2023-03-13 13:30:00
14	164	2023-03-14 14:50:00
15	165	2023-03-15 09:35:00
16	166	2023-03-16 11:00:00
17	167	2023-03-17 12:25:00
18	168	2023-03-18 13:10:00
19	169	2023-03-19 14:00:00
20	170	2023-03-20 09:20:00
21	171	2023-03-21 10:30:00
22	172	2023-03-22 11:45:00
23	173	2023-03-23 12:50:00
24	174	2023-03-24 13:35:00
25	175	2023-03-25 14:15:00
26	176	2023-03-26 09:40:00
27	177	2023-03-27 10:25:00
28	178	2023-03-28 11:30:00
29	179	2023-03-29 12:05:00
30	180	2023-03-30 13:20:00
31	181	2023-03-31 09:55:00
32	182	2023-04-01 10:40:00
33	183	2023-04-02 12:00:00
34	184	2023-04-03 13:10:00
35	185	2023-04-04 14:20:00
36	186	2023-04-05 09:45:00
37	187	2023-04-06 11:25:00
38	188	2023-04-07 12:50:00
39	189	2023-04-08 13:30:00
40	190	2023-04-09 14:05:00
41	191	2023-04-10 09:30:00
42	192	2023-04-11 10:20:00
43	193	2023-04-12 11:40:00
44	194	2023-04-13 12:55:00
45	195	2023-04-14 13:25:00
46	196	2023-04-15 14:40:00
47	197	2023-04-16 09:50:00
48	198	2023-04-17 10:55:00
49	199	2023-04-18 12:10:00
50	200	2023-04-19 13:15:00
51	201	2023-04-20 09:30:00
52	202	2023-04-21 10:35:00
53	203	2023-04-22 11:25:00
54	204	2023-04-23 12:40:00
55	205	2023-04-24 13:55:00
56	206	2023-04-25 14:15:00
57	207	2023-04-26 09:20:00
58	208	2023-04-27 10:45:00
59	209	2023-04-28 11:50:00
60	210	2023-04-29 13:05:00
61	211	2023-04-30 14:25:00
62	212	2023-05-01 09:10:00
63	213	2023-05-02 10:30:00
64	214	2023-05-03 11:40:00
65	215	2023-05-04 12:55:00
66	216	2023-05-05 14:00:00
67	217	2023-05-06 09:25:00
68	218	2023-05-07 10:35:00
69	219	2023-05-08 11:45:00
70	220	2023-05-09 13:00:00
71	221	2023-05-10 14:20:00
72	222	2023-05-11 09:15:00
73	223	2023-05-12 10:40:00
74	224	2023-05-13 11:30:00
75	225	2023-05-14 12:45:00
76	226	2023-05-15 14:05:00
77	227	2023-05-16 09:35:00
78	228	2023-05-17 10:50:00
79	229	2023-05-18 12:00:00
80	230	2023-05-19 13:10:00
81	231	2023-05-20 14:30:00
82	232	2023-05-21 09:40:00
83	233	2023-05-22 10:55:00
84	234	2023-05-23 12:05:00
85	235	2023-05-24 13:25:00
86	236	2023-05-25 14:15:00
87	237	2023-05-26 09:50:00
88	238	2023-05-27 11:00:00
89	239	2023-05-28 12:20:00
90	240	2023-05-29 13:35:00
91	241	2023-05-30 14:10:00
92	242	2023-05-31 09:30:00
93	243	2023-06-01 10:45:00
94	244	2023-06-02 11:55:00
95	245	2023-06-03 12:40:00
96	246	2023-06-04 13:20:00
97	247	2023-06-05 14:35:00
98	248	2023-06-06 09:25:00
99	249	2023-06-07 10:50:00
100	250	2023-06-08 12:15:00
\.


--
-- TOC entry 3595 (class 0 OID 24608)
-- Dependencies: 222
-- Data for Name: modalities; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.modalities (id, moda_name, moda_description) FROM stdin;
1	RX	Radiografía convencional para diagnóstico general
2	TC	Tomografía computarizada con múltiples cortes
3	RM	Resonancia magnética de alta resolución
4	US	Ecografía para estudios de tejidos blandos
5	MG	Mamografía para detección temprana de cáncer de mama
6	PET	Tomografía por emisión de positrones
7	SPECT	Tomografía computarizada por emisión de fotón único
8	DXA	Densitometría ósea para medir la densidad mineral
9	ANGIO	Angiografía por rayos X con contraste
10	FLUORO	Fluoroscopia dinámica en tiempo real
11	CT-CARD	Tomografía cardíaca especializada
12	MR-NEURO	Resonancia magnética para estudios neurológicos
13	US-DOPPLER	Ecografía Doppler para vasos sanguíneos
14	MAMO-3D	Mamografía digital en 3D
15	XR-CHEST	Radiografía de tórax especializada
16	XR-DENTAL	Radiografía dental panorámica
17	CT-TRAUMA	Tomografía para estudios de trauma
18	XR-ORTHO	Radiografía ortopédica
19	US-OBST	Ecografía obstétrica
20	MR-ABD	Resonancia magnética abdominal
21	CT-LUNG	Tomografía para evaluación pulmonar
22	XR-SPINE	Radiografía de columna completa
23	US-CARD	Ecocardiografía para estudios del corazón
24	MR-MSK	Resonancia magnética músculo-esquelética
25	CT-HEAD	Tomografía craneal de urgencia
26	XR-ABDOMEN	Radiografía abdominal simple
27	PET-CT	Tomografía combinada PET con TC
28	US-THYROID	Ecografía de tiroides
29	CT-ANGIO	Angiografía por tomografía computarizada
30	MR-ANGIO	Angiografía por resonancia magnética
31	XR-HAND	Radiografía de manos
32	US-BREAST	Ecografía mamaria complementaria
33	CT-ORTHO	Tomografía ortopédica
34	MR-SPINE	Resonancia magnética de columna
35	XR-SKULL	Radiografía de cráneo
36	CT-SINUS	Tomografía de senos paranasales
37	US-ABDOMEN	Ecografía abdominal
38	DXA-WHOLE	Densitometría ósea de cuerpo entero
39	XR-FOOT	Radiografía de pie
40	MR-CARD	Resonancia magnética cardíaca
41	XR-SHOULDER	Radiografía de hombro
42	CT-LIVER	Tomografía para estudio hepático
43	US-OBST	Ecografía obstétrica 2D/3D
44	MR-BRAIN	Resonancia magnética cerebral
45	XR-CHEST-LAT	Radiografía de tórax en proyección lateral
46	CT-PELVIS	Tomografía de pelvis
47	US-KIDNEY	Ecografía renal
48	MR-KNEE	Resonancia magnética de rodilla
49	XR-ELBOW	Radiografía de codo
50	US-VASC	Ecografía doppler vascular
51	CT-TRAUMA	Tomografía en trauma múltiple
52	MR-ABDOMEN	Resonancia magnética abdominal
53	XR-RIBS	Radiografía de costillas
54	US-PROSTATE	Ecografía de próstata transrectal
55	CT-CARD	Tomografía cardíaca multidetector
56	MR-PELVIS	Resonancia magnética pélvica
57	XR-WRIST	Radiografía de muñeca
58	US-GALL	Ecografía de vesícula biliar
59	CT-NECK	Tomografía cervical
60	MR-HEAD	Resonancia magnética de cabeza
61	XR-FOOT	Radiografía de pie
62	CT-ABDOMEN-PELVIS	Tomografía de abdomen y pelvis
63	US-NECK	Ecografía de cuello
64	MR-SPINE-LUMBAR	Resonancia lumbar de columna
65	XR-HAND	Radiografía de mano
66	CT-HEAD-TRAUMA	Tomografía craneal por trauma
67	US-PRENATAL	Ecografía prenatal morfológica
68	MR-HIP	Resonancia magnética de cadera
69	XR-SCOLIOSIS	Radiografía panorámica de columna
70	US-CAROTID	Doppler carotídeo
71	CT-SINUS	Tomografía de senos paranasales
72	MR-ORBIT	Resonancia magnética de órbitas
73	XR-FACE	Radiografía de cara
74	US-BREAST	Ecografía de mama
75	CT-EXTREMITY	Tomografía de extremidades
76	MR-ANKLE	Resonancia magnética de tobillo
77	XR-PELVIS	Radiografía de pelvis ósea
78	US-LIVER	Ecografía hepática
79	CT-SPINE-CERVICAL	Tomografía de columna cervical
80	MR-CHEST	Resonancia magnética de tórax
81	XR-CHEST-LAT	Radiografía de tórax en proyección lateral
82	CT-KIDNEY	Tomografía de riñones
83	US-PELVIS	Ecografía pélvica
84	MR-FOOT	Resonancia magnética de pie
85	XR-ABDOMEN	Radiografía simple de abdomen
86	CT-ANGIO-BRAIN	Angiotomografía cerebral
87	US-THYROID	Ecografía de tiroides
88	MR-HAND	Resonancia magnética de mano
89	XR-KNEE	Radiografía de rodilla
90	CT-ANGIO-THORAX	Angiotomografía de tórax
91	US-BLADDER	Ecografía vesical
92	MR-SHOULDER	Resonancia magnética de hombro
93	XR-FOREARM	Radiografía de antebrazo
94	CT-ANGIO-NECK	Angiotomografía de cuello
95	US-ABDOMINAL-COMPLETE	Ecografía abdominal completa
96	MR-ELBOW	Resonancia magnética de codo
97	XR-SKULL-LAT	Radiografía lateral de cráneo
98	CT-ANGIO-LOWER-LIMB	Angiotomografía de miembros inferiores
99	US-RENAL	Ecografía renal
100	MR-FULL-SPINE	Resonancia magnética total de columna
\.


--
-- TOC entry 3589 (class 0 OID 24581)
-- Dependencies: 216
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.patients (id, pati_first_name, pati_last_name, pati_birth_date, pati_gender, pati_address, pati_phone, pati_email) FROM stdin;
102	Juan	Pérez	1978-02-03	M	Av. 3 #45-67	3012345678	juan.perez@mail.com
103	Ana	López	1995-09-10	F	Calle 50 #20-12	3205554321	ana.lopez@mail.com
104	Luis	Martínez	1982-11-22	M	Carrera 7 #89-34	3151234567	luis.martinez@mail.com
105	Laura	Hernández	1998-01-15	F	Calle 22 #7-45	3118765432	laura.hernandez@mail.com
106	Andrés	Torres	1987-05-18	M	Carrera 19 #6-11	3002345678	andres.torres@mail.com
107	Sofía	Jiménez	1993-08-29	F	Av. 30 #10-22	3216549870	sofia.jimenez@mail.com
108	Pedro	Castro	1975-03-14	M	Calle 15 #2-50	3123456789	pedro.castro@mail.com
109	Camila	Vargas	2000-06-07	F	Carrera 14 #18-90	3008765432	camila.vargas@mail.com
110	Jorge	Moreno	1983-12-30	M	Calle 60 #30-12	3101239876	jorge.moreno@mail.com
111	Daniela	Ortiz	1991-04-02	F	Carrera 21 #9-56	3222345678	daniela.ortiz@mail.com
112	Felipe	Guzmán	1986-07-19	M	Av. 5 #44-21	3015556789	felipe.guzman@mail.com
113	Valentina	Rojas	1999-10-13	F	Calle 40 #12-09	3112223344	valentina.rojas@mail.com
114	Héctor	Suárez	1977-01-28	M	Carrera 33 #15-67	3134567890	hector.suarez@mail.com
115	Paula	Mendoza	1994-11-11	F	Av. 6 #70-45	3201234567	paula.mendoza@mail.com
116	Ricardo	Pineda	1989-08-23	M	Calle 100 #45-89	3149876543	ricardo.pineda@mail.com
117	Isabella	Cárdenas	1997-02-14	F	Carrera 4 #22-56	3023456789	isabella.cardenas@mail.com
118	Mateo	Salazar	1984-05-05	M	Calle 77 #13-20	3128765432	mateo.salazar@mail.com
119	Gabriela	Peña	1992-09-17	F	Carrera 50 #8-34	3001234567	gabriela.pena@mail.com
120	Sebastián	Navarro	1981-03-21	M	Calle 12 #45-11	3204567890	sebastian.navarro@mail.com
121	Natalia	Peralta	1996-07-09	F	Carrera 25 #7-80	3116785432	natalia.peralta@mail.com
122	Tomás	Valencia	1988-10-30	M	Av. 40 #20-45	3002341234	tomas.valencia@mail.com
123	Lucía	Mejía	1993-01-06	F	Calle 9 #12-67	3158765432	lucia.mejia@mail.com
124	Alejandro	Quintero	1979-12-12	M	Carrera 6 #33-22	3024567890	alejandro.quintero@mail.com
125	Carolina	Bermúdez	1991-05-19	F	Calle 33 #15-78	3123456780	carolina.bermudez@mail.com
126	Diego	Arango	1986-08-27	M	Av. 15 #4-56	3208765432	diego.arango@mail.com
127	Juliana	Cardona	1995-02-03	F	Carrera 80 #23-10	3012349876	juliana.cardona@mail.com
128	Mauricio	Bedoya	1983-09-18	M	Calle 50 #9-12	3107654321	mauricio.bedoya@mail.com
129	Estefanía	Gallego	1998-11-22	F	Carrera 7 #18-45	3132345678	estefania.gallego@mail.com
130	Samuel	Zapata	1987-04-07	M	Av. 22 #56-78	3113456789	samuel.zapata@mail.com
131	Mónica	Serna	1994-12-25	F	Calle 19 #22-90	3029876543	monica.serna@mail.com
132	Óscar	Giraldo	1982-06-15	M	Carrera 3 #45-67	3003456789	oscar.giraldo@mail.com
133	Vanessa	Cuesta	1999-09-03	F	Calle 11 #5-67	3102223344	vanessa.cuesta@mail.com
134	Cristian	Beltrán	1985-01-27	M	Av. 9 #60-12	3141234567	cristian.beltran@mail.com
135	Alejandra	Rincón	1992-08-14	F	Carrera 10 #44-32	3209876543	alejandra.rincon@mail.com
136	Fernando	Cruz	1976-03-09	M	Calle 8 #14-21	3136785432	fernando.cruz@mail.com
137	Daniela	Parra	1997-07-21	F	Av. 33 #22-12	3008765123	daniela.parra@mail.com
138	Manuel	Lagos	1989-10-05	M	Carrera 60 #77-34	3017654321	manuel.lagos@mail.com
139	Tatiana	Rivera	1995-02-28	F	Calle 100 #8-12	3154567890	tatiana.rivera@mail.com
140	Laura	Martínez	1996-05-12	F	Calle 22 #8-91	3207654321	laura.martinez@mail.com
141	Julián	Salcedo	1984-09-03	M	Carrera 18 #34-56	3119876543	julian.salcedo@mail.com
142	Paula	Moreno	1993-02-18	F	Av. 30 #10-23	3028765432	paula.moreno@mail.com
143	Andrés	Torres	1979-11-27	M	Calle 44 #56-78	3001234567	andres.torres@mail.com
144	Sofía	Arévalo	1997-07-15	F	Carrera 6 #22-45	3137654321	sofia.arevalo@mail.com
145	Camilo	Jiménez	1985-01-05	M	Av. 19 #11-12	3149876543	camilo.jimenez@mail.com
146	Valentina	Rojas	1994-04-21	F	Calle 80 #33-14	3202345678	valentina.rojas@mail.com
147	Felipe	Sánchez	1982-12-09	M	Carrera 13 #9-80	3108765432	felipe.sanchez@mail.com
148	Isabella	Ramírez	1998-08-02	F	Av. 45 #12-77	3021234567	isabella.ramirez@mail.com
149	Mateo	Castro	1991-03-26	M	Calle 60 #22-19	3016785432	mateo.castro@mail.com
150	Gabriela	Reyes	1987-10-11	F	Carrera 2 #34-10	3158765123	gabriela.reyes@mail.com
151	Ricardo	Vásquez	1978-06-23	M	Av. 12 #44-55	3123450987	ricardo.vasquez@mail.com
152	Adriana	Guzmán	1995-09-14	F	Calle 18 #23-45	3118765432	adriana.guzman@mail.com
153	Esteban	Ortega	1989-02-28	M	Carrera 99 #12-33	3006543210	esteban.ortega@mail.com
154	Mariana	Castaño	1992-05-09	F	Av. 7 #66-90	3134567890	mariana.castano@mail.com
155	Álvaro	Peña	1983-01-22	M	Calle 100 #7-13	3109988776	alvaro.pena@mail.com
156	Sara	Ruiz	1996-07-30	F	Carrera 12 #44-20	3026785432	sara.ruiz@mail.com
157	Hernán	Roldán	1975-04-18	M	Av. 11 #90-11	3151234567	hernan.roldan@mail.com
158	Camila	Montoya	1999-12-01	F	Calle 45 #22-88	3208765432	camila.montoya@mail.com
159	Leonardo	Herrera	1980-08-19	M	Carrera 8 #15-55	3012345678	leonardo.herrera@mail.com
160	Natalia	Bermúdez	1993-11-15	F	Calle 20 #17-23	3105557890	natalia.bermudez@mail.com
161	Mauricio	Rincón	1981-02-07	M	Carrera 45 #12-70	3134445566	mauricio.rincon@mail.com
162	Lucía	Fajardo	1997-06-30	F	Av. 9 #77-11	3208765098	lucia.fajardo@mail.com
163	Óscar	Villalba	1979-09-22	M	Calle 55 #13-40	3021122334	oscar.villalba@mail.com
164	Verónica	Gallego	1990-03-14	F	Carrera 7 #65-21	3117778899	veronica.gallego@mail.com
165	Iván	Restrepo	1986-01-29	M	Av. 14 #23-50	3009988775	ivan.restrepo@mail.com
166	Manuela	Patiño	1995-10-06	F	Calle 90 #18-70	3153344556	manuela.patino@mail.com
167	Diego	Acevedo	1983-04-25	M	Carrera 30 #55-10	3106677889	diego.acevedo@mail.com
168	Daniela	Quintero	1999-07-03	F	Av. 33 #100-15	3132211445	daniela.quintero@mail.com
169	Jorge	Pineda	1977-12-11	M	Calle 14 #88-20	3204455667	jorge.pineda@mail.com
170	Tatiana	Gómez	1992-05-19	F	Carrera 6 #44-60	3025566778	tatiana.gomez@mail.com
171	Fernando	Beltrán	1984-08-28	M	Av. 20 #9-11	3156677889	fernando.beltran@mail.com
172	Catalina	Arango	1996-09-02	F	Calle 99 #33-50	3118899001	catalina.arango@mail.com
173	Cristian	López	1980-06-17	M	Carrera 22 #17-10	3101234987	cristian.lopez@mail.com
174	Patricia	Zapata	1988-01-23	F	Av. 50 #10-45	3002345678	patricia.zapata@mail.com
175	Hugo	Medina	1976-11-05	M	Calle 12 #44-30	3208765123	hugo.medina@mail.com
176	Elena	Cárdenas	1994-07-29	F	Carrera 5 #66-77	3145566789	elena.cardenas@mail.com
177	Alejandro	Murillo	1987-03-16	M	Av. 18 #15-99	3139988776	alejandro.murillo@mail.com
178	Lorena	Suárez	1991-12-08	F	Calle 78 #22-50	3026655443	lorena.suarez@mail.com
179	Rafael	García	1978-02-25	M	Carrera 14 #99-60	3113344556	rafael.garcia@mail.com
180	Juliana	Lozano	1993-03-15	F	Calle 25 #44-12	3101112233	juliana.lozano@mail.com
181	Andrés	Ospina	1985-07-09	M	Carrera 19 #30-22	3205556677	andres.ospina@mail.com
182	Marcela	Torres	1991-11-21	F	Av. 7 #80-10	3139988775	marcela.torres@mail.com
183	Camilo	Guzmán	1980-01-13	M	Calle 55 #17-89	3024455667	camilo.guzman@mail.com
184	Liliana	Mendoza	1997-09-25	F	Carrera 33 #12-77	3152233445	liliana.mendoza@mail.com
185	Hernán	Prieto	1978-06-03	M	Av. 40 #90-15	3107788990	hernan.prieto@mail.com
186	Carolina	Mora	1994-10-18	F	Calle 70 #14-30	3123344556	carolina.mora@mail.com
187	Ricardo	Salazar	1986-04-07	M	Carrera 16 #88-45	3116677889	ricardo.salazar@mail.com
188	Estefanía	García	1999-12-01	F	Av. 25 #55-60	3204455332	estefania.garcia@mail.com
189	Mauricio	Ardila	1983-05-26	M	Calle 10 #23-40	3027766554	mauricio.ardila@mail.com
190	Sandra	Velásquez	1990-08-12	F	Carrera 50 #77-21	3148899776	sandra.velasquez@mail.com
191	Pedro	Nieto	1981-02-28	M	Av. 9 #60-50	3003344556	pedro.nieto@mail.com
192	Mónica	Vallejo	1995-06-16	F	Calle 80 #19-22	3209988771	monica.vallejo@mail.com
193	Germán	Cortés	1977-07-05	M	Carrera 44 #11-66	3112233445	german.cortes@mail.com
194	Ángela	Ramírez	1989-09-14	F	Av. 18 #30-70	3134455667	angela.ramirez@mail.com
195	Wilson	Jiménez	1984-12-23	M	Calle 66 #22-10	3155566778	wilson.jimenez@mail.com
196	Viviana	Gómez	1992-01-08	F	Carrera 10 #40-15	3108899001	viviana.gomez@mail.com
197	Rodrigo	Castaño	1979-03-19	M	Av. 100 #9-33	3024433221	rodrigo.castano@mail.com
198	Laura	Benítez	1996-05-30	F	Calle 45 #88-77	3205566778	laura.benitez@mail.com
199	Sergio	Martínez	1982-11-11	M	Carrera 7 #15-60	3119988774	sergio.martinez@mail.com
200	María	Gómez	1990-07-25	F	Carrera 12 #8-14	3109876543	maria.gomez@mail.com
101	Jared	Prens	2001-04-12	M	Calle 11A	3135905103	jaredprens@gmail.com
\.


--
-- TOC entry 3612 (class 0 OID 32778)
-- Dependencies: 239
-- Data for Name: patients_audit; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.patients_audit (audit_id, patient_id, actionpatient, changed_at, changed_by, before_data, after_data) FROM stdin;
1	101	UPDATE	2025-10-16 22:53:21.118622+00	Admin	{"id": 101, "pati_email": "jaredprens@gmail.com", "pati_phone": "3135905103", "pati_gender": "M", "pati_address": "Calle 11A", "pati_last_name": "Prens", "pati_birth_date": "2001-04-12", "pati_first_name": "Jared"}	{"id": 101, "pati_email": "jaredprens@gmail.com", "pati_phone": "3135905103", "pati_gender": "M", "pati_address": "Calle 11A", "pati_last_name": "Prens", "pati_birth_date": "2001-04-12", "pati_first_name": "Jared"}
2	101	UPDATE	2025-10-16 22:54:06.888539+00	Admin	{"id": 101, "pati_email": "jaredprens@gmail.com", "pati_phone": "3135905103", "pati_gender": "M", "pati_address": "Calle 11A", "pati_last_name": "Caraballo", "pati_birth_date": "2001-04-12", "pati_first_name": "Jared"}	{"id": 101, "pati_email": "jaredprens@gmail.com", "pati_phone": "3135905103", "pati_gender": "M", "pati_address": "Calle 11A", "pati_last_name": "Caraballo", "pati_birth_date": "2001-04-12", "pati_first_name": "Jared"}
\.


--
-- TOC entry 3609 (class 0 OID 24706)
-- Dependencies: 236
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.payments (id, paym_appointment_id, paym_amount, paym_date, paym_method) FROM stdin;
3	103	82000	2023-01-17 11:15:00	Tarjeta Crédito
4	104	60000	2023-01-18 12:45:00	Efectivo
5	105	95000	2023-01-19 14:10:00	Transferencia
6	106	70000	2023-01-20 09:20:00	Efectivo
7	107	65000	2023-01-21 10:30:00	Tarjeta Crédito
8	108	88000	2023-01-22 11:40:00	Transferencia
9	109	56000	2023-01-23 13:00:00	Efectivo
10	110	73000	2023-01-24 14:20:00	Tarjeta Débito
11	111	81000	2023-01-25 09:10:00	Tarjeta Crédito
12	112	69000	2023-01-26 10:25:00	Transferencia
13	113	94000	2023-01-27 11:35:00	Efectivo
14	114	58000	2023-01-28 12:45:00	Tarjeta Débito
15	115	86000	2023-01-29 14:05:00	Tarjeta Crédito
16	116	72000	2023-01-30 09:15:00	Efectivo
17	117	90000	2023-01-31 10:40:00	Transferencia
18	118	64000	2023-02-01 11:55:00	Tarjeta Débito
19	119	88000	2023-02-02 13:20:00	Efectivo
20	120	77000	2023-02-03 14:30:00	Tarjeta Crédito
21	121	69000	2023-02-04 09:25:00	Tarjeta Débito
22	122	93000	2023-02-05 10:35:00	Transferencia
23	123	58000	2023-02-06 11:50:00	Efectivo
24	124	87000	2023-02-07 13:00:00	Tarjeta Crédito
25	125	76000	2023-02-08 14:20:00	Tarjeta Débito
26	126	81000	2023-02-09 09:40:00	Transferencia
27	127	67000	2023-02-10 10:50:00	Efectivo
28	128	94000	2023-02-11 12:00:00	Tarjeta Crédito
29	129	72000	2023-02-12 13:10:00	Efectivo
30	130	88000	2023-02-13 14:35:00	Tarjeta Débito
31	131	65000	2023-02-14 09:20:00	Tarjeta Crédito
32	132	93000	2023-02-15 10:45:00	Transferencia
33	133	78000	2023-02-16 11:55:00	Efectivo
34	134	70000	2023-02-17 13:05:00	Tarjeta Débito
35	135	91000	2023-02-18 14:15:00	Tarjeta Crédito
36	136	69000	2023-02-19 09:35:00	Efectivo
37	137	85000	2023-02-20 10:50:00	Transferencia
38	138	74000	2023-02-21 12:00:00	Tarjeta Débito
39	139	93000	2023-02-22 13:25:00	Efectivo
40	140	61000	2023-02-23 14:30:00	Tarjeta Crédito
41	141	78000	2023-02-24 09:15:00	Efectivo
42	142	87000	2023-02-25 10:35:00	Tarjeta Débito
43	143	95000	2023-02-26 11:45:00	Transferencia
44	144	69000	2023-02-27 13:00:00	Tarjeta Crédito
45	145	83000	2023-02-28 14:20:00	Efectivo
46	146	76000	2023-03-01 09:30:00	Tarjeta Débito
47	147	91000	2023-03-02 10:40:00	Tarjeta Crédito
48	148	72000	2023-03-03 11:55:00	Efectivo
49	149	95000	2023-03-04 13:10:00	Transferencia
50	150	68000	2023-03-05 14:25:00	Efectivo
51	151	72000	2023-03-06 09:20:00	Efectivo
52	152	93000	2023-03-07 10:35:00	Tarjeta Crédito
53	153	85000	2023-03-08 11:50:00	Transferencia
54	154	69000	2023-03-09 13:00:00	Tarjeta Débito
55	155	91000	2023-03-10 14:15:00	Efectivo
56	156	77000	2023-03-11 09:40:00	Tarjeta Crédito
57	157	60000	2023-03-12 10:55:00	Efectivo
58	158	94000	2023-03-13 12:05:00	Transferencia
59	159	88000	2023-03-14 13:15:00	Tarjeta Débito
60	160	81000	2023-03-15 14:30:00	Efectivo
61	161	95000	2023-03-16 09:25:00	Tarjeta Crédito
62	162	72000	2023-03-17 10:35:00	Efectivo
63	163	87000	2023-03-18 11:45:00	Tarjeta Débito
64	164	93000	2023-03-19 13:00:00	Transferencia
65	165	64000	2023-03-20 14:10:00	Tarjeta Crédito
66	166	89000	2023-03-21 09:35:00	Efectivo
67	167	75000	2023-03-22 10:50:00	Tarjeta Débito
68	168	92000	2023-03-23 12:05:00	Efectivo
69	169	87000	2023-03-24 13:20:00	Tarjeta Crédito
70	170	78000	2023-03-25 14:25:00	Transferencia
71	171	81000	2023-03-26 09:15:00	Efectivo
72	172	69000	2023-03-27 10:20:00	Tarjeta Débito
73	173	93000	2023-03-28 11:35:00	Efectivo
74	174	85000	2023-03-29 12:45:00	Tarjeta Crédito
75	175	76000	2023-03-30 14:00:00	Transferencia
76	176	95000	2023-03-31 09:20:00	Tarjeta Débito
77	177	72000	2023-04-01 10:40:00	Efectivo
78	178	88000	2023-04-02 11:50:00	Tarjeta Crédito
79	179	93000	2023-04-03 13:00:00	Efectivo
80	180	78000	2023-04-04 14:20:00	Transferencia
81	181	91000	2023-04-05 09:35:00	Tarjeta Débito
82	182	65000	2023-04-06 10:50:00	Efectivo
83	183	94000	2023-04-07 12:05:00	Tarjeta Crédito
84	184	81000	2023-04-08 13:20:00	Transferencia
85	185	77000	2023-04-09 14:35:00	Efectivo
86	186	89000	2023-04-10 09:25:00	Tarjeta Débito
87	187	95000	2023-04-11 10:40:00	Efectivo
88	188	72000	2023-04-12 11:55:00	Tarjeta Crédito
89	189	87000	2023-04-13 13:05:00	Efectivo
90	190	93000	2023-04-14 14:15:00	Transferencia
91	191	68000	2023-04-15 09:35:00	Tarjeta Débito
92	192	85000	2023-04-16 10:45:00	Efectivo
93	193	77000	2023-04-17 12:00:00	Tarjeta Crédito
94	194	91000	2023-04-18 13:10:00	Efectivo
95	195	65000	2023-04-19 14:20:00	Transferencia
96	196	94000	2023-04-20 09:30:00	Tarjeta Débito
97	197	72000	2023-04-21 10:45:00	Efectivo
98	198	88000	2023-04-22 11:55:00	Tarjeta Crédito
99	199	93000	2023-04-23 13:05:00	Efectivo
100	200	78000	2023-04-24 14:15:00	Tarjeta Débito
1	101	75000	2023-01-15 10:00:00	Tarjeta Débito
2	102	25	2023-01-16 12:00:00	Efectivo
\.


--
-- TOC entry 3614 (class 0 OID 40976)
-- Dependencies: 241
-- Data for Name: payments_audit; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.payments_audit (audit_id, payment_id, actionpayment, changed_at, changed_by, before_data, after_data) FROM stdin;
1	1	UPDATE	2025-10-16 23:09:52.002297+00	Admin	{"id": 1, "paym_date": "2023-01-15T09:30:00", "paym_amount": 50000, "paym_method": "Efectivo", "paym_appointment_id": 101}	{"id": 1, "paym_date": "2023-01-15T09:30:00", "paym_amount": 50000, "paym_method": "Cuerpo", "paym_appointment_id": 101}
2	1	UPDATE	2025-10-16 23:10:19.264536+00	Admin	{"id": 1, "paym_date": "2023-01-15T09:30:00", "paym_amount": 50000, "paym_method": "Cuerpo", "paym_appointment_id": 101}	{"id": 1, "paym_date": "2023-01-15T09:30:00", "paym_amount": 50000, "paym_method": "Efectivo", "paym_appointment_id": 101}
3	1	DELETE	2025-10-16 23:10:25.799908+00	Admin	{"id": 1, "paym_date": "2023-01-15T09:30:00", "paym_amount": 50000, "paym_method": "Efectivo", "paym_appointment_id": 101}	\N
4	0	INSERT	2025-10-16 23:12:13.699597+00	Admin	\N	{"id": 0, "paym_date": "2023-01-16T12:00:00", "paym_amount": 25, "paym_method": "Efectivo", "paym_appointment_id": 102}
5	1	UPDATE	2025-10-16 23:12:13.740159+00	Admin	{"id": 2, "paym_date": "2023-01-16T10:00:00", "paym_amount": 75000, "paym_method": "Tarjeta Débito", "paym_appointment_id": 102}	{"id": 1, "paym_date": "2023-01-15T10:00:00", "paym_amount": 75000, "paym_method": "Tarjeta Débito", "paym_appointment_id": 101}
6	2	UPDATE	2025-10-16 23:12:18.58914+00	Admin	{"id": 0, "paym_date": "2023-01-16T12:00:00", "paym_amount": 25, "paym_method": "Efectivo", "paym_appointment_id": 102}	{"id": 2, "paym_date": "2023-01-16T12:00:00", "paym_amount": 25, "paym_method": "Efectivo", "paym_appointment_id": 102}
\.


--
-- TOC entry 3607 (class 0 OID 24686)
-- Dependencies: 234
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.reports (id, repo_study_id, repo_text, repo_creation_date, repo_doctor_id) FROM stdin;
51	151	Informe preliminar sin hallazgos relevantes.	2023-01-10 09:00:00	101
52	152	Se evidencia lesión benigna, recomendada observación.	2023-01-11 10:30:00	102
53	153	Radiografía normal, sin cambios estructurales.	2023-01-12 11:00:00	103
54	154	Hallazgos compatibles con inflamación crónica.	2023-01-13 14:15:00	104
55	155	No se identifican anomalías significativas.	2023-01-14 08:45:00	105
56	156	Control postquirúrgico satisfactorio.	2023-01-15 16:20:00	106
57	157	Pequeña fractura observada en extremidad inferior.	2023-01-16 09:40:00	107
58	158	Tejidos blandos sin alteraciones aparentes.	2023-01-17 13:50:00	108
59	159	Se confirma reducción completa de fractura previa.	2023-01-18 15:30:00	109
60	160	Lesión leve en cartílago articular.	2023-01-19 09:10:00	110
61	161	Resultado dentro de parámetros normales.	2023-01-20 11:25:00	111
62	162	Infiltración leve observada en tejido adyacente.	2023-01-21 10:15:00	112
63	163	Sin evidencia de recurrencia tumoral.	2023-01-22 12:05:00	113
64	164	Resultados compatibles con diagnóstico inicial.	2023-01-23 14:55:00	114
65	165	Cambios degenerativos leves en columna lumbar.	2023-01-24 08:30:00	115
66	166	Examen satisfactorio, sin complicaciones.	2023-01-25 17:00:00	116
67	167	Estructuras óseas en condiciones normales.	2023-01-26 09:45:00	117
68	168	Inflamación leve en región cervical.	2023-01-27 13:25:00	118
69	169	Hallazgos compatibles con recuperación parcial.	2023-01-28 15:15:00	119
70	170	Imagen muestra consolidación ósea adecuada.	2023-01-29 10:00:00	120
71	171	Informe dentro de límites normales.	2023-01-30 11:10:00	121
72	172	Evidencia de leve escoliosis.	2023-01-31 12:20:00	122
73	173	Examen revela inflamación articular.	2023-02-01 14:30:00	123
74	174	Radiografía sin hallazgos patológicos.	2023-02-02 09:35:00	124
75	175	Lesión cicatrizada sin complicaciones.	2023-02-03 10:50:00	125
76	176	Cambios degenerativos moderados observados.	2023-02-04 16:05:00	126
77	177	Pulmones sin signos de enfermedad activa.	2023-02-05 09:20:00	127
78	178	Evaluación post-tratamiento positiva.	2023-02-06 11:15:00	128
79	179	Informe muestra recuperación favorable.	2023-02-07 15:00:00	129
80	180	Sin signos de fractura aguda.	2023-02-08 13:10:00	130
81	181	Cambios mínimos en articulación examinada.	2023-02-09 10:25:00	131
82	182	Se recomienda seguimiento clínico.	2023-02-10 08:55:00	132
83	183	Examen revela inflamación leve.	2023-02-11 14:40:00	133
84	184	Resultados consistentes con evolución positiva.	2023-02-12 15:20:00	134
85	185	Informe dentro de la normalidad.	2023-02-13 10:35:00	135
86	186	Cambios degenerativos leves observados.	2023-02-14 12:45:00	136
87	187	Sin anomalías detectadas.	2023-02-15 09:30:00	137
88	188	Evaluación cardiopulmonar normal.	2023-02-16 11:50:00	138
89	189	Consolidación ósea en progreso.	2023-02-17 13:35:00	139
90	190	Examen control muestra estabilidad.	2023-02-18 15:05:00	140
91	191	Informe sin complicaciones adicionales.	2023-02-19 09:15:00	141
92	192	Cambios menores en estructura ósea.	2023-02-20 11:40:00	142
93	193	Hallazgos normales.	2023-02-21 10:05:00	143
94	194	Pequeña desviación en columna torácica.	2023-02-22 12:25:00	144
95	195	Evaluación sin alteraciones relevantes.	2023-02-23 14:50:00	145
96	196	Resultado compatible con recuperación completa.	2023-02-24 08:40:00	146
97	197	Informe radiológico normal.	2023-02-25 09:55:00	147
98	198	Leve desgaste articular detectado.	2023-02-26 13:00:00	148
99	199	Examen muestra evolución positiva.	2023-02-27 15:25:00	149
100	200	Hallazgos dentro de lo esperado.	2023-02-28 09:05:00	150
101	201	Radiografía dentro de parámetros normales.	2023-03-01 09:00:00	101
102	202	Se observan signos leves de inflamación.	2023-03-02 10:20:00	102
103	203	Informe radiológico sin anomalías relevantes.	2023-03-03 11:10:00	103
104	204	Lesión ósea en fase de cicatrización.	2023-03-04 14:00:00	104
105	205	Hallazgos compatibles con diagnóstico previo.	2023-03-05 15:15:00	105
106	206	Pulmones sin evidencia de patología.	2023-03-06 09:40:00	106
107	207	Cambios degenerativos leves observados.	2023-03-07 10:30:00	107
108	208	Estructuras óseas dentro de la normalidad.	2023-03-08 13:20:00	108
109	209	Informe post-operatorio satisfactorio.	2023-03-09 16:45:00	109
110	210	Examen revela consolidación completa.	2023-03-10 09:15:00	110
111	211	Radiografía sin signos de complicaciones.	2023-03-11 11:25:00	111
112	212	Cambios compatibles con inflamación articular.	2023-03-12 14:10:00	112
113	213	Hallazgos normales en tejidos blandos.	2023-03-13 10:00:00	113
114	214	Lesión ósea completamente resuelta.	2023-03-14 12:35:00	114
115	215	Informe dentro de los valores normales.	2023-03-15 09:05:00	115
116	216	Cambios degenerativos mínimos.	2023-03-16 13:50:00	116
117	217	Examen revela buena recuperación.	2023-03-17 15:40:00	117
118	218	Resultados compatibles con evolución positiva.	2023-03-18 09:25:00	118
119	219	Estructuras óseas sin alteraciones significativas.	2023-03-19 11:00:00	119
120	220	Informe radiológico normal.	2023-03-20 14:30:00	120
121	221	Pequeña inflamación detectada en rodilla.	2023-03-21 09:15:00	121
122	222	Consolidación adecuada en fractura previa.	2023-03-22 10:50:00	122
123	223	Examen muestra estabilidad estructural.	2023-03-23 13:10:00	123
124	224	Radiografía dentro de parámetros esperados.	2023-03-24 15:00:00	124
125	225	Cambios leves en articulación observada.	2023-03-25 09:45:00	125
126	226	Sin hallazgos patológicos relevantes.	2023-03-26 11:20:00	126
127	227	Informe compatible con control post-tratamiento.	2023-03-27 14:00:00	127
128	228	Evidencia de leve escoliosis.	2023-03-28 10:35:00	128
129	229	Evaluación muestra evolución satisfactoria.	2023-03-29 09:30:00	129
130	230	Pulmones sin alteraciones evidentes.	2023-03-30 11:15:00	130
131	231	Cambios degenerativos moderados en cadera.	2023-03-31 13:45:00	131
132	232	Examen muestra estructuras normales.	2023-04-01 09:20:00	132
133	233	Radiografía sin alteraciones adicionales.	2023-04-02 12:10:00	133
134	234	Consolidación ósea parcial en progreso.	2023-04-03 15:25:00	134
135	235	Informe normal.	2023-04-04 09:40:00	135
136	236	Cambios mínimos en región lumbar.	2023-04-05 10:55:00	136
137	237	Hallazgos dentro de parámetros normales.	2023-04-06 13:15:00	137
138	238	Sin evidencia de inflamación activa.	2023-04-07 14:50:00	138
139	239	Evolución favorable de la lesión previa.	2023-04-08 09:10:00	139
140	240	Radiografía control sin anomalías.	2023-04-09 11:30:00	140
141	241	Cambios degenerativos leves en cervical.	2023-04-10 09:50:00	141
142	242	Informe consistente con diagnóstico clínico.	2023-04-11 12:40:00	142
143	243	Lesión benigna cicatrizada correctamente.	2023-04-12 15:35:00	143
144	244	Estructuras sin anomalías detectadas.	2023-04-13 09:25:00	144
145	245	Hallazgos compatibles con recuperación completa.	2023-04-14 10:15:00	145
146	246	Examen radiológico sin hallazgos relevantes.	2023-04-15 13:00:00	146
147	247	Pulmones dentro de parámetros normales.	2023-04-16 09:35:00	147
148	248	Cambios menores en tejido articular.	2023-04-17 11:55:00	148
149	249	Informe sin complicaciones adicionales.	2023-04-18 14:05:00	149
150	250	Radiografía final con evolución positiva.	2023-04-19 09:15:00	150
\.


--
-- TOC entry 3603 (class 0 OID 24644)
-- Dependencies: 230
-- Data for Name: studies; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.studies (id, stud_patient_id, stud_doctor_id, stud_modality_id, stud_equipment_id, stud_appointment_id, stud_date, stud_status) FROM stdin;
151	101	101	1	1	101	2023-01-10 08:30:00	Finalizado
152	102	102	2	2	102	2023-01-11 09:15:00	Finalizado
153	103	103	3	3	103	2023-01-12 10:00:00	Pendiente
154	104	104	4	4	104	2023-01-13 11:45:00	En Proceso
155	105	105	1	5	105	2023-01-14 14:20:00	Finalizado
156	106	106	2	6	106	2023-01-15 08:50:00	Finalizado
157	107	107	3	7	107	2023-01-16 09:30:00	En Proceso
158	108	108	4	8	108	2023-01-17 10:10:00	Pendiente
159	109	109	1	9	109	2023-01-18 15:25:00	Finalizado
160	110	110	2	10	110	2023-01-19 16:00:00	Finalizado
161	111	111	3	1	111	2023-01-20 08:15:00	Pendiente
162	112	112	4	2	112	2023-01-21 09:00:00	En Proceso
163	113	113	1	3	113	2023-01-22 10:30:00	Finalizado
164	114	114	2	4	114	2023-01-23 11:10:00	Finalizado
165	115	115	3	5	115	2023-01-24 13:45:00	Pendiente
166	116	116	4	6	116	2023-01-25 15:00:00	En Proceso
167	117	117	1	7	117	2023-01-26 08:50:00	Finalizado
168	118	118	2	8	118	2023-01-27 09:20:00	Finalizado
169	119	119	3	9	119	2023-01-28 10:40:00	Pendiente
170	120	120	4	10	120	2023-01-29 12:00:00	En Proceso
171	121	121	1	1	121	2023-01-30 14:10:00	Finalizado
172	122	122	2	2	122	2023-02-01 08:00:00	Finalizado
173	123	123	3	3	123	2023-02-02 09:30:00	Pendiente
174	124	124	4	4	124	2023-02-03 10:50:00	En Proceso
175	125	125	1	5	125	2023-02-04 11:25:00	Finalizado
176	126	126	2	6	126	2023-02-05 12:15:00	Finalizado
177	127	127	3	7	127	2023-02-06 08:45:00	Pendiente
178	128	128	4	8	128	2023-02-07 09:15:00	En Proceso
179	129	129	1	9	129	2023-02-08 10:25:00	Finalizado
180	130	130	2	10	130	2023-02-09 11:10:00	Finalizado
181	131	131	3	1	131	2023-02-10 14:00:00	Pendiente
182	132	132	4	2	132	2023-02-11 08:20:00	En Proceso
183	133	133	1	3	133	2023-02-12 09:30:00	Finalizado
184	134	134	2	4	134	2023-02-13 10:45:00	Finalizado
185	135	135	3	5	135	2023-02-14 13:10:00	Pendiente
186	136	136	4	6	136	2023-02-15 14:40:00	En Proceso
187	137	137	1	7	137	2023-02-16 08:30:00	Finalizado
188	138	138	2	8	138	2023-02-17 09:10:00	Finalizado
189	139	139	3	9	139	2023-02-18 10:20:00	Pendiente
190	140	140	4	10	140	2023-02-19 11:35:00	En Proceso
191	141	141	1	1	141	2023-02-20 13:50:00	Finalizado
192	142	142	2	2	142	2023-02-21 08:10:00	Finalizado
193	143	143	3	3	143	2023-02-22 09:40:00	Pendiente
194	144	144	4	4	144	2023-02-23 10:55:00	En Proceso
195	145	145	1	5	145	2023-02-24 12:30:00	Finalizado
196	146	146	2	6	146	2023-02-25 14:15:00	Finalizado
197	147	147	3	7	147	2023-02-26 08:25:00	Pendiente
198	148	148	4	8	148	2023-02-27 09:05:00	En Proceso
199	149	149	1	9	149	2023-02-28 10:15:00	Finalizado
200	150	150	2	10	150	2023-03-01 11:20:00	Finalizado
201	151	151	3	1	151	2023-03-02 08:40:00	Pendiente
202	152	152	4	2	152	2023-03-03 09:25:00	En Proceso
203	153	153	1	3	153	2023-03-04 10:30:00	Finalizado
204	154	154	2	4	154	2023-03-05 11:45:00	Finalizado
205	155	155	3	5	155	2023-03-06 13:15:00	Pendiente
206	156	156	4	6	156	2023-03-07 14:20:00	En Proceso
207	157	157	1	7	157	2023-03-08 08:55:00	Finalizado
208	158	158	2	8	158	2023-03-09 09:35:00	Finalizado
209	159	159	3	9	159	2023-03-10 10:50:00	Pendiente
210	160	160	4	10	160	2023-03-11 12:05:00	En Proceso
211	161	161	1	1	161	2023-03-12 08:10:00	Finalizado
212	162	162	2	2	162	2023-03-13 09:15:00	Finalizado
213	163	163	3	3	163	2023-03-14 10:25:00	Pendiente
214	164	164	4	4	164	2023-03-15 11:40:00	En Proceso
215	165	165	1	5	165	2023-03-16 13:00:00	Finalizado
216	166	166	2	6	166	2023-03-17 14:10:00	Finalizado
217	167	167	3	7	167	2023-03-18 08:20:00	Pendiente
218	168	168	4	8	168	2023-03-19 09:30:00	En Proceso
219	169	169	1	9	169	2023-03-20 10:45:00	Finalizado
220	170	170	2	10	170	2023-03-21 12:15:00	Finalizado
221	171	171	3	1	171	2023-03-22 08:35:00	Pendiente
222	172	172	4	2	172	2023-03-23 09:05:00	En Proceso
223	173	173	1	3	173	2023-03-24 10:20:00	Finalizado
224	174	174	2	4	174	2023-03-25 11:30:00	Finalizado
225	175	175	3	5	175	2023-03-26 13:50:00	Pendiente
226	176	176	4	6	176	2023-03-27 14:25:00	En Proceso
227	177	177	1	7	177	2023-03-28 08:50:00	Finalizado
228	178	178	2	8	178	2023-03-29 09:40:00	Finalizado
229	179	179	3	9	179	2023-03-30 10:55:00	Pendiente
230	180	180	4	10	180	2023-03-31 12:35:00	En Proceso
231	181	181	1	1	181	2023-04-01 08:25:00	Finalizado
232	182	182	2	2	182	2023-04-02 09:15:00	Finalizado
233	183	183	3	3	183	2023-04-03 10:30:00	Pendiente
234	184	184	4	4	184	2023-04-04 11:50:00	En Proceso
235	185	185	1	5	185	2023-04-05 13:10:00	Finalizado
236	186	186	2	6	186	2023-04-06 14:40:00	Finalizado
237	187	187	3	7	187	2023-04-07 08:20:00	Pendiente
238	188	188	4	8	188	2023-04-08 09:30:00	En Proceso
239	189	189	1	9	189	2023-04-09 10:50:00	Finalizado
240	190	190	2	10	190	2023-04-10 12:20:00	Finalizado
241	191	191	3	1	191	2023-04-11 08:15:00	Pendiente
242	192	192	4	2	192	2023-04-12 09:25:00	En Proceso
243	193	193	1	3	193	2023-04-13 10:35:00	Finalizado
244	194	194	2	4	194	2023-04-14 11:55:00	Finalizado
245	195	195	3	5	195	2023-04-15 13:40:00	Pendiente
246	196	196	4	6	196	2023-04-16 14:10:00	En Proceso
247	197	197	1	7	197	2023-04-17 08:50:00	Finalizado
248	198	198	2	8	198	2023-04-18 09:20:00	Finalizado
249	199	199	3	9	199	2023-04-19 10:30:00	Pendiente
250	200	200	4	10	200	2023-04-20 12:00:00	En Proceso
\.


--
-- TOC entry 3616 (class 0 OID 41006)
-- Dependencies: 243
-- Data for Name: studies_audit; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.studies_audit (audit_id, study_id, actionstudy, changed_at, changed_by, before_data, after_data) FROM stdin;
\.


--
-- TOC entry 3610 (class 0 OID 24716)
-- Dependencies: 237
-- Data for Name: study_tags; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.study_tags (stta_study_id, stta_tag_id) FROM stdin;
194	1
242	1
179	2
211	2
186	3
218	3
171	4
250	4
151	5
207	5
169	6
232	6
158	7
201	7
154	8
214	8
183	9
234	9
161	10
222	10
174	11
228	11
152	12
209	12
180	13
203	13
166	14
246	14
156	15
237	15
189	16
226	16
177	17
217	17
198	18
240	18
163	19
213	19
195	20
230	20
160	21
223	21
173	22
241	22
197	23
248	23
190	24
220	24
181	25
205	25
187	26
233	26
153	27
239	27
165	28
202	28
176	29
216	29
192	30
229	30
170	31
225	31
175	32
245	32
157	33
219	33
184	34
238	34
196	35
244	35
168	36
235	36
199	37
212	37
162	38
249	38
188	39
206	39
178	40
221	40
182	41
210	41
155	42
236	42
200	43
247	43
193	44
215	44
167	45
227	45
185	46
204	46
172	47
231	47
191	48
224	48
159	49
243	49
164	50
208	50
\.


--
-- TOC entry 3599 (class 0 OID 24624)
-- Dependencies: 226
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.tags (id, tag_name, tag_description) FROM stdin;
1	URGENCIA	Estudio solicitado en contexto de urgencia
2	CONTROL	Estudio de control de patología previa
3	PREOPERATORIO	Estudio para valoración prequirúrgica
4	POSTOPERATORIO	Seguimiento de cirugía reciente
5	PEDIATRICO	Paciente en edad pediátrica
6	ADULTO	Paciente adulto
7	GERIATRICO	Paciente mayor de 65 años
8	TRAUMA	Estudio solicitado por trauma
9	ONCOLOGICO	Paciente en estudio oncológico
10	CARDIOLOGICO	Estudio orientado a patología cardiaca
11	NEUROLOGICO	Enfocado en patología neurológica
12	RESPIRATORIO	Relacionado con patología respiratoria
13	MUSCULOESQUELETICO	Estudio de sistema óseo y muscular
14	ABDOMINAL	Orientado a patología abdominal
15	GENITOURINARIO	Relacionado con sistema genitourinario
16	ENDOCRINOLOGICO	Paciente con patología endocrina
17	PRENATAL	Estudio realizado durante embarazo
18	DIAGNOSTICO	Primer estudio diagnóstico de la patología
19	SEGUIMIENTO	Seguimiento de enfermedad o tratamiento
20	INVESTIGACION	Parte de protocolo de investigación
21	DERMATOLOGICO	Patología relacionada con piel y tejidos blandos
22	OTORRINO	Estudio en contexto de patología ORL
23	OFTALMOLOGICO	Relacionado con estructuras oculares
24	GASTROENTEROLOGICO	Estudio orientado a aparato digestivo
25	NEFROLOGICO	Paciente con patología renal
26	VASCULAR	Enfocado en sistema vascular
27	HEMATOLOGICO	Paciente con patología hematológica
28	INFECCIOSO	Estudio por sospecha de infección
29	NEOPLASICO	Lesión sospechosa de neoplasia
30	PREVENTIVO	Estudio en programa de tamizaje
31	LABORAL	Relacionado con exámenes ocupacionales
32	DEPORTIVO	Paciente en contexto de medicina deportiva
33	CRONICO	Enfermedad de curso crónico
34	AGUDO	Enfermedad de inicio agudo
35	POSTPARTO	Paciente en periodo postparto
36	NEONATAL	Estudio en recién nacidos
37	ADOLESCENTE	Paciente en edad adolescente
38	INMUNOSUPRIMIDO	Paciente con inmunosupresión
39	COVID19	Estudio solicitado en paciente con sospecha de COVID-19
40	VACUNACION	Evaluación previa a vacunación especial
41	CARDIOLOGICO	Relacionado con enfermedades cardiovasculares
42	NEUROLOGICO	Patología del sistema nervioso central o periférico
43	RESPIRATORIO	Problemas pulmonares o vías respiratorias
44	ENDOCRINO	Paciente con alteraciones hormonales
45	TRAUMA	Estudio en contexto de trauma físico
46	QUIRURGICO	Paciente en evaluación pre o post quirúrgica
47	REUMATOLOGICO	Estudio en enfermedades autoinmunes o articulares
48	ALERGOLOGICO	Paciente con antecedentes de alergias graves
49	GENETICO	Evaluación por enfermedades hereditarias
50	OBSTETRICO	Paciente embarazada en control obstétrico
51	PEDIATRICO	Enfocado en población infantil
52	GERIATRICO	Estudio en adulto mayor
53	ONCOLOGICO	Control y seguimiento de cáncer
54	PSIQUIATRICO	Paciente con diagnóstico psiquiátrico
55	MUSCULOESQUELETICO	Estudio de huesos, músculos y articulaciones
56	UROLOGICO	Patología relacionada con vías urinarias
57	OTORRINOLARINGOLOGICO	Problemas de oído, nariz y garganta
58	MAXILOFACIAL	Evaluación de mandíbula y estructuras faciales
59	DENTAL	Estudio dental y odontológico
60	CRANEAL	Imagen para estructuras del cráneo
61	TORACICO	Examen orientado al tórax
62	ABDOMINAL	Imagen diagnóstica de abdomen
63	PELVICO	Estudio orientado a la pelvis
64	EXTREMIDADES	Examen en brazos o piernas
65	ESPINAL	Evaluación de columna vertebral
66	CEREBRAL	Estudio cerebral
67	PULMONAR	Patología pulmonar específica
68	HEPATOBILIAR	Imagen de hígado y vías biliares
69	PANCREATICO	Estudio de páncreas
70	TIROIDEO	Estudio de glándula tiroides
71	SUPRARRENAL	Evaluación de glándulas suprarrenales
72	VESICULAR	Estudio de vesícula biliar
73	PROSTATICO	Paciente masculino con estudio de próstata
74	MAMARIO	Estudio de mama en control preventivo o diagnóstico
75	FERTILIDAD	Examen en contexto de reproducción asistida
76	NEUROMUSCULAR	Patología de nervios y músculos
77	DERMICO	Estudio de piel en lesiones cutáneas
78	ARTICULAR	Imagen de rodillas, codos u otras articulaciones
79	FRACTURA	Paciente con sospecha de fractura ósea
80	POSTOPERATORIO	Seguimiento después de cirugía
81	CONTROL	Estudio de control médico regular
82	INICIAL	Primer examen diagnóstico
83	SEGUIMIENTO	Evaluación periódica de evolución clínica
84	URGENCIA	Paciente atendido en urgencias
85	PROGRAMADO	Examen en agenda programada
86	ESPECIAL	Estudio con técnica o indicación especial
87	INVESTIGACION	Examen en protocolo de investigación clínica
88	EDUCATIVO	Caso usado para docencia
89	VALIDACION	Estudio usado en validación de técnica
90	SEGUNDA_OPINION	Paciente que busca confirmación diagnóstica
91	DOCENTE	Imagen usada en clases de formación
92	ARCHIVO	Estudio almacenado como referencia
93	HISTORICO	Imagen de un caso clínico pasado
94	ANONIMIZADO	Estudio con datos de paciente ocultos
95	PRUEBA	Examen de prueba técnica
96	CALIDAD	Usado en control de calidad de equipos
97	CERTIFICADO	Estudio solicitado para certificación médica
98	INTERNACIONAL	Paciente remitido del exterior
99	TELEMEDICINA	Examen usado en consulta a distancia
100	EXPORTADO	Imagen exportada a otro sistema o PACS
\.


--
-- TOC entry 3593 (class 0 OID 24600)
-- Dependencies: 220
-- Data for Name: technologists; Type: TABLE DATA; Schema: public; Owner: salva
--

COPY public.technologists (id, tech_first_name, tech_last_name, tech_phone, tech_email) FROM stdin;
1	Laura	Martínez	3104567890	laura.martinez@hospital.com
2	Andrés	Gómez	3115678901	andres.gomez@hospital.com
3	María	Fernández	3126789012	maria.fernandez@hospital.com
4	Carlos	López	3137890123	carlos.lopez@hospital.com
5	Juliana	Ramírez	3148901234	juliana.ramirez@hospital.com
6	Felipe	Torres	3159012345	felipe.torres@hospital.com
7	Camila	Castro	3160123456	camila.castro@hospital.com
8	Sergio	Morales	3171234567	sergio.morales@hospital.com
9	Natalia	Hernández	3182345678	natalia.hernandez@hospital.com
10	David	Castaño	3193456789	david.castano@hospital.com
11	Paola	Ortiz	3204567890	paola.ortiz@hospital.com
12	Mauricio	Suárez	3215678901	mauricio.suarez@hospital.com
13	Isabel	Reyes	3226789012	isabel.reyes@hospital.com
14	Julián	Vargas	3237890123	julian.vargas@hospital.com
15	Carolina	Quintero	3248901234	carolina.quintero@hospital.com
16	Ricardo	Mendoza	3259012345	ricardo.mendoza@hospital.com
17	Valentina	Pardo	3260123456	valentina.pardo@hospital.com
18	Hernán	Cruz	3271234567	hernan.cruz@hospital.com
19	Daniela	Silva	3282345678	daniela.silva@hospital.com
20	Esteban	Mejía	3293456789	esteban.mejia@hospital.com
21	Alejandra	Salazar	3004567890	alejandra.salazar@hospital.com
22	Juan	Ríos	3015678901	juan.rios@hospital.com
23	Tatiana	García	3026789012	tatiana.garcia@hospital.com
24	Fernando	Muñoz	3037890123	fernando.munoz@hospital.com
25	Adriana	Peña	3048901234	adriana.pena@hospital.com
26	Hugo	Díaz	3059012345	hugo.diaz@hospital.com
27	Gabriela	Valencia	3060123456	gabriela.valencia@hospital.com
28	Cristian	Arango	3071234567	cristian.arango@hospital.com
29	Liliana	Rincón	3082345678	liliana.rincon@hospital.com
30	Sebastián	Jiménez	3093456789	sebastian.jimenez@hospital.com
31	Patricia	Osorio	3109876543	patricia.osorio@hospital.com
32	Martín	Benítez	3118765432	martin.benitez@hospital.com
33	Rosa	Bermúdez	3127654321	rosa.bermudez@hospital.com
34	Jorge	Escobar	3136543210	jorge.escobar@hospital.com
35	Angela	Forero	3145432109	angela.forero@hospital.com
36	Oscar	León	3154321098	oscar.leon@hospital.com
37	Monica	Peralta	3163210987	monica.peralta@hospital.com
38	Héctor	Camacho	3172109876	hector.camacho@hospital.com
39	Viviana	Guzmán	3181098765	viviana.guzman@hospital.com
40	Raúl	Cárdenas	3199988776	raul.cardenas@hospital.com
41	Camila	Mejía	3001122334	camila.mejia@hospital.com
42	Santiago	Montoya	3012233445	santiago.montoya@hospital.com
43	Natalia	Zapata	3023344556	natalia.zapata@hospital.com
44	Felipe	Londoño	3034455667	felipe.londono@hospital.com
45	Laura	Patiño	3045566778	laura.patino@hospital.com
46	Daniel	Velásquez	3056677889	daniel.velasquez@hospital.com
47	Mariana	Vargas	3067788990	mariana.vargas@hospital.com
48	Andrés	Quintero	3078899001	andres.quintero@hospital.com
49	Carolina	Reyes	3089900112	carolina.reyes@hospital.com
50	Iván	Galeano	3091001223	ivan.galeano@hospital.com
51	Valentina	Ortega	3102112334	valentina.ortega@hospital.com
52	Diego	Cardona	3113223445	diego.cardona@hospital.com
53	Alejandro	Suárez	3124334556	alejandro.suarez@hospital.com
54	Paola	Mendoza	3135445667	paola.mendoza@hospital.com
55	Esteban	Guerrero	3146556778	esteban.guerrero@hospital.com
56	Juliana	Barrera	3157667889	juliana.barrera@hospital.com
57	Mauricio	Morales	3168778990	mauricio.morales@hospital.com
58	Daniela	Chacón	3179889001	daniela.chacon@hospital.com
59	Ricardo	Torres	3180990112	ricardo.torres@hospital.com
60	Lorena	Castillo	3192101223	lorena.castillo@hospital.com
61	Camilo	Aristizábal	3003214567	camilo.aristizabal@hospital.com
62	Tatiana	Giraldo	3014325678	tatiana.giraldo@hospital.com
63	Manuel	Pérez	3025436789	manuel.perez@hospital.com
64	Adriana	Martínez	3036547890	adriana.martinez@hospital.com
65	Jorge	Salazar	3047658901	jorge.salazar@hospital.com
66	Andrea	Ramírez	3058769012	andrea.ramirez@hospital.com
67	Cristian	Pardo	3069870123	cristian.pardo@hospital.com
68	Marcela	Valencia	3071981234	marcela.valencia@hospital.com
69	Óscar	Serrano	3082092345	oscar.serrano@hospital.com
70	Lina	Cortés	3093203456	lina.cortes@hospital.com
71	Harold	Cárdenas	3104314567	harold.cardenas@hospital.com
72	Mónica	Herrera	3115425678	monica.herrera@hospital.com
73	Sebastián	Jiménez	3126536789	sebastian.jimenez@hospital.com
74	Isabela	Naranjo	3137647890	isabela.naranjo@hospital.com
75	Ramiro	Fonseca	3148758901	ramiro.fonseca@hospital.com
76	Gabriela	Restrepo	3159869012	gabriela.restrepo@hospital.com
77	Wilson	Cuellar	3161970123	wilson.cuellar@hospital.com
78	Liliana	Moreno	3172081234	liliana.moreno@hospital.com
79	Fabián	Ruiz	3183192345	fabian.ruiz@hospital.com
80	Sandra	Correa	3194203456	sandra.correa@hospital.com
81	Julio	Guzmán	3005314567	julio.guzman@hospital.com
82	Carolina	Ríos	3016425678	carolina.rios@hospital.com
83	Esteban	Martínez	3027536789	esteban.martinez@hospital.com
84	Natalia	Suárez	3038647890	natalia.suarez@hospital.com
85	Mauricio	Patiño	3049758901	mauricio.patino@hospital.com
86	Rosa	Lozano	3051869012	rosa.lozano@hospital.com
87	Héctor	Vargas	3062970123	hector.vargas@hospital.com
88	Claudia	Fernández	3073081234	claudia.fernandez@hospital.com
89	Iván	Camacho	3084192345	ivan.camacho@hospital.com
90	Viviana	Peña	3095203456	viviana.pena@hospital.com
91	Leonardo	Reyes	3106314567	leonardo.reyes@hospital.com
92	Daniela	Morales	3117425678	daniela.morales@hospital.com
93	Andrés	Castillo	3128536789	andres.castillo@hospital.com
94	Paola	Cruz	3139647890	paola.cruz@hospital.com
95	Rodrigo	Mendoza	3141758901	rodrigo.mendoza@hospital.com
96	Diana	Ortega	3152869012	diana.ortega@hospital.com
97	Álvaro	Quintero	3163970123	alvaro.quintero@hospital.com
98	Beatriz	Hoyos	3175081234	beatriz.hoyos@hospital.com
99	Fernando	Silva	3186192345	fernando.silva@hospital.com
100	Patricia	Mejía	3197203456	patricia.mejia@hospital.com
\.


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 227
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.appointments_id_seq', 1, false);


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 217
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.doctors_id_seq', 1, false);


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 223
-- Name: equipments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.equipments_id_seq', 1, false);


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 231
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.images_id_seq', 1, false);


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 221
-- Name: modalities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.modalities_id_seq', 1, false);


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 238
-- Name: patients_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.patients_audit_audit_id_seq', 2, true);


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 215
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.patients_id_seq', 1, false);


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 240
-- Name: payments_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.payments_audit_audit_id_seq', 6, true);


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 235
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 233
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.reports_id_seq', 1, false);


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 242
-- Name: studies_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.studies_audit_audit_id_seq', 1, false);


--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 229
-- Name: studies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.studies_id_seq', 1, false);


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 225
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.tags_id_seq', 1, false);


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 219
-- Name: technologists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: salva
--

SELECT pg_catalog.setval('public.technologists_id_seq', 1, false);


--
-- TOC entry 3397 (class 2606 OID 24637)
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- TOC entry 3387 (class 2606 OID 24598)
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- TOC entry 3393 (class 2606 OID 24622)
-- Name: equipments equipments_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.equipments
    ADD CONSTRAINT equipments_pkey PRIMARY KEY (id);


--
-- TOC entry 3401 (class 2606 OID 24679)
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- TOC entry 3391 (class 2606 OID 24613)
-- Name: modalities modalities_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.modalities
    ADD CONSTRAINT modalities_pkey PRIMARY KEY (id);


--
-- TOC entry 3411 (class 2606 OID 32786)
-- Name: patients_audit patients_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.patients_audit
    ADD CONSTRAINT patients_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3385 (class 2606 OID 24589)
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- TOC entry 3413 (class 2606 OID 40984)
-- Name: payments_audit payments_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.payments_audit
    ADD CONSTRAINT payments_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3407 (class 2606 OID 24710)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 3403 (class 2606 OID 24692)
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- TOC entry 3415 (class 2606 OID 41014)
-- Name: studies_audit studies_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.studies_audit
    ADD CONSTRAINT studies_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3399 (class 2606 OID 24648)
-- Name: studies studies_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT studies_pkey PRIMARY KEY (id);


--
-- TOC entry 3409 (class 2606 OID 24720)
-- Name: study_tags study_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.study_tags
    ADD CONSTRAINT study_tags_pkey PRIMARY KEY (stta_study_id, stta_tag_id);


--
-- TOC entry 3395 (class 2606 OID 24629)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- TOC entry 3389 (class 2606 OID 24606)
-- Name: technologists technologists_pkey; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.technologists
    ADD CONSTRAINT technologists_pkey PRIMARY KEY (id);


--
-- TOC entry 3405 (class 2606 OID 24694)
-- Name: reports uq_reports_study; Type: CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT uq_reports_study UNIQUE (repo_study_id);


--
-- TOC entry 3427 (class 2620 OID 32793)
-- Name: patients ai_patients_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER ai_patients_audit AFTER INSERT ON public.patients FOR EACH ROW EXECUTE FUNCTION public.patients_ai_audit();


--
-- TOC entry 3433 (class 2620 OID 40988)
-- Name: payments ai_payments_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER ai_payments_audit AFTER INSERT ON public.payments FOR EACH ROW EXECUTE FUNCTION public.payments_ai_audit();


--
-- TOC entry 3430 (class 2620 OID 41018)
-- Name: studies ai_studies_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER ai_studies_audit AFTER INSERT ON public.studies FOR EACH ROW EXECUTE FUNCTION public.studies_ai_audit();


--
-- TOC entry 3428 (class 2620 OID 32794)
-- Name: patients au_patients_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER au_patients_audit AFTER UPDATE ON public.patients FOR EACH ROW EXECUTE FUNCTION public.patients_au_audit();


--
-- TOC entry 3434 (class 2620 OID 40989)
-- Name: payments au_payments_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER au_payments_audit AFTER UPDATE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.payments_au_audit();


--
-- TOC entry 3431 (class 2620 OID 41019)
-- Name: studies au_studies_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER au_studies_audit AFTER UPDATE ON public.studies FOR EACH ROW EXECUTE FUNCTION public.studies_au_audit();


--
-- TOC entry 3429 (class 2620 OID 32795)
-- Name: patients bd_patients_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bd_patients_audit BEFORE DELETE ON public.patients FOR EACH ROW EXECUTE FUNCTION public.patients_bd_audit();


--
-- TOC entry 3436 (class 2620 OID 40966)
-- Name: patients_audit bd_patients_audit_block; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bd_patients_audit_block BEFORE DELETE ON public.patients_audit FOR EACH ROW EXECUTE FUNCTION public.patients_audit_block_bd();


--
-- TOC entry 3435 (class 2620 OID 40990)
-- Name: payments bd_payments_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bd_payments_audit BEFORE DELETE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.payments_bd_audit();


--
-- TOC entry 3439 (class 2620 OID 40996)
-- Name: payments_audit bd_payments_audit_block; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bd_payments_audit_block BEFORE DELETE ON public.payments_audit FOR EACH ROW EXECUTE FUNCTION public.payments_audit_block_bd();


--
-- TOC entry 3432 (class 2620 OID 41020)
-- Name: studies bd_studies_audit; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bd_studies_audit BEFORE DELETE ON public.studies FOR EACH ROW EXECUTE FUNCTION public.studies_bd_audit();


--
-- TOC entry 3442 (class 2620 OID 41026)
-- Name: studies_audit bd_studies_audit_block; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bd_studies_audit_block BEFORE DELETE ON public.studies_audit FOR EACH ROW EXECUTE FUNCTION public.studies_audit_block_bd();


--
-- TOC entry 3437 (class 2620 OID 40964)
-- Name: patients_audit bi_patients_audit_guard; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bi_patients_audit_guard BEFORE INSERT ON public.patients_audit FOR EACH ROW EXECUTE FUNCTION public.patients_audit_guard_bi();


--
-- TOC entry 3440 (class 2620 OID 40994)
-- Name: payments_audit bi_payments_audit_guard; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bi_payments_audit_guard BEFORE INSERT ON public.payments_audit FOR EACH ROW EXECUTE FUNCTION public.payments_audit_guard_bi();


--
-- TOC entry 3443 (class 2620 OID 41024)
-- Name: studies_audit bi_studies_audit_guard; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bi_studies_audit_guard BEFORE INSERT ON public.studies_audit FOR EACH ROW EXECUTE FUNCTION public.studies_audit_guard_bi();


--
-- TOC entry 3438 (class 2620 OID 40965)
-- Name: patients_audit bu_patients_audit_block; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bu_patients_audit_block BEFORE UPDATE ON public.patients_audit FOR EACH ROW EXECUTE FUNCTION public.patients_audit_block_bu();


--
-- TOC entry 3441 (class 2620 OID 40995)
-- Name: payments_audit bu_payments_audit_block; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bu_payments_audit_block BEFORE UPDATE ON public.payments_audit FOR EACH ROW EXECUTE FUNCTION public.payments_audit_block_bu();


--
-- TOC entry 3444 (class 2620 OID 41025)
-- Name: studies_audit bu_studies_audit_block; Type: TRIGGER; Schema: public; Owner: salva
--

CREATE TRIGGER bu_studies_audit_block BEFORE UPDATE ON public.studies_audit FOR EACH ROW EXECUTE FUNCTION public.studies_audit_block_bu();


--
-- TOC entry 3416 (class 2606 OID 24638)
-- Name: appointments fk_appointments_patients; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_patients FOREIGN KEY (appo_patient_id) REFERENCES public.patients(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3422 (class 2606 OID 24680)
-- Name: images fk_images_study; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT fk_images_study FOREIGN KEY (imag_study_id) REFERENCES public.studies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3423 (class 2606 OID 24695)
-- Name: reports fk_reports_doctor; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_reports_doctor FOREIGN KEY (repo_doctor_id) REFERENCES public.doctors(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3424 (class 2606 OID 24700)
-- Name: reports fk_reports_study; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_reports_study FOREIGN KEY (repo_study_id) REFERENCES public.studies(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3417 (class 2606 OID 24649)
-- Name: studies fk_studies_appointment; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT fk_studies_appointment FOREIGN KEY (stud_appointment_id) REFERENCES public.appointments(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3418 (class 2606 OID 24654)
-- Name: studies fk_studies_doctor; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT fk_studies_doctor FOREIGN KEY (stud_doctor_id) REFERENCES public.doctors(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3419 (class 2606 OID 24659)
-- Name: studies fk_studies_equipment; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT fk_studies_equipment FOREIGN KEY (stud_equipment_id) REFERENCES public.equipments(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3420 (class 2606 OID 24664)
-- Name: studies fk_studies_modality; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT fk_studies_modality FOREIGN KEY (stud_modality_id) REFERENCES public.modalities(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3421 (class 2606 OID 24669)
-- Name: studies fk_studies_patient; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT fk_studies_patient FOREIGN KEY (stud_patient_id) REFERENCES public.patients(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3426 (class 2606 OID 24721)
-- Name: study_tags fk_study_tags_tag; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.study_tags
    ADD CONSTRAINT fk_study_tags_tag FOREIGN KEY (stta_tag_id) REFERENCES public.tags(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3425 (class 2606 OID 24711)
-- Name: payments payments_paym_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: salva
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_paym_appointment_id_fkey FOREIGN KEY (paym_appointment_id) REFERENCES public.appointments(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2025-10-16 19:15:47

--
-- PostgreSQL database dump complete
--

