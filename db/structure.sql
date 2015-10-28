--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    street_1 character varying,
    street_2 character varying,
    county character varying,
    city character varying,
    postcode character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    country character varying
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
-- Name: bag_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bag_types (
    id integer NOT NULL,
    manufacturer character varying,
    description character varying,
    glucose_grams_per_litre numeric(4,1),
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
-- Name: bag_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bag_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bag_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bag_types_id_seq OWNED BY bag_types.id;


--
-- Name: clinic_visits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: doctors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE doctors (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    email character varying,
    code character varying,
    address_id integer,
    practitioner_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE doctors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE doctors_id_seq OWNED BY doctors.id;


--
-- Name: doctors_practices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE doctors_practices (
    doctor_id integer,
    practice_id integer
);


--
-- Name: drug_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: drug_types_drugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drug_types_drugs (
    drug_id integer,
    drug_type_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: drugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE drugs (
    id integer NOT NULL,
    name character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- Name: edta_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE edta_codes (
    id integer NOT NULL,
    code integer,
    death_cause character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: edta_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE edta_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edta_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE edta_codes_id_seq OWNED BY edta_codes.id;


--
-- Name: episode_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE episode_types (
    id integer NOT NULL,
    term character varying,
    definition character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: episode_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE episode_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: episode_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE episode_types_id_seq OWNED BY episode_types.id;


--
-- Name: esrf; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE esrf (
    id integer NOT NULL,
    patient_id integer,
    diagnosed_on date,
    prd_description_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: esrf_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE esrf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: esrf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE esrf_id_seq OWNED BY esrf.id;


--
-- Name: ethnicities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ethnicities (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ethnicities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ethnicities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ethnicities_id_seq OWNED BY ethnicities.id;


--
-- Name: event_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_types (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying,
    deleted_at timestamp without time zone
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
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    date_time timestamp without time zone,
    description character varying,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    event_type_id integer,
    patient_id integer
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
-- Name: exit_site_infections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE exit_site_infections (
    id integer NOT NULL,
    patient_id integer,
    diagnosis_date date,
    treatment text,
    outcome text,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: exit_site_infections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exit_site_infections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exit_site_infections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exit_site_infections_id_seq OWNED BY exit_site_infections.id;


--
-- Name: fluid_descriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fluid_descriptions (
    id integer NOT NULL,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fluid_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fluid_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fluid_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fluid_descriptions_id_seq OWNED BY fluid_descriptions.id;


--
-- Name: infection_organisms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE infection_organisms (
    id integer NOT NULL,
    organism_code_id integer,
    sensitivity text,
    infectable_id integer,
    infectable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: infection_organisms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE infection_organisms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: infection_organisms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE infection_organisms_id_seq OWNED BY infection_organisms.id;


--
-- Name: letter_descriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: letters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE letters (
    id integer NOT NULL,
    state character varying DEFAULT 'draft'::character varying NOT NULL,
    type character varying NOT NULL,
    letter_description_id integer NOT NULL,
    problems text,
    medications text,
    body text,
    signature character varying,
    recipient character varying DEFAULT 'doctor'::character varying NOT NULL,
    additional_recipients character varying,
    doctor_id integer,
    patient_id integer,
    clinic_visit_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    author_id integer,
    reviewer_id integer,
    recipient_address_id integer
);


--
-- Name: letters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letters_id_seq OWNED BY letters.id;


--
-- Name: medication_routes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medication_routes (
    id integer NOT NULL,
    name character varying,
    full_name character varying,
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
-- Name: medication_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medication_versions (
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
-- Name: medication_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medication_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medication_versions_id_seq OWNED BY medication_versions.id;


--
-- Name: medications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medications (
    id integer NOT NULL,
    patient_id integer,
    medicatable_id integer,
    medicatable_type character varying,
    treatable_id integer,
    treatable_type character varying,
    dose character varying,
    medication_route_id integer,
    frequency character varying,
    notes text,
    start_date date,
    end_date date,
    provider integer,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: medications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medications_id_seq OWNED BY medications.id;


--
-- Name: modalities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE modalities (
    id integer NOT NULL,
    patient_id integer,
    modality_code_id integer,
    modality_reason_id integer,
    modal_change_type character varying,
    notes text,
    start_date date,
    end_date date,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: modalities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE modalities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modalities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE modalities_id_seq OWNED BY modalities.id;


--
-- Name: modality_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE modality_codes (
    id integer NOT NULL,
    code character varying,
    name character varying,
    site character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: modality_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE modality_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE modality_codes_id_seq OWNED BY modality_codes.id;


--
-- Name: modality_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE modality_reasons (
    id integer NOT NULL,
    type character varying,
    rr_code integer,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- Name: organism_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organism_codes (
    id integer NOT NULL,
    read_code character varying,
    name character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organism_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organism_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organism_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organism_codes_id_seq OWNED BY organism_codes.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE patients (
    id integer NOT NULL,
    nhs_number character varying,
    local_patient_id character varying,
    family_name character varying,
    given_name character varying,
    born_on date,
    paediatric_patient_indicator boolean,
    sex character varying,
    ethnicity_id integer,
    current_address_id integer,
    address_at_diagnosis_id integer,
    gp_practice_code character varying,
    pct_org_code character varying,
    hospital_centre_code character varying,
    primary_esrf_centre character varying,
    died_on date,
    first_edta_code_id integer,
    second_edta_code_id integer,
    death_notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    practice_id integer,
    doctor_id integer
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
-- Name: pd_regime_bags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pd_regime_bags (
    id integer NOT NULL,
    pd_regime_id integer,
    bag_type_id integer,
    volume integer,
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
-- Name: pd_regimes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pd_regimes (
    id integer NOT NULL,
    patient_id integer,
    start_date date,
    end_date date,
    treatment character varying,
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: peritonitis_episodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peritonitis_episodes (
    id integer NOT NULL,
    patient_id integer,
    diagnosis_date date,
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
-- Name: peritonitis_episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE peritonitis_episodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: peritonitis_episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE peritonitis_episodes_id_seq OWNED BY peritonitis_episodes.id;


--
-- Name: practices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE practices (
    id integer NOT NULL,
    name character varying,
    email character varying,
    code character varying,
    address_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: practices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE practices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: practices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE practices_id_seq OWNED BY practices.id;


--
-- Name: prd_descriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prd_descriptions (
    id integer NOT NULL,
    code character varying,
    term character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: prd_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prd_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prd_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prd_descriptions_id_seq OWNED BY prd_descriptions.id;


--
-- Name: problem_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: problems; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE problems (
    id integer NOT NULL,
    patient_id integer,
    description character varying,
    date date,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: problems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE problems_id_seq OWNED BY problems.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles_users (
    role_id integer,
    user_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: transplants_donor_workup_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transplants_donor_workup_versions (
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
-- Name: transplants_donor_workup_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplants_donor_workup_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplants_donor_workup_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplants_donor_workup_versions_id_seq OWNED BY transplants_donor_workup_versions.id;


--
-- Name: transplants_donor_workups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transplants_donor_workups (
    id integer NOT NULL,
    patient_id integer,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplants_donor_workups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplants_donor_workups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplants_donor_workups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplants_donor_workups_id_seq OWNED BY transplants_donor_workups.id;


--
-- Name: transplants_recipient_workup_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transplants_recipient_workup_versions (
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
-- Name: transplants_recipient_workup_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplants_recipient_workup_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplants_recipient_workup_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplants_recipient_workup_versions_id_seq OWNED BY transplants_recipient_workup_versions.id;


--
-- Name: transplants_recipient_workups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transplants_recipient_workups (
    id integer NOT NULL,
    patient_id integer,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplants_recipient_workups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transplants_recipient_workups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplants_recipient_workups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transplants_recipient_workups_id_seq OWNED BY transplants_recipient_workups.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    approved boolean DEFAULT false,
    username character varying,
    first_name character varying,
    last_name character varying,
    last_activity_at timestamp without time zone,
    expired_at timestamp without time zone,
    professional_position character varying,
    signature character varying
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
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bag_types ALTER COLUMN id SET DEFAULT nextval('bag_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clinic_visits ALTER COLUMN id SET DEFAULT nextval('clinic_visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY doctors ALTER COLUMN id SET DEFAULT nextval('doctors_id_seq'::regclass);


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

ALTER TABLE ONLY edta_codes ALTER COLUMN id SET DEFAULT nextval('edta_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY episode_types ALTER COLUMN id SET DEFAULT nextval('episode_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY esrf ALTER COLUMN id SET DEFAULT nextval('esrf_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ethnicities ALTER COLUMN id SET DEFAULT nextval('ethnicities_id_seq'::regclass);


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

ALTER TABLE ONLY exit_site_infections ALTER COLUMN id SET DEFAULT nextval('exit_site_infections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fluid_descriptions ALTER COLUMN id SET DEFAULT nextval('fluid_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY infection_organisms ALTER COLUMN id SET DEFAULT nextval('infection_organisms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letter_descriptions ALTER COLUMN id SET DEFAULT nextval('letter_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letters ALTER COLUMN id SET DEFAULT nextval('letters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_routes ALTER COLUMN id SET DEFAULT nextval('medication_routes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medication_versions ALTER COLUMN id SET DEFAULT nextval('medication_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medications ALTER COLUMN id SET DEFAULT nextval('medications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY modalities ALTER COLUMN id SET DEFAULT nextval('modalities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_codes ALTER COLUMN id SET DEFAULT nextval('modality_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY modality_reasons ALTER COLUMN id SET DEFAULT nextval('modality_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organism_codes ALTER COLUMN id SET DEFAULT nextval('organism_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients ALTER COLUMN id SET DEFAULT nextval('patients_id_seq'::regclass);


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

ALTER TABLE ONLY peritonitis_episodes ALTER COLUMN id SET DEFAULT nextval('peritonitis_episodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY practices ALTER COLUMN id SET DEFAULT nextval('practices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prd_descriptions ALTER COLUMN id SET DEFAULT nextval('prd_descriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY problem_versions ALTER COLUMN id SET DEFAULT nextval('problem_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY problems ALTER COLUMN id SET DEFAULT nextval('problems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplants_donor_workup_versions ALTER COLUMN id SET DEFAULT nextval('transplants_donor_workup_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplants_donor_workups ALTER COLUMN id SET DEFAULT nextval('transplants_donor_workups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplants_recipient_workup_versions ALTER COLUMN id SET DEFAULT nextval('transplants_recipient_workup_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplants_recipient_workups ALTER COLUMN id SET DEFAULT nextval('transplants_recipient_workups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: bag_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bag_types
    ADD CONSTRAINT bag_types_pkey PRIMARY KEY (id);


--
-- Name: clinic_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clinic_visits
    ADD CONSTRAINT clinic_visits_pkey PRIMARY KEY (id);


--
-- Name: doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: drug_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drug_types
    ADD CONSTRAINT drug_types_pkey PRIMARY KEY (id);


--
-- Name: drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: edta_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY edta_codes
    ADD CONSTRAINT edta_codes_pkey PRIMARY KEY (id);


--
-- Name: episode_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY episode_types
    ADD CONSTRAINT episode_types_pkey PRIMARY KEY (id);


--
-- Name: esrf_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY esrf
    ADD CONSTRAINT esrf_pkey PRIMARY KEY (id);


--
-- Name: ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ethnicities
    ADD CONSTRAINT ethnicities_pkey PRIMARY KEY (id);


--
-- Name: event_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT event_types_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: exit_site_infections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY exit_site_infections
    ADD CONSTRAINT exit_site_infections_pkey PRIMARY KEY (id);


--
-- Name: fluid_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fluid_descriptions
    ADD CONSTRAINT fluid_descriptions_pkey PRIMARY KEY (id);


--
-- Name: infection_organisms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY infection_organisms
    ADD CONSTRAINT infection_organisms_pkey PRIMARY KEY (id);


--
-- Name: letter_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY letter_descriptions
    ADD CONSTRAINT letter_descriptions_pkey PRIMARY KEY (id);


--
-- Name: letters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY letters
    ADD CONSTRAINT letters_pkey PRIMARY KEY (id);


--
-- Name: medication_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medication_routes
    ADD CONSTRAINT medication_routes_pkey PRIMARY KEY (id);


--
-- Name: medication_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medication_versions
    ADD CONSTRAINT medication_versions_pkey PRIMARY KEY (id);


--
-- Name: medications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medications
    ADD CONSTRAINT medications_pkey PRIMARY KEY (id);


--
-- Name: modalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY modalities
    ADD CONSTRAINT modalities_pkey PRIMARY KEY (id);


--
-- Name: modality_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY modality_codes
    ADD CONSTRAINT modality_codes_pkey PRIMARY KEY (id);


--
-- Name: modality_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY modality_reasons
    ADD CONSTRAINT modality_reasons_pkey PRIMARY KEY (id);


--
-- Name: organism_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organism_codes
    ADD CONSTRAINT organism_codes_pkey PRIMARY KEY (id);


--
-- Name: patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: pd_regime_bags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pd_regime_bags
    ADD CONSTRAINT pd_regime_bags_pkey PRIMARY KEY (id);


--
-- Name: pd_regimes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pd_regimes
    ADD CONSTRAINT pd_regimes_pkey PRIMARY KEY (id);


--
-- Name: peritonitis_episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peritonitis_episodes
    ADD CONSTRAINT peritonitis_episodes_pkey PRIMARY KEY (id);


--
-- Name: practices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY practices
    ADD CONSTRAINT practices_pkey PRIMARY KEY (id);


--
-- Name: prd_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prd_descriptions
    ADD CONSTRAINT prd_descriptions_pkey PRIMARY KEY (id);


--
-- Name: problem_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY problem_versions
    ADD CONSTRAINT problem_versions_pkey PRIMARY KEY (id);


--
-- Name: problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: transplants_donor_workup_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transplants_donor_workup_versions
    ADD CONSTRAINT transplants_donor_workup_versions_pkey PRIMARY KEY (id);


--
-- Name: transplants_donor_workups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transplants_donor_workups
    ADD CONSTRAINT transplants_donor_workups_pkey PRIMARY KEY (id);


--
-- Name: transplants_recipient_workup_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transplants_recipient_workup_versions
    ADD CONSTRAINT transplants_recipient_workup_versions_pkey PRIMARY KEY (id);


--
-- Name: transplants_recipient_workups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transplants_recipient_workups
    ADD CONSTRAINT transplants_recipient_workups_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: donor_workup_versions_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX donor_workup_versions_type_id ON transplants_donor_workup_versions USING btree (item_type, item_id);


--
-- Name: index_bag_types_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bag_types_on_deleted_at ON bag_types USING btree (deleted_at);


--
-- Name: index_clinic_visits_on_patient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clinic_visits_on_patient_id ON clinic_visits USING btree (patient_id);


--
-- Name: index_doctors_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_doctors_on_code ON doctors USING btree (code);


--
-- Name: index_doctors_practices; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_doctors_practices ON doctors_practices USING btree (doctor_id, practice_id);


--
-- Name: index_drug_types_drugs_on_drug_id_and_drug_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_drug_types_drugs_on_drug_id_and_drug_type_id ON drug_types_drugs USING btree (drug_id, drug_type_id);


--
-- Name: index_infection_organisms; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_infection_organisms ON infection_organisms USING btree (organism_code_id, infectable_id, infectable_type);


--
-- Name: index_infection_organisms_on_infectable_type_and_infectable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_infection_organisms_on_infectable_type_and_infectable_id ON infection_organisms USING btree (infectable_type, infectable_id);


--
-- Name: index_letters_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_letters_on_author_id ON letters USING btree (author_id);


--
-- Name: index_letters_on_clinic_visit_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_letters_on_clinic_visit_id ON letters USING btree (clinic_visit_id);


--
-- Name: index_letters_on_doctor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_letters_on_doctor_id ON letters USING btree (doctor_id);


--
-- Name: index_letters_on_letter_description_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_letters_on_letter_description_id ON letters USING btree (letter_description_id);


--
-- Name: index_letters_on_patient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_letters_on_patient_id ON letters USING btree (patient_id);


--
-- Name: index_letters_on_recipient_address_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_letters_on_recipient_address_id ON letters USING btree (recipient_address_id);


--
-- Name: index_letters_on_reviewer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_letters_on_reviewer_id ON letters USING btree (reviewer_id);


--
-- Name: index_letters_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_letters_on_type ON letters USING btree (type);


--
-- Name: index_medication_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_medication_versions_on_item_type_and_item_id ON medication_versions USING btree (item_type, item_id);


--
-- Name: index_medications_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_medications_on_deleted_at ON medications USING btree (deleted_at);


--
-- Name: index_medications_on_medicatable_type_and_medicatable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_medications_on_medicatable_type_and_medicatable_id ON medications USING btree (medicatable_type, medicatable_id);


--
-- Name: index_medications_on_treatable_type_and_treatable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_medications_on_treatable_type_and_treatable_id ON medications USING btree (treatable_type, treatable_id);


--
-- Name: index_patients_on_doctor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_patients_on_doctor_id ON patients USING btree (doctor_id);


--
-- Name: index_problem_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_problem_versions_on_item_type_and_item_id ON problem_versions USING btree (item_type, item_id);


--
-- Name: index_problems_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_problems_on_deleted_at ON problems USING btree (deleted_at);


--
-- Name: index_transplants_donor_workups_on_document; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transplants_donor_workups_on_document ON transplants_donor_workups USING gin (document);


--
-- Name: index_transplants_donor_workups_on_patient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transplants_donor_workups_on_patient_id ON transplants_donor_workups USING btree (patient_id);


--
-- Name: index_transplants_recipient_workups_on_document; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transplants_recipient_workups_on_document ON transplants_recipient_workups USING gin (document);


--
-- Name: index_transplants_recipient_workups_on_patient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transplants_recipient_workups_on_patient_id ON transplants_recipient_workups USING btree (patient_id);


--
-- Name: index_users_on_approved; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_approved ON users USING btree (approved);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_expired_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_expired_at ON users USING btree (expired_at);


--
-- Name: index_users_on_last_activity_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_last_activity_at ON users USING btree (last_activity_at);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: tx_workup_versions_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX tx_workup_versions_type_id ON transplants_recipient_workup_versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_15ecb734e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplants_donor_workups
    ADD CONSTRAINT fk_rails_15ecb734e1 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: fk_rails_7f025877c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letters
    ADD CONSTRAINT fk_rails_7f025877c9 FOREIGN KEY (reviewer_id) REFERENCES users(id);


--
-- Name: fk_rails_cc2440db33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letters
    ADD CONSTRAINT fk_rails_cc2440db33 FOREIGN KEY (author_id) REFERENCES users(id);


--
-- Name: fk_rails_e6d1b83a79; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letters
    ADD CONSTRAINT fk_rails_e6d1b83a79 FOREIGN KEY (recipient_address_id) REFERENCES addresses(id);


--
-- Name: fk_rails_f38bf6647a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transplants_recipient_workups
    ADD CONSTRAINT fk_rails_f38bf6647a FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141020170329');

INSERT INTO schema_migrations (version) VALUES ('20141023111038');

INSERT INTO schema_migrations (version) VALUES ('20141024111716');

INSERT INTO schema_migrations (version) VALUES ('20141030174624');

INSERT INTO schema_migrations (version) VALUES ('20141030180107');

INSERT INTO schema_migrations (version) VALUES ('20141030183859');

INSERT INTO schema_migrations (version) VALUES ('20141104150240');

INSERT INTO schema_migrations (version) VALUES ('20141105153315');

INSERT INTO schema_migrations (version) VALUES ('20141107145549');

INSERT INTO schema_migrations (version) VALUES ('20141107145615');

INSERT INTO schema_migrations (version) VALUES ('20141124152845');

INSERT INTO schema_migrations (version) VALUES ('20141208160813');

INSERT INTO schema_migrations (version) VALUES ('20141222110119');

INSERT INTO schema_migrations (version) VALUES ('20141223165855');

INSERT INTO schema_migrations (version) VALUES ('20141229135723');

INSERT INTO schema_migrations (version) VALUES ('20150102095659');

INSERT INTO schema_migrations (version) VALUES ('20150109152145');

INSERT INTO schema_migrations (version) VALUES ('20150112113417');

INSERT INTO schema_migrations (version) VALUES ('20150119160039');

INSERT INTO schema_migrations (version) VALUES ('20150120155952');

INSERT INTO schema_migrations (version) VALUES ('20150203161438');

INSERT INTO schema_migrations (version) VALUES ('20150206115827');

INSERT INTO schema_migrations (version) VALUES ('20150206174242');

INSERT INTO schema_migrations (version) VALUES ('20150213103857');

INSERT INTO schema_migrations (version) VALUES ('20150224140027');

INSERT INTO schema_migrations (version) VALUES ('20150302171638');

INSERT INTO schema_migrations (version) VALUES ('20150304173609');

INSERT INTO schema_migrations (version) VALUES ('20150312112909');

INSERT INTO schema_migrations (version) VALUES ('20150312113937');

INSERT INTO schema_migrations (version) VALUES ('20150313124325');

INSERT INTO schema_migrations (version) VALUES ('20150317095034');

INSERT INTO schema_migrations (version) VALUES ('20150317151009');

INSERT INTO schema_migrations (version) VALUES ('20150514113239');

INSERT INTO schema_migrations (version) VALUES ('20150514145145');

INSERT INTO schema_migrations (version) VALUES ('20150515154952');

INSERT INTO schema_migrations (version) VALUES ('20150515155052');

INSERT INTO schema_migrations (version) VALUES ('20150519150307');

INSERT INTO schema_migrations (version) VALUES ('20150520085606');

INSERT INTO schema_migrations (version) VALUES ('20150602151910');

INSERT INTO schema_migrations (version) VALUES ('20150603105219');

INSERT INTO schema_migrations (version) VALUES ('20150605095934');

INSERT INTO schema_migrations (version) VALUES ('20150605151945');

INSERT INTO schema_migrations (version) VALUES ('20150608093002');

INSERT INTO schema_migrations (version) VALUES ('20150619134623');

INSERT INTO schema_migrations (version) VALUES ('20150619150714');

INSERT INTO schema_migrations (version) VALUES ('20150623083220');

INSERT INTO schema_migrations (version) VALUES ('20150623105816');

INSERT INTO schema_migrations (version) VALUES ('20150701104744');

INSERT INTO schema_migrations (version) VALUES ('20150701144155');

INSERT INTO schema_migrations (version) VALUES ('20150702084036');

INSERT INTO schema_migrations (version) VALUES ('20150709152737');

INSERT INTO schema_migrations (version) VALUES ('20150717093153');

INSERT INTO schema_migrations (version) VALUES ('20150903143922');

INSERT INTO schema_migrations (version) VALUES ('20150923201215');

INSERT INTO schema_migrations (version) VALUES ('20150925133903');

INSERT INTO schema_migrations (version) VALUES ('20151014205537');

INSERT INTO schema_migrations (version) VALUES ('20151014210052');

