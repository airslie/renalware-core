--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: access_assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_assessments (
    id integer NOT NULL,
    patient_id integer,
    type_id integer NOT NULL,
    site_id integer NOT NULL,
    side character varying NOT NULL,
    performed_on date NOT NULL,
    procedure_on date,
    comments text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_assessments_id_seq OWNED BY access_assessments.id;


--
-- Name: access_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_plans (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_plans_id_seq OWNED BY access_plans.id;


--
-- Name: access_procedures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_procedures (
    id integer NOT NULL,
    patient_id integer,
    type_id integer NOT NULL,
    site_id integer NOT NULL,
    side character varying NOT NULL,
    performed_on date NOT NULL,
    first_procedure boolean,
    catheter_make character varying,
    catheter_lot_no character varying,
    outcome text,
    notes text,
    first_used_on date,
    failed_on date,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    performed_by character varying
);


--
-- Name: access_procedures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_procedures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_procedures_id_seq OWNED BY access_procedures.id;


--
-- Name: access_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_profiles (
    id integer NOT NULL,
    patient_id integer,
    formed_on date NOT NULL,
    planned_on date,
    started_on date,
    terminated_on date,
    type_id integer NOT NULL,
    site_id integer NOT NULL,
    plan_id integer,
    side character varying NOT NULL,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    decided_by_id integer
);


--
-- Name: access_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_profiles_id_seq OWNED BY access_profiles.id;


--
-- Name: access_sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_sites (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_sites_id_seq OWNED BY access_sites.id;


--
-- Name: access_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_types (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    abbreviation character varying
);


--
-- Name: access_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_types_id_seq OWNED BY access_types.id;


--
-- Name: access_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE access_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: access_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_versions_id_seq OWNED BY access_versions.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE addresses (
    id integer NOT NULL,
    addressable_type character varying NOT NULL,
    addressable_id integer NOT NULL,
    street_1 character varying,
    street_2 character varying,
    county character varying,
    city character varying,
    postcode character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    country character varying,
    name character varying,
    organisation_name character varying
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: clinic_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clinic_visits (
    id integer NOT NULL,
    patient_id integer,
    date timestamp without time zone NOT NULL,
    height double precision,
    weight double precision,
    systolic_bp integer,
    diastolic_bp integer,
    urine_blood character varying,
    urine_protein character varying,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    clinic_id integer NOT NULL
);


--
-- Name: clinic_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clinic_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clinic_visits_id_seq OWNED BY clinic_visits.id;


--
-- Name: clinics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clinics (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: clinics_appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clinics_appointments (
    id integer NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    patient_id integer NOT NULL,
    user_id integer NOT NULL,
    clinic_id integer NOT NULL
);


--
-- Name: clinics_appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clinics_appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinics_appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clinics_appointments_id_seq OWNED BY clinics_appointments.id;


--
-- Name: clinics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clinics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clinics_id_seq OWNED BY clinics.id;


--
-- Name: death_edta_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE death_edta_codes (
    id integer NOT NULL,
    code integer,
    death_cause character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: death_edta_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE death_edta_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: death_edta_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE death_edta_codes_id_seq OWNED BY death_edta_codes.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: directory_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE directory_people (
    id integer NOT NULL,
    given_name character varying NOT NULL,
    family_name character varying NOT NULL,
    title character varying,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directory_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directory_people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directory_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directory_people_id_seq OWNED BY directory_people.id;


--
-- Name: drug_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drug_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: drug_types_drugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drug_types_drugs (
    drug_id integer,
    drug_type_id integer
);


--
-- Name: drug_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE drug_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE drug_types_id_seq OWNED BY drug_types.id;


--
-- Name: drugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE drugs (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: drugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE drugs_id_seq OWNED BY drugs.id;


--
-- Name: event_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: event_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_types_id_seq OWNED BY event_types.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    event_type_id integer,
    description character varying,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: feed_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE feed_messages (
    id integer NOT NULL,
    event_code character varying NOT NULL,
    header_id character varying NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: feed_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feed_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feed_messages_id_seq OWNED BY feed_messages.id;


--
-- Name: hd_cannulation_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hd_cannulation_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_cannulation_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hd_cannulation_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_cannulation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hd_cannulation_types_id_seq OWNED BY hd_cannulation_types.id;


--
-- Name: hd_dialysers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hd_dialysers (
    id integer NOT NULL,
    "group" character varying NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_dialysers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hd_dialysers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_dialysers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hd_dialysers_id_seq OWNED BY hd_dialysers.id;


--
-- Name: hd_dry_weights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hd_dry_weights (
    id integer NOT NULL,
    patient_id integer,
    weight double precision NOT NULL,
    assessed_on date NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    assessor_id integer NOT NULL
);


--
-- Name: hd_dry_weights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hd_dry_weights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_dry_weights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hd_dry_weights_id_seq OWNED BY hd_dry_weights.id;


--
-- Name: hd_patient_statistics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hd_patient_statistics (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    hospital_unit_id integer NOT NULL,
    month integer,
    year integer,
    rolling boolean,
    pre_mean_systolic_blood_pressure numeric(10,2),
    pre_mean_diastolic_blood_pressure numeric(10,2),
    post_mean_systolic_blood_pressure numeric(10,2),
    post_mean_diastolic_blood_pressure numeric(10,2),
    lowest_systolic_blood_pressure numeric(10,2),
    highest_systolic_blood_pressure numeric(10,2),
    mean_fluid_removal numeric(10,2),
    mean_weight_loss numeric(10,2),
    mean_machine_ktv numeric(10,2),
    mean_blood_flow numeric(10,2),
    mean_litres_processed numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    session_count integer DEFAULT 0 NOT NULL,
    number_of_missed_sessions integer,
    dialysis_minutes_shortfall integer,
    dialysis_minutes_shortfall_percentage numeric(10,2),
    mean_ufr numeric(10,2),
    mean_weight_loss_as_percentage_of_body_weight numeric(10,2)
);


--
-- Name: hd_patient_statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hd_patient_statistics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_patient_statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hd_patient_statistics_id_seq OWNED BY hd_patient_statistics.id;


--
-- Name: hd_preference_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hd_preference_sets (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    hospital_unit_id integer,
    schedule character varying,
    other_schedule character varying,
    entered_on date,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_preference_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hd_preference_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_preference_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hd_preference_sets_id_seq OWNED BY hd_preference_sets.id;


--
-- Name: hd_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hd_profiles (
    id integer NOT NULL,
    patient_id integer,
    hospital_unit_id integer,
    schedule character varying,
    other_schedule character varying,
    prescribed_time integer,
    prescribed_on date,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    prescriber_id integer,
    named_nurse_id integer,
    transport_decider_id integer,
    deactivated_at timestamp without time zone,
    active boolean DEFAULT true
);


--
-- Name: hd_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hd_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hd_profiles_id_seq OWNED BY hd_profiles.id;


--
-- Name: hd_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hd_sessions (
    id integer NOT NULL,
    patient_id integer,
    hospital_unit_id integer,
    modality_description_id integer,
    performed_on date NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    duration integer,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    signed_on_by_id integer,
    signed_off_by_id integer,
    type character varying NOT NULL,
    signed_off_at timestamp without time zone,
    profile_id integer,
    dry_weight_id integer
);


--
-- Name: hd_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hd_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hd_sessions_id_seq OWNED BY hd_sessions.id;


--
-- Name: hd_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hd_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: hd_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hd_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hd_versions_id_seq OWNED BY hd_versions.id;


--
-- Name: hospital_centres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hospital_centres (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    location character varying,
    active boolean,
    is_transplant_site boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hospital_centres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hospital_centres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_centres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hospital_centres_id_seq OWNED BY hospital_centres.id;


--
-- Name: hospital_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hospital_units (
    id integer NOT NULL,
    hospital_centre_id integer NOT NULL,
    name character varying NOT NULL,
    unit_code character varying NOT NULL,
    renal_registry_code character varying NOT NULL,
    unit_type character varying NOT NULL,
    is_hd_site boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hospital_units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hospital_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hospital_units_id_seq OWNED BY hospital_units.id;


--
-- Name: letter_archives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letter_archives (
    id integer NOT NULL,
    content text NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letter_id integer NOT NULL
);


--
-- Name: letter_archives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letter_archives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_archives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letter_archives_id_seq OWNED BY letter_archives.id;


--
-- Name: letter_contact_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letter_contact_descriptions (
    id integer NOT NULL,
    system_code character varying NOT NULL,
    name character varying NOT NULL,
    "position" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: letter_contact_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letter_contact_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_contact_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letter_contact_descriptions_id_seq OWNED BY letter_contact_descriptions.id;


--
-- Name: letter_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letter_contacts (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    default_cc boolean DEFAULT false NOT NULL,
    description_id integer NOT NULL,
    other_description character varying,
    notes text
);


--
-- Name: letter_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letter_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letter_contacts_id_seq OWNED BY letter_contacts.id;


--
-- Name: letter_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letter_descriptions (
    id integer NOT NULL,
    text character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: letter_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letter_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letter_descriptions_id_seq OWNED BY letter_descriptions.id;


--
-- Name: letter_letterheads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letter_letterheads (
    id integer NOT NULL,
    name character varying NOT NULL,
    site_code character varying NOT NULL,
    unit_info character varying NOT NULL,
    trust_name character varying NOT NULL,
    trust_caption character varying NOT NULL,
    site_info text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: letter_letterheads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letter_letterheads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_letterheads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letter_letterheads_id_seq OWNED BY letter_letterheads.id;


--
-- Name: letter_letters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letter_letters (
    id integer NOT NULL,
    event_type character varying,
    event_id integer,
    patient_id integer,
    type character varying NOT NULL,
    issued_on date NOT NULL,
    description character varying,
    salutation character varying,
    body text,
    notes text,
    signed_at timestamp without time zone,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letterhead_id integer NOT NULL,
    author_id integer NOT NULL
);


--
-- Name: letter_letters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letter_letters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letter_letters_id_seq OWNED BY letter_letters.id;


--
-- Name: letter_recipients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letter_recipients (
    id integer NOT NULL,
    role character varying NOT NULL,
    person_role character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letter_id integer NOT NULL,
    addressee_type character varying,
    addressee_id integer
);


--
-- Name: letter_recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letter_recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letter_recipients_id_seq OWNED BY letter_recipients.id;


--
-- Name: letter_signatures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letter_signatures (
    id integer NOT NULL,
    signed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letter_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: letter_signatures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letter_signatures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_signatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letter_signatures_id_seq OWNED BY letter_signatures.id;


--
-- Name: medication_prescription_terminations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE medication_prescription_terminations (
    id integer NOT NULL,
    terminated_on date NOT NULL,
    notes text,
    prescription_id integer NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: medication_prescription_terminations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medication_prescription_terminations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescription_terminations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medication_prescription_terminations_id_seq OWNED BY medication_prescription_terminations.id;


--
-- Name: medication_prescription_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE medication_prescription_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: medication_prescription_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medication_prescription_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescription_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medication_prescription_versions_id_seq OWNED BY medication_prescription_versions.id;


--
-- Name: medication_prescriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE medication_prescriptions (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    drug_id integer NOT NULL,
    treatable_id integer NOT NULL,
    treatable_type character varying NOT NULL,
    dose_amount character varying NOT NULL,
    dose_unit character varying NOT NULL,
    medication_route_id integer NOT NULL,
    route_description character varying,
    frequency character varying NOT NULL,
    notes text,
    prescribed_on date NOT NULL,
    provider integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    administer_on_hd boolean DEFAULT false NOT NULL
);


--
-- Name: medication_prescriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medication_prescriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medication_prescriptions_id_seq OWNED BY medication_prescriptions.id;


--
-- Name: medication_routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE medication_routes (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: medication_routes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medication_routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medication_routes_id_seq OWNED BY medication_routes.id;


--
-- Name: modality_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE modality_descriptions (
    id integer NOT NULL,
    name character varying NOT NULL,
    type character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: modality_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE modality_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE modality_descriptions_id_seq OWNED BY modality_descriptions.id;


--
-- Name: modality_modalities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE modality_modalities (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    description_id integer NOT NULL,
    reason_id integer,
    modal_change_type character varying,
    notes text,
    started_on date NOT NULL,
    ended_on date,
    state character varying DEFAULT 'current'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: modality_modalities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE modality_modalities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_modalities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE modality_modalities_id_seq OWNED BY modality_modalities.id;


--
-- Name: modality_reasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE modality_reasons (
    id integer NOT NULL,
    type character varying,
    rr_code integer,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: modality_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE modality_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE modality_reasons_id_seq OWNED BY modality_reasons.id;


--
-- Name: pathology_labs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_labs (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: pathology_labs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_labs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_labs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_labs_id_seq OWNED BY pathology_labs.id;


--
-- Name: pathology_observation_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_observation_descriptions (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying
);


--
-- Name: pathology_observation_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_observation_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observation_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_observation_descriptions_id_seq OWNED BY pathology_observation_descriptions.id;


--
-- Name: pathology_observation_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_observation_requests (
    id integer NOT NULL,
    requestor_order_number character varying,
    requestor_name character varying NOT NULL,
    requested_at timestamp without time zone NOT NULL,
    patient_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description_id integer NOT NULL
);


--
-- Name: pathology_observation_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_observation_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observation_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_observation_requests_id_seq OWNED BY pathology_observation_requests.id;


--
-- Name: pathology_observations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_observations (
    id integer NOT NULL,
    result character varying NOT NULL,
    comment text,
    observed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description_id integer NOT NULL,
    request_id integer
);


--
-- Name: pathology_observations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_observations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_observations_id_seq OWNED BY pathology_observations.id;


--
-- Name: pathology_request_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_request_descriptions (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying,
    required_observation_description_id integer,
    expiration_days integer DEFAULT 0 NOT NULL,
    lab_id integer NOT NULL,
    bottle_type character varying
);


--
-- Name: pathology_request_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_request_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_request_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_request_descriptions_id_seq OWNED BY pathology_request_descriptions.id;


--
-- Name: pathology_request_descriptions_requests_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_request_descriptions_requests_requests (
    id integer NOT NULL,
    request_id integer NOT NULL,
    request_description_id integer NOT NULL
);


--
-- Name: pathology_request_descriptions_requests_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_request_descriptions_requests_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_request_descriptions_requests_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_request_descriptions_requests_requests_id_seq OWNED BY pathology_request_descriptions_requests_requests.id;


--
-- Name: pathology_requests_drug_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_requests_drug_categories (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: pathology_requests_drug_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_requests_drug_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_drug_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_requests_drug_categories_id_seq OWNED BY pathology_requests_drug_categories.id;


--
-- Name: pathology_requests_drugs_drug_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_requests_drugs_drug_categories (
    id integer NOT NULL,
    drug_id integer NOT NULL,
    drug_category_id integer NOT NULL
);


--
-- Name: pathology_requests_drugs_drug_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_requests_drugs_drug_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_drugs_drug_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_requests_drugs_drug_categories_id_seq OWNED BY pathology_requests_drugs_drug_categories.id;


--
-- Name: pathology_requests_global_rule_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_requests_global_rule_sets (
    id integer NOT NULL,
    request_description_id integer NOT NULL,
    frequency_type character varying NOT NULL,
    clinic_id integer
);


--
-- Name: pathology_requests_global_rule_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_requests_global_rule_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_global_rule_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_requests_global_rule_sets_id_seq OWNED BY pathology_requests_global_rule_sets.id;


--
-- Name: pathology_requests_global_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_requests_global_rules (
    id integer NOT NULL,
    rule_set_id integer,
    type character varying,
    param_id character varying,
    param_comparison_operator character varying,
    param_comparison_value character varying,
    rule_set_type character varying NOT NULL
);


--
-- Name: pathology_requests_global_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_requests_global_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_global_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_requests_global_rules_id_seq OWNED BY pathology_requests_global_rules.id;


--
-- Name: pathology_requests_patient_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_requests_patient_rules (
    id integer NOT NULL,
    test_description text,
    sample_number_bottles integer,
    sample_type character varying,
    frequency_type character varying,
    patient_id integer,
    start_date date,
    end_date date,
    lab_id integer
);


--
-- Name: pathology_requests_patient_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_requests_patient_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_patient_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_requests_patient_rules_id_seq OWNED BY pathology_requests_patient_rules.id;


--
-- Name: pathology_requests_patient_rules_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_requests_patient_rules_requests (
    id integer NOT NULL,
    request_id integer NOT NULL,
    patient_rule_id integer NOT NULL
);


--
-- Name: pathology_requests_patient_rules_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_requests_patient_rules_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_patient_rules_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_requests_patient_rules_requests_id_seq OWNED BY pathology_requests_patient_rules_requests.id;


--
-- Name: pathology_requests_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pathology_requests_requests (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    clinic_id integer NOT NULL,
    consultant_id integer NOT NULL,
    telephone character varying NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    template character varying NOT NULL,
    high_risk boolean NOT NULL
);


--
-- Name: pathology_requests_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pathology_requests_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pathology_requests_requests_id_seq OWNED BY pathology_requests_requests.id;


--
-- Name: patient_bookmarks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patient_bookmarks (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text,
    urgent boolean DEFAULT false NOT NULL
);


--
-- Name: patient_bookmarks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patient_bookmarks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE patient_bookmarks_id_seq OWNED BY patient_bookmarks.id;


--
-- Name: patient_ethnicities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patient_ethnicities (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: patient_ethnicities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patient_ethnicities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE patient_ethnicities_id_seq OWNED BY patient_ethnicities.id;


--
-- Name: patient_languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patient_languages (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: patient_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patient_languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE patient_languages_id_seq OWNED BY patient_languages.id;


--
-- Name: patient_practices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patient_practices (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: patient_practices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patient_practices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_practices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE patient_practices_id_seq OWNED BY patient_practices.id;


--
-- Name: patient_practices_primary_care_physicians; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patient_practices_primary_care_physicians (
    primary_care_physician_id integer NOT NULL,
    practice_id integer NOT NULL
);


--
-- Name: patient_primary_care_physicians; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patient_primary_care_physicians (
    id integer NOT NULL,
    given_name character varying,
    family_name character varying,
    email character varying,
    code character varying,
    practitioner_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    telephone character varying
);


--
-- Name: patient_primary_care_physicians_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patient_primary_care_physicians_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_primary_care_physicians_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE patient_primary_care_physicians_id_seq OWNED BY patient_primary_care_physicians.id;


--
-- Name: patient_religions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patient_religions (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: patient_religions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patient_religions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_religions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE patient_religions_id_seq OWNED BY patient_religions.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patients (
    id integer NOT NULL,
    nhs_number character varying,
    local_patient_id character varying NOT NULL,
    family_name character varying NOT NULL,
    given_name character varying NOT NULL,
    born_on date NOT NULL,
    paediatric_patient_indicator boolean,
    sex character varying,
    ethnicity_id integer,
    gp_practice_code character varying,
    pct_org_code character varying,
    hospital_centre_code character varying,
    primary_esrf_centre character varying,
    died_on date,
    first_edta_code_id integer,
    second_edta_code_id integer,
    death_notes text,
    cc_on_all_letters boolean DEFAULT true,
    cc_decision_on date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    practice_id integer,
    primary_care_physician_id integer,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    title character varying,
    suffix character varying,
    marital_status character varying,
    telephone1 character varying,
    telephone2 character varying,
    email character varying,
    document jsonb,
    religion_id integer,
    language_id integer,
    diabetic boolean DEFAULT false NOT NULL
);


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE patients_id_seq OWNED BY patients.id;


--
-- Name: pd_bag_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_bag_types (
    id integer NOT NULL,
    manufacturer character varying NOT NULL,
    description character varying NOT NULL,
    glucose_grams_per_litre numeric(4,1) NOT NULL,
    amino_acid boolean,
    icodextrin boolean,
    low_glucose_degradation boolean,
    low_sodium boolean,
    sodium_mmole_l integer,
    lactate_mmole_l integer,
    bicarbonate_mmole_l integer,
    calcium_mmole_l numeric(3,2),
    magnesium_mmole_l numeric(3,2),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_bag_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_bag_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_bag_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_bag_types_id_seq OWNED BY pd_bag_types.id;


--
-- Name: pd_episode_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_episode_types (
    id integer NOT NULL,
    term character varying,
    definition character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_episode_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_episode_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_episode_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_episode_types_id_seq OWNED BY pd_episode_types.id;


--
-- Name: pd_exit_site_infections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_exit_site_infections (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    diagnosis_date date NOT NULL,
    treatment text,
    outcome text,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_exit_site_infections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_exit_site_infections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_exit_site_infections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_exit_site_infections_id_seq OWNED BY pd_exit_site_infections.id;


--
-- Name: pd_fluid_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_fluid_descriptions (
    id integer NOT NULL,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_fluid_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_fluid_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_fluid_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_fluid_descriptions_id_seq OWNED BY pd_fluid_descriptions.id;


--
-- Name: pd_infection_organisms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_infection_organisms (
    id integer NOT NULL,
    organism_code_id integer NOT NULL,
    sensitivity text,
    infectable_id integer,
    infectable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_infection_organisms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_infection_organisms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_infection_organisms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_infection_organisms_id_seq OWNED BY pd_infection_organisms.id;


--
-- Name: pd_organism_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_organism_codes (
    id integer NOT NULL,
    read_code character varying,
    name character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_organism_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_organism_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_organism_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_organism_codes_id_seq OWNED BY pd_organism_codes.id;


--
-- Name: pd_peritonitis_episodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_peritonitis_episodes (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    diagnosis_date date NOT NULL,
    treatment_start_date date,
    treatment_end_date date,
    episode_type_id integer,
    catheter_removed boolean,
    line_break boolean,
    exit_site_infection boolean,
    diarrhoea boolean,
    abdominal_pain boolean,
    fluid_description_id integer,
    white_cell_total integer,
    white_cell_neutro integer,
    white_cell_lympho integer,
    white_cell_degen integer,
    white_cell_other integer,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_peritonitis_episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_peritonitis_episodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_peritonitis_episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_peritonitis_episodes_id_seq OWNED BY pd_peritonitis_episodes.id;


--
-- Name: pd_regime_bags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_regime_bags (
    id integer NOT NULL,
    regime_id integer NOT NULL,
    bag_type_id integer NOT NULL,
    volume integer NOT NULL,
    per_week integer,
    monday boolean,
    tuesday boolean,
    wednesday boolean,
    thursday boolean,
    friday boolean,
    saturday boolean,
    sunday boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_regime_bags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_regime_bags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_regime_bags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_regime_bags_id_seq OWNED BY pd_regime_bags.id;


--
-- Name: pd_regimes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pd_regimes (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    treatment character varying NOT NULL,
    type character varying,
    glucose_ml_percent_1_36 integer,
    glucose_ml_percent_2_27 integer,
    glucose_ml_percent_3_86 integer,
    amino_acid_ml integer,
    icodextrin_ml integer,
    add_hd boolean,
    last_fill_ml integer,
    add_manual_exchange boolean,
    tidal_indicator boolean,
    tidal_percentage integer,
    no_cycles_per_apd integer,
    overnight_pd_ml integer,
    apd_machine_pac character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    therapy_time integer
);


--
-- Name: pd_regimes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pd_regimes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_regimes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pd_regimes_id_seq OWNED BY pd_regimes.id;


--
-- Name: problem_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE problem_notes (
    id integer NOT NULL,
    problem_id integer,
    description text NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: problem_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE problem_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE problem_notes_id_seq OWNED BY problem_notes.id;


--
-- Name: problem_problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE problem_problems (
    id integer NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    patient_id integer NOT NULL,
    description character varying NOT NULL,
    date date,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: problem_problems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE problem_problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE problem_problems_id_seq OWNED BY problem_problems.id;


--
-- Name: problem_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE problem_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: problem_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE problem_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE problem_versions_id_seq OWNED BY problem_versions.id;


--
-- Name: renal_prd_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE renal_prd_descriptions (
    id integer NOT NULL,
    code character varying,
    term character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: renal_prd_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE renal_prd_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_prd_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE renal_prd_descriptions_id_seq OWNED BY renal_prd_descriptions.id;


--
-- Name: renal_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE renal_profiles (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    esrf_on date,
    first_seen_on date,
    weight_at_esrf double precision,
    modality_at_esrf character varying,
    prd_description_id integer,
    smoking_status character varying,
    comorbidities_updated_on date,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: renal_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE renal_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE renal_profiles_id_seq OWNED BY renal_profiles.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles_users (
    role_id integer,
    user_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: transplant_donations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_donations (
    id integer NOT NULL,
    patient_id integer,
    recipient_id integer,
    state character varying NOT NULL,
    relationship_with_recipient character varying NOT NULL,
    relationship_with_recipient_other character varying,
    blood_group_compatibility character varying,
    mismatch_grade character varying,
    paired_pooled_donation character varying,
    volunteered_on date,
    first_seen_on date,
    workup_completed_on date,
    donated_on date,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_donations_id_seq OWNED BY transplant_donations.id;


--
-- Name: transplant_donor_followups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_donor_followups (
    id integer NOT NULL,
    operation_id integer NOT NULL,
    notes text,
    followed_up boolean,
    ukt_center_code character varying,
    last_seen_on date,
    lost_to_followup boolean,
    transferred_for_followup boolean,
    dead_on date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_followups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_donor_followups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_donor_followups_id_seq OWNED BY transplant_donor_followups.id;


--
-- Name: transplant_donor_operations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_donor_operations (
    id integer NOT NULL,
    patient_id integer,
    performed_on date NOT NULL,
    anaesthetist character varying,
    donor_splenectomy_peri_or_post_operatively character varying,
    kidney_side character varying,
    nephrectomy_type character varying,
    nephrectomy_type_other character varying,
    operating_surgeon character varying,
    notes text,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_donor_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_donor_operations_id_seq OWNED BY transplant_donor_operations.id;


--
-- Name: transplant_donor_workups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_donor_workups (
    id integer NOT NULL,
    patient_id integer,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_workups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_donor_workups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_workups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_donor_workups_id_seq OWNED BY transplant_donor_workups.id;


--
-- Name: transplant_failure_cause_description_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_failure_cause_description_groups (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_failure_cause_description_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_failure_cause_description_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_failure_cause_description_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_failure_cause_description_groups_id_seq OWNED BY transplant_failure_cause_description_groups.id;


--
-- Name: transplant_failure_cause_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_failure_cause_descriptions (
    id integer NOT NULL,
    group_id integer,
    code character varying NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_failure_cause_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_failure_cause_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_failure_cause_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_failure_cause_descriptions_id_seq OWNED BY transplant_failure_cause_descriptions.id;


--
-- Name: transplant_recipient_followups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_recipient_followups (
    id integer NOT NULL,
    operation_id integer NOT NULL,
    notes text,
    stent_removed_on date,
    transplant_failed boolean,
    transplant_failed_on date,
    transplant_failure_cause_description_id integer,
    transplant_failure_cause_other character varying,
    transplant_failure_notes text,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_recipient_followups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_recipient_followups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_recipient_followups_id_seq OWNED BY transplant_recipient_followups.id;


--
-- Name: transplant_recipient_operations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_recipient_operations (
    id integer NOT NULL,
    patient_id integer,
    performed_on date NOT NULL,
    theatre_case_start_time time without time zone NOT NULL,
    donor_kidney_removed_from_ice_at timestamp without time zone NOT NULL,
    operation_type character varying NOT NULL,
    hospital_centre_id integer NOT NULL,
    kidney_perfused_with_blood_at timestamp without time zone NOT NULL,
    cold_ischaemic_time integer NOT NULL,
    warm_ischaemic_time integer NOT NULL,
    notes text,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_recipient_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_recipient_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_recipient_operations_id_seq OWNED BY transplant_recipient_operations.id;


--
-- Name: transplant_recipient_workups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_recipient_workups (
    id integer NOT NULL,
    patient_id integer,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_recipient_workups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_recipient_workups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_workups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_recipient_workups_id_seq OWNED BY transplant_recipient_workups.id;


--
-- Name: transplant_registration_status_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_registration_status_descriptions (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying,
    "position" integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_registration_status_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_registration_status_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registration_status_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_registration_status_descriptions_id_seq OWNED BY transplant_registration_status_descriptions.id;


--
-- Name: transplant_registration_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_registration_statuses (
    id integer NOT NULL,
    registration_id integer,
    description_id integer,
    started_on date NOT NULL,
    terminated_on date,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_registration_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_registration_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registration_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_registration_statuses_id_seq OWNED BY transplant_registration_statuses.id;


--
-- Name: transplant_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_registrations (
    id integer NOT NULL,
    patient_id integer,
    referred_on date,
    assessed_on date,
    enterred_on date,
    contact text,
    notes text,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_registrations_id_seq OWNED BY transplant_registrations.id;


--
-- Name: transplant_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transplant_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: transplant_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplant_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplant_versions_id_seq OWNED BY transplant_versions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    username character varying NOT NULL,
    given_name character varying NOT NULL,
    family_name character varying NOT NULL,
    signature character varying,
    last_activity_at timestamp without time zone,
    datetime timestamp without time zone,
    expired_at timestamp without time zone,
    professional_position character varying,
    approved boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    telephone character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_assessments ALTER COLUMN id SET DEFAULT nextval('access_assessments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_plans ALTER COLUMN id SET DEFAULT nextval('access_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_procedures ALTER COLUMN id SET DEFAULT nextval('access_procedures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_profiles ALTER COLUMN id SET DEFAULT nextval('access_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_sites ALTER COLUMN id SET DEFAULT nextval('access_sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_types ALTER COLUMN id SET DEFAULT nextval('access_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_versions ALTER COLUMN id SET DEFAULT nextval('access_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinic_visits ALTER COLUMN id SET DEFAULT nextval('clinic_visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinics ALTER COLUMN id SET DEFAULT nextval('clinics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinics_appointments ALTER COLUMN id SET DEFAULT nextval('clinics_appointments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY death_edta_codes ALTER COLUMN id SET DEFAULT nextval('death_edta_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directory_people ALTER COLUMN id SET DEFAULT nextval('directory_people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_types ALTER COLUMN id SET DEFAULT nextval('drug_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY drugs ALTER COLUMN id SET DEFAULT nextval('drugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_types ALTER COLUMN id SET DEFAULT nextval('event_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feed_messages ALTER COLUMN id SET DEFAULT nextval('feed_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_cannulation_types ALTER COLUMN id SET DEFAULT nextval('hd_cannulation_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_dialysers ALTER COLUMN id SET DEFAULT nextval('hd_dialysers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_dry_weights ALTER COLUMN id SET DEFAULT nextval('hd_dry_weights_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_patient_statistics ALTER COLUMN id SET DEFAULT nextval('hd_patient_statistics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_preference_sets ALTER COLUMN id SET DEFAULT nextval('hd_preference_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_profiles ALTER COLUMN id SET DEFAULT nextval('hd_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions ALTER COLUMN id SET DEFAULT nextval('hd_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_versions ALTER COLUMN id SET DEFAULT nextval('hd_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hospital_centres ALTER COLUMN id SET DEFAULT nextval('hospital_centres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hospital_units ALTER COLUMN id SET DEFAULT nextval('hospital_units_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_archives ALTER COLUMN id SET DEFAULT nextval('letter_archives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_contact_descriptions ALTER COLUMN id SET DEFAULT nextval('letter_contact_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_contacts ALTER COLUMN id SET DEFAULT nextval('letter_contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_descriptions ALTER COLUMN id SET DEFAULT nextval('letter_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_letterheads ALTER COLUMN id SET DEFAULT nextval('letter_letterheads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_letters ALTER COLUMN id SET DEFAULT nextval('letter_letters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_recipients ALTER COLUMN id SET DEFAULT nextval('letter_recipients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_signatures ALTER COLUMN id SET DEFAULT nextval('letter_signatures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations ALTER COLUMN id SET DEFAULT nextval('medication_prescription_terminations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescription_versions ALTER COLUMN id SET DEFAULT nextval('medication_prescription_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescriptions ALTER COLUMN id SET DEFAULT nextval('medication_prescriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_routes ALTER COLUMN id SET DEFAULT nextval('medication_routes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_descriptions ALTER COLUMN id SET DEFAULT nextval('modality_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_modalities ALTER COLUMN id SET DEFAULT nextval('modality_modalities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_reasons ALTER COLUMN id SET DEFAULT nextval('modality_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_labs ALTER COLUMN id SET DEFAULT nextval('pathology_labs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observation_descriptions ALTER COLUMN id SET DEFAULT nextval('pathology_observation_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observation_requests ALTER COLUMN id SET DEFAULT nextval('pathology_observation_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observations ALTER COLUMN id SET DEFAULT nextval('pathology_observations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions ALTER COLUMN id SET DEFAULT nextval('pathology_request_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions_requests_requests ALTER COLUMN id SET DEFAULT nextval('pathology_request_descriptions_requests_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_drug_categories ALTER COLUMN id SET DEFAULT nextval('pathology_requests_drug_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_drugs_drug_categories ALTER COLUMN id SET DEFAULT nextval('pathology_requests_drugs_drug_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rule_sets ALTER COLUMN id SET DEFAULT nextval('pathology_requests_global_rule_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rules ALTER COLUMN id SET DEFAULT nextval('pathology_requests_global_rules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules ALTER COLUMN id SET DEFAULT nextval('pathology_requests_patient_rules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules_requests ALTER COLUMN id SET DEFAULT nextval('pathology_requests_patient_rules_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests ALTER COLUMN id SET DEFAULT nextval('pathology_requests_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_bookmarks ALTER COLUMN id SET DEFAULT nextval('patient_bookmarks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_ethnicities ALTER COLUMN id SET DEFAULT nextval('patient_ethnicities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_languages ALTER COLUMN id SET DEFAULT nextval('patient_languages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_practices ALTER COLUMN id SET DEFAULT nextval('patient_practices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_primary_care_physicians ALTER COLUMN id SET DEFAULT nextval('patient_primary_care_physicians_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_religions ALTER COLUMN id SET DEFAULT nextval('patient_religions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients ALTER COLUMN id SET DEFAULT nextval('patients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_bag_types ALTER COLUMN id SET DEFAULT nextval('pd_bag_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_episode_types ALTER COLUMN id SET DEFAULT nextval('pd_episode_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_exit_site_infections ALTER COLUMN id SET DEFAULT nextval('pd_exit_site_infections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_fluid_descriptions ALTER COLUMN id SET DEFAULT nextval('pd_fluid_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_infection_organisms ALTER COLUMN id SET DEFAULT nextval('pd_infection_organisms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_organism_codes ALTER COLUMN id SET DEFAULT nextval('pd_organism_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes ALTER COLUMN id SET DEFAULT nextval('pd_peritonitis_episodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_regime_bags ALTER COLUMN id SET DEFAULT nextval('pd_regime_bags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_regimes ALTER COLUMN id SET DEFAULT nextval('pd_regimes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_notes ALTER COLUMN id SET DEFAULT nextval('problem_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_problems ALTER COLUMN id SET DEFAULT nextval('problem_problems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_versions ALTER COLUMN id SET DEFAULT nextval('problem_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY renal_prd_descriptions ALTER COLUMN id SET DEFAULT nextval('renal_prd_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY renal_profiles ALTER COLUMN id SET DEFAULT nextval('renal_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donations ALTER COLUMN id SET DEFAULT nextval('transplant_donations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_followups ALTER COLUMN id SET DEFAULT nextval('transplant_donor_followups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_operations ALTER COLUMN id SET DEFAULT nextval('transplant_donor_operations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_workups ALTER COLUMN id SET DEFAULT nextval('transplant_donor_workups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_description_groups ALTER COLUMN id SET DEFAULT nextval('transplant_failure_cause_description_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_descriptions ALTER COLUMN id SET DEFAULT nextval('transplant_failure_cause_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_followups ALTER COLUMN id SET DEFAULT nextval('transplant_recipient_followups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_operations ALTER COLUMN id SET DEFAULT nextval('transplant_recipient_operations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_workups ALTER COLUMN id SET DEFAULT nextval('transplant_recipient_workups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registration_status_descriptions ALTER COLUMN id SET DEFAULT nextval('transplant_registration_status_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses ALTER COLUMN id SET DEFAULT nextval('transplant_registration_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registrations ALTER COLUMN id SET DEFAULT nextval('transplant_registrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_versions ALTER COLUMN id SET DEFAULT nextval('transplant_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: access_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT access_assessments_pkey PRIMARY KEY (id);


--
-- Name: access_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_plans
    ADD CONSTRAINT access_plans_pkey PRIMARY KEY (id);


--
-- Name: access_procedures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT access_procedures_pkey PRIMARY KEY (id);


--
-- Name: access_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT access_profiles_pkey PRIMARY KEY (id);


--
-- Name: access_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_sites
    ADD CONSTRAINT access_sites_pkey PRIMARY KEY (id);


--
-- Name: access_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_types
    ADD CONSTRAINT access_types_pkey PRIMARY KEY (id);


--
-- Name: access_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_versions
    ADD CONSTRAINT access_versions_pkey PRIMARY KEY (id);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: clinic_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinic_visits
    ADD CONSTRAINT clinic_visits_pkey PRIMARY KEY (id);


--
-- Name: clinics_appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinics_appointments
    ADD CONSTRAINT clinics_appointments_pkey PRIMARY KEY (id);


--
-- Name: clinics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinics
    ADD CONSTRAINT clinics_pkey PRIMARY KEY (id);


--
-- Name: death_edta_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY death_edta_codes
    ADD CONSTRAINT death_edta_codes_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: directory_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY directory_people
    ADD CONSTRAINT directory_people_pkey PRIMARY KEY (id);


--
-- Name: drug_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_types
    ADD CONSTRAINT drug_types_pkey PRIMARY KEY (id);


--
-- Name: drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: event_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT event_types_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: feed_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feed_messages
    ADD CONSTRAINT feed_messages_pkey PRIMARY KEY (id);


--
-- Name: hd_cannulation_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_cannulation_types
    ADD CONSTRAINT hd_cannulation_types_pkey PRIMARY KEY (id);


--
-- Name: hd_dialysers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_dialysers
    ADD CONSTRAINT hd_dialysers_pkey PRIMARY KEY (id);


--
-- Name: hd_dry_weights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_dry_weights
    ADD CONSTRAINT hd_dry_weights_pkey PRIMARY KEY (id);


--
-- Name: hd_patient_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_patient_statistics
    ADD CONSTRAINT hd_patient_statistics_pkey PRIMARY KEY (id);


--
-- Name: hd_preference_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT hd_preference_sets_pkey PRIMARY KEY (id);


--
-- Name: hd_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT hd_profiles_pkey PRIMARY KEY (id);


--
-- Name: hd_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT hd_sessions_pkey PRIMARY KEY (id);


--
-- Name: hd_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_versions
    ADD CONSTRAINT hd_versions_pkey PRIMARY KEY (id);


--
-- Name: hospital_centres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hospital_centres
    ADD CONSTRAINT hospital_centres_pkey PRIMARY KEY (id);


--
-- Name: hospital_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hospital_units
    ADD CONSTRAINT hospital_units_pkey PRIMARY KEY (id);


--
-- Name: letter_archives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_archives
    ADD CONSTRAINT letter_archives_pkey PRIMARY KEY (id);


--
-- Name: letter_contact_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_contact_descriptions
    ADD CONSTRAINT letter_contact_descriptions_pkey PRIMARY KEY (id);


--
-- Name: letter_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_contacts
    ADD CONSTRAINT letter_contacts_pkey PRIMARY KEY (id);


--
-- Name: letter_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_descriptions
    ADD CONSTRAINT letter_descriptions_pkey PRIMARY KEY (id);


--
-- Name: letter_letterheads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_letterheads
    ADD CONSTRAINT letter_letterheads_pkey PRIMARY KEY (id);


--
-- Name: letter_letters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT letter_letters_pkey PRIMARY KEY (id);


--
-- Name: letter_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_recipients
    ADD CONSTRAINT letter_recipients_pkey PRIMARY KEY (id);


--
-- Name: letter_signatures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_signatures
    ADD CONSTRAINT letter_signatures_pkey PRIMARY KEY (id);


--
-- Name: medication_prescription_terminations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations
    ADD CONSTRAINT medication_prescription_terminations_pkey PRIMARY KEY (id);


--
-- Name: medication_prescription_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescription_versions
    ADD CONSTRAINT medication_prescription_versions_pkey PRIMARY KEY (id);


--
-- Name: medication_prescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT medication_prescriptions_pkey PRIMARY KEY (id);


--
-- Name: medication_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_routes
    ADD CONSTRAINT medication_routes_pkey PRIMARY KEY (id);


--
-- Name: modality_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_descriptions
    ADD CONSTRAINT modality_descriptions_pkey PRIMARY KEY (id);


--
-- Name: modality_modalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT modality_modalities_pkey PRIMARY KEY (id);


--
-- Name: modality_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_reasons
    ADD CONSTRAINT modality_reasons_pkey PRIMARY KEY (id);


--
-- Name: pathology_labs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_labs
    ADD CONSTRAINT pathology_labs_pkey PRIMARY KEY (id);


--
-- Name: pathology_observation_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observation_descriptions
    ADD CONSTRAINT pathology_observation_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pathology_observation_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observation_requests
    ADD CONSTRAINT pathology_observation_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_observations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observations
    ADD CONSTRAINT pathology_observations_pkey PRIMARY KEY (id);


--
-- Name: pathology_request_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions
    ADD CONSTRAINT pathology_request_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pathology_request_descriptions_requests_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions_requests_requests
    ADD CONSTRAINT pathology_request_descriptions_requests_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_drug_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_drug_categories
    ADD CONSTRAINT pathology_requests_drug_categories_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_drugs_drug_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_drugs_drug_categories
    ADD CONSTRAINT pathology_requests_drugs_drug_categories_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_global_rule_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rule_sets
    ADD CONSTRAINT pathology_requests_global_rule_sets_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_global_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rules
    ADD CONSTRAINT pathology_requests_global_rules_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_patient_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules
    ADD CONSTRAINT pathology_requests_patient_rules_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_patient_rules_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules_requests
    ADD CONSTRAINT pathology_requests_patient_rules_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT pathology_requests_requests_pkey PRIMARY KEY (id);


--
-- Name: patient_bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_bookmarks
    ADD CONSTRAINT patient_bookmarks_pkey PRIMARY KEY (id);


--
-- Name: patient_ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_ethnicities
    ADD CONSTRAINT patient_ethnicities_pkey PRIMARY KEY (id);


--
-- Name: patient_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_languages
    ADD CONSTRAINT patient_languages_pkey PRIMARY KEY (id);


--
-- Name: patient_practices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_practices
    ADD CONSTRAINT patient_practices_pkey PRIMARY KEY (id);


--
-- Name: patient_primary_care_physicians_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_primary_care_physicians
    ADD CONSTRAINT patient_primary_care_physicians_pkey PRIMARY KEY (id);


--
-- Name: patient_religions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_religions
    ADD CONSTRAINT patient_religions_pkey PRIMARY KEY (id);


--
-- Name: patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: pd_bag_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_bag_types
    ADD CONSTRAINT pd_bag_types_pkey PRIMARY KEY (id);


--
-- Name: pd_episode_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_episode_types
    ADD CONSTRAINT pd_episode_types_pkey PRIMARY KEY (id);


--
-- Name: pd_exit_site_infections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_exit_site_infections
    ADD CONSTRAINT pd_exit_site_infections_pkey PRIMARY KEY (id);


--
-- Name: pd_fluid_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_fluid_descriptions
    ADD CONSTRAINT pd_fluid_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pd_infection_organisms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_infection_organisms
    ADD CONSTRAINT pd_infection_organisms_pkey PRIMARY KEY (id);


--
-- Name: pd_organism_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_organism_codes
    ADD CONSTRAINT pd_organism_codes_pkey PRIMARY KEY (id);


--
-- Name: pd_peritonitis_episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes
    ADD CONSTRAINT pd_peritonitis_episodes_pkey PRIMARY KEY (id);


--
-- Name: pd_regime_bags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_regime_bags
    ADD CONSTRAINT pd_regime_bags_pkey PRIMARY KEY (id);


--
-- Name: pd_regimes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_regimes
    ADD CONSTRAINT pd_regimes_pkey PRIMARY KEY (id);


--
-- Name: problem_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_notes
    ADD CONSTRAINT problem_notes_pkey PRIMARY KEY (id);


--
-- Name: problem_problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_problems
    ADD CONSTRAINT problem_problems_pkey PRIMARY KEY (id);


--
-- Name: problem_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_versions
    ADD CONSTRAINT problem_versions_pkey PRIMARY KEY (id);


--
-- Name: renal_prd_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY renal_prd_descriptions
    ADD CONSTRAINT renal_prd_descriptions_pkey PRIMARY KEY (id);


--
-- Name: renal_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY renal_profiles
    ADD CONSTRAINT renal_profiles_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: transplant_donations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donations
    ADD CONSTRAINT transplant_donations_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_followups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_followups
    ADD CONSTRAINT transplant_donor_followups_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_operations
    ADD CONSTRAINT transplant_donor_operations_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_workups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_workups
    ADD CONSTRAINT transplant_donor_workups_pkey PRIMARY KEY (id);


--
-- Name: transplant_failure_cause_description_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_description_groups
    ADD CONSTRAINT transplant_failure_cause_description_groups_pkey PRIMARY KEY (id);


--
-- Name: transplant_failure_cause_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_descriptions
    ADD CONSTRAINT transplant_failure_cause_descriptions_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_followups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_followups
    ADD CONSTRAINT transplant_recipient_followups_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_operations
    ADD CONSTRAINT transplant_recipient_operations_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_workups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_workups
    ADD CONSTRAINT transplant_recipient_workups_pkey PRIMARY KEY (id);


--
-- Name: transplant_registration_status_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registration_status_descriptions
    ADD CONSTRAINT transplant_registration_status_descriptions_pkey PRIMARY KEY (id);


--
-- Name: transplant_registration_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses
    ADD CONSTRAINT transplant_registration_statuses_pkey PRIMARY KEY (id);


--
-- Name: transplant_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registrations
    ADD CONSTRAINT transplant_registrations_pkey PRIMARY KEY (id);


--
-- Name: transplant_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_versions
    ADD CONSTRAINT transplant_versions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: access_versions_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_versions_type_id ON access_versions USING btree (item_type, item_id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: hd_versions_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX hd_versions_type_id ON hd_versions USING btree (item_type, item_id);


--
-- Name: idx_infection_organisms; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_infection_organisms ON pd_infection_organisms USING btree (organism_code_id, infectable_id, infectable_type);


--
-- Name: idx_infection_organisms_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_infection_organisms_type ON pd_infection_organisms USING btree (infectable_id, infectable_type);


--
-- Name: idx_medication_prescriptions_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_medication_prescriptions_type ON medication_prescriptions USING btree (treatable_id, treatable_type);


--
-- Name: idx_mp_patient_id_medication_route_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mp_patient_id_medication_route_id ON medication_prescriptions USING btree (patient_id, medication_route_id);


--
-- Name: index_access_assessments_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_assessments_on_created_by_id ON access_assessments USING btree (created_by_id);


--
-- Name: index_access_assessments_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_assessments_on_document ON access_assessments USING gin (document);


--
-- Name: index_access_assessments_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_assessments_on_patient_id ON access_assessments USING btree (patient_id);


--
-- Name: index_access_assessments_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_assessments_on_updated_by_id ON access_assessments USING btree (updated_by_id);


--
-- Name: index_access_procedures_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_procedures_on_created_by_id ON access_procedures USING btree (created_by_id);


--
-- Name: index_access_procedures_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_procedures_on_patient_id ON access_procedures USING btree (patient_id);


--
-- Name: index_access_procedures_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_procedures_on_updated_by_id ON access_procedures USING btree (updated_by_id);


--
-- Name: index_access_profiles_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_profiles_on_created_by_id ON access_profiles USING btree (created_by_id);


--
-- Name: index_access_profiles_on_decided_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_profiles_on_decided_by_id ON access_profiles USING btree (decided_by_id);


--
-- Name: index_access_profiles_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_profiles_on_patient_id ON access_profiles USING btree (patient_id);


--
-- Name: index_access_profiles_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_access_profiles_on_updated_by_id ON access_profiles USING btree (updated_by_id);


--
-- Name: index_addresses_on_addressable_type_and_addressable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_addressable_type_and_addressable_id ON addresses USING btree (addressable_type, addressable_id);


--
-- Name: index_clinic_visits_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinic_visits_on_created_by_id ON clinic_visits USING btree (created_by_id);


--
-- Name: index_clinic_visits_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinic_visits_on_patient_id ON clinic_visits USING btree (patient_id);


--
-- Name: index_clinic_visits_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinic_visits_on_updated_by_id ON clinic_visits USING btree (updated_by_id);


--
-- Name: index_directory_people_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_directory_people_on_created_by_id ON directory_people USING btree (created_by_id);


--
-- Name: index_directory_people_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_directory_people_on_updated_by_id ON directory_people USING btree (updated_by_id);


--
-- Name: index_doctors_practices; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_doctors_practices ON patient_practices_primary_care_physicians USING btree (primary_care_physician_id, practice_id);


--
-- Name: index_drug_types_drugs_on_drug_id_and_drug_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_drug_types_drugs_on_drug_id_and_drug_type_id ON drug_types_drugs USING btree (drug_id, drug_type_id);


--
-- Name: index_hd_dry_weights_on_assessor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_dry_weights_on_assessor_id ON hd_dry_weights USING btree (assessor_id);


--
-- Name: index_hd_dry_weights_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_dry_weights_on_created_by_id ON hd_dry_weights USING btree (created_by_id);


--
-- Name: index_hd_dry_weights_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_dry_weights_on_patient_id ON hd_dry_weights USING btree (patient_id);


--
-- Name: index_hd_dry_weights_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_dry_weights_on_updated_by_id ON hd_dry_weights USING btree (updated_by_id);


--
-- Name: index_hd_patient_statistics_on_hospital_unit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_hospital_unit_id ON hd_patient_statistics USING btree (hospital_unit_id);


--
-- Name: index_hd_patient_statistics_on_month; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_month ON hd_patient_statistics USING btree (month);


--
-- Name: index_hd_patient_statistics_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_patient_id ON hd_patient_statistics USING btree (patient_id);


--
-- Name: index_hd_patient_statistics_on_patient_id_and_month_and_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hd_patient_statistics_on_patient_id_and_month_and_year ON hd_patient_statistics USING btree (patient_id, month, year);


--
-- Name: index_hd_patient_statistics_on_patient_id_and_rolling; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hd_patient_statistics_on_patient_id_and_rolling ON hd_patient_statistics USING btree (patient_id, rolling);


--
-- Name: index_hd_patient_statistics_on_rolling; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_rolling ON hd_patient_statistics USING btree (rolling);


--
-- Name: index_hd_patient_statistics_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_year ON hd_patient_statistics USING btree (year);


--
-- Name: index_hd_preference_sets_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_created_by_id ON hd_preference_sets USING btree (created_by_id);


--
-- Name: index_hd_preference_sets_on_hospital_unit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_hospital_unit_id ON hd_preference_sets USING btree (hospital_unit_id);


--
-- Name: index_hd_preference_sets_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_patient_id ON hd_preference_sets USING btree (patient_id);


--
-- Name: index_hd_preference_sets_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_updated_by_id ON hd_preference_sets USING btree (updated_by_id);


--
-- Name: index_hd_profiles_on_active_and_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hd_profiles_on_active_and_patient_id ON hd_profiles USING btree (active, patient_id);


--
-- Name: index_hd_profiles_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_profiles_on_created_by_id ON hd_profiles USING btree (created_by_id);


--
-- Name: index_hd_profiles_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_profiles_on_document ON hd_profiles USING gin (document);


--
-- Name: index_hd_profiles_on_hospital_unit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_profiles_on_hospital_unit_id ON hd_profiles USING btree (hospital_unit_id);


--
-- Name: index_hd_profiles_on_named_nurse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_profiles_on_named_nurse_id ON hd_profiles USING btree (named_nurse_id);


--
-- Name: index_hd_profiles_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_profiles_on_patient_id ON hd_profiles USING btree (patient_id);


--
-- Name: index_hd_profiles_on_prescriber_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_profiles_on_prescriber_id ON hd_profiles USING btree (prescriber_id);


--
-- Name: index_hd_profiles_on_transport_decider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_profiles_on_transport_decider_id ON hd_profiles USING btree (transport_decider_id);


--
-- Name: index_hd_profiles_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_profiles_on_updated_by_id ON hd_profiles USING btree (updated_by_id);


--
-- Name: index_hd_sessions_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_created_by_id ON hd_sessions USING btree (created_by_id);


--
-- Name: index_hd_sessions_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_document ON hd_sessions USING gin (document);


--
-- Name: index_hd_sessions_on_dry_weight_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_dry_weight_id ON hd_sessions USING btree (dry_weight_id);


--
-- Name: index_hd_sessions_on_hospital_unit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_hospital_unit_id ON hd_sessions USING btree (hospital_unit_id);


--
-- Name: index_hd_sessions_on_modality_description_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_modality_description_id ON hd_sessions USING btree (modality_description_id);


--
-- Name: index_hd_sessions_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_patient_id ON hd_sessions USING btree (patient_id);


--
-- Name: index_hd_sessions_on_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_profile_id ON hd_sessions USING btree (profile_id);


--
-- Name: index_hd_sessions_on_signed_off_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_signed_off_by_id ON hd_sessions USING btree (signed_off_by_id);


--
-- Name: index_hd_sessions_on_signed_on_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_signed_on_by_id ON hd_sessions USING btree (signed_on_by_id);


--
-- Name: index_hd_sessions_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hd_sessions_on_updated_by_id ON hd_sessions USING btree (updated_by_id);


--
-- Name: index_hospital_centres_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hospital_centres_on_code ON hospital_centres USING btree (code);


--
-- Name: index_letter_archives_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_archives_on_created_by_id ON letter_archives USING btree (created_by_id);


--
-- Name: index_letter_archives_on_letter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_archives_on_letter_id ON letter_archives USING btree (letter_id);


--
-- Name: index_letter_archives_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_archives_on_updated_by_id ON letter_archives USING btree (updated_by_id);


--
-- Name: index_letter_contact_descriptions_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_name ON letter_contact_descriptions USING btree (name);


--
-- Name: index_letter_contact_descriptions_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_position ON letter_contact_descriptions USING btree ("position");


--
-- Name: index_letter_contact_descriptions_on_system_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_system_code ON letter_contact_descriptions USING btree (system_code);


--
-- Name: index_letter_contacts_on_person_id_and_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_letter_contacts_on_person_id_and_patient_id ON letter_contacts USING btree (person_id, patient_id);


--
-- Name: index_letter_letters_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_letters_on_author_id ON letter_letters USING btree (author_id);


--
-- Name: index_letter_letters_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_letters_on_created_by_id ON letter_letters USING btree (created_by_id);


--
-- Name: index_letter_letters_on_event_type_and_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_letters_on_event_type_and_event_id ON letter_letters USING btree (event_type, event_id);


--
-- Name: index_letter_letters_on_letterhead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_letters_on_letterhead_id ON letter_letters USING btree (letterhead_id);


--
-- Name: index_letter_letters_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_letters_on_patient_id ON letter_letters USING btree (patient_id);


--
-- Name: index_letter_letters_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_letters_on_updated_by_id ON letter_letters USING btree (updated_by_id);


--
-- Name: index_letter_recipients_on_addressee_type_and_addressee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_recipients_on_addressee_type_and_addressee_id ON letter_recipients USING btree (addressee_type, addressee_id);


--
-- Name: index_letter_recipients_on_letter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_recipients_on_letter_id ON letter_recipients USING btree (letter_id);


--
-- Name: index_letter_signatures_on_letter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_signatures_on_letter_id ON letter_signatures USING btree (letter_id);


--
-- Name: index_letter_signatures_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letter_signatures_on_user_id ON letter_signatures USING btree (user_id);


--
-- Name: index_medication_prescription_terminations_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_created_by_id ON medication_prescription_terminations USING btree (created_by_id);


--
-- Name: index_medication_prescription_terminations_on_prescription_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_prescription_id ON medication_prescription_terminations USING btree (prescription_id);


--
-- Name: index_medication_prescription_terminations_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_updated_by_id ON medication_prescription_terminations USING btree (updated_by_id);


--
-- Name: index_medication_prescription_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescription_versions_on_item_type_and_item_id ON medication_prescription_versions USING btree (item_type, item_id);


--
-- Name: index_medication_prescriptions_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_created_by_id ON medication_prescriptions USING btree (created_by_id);


--
-- Name: index_medication_prescriptions_on_drug_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_drug_id ON medication_prescriptions USING btree (drug_id);


--
-- Name: index_medication_prescriptions_on_drug_id_and_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_drug_id_and_patient_id ON medication_prescriptions USING btree (drug_id, patient_id);


--
-- Name: index_medication_prescriptions_on_medication_route_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_medication_route_id ON medication_prescriptions USING btree (medication_route_id);


--
-- Name: index_medication_prescriptions_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_patient_id ON medication_prescriptions USING btree (patient_id);


--
-- Name: index_medication_prescriptions_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_updated_by_id ON medication_prescriptions USING btree (updated_by_id);


--
-- Name: index_modality_modalities_on_description_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_modality_modalities_on_description_id ON modality_modalities USING btree (description_id);


--
-- Name: index_modality_modalities_on_reason_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_modality_modalities_on_reason_id ON modality_modalities USING btree (reason_id);


--
-- Name: index_pathology_observation_requests_on_description_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_description_id ON pathology_observation_requests USING btree (description_id);


--
-- Name: index_pathology_observation_requests_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_patient_id ON pathology_observation_requests USING btree (patient_id);


--
-- Name: index_pathology_observations_on_description_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pathology_observations_on_description_id ON pathology_observations USING btree (description_id);


--
-- Name: index_pathology_observations_on_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pathology_observations_on_request_id ON pathology_observations USING btree (request_id);


--
-- Name: index_patient_bookmarks_on_patient_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_patient_bookmarks_on_patient_id_and_user_id ON patient_bookmarks USING btree (patient_id, user_id);


--
-- Name: index_patient_practices_primary_care_physicians_on_practice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patient_practices_primary_care_physicians_on_practice_id ON patient_practices_primary_care_physicians USING btree (practice_id);


--
-- Name: index_patient_primary_care_physicians_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_patient_primary_care_physicians_on_code ON patient_primary_care_physicians USING btree (code);


--
-- Name: index_patients_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_created_by_id ON patients USING btree (created_by_id);


--
-- Name: index_patients_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_document ON patients USING gin (document);


--
-- Name: index_patients_on_primary_care_physician_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_primary_care_physician_id ON patients USING btree (primary_care_physician_id);


--
-- Name: index_patients_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_updated_by_id ON patients USING btree (updated_by_id);


--
-- Name: index_pd_bag_types_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pd_bag_types_on_deleted_at ON pd_bag_types USING btree (deleted_at);


--
-- Name: index_pd_peritonitis_episodes_on_episode_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pd_peritonitis_episodes_on_episode_type_id ON pd_peritonitis_episodes USING btree (episode_type_id);


--
-- Name: index_pd_peritonitis_episodes_on_fluid_description_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pd_peritonitis_episodes_on_fluid_description_id ON pd_peritonitis_episodes USING btree (fluid_description_id);


--
-- Name: index_problem_notes_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_problem_notes_on_created_by_id ON problem_notes USING btree (created_by_id);


--
-- Name: index_problem_notes_on_problem_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_problem_notes_on_problem_id ON problem_notes USING btree (problem_id);


--
-- Name: index_problem_notes_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_problem_notes_on_updated_by_id ON problem_notes USING btree (updated_by_id);


--
-- Name: index_problem_problems_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_problem_problems_on_deleted_at ON problem_problems USING btree (deleted_at);


--
-- Name: index_problem_problems_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_problem_problems_on_position ON problem_problems USING btree ("position");


--
-- Name: index_problem_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_problem_versions_on_item_type_and_item_id ON problem_versions USING btree (item_type, item_id);


--
-- Name: index_renal_profiles_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_renal_profiles_on_document ON renal_profiles USING gin (document);


--
-- Name: index_transplant_donations_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_donations_on_patient_id ON transplant_donations USING btree (patient_id);


--
-- Name: index_transplant_donations_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_donations_on_recipient_id ON transplant_donations USING btree (recipient_id);


--
-- Name: index_transplant_donor_followups_on_operation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_donor_followups_on_operation_id ON transplant_donor_followups USING btree (operation_id);


--
-- Name: index_transplant_donor_operations_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_donor_operations_on_document ON transplant_donor_operations USING gin (document);


--
-- Name: index_transplant_donor_operations_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_donor_operations_on_patient_id ON transplant_donor_operations USING btree (patient_id);


--
-- Name: index_transplant_donor_workups_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_donor_workups_on_document ON transplant_donor_workups USING gin (document);


--
-- Name: index_transplant_donor_workups_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_donor_workups_on_patient_id ON transplant_donor_workups USING btree (patient_id);


--
-- Name: index_transplant_failure_cause_descriptions_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_transplant_failure_cause_descriptions_on_code ON transplant_failure_cause_descriptions USING btree (code);


--
-- Name: index_transplant_recipient_followups_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_recipient_followups_on_document ON transplant_recipient_followups USING gin (document);


--
-- Name: index_transplant_recipient_followups_on_operation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_recipient_followups_on_operation_id ON transplant_recipient_followups USING btree (operation_id);


--
-- Name: index_transplant_recipient_operations_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_document ON transplant_recipient_operations USING gin (document);


--
-- Name: index_transplant_recipient_operations_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_patient_id ON transplant_recipient_operations USING btree (patient_id);


--
-- Name: index_transplant_recipient_workups_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_document ON transplant_recipient_workups USING gin (document);


--
-- Name: index_transplant_recipient_workups_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_patient_id ON transplant_recipient_workups USING btree (patient_id);


--
-- Name: index_transplant_registration_status_descriptions_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_registration_status_descriptions_on_code ON transplant_registration_status_descriptions USING btree (code);


--
-- Name: index_transplant_registration_statuses_on_description_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_description_id ON transplant_registration_statuses USING btree (description_id);


--
-- Name: index_transplant_registration_statuses_on_registration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_registration_id ON transplant_registration_statuses USING btree (registration_id);


--
-- Name: index_transplant_registrations_on_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_registrations_on_document ON transplant_registrations USING gin (document);


--
-- Name: index_transplant_registrations_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transplant_registrations_on_patient_id ON transplant_registrations USING btree (patient_id);


--
-- Name: index_users_on_approved; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_approved ON users USING btree (approved);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_expired_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_expired_at ON users USING btree (expired_at);


--
-- Name: index_users_on_last_activity_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_last_activity_at ON users USING btree (last_activity_at);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: tx_versions_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tx_versions_type_id ON transplant_versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_01ec61436d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_01ec61436d FOREIGN KEY (religion_id) REFERENCES patient_religions(id);


--
-- Name: fk_rails_042462eeb9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_042462eeb9 FOREIGN KEY (language_id) REFERENCES patient_languages(id);


--
-- Name: fk_rails_0447199042; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT fk_rails_0447199042 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_050f679712; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observation_requests
    ADD CONSTRAINT fk_rails_050f679712 FOREIGN KEY (description_id) REFERENCES pathology_request_descriptions(id);


--
-- Name: fk_rails_06517764c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules_requests
    ADD CONSTRAINT fk_rails_06517764c3 FOREIGN KEY (patient_rule_id) REFERENCES pathology_requests_patient_rules(id);


--
-- Name: fk_rails_0aab25a07c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_0aab25a07c FOREIGN KEY (named_nurse_id) REFERENCES users(id);


--
-- Name: fk_rails_0b66891291; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donations
    ADD CONSTRAINT fk_rails_0b66891291 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_11c7f6fec3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT fk_rails_11c7f6fec3 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_15f58845a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules
    ADD CONSTRAINT fk_rails_15f58845a2 FOREIGN KEY (lab_id) REFERENCES pathology_labs(id);


--
-- Name: fk_rails_17327d4301; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_17327d4301 FOREIGN KEY (medication_route_id) REFERENCES medication_routes(id);


--
-- Name: fk_rails_18650a2566; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT fk_rails_18650a2566 FOREIGN KEY (site_id) REFERENCES access_sites(id);


--
-- Name: fk_rails_1f3fb8ef97; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations
    ADD CONSTRAINT fk_rails_1f3fb8ef97 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: fk_rails_21e1b74109; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT fk_rails_21e1b74109 FOREIGN KEY (description_id) REFERENCES modality_descriptions(id);


--
-- Name: fk_rails_24de49b694; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_drugs_drug_categories
    ADD CONSTRAINT fk_rails_24de49b694 FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: fk_rails_25e627b557; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_25e627b557 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_27e92c81fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_27e92c81fe FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: fk_rails_2ae6a3ad59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_2ae6a3ad59 FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: fk_rails_2bd34b98f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations
    ADD CONSTRAINT fk_rails_2bd34b98f9 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: fk_rails_31546389ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_dry_weights
    ADD CONSTRAINT fk_rails_31546389ab FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_324e505f46; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_dry_weights
    ADD CONSTRAINT fk_rails_324e505f46 FOREIGN KEY (assessor_id) REFERENCES users(id);


--
-- Name: fk_rails_32f4ff205a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses
    ADD CONSTRAINT fk_rails_32f4ff205a FOREIGN KEY (registration_id) REFERENCES transplant_registrations(id);


--
-- Name: fk_rails_33f3612955; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registrations
    ADD CONSTRAINT fk_rails_33f3612955 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_33f61c70e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_contacts
    ADD CONSTRAINT fk_rails_33f61c70e6 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_36cb307ab5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses
    ADD CONSTRAINT fk_rails_36cb307ab5 FOREIGN KEY (description_id) REFERENCES transplant_registration_status_descriptions(id);


--
-- Name: fk_rails_3916726775; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions_requests_requests
    ADD CONSTRAINT fk_rails_3916726775 FOREIGN KEY (request_id) REFERENCES pathology_requests_requests(id);


--
-- Name: fk_rails_39983ddc03; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT fk_rails_39983ddc03 FOREIGN KEY (letterhead_id) REFERENCES letter_letterheads(id);


--
-- Name: fk_rails_39da21b3fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions
    ADD CONSTRAINT fk_rails_39da21b3fe FOREIGN KEY (required_observation_description_id) REFERENCES pathology_observation_descriptions(id);


--
-- Name: fk_rails_3a852d1667; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_operations
    ADD CONSTRAINT fk_rails_3a852d1667 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_3bafe36805; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_types_drugs
    ADD CONSTRAINT fk_rails_3bafe36805 FOREIGN KEY (drug_type_id) REFERENCES drug_types(id);


--
-- Name: fk_rails_3e035fe47f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_3e035fe47f FOREIGN KEY (profile_id) REFERENCES hd_profiles(id);


--
-- Name: fk_rails_3e0f147311; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_3e0f147311 FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: fk_rails_3e725c96fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT fk_rails_3e725c96fc FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_3f47dd9cc1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_bookmarks
    ADD CONSTRAINT fk_rails_3f47dd9cc1 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_40e23de825; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rule_sets
    ADD CONSTRAINT fk_rails_40e23de825 FOREIGN KEY (clinic_id) REFERENCES clinics(id);


--
-- Name: fk_rails_506a7ce21d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT fk_rails_506a7ce21d FOREIGN KEY (type_id) REFERENCES access_types(id);


--
-- Name: fk_rails_55ecff6804; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_practices_primary_care_physicians
    ADD CONSTRAINT fk_rails_55ecff6804 FOREIGN KEY (primary_care_physician_id) REFERENCES patient_primary_care_physicians(id);


--
-- Name: fk_rails_563fedb262; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_563fedb262 FOREIGN KEY (dry_weight_id) REFERENCES hd_dry_weights(id);


--
-- Name: fk_rails_568750244e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY renal_profiles
    ADD CONSTRAINT fk_rails_568750244e FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_571a3cadda; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_workups
    ADD CONSTRAINT fk_rails_571a3cadda FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_5b44e541da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_5b44e541da FOREIGN KEY (ethnicity_id) REFERENCES patient_ethnicities(id);


--
-- Name: fk_rails_604fdf3a9e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT fk_rails_604fdf3a9e FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_60aca3bf58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_signatures
    ADD CONSTRAINT fk_rails_60aca3bf58 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_617c726b94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT fk_rails_617c726b94 FOREIGN KEY (consultant_id) REFERENCES users(id);


--
-- Name: fk_rails_6191e75b3b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT fk_rails_6191e75b3b FOREIGN KEY (author_id) REFERENCES users(id);


--
-- Name: fk_rails_6231b53275; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_6231b53275 FOREIGN KEY (second_edta_code_id) REFERENCES death_edta_codes(id);


--
-- Name: fk_rails_6893ba0593; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_followups
    ADD CONSTRAINT fk_rails_6893ba0593 FOREIGN KEY (transplant_failure_cause_description_id) REFERENCES transplant_failure_cause_descriptions(id);


--
-- Name: fk_rails_6951f9dee7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_6951f9dee7 FOREIGN KEY (first_edta_code_id) REFERENCES death_edta_codes(id);


--
-- Name: fk_rails_6a44f3907b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_notes
    ADD CONSTRAINT fk_rails_6a44f3907b FOREIGN KEY (problem_id) REFERENCES problem_problems(id);


--
-- Name: fk_rails_70ef87ad18; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observations
    ADD CONSTRAINT fk_rails_70ef87ad18 FOREIGN KEY (request_id) REFERENCES pathology_observation_requests(id);


--
-- Name: fk_rails_7345be7c22; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_7345be7c22 FOREIGN KEY (primary_care_physician_id) REFERENCES patient_primary_care_physicians(id);


--
-- Name: fk_rails_751ed7515f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_751ed7515f FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_75f14fef31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_75f14fef31 FOREIGN KEY (event_type_id) REFERENCES event_types(id);


--
-- Name: fk_rails_78dc63040c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_followups
    ADD CONSTRAINT fk_rails_78dc63040c FOREIGN KEY (operation_id) REFERENCES transplant_recipient_operations(id);


--
-- Name: fk_rails_7a89922302; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_practices_primary_care_physicians
    ADD CONSTRAINT fk_rails_7a89922302 FOREIGN KEY (practice_id) REFERENCES patient_practices(id);


--
-- Name: fk_rails_7dc4363735; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_archives
    ADD CONSTRAINT fk_rails_7dc4363735 FOREIGN KEY (letter_id) REFERENCES letter_letters(id);


--
-- Name: fk_rails_89630f47ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_89630f47ee FOREIGN KEY (transport_decider_id) REFERENCES users(id);


--
-- Name: fk_rails_8d75e5423f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT fk_rails_8d75e5423f FOREIGN KEY (decided_by_id) REFERENCES users(id);


--
-- Name: fk_rails_8f3a7fc1c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hospital_units
    ADD CONSTRAINT fk_rails_8f3a7fc1c7 FOREIGN KEY (hospital_centre_id) REFERENCES hospital_centres(id);


--
-- Name: fk_rails_8f574ed703; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions_requests_requests
    ADD CONSTRAINT fk_rails_8f574ed703 FOREIGN KEY (request_description_id) REFERENCES pathology_request_descriptions(id);


--
-- Name: fk_rails_909dcaaf3d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinics_appointments
    ADD CONSTRAINT fk_rails_909dcaaf3d FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_9183cb4170; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_descriptions
    ADD CONSTRAINT fk_rails_9183cb4170 FOREIGN KEY (group_id) REFERENCES transplant_failure_cause_description_groups(id);


--
-- Name: fk_rails_93dc1108f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_workups
    ADD CONSTRAINT fk_rails_93dc1108f3 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_9702c22886; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_exit_site_infections
    ADD CONSTRAINT fk_rails_9702c22886 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_9739853ad1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_9739853ad1 FOREIGN KEY (primary_care_physician_id) REFERENCES patient_primary_care_physicians(id);


--
-- Name: fk_rails_9c76b7ba29; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_recipients
    ADD CONSTRAINT fk_rails_9c76b7ba29 FOREIGN KEY (letter_id) REFERENCES letter_letters(id);


--
-- Name: fk_rails_9dada905f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT fk_rails_9dada905f6 FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: fk_rails_9dbbc5bfd0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT fk_rails_9dbbc5bfd0 FOREIGN KEY (type_id) REFERENCES access_types(id);


--
-- Name: fk_rails_a0b9cd97fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions
    ADD CONSTRAINT fk_rails_a0b9cd97fe FOREIGN KEY (lab_id) REFERENCES pathology_labs(id);


--
-- Name: fk_rails_a0d87208a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_contacts
    ADD CONSTRAINT fk_rails_a0d87208a0 FOREIGN KEY (description_id) REFERENCES letter_contact_descriptions(id);


--
-- Name: fk_rails_a3afae15cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_a3afae15cb FOREIGN KEY (modality_description_id) REFERENCES modality_descriptions(id);


--
-- Name: fk_rails_a5852d1710; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_contacts
    ADD CONSTRAINT fk_rails_a5852d1710 FOREIGN KEY (person_id) REFERENCES directory_people(id);


--
-- Name: fk_rails_a654a17f8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_patient_statistics
    ADD CONSTRAINT fk_rails_a654a17f8d FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: fk_rails_a70920e237; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_regimes
    ADD CONSTRAINT fk_rails_a70920e237 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_a850498c88; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_drugs_drug_categories
    ADD CONSTRAINT fk_rails_a850498c88 FOREIGN KEY (drug_category_id) REFERENCES pathology_requests_drug_categories(id);


--
-- Name: fk_rails_a8d58d31e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT fk_rails_a8d58d31e6 FOREIGN KEY (clinic_id) REFERENCES clinics(id);


--
-- Name: fk_rails_ac8e970c42; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT fk_rails_ac8e970c42 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_acbcae03df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT fk_rails_acbcae03df FOREIGN KEY (type_id) REFERENCES access_types(id);


--
-- Name: fk_rails_ae56e9fe7e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_ae56e9fe7e FOREIGN KEY (episode_type_id) REFERENCES pd_episode_types(id);


--
-- Name: fk_rails_b13e09c8a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules
    ADD CONSTRAINT fk_rails_b13e09c8a3 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_b163068880; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_patient_statistics
    ADD CONSTRAINT fk_rails_b163068880 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_b1b697cf23; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_practices_primary_care_physicians
    ADD CONSTRAINT fk_rails_b1b697cf23 FOREIGN KEY (primary_care_physician_id) REFERENCES patient_primary_care_physicians(id);


--
-- Name: fk_rails_b6ee03185c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_operations
    ADD CONSTRAINT fk_rails_b6ee03185c FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_b77918cf71; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rules
    ADD CONSTRAINT fk_rails_b77918cf71 FOREIGN KEY (rule_set_id) REFERENCES pathology_requests_global_rule_sets(id);


--
-- Name: fk_rails_b7cc8fd5dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinics_appointments
    ADD CONSTRAINT fk_rails_b7cc8fd5dd FOREIGN KEY (clinic_id) REFERENCES clinics(id);


--
-- Name: fk_rails_b844dc9537; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinic_visits
    ADD CONSTRAINT fk_rails_b844dc9537 FOREIGN KEY (clinic_id) REFERENCES clinics(id);


--
-- Name: fk_rails_bd995b497c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_bd995b497c FOREIGN KEY (signed_on_by_id) REFERENCES users(id);


--
-- Name: fk_rails_c12b863727; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_bookmarks
    ADD CONSTRAINT fk_rails_c12b863727 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_c31cea56ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT fk_rails_c31cea56ac FOREIGN KEY (reason_id) REFERENCES modality_reasons(id);


--
-- Name: fk_rails_c367d368e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT fk_rails_c367d368e6 FOREIGN KEY (plan_id) REFERENCES access_plans(id);


--
-- Name: fk_rails_c75064199c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_donor_followups
    ADD CONSTRAINT fk_rails_c75064199c FOREIGN KEY (operation_id) REFERENCES transplant_donor_operations(id);


--
-- Name: fk_rails_c7b1e35b07; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_c7b1e35b07 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: fk_rails_c89b2174e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_c89b2174e9 FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: fk_rails_ca16ec591e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_regime_bags
    ADD CONSTRAINT fk_rails_ca16ec591e FOREIGN KEY (regime_id) REFERENCES pd_regimes(id);


--
-- Name: fk_rails_cd10bc0ddf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY renal_profiles
    ADD CONSTRAINT fk_rails_cd10bc0ddf FOREIGN KEY (prd_description_id) REFERENCES renal_prd_descriptions(id);


--
-- Name: fk_rails_d04ba97fc5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT fk_rails_d04ba97fc5 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_d4aaa80dee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_signatures
    ADD CONSTRAINT fk_rails_d4aaa80dee FOREIGN KEY (letter_id) REFERENCES letter_letters(id);


--
-- Name: fk_rails_d92d27629e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_d92d27629e FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_db5255e417; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observation_requests
    ADD CONSTRAINT fk_rails_db5255e417 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_dc1b1799e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_observations
    ADD CONSTRAINT fk_rails_dc1b1799e7 FOREIGN KEY (description_id) REFERENCES pathology_observation_descriptions(id);


--
-- Name: fk_rails_de0d26811a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_regime_bags
    ADD CONSTRAINT fk_rails_de0d26811a FOREIGN KEY (bag_type_id) REFERENCES pd_bag_types(id);


--
-- Name: fk_rails_df82011585; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_infection_organisms
    ADD CONSTRAINT fk_rails_df82011585 FOREIGN KEY (organism_code_id) REFERENCES pd_organism_codes(id);


--
-- Name: fk_rails_e03d4a27ce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinics_appointments
    ADD CONSTRAINT fk_rails_e03d4a27ce FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_e1899a68af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_e1899a68af FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_e2a7142459; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT fk_rails_e2a7142459 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_e32b0e0494; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_e32b0e0494 FOREIGN KEY (signed_off_by_id) REFERENCES users(id);


--
-- Name: fk_rails_e41edf9bc0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplant_recipient_operations
    ADD CONSTRAINT fk_rails_e41edf9bc0 FOREIGN KEY (hospital_centre_id) REFERENCES hospital_centres(id);


--
-- Name: fk_rails_e53c500fcd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rule_sets
    ADD CONSTRAINT fk_rails_e53c500fcd FOREIGN KEY (request_description_id) REFERENCES pathology_request_descriptions(id);


--
-- Name: fk_rails_e97a696dd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_e97a696dd5 FOREIGN KEY (fluid_description_id) REFERENCES pd_fluid_descriptions(id);


--
-- Name: fk_rails_e97e417b7d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT fk_rails_e97e417b7d FOREIGN KEY (site_id) REFERENCES access_sites(id);


--
-- Name: fk_rails_eb5294f3df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_eb5294f3df FOREIGN KEY (prescriber_id) REFERENCES users(id);


--
-- Name: fk_rails_ed137a641b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT fk_rails_ed137a641b FOREIGN KEY (site_id) REFERENCES access_sites(id);


--
-- Name: fk_rails_edf3902cb0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_problems
    ADD CONSTRAINT fk_rails_edf3902cb0 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_f0adc9d29e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinics
    ADD CONSTRAINT fk_rails_f0adc9d29e FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_f0bcae6feb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT fk_rails_f0bcae6feb FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: fk_rails_f228a98e1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_f228a98e1b FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_f2b12c3a20; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patient_practices_primary_care_physicians
    ADD CONSTRAINT fk_rails_f2b12c3a20 FOREIGN KEY (practice_id) REFERENCES patient_practices(id);


--
-- Name: fk_rails_f8ed99dfda; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY drug_types_drugs
    ADD CONSTRAINT fk_rails_f8ed99dfda FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: fk_rails_fc41021986; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules_requests
    ADD CONSTRAINT fk_rails_fc41021986 FOREIGN KEY (request_id) REFERENCES pathology_requests_requests(id);


--
-- Name: fk_rails_fe1184d31a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations
    ADD CONSTRAINT fk_rails_fe1184d31a FOREIGN KEY (prescription_id) REFERENCES medication_prescriptions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20141004150240');

INSERT INTO schema_migrations (version) VALUES ('20141010170329');

INSERT INTO schema_migrations (version) VALUES ('20141020170329');

INSERT INTO schema_migrations (version) VALUES ('20141023111038');

INSERT INTO schema_migrations (version) VALUES ('20141024111715');

INSERT INTO schema_migrations (version) VALUES ('20141024111716');

INSERT INTO schema_migrations (version) VALUES ('20141107145549');

INSERT INTO schema_migrations (version) VALUES ('20141107145614');

INSERT INTO schema_migrations (version) VALUES ('20141107145615');

INSERT INTO schema_migrations (version) VALUES ('20141208160813');

INSERT INTO schema_migrations (version) VALUES ('20141222110119');

INSERT INTO schema_migrations (version) VALUES ('20141223135723');

INSERT INTO schema_migrations (version) VALUES ('20141223135724');

INSERT INTO schema_migrations (version) VALUES ('20150109113417');

INSERT INTO schema_migrations (version) VALUES ('20150109152145');

INSERT INTO schema_migrations (version) VALUES ('20150119160039');

INSERT INTO schema_migrations (version) VALUES ('20150120155952');

INSERT INTO schema_migrations (version) VALUES ('20150203161438');

INSERT INTO schema_migrations (version) VALUES ('20150213103855');

INSERT INTO schema_migrations (version) VALUES ('20150213103856');

INSERT INTO schema_migrations (version) VALUES ('20150213103857');

INSERT INTO schema_migrations (version) VALUES ('20150224140027');

INSERT INTO schema_migrations (version) VALUES ('20150302171638');

INSERT INTO schema_migrations (version) VALUES ('20150312112909');

INSERT INTO schema_migrations (version) VALUES ('20150312113937');

INSERT INTO schema_migrations (version) VALUES ('20150313124325');

INSERT INTO schema_migrations (version) VALUES ('20150514113239');

INSERT INTO schema_migrations (version) VALUES ('20150515154952');

INSERT INTO schema_migrations (version) VALUES ('20150515155052');

INSERT INTO schema_migrations (version) VALUES ('20150602151910');

INSERT INTO schema_migrations (version) VALUES ('20150605095934');

INSERT INTO schema_migrations (version) VALUES ('20150605151945');

INSERT INTO schema_migrations (version) VALUES ('20150608093000');

INSERT INTO schema_migrations (version) VALUES ('20150608093001');

INSERT INTO schema_migrations (version) VALUES ('20150608093002');

INSERT INTO schema_migrations (version) VALUES ('20150623083220');

INSERT INTO schema_migrations (version) VALUES ('20150623105816');

INSERT INTO schema_migrations (version) VALUES ('20150701104744');

INSERT INTO schema_migrations (version) VALUES ('20150702084036');

INSERT INTO schema_migrations (version) VALUES ('20150709152737');

INSERT INTO schema_migrations (version) VALUES ('20150717093153');

INSERT INTO schema_migrations (version) VALUES ('20150923201215');

INSERT INTO schema_migrations (version) VALUES ('20151014205537');

INSERT INTO schema_migrations (version) VALUES ('20151021194419');

INSERT INTO schema_migrations (version) VALUES ('20151022184845');

INSERT INTO schema_migrations (version) VALUES ('20151022190252');

INSERT INTO schema_migrations (version) VALUES ('20151103210628');

INSERT INTO schema_migrations (version) VALUES ('20151104183740');

INSERT INTO schema_migrations (version) VALUES ('20151111194419');

INSERT INTO schema_migrations (version) VALUES ('20151116111600');

INSERT INTO schema_migrations (version) VALUES ('20151116170100');

INSERT INTO schema_migrations (version) VALUES ('20151116170200');

INSERT INTO schema_migrations (version) VALUES ('20151207163303');

INSERT INTO schema_migrations (version) VALUES ('20151207163304');

INSERT INTO schema_migrations (version) VALUES ('20151207167020');

INSERT INTO schema_migrations (version) VALUES ('20160106167020');

INSERT INTO schema_migrations (version) VALUES ('20160114222043');

INSERT INTO schema_migrations (version) VALUES ('20160120203747');

INSERT INTO schema_migrations (version) VALUES ('20160120203748');

INSERT INTO schema_migrations (version) VALUES ('20160120203753');

INSERT INTO schema_migrations (version) VALUES ('20160120203754');

INSERT INTO schema_migrations (version) VALUES ('20160120203755');

INSERT INTO schema_migrations (version) VALUES ('20160120213000');

INSERT INTO schema_migrations (version) VALUES ('20160120213001');

INSERT INTO schema_migrations (version) VALUES ('20160121175711');

INSERT INTO schema_migrations (version) VALUES ('20160121175712');

INSERT INTO schema_migrations (version) VALUES ('20160202152252');

INSERT INTO schema_migrations (version) VALUES ('20160203160040');

INSERT INTO schema_migrations (version) VALUES ('20160203160041');

INSERT INTO schema_migrations (version) VALUES ('20160208153327');

INSERT INTO schema_migrations (version) VALUES ('20160209203446');

INSERT INTO schema_migrations (version) VALUES ('20160218220145');

INSERT INTO schema_migrations (version) VALUES ('20160302192055');

INSERT INTO schema_migrations (version) VALUES ('20160303151449');

INSERT INTO schema_migrations (version) VALUES ('20160303151540');

INSERT INTO schema_migrations (version) VALUES ('20160304151449');

INSERT INTO schema_migrations (version) VALUES ('20160304151540');

INSERT INTO schema_migrations (version) VALUES ('20160304162205');

INSERT INTO schema_migrations (version) VALUES ('20160314181446');

INSERT INTO schema_migrations (version) VALUES ('20160327221550');

INSERT INTO schema_migrations (version) VALUES ('20160412123106');

INSERT INTO schema_migrations (version) VALUES ('20160419132410');

INSERT INTO schema_migrations (version) VALUES ('20160420132524');

INSERT INTO schema_migrations (version) VALUES ('20160426093341');

INSERT INTO schema_migrations (version) VALUES ('20160426112409');

INSERT INTO schema_migrations (version) VALUES ('20160503113814');

INSERT INTO schema_migrations (version) VALUES ('20160505142813');

INSERT INTO schema_migrations (version) VALUES ('20160505151102');

INSERT INTO schema_migrations (version) VALUES ('20160506104710');

INSERT INTO schema_migrations (version) VALUES ('20160506151356');

INSERT INTO schema_migrations (version) VALUES ('20160509134401');

INSERT INTO schema_migrations (version) VALUES ('20160509134929');

INSERT INTO schema_migrations (version) VALUES ('20160509151927');

INSERT INTO schema_migrations (version) VALUES ('20160509171244');

INSERT INTO schema_migrations (version) VALUES ('20160510155932');

INSERT INTO schema_migrations (version) VALUES ('20160518110836');

INSERT INTO schema_migrations (version) VALUES ('20160518111325');

INSERT INTO schema_migrations (version) VALUES ('20160524171947');

INSERT INTO schema_migrations (version) VALUES ('20160525124151');

INSERT INTO schema_migrations (version) VALUES ('20160527104432');

INSERT INTO schema_migrations (version) VALUES ('20160530162708');

INSERT INTO schema_migrations (version) VALUES ('20160530162720');

INSERT INTO schema_migrations (version) VALUES ('20160530170058');

INSERT INTO schema_migrations (version) VALUES ('20160531141853');

INSERT INTO schema_migrations (version) VALUES ('20160613120910');

INSERT INTO schema_migrations (version) VALUES ('20160616163622');

INSERT INTO schema_migrations (version) VALUES ('20160620131148');

INSERT INTO schema_migrations (version) VALUES ('20160628141349');

INSERT INTO schema_migrations (version) VALUES ('20160726150709');

INSERT INTO schema_migrations (version) VALUES ('20160726170852');

INSERT INTO schema_migrations (version) VALUES ('20160728094200');

INSERT INTO schema_migrations (version) VALUES ('20160728103933');

INSERT INTO schema_migrations (version) VALUES ('20160729083654');

INSERT INTO schema_migrations (version) VALUES ('20160729095901');

INSERT INTO schema_migrations (version) VALUES ('20160805120015');

INSERT INTO schema_migrations (version) VALUES ('20160809095951');

INSERT INTO schema_migrations (version) VALUES ('20160812073616');

INSERT INTO schema_migrations (version) VALUES ('20160812073900');

INSERT INTO schema_migrations (version) VALUES ('20160817095514');

INSERT INTO schema_migrations (version) VALUES ('20160818131917');

INSERT INTO schema_migrations (version) VALUES ('20160822130644');

INSERT INTO schema_migrations (version) VALUES ('20160823173525');

INSERT INTO schema_migrations (version) VALUES ('20160824132805');

INSERT INTO schema_migrations (version) VALUES ('20160829114845');

INSERT INTO schema_migrations (version) VALUES ('20160830141439');

INSERT INTO schema_migrations (version) VALUES ('20160905140623');

INSERT INTO schema_migrations (version) VALUES ('20160906195949');

INSERT INTO schema_migrations (version) VALUES ('20160916113152');

INSERT INTO schema_migrations (version) VALUES ('20160922154638');

INSERT INTO schema_migrations (version) VALUES ('20160930111424');

INSERT INTO schema_migrations (version) VALUES ('20161003192717');

INSERT INTO schema_migrations (version) VALUES ('20161003204347');

INSERT INTO schema_migrations (version) VALUES ('20161004185820');

INSERT INTO schema_migrations (version) VALUES ('20161010191529');

INSERT INTO schema_migrations (version) VALUES ('20161014134639');

INSERT INTO schema_migrations (version) VALUES ('20161018174711');

INSERT INTO schema_migrations (version) VALUES ('20161019145606');

INSERT INTO schema_migrations (version) VALUES ('20161027165025');

INSERT INTO schema_migrations (version) VALUES ('20161028145040');

INSERT INTO schema_migrations (version) VALUES ('20161031170940');

INSERT INTO schema_migrations (version) VALUES ('20161101105519');

INSERT INTO schema_migrations (version) VALUES ('20161103091319');

INSERT INTO schema_migrations (version) VALUES ('20161107141354');

INSERT INTO schema_migrations (version) VALUES ('20161108123101');

INSERT INTO schema_migrations (version) VALUES ('20161111154939');

INSERT INTO schema_migrations (version) VALUES ('20161114184444');

