--
-- PostgreSQL database dump
--

\restrict fEz4fpQW6sJWjrUZphYz9oiMSivYm2KyAk7b9vrsvACEz8JEsdbBFvhUZLdesna

-- Dumped from database version 17.10 (Debian 17.10-1.pgdg13+1)
-- Dumped by pg_dump version 17.10 (Debian 17.10-1.pgdg13+1)

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO mlflow;

--
-- Name: datasets; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.datasets (
    dataset_uuid character varying(36) NOT NULL,
    experiment_id integer NOT NULL,
    name character varying(500) NOT NULL,
    digest character varying(36) NOT NULL,
    dataset_source_type character varying(36) NOT NULL,
    dataset_source text NOT NULL,
    dataset_schema text,
    dataset_profile text
);


ALTER TABLE public.datasets OWNER TO mlflow;

--
-- Name: experiment_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.experiment_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    experiment_id integer NOT NULL
);


ALTER TABLE public.experiment_tags OWNER TO mlflow;

--
-- Name: experiments; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.experiments (
    experiment_id integer NOT NULL,
    name character varying(256) NOT NULL,
    artifact_location character varying(256),
    lifecycle_stage character varying(32),
    creation_time bigint,
    last_update_time bigint,
    CONSTRAINT experiments_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY ((ARRAY['active'::character varying, 'deleted'::character varying])::text[])))
);


ALTER TABLE public.experiments OWNER TO mlflow;

--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE; Schema: public; Owner: mlflow
--

CREATE SEQUENCE public.experiments_experiment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.experiments_experiment_id_seq OWNER TO mlflow;

--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mlflow
--

ALTER SEQUENCE public.experiments_experiment_id_seq OWNED BY public.experiments.experiment_id;


--
-- Name: input_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.input_tags (
    input_uuid character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(500) NOT NULL
);


ALTER TABLE public.input_tags OWNER TO mlflow;

--
-- Name: inputs; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.inputs (
    input_uuid character varying(36) NOT NULL,
    source_type character varying(36) NOT NULL,
    source_id character varying(36) NOT NULL,
    destination_type character varying(36) NOT NULL,
    destination_id character varying(36) NOT NULL
);


ALTER TABLE public.inputs OWNER TO mlflow;

--
-- Name: latest_metrics; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.latest_metrics (
    key character varying(250) NOT NULL,
    value double precision NOT NULL,
    "timestamp" bigint,
    step bigint NOT NULL,
    is_nan boolean NOT NULL,
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.latest_metrics OWNER TO mlflow;

--
-- Name: metrics; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.metrics (
    key character varying(250) NOT NULL,
    value double precision NOT NULL,
    "timestamp" bigint NOT NULL,
    run_uuid character varying(32) NOT NULL,
    step bigint DEFAULT '0'::bigint NOT NULL,
    is_nan boolean DEFAULT false NOT NULL
);


ALTER TABLE public.metrics OWNER TO mlflow;

--
-- Name: model_version_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.model_version_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    name character varying(256) NOT NULL,
    version integer NOT NULL
);


ALTER TABLE public.model_version_tags OWNER TO mlflow;

--
-- Name: model_versions; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.model_versions (
    name character varying(256) NOT NULL,
    version integer NOT NULL,
    creation_time bigint,
    last_updated_time bigint,
    description character varying(5000),
    user_id character varying(256),
    current_stage character varying(20),
    source character varying(500),
    run_id character varying(32),
    status character varying(20),
    status_message character varying(500),
    run_link character varying(500),
    storage_location character varying(500)
);


ALTER TABLE public.model_versions OWNER TO mlflow;

--
-- Name: params; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.params (
    key character varying(250) NOT NULL,
    value character varying(8000) NOT NULL,
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.params OWNER TO mlflow;

--
-- Name: registered_model_aliases; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.registered_model_aliases (
    alias character varying(256) NOT NULL,
    version integer NOT NULL,
    name character varying(256) NOT NULL
);


ALTER TABLE public.registered_model_aliases OWNER TO mlflow;

--
-- Name: registered_model_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.registered_model_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    name character varying(256) NOT NULL
);


ALTER TABLE public.registered_model_tags OWNER TO mlflow;

--
-- Name: registered_models; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.registered_models (
    name character varying(256) NOT NULL,
    creation_time bigint,
    last_updated_time bigint,
    description character varying(5000)
);


ALTER TABLE public.registered_models OWNER TO mlflow;

--
-- Name: runs; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.runs (
    run_uuid character varying(32) NOT NULL,
    name character varying(250),
    source_type character varying(20),
    source_name character varying(500),
    entry_point_name character varying(50),
    user_id character varying(256),
    status character varying(9),
    start_time bigint,
    end_time bigint,
    source_version character varying(50),
    lifecycle_stage character varying(20),
    artifact_uri character varying(200),
    experiment_id integer,
    deleted_time bigint,
    CONSTRAINT runs_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY ((ARRAY['active'::character varying, 'deleted'::character varying])::text[]))),
    CONSTRAINT runs_status_check CHECK (((status)::text = ANY ((ARRAY['SCHEDULED'::character varying, 'FAILED'::character varying, 'FINISHED'::character varying, 'RUNNING'::character varying, 'KILLED'::character varying])::text[]))),
    CONSTRAINT source_type CHECK (((source_type)::text = ANY ((ARRAY['NOTEBOOK'::character varying, 'JOB'::character varying, 'LOCAL'::character varying, 'UNKNOWN'::character varying, 'PROJECT'::character varying])::text[])))
);


ALTER TABLE public.runs OWNER TO mlflow;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.tags (
    key character varying(250) NOT NULL,
    value character varying(8000),
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.tags OWNER TO mlflow;

--
-- Name: trace_info; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.trace_info (
    request_id character varying(50) NOT NULL,
    experiment_id integer NOT NULL,
    timestamp_ms bigint NOT NULL,
    execution_time_ms bigint,
    status character varying(50) NOT NULL
);


ALTER TABLE public.trace_info OWNER TO mlflow;

--
-- Name: trace_request_metadata; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.trace_request_metadata (
    key character varying(250) NOT NULL,
    value character varying(8000),
    request_id character varying(50) NOT NULL
);


ALTER TABLE public.trace_request_metadata OWNER TO mlflow;

--
-- Name: trace_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.trace_tags (
    key character varying(250) NOT NULL,
    value character varying(8000),
    request_id character varying(50) NOT NULL
);


ALTER TABLE public.trace_tags OWNER TO mlflow;

--
-- Name: experiments experiment_id; Type: DEFAULT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiments ALTER COLUMN experiment_id SET DEFAULT nextval('public.experiments_experiment_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.alembic_version (version_num) FROM stdin;
0584bdc529eb
\.


--
-- Data for Name: datasets; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.datasets (dataset_uuid, experiment_id, name, digest, dataset_source_type, dataset_source, dataset_schema, dataset_profile) FROM stdin;
b19b1bf554bf4fe78226dcb7e3fc66af	3	dataset	54b5669a	code	{"tags": {"mlflow.user": "eduar", "mlflow.source.name": "c:\\\\Users\\\\eduar\\\\anaconda3\\\\Lib\\\\site-packages\\\\ipykernel_launcher.py", "mlflow.source.type": "LOCAL", "mlflow.source.git.commit": "affc41fd242f49a992b2f2a32c0cd948ba63dfad"}}	{"mlflow_colspec": [{"type": "double", "name": "FLAG_DOCUMENT_7", "required": true}, {"type": "double", "name": "FLAG_DOCUMENT_15", "required": true}, {"type": "double", "name": "FLAG_CONT_MOBILE", "required": true}, {"type": "double", "name": "FLAG_DOCUMENT_11", "required": true}, {"type": "double", "name": "FLAG_DOCUMENT_14", "required": true}, {"type": "double", "name": "FLAG_DOCUMENT_13", "required": true}, {"type": "double", "name": "FLAG_EMP_PHONE", "required": true}, {"type": "double", "name": "REG_REGION_NOT_LIVE_REGION", "required": true}, {"type": "double", "name": "DEF_60_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "OBS_60_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "FLAG_DOCUMENT_18", "required": true}, {"type": "double", "name": "YEARS_BEGINEXPLUATATION_AVG", "required": false}, {"type": "double", "name": "FLAG_DOCUMENT_16", "required": true}, {"type": "double", "name": "LIVINGAPARTMENTS_AVG", "required": false}, {"type": "double", "name": "DEF_30_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_YEAR", "required": false}, {"type": "double", "name": "REGION_POPULATION_RELATIVE", "required": true}, {"type": "double", "name": "TOTALAREA_MODE", "required": false}, {"type": "double", "name": "BASEMENTAREA_AVG", "required": false}, {"type": "double", "name": "REG_CITY_NOT_LIVE_CITY", "required": true}, {"type": "double", "name": "CNT_FAM_MEMBERS", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_QRT", "required": false}, {"type": "double", "name": "FLAG_WORK_PHONE", "required": true}, {"type": "double", "name": "NAME_INCOME_TYPE", "required": true}, {"type": "double", "name": "ORGANIZATION_TYPE", "required": true}, {"type": "double", "name": "AMT_INCOME_TOTAL", "required": true}, {"type": "double", "name": "REGION_RATING_CLIENT_W_CITY", "required": true}, {"type": "double", "name": "NAME_FAMILY_STATUS", "required": true}, {"type": "double", "name": "DAYS_LAST_PHONE_CHANGE", "required": false}, {"type": "double", "name": "FLAG_DOCUMENT_3", "required": true}, {"type": "double", "name": "NAME_CONTRACT_TYPE", "required": true}, {"type": "double", "name": "DAYS_ID_PUBLISH", "required": true}, {"type": "double", "name": "DAYS_REGISTRATION", "required": true}, {"type": "double", "name": "OCCUPATION_TYPE", "required": true}, {"type": "double", "name": "OWN_CAR_AGE", "required": false}, {"type": "double", "name": "EXT_SOURCE_2", "required": false}, {"type": "double", "name": "NAME_EDUCATION_TYPE", "required": true}, {"type": "double", "name": "EXT_SOURCE_COMPLT_SUM", "required": true}, {"type": "double", "name": "EXT_SOURCE_1", "required": false}, {"type": "double", "name": "DAYS_EMPLOYED", "required": true}, {"type": "double", "name": "AMT_ANNUITY", "required": false}, {"type": "double", "name": "DAYS_BIRTH", "required": true}, {"type": "double", "name": "EXT_SOURCE_3", "required": false}, {"type": "double", "name": "AMT_CREDIT", "required": true}, {"type": "double", "name": "AMT_GOODS_PRICE", "required": false}, {"type": "double", "name": "EXT_SOURCE_COMPLT_MEAN", "required": false}]}	{"num_rows": 196806, "num_elements": 9053076}
bdfa84c2a0d54fc8b74f481d22f1ce21	4	dataset	514acde5	code	{"tags": {"mlflow.user": "eduar", "mlflow.source.name": "c:\\\\Users\\\\eduar\\\\anaconda3\\\\Lib\\\\site-packages\\\\ipykernel_launcher.py", "mlflow.source.type": "LOCAL", "mlflow.source.git.commit": "affc41fd242f49a992b2f2a32c0cd948ba63dfad"}}	{"mlflow_colspec": [{"type": "string", "name": "NAME_CONTRACT_TYPE", "required": true}, {"type": "string", "name": "FLAG_OWN_CAR", "required": true}, {"type": "string", "name": "FLAG_OWN_REALTY", "required": true}, {"type": "long", "name": "CNT_CHILDREN", "required": true}, {"type": "double", "name": "AMT_INCOME_TOTAL", "required": true}, {"type": "double", "name": "AMT_CREDIT", "required": true}, {"type": "double", "name": "AMT_ANNUITY", "required": false}, {"type": "double", "name": "AMT_GOODS_PRICE", "required": false}, {"type": "string", "name": "NAME_TYPE_SUITE", "required": false}, {"type": "string", "name": "NAME_INCOME_TYPE", "required": true}, {"type": "string", "name": "NAME_EDUCATION_TYPE", "required": true}, {"type": "string", "name": "NAME_FAMILY_STATUS", "required": true}, {"type": "string", "name": "NAME_HOUSING_TYPE", "required": true}, {"type": "double", "name": "REGION_POPULATION_RELATIVE", "required": true}, {"type": "long", "name": "DAYS_BIRTH", "required": true}, {"type": "long", "name": "DAYS_EMPLOYED", "required": true}, {"type": "double", "name": "DAYS_REGISTRATION", "required": true}, {"type": "long", "name": "DAYS_ID_PUBLISH", "required": true}, {"type": "double", "name": "OWN_CAR_AGE", "required": false}, {"type": "long", "name": "FLAG_EMP_PHONE", "required": true}, {"type": "long", "name": "FLAG_WORK_PHONE", "required": true}, {"type": "long", "name": "FLAG_CONT_MOBILE", "required": true}, {"type": "long", "name": "FLAG_PHONE", "required": true}, {"type": "long", "name": "FLAG_EMAIL", "required": true}, {"type": "string", "name": "OCCUPATION_TYPE", "required": false}, {"type": "double", "name": "CNT_FAM_MEMBERS", "required": false}, {"type": "long", "name": "REGION_RATING_CLIENT", "required": true}, {"type": "long", "name": "REGION_RATING_CLIENT_W_CITY", "required": true}, {"type": "string", "name": "WEEKDAY_APPR_PROCESS_START", "required": true}, {"type": "long", "name": "HOUR_APPR_PROCESS_START", "required": true}, {"type": "long", "name": "REG_REGION_NOT_LIVE_REGION", "required": true}, {"type": "long", "name": "REG_REGION_NOT_WORK_REGION", "required": true}, {"type": "long", "name": "LIVE_REGION_NOT_WORK_REGION", "required": true}, {"type": "long", "name": "REG_CITY_NOT_LIVE_CITY", "required": true}, {"type": "long", "name": "REG_CITY_NOT_WORK_CITY", "required": true}, {"type": "long", "name": "LIVE_CITY_NOT_WORK_CITY", "required": true}, {"type": "string", "name": "ORGANIZATION_TYPE", "required": true}, {"type": "double", "name": "EXT_SOURCE_1", "required": false}, {"type": "double", "name": "EXT_SOURCE_2", "required": false}, {"type": "double", "name": "EXT_SOURCE_3", "required": false}, {"type": "double", "name": "APARTMENTS_AVG", "required": false}, {"type": "double", "name": "BASEMENTAREA_AVG", "required": false}, {"type": "double", "name": "YEARS_BEGINEXPLUATATION_AVG", "required": false}, {"type": "double", "name": "COMMONAREA_AVG", "required": false}, {"type": "double", "name": "ELEVATORS_AVG", "required": false}, {"type": "double", "name": "ENTRANCES_AVG", "required": false}, {"type": "double", "name": "FLOORSMAX_AVG", "required": false}, {"type": "double", "name": "LIVINGAPARTMENTS_AVG", "required": false}, {"type": "double", "name": "LIVINGAREA_AVG", "required": false}, {"type": "double", "name": "NONLIVINGAPARTMENTS_AVG", "required": false}, {"type": "double", "name": "NONLIVINGAREA_AVG", "required": false}, {"type": "double", "name": "YEARS_BEGINEXPLUATATION_MODE", "required": false}, {"type": "double", "name": "YEARS_BUILD_MODE", "required": false}, {"type": "double", "name": "FLOORSMAX_MODE", "required": false}, {"type": "double", "name": "YEARS_BEGINEXPLUATATION_MEDI", "required": false}, {"type": "double", "name": "FLOORSMAX_MEDI", "required": false}, {"type": "double", "name": "FLOORSMIN_MEDI", "required": false}, {"type": "double", "name": "LANDAREA_MEDI", "required": false}, {"type": "string", "name": "FONDKAPREMONT_MODE", "required": false}, {"type": "string", "name": "HOUSETYPE_MODE", "required": false}, {"type": "double", "name": "TOTALAREA_MODE", "required": false}, {"type": "string", "name": "WALLSMATERIAL_MODE", "required": false}, {"type": "string", "name": "EMERGENCYSTATE_MODE", "required": false}, {"type": "double", "name": "OBS_30_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "DEF_30_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "OBS_60_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "DEF_60_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "DAYS_LAST_PHONE_CHANGE", "required": false}, {"type": "long", "name": "FLAG_DOCUMENT_3", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_5", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_6", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_7", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_8", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_9", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_11", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_13", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_14", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_15", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_16", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_17", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_18", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_19", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_20", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_21", "required": true}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_HOUR", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_DAY", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_WEEK", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_MON", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_QRT", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_YEAR", "required": false}, {"type": "integer", "name": "COMMONAREA_missing", "required": true}, {"type": "integer", "name": "NONLIVINGAPARTMENTS_missing", "required": true}, {"type": "integer", "name": "LIVINGAPARTMENTS_missing", "required": true}, {"type": "integer", "name": "FLOORSMIN_missing", "required": true}, {"type": "integer", "name": "YEARS_BUILD_missing", "required": true}, {"type": "integer", "name": "LANDAREA_missing", "required": true}, {"type": "integer", "name": "BASEMENTAREA_missing", "required": true}, {"type": "integer", "name": "NONLIVINGAREA_missing", "required": true}, {"type": "integer", "name": "ELEVATORS_missing", "required": true}, {"type": "integer", "name": "APARTMENTS_missing", "required": true}, {"type": "integer", "name": "ENTRANCES_missing", "required": true}, {"type": "integer", "name": "LIVINGAREA_missing", "required": true}, {"type": "double", "name": "EXT_SOURCE_COMPLT_MEAN", "required": false}, {"type": "double", "name": "EXT_SOURCE_COMPLT_SUM", "required": true}, {"type": "double", "name": "COMPROMETIMENTO_RENDA_PCT", "required": false}]}	{"num_rows": 196806, "num_elements": 20664630}
a9118643d62e49f7be17c6d19a368c6b	4	dataset	299a68f8	code	{"tags": {"mlflow.user": "eduar", "mlflow.source.name": "c:\\\\Users\\\\eduar\\\\anaconda3\\\\Lib\\\\site-packages\\\\ipykernel_launcher.py", "mlflow.source.type": "LOCAL", "mlflow.source.git.commit": "affc41fd242f49a992b2f2a32c0cd948ba63dfad"}}	{"mlflow_colspec": [{"type": "string", "name": "NAME_CONTRACT_TYPE", "required": true}, {"type": "string", "name": "FLAG_OWN_CAR", "required": true}, {"type": "string", "name": "FLAG_OWN_REALTY", "required": true}, {"type": "long", "name": "CNT_CHILDREN", "required": true}, {"type": "double", "name": "AMT_INCOME_TOTAL", "required": true}, {"type": "double", "name": "AMT_CREDIT", "required": true}, {"type": "double", "name": "AMT_ANNUITY", "required": false}, {"type": "double", "name": "AMT_GOODS_PRICE", "required": false}, {"type": "string", "name": "NAME_TYPE_SUITE", "required": false}, {"type": "string", "name": "NAME_INCOME_TYPE", "required": true}, {"type": "string", "name": "NAME_EDUCATION_TYPE", "required": true}, {"type": "string", "name": "NAME_FAMILY_STATUS", "required": true}, {"type": "string", "name": "NAME_HOUSING_TYPE", "required": true}, {"type": "double", "name": "REGION_POPULATION_RELATIVE", "required": true}, {"type": "long", "name": "DAYS_BIRTH", "required": true}, {"type": "long", "name": "DAYS_EMPLOYED", "required": true}, {"type": "double", "name": "DAYS_REGISTRATION", "required": true}, {"type": "long", "name": "DAYS_ID_PUBLISH", "required": true}, {"type": "double", "name": "OWN_CAR_AGE", "required": false}, {"type": "long", "name": "FLAG_EMP_PHONE", "required": true}, {"type": "long", "name": "FLAG_WORK_PHONE", "required": true}, {"type": "long", "name": "FLAG_CONT_MOBILE", "required": true}, {"type": "long", "name": "FLAG_PHONE", "required": true}, {"type": "long", "name": "FLAG_EMAIL", "required": true}, {"type": "string", "name": "OCCUPATION_TYPE", "required": false}, {"type": "double", "name": "CNT_FAM_MEMBERS", "required": true}, {"type": "long", "name": "REGION_RATING_CLIENT", "required": true}, {"type": "long", "name": "REGION_RATING_CLIENT_W_CITY", "required": true}, {"type": "string", "name": "WEEKDAY_APPR_PROCESS_START", "required": true}, {"type": "long", "name": "HOUR_APPR_PROCESS_START", "required": true}, {"type": "long", "name": "REG_REGION_NOT_LIVE_REGION", "required": true}, {"type": "long", "name": "REG_REGION_NOT_WORK_REGION", "required": true}, {"type": "long", "name": "LIVE_REGION_NOT_WORK_REGION", "required": true}, {"type": "long", "name": "REG_CITY_NOT_LIVE_CITY", "required": true}, {"type": "long", "name": "REG_CITY_NOT_WORK_CITY", "required": true}, {"type": "long", "name": "LIVE_CITY_NOT_WORK_CITY", "required": true}, {"type": "string", "name": "ORGANIZATION_TYPE", "required": true}, {"type": "double", "name": "EXT_SOURCE_1", "required": false}, {"type": "double", "name": "EXT_SOURCE_2", "required": false}, {"type": "double", "name": "EXT_SOURCE_3", "required": false}, {"type": "double", "name": "APARTMENTS_AVG", "required": false}, {"type": "double", "name": "BASEMENTAREA_AVG", "required": false}, {"type": "double", "name": "YEARS_BEGINEXPLUATATION_AVG", "required": false}, {"type": "double", "name": "COMMONAREA_AVG", "required": false}, {"type": "double", "name": "ELEVATORS_AVG", "required": false}, {"type": "double", "name": "ENTRANCES_AVG", "required": false}, {"type": "double", "name": "FLOORSMAX_AVG", "required": false}, {"type": "double", "name": "LIVINGAPARTMENTS_AVG", "required": false}, {"type": "double", "name": "LIVINGAREA_AVG", "required": false}, {"type": "double", "name": "NONLIVINGAPARTMENTS_AVG", "required": false}, {"type": "double", "name": "NONLIVINGAREA_AVG", "required": false}, {"type": "double", "name": "YEARS_BEGINEXPLUATATION_MODE", "required": false}, {"type": "double", "name": "YEARS_BUILD_MODE", "required": false}, {"type": "double", "name": "FLOORSMAX_MODE", "required": false}, {"type": "double", "name": "YEARS_BEGINEXPLUATATION_MEDI", "required": false}, {"type": "double", "name": "FLOORSMAX_MEDI", "required": false}, {"type": "double", "name": "FLOORSMIN_MEDI", "required": false}, {"type": "double", "name": "LANDAREA_MEDI", "required": false}, {"type": "string", "name": "FONDKAPREMONT_MODE", "required": false}, {"type": "string", "name": "HOUSETYPE_MODE", "required": false}, {"type": "double", "name": "TOTALAREA_MODE", "required": false}, {"type": "string", "name": "WALLSMATERIAL_MODE", "required": false}, {"type": "string", "name": "EMERGENCYSTATE_MODE", "required": false}, {"type": "double", "name": "OBS_30_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "DEF_30_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "OBS_60_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "DEF_60_CNT_SOCIAL_CIRCLE", "required": false}, {"type": "double", "name": "DAYS_LAST_PHONE_CHANGE", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_3", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_5", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_6", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_7", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_8", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_9", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_11", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_13", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_14", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_15", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_16", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_17", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_18", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_19", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_20", "required": true}, {"type": "long", "name": "FLAG_DOCUMENT_21", "required": true}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_HOUR", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_DAY", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_WEEK", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_MON", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_QRT", "required": false}, {"type": "double", "name": "AMT_REQ_CREDIT_BUREAU_YEAR", "required": false}, {"type": "integer", "name": "COMMONAREA_missing", "required": true}, {"type": "integer", "name": "NONLIVINGAPARTMENTS_missing", "required": true}, {"type": "integer", "name": "LIVINGAPARTMENTS_missing", "required": true}, {"type": "integer", "name": "FLOORSMIN_missing", "required": true}, {"type": "integer", "name": "YEARS_BUILD_missing", "required": true}, {"type": "integer", "name": "LANDAREA_missing", "required": true}, {"type": "integer", "name": "BASEMENTAREA_missing", "required": true}, {"type": "integer", "name": "NONLIVINGAREA_missing", "required": true}, {"type": "integer", "name": "ELEVATORS_missing", "required": true}, {"type": "integer", "name": "APARTMENTS_missing", "required": true}, {"type": "integer", "name": "ENTRANCES_missing", "required": true}, {"type": "integer", "name": "LIVINGAREA_missing", "required": true}, {"type": "double", "name": "EXT_SOURCE_COMPLT_MEAN", "required": false}, {"type": "double", "name": "EXT_SOURCE_COMPLT_SUM", "required": true}, {"type": "double", "name": "COMPROMETIMENTO_RENDA_PCT", "required": false}]}	{"num_rows": 61503, "num_elements": 6457815}
\.


--
-- Data for Name: experiment_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.experiment_tags (key, value, experiment_id) FROM stdin;
\.


--
-- Data for Name: experiments; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.experiments (experiment_id, name, artifact_location, lifecycle_stage, creation_time, last_update_time) FROM stdin;
0	Default	/mlflow/artifacts/0	active	1784572367885	1784572367885
1	models-cross-val	/mlflow/artifacts/1	active	1784572417268	1784572417268
2	selection-model-win	/mlflow/artifacts/2	active	1784639655590	1784639655590
3	optimization-model-win	/mlflow/artifacts/3	active	1784641455506	1784641455506
4	final-model	/mlflow/artifacts/4	active	1784652629517	1784652629517
\.


--
-- Data for Name: input_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.input_tags (input_uuid, name, value) FROM stdin;
95d57bdc767743918933973482d37aa7	mlflow.data.context	train
171c57c935b44612af25b8b07e5d5f56	mlflow.data.context	train
b29b7bfecec14b26a8cd03668fecc4b8	mlflow.data.context	train
1bc21b9625ed4e389e1f862d17fb915f	mlflow.data.context	train
215d02e1fc5046cbb6ac7f0a077fd323	mlflow.data.context	train
900fbc0a80fc449cb8cf2d2339289448	mlflow.data.context	train
08b301d7bee44336a81cdefffdf6fd16	mlflow.data.context	train
2a4bcea08f464e18b1d37d2efea62d47	mlflow.data.context	train
97a958a92dcf463eb00ee4956d60f6b4	mlflow.data.context	train
da996d45c74b4c5a8c315d48445d5537	mlflow.data.context	train
c3eba166758948298fb1e1805ccd7558	mlflow.data.context	train
d574937230fb4c40a478611b00b4d016	mlflow.data.context	train
88c6988a4b9640b09e21768f603b7ae3	mlflow.data.context	train
f9f7bc96d80d4f53a74f4304a7155788	mlflow.data.context	train
cfd8c01e416947759db02dc56036d58f	mlflow.data.context	train
165dbaba652c4c038e3a2224f41a516f	mlflow.data.context	train
b909a8c7a1fc4ac5a7f58d585eac010b	mlflow.data.context	train
f9d5bfb1c9e94230b2275aa13349f9f8	mlflow.data.context	train
f4861bd4395c44eaa4d8e369c7a93088	mlflow.data.context	train
6d03ced2459a4fb38df6e109fa8f4c28	mlflow.data.context	train
1ea4cbe8a44a4b9d9a842244a98b63a1	mlflow.data.context	train
080b7bea336942d28e62f153472502fc	mlflow.data.context	train
ba05fbed0be4440996297062a9655158	mlflow.data.context	train
7addd0537a6946ee9d2c0009158e9f8a	mlflow.data.context	train
3182d6a4f74b4dafb47db9dab88fbb2d	mlflow.data.context	train
54a25514ae114c42b4c02942989fa9bb	mlflow.data.context	train
4289ec2cb6364b7098ae942cf3f813ae	mlflow.data.context	train
4c2f768b0cf84b1a825543f164469fc7	mlflow.data.context	train
c7dc116603b5452f908fe919c9ec4dde	mlflow.data.context	train
7b709c5f648042caa0b9117e7250fce0	mlflow.data.context	train
b2e23214dff44c50b78b2dc68bcd3b00	mlflow.data.context	train
9fb9dc59a2174286b1fdda0c782016ef	mlflow.data.context	train
522881fad93940d4bd77d6e188ff5d6e	mlflow.data.context	train
53ef7fa4fe2741b3a3468f14dd4339d2	mlflow.data.context	train
4f45eac0c3744304807eb3153bf89723	mlflow.data.context	train
f9c007a1f1704594b2ca5d9ba582db0f	mlflow.data.context	train
cfe269688a114bb58f201049f52af9da	mlflow.data.context	train
27589a9a40d3429183b9540fee8f8d2c	mlflow.data.context	train
42967c34dbc244afb479c3be1ca0a6b0	mlflow.data.context	train
2fc4b69764124914889c53136bbc40ff	mlflow.data.context	train
b9ec9df23000417890e11d407be6d993	mlflow.data.context	train
558f2d759f5f49f5856540e210b6bf59	mlflow.data.context	train
96f4fd3324084454a56e7de2cdb996de	mlflow.data.context	train
58a6ce1982e5447995ee22facedb6630	mlflow.data.context	train
8dab90c79eb64de4a22195b6bbcdaf27	mlflow.data.context	train
5c41d6196a614acbaefcc55acf241f30	mlflow.data.context	train
a0dc3a27d79b4917b5d3ce6265072bc1	mlflow.data.context	train
a14fb5ed611144278e9801942659a0c7	mlflow.data.context	train
9a1970c00b204152bc536374b65fc553	mlflow.data.context	train
ac7cb07e1167404b95fbae08d318cca3	mlflow.data.context	train
782326778dc94b6c9ff804346f4c0f41	mlflow.data.context	train
0ae2406c91fe440bbbe37ed9a644c2c5	mlflow.data.context	train
7c66f1bef745424b970f36849db0b67d	mlflow.data.context	train
613245d7d2f94dbbb574ad49a6854b21	mlflow.data.context	train
b95245a24d01448c93da5b1115f2caac	mlflow.data.context	train
f835778454ab4bad89a7b1c6201b0dcb	mlflow.data.context	train
a38cae2e03cb4060896b6c3fd26de73b	mlflow.data.context	train
852876bce7714beea3b2e99efdc8bfc3	mlflow.data.context	train
1feac921f7f3498bb75c0f708dea6673	mlflow.data.context	train
e634bb26c67c47979377f6d39801596c	mlflow.data.context	train
5bd8da6be07e41969d67c4945d331837	mlflow.data.context	train
ec96240aae6842adb836d488b69bb794	mlflow.data.context	train
f3586bcc6943420fbe97870dfa4a2740	mlflow.data.context	train
f10d28e1fefc4b499720fdc2d037d714	mlflow.data.context	train
2876ece0bebb44ceb96f726a1bfc8404	mlflow.data.context	train
1d4aa5085b0f48cdb4b47dfb66c2b0a3	mlflow.data.context	train
2043b3f3bd4342d0a073638936930da2	mlflow.data.context	train
291260d182144323a3046604d0ba1f17	mlflow.data.context	train
8d2b623534cc431e98fb97e5cfa8bdb7	mlflow.data.context	train
3b914a813c21401494c482b7cc21a588	mlflow.data.context	train
cbb5fecbdbee4e72b232ab522824ab60	mlflow.data.context	train
18a0e068f4144af59af7db8f1539b14a	mlflow.data.context	train
4ee0d4dbeafc4839a2f52e5d867adda3	mlflow.data.context	train
d8ede011e327477aa66d38258d82bce9	mlflow.data.context	train
5ddb60575712489ab8bff1a67a0fb1ef	mlflow.data.context	train
a303d569848145aeb91dc51b19f89a48	mlflow.data.context	train
d6dee4d195ce410e8ceed284d9af134d	mlflow.data.context	train
5e421b700ddf4ca0a002f543ad32e356	mlflow.data.context	train
a2ea0be6fc1641c590dc60e8f1a2dd51	mlflow.data.context	train
ea82ed7119854b3a9852be495b41a47a	mlflow.data.context	train
07eabfae348e4151bb5abddd71a326a4	mlflow.data.context	train
cc0ea6e17f52427f89fcf22191818c16	mlflow.data.context	train
de7e3b3d4d40465cb4f1bb8e6a55b094	mlflow.data.context	train
fd1cf85a03dd4b7fbce78e8112748649	mlflow.data.context	train
06c85359c6d9481faad4bfa16328915e	mlflow.data.context	train
b666eee6a6cf43ad8d14c20025652127	mlflow.data.context	train
eb0dd79e91064612bd589c63b4d35857	mlflow.data.context	train
91b5907780834f019e24c775fe3e3cee	mlflow.data.context	train
2993dc288beb42c49253a6625b026f64	mlflow.data.context	train
bce778d0423a4efaa2376d4bde7ace9e	mlflow.data.context	train
7e295b1d73e64b9baf0d78fd13edf5ac	mlflow.data.context	train
c1da0d15980d4a5c95ba6cd36e3bcc63	mlflow.data.context	train
9c45bab111774fff9e6dc298ad9a4757	mlflow.data.context	train
6b34f19040d447a9a45c25ac49eb88bc	mlflow.data.context	train
728571f9e2034a6ea2867d1de234b418	mlflow.data.context	train
ff407a54fcd84fb7a55cdee6b711c310	mlflow.data.context	train
47456ba58bda426c857c982df46f8000	mlflow.data.context	train
9dc85489530c441188c477e4540b3c17	mlflow.data.context	train
d287220a7f044bcf868e3b311fcf215e	mlflow.data.context	train
35bf27584e8e491bbc29699d7e529f17	mlflow.data.context	train
e33259400283483dadd872ced9c46d56	mlflow.data.context	train
334c1fcb6d3f4868bb9bc47752b716ce	mlflow.data.context	train
94a6f3dfe536489d97f52238a896a4f1	mlflow.data.context	train
c5bb0dc8cade464681cf9ad4158bdd29	mlflow.data.context	train
7fa0aa6dd69e472093421d7745c289ac	mlflow.data.context	train
d07e1e820f7d464594ac83b2ef701dbf	mlflow.data.context	train
2fa228a4b7254eb9b37c8078d556f61f	mlflow.data.context	train
32217cb4ca6645a486e6d918dc0b791a	mlflow.data.context	train
bdfb38b742414e9793fa098bb46106b8	mlflow.data.context	train
d097a1df90c54d3faa80b8d6e7988ecf	mlflow.data.context	train
f2e61d71316b4facb10bc0a815e9500e	mlflow.data.context	train
6711096a25274abfa068eadd54b0d2f6	mlflow.data.context	train
cfbcf769a926445ea3e088e9ee7cdcc9	mlflow.data.context	train
92ea5248e973475285a386fa8d5c40b2	mlflow.data.context	train
7da25628e8c54839a8196dfa6f0bb2fb	mlflow.data.context	train
9df77e59a9ae4968b3f717c10d5ca79d	mlflow.data.context	train
b6a1529d91d74a98b30beb64dd5c22f4	mlflow.data.context	train
227d6edefa974f22b5a3827d2735024c	mlflow.data.context	train
0d6c266c77714387b586748bf5cb8d2d	mlflow.data.context	train
e7409acf210a4c16a14177e378d493d9	mlflow.data.context	train
722ebb02799b4b859909e5631f0978a5	mlflow.data.context	train
41e583686e614da896f74562bd3b84bb	mlflow.data.context	train
51d854fdbf17465ca07fa3b8641ca4fd	mlflow.data.context	train
e18ba170c4a04b89b2213513dedb730c	mlflow.data.context	train
800829ca9c9a426da83e2547383284d8	mlflow.data.context	train
a4ca6887c4e8442d846599c31c5a8287	mlflow.data.context	train
e2b66c23fc1f4fa1aa83de95b266d157	mlflow.data.context	train
fcc1d91254714812849970f5e4514fb2	mlflow.data.context	train
3fae9094a6ac49b48ce2ccf36bd9cb7d	mlflow.data.context	train
5f44a79c13bd4e07b018de9d685857e3	mlflow.data.context	train
1b999699497049c2965e89a39d0a0b77	mlflow.data.context	train
6081d39ac8d84e2f9f1eb8951b4e9106	mlflow.data.context	train
c57a50d6615245bbad812404389eb665	mlflow.data.context	train
b211b20bc901470e991cdf5ec9a2dde3	mlflow.data.context	train
d93ba875a1ad4de8a755ad0db79339dc	mlflow.data.context	train
8e0fc0fc4aa943bc8ea15d14cc490c81	mlflow.data.context	train
3533ad2327834c348910a194a43c5f5c	mlflow.data.context	train
424e36f1d8e04e559bde6e65d4f2917a	mlflow.data.context	train
bad6d531e40a4f46969e902f3d02f787	mlflow.data.context	train
a63f683f5bb14629ae76aee65a2e6e3b	mlflow.data.context	train
6e743dbfb04742f4878d92030389c6ad	mlflow.data.context	train
0fdc5eed152d4c5bba699c1946834263	mlflow.data.context	train
c0e77607805241b8893d6709a4e96ace	mlflow.data.context	train
d6ca0bfe4bb14b03a8ec25819c165998	mlflow.data.context	train
e162c2a8156a4070b702d2717532e926	mlflow.data.context	train
e0c6266a4a3742e5b71e5714526c5cc5	mlflow.data.context	train
e7be533cbd0b40a0aa4248a1ad8b9c7c	mlflow.data.context	train
9c55b3aee8c444a69c1d4bfc8996e001	mlflow.data.context	train
f47a4f52d7394566b1a22130f37c19ab	mlflow.data.context	train
2ea6f06027f9497fb118a970ac9f50a6	mlflow.data.context	train
0a30aad499e040b7a8761eaa52c65883	mlflow.data.context	train
f4e81a1665d0476fac0d60d9006e2ac4	mlflow.data.context	train
d823db558cbf4c1895675b142565c49f	mlflow.data.context	train
a0ff0d5145544c8f9e58e429cf21bc6c	mlflow.data.context	train
585ec19c13bd4d13baea223287a4ee39	mlflow.data.context	train
67a224f91ee44b68a7893cc5c09e5eb3	mlflow.data.context	train
31182d7bda924e208456ede258f8d149	mlflow.data.context	train
7fa8a7616e1743fcba36acd0b1ef4881	mlflow.data.context	train
3f015966db2644b5995477b4faed4344	mlflow.data.context	train
b72f3314cbce4da494ff083f791d588e	mlflow.data.context	train
f2293aa90f3d429bb0defddb8442019a	mlflow.data.context	train
d9569383c66a47fb9d3b583cd7a79e74	mlflow.data.context	train
d51750747bf1476db87097c51a4363bc	mlflow.data.context	train
9c0d885ebe0743f68c771b590753b9c5	mlflow.data.context	train
7c8aedacecb7426d8a35c8a8b71846ff	mlflow.data.context	train
ad0dd5d0e4304fd7aa902730b40a84f7	mlflow.data.context	train
e76e931b417d4053b2a9887e53df726b	mlflow.data.context	train
862db006b02943c58a159701a57f3923	mlflow.data.context	train
b8134b08fb934cb78928be6d108c385b	mlflow.data.context	train
bd2dfc06daa3407eb2505847019a97ef	mlflow.data.context	train
9249e8aadd4b46658949623471ca9a7c	mlflow.data.context	train
1c9016c0a79b42009cb81f6da1696bcd	mlflow.data.context	train
398f4d8f2bec4297a2f76d2258ad440c	mlflow.data.context	train
8e6cfb09de0045b7973081ed7362fcb9	mlflow.data.context	train
35cdb3848b3d4101b4f416decbc76278	mlflow.data.context	train
a94a303c85b9420e92bbcc41741dc5c9	mlflow.data.context	train
ac4481e95a83491e96f5db9286c18b20	mlflow.data.context	train
f88ddd57a7e34363a9c1cf18ea798596	mlflow.data.context	train
fb9f8507b0ef417b95bdadc70f8f8960	mlflow.data.context	train
b66c45a02f134c2a852d6c850c6b2c2b	mlflow.data.context	train
039a8b4ad7764ef2acf37e684e90c2c0	mlflow.data.context	train
3d1ed19e418b425fb1277ab95484dfe5	mlflow.data.context	train
7538ce241a884d8aa249c3c917c41587	mlflow.data.context	train
b00659f6e81c408082cb2eeb4728fcb2	mlflow.data.context	train
ba761baa663949a68d6d4bf91b1f8faa	mlflow.data.context	train
3c8f3e23dbb94c54918522907915b85e	mlflow.data.context	train
e8ffb0a32bdb4553bf55e54524ca47bb	mlflow.data.context	train
04090cbfe19046e2a190074b608956ca	mlflow.data.context	train
56902dee4b384f7796dd58c6657b741e	mlflow.data.context	train
78a688c8bda445eeb10923517d52c01d	mlflow.data.context	train
8f8920cab82847e1a9bd1d7a13f3150f	mlflow.data.context	train
b0dd9cb4541141f89381ba37bb4cc8f8	mlflow.data.context	train
e68942776c0c47e5a4714951f2e6bd06	mlflow.data.context	train
b464d71c8d144044b8c43490c16283eb	mlflow.data.context	train
49603d30067f4f96abab6a1a16e2b8e1	mlflow.data.context	train
cc1989f7670340389ace949d4b5ca7c2	mlflow.data.context	train
497bd1255b92496db258b31009aa5330	mlflow.data.context	train
a2273c054dbf4251a95f43d986f1428e	mlflow.data.context	train
069c11120ebe46328fd643d7a689c8fb	mlflow.data.context	train
5cecdf1965974d3a97f5baa707e0353a	mlflow.data.context	train
ac17866ab036402ab7abc7499cd9a8d6	mlflow.data.context	train
fe8f790f46c0400b935937b02f4ab556	mlflow.data.context	train
f0cdc76fbcac4880816da7b43c48e697	mlflow.data.context	train
d7d47c8162b24a5eba07cc48e25cadc0	mlflow.data.context	train
2c6d3d1be78149df9a0e65c7681ff86e	mlflow.data.context	train
1948d398dc2346b08dc8eaedbcaf0855	mlflow.data.context	train
ac8a0803268c482eb64b5ad8c168eaa9	mlflow.data.context	train
3cbe26e799374147b59a68925412f263	mlflow.data.context	train
e5a971a88c9149f2a3eb779418bc9df9	mlflow.data.context	train
e6080cf5000c47c09826098db3f33cc8	mlflow.data.context	train
e032e0a9797e4bc29d48fbfae24de14a	mlflow.data.context	train
1517378abae64b4aa33af29a7d3d2673	mlflow.data.context	train
4aba2f39ca0449af9b03de3758777b07	mlflow.data.context	train
fa976bcbba64429d9883ec89f25f24f4	mlflow.data.context	train
4c648f7ce7ad43f0a1d66431bcb3a99c	mlflow.data.context	train
fb08aaf2ee4a42eb9c43fe635d12b62e	mlflow.data.context	train
f37796355190402dad85770509c60b64	mlflow.data.context	train
40f13e891bd2415896382cbb6dfe8582	mlflow.data.context	train
7644f82a561a4dd7b701033f5c877279	mlflow.data.context	train
6a34ae3c1aa042a7bd1ecf06727af198	mlflow.data.context	train
7b4c1f4fa67341c9b8aa226d5b4c1634	mlflow.data.context	train
19fb87837d1d4a2b8a4e509aed9eab87	mlflow.data.context	train
4300ade655294a8fa284dcf360bffae4	mlflow.data.context	train
b86712daee194260b04efaf96aa3240f	mlflow.data.context	train
bad27db2eec74b8c909c5d47bb572bdf	mlflow.data.context	train
7c03d42dd64944649b6dc69097d17aa3	mlflow.data.context	train
6b15654c3f8c429ea2e0ef1395303343	mlflow.data.context	train
4ead1ad386844260924b9772cab79078	mlflow.data.context	train
b4262e4faf88449aac7a1ae92ffc5128	mlflow.data.context	train
0416114f16ff4362ada8fd76d6d424ca	mlflow.data.context	train
2fb461dbe2df470291ed23451efaf88e	mlflow.data.context	train
c4253af28404412ab6ca59ff63cc2fe9	mlflow.data.context	train
eda4b163bc2642f7b0c70226c7dc20c4	mlflow.data.context	train
e4acb16c87764ffa94f99f08e01bffc5	mlflow.data.context	train
199ccfe31f6b468c903d1e55202989c9	mlflow.data.context	train
4a77f1f299494b258078bb5e8ea0b904	mlflow.data.context	train
f2e9c986aece48eaa2b1d99d7f1e9774	mlflow.data.context	train
e67bd77af16644aeae4bb5994a915ee0	mlflow.data.context	train
d64e79dfcc654488ac2e081c36f6cfe0	mlflow.data.context	train
e1bdb0017e664cf393c73f62d1fecd2d	mlflow.data.context	train
319a25f66e2c49d9812341a79109276f	mlflow.data.context	train
d1fb189769244fd9b5d664ea7e63b82f	mlflow.data.context	train
58fd71129e344694836c4b4e57ae2d5c	mlflow.data.context	train
199c9e30c1304843908e5b900f242513	mlflow.data.context	train
a8cba5e8fbd04cfa86c77b3dcadc33d2	mlflow.data.context	train
680052940448475e9819cea8cccbabde	mlflow.data.context	train
94bb8b8b35e54c14900dc7eb96201c74	mlflow.data.context	train
9fa95fb2eb3b4a43aab868a0739f6529	mlflow.data.context	train
499cf862ed7e47bdab22d923c31f3e50	mlflow.data.context	train
3ce5f8046a494635943bd95179972413	mlflow.data.context	train
bb55b9e3240c4ed7a640bea72da0851f	mlflow.data.context	train
064f21359ad047988d694227a266bd21	mlflow.data.context	train
a1515e9a6de5489782376cfb530f55d9	mlflow.data.context	train
caed02b439374195a39a9b18da3b3770	mlflow.data.context	train
84b0b3b796c34bf8b12ed8bcc11c7dc1	mlflow.data.context	train
16384e1d527c4e948739eee9b5b311f9	mlflow.data.context	train
1c66739f269346bc8975b87c7186bf9b	mlflow.data.context	train
dd6887f2c19342fda7ae264510e37d03	mlflow.data.context	train
56b60adcbd7e4113a59eba96438c7560	mlflow.data.context	train
b4e347ab081d409e8833b70225aa3329	mlflow.data.context	train
327c301dbf394d8da5e245865bebeeff	mlflow.data.context	train
05e15445280b4352a9af07820b560935	mlflow.data.context	train
426b37e362374218a34f46865f18007f	mlflow.data.context	train
ae9313607a134a8aa0fe6802225977ba	mlflow.data.context	train
b2d1e43bd7344ab4ae41ebffaeec2ac1	mlflow.data.context	train
2b98e9b3d29445c1971149d4eaa4775d	mlflow.data.context	train
aefd82a9580c432789d28beeee2f4133	mlflow.data.context	train
0be25efe47204de495cfac82ff8719a2	mlflow.data.context	train
a9695a86c5d047d7ab86945c115949b0	mlflow.data.context	train
608896461fd54149bdc15b6b5d7a3421	mlflow.data.context	train
13ca8de39fbb4147bf119956854d1fbf	mlflow.data.context	train
9174b416bb9845f3aaae86825fb12c71	mlflow.data.context	train
1ca93d52fd87415488ae26842539aa89	mlflow.data.context	train
b424d2adb5f444048ccf18a13819ddb6	mlflow.data.context	train
37b461d0212a45b8b4f34a4fb7732bbb	mlflow.data.context	train
2a4a5242f1f14385b4e6911a0fdf0e62	mlflow.data.context	train
eb35cadbbc674e03be8b8fad29de041c	mlflow.data.context	train
fc2c49799e914302baa62dbf300b87ab	mlflow.data.context	train
3632e072a99344dd830a28eecca1e3b5	mlflow.data.context	train
4b3989bf714340bc85fa5d9023a22038	mlflow.data.context	train
d515721eed8e4feaad831e82113a29aa	mlflow.data.context	train
21d563665dc54349b6536de568a27573	mlflow.data.context	train
228663ab2a384431b2dd5bf88d331a82	mlflow.data.context	train
a4cdcea502b64522bb0e5dc6d63eaf28	mlflow.data.context	train
ccf3dfed465345b1a72383f0f60f3303	mlflow.data.context	train
b4fb94fb347846e79cbb2d298c189f6a	mlflow.data.context	train
27b84c9f3f1d488eb9a75c464e71bf60	mlflow.data.context	train
6e5f89acf106402798e3e74b1a6d14c7	mlflow.data.context	train
d48c0aad703f4793aca227a1daa3dd1a	mlflow.data.context	train
854c48d7feb144a7a683632222e7e797	mlflow.data.context	train
5756a67306f1426ea580c3035f663c8b	mlflow.data.context	train
f0785fd81d7443df86cc11fbeee4ce66	mlflow.data.context	train
8b89f9d1170d4850b9d3905f1b318761	mlflow.data.context	train
e983e0d6052040f9a89190dc61aa3419	mlflow.data.context	train
19310411b4714adb911eac5a229cf76a	mlflow.data.context	train
4ff429a7c09c4482aacdfa2c86ad67b9	mlflow.data.context	train
dbc63d63640843589c1f07632ad90fd5	mlflow.data.context	train
c778bdc02bab44a5885a630ba67c00f7	mlflow.data.context	train
6ac15f397aca4793a239c26a6d9e2a57	mlflow.data.context	train
e73ad21bda804f6b81f560909c43b155	mlflow.data.context	train
7ccfe7d6032c496aadf8f001f60f130f	mlflow.data.context	train
fddde806e35a4f7ab0257e9d63bc76cd	mlflow.data.context	train
a3036ec9af2047b38c8a0707b74fba54	mlflow.data.context	train
b179c4d176c3413d97273b89562d6911	mlflow.data.context	train
0996e3f291e343d0ab3f0b9b92c09eda	mlflow.data.context	eval
\.


--
-- Data for Name: inputs; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.inputs (input_uuid, source_type, source_id, destination_type, destination_id) FROM stdin;
95d57bdc767743918933973482d37aa7	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b065943b869c45d1ab9a544997cbd2e3
171c57c935b44612af25b8b07e5d5f56	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	876e004fc22941a5bd0abf6035008d6e
b29b7bfecec14b26a8cd03668fecc4b8	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	77d0e55214db4ecd857415d3af80c800
1bc21b9625ed4e389e1f862d17fb915f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8af2154e65c646ba85f95ef956f429e3
215d02e1fc5046cbb6ac7f0a077fd323	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	546361b43206462abda8503c0473c830
900fbc0a80fc449cb8cf2d2339289448	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	863d9eddfa374352ac9ef04f414aed07
08b301d7bee44336a81cdefffdf6fd16	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	761f6f2a81274b38bf29c785c17b9f5c
2a4bcea08f464e18b1d37d2efea62d47	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	014e8bb3efda4a7f9e544ad0c54eda97
97a958a92dcf463eb00ee4956d60f6b4	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	889b7c5d83704dd2ac3f3508dcb6bbeb
da996d45c74b4c5a8c315d48445d5537	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	ae175d867d8d4942b3953e031f48deea
c3eba166758948298fb1e1805ccd7558	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c570005822f1468ebc56e3a2e5f3a7be
d574937230fb4c40a478611b00b4d016	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	6198d6b56d9e4ff5afeca1168f4226b8
88c6988a4b9640b09e21768f603b7ae3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	905dc0ac6a9b46bfa4b2435798fa6880
f9f7bc96d80d4f53a74f4304a7155788	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3c993ea82ef44d1f91ec5ae384b63d04
cfd8c01e416947759db02dc56036d58f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5f4890e2fdc040bfba29e6fba7cf13de
165dbaba652c4c038e3a2224f41a516f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	31c19df3feba406bbe273cf28ad356ea
b909a8c7a1fc4ac5a7f58d585eac010b	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	06988d80ee2a49cc847b86b0ba828472
f9d5bfb1c9e94230b2275aa13349f9f8	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	884482f15ecf455cacf6203986941bd8
f4861bd4395c44eaa4d8e369c7a93088	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	1336414e54eb49e886f22580bd301b28
6d03ced2459a4fb38df6e109fa8f4c28	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b3547d0973f74bf49d4e595aacdb1e3b
1ea4cbe8a44a4b9d9a842244a98b63a1	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	11cd7d2db6784fe4b02a7ae8f71d8cf2
080b7bea336942d28e62f153472502fc	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	58b4b9d2beff44d3b6bce2af1c53b954
ba05fbed0be4440996297062a9655158	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a96bb954fdd64eed9d3bb56c6d5ea887
7addd0537a6946ee9d2c0009158e9f8a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	ed6d527941fe49ec9efa86d9ecec40b9
3182d6a4f74b4dafb47db9dab88fbb2d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	9bee251d163640f4b41fe3bb301ce520
54a25514ae114c42b4c02942989fa9bb	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c5d632c0f5584ef38bba13efd4e41e85
4289ec2cb6364b7098ae942cf3f813ae	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d54ca38b32404c3ab9603d5c17d370be
4c2f768b0cf84b1a825543f164469fc7	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	74a92f84946a40ec9f5ef59d95735532
c7dc116603b5452f908fe919c9ec4dde	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	19cbd69551b74540ae49e5172dcbd422
7b709c5f648042caa0b9117e7250fce0	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3ed8585907ef4caa8fe4d70cb6b0cc87
b2e23214dff44c50b78b2dc68bcd3b00	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e29e156922854739b295baa6f96964b9
9fb9dc59a2174286b1fdda0c782016ef	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	337c2ecc590441f4b0d4ed6e6c6d874b
522881fad93940d4bd77d6e188ff5d6e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	4aca56d551a8462caff8f4910dc5c067
53ef7fa4fe2741b3a3468f14dd4339d2	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	4ed8356cc0124c2687e88834f4d5b105
4f45eac0c3744304807eb3153bf89723	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	bb2f576d862c4a68b3b67f55ee6e56e3
f9c007a1f1704594b2ca5d9ba582db0f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d4ffdfcc60964dc2a44d6526250c8242
cfe269688a114bb58f201049f52af9da	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5094306f911645f7960433fa475f3906
27589a9a40d3429183b9540fee8f8d2c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c15aab38a0b749289678168eed8a375f
42967c34dbc244afb479c3be1ca0a6b0	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a66a3b993e8c4892807fe3212c6626d1
2fc4b69764124914889c53136bbc40ff	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5c42167498f34202a2d02f90db37735d
b9ec9df23000417890e11d407be6d993	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	802c5ed50bad4391bbb5c72644ab5629
558f2d759f5f49f5856540e210b6bf59	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b8c92046e4d64195892f204054da11ee
96f4fd3324084454a56e7de2cdb996de	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	6558904b55d747dcbb1151b72104deda
58a6ce1982e5447995ee22facedb6630	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	23f4f5b6b75745cbbfb0974a54367678
8dab90c79eb64de4a22195b6bbcdaf27	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	979923580d5349d5968ee3fbca0c330a
5c41d6196a614acbaefcc55acf241f30	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	bc0ab96304f34a6c848f80daf1fb9a6e
a0dc3a27d79b4917b5d3ce6265072bc1	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b58e93020e20438db09d29ad3c13df59
a14fb5ed611144278e9801942659a0c7	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	70213c72967b441a8ecd0ad831f5b776
9a1970c00b204152bc536374b65fc553	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7eea4fc7e3a546589babe6a0b7310882
ac7cb07e1167404b95fbae08d318cca3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	518de6201cd84159962c329678dae7c7
782326778dc94b6c9ff804346f4c0f41	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2ab6619860f04dd6806c00d08dd3c42d
0ae2406c91fe440bbbe37ed9a644c2c5	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	cc29150802304136adce6bad79c64a02
7c66f1bef745424b970f36849db0b67d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e70dd208f60b4acc863c851496a7b8e1
613245d7d2f94dbbb574ad49a6854b21	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	16766e90a32c4f369ecd9e9b701ab356
b95245a24d01448c93da5b1115f2caac	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2918b242568447af9cdc39919fb7482a
f835778454ab4bad89a7b1c6201b0dcb	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0f8c5f9035b34684adc09c8445ef8cea
a38cae2e03cb4060896b6c3fd26de73b	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	10f0304d917b4d91a53520741a9f09f3
852876bce7714beea3b2e99efdc8bfc3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0862f531c85046b18a2ec61111e68861
1feac921f7f3498bb75c0f708dea6673	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	718cc73f4d1b4db98abc0e7b10db5ed6
f3586bcc6943420fbe97870dfa4a2740	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	9aac8f92473d49cf903225b9a22ad98e
cbb5fecbdbee4e72b232ab522824ab60	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	fb402d7ff6d741018d6a91ea10972f05
94a6f3dfe536489d97f52238a896a4f1	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8f70bc6c911d4d3daac5817bcbceb1c8
c5bb0dc8cade464681cf9ad4158bdd29	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	6d7c5305df6349cebc54d4fa9a31214a
e634bb26c67c47979377f6d39801596c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	f3039f0f77a54e3a87583ce82d69fd41
5bd8da6be07e41969d67c4945d331837	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5f60cb1e96ef4d32aba7cf2ba79d8aa2
ec96240aae6842adb836d488b69bb794	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a8986aaa09bb45edaf20a7a2a477b6f0
f10d28e1fefc4b499720fdc2d037d714	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	08f786cb8efb4f64b9a2607fd6ca5ee5
1d4aa5085b0f48cdb4b47dfb66c2b0a3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	deb70d2c6e9844ad8ec9a5549a069559
291260d182144323a3046604d0ba1f17	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	651dd8509db8453e9b57f0db626a0bc0
d8ede011e327477aa66d38258d82bce9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8883ec417d31449b9c035b2913e2c586
a303d569848145aeb91dc51b19f89a48	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7c8b46c7a5b748aa8f1d0b39f7af527e
d6dee4d195ce410e8ceed284d9af134d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3543bc1d263645d99771e0034c716e7b
d287220a7f044bcf868e3b311fcf215e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8e5b753561c44b3195234ef62f8f47b2
2fa228a4b7254eb9b37c8078d556f61f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	9e05181cd24c4328ad2c35ebdb23abc7
35bf27584e8e491bbc29699d7e529f17	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	08b5f55856b74797a4e16456167adfd5
32217cb4ca6645a486e6d918dc0b791a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d936f59062f2489586c8c6aa48246a22
2876ece0bebb44ceb96f726a1bfc8404	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d1000f6e85de4fe2a8c95dc022bdab8f
2043b3f3bd4342d0a073638936930da2	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a8ef003494f048faa29d895d18d2d187
5ddb60575712489ab8bff1a67a0fb1ef	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	fca3189b071b4c8aae99a36fec28a55a
a2ea0be6fc1641c590dc60e8f1a2dd51	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	aa2f79a2f19d42db9cb8620483e02b5e
7fa0aa6dd69e472093421d7745c289ac	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	9c1ced865d204984869839b7cd4f6859
d07e1e820f7d464594ac83b2ef701dbf	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c2857623dd374caeb05d44680f352000
8d2b623534cc431e98fb97e5cfa8bdb7	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	69b74a9c9f174a25b25bca9453b251dd
3b914a813c21401494c482b7cc21a588	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	4a86e315bd1b42e4a441cf540b75416d
18a0e068f4144af59af7db8f1539b14a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e094133c648a4dcf978411aa6d5934e7
5e421b700ddf4ca0a002f543ad32e356	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c88117b6aafc456082337e849f1bf075
07eabfae348e4151bb5abddd71a326a4	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	329d6d6fd07d4659b5300ae5ad320063
b666eee6a6cf43ad8d14c20025652127	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	581effbe4a2f4945aaadeb01b564b851
eb0dd79e91064612bd589c63b4d35857	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d90190edced44c048d8f32ec24d761bb
6b34f19040d447a9a45c25ac49eb88bc	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3401268c42cb4248abf5eb0c4fca768a
728571f9e2034a6ea2867d1de234b418	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	cf02466f55074fecb9cf4a06f6468695
ff407a54fcd84fb7a55cdee6b711c310	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	491c6531e590476ba6d0e4c3f8ee4002
47456ba58bda426c857c982df46f8000	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a6e212b95bfc4605a1be9024004fb49f
9dc85489530c441188c477e4540b3c17	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3919fe95d06c45a48568942d0a5d55ac
4ee0d4dbeafc4839a2f52e5d867adda3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7594e7f61c11418997699b81d6b68aac
cc0ea6e17f52427f89fcf22191818c16	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0260b00d3be4497b9ca6fbdcf0fb56f3
91b5907780834f019e24c775fe3e3cee	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3ac81d7485e549e392a19922b5afb56d
2993dc288beb42c49253a6625b026f64	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	9310e0296fef46229d141a34118600f6
bce778d0423a4efaa2376d4bde7ace9e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8dd0782b26a647b0924ccd9a97b01735
7e295b1d73e64b9baf0d78fd13edf5ac	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	17cdd4ed361b4c6aa962d390cb1f5fc5
c1da0d15980d4a5c95ba6cd36e3bcc63	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	701e73d0f1184acd9682089de7c9c496
9c45bab111774fff9e6dc298ad9a4757	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	111954c77263486eb7b19f050d26b75a
ea82ed7119854b3a9852be495b41a47a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	804bc8eb2efe4ead940fa0c158126ca0
de7e3b3d4d40465cb4f1bb8e6a55b094	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e8d9a9ae1a314ef4822cb690114b565a
fd1cf85a03dd4b7fbce78e8112748649	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c174b51cb9ef4197a069b455c2ae15f6
06c85359c6d9481faad4bfa16328915e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0561a4c2b698400f949c0e76eef5fbdc
e33259400283483dadd872ced9c46d56	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	cfd7a5c4650749a99227270f7490d366
334c1fcb6d3f4868bb9bc47752b716ce	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	99058e32615c47359503e260cbce6d91
bdfb38b742414e9793fa098bb46106b8	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	49388c150ccb4b929ee16b2bb07bb27f
d097a1df90c54d3faa80b8d6e7988ecf	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	27593188f9b74471b4e76392b99287d0
f2e61d71316b4facb10bc0a815e9500e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7d1d89bca5f64345807b2f8710248857
6711096a25274abfa068eadd54b0d2f6	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0f815fdf0e0645fcbc9bd75f41904b44
cfbcf769a926445ea3e088e9ee7cdcc9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	fd3500958da74eb280182de207c1c9f1
92ea5248e973475285a386fa8d5c40b2	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	64b0900a1e964558863d196db339900c
7da25628e8c54839a8196dfa6f0bb2fb	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	dc2d72393aae497781f7a6cceff926d7
9df77e59a9ae4968b3f717c10d5ca79d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	82bdb95fb73945928fc4add300efc29e
b6a1529d91d74a98b30beb64dd5c22f4	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c04b03a1eb034e30ab0dbfd07f0a56bc
227d6edefa974f22b5a3827d2735024c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	61939d5dc91f45f0b71ee70059923014
0d6c266c77714387b586748bf5cb8d2d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e62dd40594234fe2b1e7032791dd20a8
e7409acf210a4c16a14177e378d493d9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	fd9968abd7b9464aa499ac3910ae6d59
722ebb02799b4b859909e5631f0978a5	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	40baf7c768a8472dac8cadf8920e416c
41e583686e614da896f74562bd3b84bb	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	4b6e2f4862564695a32ae677d3ebd136
51d854fdbf17465ca07fa3b8641ca4fd	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	82eba4c14c7b4ac791e397f13b4544de
e18ba170c4a04b89b2213513dedb730c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	86e01e0667ec427599d0c10de411791f
800829ca9c9a426da83e2547383284d8	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	982fe4200d6b4f95a5e5e436b1885c0b
a4ca6887c4e8442d846599c31c5a8287	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	ea474e0674fd492c81f549be6c166cd2
e2b66c23fc1f4fa1aa83de95b266d157	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	6e7d042ef55247409d9390031ff02a47
fcc1d91254714812849970f5e4514fb2	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	caa44697e4d24e98b6d5f91363319ce0
3fae9094a6ac49b48ce2ccf36bd9cb7d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	09141ce7bff34a53b91aedc1c71e0d1c
5f44a79c13bd4e07b018de9d685857e3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c1dbce29b41c445ba8138ce9811b0068
1b999699497049c2965e89a39d0a0b77	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	20e40ce2d6c44003bb759ab6e1351170
6081d39ac8d84e2f9f1eb8951b4e9106	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	079ff97d445546cbb52ed19b2d617517
c57a50d6615245bbad812404389eb665	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a8008dd2ea1b43f196f1024d66cd3866
b211b20bc901470e991cdf5ec9a2dde3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	ed12fbe584314822bdbf2b28e61fd9f4
d93ba875a1ad4de8a755ad0db79339dc	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8dd5e097c3e7404b8bb68ce4d54c81da
8e0fc0fc4aa943bc8ea15d14cc490c81	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5dfe43d07bae4c3e8be8f52e18ee4e21
3533ad2327834c348910a194a43c5f5c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	373663ce084a43b8bfb50018919a65db
424e36f1d8e04e559bde6e65d4f2917a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	bf5751b68e994a81998944e44b1b573d
bad6d531e40a4f46969e902f3d02f787	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8c20356faa924d4fb9eba650a0792cc3
a63f683f5bb14629ae76aee65a2e6e3b	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5e4c9e7de52d47a391919bb68173e02c
6e743dbfb04742f4878d92030389c6ad	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	81cc585288d144dbaed1346c79c254ca
0fdc5eed152d4c5bba699c1946834263	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	729adea5b08d4ad4a4653e52efbafee9
c0e77607805241b8893d6709a4e96ace	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	aea8d7c689ae4b289a07ea312f8cd967
d6ca0bfe4bb14b03a8ec25819c165998	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c3c64461db474abfb41a7918f0836f40
e162c2a8156a4070b702d2717532e926	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	52134bc6efa44da38234f805e719543d
e0c6266a4a3742e5b71e5714526c5cc5	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7263fee2dbbf4c2c8d21f11ee7cfb4d5
e7be533cbd0b40a0aa4248a1ad8b9c7c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	858e7d66bbc44d07b4318652fe66bf8a
9c55b3aee8c444a69c1d4bfc8996e001	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b93a661f89624444924de260e56e2235
f47a4f52d7394566b1a22130f37c19ab	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b3a13dff7789467091ec52640e9adc99
2ea6f06027f9497fb118a970ac9f50a6	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	aaa258948ae9488bb474a158d63f9148
0a30aad499e040b7a8761eaa52c65883	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	1858617a3b064a73a5af67ad947b5cdf
f4e81a1665d0476fac0d60d9006e2ac4	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2cb17c9ab3fb42f6a309da1001231d6f
d823db558cbf4c1895675b142565c49f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	343a984aca99424a9ea4fde70eae7fd6
a0ff0d5145544c8f9e58e429cf21bc6c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	fe50acdbb80f44b3b833e6da5d8494d5
585ec19c13bd4d13baea223287a4ee39	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	639bd817783446149d47dfcd0926f1a0
67a224f91ee44b68a7893cc5c09e5eb3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2dd58258a1c14b7e9fbbcf0a30084f7d
31182d7bda924e208456ede258f8d149	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b6ad1bd3b5e24e56a38c6e514a836fbb
7fa8a7616e1743fcba36acd0b1ef4881	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3d117da059cf48f1b0389bf9323ce232
3f015966db2644b5995477b4faed4344	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	175caae5af7f4140b4ecae075484bb7b
b72f3314cbce4da494ff083f791d588e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	37b22dee0c674dc0ae4c25e6ee9d21d1
f2293aa90f3d429bb0defddb8442019a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5b7ac14d710141e0ae9db4df5d76863d
d9569383c66a47fb9d3b583cd7a79e74	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e5c01080e79f4145ae6c1fbbeb6dab7f
ad0dd5d0e4304fd7aa902730b40a84f7	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	12c0eb897e9e4e799fa7e402ede53e68
d51750747bf1476db87097c51a4363bc	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	db19dbd296a547468d99e1eac5c48d91
7c8aedacecb7426d8a35c8a8b71846ff	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	920842c57a5a49bb87e14ce762de0e6f
e76e931b417d4053b2a9887e53df726b	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	464465db08d54ca3890683e7f08018cd
862db006b02943c58a159701a57f3923	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2719cadee66a4cddb04bd6047c0bdea1
b8134b08fb934cb78928be6d108c385b	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7da83a5b702d4cd9a3b6288e6ec4a963
9249e8aadd4b46658949623471ca9a7c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0fa292059a01459388a9848f32021680
9c0d885ebe0743f68c771b590753b9c5	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5ca501b4ad684b6d8ca4c0d74bc38d7d
bd2dfc06daa3407eb2505847019a97ef	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	dab10324d6874b25b032b2e41b538db5
1c9016c0a79b42009cb81f6da1696bcd	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a88dec410f58417cb1ad18c7cb2485f3
398f4d8f2bec4297a2f76d2258ad440c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	57a6a6513f3d4a139635fb009beabe0e
8e6cfb09de0045b7973081ed7362fcb9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	bdb2446748cb45d9b995eaf2595da298
35cdb3848b3d4101b4f416decbc76278	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	52254688abc64f459641607d3a8dfb6a
a94a303c85b9420e92bbcc41741dc5c9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7d976b24c40b49f396e96bc3fb05fd94
ac4481e95a83491e96f5db9286c18b20	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c30e3c7d28f94109946cce7fcb30cba5
f88ddd57a7e34363a9c1cf18ea798596	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	1bb7906f11194fa6b7498584acfcaac0
fb9f8507b0ef417b95bdadc70f8f8960	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	350e32e8aae5456fb766e828852e52f8
b66c45a02f134c2a852d6c850c6b2c2b	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5aa083ca632a4a3ba6f7762d0c339e85
039a8b4ad7764ef2acf37e684e90c2c0	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	dfdba455d2f94583a9a6c822f573f830
3d1ed19e418b425fb1277ab95484dfe5	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2bc4f68109344e3d8099ec77369d61d3
7538ce241a884d8aa249c3c917c41587	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	993859e43a124bfbba2b2ebb47441c36
b00659f6e81c408082cb2eeb4728fcb2	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2715b04b5bad4a7ca933580943a2814a
ba761baa663949a68d6d4bf91b1f8faa	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b7b0e8f2158c4888aa058c14df7a1439
3c8f3e23dbb94c54918522907915b85e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d8b6ad6854ce4c91948c621ba3b09130
e8ffb0a32bdb4553bf55e54524ca47bb	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	621e30a66f4f4f2c9e8e5d2e3d26b6f9
04090cbfe19046e2a190074b608956ca	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b49827a8551c45039120e727c2742f3c
56902dee4b384f7796dd58c6657b741e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	95bce22e5e554d8298e264b28c9e8fc5
78a688c8bda445eeb10923517d52c01d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	bc449f79816a40b389ab2d1898b1b8f4
8f8920cab82847e1a9bd1d7a13f3150f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0b2d11961fe2427d959a976e2033ca2e
b0dd9cb4541141f89381ba37bb4cc8f8	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	000523ae15fd47739ed9fccc383746ef
e68942776c0c47e5a4714951f2e6bd06	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	308716eedad140d8b8c2c920a5203a28
b464d71c8d144044b8c43490c16283eb	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b4b583974c19441a99bf1809f32d97ac
49603d30067f4f96abab6a1a16e2b8e1	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d720a01642da4ff5b01c61771cdf9d91
cc1989f7670340389ace949d4b5ca7c2	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	9c030b074f6740f7b9f76b2dddeffb8c
fe8f790f46c0400b935937b02f4ab556	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	4fe6b8e9bbef4cb49dd0b503775f095e
f0cdc76fbcac4880816da7b43c48e697	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c9bd89e9733b418e8a4c762cccf8aa2d
fb08aaf2ee4a42eb9c43fe635d12b62e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	61bef132335149da8fc1bcd646945380
b86712daee194260b04efaf96aa3240f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8c036e2f01ae4dce9b24165f8105ca06
f37796355190402dad85770509c60b64	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	532603551a954e97bc6f82485f631d2e
497bd1255b92496db258b31009aa5330	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a4fe1e00ac0e4e67b019e182ca42dfa5
2fb461dbe2df470291ed23451efaf88e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2b432c32784143a9b9d3be8670c9b2de
d7d47c8162b24a5eba07cc48e25cadc0	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	91efa9c98d164aedac595d534867cfa9
a2273c054dbf4251a95f43d986f1428e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7cabb843d24d4b86a34757eaf1696d59
40f13e891bd2415896382cbb6dfe8582	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	cbe54d84d2f84e4b982ad2d27427c7a7
4a77f1f299494b258078bb5e8ea0b904	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	97fb30d77c874bbe909e9b34ff9ab219
c4253af28404412ab6ca59ff63cc2fe9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	23cfec62bb2b4c81b834e33e1d64015a
bad27db2eec74b8c909c5d47bb572bdf	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	4ad932f7dcda4517b7b5cc0c8beac404
7644f82a561a4dd7b701033f5c877279	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a83392e9cd7a4265b05f9abeced43638
2c6d3d1be78149df9a0e65c7681ff86e	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5271cb97dc8e4421816e4fbc4e06b329
069c11120ebe46328fd643d7a689c8fb	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	193b290a18504fa8a42991b624278dbf
1948d398dc2346b08dc8eaedbcaf0855	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	384089aee8ff469e884eb523460d2e23
ac8a0803268c482eb64b5ad8c168eaa9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	9ee14964976f41c9a0d4773391dc1b89
3cbe26e799374147b59a68925412f263	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	bbf38d0761d14a96a7f6af68d83b297c
7c03d42dd64944649b6dc69097d17aa3	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e465ea368468417f95c02d9736ea13d2
eda4b163bc2642f7b0c70226c7dc20c4	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7f39848a745a4f55b4b6f53656bbea09
e5a971a88c9149f2a3eb779418bc9df9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	99f8a6c1a99042518e4a0ef2de67cbd0
5cecdf1965974d3a97f5baa707e0353a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	82ae9253c99347c28805e14bb275d4e1
6b15654c3f8c429ea2e0ef1395303343	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	ea05524904e94189b607f30d35114cf5
e4acb16c87764ffa94f99f08e01bffc5	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	59630d004d38484f8b30f453b17fd561
e6080cf5000c47c09826098db3f33cc8	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	143106f491a142fa98764b4036346fc5
e032e0a9797e4bc29d48fbfae24de14a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	212e3cc9c33a469097370a89878e6e0d
4ead1ad386844260924b9772cab79078	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5098e5701fc04d33a5d78ff3e0c2d8f2
6a34ae3c1aa042a7bd1ecf06727af198	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0b4fd1f6f7d84dfe891162a68110faa4
d64e79dfcc654488ac2e081c36f6cfe0	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c8478da13b1d44e09ff6954fe7f8ceb5
1517378abae64b4aa33af29a7d3d2673	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2593c87053c24c5ab46a701293e5da1c
e1bdb0017e664cf393c73f62d1fecd2d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0a433fa3378a4b90b664cc4fde90ed21
7b4c1f4fa67341c9b8aa226d5b4c1634	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5731165fd9d341c093634c24885b4b80
19fb87837d1d4a2b8a4e509aed9eab87	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e04590dc86674c0985b160f47a15d939
4300ade655294a8fa284dcf360bffae4	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3a54e130da3a488e9cddd8f564b50636
f2e9c986aece48eaa2b1d99d7f1e9774	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	6fd1e2f0387c42e6bc1b573547aa39c7
e67bd77af16644aeae4bb5994a915ee0	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8c6c444e121e4c82ad5345c29fcd297d
199ccfe31f6b468c903d1e55202989c9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	14f0de2bdc004a6ca97d19b2d9dad96b
b4262e4faf88449aac7a1ae92ffc5128	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7f16b61fe03848238ff296583f7d49f5
0416114f16ff4362ada8fd76d6d424ca	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7166345b17ac40e3a6384bc3e57a4e38
4aba2f39ca0449af9b03de3758777b07	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	531d154bc65c4e3c9e3e691c91d4e598
fa976bcbba64429d9883ec89f25f24f4	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	196f279c8b2a47a3ae0b5e4069634bfe
ac17866ab036402ab7abc7499cd9a8d6	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	08a4d70131f54e81bd0d47a5448e3d43
4c648f7ce7ad43f0a1d66431bcb3a99c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7305560d783f4197a5a7e63dcb91495c
319a25f66e2c49d9812341a79109276f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	af4fa3186c554df8bd52d00efdd3b518
d1fb189769244fd9b5d664ea7e63b82f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	0e6ba24868c9455f9324ff11fa6f37c0
58fd71129e344694836c4b4e57ae2d5c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e6f37d31a9df48adbf7ce400630985f2
199c9e30c1304843908e5b900f242513	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	5219ab1ee77e4d0a9b2ea76665637741
a8cba5e8fbd04cfa86c77b3dcadc33d2	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b7a96024f405468da0046f142f3fba28
680052940448475e9819cea8cccbabde	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	cc82112ae9004ab48a54576c09abb51e
94bb8b8b35e54c14900dc7eb96201c74	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	df12860a7b4a46e9abaef76ff774590e
9fa95fb2eb3b4a43aab868a0739f6529	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a45d4a14e3cb4767b85a0dd503888266
499cf862ed7e47bdab22d923c31f3e50	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	91fb3e7556b448e794bc7f57497b4ac4
3ce5f8046a494635943bd95179972413	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	28adcc19e5354574966fd00385b49f1a
bb55b9e3240c4ed7a640bea72da0851f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	fd79d84e5b9a463e8c5d9ad2eebe966f
064f21359ad047988d694227a266bd21	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	bd4a6462eb314b5cb3c57f9db508a4e4
a1515e9a6de5489782376cfb530f55d9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3405dcc6ebdd44609d0d260aa28f3122
caed02b439374195a39a9b18da3b3770	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	ee5e81cfc9ad4fda8222a171057e4ffc
84b0b3b796c34bf8b12ed8bcc11c7dc1	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	cca09d0a7a824be1b885d47ad28e10a4
16384e1d527c4e948739eee9b5b311f9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c599cc0f5ca645e989b7478887d03f28
1c66739f269346bc8975b87c7186bf9b	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	de0278a9f23d4eea946bc673a797c3c2
dd6887f2c19342fda7ae264510e37d03	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	130f444dde0c42df9f6abc1bd79d9b77
56b60adcbd7e4113a59eba96438c7560	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e3ca2557a9f543f7952783569ae86534
b4e347ab081d409e8833b70225aa3329	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2ad9ddee054f4a0fa0c5e251a177dd6a
327c301dbf394d8da5e245865bebeeff	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	117e0e60760d44ac9ef154cceb212171
05e15445280b4352a9af07820b560935	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	62ca7fadf67347b29ca9598d327eebd2
426b37e362374218a34f46865f18007f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	ba4d5a30aa02426d9e1536625f3ebe6a
ae9313607a134a8aa0fe6802225977ba	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	98d0deba9dd641d281274cbf802081fb
b2d1e43bd7344ab4ae41ebffaeec2ac1	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	cd47568195194bd4b3b7f694f1a08f9a
2b98e9b3d29445c1971149d4eaa4775d	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	30bde976c0b84a36b835f3d18848103c
aefd82a9580c432789d28beeee2f4133	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	200e44c932ce4dad8671cd5da9b409d9
0be25efe47204de495cfac82ff8719a2	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	8d81437cc3714f6982ae885c3c81bacf
a9695a86c5d047d7ab86945c115949b0	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3e09014e17a84af3b1624fa0068fa0a7
608896461fd54149bdc15b6b5d7a3421	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	b4689faec3f7445fbe0ba427b0859231
13ca8de39fbb4147bf119956854d1fbf	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	aa9da8551d8a425785523304e9c547f3
9174b416bb9845f3aaae86825fb12c71	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	f9ede5de86ea4f9b8ac1a181ddd36d72
1ca93d52fd87415488ae26842539aa89	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	569e3af54f5549d389c2817c8ccf9823
b424d2adb5f444048ccf18a13819ddb6	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	f0d12270c17441cb82afdc0ff9f70809
37b461d0212a45b8b4f34a4fb7732bbb	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	52e3ecc8bd264c6bb75dd7e13c9c3713
2a4a5242f1f14385b4e6911a0fdf0e62	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2e7a3710bd5e4ee2ad9d870e16e43be0
eb35cadbbc674e03be8b8fad29de041c	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d3f4b439155d4a1f8452de974a8fd530
fc2c49799e914302baa62dbf300b87ab	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	2d0fdb5b0ebe4654b38066951cec3ae8
3632e072a99344dd830a28eecca1e3b5	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	d6ab3fd3b7be407a86383f867d0d3987
4b3989bf714340bc85fa5d9023a22038	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	571b8fa9bdad427a9816b5b5144622ef
d515721eed8e4feaad831e82113a29aa	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	11b06d8ded174450aaa0563cd01e2137
21d563665dc54349b6536de568a27573	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	fea20651e3e744068c1d02e03e73f652
228663ab2a384431b2dd5bf88d331a82	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	35ea2431d44b4d5197234e1257f742e7
a4cdcea502b64522bb0e5dc6d63eaf28	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	19c7ae8c940042a9bea5484d5c7a996f
ccf3dfed465345b1a72383f0f60f3303	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c2a98b6d06ba4b14ac81cdaaacee8d9b
b4fb94fb347846e79cbb2d298c189f6a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	87f145f9b3b4496f901df95d56e470b8
27b84c9f3f1d488eb9a75c464e71bf60	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c23e0bcb7b334d3aae37f42aa4aaa09d
6e5f89acf106402798e3e74b1a6d14c7	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	f4eb85ac7f484c7b9665388a9a0d3e8f
d48c0aad703f4793aca227a1daa3dd1a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e9f2cf11fabd4422a3404f41f7e12593
854c48d7feb144a7a683632222e7e797	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	faefe080fefc45eabc2137abcdf3ef0c
5756a67306f1426ea580c3035f663c8b	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	96479ef023f34b15a8033d9c5657d9dc
f0785fd81d7443df86cc11fbeee4ce66	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	3e93389d94ca40148d153412a6cddbcb
8b89f9d1170d4850b9d3905f1b318761	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	eb16c82079fd4ba591d99f8201df04d1
e983e0d6052040f9a89190dc61aa3419	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	a643f1f3cf3147aaa764aafd4114e6ff
19310411b4714adb911eac5a229cf76a	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	e4ff17e0741440b49a2e374cba8fc594
4ff429a7c09c4482aacdfa2c86ad67b9	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	1918bf94daa7417a9f9a9bbe2f473d24
dbc63d63640843589c1f07632ad90fd5	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	6975e9f2410b4b48a24bb54de3773f71
c778bdc02bab44a5885a630ba67c00f7	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	c7ca2abd948b4f7a8f5ef910fcb0e754
6ac15f397aca4793a239c26a6d9e2a57	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	7c916e1a7e7d4b44be04309d6b501d6f
fddde806e35a4f7ab0257e9d63bc76cd	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	9e379079e72747be9cc278ce97ad8b11
0996e3f291e343d0ab3f0b9b92c09eda	DATASET	a9118643d62e49f7be17c6d19a368c6b	RUN	be0003b4c09f45a384716a36faaa3fde
e73ad21bda804f6b81f560909c43b155	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	ce2b0e6b82744bb9ab441eb5516e4bb9
a3036ec9af2047b38c8a0707b74fba54	DATASET	bdfa84c2a0d54fc8b74f481d22f1ce21	RUN	033ebefb766e4bfa8282ab39cec5c865
7ccfe7d6032c496aadf8f001f60f130f	DATASET	b19b1bf554bf4fe78226dcb7e3fc66af	RUN	bec59faddbfa49baa60c2a3653cd5dbd
b179c4d176c3413d97273b89562d6911	DATASET	bdfa84c2a0d54fc8b74f481d22f1ce21	RUN	be0003b4c09f45a384716a36faaa3fde
\.


--
-- Data for Name: latest_metrics; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.latest_metrics (key, value, "timestamp", step, is_nan, run_uuid) FROM stdin;
precision_mean	0.1928	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
precision_std	0.0007	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
recall_mean	0.5374	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
recall_std	0.0075	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
f1_mean	0.2838	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
f1_std	0.0017	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
roc_auc_mean	0.7435	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
roc_auc_std	0.0014	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
pr_auc_mean	0.2219	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
pr_auc_std	0.0007	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
ks_mean	0.3645	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
ks_std	0.0051	1784572665084	0	f	1c1474a4dc0a42e595b137a2ff7eb3cd
precision_mean	0.1792	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
precision_std	0.0016	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
recall_mean	0.6239	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
recall_std	0.0088	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
f1_mean	0.2784	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
f1_std	0.0026	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
roc_auc_mean	0.7536	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
roc_auc_std	0.0017	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
pr_auc_mean	0.2397	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
pr_auc_std	0.0043	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
ks_mean	0.3818	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
ks_std	0.0057	1784572691528	0	f	87bee9e02af04727a439076b5099ea26
precision_mean	0.1906	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
precision_std	0.0012	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
recall_mean	0.5676	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
recall_std	0.0084	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
f1_mean	0.2854	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
f1_std	0.0019	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
roc_auc_mean	0.7486	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
roc_auc_std	0.0025	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
pr_auc_mean	0.2344	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
pr_auc_std	0.0028	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
ks_mean	0.3721	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
ks_std	0.0062	1784572720546	0	f	a0d9d4037d9a483e8ff2887e8c35e79a
precision	0.18946943172636682	1784639991894	0	f	7ad743cafe754961865d8d9048d97887
recall	0.5667673716012085	1784639991894	0	f	7ad743cafe754961865d8d9048d97887
f1_score	0.2839985870717061	1784639991894	0	f	7ad743cafe754961865d8d9048d97887
roc_auc	0.7469787896220874	1784639991894	0	f	7ad743cafe754961865d8d9048d97887
pr_auc	0.22682644224808374	1784639991894	0	f	7ad743cafe754961865d8d9048d97887
ks	0.36509963247989025	1784639991894	0	f	7ad743cafe754961865d8d9048d97887
precision	0.17640308213563582	1784640008093	0	f	9899a48432a34cb39a199dcf5ae28c28
recall	0.6501510574018127	1784640008093	0	f	9899a48432a34cb39a199dcf5ae28c28
f1_score	0.27751031636863827	1784640008093	0	f	9899a48432a34cb39a199dcf5ae28c28
roc_auc	0.7602718944173115	1784640008093	0	f	9899a48432a34cb39a199dcf5ae28c28
pr_auc	0.2510765996522225	1784640008093	0	f	9899a48432a34cb39a199dcf5ae28c28
ks	0.38622369747523766	1784640008093	0	f	9899a48432a34cb39a199dcf5ae28c28
precision	0.185683025945608	1784640024257	0	f	f8b1be9aa8b34c36a0d398fea269c222
recall	0.5981873111782477	1784640024257	0	f	f8b1be9aa8b34c36a0d398fea269c222
f1_score	0.2833969465648855	1784640024257	0	f	f8b1be9aa8b34c36a0d398fea269c222
roc_auc	0.755851103110717	1784640024257	0	f	f8b1be9aa8b34c36a0d398fea269c222
pr_auc	0.24566666725077968	1784640024257	0	f	f8b1be9aa8b34c36a0d398fea269c222
ks	0.38159838812256747	1784640024257	0	f	f8b1be9aa8b34c36a0d398fea269c222
validation_pr_auc	0.22847684463910747	1784641519037	0	f	b065943b869c45d1ab9a544997cbd2e3
validation_pr_auc	0.23673910272767093	1784641555462	0	f	876e004fc22941a5bd0abf6035008d6e
validation_pr_auc	0.2384851347533118	1784641572021	0	f	77d0e55214db4ecd857415d3af80c800
validation_pr_auc	0.23858607120652361	1784641603660	0	f	8af2154e65c646ba85f95ef956f429e3
validation_pr_auc	0.23613197746454997	1784641635034	0	f	546361b43206462abda8503c0473c830
validation_pr_auc	0.2041055703053928	1784641663972	0	f	863d9eddfa374352ac9ef04f414aed07
validation_pr_auc	0.23838542170727814	1784641684244	0	f	761f6f2a81274b38bf29c785c17b9f5c
validation_pr_auc	0.23580317605346182	1784641699980	0	f	014e8bb3efda4a7f9e544ad0c54eda97
validation_pr_auc	0.23554122697991406	1784641719336	0	f	889b7c5d83704dd2ac3f3508dcb6bbeb
validation_pr_auc	0.2379827604380464	1784641766154	0	f	ae175d867d8d4942b3953e031f48deea
validation_pr_auc	0.23951316720116397	1784641788237	0	f	c570005822f1468ebc56e3a2e5f3a7be
validation_pr_auc	0.23890335176619626	1784641825233	0	f	6198d6b56d9e4ff5afeca1168f4226b8
validation_pr_auc	0.23614247754587858	1784641873239	0	f	905dc0ac6a9b46bfa4b2435798fa6880
validation_pr_auc	0.23478565204395876	1784641916689	0	f	3c993ea82ef44d1f91ec5ae384b63d04
validation_pr_auc	0.23329095050690005	1784641980822	0	f	5f4890e2fdc040bfba29e6fba7cf13de
validation_pr_auc	0.23889832181700338	1784642051275	0	f	31c19df3feba406bbe273cf28ad356ea
validation_pr_auc	0.23667609196380138	1784642096843	0	f	06988d80ee2a49cc847b86b0ba828472
validation_pr_auc	0.23102322180299026	1784642128731	0	f	884482f15ecf455cacf6203986941bd8
validation_pr_auc	0.23776487732917548	1784642165917	0	f	1336414e54eb49e886f22580bd301b28
validation_pr_auc	0.23884570145784734	1784642198823	0	f	b3547d0973f74bf49d4e595aacdb1e3b
validation_pr_auc	0.23339096226929382	1784642245798	0	f	11cd7d2db6784fe4b02a7ae8f71d8cf2
validation_pr_auc	0.23834803080081776	1784642348840	0	f	58b4b9d2beff44d3b6bce2af1c53b954
validation_pr_auc	0.23915791322056684	1784642761801	0	f	4ed8356cc0124c2687e88834f4d5b105
validation_pr_auc	0.23866442210324595	1784643048848	0	f	6558904b55d747dcbb1151b72104deda
validation_pr_auc	0.2387430926112426	1784643089208	0	f	23f4f5b6b75745cbbfb0974a54367678
validation_pr_auc	0.2351100581492431	1784643190090	0	f	bc0ab96304f34a6c848f80daf1fb9a6e
validation_pr_auc	0.23777746150047085	1784643293525	0	f	7eea4fc7e3a546589babe6a0b7310882
validation_pr_auc	0.23742885554570173	1784643318803	0	f	518de6201cd84159962c329678dae7c7
validation_pr_auc	0.23789070635819176	1784643434174	0	f	16766e90a32c4f369ecd9e9b701ab356
validation_pr_auc	0.23536910495163546	1784642412599	0	f	a96bb954fdd64eed9d3bb56c6d5ea887
validation_pr_auc	0.23961769328806004	1784642612550	0	f	3ed8585907ef4caa8fe4d70cb6b0cc87
validation_pr_auc	0.23278599478541076	1784643161755	0	f	979923580d5349d5968ee3fbca0c330a
validation_pr_auc	0.23866596482091815	1784643261466	0	f	70213c72967b441a8ecd0ad831f5b776
validation_pr_auc	0.2386994679787821	1784642448609	0	f	ed6d527941fe49ec9efa86d9ecec40b9
validation_pr_auc	0.2394939852743986	1784643222098	0	f	b58e93020e20438db09d29ad3c13df59
validation_pr_auc	0.23852488273745287	1784642482497	0	f	9bee251d163640f4b41fe3bb301ce520
validation_pr_auc	0.23747700544092193	1784642796415	0	f	bb2f576d862c4a68b3b67f55ee6e56e3
validation_pr_auc	0.2283517678688885	1784643481683	0	f	0f8c5f9035b34684adc09c8445ef8cea
validation_pr_auc	0.23267544480965693	1784642508328	0	f	c5d632c0f5584ef38bba13efd4e41e85
validation_pr_auc	0.2355425344300796	1784642580371	0	f	19cbd69551b74540ae49e5172dcbd422
validation_pr_auc	0.23703004948504325	1784642901455	0	f	c15aab38a0b749289678168eed8a375f
validation_pr_auc	0.23481808389187075	1784643455357	0	f	2918b242568447af9cdc39919fb7482a
validation_pr_auc	0.22686677995992874	1784642526876	0	f	d54ca38b32404c3ab9603d5c17d370be
validation_pr_auc	0.2400271007485743	1784642639468	0	f	e29e156922854739b295baa6f96964b9
validation_pr_auc	0.23831596994324025	1784642867543	0	f	5094306f911645f7960433fa475f3906
validation_pr_auc	0.23978826701065245	1784642959366	0	f	5c42167498f34202a2d02f90db37735d
validation_pr_auc	0.23884833089245702	1784643001480	0	f	b8c92046e4d64195892f204054da11ee
validation_pr_auc	0.23921063477794782	1784643344622	0	f	2ab6619860f04dd6806c00d08dd3c42d
validation_pr_auc	0.2354744790233689	1784642554034	0	f	74a92f84946a40ec9f5ef59d95735532
validation_pr_auc	0.2388521432104879	1784642670596	0	f	337c2ecc590441f4b0d4ed6e6c6d874b
validation_pr_auc	0.23344649764795122	1784642713593	0	f	4aca56d551a8462caff8f4910dc5c067
validation_pr_auc	0.23636428410341098	1784642819171	0	f	d4ffdfcc60964dc2a44d6526250c8242
validation_pr_auc	0.23621279182916544	1784643383705	0	f	cc29150802304136adce6bad79c64a02
validation_pr_auc	0.23847991081147066	1784642932911	0	f	a66a3b993e8c4892807fe3212c6626d1
validation_pr_auc	0.23752624988669915	1784642979469	0	f	802c5ed50bad4391bbb5c72644ab5629
validation_pr_auc	0.2386382379261528	1784643409561	0	f	e70dd208f60b4acc863c851496a7b8e1
validation_pr_auc	0.22887033290496642	1784643524174	0	f	10f0304d917b4d91a53520741a9f09f3
validation_pr_auc	0.23889086285921363	1784643561400	0	f	0862f531c85046b18a2ec61111e68861
validation_pr_auc	0.2365207251286767	1784643584346	0	f	718cc73f4d1b4db98abc0e7b10db5ed6
validation_pr_auc	0.23771819921120665	1784643600416	0	f	f3039f0f77a54e3a87583ce82d69fd41
validation_pr_auc	0.2392606581569918	1784643621555	0	f	5f60cb1e96ef4d32aba7cf2ba79d8aa2
validation_pr_auc	0.2384366470284109	1784643680676	0	f	a8986aaa09bb45edaf20a7a2a477b6f0
validation_pr_auc	0.23773057149051485	1784643710617	0	f	9aac8f92473d49cf903225b9a22ad98e
validation_pr_auc	0.23105046264547935	1784643740803	0	f	08f786cb8efb4f64b9a2607fd6ca5ee5
validation_pr_auc	0.2379290565120181	1784643782286	0	f	d1000f6e85de4fe2a8c95dc022bdab8f
validation_pr_auc	0.23720809307337418	1784643816797	0	f	deb70d2c6e9844ad8ec9a5549a069559
validation_pr_auc	0.23765597796270455	1784643843094	0	f	a8ef003494f048faa29d895d18d2d187
validation_pr_auc	0.23822738469831842	1784643863200	0	f	651dd8509db8453e9b57f0db626a0bc0
validation_pr_auc	0.24045021219057036	1784643882588	0	f	69b74a9c9f174a25b25bca9453b251dd
validation_pr_auc	0.23732912683715965	1784643900219	0	f	4a86e315bd1b42e4a441cf540b75416d
validation_pr_auc	0.23943472927823112	1784643918668	0	f	fb402d7ff6d741018d6a91ea10972f05
validation_pr_auc	0.23796586447544502	1784643943262	0	f	e094133c648a4dcf978411aa6d5934e7
validation_pr_auc	0.23801187252810552	1784643958044	0	f	7594e7f61c11418997699b81d6b68aac
validation_pr_auc	0.23932617239339504	1784643975953	0	f	8883ec417d31449b9c035b2913e2c586
validation_pr_auc	0.2264973966304575	1784643989232	0	f	fca3189b071b4c8aae99a36fec28a55a
validation_pr_auc	0.23772922092388876	1784644006530	0	f	7c8b46c7a5b748aa8f1d0b39f7af527e
validation_pr_auc	0.23225621888562065	1784644024984	0	f	3543bc1d263645d99771e0034c716e7b
validation_pr_auc	0.22236546909088686	1784644049752	0	f	c88117b6aafc456082337e849f1bf075
validation_pr_auc	0.2363161873472584	1784644068585	0	f	aa2f79a2f19d42db9cb8620483e02b5e
validation_pr_auc	0.23916579555158798	1784644097446	0	f	804bc8eb2efe4ead940fa0c158126ca0
validation_pr_auc	0.220999937856713	1784644130564	0	f	329d6d6fd07d4659b5300ae5ad320063
validation_pr_auc	0.21622049631541057	1784644159055	0	f	0260b00d3be4497b9ca6fbdcf0fb56f3
validation_pr_auc	0.22818219248907942	1784644186691	0	f	e8d9a9ae1a314ef4822cb690114b565a
validation_pr_auc	0.2355513338184599	1784644201775	0	f	c174b51cb9ef4197a069b455c2ae15f6
validation_pr_auc	0.23706332122359083	1784644219320	0	f	0561a4c2b698400f949c0e76eef5fbdc
validation_pr_auc	0.23817803240696447	1784644239926	0	f	581effbe4a2f4945aaadeb01b564b851
validation_pr_auc	0.23443351613560118	1784644287430	0	f	d90190edced44c048d8f32ec24d761bb
validation_pr_auc	0.239117736655064	1784644306074	0	f	3ac81d7485e549e392a19922b5afb56d
validation_pr_auc	0.2393617378394998	1784644326022	0	f	9310e0296fef46229d141a34118600f6
validation_pr_auc	0.23774683170004546	1784644346834	0	f	8dd0782b26a647b0924ccd9a97b01735
validation_pr_auc	0.24075366127945053	1784644372220	0	f	17cdd4ed361b4c6aa962d390cb1f5fc5
validation_pr_auc	0.2297408100236427	1784644407055	0	f	3401268c42cb4248abf5eb0c4fca768a
validation_pr_auc	0.2367795768301549	1784644424282	0	f	701e73d0f1184acd9682089de7c9c496
validation_pr_auc	0.23790540786174308	1784644445464	0	f	8e5b753561c44b3195234ef62f8f47b2
validation_pr_auc	0.23941220941854172	1784644488263	0	f	cf02466f55074fecb9cf4a06f6468695
validation_pr_auc	0.23870385316495416	1784644522096	0	f	cfd7a5c4650749a99227270f7490d366
validation_pr_auc	0.23638927897706427	1784644562904	0	f	8f70bc6c911d4d3daac5817bcbceb1c8
validation_pr_auc	0.2368251315953689	1784644603409	0	f	491c6531e590476ba6d0e4c3f8ee4002
validation_pr_auc	0.2394520311696961	1784644645887	0	f	111954c77263486eb7b19f050d26b75a
validation_pr_auc	0.2383637904416785	1784644684420	0	f	9c1ced865d204984869839b7cd4f6859
validation_pr_auc	0.2378735910467362	1784644718998	0	f	c2857623dd374caeb05d44680f352000
validation_pr_auc	0.234504753039241	1784644751781	0	f	a6e212b95bfc4605a1be9024004fb49f
validation_pr_auc	0.23910835068112493	1784644802517	0	f	3919fe95d06c45a48568942d0a5d55ac
validation_pr_auc	0.23914526041439016	1784644848586	0	f	9e05181cd24c4328ad2c35ebdb23abc7
validation_pr_auc	0.23927049703030925	1784644882235	0	f	99058e32615c47359503e260cbce6d91
validation_pr_auc	0.23566446898205218	1784644913538	0	f	6d7c5305df6349cebc54d4fa9a31214a
validation_pr_auc	0.23837139587623624	1784644937381	0	f	08b5f55856b74797a4e16456167adfd5
validation_pr_auc	0.23730179081428887	1784644968297	0	f	d936f59062f2489586c8c6aa48246a22
validation_pr_auc	0.23587435419413547	1784645006453	0	f	49388c150ccb4b929ee16b2bb07bb27f
validation_pr_auc	0.23981335948646296	1784645041091	0	f	27593188f9b74471b4e76392b99287d0
validation_pr_auc	0.2386440424187308	1784645079839	0	f	7d1d89bca5f64345807b2f8710248857
validation_pr_auc	0.24014290360593785	1784645114514	0	f	0f815fdf0e0645fcbc9bd75f41904b44
validation_pr_auc	0.23201299790453175	1784645153026	0	f	fd3500958da74eb280182de207c1c9f1
validation_pr_auc	0.2388162661497287	1784645182880	0	f	64b0900a1e964558863d196db339900c
validation_pr_auc	0.23785068442697385	1784645220456	0	f	dc2d72393aae497781f7a6cceff926d7
validation_pr_auc	0.23815070549345224	1784645247276	0	f	82bdb95fb73945928fc4add300efc29e
validation_pr_auc	0.2377509901727856	1784645264492	0	f	c04b03a1eb034e30ab0dbfd07f0a56bc
validation_pr_auc	0.2331216141087063	1784645293611	0	f	61939d5dc91f45f0b71ee70059923014
validation_pr_auc	0.238858240205721	1784645319576	0	f	e62dd40594234fe2b1e7032791dd20a8
validation_pr_auc	0.2391588228999696	1784645356751	0	f	fd9968abd7b9464aa499ac3910ae6d59
validation_pr_auc	0.23776050567197682	1784645371216	0	f	40baf7c768a8472dac8cadf8920e416c
validation_pr_auc	0.23313561601721605	1784645397412	0	f	4b6e2f4862564695a32ae677d3ebd136
validation_pr_auc	0.23157465753435597	1784645427019	0	f	82eba4c14c7b4ac791e397f13b4544de
validation_pr_auc	0.23993667503883026	1784645464032	0	f	86e01e0667ec427599d0c10de411791f
validation_pr_auc	0.23777697052628807	1784645502408	0	f	982fe4200d6b4f95a5e5e436b1885c0b
validation_pr_auc	0.23911104868613867	1784645529602	0	f	ea474e0674fd492c81f549be6c166cd2
validation_pr_auc	0.23903469577488107	1784645564561	0	f	6e7d042ef55247409d9390031ff02a47
validation_pr_auc	0.2386095166147394	1784645597278	0	f	caa44697e4d24e98b6d5f91363319ce0
validation_pr_auc	0.23671517331672356	1784645811304	0	f	8dd5e097c3e7404b8bb68ce4d54c81da
validation_pr_auc	0.235098975115705	1784646313628	0	f	aaa258948ae9488bb474a158d63f9148
validation_pr_auc	0.231909029430468	1784660102035	0	f	2cb17c9ab3fb42f6a309da1001231d6f
validation_pr_auc	0.23155638050872876	1784660367436	0	f	175caae5af7f4140b4ecae075484bb7b
validation_pr_auc	0.235789873434683	1784660623951	0	f	464465db08d54ca3890683e7f08018cd
validation_pr_auc	0.239349148484477	1784660679390	0	f	dab10324d6874b25b032b2e41b538db5
validation_pr_auc	0.23793577105095753	1784660699733	0	f	0fa292059a01459388a9848f32021680
validation_pr_auc	0.23501185363415247	1784660717247	0	f	a88dec410f58417cb1ad18c7cb2485f3
validation_pr_auc	0.23713938132545442	1784660773974	0	f	52254688abc64f459641607d3a8dfb6a
validation_pr_auc	0.22834693926158314	1784660790182	0	f	7d976b24c40b49f396e96bc3fb05fd94
validation_pr_auc	0.23594506869876225	1784660870076	0	f	350e32e8aae5456fb766e828852e52f8
validation_pr_auc	0.23238742456835354	1784660999095	0	f	993859e43a124bfbba2b2ebb47441c36
validation_pr_auc	0.23729492192650276	1784661037635	0	f	2715b04b5bad4a7ca933580943a2814a
validation_pr_auc	0.23800433888631997	1784661125596	0	f	d8b6ad6854ce4c91948c621ba3b09130
validation_pr_auc	0.2388476760584822	1784645638765	0	f	09141ce7bff34a53b91aedc1c71e0d1c
validation_pr_auc	0.23559105814831088	1784645695254	0	f	20e40ce2d6c44003bb759ab6e1351170
validation_pr_auc	0.23910474705512583	1784645721582	0	f	079ff97d445546cbb52ed19b2d617517
validation_pr_auc	0.23086221994060718	1784646074268	0	f	aea8d7c689ae4b289a07ea312f8cd967
validation_pr_auc	0.22360388476990084	1784660148641	0	f	343a984aca99424a9ea4fde70eae7fd6
validation_pr_auc	0.2360950853896569	1784660197904	0	f	fe50acdbb80f44b3b833e6da5d8494d5
validation_pr_auc	0.23852643953523908	1784660343189	0	f	3d117da059cf48f1b0389bf9323ce232
validation_pr_auc	0.21515202555543603	1784660403416	0	f	37b22dee0c674dc0ae4c25e6ee9d21d1
validation_pr_auc	0.23923668080022936	1784660521354	0	f	db19dbd296a547468d99e1eac5c48d91
validation_pr_auc	0.23567331425801397	1784660732258	0	f	57a6a6513f3d4a139635fb009beabe0e
validation_pr_auc	0.23605984255526585	1784645665743	0	f	c1dbce29b41c445ba8138ce9811b0068
validation_pr_auc	0.23685084904341405	1784645764441	0	f	a8008dd2ea1b43f196f1024d66cd3866
validation_pr_auc	0.23805717463817408	1784645874477	0	f	373663ce084a43b8bfb50018919a65db
validation_pr_auc	0.23858925850806456	1784645910414	0	f	bf5751b68e994a81998944e44b1b573d
validation_pr_auc	0.23613759574240165	1784645976938	0	f	5e4c9e7de52d47a391919bb68173e02c
validation_pr_auc	0.23441641784614928	1784646042768	0	f	729adea5b08d4ad4a4653e52efbafee9
validation_pr_auc	0.2400853141708851	1784646114551	0	f	c3c64461db474abfb41a7918f0836f40
validation_pr_auc	0.23924327818146796	1784646153836	0	f	52134bc6efa44da38234f805e719543d
validation_pr_auc	0.2377978060066758	1784646260142	0	f	b93a661f89624444924de260e56e2235
best_validation_pr_auc	0.24075366127945053	1784646313796	0	f	5cfc620daab64d35912dd7df3c7d139d
validation_pr_auc	0.1915614071255696	1784660238765	0	f	639bd817783446149d47dfcd0926f1a0
validation_pr_auc	0.2208847515480547	1784660427870	0	f	5b7ac14d710141e0ae9db4df5d76863d
validation_pr_auc	0.234734821701286	1784660444049	0	f	e5c01080e79f4145ae6c1fbbeb6dab7f
validation_pr_auc	0.23963371297336064	1784660572546	0	f	920842c57a5a49bb87e14ce762de0e6f
validation_pr_auc	0.23754266423783924	1784660664112	0	f	7da83a5b702d4cd9a3b6288e6ec4a963
validation_pr_auc	0.23787353044120613	1784660834741	0	f	c30e3c7d28f94109946cce7fcb30cba5
validation_pr_auc	0.23332056095528977	1784660855896	0	f	1bb7906f11194fa6b7498584acfcaac0
validation_pr_auc	0.23843244928623855	1784660893832	0	f	5aa083ca632a4a3ba6f7762d0c339e85
validation_pr_auc	0.23653853344677897	1784660947091	0	f	2bc4f68109344e3d8099ec77369d61d3
validation_pr_auc	0.22809517834187143	1784645791289	0	f	ed12fbe584314822bdbf2b28e61fd9f4
validation_pr_auc	0.23873454846810055	1784645830299	0	f	5dfe43d07bae4c3e8be8f52e18ee4e21
validation_pr_auc	0.2374819436621965	1784645937051	0	f	8c20356faa924d4fb9eba650a0792cc3
validation_pr_auc	0.23867731075524828	1784646022374	0	f	81cc585288d144dbaed1346c79c254ca
validation_pr_auc	0.23920657006601564	1784646192716	0	f	7263fee2dbbf4c2c8d21f11ee7cfb4d5
validation_pr_auc	0.2393871152185108	1784646222068	0	f	858e7d66bbc44d07b4318652fe66bf8a
validation_pr_auc	0.23696382933362364	1784660284548	0	f	2dd58258a1c14b7e9fbbcf0a30084f7d
validation_pr_auc	0.23454498937205534	1784660649499	0	f	2719cadee66a4cddb04bd6047c0bdea1
validation_pr_auc	0.23680199126573914	1784660907869	0	f	dfdba455d2f94583a9a6c822f573f830
validation_pr_auc	0.23648871840639246	1784646289351	0	f	b3a13dff7789467091ec52640e9adc99
validation_pr_auc	0.2399119857691648	1784660297830	0	f	b6ad1bd3b5e24e56a38c6e514a836fbb
validation_pr_auc	0.2313938140796325	1784660545182	0	f	5ca501b4ad684b6d8ca4c0d74bc38d7d
validation_pr_auc	0.23755815284683268	1784660604612	0	f	12c0eb897e9e4e799fa7e402ede53e68
validation_pr_auc	0.23253253169378327	1784660747684	0	f	bdb2446748cb45d9b995eaf2595da298
validation_pr_auc	0.23850872572233073	1784661071975	0	f	b7b0e8f2158c4888aa058c14df7a1439
validation_pr_auc	0.2175435832471577	1784661142649	0	f	621e30a66f4f4f2c9e8e5d2e3d26b6f9
validation_pr_auc	0.23828999458564412	1784661157066	0	f	b49827a8551c45039120e727c2742f3c
validation_pr_auc	0.23811198033537032	1784661185419	0	f	95bce22e5e554d8298e264b28c9e8fc5
validation_pr_auc	0.23101346784990906	1784661255114	0	f	bc449f79816a40b389ab2d1898b1b8f4
validation_pr_auc	0.23799950703732992	1784661324499	0	f	0b2d11961fe2427d959a976e2033ca2e
validation_pr_auc	0.23928956083733122	1784661365017	0	f	000523ae15fd47739ed9fccc383746ef
validation_pr_auc	0.2374579979427166	1784661413595	0	f	308716eedad140d8b8c2c920a5203a28
validation_pr_auc	0.23953483777970533	1784661453608	0	f	b4b583974c19441a99bf1809f32d97ac
validation_pr_auc	0.23618076480190248	1784661488229	0	f	d720a01642da4ff5b01c61771cdf9d91
validation_pr_auc	0.2365287064495622	1784661516913	0	f	9c030b074f6740f7b9f76b2dddeffb8c
validation_pr_auc	0.2396755363718379	1784661564205	0	f	4fe6b8e9bbef4cb49dd0b503775f095e
validation_pr_auc	0.23794729660618208	1784661612242	0	f	c9bd89e9733b418e8a4c762cccf8aa2d
validation_pr_auc	0.23585511581303928	1784661643252	0	f	61bef132335149da8fc1bcd646945380
validation_pr_auc	0.23824838982171367	1784661671839	0	f	8c036e2f01ae4dce9b24165f8105ca06
validation_pr_auc	0.23689189328415983	1784661688387	0	f	532603551a954e97bc6f82485f631d2e
validation_pr_auc	0.23824726736183582	1784661727753	0	f	a4fe1e00ac0e4e67b019e182ca42dfa5
validation_pr_auc	0.2382020587972399	1784661761728	0	f	2b432c32784143a9b9d3be8670c9b2de
validation_pr_auc	0.23913887251415988	1784661798996	0	f	91efa9c98d164aedac595d534867cfa9
validation_pr_auc	0.23872596781373606	1784661850519	0	f	7cabb843d24d4b86a34757eaf1696d59
validation_pr_auc	0.23657920935896445	1784661867399	0	f	cbe54d84d2f84e4b982ad2d27427c7a7
validation_pr_auc	0.23499723994602942	1784661917811	0	f	97fb30d77c874bbe909e9b34ff9ab219
validation_pr_auc	0.2404309851910955	1784661949096	0	f	23cfec62bb2b4c81b834e33e1d64015a
validation_pr_auc	0.23759212950037023	1784661984262	0	f	4ad932f7dcda4517b7b5cc0c8beac404
validation_pr_auc	0.2402926545510029	1784662029256	0	f	a83392e9cd7a4265b05f9abeced43638
validation_pr_auc	0.2387830021456303	1784662058319	0	f	5271cb97dc8e4421816e4fbc4e06b329
validation_pr_auc	0.23843773322699277	1784662117862	0	f	193b290a18504fa8a42991b624278dbf
validation_pr_auc	0.23717508584599145	1784662169850	0	f	384089aee8ff469e884eb523460d2e23
validation_pr_auc	0.23385833795146863	1784662245209	0	f	9ee14964976f41c9a0d4773391dc1b89
validation_pr_auc	0.23983360169081472	1784662277663	0	f	bbf38d0761d14a96a7f6af68d83b297c
validation_pr_auc	0.23840539451346338	1784662307539	0	f	e465ea368468417f95c02d9736ea13d2
validation_pr_auc	0.23987497686307196	1784662344865	0	f	7f39848a745a4f55b4b6f53656bbea09
validation_pr_auc	0.237918841066137	1784662373644	0	f	99f8a6c1a99042518e4a0ef2de67cbd0
validation_pr_auc	0.2404352653220775	1784662405142	0	f	82ae9253c99347c28805e14bb275d4e1
validation_pr_auc	0.23581505385945814	1784662448587	0	f	ea05524904e94189b607f30d35114cf5
validation_pr_auc	0.2361306041886094	1784662477862	0	f	59630d004d38484f8b30f453b17fd561
validation_pr_auc	0.24018325845146854	1784662508150	0	f	143106f491a142fa98764b4036346fc5
validation_pr_auc	0.2393519786006988	1784662543402	0	f	212e3cc9c33a469097370a89878e6e0d
validation_pr_auc	0.23635057328017015	1784662590312	0	f	5098e5701fc04d33a5d78ff3e0c2d8f2
validation_pr_auc	0.2394865183124187	1784662626185	0	f	0b4fd1f6f7d84dfe891162a68110faa4
validation_pr_auc	0.23948550133550517	1784662659930	0	f	c8478da13b1d44e09ff6954fe7f8ceb5
validation_pr_auc	0.23930450076340984	1784662702803	0	f	2593c87053c24c5ab46a701293e5da1c
validation_pr_auc	0.24108764271456687	1784662721041	0	f	0a433fa3378a4b90b664cc4fde90ed21
validation_pr_auc	0.22794698235069122	1784662740242	0	f	5731165fd9d341c093634c24885b4b80
validation_pr_auc	0.23985411420584654	1784662772827	0	f	6fd1e2f0387c42e6bc1b573547aa39c7
validation_pr_auc	0.2369201642905565	1784662788977	0	f	8c6c444e121e4c82ad5345c29fcd297d
validation_pr_auc	0.2392874273950558	1784662821696	0	f	14f0de2bdc004a6ca97d19b2d9dad96b
validation_pr_auc	0.23985283318217474	1784662846665	0	f	7f16b61fe03848238ff296583f7d49f5
validation_pr_auc	0.23646414471733	1784662877008	0	f	531d154bc65c4e3c9e3e691c91d4e598
validation_pr_auc	0.23758423006338403	1784662941888	0	f	7166345b17ac40e3a6384bc3e57a4e38
validation_pr_auc	0.23931701158957155	1784662970788	0	f	e04590dc86674c0985b160f47a15d939
validation_pr_auc	0.23799043061795616	1784663006365	0	f	08a4d70131f54e81bd0d47a5448e3d43
validation_pr_auc	0.23724390889896324	1784663019384	0	f	3a54e130da3a488e9cddd8f564b50636
validation_pr_auc	0.22779885717927664	1784663038139	0	f	196f279c8b2a47a3ae0b5e4069634bfe
validation_pr_auc	0.2364999196120953	1784663051245	0	f	7305560d783f4197a5a7e63dcb91495c
validation_pr_auc	0.23918269617673885	1784663063694	0	f	af4fa3186c554df8bd52d00efdd3b518
validation_pr_auc	0.23904553873756432	1784663095120	0	f	0e6ba24868c9455f9324ff11fa6f37c0
validation_pr_auc	0.2411067234824961	1784663125601	0	f	e6f37d31a9df48adbf7ce400630985f2
validation_pr_auc	0.23891591583211336	1784663139873	0	f	5219ab1ee77e4d0a9b2ea76665637741
validation_pr_auc	0.2371636930317649	1784663168232	0	f	b7a96024f405468da0046f142f3fba28
validation_pr_auc	0.23717406384302947	1784663198323	0	f	cc82112ae9004ab48a54576c09abb51e
validation_pr_auc	0.23119092732172714	1784663224732	0	f	df12860a7b4a46e9abaef76ff774590e
validation_pr_auc	0.23886098128050712	1784663264720	0	f	a45d4a14e3cb4767b85a0dd503888266
validation_pr_auc	0.23527647209142072	1784663288421	0	f	91fb3e7556b448e794bc7f57497b4ac4
validation_pr_auc	0.23499614892135795	1784663312283	0	f	28adcc19e5354574966fd00385b49f1a
validation_pr_auc	0.23876818214457274	1784663346568	0	f	fd79d84e5b9a463e8c5d9ad2eebe966f
validation_pr_auc	0.23860580769722406	1784663494566	0	f	cca09d0a7a824be1b885d47ad28e10a4
validation_pr_auc	0.23977643247751726	1784663578576	0	f	de0278a9f23d4eea946bc673a797c3c2
validation_pr_auc	0.23954266657231044	1784663386735	0	f	bd4a6462eb314b5cb3c57f9db508a4e4
validation_pr_auc	0.24028517480514375	1784663698771	0	f	117e0e60760d44ac9ef154cceb212171
validation_pr_auc	0.23711452859714285	1784663413896	0	f	3405dcc6ebdd44609d0d260aa28f3122
validation_pr_auc	0.23937418964497173	1784663617185	0	f	130f444dde0c42df9f6abc1bd79d9b77
validation_pr_auc	0.2058622177352676	1784663457499	0	f	ee5e81cfc9ad4fda8222a171057e4ffc
validation_pr_auc	0.23828710684417304	1784663669055	0	f	2ad9ddee054f4a0fa0c5e251a177dd6a
validation_pr_auc	0.23958061603548161	1784663536040	0	f	c599cc0f5ca645e989b7478887d03f28
validation_pr_auc	0.237830518773729	1784663640458	0	f	e3ca2557a9f543f7952783569ae86534
validation_pr_auc	0.23755091949322077	1784663725341	0	f	62ca7fadf67347b29ca9598d327eebd2
validation_pr_auc	0.23869291080670169	1784663768318	0	f	ba4d5a30aa02426d9e1536625f3ebe6a
validation_pr_auc	0.23770157934473604	1784663781491	0	f	98d0deba9dd641d281274cbf802081fb
validation_pr_auc	0.21813045459444436	1784663798110	0	f	cd47568195194bd4b3b7f694f1a08f9a
validation_pr_auc	0.23968560306027464	1784663818953	0	f	30bde976c0b84a36b835f3d18848103c
validation_pr_auc	0.23417770518508363	1784663852618	0	f	200e44c932ce4dad8671cd5da9b409d9
validation_pr_auc	0.23935771317809265	1784663885216	0	f	8d81437cc3714f6982ae885c3c81bacf
validation_pr_auc	0.23955856183273483	1784663918975	0	f	3e09014e17a84af3b1624fa0068fa0a7
validation_pr_auc	0.2389233261835132	1784663934051	0	f	b4689faec3f7445fbe0ba427b0859231
validation_pr_auc	0.2270072882396025	1784663979104	0	f	aa9da8551d8a425785523304e9c547f3
validation_pr_auc	0.2390095926969984	1784664012632	0	f	f9ede5de86ea4f9b8ac1a181ddd36d72
validation_pr_auc	0.23952717908417398	1784664057456	0	f	569e3af54f5549d389c2817c8ccf9823
validation_pr_auc	0.2397392585261173	1784664092634	0	f	f0d12270c17441cb82afdc0ff9f70809
validation_pr_auc	0.2403590641639288	1784664139342	0	f	52e3ecc8bd264c6bb75dd7e13c9c3713
validation_pr_auc	0.23481804424567984	1784664177344	0	f	2e7a3710bd5e4ee2ad9d870e16e43be0
validation_pr_auc	0.23772940580821655	1784664236753	0	f	d3f4b439155d4a1f8452de974a8fd530
validation_pr_auc	0.2288557735994681	1784664292654	0	f	2d0fdb5b0ebe4654b38066951cec3ae8
validation_pr_auc	0.23838165306658973	1784664336387	0	f	d6ab3fd3b7be407a86383f867d0d3987
validation_pr_auc	0.23716800792342335	1784664372581	0	f	571b8fa9bdad427a9816b5b5144622ef
validation_pr_auc	0.23849787266881473	1784664396720	0	f	11b06d8ded174450aaa0563cd01e2137
validation_pr_auc	0.23991826914000172	1784664428854	0	f	fea20651e3e744068c1d02e03e73f652
validation_pr_auc	0.2387662132377705	1784664466809	0	f	35ea2431d44b4d5197234e1257f742e7
validation_pr_auc	0.23904594225695305	1784664486011	0	f	19c7ae8c940042a9bea5484d5c7a996f
validation_pr_auc	0.2398773740063644	1784664521956	0	f	c2a98b6d06ba4b14ac81cdaaacee8d9b
validation_pr_auc	0.23920689197632994	1784664548281	0	f	87f145f9b3b4496f901df95d56e470b8
validation_pr_auc	0.23878234308300386	1784664602071	0	f	c23e0bcb7b334d3aae37f42aa4aaa09d
validation_pr_auc	0.23788897478537532	1784664691358	0	f	f4eb85ac7f484c7b9665388a9a0d3e8f
validation_pr_auc	0.22938362753881394	1784664735108	0	f	e9f2cf11fabd4422a3404f41f7e12593
validation_pr_auc	0.23897452171566785	1784664783971	0	f	faefe080fefc45eabc2137abcdf3ef0c
validation_pr_auc	0.2399403272145806	1784664812427	0	f	96479ef023f34b15a8033d9c5657d9dc
validation_pr_auc	0.23542095340310615	1784664844580	0	f	3e93389d94ca40148d153412a6cddbcb
validation_pr_auc	0.23823112517820766	1784664881339	0	f	eb16c82079fd4ba591d99f8201df04d1
validation_pr_auc	0.2391816591662354	1784664919134	0	f	a643f1f3cf3147aaa764aafd4114e6ff
validation_pr_auc	0.23756687468343876	1784664941501	0	f	e4ff17e0741440b49a2e374cba8fc594
validation_pr_auc	0.23919607623095504	1784664963170	0	f	1918bf94daa7417a9f9a9bbe2f473d24
validation_pr_auc	0.22684420046601392	1784664997609	0	f	6975e9f2410b4b48a24bb54de3773f71
validation_pr_auc	0.2371633090352755	1784665017481	0	f	c7ca2abd948b4f7a8f5ef910fcb0e754
validation_pr_auc	0.23714535261904882	1784665031149	0	f	7c916e1a7e7d4b44be04309d6b501d6f
validation_pr_auc	0.24005564996478096	1784665066330	0	f	ce2b0e6b82744bb9ab441eb5516e4bb9
validation_pr_auc	0.2377973116721291	1784665118428	0	f	bec59faddbfa49baa60c2a3653cd5dbd
best_validation_pr_auc	0.2411067234824961	1784665118624	0	f	cceff74de09a44f48ae9e027c5f35536
precision	0.23423799582463464	1784668335541	0	f	033ebefb766e4bfa8282ab39cec5c865
recall	0.45196374622356494	1784668335541	0	f	033ebefb766e4bfa8282ab39cec5c865
f1_score	0.3085596424888278	1784668335541	0	f	033ebefb766e4bfa8282ab39cec5c865
pr_auc	0.24880570334998775	1784668335541	0	f	033ebefb766e4bfa8282ab39cec5c865
roc_auc	0.7595517912593219	1784668335541	0	f	033ebefb766e4bfa8282ab39cec5c865
ks	0.38352147511622003	1784668335541	0	f	033ebefb766e4bfa8282ab39cec5c865
threshold	0.64	1784668335541	0	f	033ebefb766e4bfa8282ab39cec5c865
training_precision_score	0.9162393533441483	1784670139082	0	f	be0003b4c09f45a384716a36faaa3fde
training_recall_score	0.741517026919911	1784670139082	0	f	be0003b4c09f45a384716a36faaa3fde
training_f1_score	0.7988895602736004	1784670139082	0	f	be0003b4c09f45a384716a36faaa3fde
training_accuracy_score	0.741517026919911	1784670139082	0	f	be0003b4c09f45a384716a36faaa3fde
training_log_loss	0.517355146468789	1784670139082	0	f	be0003b4c09f45a384716a36faaa3fde
training_roc_auc	0.8558960141646185	1784670139082	0	f	be0003b4c09f45a384716a36faaa3fde
training_score	0.741517026919911	1784670159077	0	f	be0003b4c09f45a384716a36faaa3fde
precision	0.23423799582463464	1784670167656	0	f	be0003b4c09f45a384716a36faaa3fde
recall	0.45196374622356494	1784670167656	0	f	be0003b4c09f45a384716a36faaa3fde
f1_score	0.3085596424888278	1784670167656	0	f	be0003b4c09f45a384716a36faaa3fde
pr_auc	0.24880570334998775	1784670167656	0	f	be0003b4c09f45a384716a36faaa3fde
roc_auc	0.7595517912593219	1784670167656	0	f	be0003b4c09f45a384716a36faaa3fde
ks	0.38352147511622003	1784670167656	0	f	be0003b4c09f45a384716a36faaa3fde
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
precision_mean	0.1928	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
precision_std	0.0007	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
recall_mean	0.5374	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
recall_std	0.0075	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
f1_mean	0.2838	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
f1_std	0.0017	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
roc_auc_mean	0.7435	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
roc_auc_std	0.0014	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
pr_auc_mean	0.2219	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
pr_auc_std	0.0007	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
ks_mean	0.3645	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
ks_std	0.0051	1784572665084	1c1474a4dc0a42e595b137a2ff7eb3cd	0	f
precision_mean	0.1792	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
precision_std	0.0016	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
recall_mean	0.6239	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
recall_std	0.0088	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
f1_mean	0.2784	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
f1_std	0.0026	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
roc_auc_mean	0.7536	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
roc_auc_std	0.0017	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
pr_auc_mean	0.2397	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
pr_auc_std	0.0043	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
ks_mean	0.3818	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
ks_std	0.0057	1784572691528	87bee9e02af04727a439076b5099ea26	0	f
precision_mean	0.1906	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
precision_std	0.0012	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
recall_mean	0.5676	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
recall_std	0.0084	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
f1_mean	0.2854	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
f1_std	0.0019	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
roc_auc_mean	0.7486	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
roc_auc_std	0.0025	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
pr_auc_mean	0.2344	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
pr_auc_std	0.0028	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
ks_mean	0.3721	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
ks_std	0.0062	1784572720546	a0d9d4037d9a483e8ff2887e8c35e79a	0	f
precision	0.18946943172636682	1784639991894	7ad743cafe754961865d8d9048d97887	0	f
recall	0.5667673716012085	1784639991894	7ad743cafe754961865d8d9048d97887	0	f
f1_score	0.2839985870717061	1784639991894	7ad743cafe754961865d8d9048d97887	0	f
roc_auc	0.7469787896220874	1784639991894	7ad743cafe754961865d8d9048d97887	0	f
pr_auc	0.22682644224808374	1784639991894	7ad743cafe754961865d8d9048d97887	0	f
ks	0.36509963247989025	1784639991894	7ad743cafe754961865d8d9048d97887	0	f
precision	0.17640308213563582	1784640008093	9899a48432a34cb39a199dcf5ae28c28	0	f
recall	0.6501510574018127	1784640008093	9899a48432a34cb39a199dcf5ae28c28	0	f
f1_score	0.27751031636863827	1784640008093	9899a48432a34cb39a199dcf5ae28c28	0	f
roc_auc	0.7602718944173115	1784640008093	9899a48432a34cb39a199dcf5ae28c28	0	f
pr_auc	0.2510765996522225	1784640008093	9899a48432a34cb39a199dcf5ae28c28	0	f
ks	0.38622369747523766	1784640008093	9899a48432a34cb39a199dcf5ae28c28	0	f
precision	0.185683025945608	1784640024257	f8b1be9aa8b34c36a0d398fea269c222	0	f
recall	0.5981873111782477	1784640024257	f8b1be9aa8b34c36a0d398fea269c222	0	f
f1_score	0.2833969465648855	1784640024257	f8b1be9aa8b34c36a0d398fea269c222	0	f
roc_auc	0.755851103110717	1784640024257	f8b1be9aa8b34c36a0d398fea269c222	0	f
pr_auc	0.24566666725077968	1784640024257	f8b1be9aa8b34c36a0d398fea269c222	0	f
ks	0.38159838812256747	1784640024257	f8b1be9aa8b34c36a0d398fea269c222	0	f
validation_pr_auc	0.22847684463910747	1784641519037	b065943b869c45d1ab9a544997cbd2e3	0	f
validation_pr_auc	0.23673910272767093	1784641555462	876e004fc22941a5bd0abf6035008d6e	0	f
validation_pr_auc	0.2384851347533118	1784641572021	77d0e55214db4ecd857415d3af80c800	0	f
validation_pr_auc	0.23858607120652361	1784641603660	8af2154e65c646ba85f95ef956f429e3	0	f
validation_pr_auc	0.23613197746454997	1784641635034	546361b43206462abda8503c0473c830	0	f
validation_pr_auc	0.2041055703053928	1784641663972	863d9eddfa374352ac9ef04f414aed07	0	f
validation_pr_auc	0.23838542170727814	1784641684244	761f6f2a81274b38bf29c785c17b9f5c	0	f
validation_pr_auc	0.23580317605346182	1784641699980	014e8bb3efda4a7f9e544ad0c54eda97	0	f
validation_pr_auc	0.23554122697991406	1784641719336	889b7c5d83704dd2ac3f3508dcb6bbeb	0	f
validation_pr_auc	0.2379827604380464	1784641766154	ae175d867d8d4942b3953e031f48deea	0	f
validation_pr_auc	0.23951316720116397	1784641788237	c570005822f1468ebc56e3a2e5f3a7be	0	f
validation_pr_auc	0.23890335176619626	1784641825233	6198d6b56d9e4ff5afeca1168f4226b8	0	f
validation_pr_auc	0.23614247754587858	1784641873239	905dc0ac6a9b46bfa4b2435798fa6880	0	f
validation_pr_auc	0.23478565204395876	1784641916689	3c993ea82ef44d1f91ec5ae384b63d04	0	f
validation_pr_auc	0.23329095050690005	1784641980822	5f4890e2fdc040bfba29e6fba7cf13de	0	f
validation_pr_auc	0.23889832181700338	1784642051275	31c19df3feba406bbe273cf28ad356ea	0	f
validation_pr_auc	0.23667609196380138	1784642096843	06988d80ee2a49cc847b86b0ba828472	0	f
validation_pr_auc	0.23102322180299026	1784642128731	884482f15ecf455cacf6203986941bd8	0	f
validation_pr_auc	0.2386994679787821	1784642448609	ed6d527941fe49ec9efa86d9ecec40b9	0	f
validation_pr_auc	0.2394939852743986	1784643222098	b58e93020e20438db09d29ad3c13df59	0	f
validation_pr_auc	0.23776487732917548	1784642165917	1336414e54eb49e886f22580bd301b28	0	f
validation_pr_auc	0.23884570145784734	1784642198823	b3547d0973f74bf49d4e595aacdb1e3b	0	f
validation_pr_auc	0.23339096226929382	1784642245798	11cd7d2db6784fe4b02a7ae8f71d8cf2	0	f
validation_pr_auc	0.23536910495163546	1784642412599	a96bb954fdd64eed9d3bb56c6d5ea887	0	f
validation_pr_auc	0.23852488273745287	1784642482497	9bee251d163640f4b41fe3bb301ce520	0	f
validation_pr_auc	0.23961769328806004	1784642612550	3ed8585907ef4caa8fe4d70cb6b0cc87	0	f
validation_pr_auc	0.23747700544092193	1784642796415	bb2f576d862c4a68b3b67f55ee6e56e3	0	f
validation_pr_auc	0.23278599478541076	1784643161755	979923580d5349d5968ee3fbca0c330a	0	f
validation_pr_auc	0.23866596482091815	1784643261466	70213c72967b441a8ecd0ad831f5b776	0	f
validation_pr_auc	0.2283517678688885	1784643481683	0f8c5f9035b34684adc09c8445ef8cea	0	f
validation_pr_auc	0.23834803080081776	1784642348840	58b4b9d2beff44d3b6bce2af1c53b954	0	f
validation_pr_auc	0.23915791322056684	1784642761801	4ed8356cc0124c2687e88834f4d5b105	0	f
validation_pr_auc	0.23866442210324595	1784643048848	6558904b55d747dcbb1151b72104deda	0	f
validation_pr_auc	0.2387430926112426	1784643089208	23f4f5b6b75745cbbfb0974a54367678	0	f
validation_pr_auc	0.2351100581492431	1784643190090	bc0ab96304f34a6c848f80daf1fb9a6e	0	f
validation_pr_auc	0.23777746150047085	1784643293525	7eea4fc7e3a546589babe6a0b7310882	0	f
validation_pr_auc	0.23742885554570173	1784643318803	518de6201cd84159962c329678dae7c7	0	f
validation_pr_auc	0.23789070635819176	1784643434174	16766e90a32c4f369ecd9e9b701ab356	0	f
validation_pr_auc	0.23267544480965693	1784642508328	c5d632c0f5584ef38bba13efd4e41e85	0	f
validation_pr_auc	0.2355425344300796	1784642580371	19cbd69551b74540ae49e5172dcbd422	0	f
validation_pr_auc	0.23703004948504325	1784642901455	c15aab38a0b749289678168eed8a375f	0	f
validation_pr_auc	0.23481808389187075	1784643455357	2918b242568447af9cdc39919fb7482a	0	f
validation_pr_auc	0.22686677995992874	1784642526876	d54ca38b32404c3ab9603d5c17d370be	0	f
validation_pr_auc	0.2400271007485743	1784642639468	e29e156922854739b295baa6f96964b9	0	f
validation_pr_auc	0.23831596994324025	1784642867543	5094306f911645f7960433fa475f3906	0	f
validation_pr_auc	0.23978826701065245	1784642959366	5c42167498f34202a2d02f90db37735d	0	f
validation_pr_auc	0.23884833089245702	1784643001480	b8c92046e4d64195892f204054da11ee	0	f
validation_pr_auc	0.23921063477794782	1784643344622	2ab6619860f04dd6806c00d08dd3c42d	0	f
validation_pr_auc	0.2354744790233689	1784642554034	74a92f84946a40ec9f5ef59d95735532	0	f
validation_pr_auc	0.2388521432104879	1784642670596	337c2ecc590441f4b0d4ed6e6c6d874b	0	f
validation_pr_auc	0.23344649764795122	1784642713593	4aca56d551a8462caff8f4910dc5c067	0	f
validation_pr_auc	0.23636428410341098	1784642819171	d4ffdfcc60964dc2a44d6526250c8242	0	f
validation_pr_auc	0.23621279182916544	1784643383705	cc29150802304136adce6bad79c64a02	0	f
validation_pr_auc	0.23847991081147066	1784642932911	a66a3b993e8c4892807fe3212c6626d1	0	f
validation_pr_auc	0.23752624988669915	1784642979469	802c5ed50bad4391bbb5c72644ab5629	0	f
validation_pr_auc	0.2386382379261528	1784643409561	e70dd208f60b4acc863c851496a7b8e1	0	f
validation_pr_auc	0.22887033290496642	1784643524174	10f0304d917b4d91a53520741a9f09f3	0	f
validation_pr_auc	0.23889086285921363	1784643561400	0862f531c85046b18a2ec61111e68861	0	f
validation_pr_auc	0.2365207251286767	1784643584346	718cc73f4d1b4db98abc0e7b10db5ed6	0	f
validation_pr_auc	0.23771819921120665	1784643600416	f3039f0f77a54e3a87583ce82d69fd41	0	f
validation_pr_auc	0.2392606581569918	1784643621555	5f60cb1e96ef4d32aba7cf2ba79d8aa2	0	f
validation_pr_auc	0.2384366470284109	1784643680676	a8986aaa09bb45edaf20a7a2a477b6f0	0	f
validation_pr_auc	0.23773057149051485	1784643710617	9aac8f92473d49cf903225b9a22ad98e	0	f
validation_pr_auc	0.23105046264547935	1784643740803	08f786cb8efb4f64b9a2607fd6ca5ee5	0	f
validation_pr_auc	0.2379290565120181	1784643782286	d1000f6e85de4fe2a8c95dc022bdab8f	0	f
validation_pr_auc	0.23720809307337418	1784643816797	deb70d2c6e9844ad8ec9a5549a069559	0	f
validation_pr_auc	0.23765597796270455	1784643843094	a8ef003494f048faa29d895d18d2d187	0	f
validation_pr_auc	0.23822738469831842	1784643863200	651dd8509db8453e9b57f0db626a0bc0	0	f
validation_pr_auc	0.24045021219057036	1784643882588	69b74a9c9f174a25b25bca9453b251dd	0	f
validation_pr_auc	0.23732912683715965	1784643900219	4a86e315bd1b42e4a441cf540b75416d	0	f
validation_pr_auc	0.23943472927823112	1784643918668	fb402d7ff6d741018d6a91ea10972f05	0	f
validation_pr_auc	0.23796586447544502	1784643943262	e094133c648a4dcf978411aa6d5934e7	0	f
validation_pr_auc	0.23801187252810552	1784643958044	7594e7f61c11418997699b81d6b68aac	0	f
validation_pr_auc	0.23932617239339504	1784643975953	8883ec417d31449b9c035b2913e2c586	0	f
validation_pr_auc	0.2264973966304575	1784643989232	fca3189b071b4c8aae99a36fec28a55a	0	f
validation_pr_auc	0.23772922092388876	1784644006530	7c8b46c7a5b748aa8f1d0b39f7af527e	0	f
validation_pr_auc	0.23225621888562065	1784644024984	3543bc1d263645d99771e0034c716e7b	0	f
validation_pr_auc	0.22236546909088686	1784644049752	c88117b6aafc456082337e849f1bf075	0	f
validation_pr_auc	0.2363161873472584	1784644068585	aa2f79a2f19d42db9cb8620483e02b5e	0	f
validation_pr_auc	0.23916579555158798	1784644097446	804bc8eb2efe4ead940fa0c158126ca0	0	f
validation_pr_auc	0.220999937856713	1784644130564	329d6d6fd07d4659b5300ae5ad320063	0	f
validation_pr_auc	0.21622049631541057	1784644159055	0260b00d3be4497b9ca6fbdcf0fb56f3	0	f
validation_pr_auc	0.22818219248907942	1784644186691	e8d9a9ae1a314ef4822cb690114b565a	0	f
validation_pr_auc	0.2355513338184599	1784644201775	c174b51cb9ef4197a069b455c2ae15f6	0	f
validation_pr_auc	0.23706332122359083	1784644219320	0561a4c2b698400f949c0e76eef5fbdc	0	f
validation_pr_auc	0.23817803240696447	1784644239926	581effbe4a2f4945aaadeb01b564b851	0	f
validation_pr_auc	0.23443351613560118	1784644287430	d90190edced44c048d8f32ec24d761bb	0	f
validation_pr_auc	0.239117736655064	1784644306074	3ac81d7485e549e392a19922b5afb56d	0	f
validation_pr_auc	0.2393617378394998	1784644326022	9310e0296fef46229d141a34118600f6	0	f
validation_pr_auc	0.23774683170004546	1784644346834	8dd0782b26a647b0924ccd9a97b01735	0	f
validation_pr_auc	0.24075366127945053	1784644372220	17cdd4ed361b4c6aa962d390cb1f5fc5	0	f
validation_pr_auc	0.2297408100236427	1784644407055	3401268c42cb4248abf5eb0c4fca768a	0	f
validation_pr_auc	0.2367795768301549	1784644424282	701e73d0f1184acd9682089de7c9c496	0	f
validation_pr_auc	0.23790540786174308	1784644445464	8e5b753561c44b3195234ef62f8f47b2	0	f
validation_pr_auc	0.23941220941854172	1784644488263	cf02466f55074fecb9cf4a06f6468695	0	f
validation_pr_auc	0.23870385316495416	1784644522096	cfd7a5c4650749a99227270f7490d366	0	f
validation_pr_auc	0.23638927897706427	1784644562904	8f70bc6c911d4d3daac5817bcbceb1c8	0	f
validation_pr_auc	0.2368251315953689	1784644603409	491c6531e590476ba6d0e4c3f8ee4002	0	f
validation_pr_auc	0.2394520311696961	1784644645887	111954c77263486eb7b19f050d26b75a	0	f
validation_pr_auc	0.2383637904416785	1784644684420	9c1ced865d204984869839b7cd4f6859	0	f
validation_pr_auc	0.2378735910467362	1784644718998	c2857623dd374caeb05d44680f352000	0	f
validation_pr_auc	0.234504753039241	1784644751781	a6e212b95bfc4605a1be9024004fb49f	0	f
validation_pr_auc	0.23910835068112493	1784644802517	3919fe95d06c45a48568942d0a5d55ac	0	f
validation_pr_auc	0.23914526041439016	1784644848586	9e05181cd24c4328ad2c35ebdb23abc7	0	f
validation_pr_auc	0.23927049703030925	1784644882235	99058e32615c47359503e260cbce6d91	0	f
validation_pr_auc	0.23566446898205218	1784644913538	6d7c5305df6349cebc54d4fa9a31214a	0	f
validation_pr_auc	0.23837139587623624	1784644937381	08b5f55856b74797a4e16456167adfd5	0	f
validation_pr_auc	0.23730179081428887	1784644968297	d936f59062f2489586c8c6aa48246a22	0	f
validation_pr_auc	0.23587435419413547	1784645006453	49388c150ccb4b929ee16b2bb07bb27f	0	f
validation_pr_auc	0.23981335948646296	1784645041091	27593188f9b74471b4e76392b99287d0	0	f
validation_pr_auc	0.2386440424187308	1784645079839	7d1d89bca5f64345807b2f8710248857	0	f
validation_pr_auc	0.24014290360593785	1784645114514	0f815fdf0e0645fcbc9bd75f41904b44	0	f
validation_pr_auc	0.23201299790453175	1784645153026	fd3500958da74eb280182de207c1c9f1	0	f
validation_pr_auc	0.2388162661497287	1784645182880	64b0900a1e964558863d196db339900c	0	f
validation_pr_auc	0.23785068442697385	1784645220456	dc2d72393aae497781f7a6cceff926d7	0	f
validation_pr_auc	0.23815070549345224	1784645247276	82bdb95fb73945928fc4add300efc29e	0	f
validation_pr_auc	0.2377509901727856	1784645264492	c04b03a1eb034e30ab0dbfd07f0a56bc	0	f
validation_pr_auc	0.2331216141087063	1784645293611	61939d5dc91f45f0b71ee70059923014	0	f
validation_pr_auc	0.238858240205721	1784645319576	e62dd40594234fe2b1e7032791dd20a8	0	f
validation_pr_auc	0.2391588228999696	1784645356751	fd9968abd7b9464aa499ac3910ae6d59	0	f
validation_pr_auc	0.23776050567197682	1784645371216	40baf7c768a8472dac8cadf8920e416c	0	f
validation_pr_auc	0.23313561601721605	1784645397412	4b6e2f4862564695a32ae677d3ebd136	0	f
validation_pr_auc	0.23157465753435597	1784645427019	82eba4c14c7b4ac791e397f13b4544de	0	f
validation_pr_auc	0.23993667503883026	1784645464032	86e01e0667ec427599d0c10de411791f	0	f
validation_pr_auc	0.23777697052628807	1784645502408	982fe4200d6b4f95a5e5e436b1885c0b	0	f
validation_pr_auc	0.23911104868613867	1784645529602	ea474e0674fd492c81f549be6c166cd2	0	f
validation_pr_auc	0.23903469577488107	1784645564561	6e7d042ef55247409d9390031ff02a47	0	f
validation_pr_auc	0.2386095166147394	1784645597278	caa44697e4d24e98b6d5f91363319ce0	0	f
validation_pr_auc	0.2388476760584822	1784645638765	09141ce7bff34a53b91aedc1c71e0d1c	0	f
validation_pr_auc	0.23605984255526585	1784645665743	c1dbce29b41c445ba8138ce9811b0068	0	f
validation_pr_auc	0.23559105814831088	1784645695254	20e40ce2d6c44003bb759ab6e1351170	0	f
validation_pr_auc	0.23910474705512583	1784645721582	079ff97d445546cbb52ed19b2d617517	0	f
validation_pr_auc	0.23685084904341405	1784645764441	a8008dd2ea1b43f196f1024d66cd3866	0	f
validation_pr_auc	0.22809517834187143	1784645791289	ed12fbe584314822bdbf2b28e61fd9f4	0	f
validation_pr_auc	0.23671517331672356	1784645811304	8dd5e097c3e7404b8bb68ce4d54c81da	0	f
validation_pr_auc	0.23873454846810055	1784645830299	5dfe43d07bae4c3e8be8f52e18ee4e21	0	f
validation_pr_auc	0.23805717463817408	1784645874477	373663ce084a43b8bfb50018919a65db	0	f
validation_pr_auc	0.23858925850806456	1784645910414	bf5751b68e994a81998944e44b1b573d	0	f
validation_pr_auc	0.2374819436621965	1784645937051	8c20356faa924d4fb9eba650a0792cc3	0	f
validation_pr_auc	0.23613759574240165	1784645976938	5e4c9e7de52d47a391919bb68173e02c	0	f
validation_pr_auc	0.23867731075524828	1784646022374	81cc585288d144dbaed1346c79c254ca	0	f
validation_pr_auc	0.23441641784614928	1784646042768	729adea5b08d4ad4a4653e52efbafee9	0	f
validation_pr_auc	0.23086221994060718	1784646074268	aea8d7c689ae4b289a07ea312f8cd967	0	f
validation_pr_auc	0.2400853141708851	1784646114551	c3c64461db474abfb41a7918f0836f40	0	f
validation_pr_auc	0.23924327818146796	1784646153836	52134bc6efa44da38234f805e719543d	0	f
validation_pr_auc	0.23920657006601564	1784646192716	7263fee2dbbf4c2c8d21f11ee7cfb4d5	0	f
validation_pr_auc	0.2393871152185108	1784646222068	858e7d66bbc44d07b4318652fe66bf8a	0	f
validation_pr_auc	0.2377978060066758	1784646260142	b93a661f89624444924de260e56e2235	0	f
validation_pr_auc	0.23648871840639246	1784646289351	b3a13dff7789467091ec52640e9adc99	0	f
validation_pr_auc	0.235098975115705	1784646313628	aaa258948ae9488bb474a158d63f9148	0	f
best_validation_pr_auc	0.24075366127945053	1784646313796	5cfc620daab64d35912dd7df3c7d139d	0	f
validation_pr_auc	0.231909029430468	1784660102035	2cb17c9ab3fb42f6a309da1001231d6f	0	f
validation_pr_auc	0.22360388476990084	1784660148641	343a984aca99424a9ea4fde70eae7fd6	0	f
validation_pr_auc	0.2360950853896569	1784660197904	fe50acdbb80f44b3b833e6da5d8494d5	0	f
validation_pr_auc	0.1915614071255696	1784660238765	639bd817783446149d47dfcd0926f1a0	0	f
validation_pr_auc	0.23696382933362364	1784660284548	2dd58258a1c14b7e9fbbcf0a30084f7d	0	f
validation_pr_auc	0.2399119857691648	1784660297830	b6ad1bd3b5e24e56a38c6e514a836fbb	0	f
validation_pr_auc	0.23852643953523908	1784660343189	3d117da059cf48f1b0389bf9323ce232	0	f
validation_pr_auc	0.23155638050872876	1784660367436	175caae5af7f4140b4ecae075484bb7b	0	f
validation_pr_auc	0.21515202555543603	1784660403416	37b22dee0c674dc0ae4c25e6ee9d21d1	0	f
validation_pr_auc	0.2208847515480547	1784660427870	5b7ac14d710141e0ae9db4df5d76863d	0	f
validation_pr_auc	0.234734821701286	1784660444049	e5c01080e79f4145ae6c1fbbeb6dab7f	0	f
validation_pr_auc	0.23923668080022936	1784660521354	db19dbd296a547468d99e1eac5c48d91	0	f
validation_pr_auc	0.2313938140796325	1784660545182	5ca501b4ad684b6d8ca4c0d74bc38d7d	0	f
validation_pr_auc	0.23963371297336064	1784660572546	920842c57a5a49bb87e14ce762de0e6f	0	f
validation_pr_auc	0.23755815284683268	1784660604612	12c0eb897e9e4e799fa7e402ede53e68	0	f
validation_pr_auc	0.235789873434683	1784660623951	464465db08d54ca3890683e7f08018cd	0	f
validation_pr_auc	0.23454498937205534	1784660649499	2719cadee66a4cddb04bd6047c0bdea1	0	f
validation_pr_auc	0.23754266423783924	1784660664112	7da83a5b702d4cd9a3b6288e6ec4a963	0	f
validation_pr_auc	0.239349148484477	1784660679390	dab10324d6874b25b032b2e41b538db5	0	f
validation_pr_auc	0.23793577105095753	1784660699733	0fa292059a01459388a9848f32021680	0	f
validation_pr_auc	0.23501185363415247	1784660717247	a88dec410f58417cb1ad18c7cb2485f3	0	f
validation_pr_auc	0.23567331425801397	1784660732258	57a6a6513f3d4a139635fb009beabe0e	0	f
validation_pr_auc	0.23253253169378327	1784660747684	bdb2446748cb45d9b995eaf2595da298	0	f
validation_pr_auc	0.23713938132545442	1784660773974	52254688abc64f459641607d3a8dfb6a	0	f
validation_pr_auc	0.22834693926158314	1784660790182	7d976b24c40b49f396e96bc3fb05fd94	0	f
validation_pr_auc	0.23787353044120613	1784660834741	c30e3c7d28f94109946cce7fcb30cba5	0	f
validation_pr_auc	0.23332056095528977	1784660855896	1bb7906f11194fa6b7498584acfcaac0	0	f
validation_pr_auc	0.23594506869876225	1784660870076	350e32e8aae5456fb766e828852e52f8	0	f
validation_pr_auc	0.23843244928623855	1784660893832	5aa083ca632a4a3ba6f7762d0c339e85	0	f
validation_pr_auc	0.23680199126573914	1784660907869	dfdba455d2f94583a9a6c822f573f830	0	f
validation_pr_auc	0.23653853344677897	1784660947091	2bc4f68109344e3d8099ec77369d61d3	0	f
validation_pr_auc	0.23238742456835354	1784660999095	993859e43a124bfbba2b2ebb47441c36	0	f
validation_pr_auc	0.23729492192650276	1784661037635	2715b04b5bad4a7ca933580943a2814a	0	f
validation_pr_auc	0.23800433888631997	1784661125596	d8b6ad6854ce4c91948c621ba3b09130	0	f
validation_pr_auc	0.23850872572233073	1784661071975	b7b0e8f2158c4888aa058c14df7a1439	0	f
validation_pr_auc	0.2175435832471577	1784661142649	621e30a66f4f4f2c9e8e5d2e3d26b6f9	0	f
validation_pr_auc	0.23828999458564412	1784661157066	b49827a8551c45039120e727c2742f3c	0	f
validation_pr_auc	0.23811198033537032	1784661185419	95bce22e5e554d8298e264b28c9e8fc5	0	f
validation_pr_auc	0.23101346784990906	1784661255114	bc449f79816a40b389ab2d1898b1b8f4	0	f
validation_pr_auc	0.23799950703732992	1784661324499	0b2d11961fe2427d959a976e2033ca2e	0	f
validation_pr_auc	0.23928956083733122	1784661365017	000523ae15fd47739ed9fccc383746ef	0	f
validation_pr_auc	0.2374579979427166	1784661413595	308716eedad140d8b8c2c920a5203a28	0	f
validation_pr_auc	0.23953483777970533	1784661453608	b4b583974c19441a99bf1809f32d97ac	0	f
validation_pr_auc	0.23618076480190248	1784661488229	d720a01642da4ff5b01c61771cdf9d91	0	f
validation_pr_auc	0.2365287064495622	1784661516913	9c030b074f6740f7b9f76b2dddeffb8c	0	f
validation_pr_auc	0.2396755363718379	1784661564205	4fe6b8e9bbef4cb49dd0b503775f095e	0	f
validation_pr_auc	0.23794729660618208	1784661612242	c9bd89e9733b418e8a4c762cccf8aa2d	0	f
validation_pr_auc	0.23585511581303928	1784661643252	61bef132335149da8fc1bcd646945380	0	f
validation_pr_auc	0.23824838982171367	1784661671839	8c036e2f01ae4dce9b24165f8105ca06	0	f
validation_pr_auc	0.23689189328415983	1784661688387	532603551a954e97bc6f82485f631d2e	0	f
validation_pr_auc	0.23824726736183582	1784661727753	a4fe1e00ac0e4e67b019e182ca42dfa5	0	f
validation_pr_auc	0.2382020587972399	1784661761728	2b432c32784143a9b9d3be8670c9b2de	0	f
validation_pr_auc	0.23913887251415988	1784661798996	91efa9c98d164aedac595d534867cfa9	0	f
validation_pr_auc	0.23872596781373606	1784661850519	7cabb843d24d4b86a34757eaf1696d59	0	f
validation_pr_auc	0.23657920935896445	1784661867399	cbe54d84d2f84e4b982ad2d27427c7a7	0	f
validation_pr_auc	0.23499723994602942	1784661917811	97fb30d77c874bbe909e9b34ff9ab219	0	f
validation_pr_auc	0.2404309851910955	1784661949096	23cfec62bb2b4c81b834e33e1d64015a	0	f
validation_pr_auc	0.23759212950037023	1784661984262	4ad932f7dcda4517b7b5cc0c8beac404	0	f
validation_pr_auc	0.2402926545510029	1784662029256	a83392e9cd7a4265b05f9abeced43638	0	f
validation_pr_auc	0.2387830021456303	1784662058319	5271cb97dc8e4421816e4fbc4e06b329	0	f
validation_pr_auc	0.23843773322699277	1784662117862	193b290a18504fa8a42991b624278dbf	0	f
validation_pr_auc	0.23717508584599145	1784662169850	384089aee8ff469e884eb523460d2e23	0	f
validation_pr_auc	0.23385833795146863	1784662245209	9ee14964976f41c9a0d4773391dc1b89	0	f
validation_pr_auc	0.23983360169081472	1784662277663	bbf38d0761d14a96a7f6af68d83b297c	0	f
validation_pr_auc	0.23840539451346338	1784662307539	e465ea368468417f95c02d9736ea13d2	0	f
validation_pr_auc	0.23987497686307196	1784662344865	7f39848a745a4f55b4b6f53656bbea09	0	f
validation_pr_auc	0.237918841066137	1784662373644	99f8a6c1a99042518e4a0ef2de67cbd0	0	f
validation_pr_auc	0.2404352653220775	1784662405142	82ae9253c99347c28805e14bb275d4e1	0	f
validation_pr_auc	0.23581505385945814	1784662448587	ea05524904e94189b607f30d35114cf5	0	f
validation_pr_auc	0.2361306041886094	1784662477862	59630d004d38484f8b30f453b17fd561	0	f
validation_pr_auc	0.24018325845146854	1784662508150	143106f491a142fa98764b4036346fc5	0	f
validation_pr_auc	0.2393519786006988	1784662543402	212e3cc9c33a469097370a89878e6e0d	0	f
validation_pr_auc	0.23635057328017015	1784662590312	5098e5701fc04d33a5d78ff3e0c2d8f2	0	f
validation_pr_auc	0.2394865183124187	1784662626185	0b4fd1f6f7d84dfe891162a68110faa4	0	f
validation_pr_auc	0.23948550133550517	1784662659930	c8478da13b1d44e09ff6954fe7f8ceb5	0	f
validation_pr_auc	0.23930450076340984	1784662702803	2593c87053c24c5ab46a701293e5da1c	0	f
validation_pr_auc	0.24108764271456687	1784662721041	0a433fa3378a4b90b664cc4fde90ed21	0	f
validation_pr_auc	0.22794698235069122	1784662740242	5731165fd9d341c093634c24885b4b80	0	f
validation_pr_auc	0.23985411420584654	1784662772827	6fd1e2f0387c42e6bc1b573547aa39c7	0	f
validation_pr_auc	0.2369201642905565	1784662788977	8c6c444e121e4c82ad5345c29fcd297d	0	f
validation_pr_auc	0.2392874273950558	1784662821696	14f0de2bdc004a6ca97d19b2d9dad96b	0	f
validation_pr_auc	0.23985283318217474	1784662846665	7f16b61fe03848238ff296583f7d49f5	0	f
validation_pr_auc	0.23646414471733	1784662877008	531d154bc65c4e3c9e3e691c91d4e598	0	f
validation_pr_auc	0.23758423006338403	1784662941888	7166345b17ac40e3a6384bc3e57a4e38	0	f
validation_pr_auc	0.23931701158957155	1784662970788	e04590dc86674c0985b160f47a15d939	0	f
validation_pr_auc	0.23799043061795616	1784663006365	08a4d70131f54e81bd0d47a5448e3d43	0	f
validation_pr_auc	0.23724390889896324	1784663019384	3a54e130da3a488e9cddd8f564b50636	0	f
validation_pr_auc	0.22779885717927664	1784663038139	196f279c8b2a47a3ae0b5e4069634bfe	0	f
validation_pr_auc	0.2364999196120953	1784663051245	7305560d783f4197a5a7e63dcb91495c	0	f
validation_pr_auc	0.23918269617673885	1784663063694	af4fa3186c554df8bd52d00efdd3b518	0	f
validation_pr_auc	0.23904553873756432	1784663095120	0e6ba24868c9455f9324ff11fa6f37c0	0	f
validation_pr_auc	0.2411067234824961	1784663125601	e6f37d31a9df48adbf7ce400630985f2	0	f
validation_pr_auc	0.23891591583211336	1784663139873	5219ab1ee77e4d0a9b2ea76665637741	0	f
validation_pr_auc	0.2371636930317649	1784663168232	b7a96024f405468da0046f142f3fba28	0	f
validation_pr_auc	0.23717406384302947	1784663198323	cc82112ae9004ab48a54576c09abb51e	0	f
validation_pr_auc	0.23119092732172714	1784663224732	df12860a7b4a46e9abaef76ff774590e	0	f
validation_pr_auc	0.23886098128050712	1784663264720	a45d4a14e3cb4767b85a0dd503888266	0	f
validation_pr_auc	0.23527647209142072	1784663288421	91fb3e7556b448e794bc7f57497b4ac4	0	f
validation_pr_auc	0.23499614892135795	1784663312283	28adcc19e5354574966fd00385b49f1a	0	f
validation_pr_auc	0.23876818214457274	1784663346568	fd79d84e5b9a463e8c5d9ad2eebe966f	0	f
validation_pr_auc	0.23860580769722406	1784663494566	cca09d0a7a824be1b885d47ad28e10a4	0	f
validation_pr_auc	0.23977643247751726	1784663578576	de0278a9f23d4eea946bc673a797c3c2	0	f
validation_pr_auc	0.23954266657231044	1784663386735	bd4a6462eb314b5cb3c57f9db508a4e4	0	f
validation_pr_auc	0.24028517480514375	1784663698771	117e0e60760d44ac9ef154cceb212171	0	f
validation_pr_auc	0.23711452859714285	1784663413896	3405dcc6ebdd44609d0d260aa28f3122	0	f
validation_pr_auc	0.23937418964497173	1784663617185	130f444dde0c42df9f6abc1bd79d9b77	0	f
validation_pr_auc	0.2058622177352676	1784663457499	ee5e81cfc9ad4fda8222a171057e4ffc	0	f
validation_pr_auc	0.23828710684417304	1784663669055	2ad9ddee054f4a0fa0c5e251a177dd6a	0	f
validation_pr_auc	0.23958061603548161	1784663536040	c599cc0f5ca645e989b7478887d03f28	0	f
validation_pr_auc	0.237830518773729	1784663640458	e3ca2557a9f543f7952783569ae86534	0	f
validation_pr_auc	0.23755091949322077	1784663725341	62ca7fadf67347b29ca9598d327eebd2	0	f
validation_pr_auc	0.23869291080670169	1784663768318	ba4d5a30aa02426d9e1536625f3ebe6a	0	f
validation_pr_auc	0.23770157934473604	1784663781491	98d0deba9dd641d281274cbf802081fb	0	f
validation_pr_auc	0.21813045459444436	1784663798110	cd47568195194bd4b3b7f694f1a08f9a	0	f
validation_pr_auc	0.23968560306027464	1784663818953	30bde976c0b84a36b835f3d18848103c	0	f
validation_pr_auc	0.23417770518508363	1784663852618	200e44c932ce4dad8671cd5da9b409d9	0	f
validation_pr_auc	0.23935771317809265	1784663885216	8d81437cc3714f6982ae885c3c81bacf	0	f
validation_pr_auc	0.23955856183273483	1784663918975	3e09014e17a84af3b1624fa0068fa0a7	0	f
validation_pr_auc	0.2389233261835132	1784663934051	b4689faec3f7445fbe0ba427b0859231	0	f
validation_pr_auc	0.2270072882396025	1784663979104	aa9da8551d8a425785523304e9c547f3	0	f
validation_pr_auc	0.2390095926969984	1784664012632	f9ede5de86ea4f9b8ac1a181ddd36d72	0	f
validation_pr_auc	0.23952717908417398	1784664057456	569e3af54f5549d389c2817c8ccf9823	0	f
validation_pr_auc	0.2397392585261173	1784664092634	f0d12270c17441cb82afdc0ff9f70809	0	f
validation_pr_auc	0.2403590641639288	1784664139342	52e3ecc8bd264c6bb75dd7e13c9c3713	0	f
validation_pr_auc	0.23481804424567984	1784664177344	2e7a3710bd5e4ee2ad9d870e16e43be0	0	f
validation_pr_auc	0.23772940580821655	1784664236753	d3f4b439155d4a1f8452de974a8fd530	0	f
validation_pr_auc	0.2288557735994681	1784664292654	2d0fdb5b0ebe4654b38066951cec3ae8	0	f
validation_pr_auc	0.23838165306658973	1784664336387	d6ab3fd3b7be407a86383f867d0d3987	0	f
validation_pr_auc	0.23716800792342335	1784664372581	571b8fa9bdad427a9816b5b5144622ef	0	f
validation_pr_auc	0.23849787266881473	1784664396720	11b06d8ded174450aaa0563cd01e2137	0	f
validation_pr_auc	0.23991826914000172	1784664428854	fea20651e3e744068c1d02e03e73f652	0	f
validation_pr_auc	0.2387662132377705	1784664466809	35ea2431d44b4d5197234e1257f742e7	0	f
validation_pr_auc	0.23904594225695305	1784664486011	19c7ae8c940042a9bea5484d5c7a996f	0	f
validation_pr_auc	0.2398773740063644	1784664521956	c2a98b6d06ba4b14ac81cdaaacee8d9b	0	f
validation_pr_auc	0.23920689197632994	1784664548281	87f145f9b3b4496f901df95d56e470b8	0	f
validation_pr_auc	0.23878234308300386	1784664602071	c23e0bcb7b334d3aae37f42aa4aaa09d	0	f
validation_pr_auc	0.23788897478537532	1784664691358	f4eb85ac7f484c7b9665388a9a0d3e8f	0	f
validation_pr_auc	0.22938362753881394	1784664735108	e9f2cf11fabd4422a3404f41f7e12593	0	f
validation_pr_auc	0.23897452171566785	1784664783971	faefe080fefc45eabc2137abcdf3ef0c	0	f
validation_pr_auc	0.2399403272145806	1784664812427	96479ef023f34b15a8033d9c5657d9dc	0	f
validation_pr_auc	0.23542095340310615	1784664844580	3e93389d94ca40148d153412a6cddbcb	0	f
validation_pr_auc	0.23823112517820766	1784664881339	eb16c82079fd4ba591d99f8201df04d1	0	f
validation_pr_auc	0.2391816591662354	1784664919134	a643f1f3cf3147aaa764aafd4114e6ff	0	f
validation_pr_auc	0.23756687468343876	1784664941501	e4ff17e0741440b49a2e374cba8fc594	0	f
validation_pr_auc	0.23919607623095504	1784664963170	1918bf94daa7417a9f9a9bbe2f473d24	0	f
validation_pr_auc	0.22684420046601392	1784664997609	6975e9f2410b4b48a24bb54de3773f71	0	f
validation_pr_auc	0.2371633090352755	1784665017481	c7ca2abd948b4f7a8f5ef910fcb0e754	0	f
validation_pr_auc	0.23714535261904882	1784665031149	7c916e1a7e7d4b44be04309d6b501d6f	0	f
validation_pr_auc	0.24005564996478096	1784665066330	ce2b0e6b82744bb9ab441eb5516e4bb9	0	f
validation_pr_auc	0.2377973116721291	1784665118428	bec59faddbfa49baa60c2a3653cd5dbd	0	f
best_validation_pr_auc	0.2411067234824961	1784665118624	cceff74de09a44f48ae9e027c5f35536	0	f
precision	0.23423799582463464	1784668335541	033ebefb766e4bfa8282ab39cec5c865	0	f
recall	0.45196374622356494	1784668335541	033ebefb766e4bfa8282ab39cec5c865	0	f
f1_score	0.3085596424888278	1784668335541	033ebefb766e4bfa8282ab39cec5c865	0	f
pr_auc	0.24880570334998775	1784668335541	033ebefb766e4bfa8282ab39cec5c865	0	f
roc_auc	0.7595517912593219	1784668335541	033ebefb766e4bfa8282ab39cec5c865	0	f
ks	0.38352147511622003	1784668335541	033ebefb766e4bfa8282ab39cec5c865	0	f
threshold	0.64	1784668335541	033ebefb766e4bfa8282ab39cec5c865	0	f
training_precision_score	0.9162393533441483	1784670139082	be0003b4c09f45a384716a36faaa3fde	0	f
training_recall_score	0.741517026919911	1784670139082	be0003b4c09f45a384716a36faaa3fde	0	f
training_f1_score	0.7988895602736004	1784670139082	be0003b4c09f45a384716a36faaa3fde	0	f
training_accuracy_score	0.741517026919911	1784670139082	be0003b4c09f45a384716a36faaa3fde	0	f
training_log_loss	0.517355146468789	1784670139082	be0003b4c09f45a384716a36faaa3fde	0	f
training_roc_auc	0.8558960141646185	1784670139082	be0003b4c09f45a384716a36faaa3fde	0	f
training_score	0.741517026919911	1784670159077	be0003b4c09f45a384716a36faaa3fde	0	f
precision	0.23423799582463464	1784670167656	be0003b4c09f45a384716a36faaa3fde	0	f
recall	0.45196374622356494	1784670167656	be0003b4c09f45a384716a36faaa3fde	0	f
f1_score	0.3085596424888278	1784670167656	be0003b4c09f45a384716a36faaa3fde	0	f
pr_auc	0.24880570334998775	1784670167656	be0003b4c09f45a384716a36faaa3fde	0	f
roc_auc	0.7595517912593219	1784670167656	be0003b4c09f45a384716a36faaa3fde	0	f
ks	0.38352147511622003	1784670167656	be0003b4c09f45a384716a36faaa3fde	0	f
\.


--
-- Data for Name: model_version_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.model_version_tags (key, value, name, version) FROM stdin;
\.


--
-- Data for Name: model_versions; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.model_versions (name, version, creation_time, last_updated_time, description, user_id, current_stage, source, run_id, status, status_message, run_link, storage_location) FROM stdin;
\.


--
-- Data for Name: params; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.params (key, value, run_uuid) FROM stdin;
n_splits	3	f5a3d1a3c4ed4af69451b19e8ca99b44
n_features	46	f5a3d1a3c4ed4af69451b19e8ca99b44
algorithm	Random Forest	1c1474a4dc0a42e595b137a2ff7eb3cd
algorithm	LightGBM	87bee9e02af04727a439076b5099ea26
algorithm	XGBoost	a0d9d4037d9a483e8ff2887e8c35e79a
n_features	46	5182637ae0084c8c9a5b790208db545b
algorithm	Random Forest	64d0075ce861402aa333540e2cfb3177
n_features	46	8274a5b2f12040bc9cd010d478f47bb2
algorithm	Random Forest	7ad743cafe754961865d8d9048d97887
algorithm	LightGBM	9899a48432a34cb39a199dcf5ae28c28
algorithm	XGBoost	f8b1be9aa8b34c36a0d398fea269c222
boosting_type	gbdt	b065943b869c45d1ab9a544997cbd2e3
colsample_bytree	0.5290418060840998	b065943b869c45d1ab9a544997cbd2e3
learning_rate	0.019906996673933378	b065943b869c45d1ab9a544997cbd2e3
max_depth	8	b065943b869c45d1ab9a544997cbd2e3
min_child_samples	39	b065943b869c45d1ab9a544997cbd2e3
min_child_weight	0.001	b065943b869c45d1ab9a544997cbd2e3
min_split_gain	0.7080725777960455	b065943b869c45d1ab9a544997cbd2e3
num_leaves	192	b065943b869c45d1ab9a544997cbd2e3
random_state	42	b065943b869c45d1ab9a544997cbd2e3
reg_alpha	0.6245760287469893	b065943b869c45d1ab9a544997cbd2e3
reg_lambda	0.002570603566117598	b065943b869c45d1ab9a544997cbd2e3
subsample	0.662397808134481	b065943b869c45d1ab9a544997cbd2e3
subsample_for_bin	200000	b065943b869c45d1ab9a544997cbd2e3
subsample_freq	0	b065943b869c45d1ab9a544997cbd2e3
metric	['None']	b065943b869c45d1ab9a544997cbd2e3
verbosity	-1	b065943b869c45d1ab9a544997cbd2e3
scale_pos_weight	11.387084592145015	b065943b869c45d1ab9a544997cbd2e3
objective	binary	b065943b869c45d1ab9a544997cbd2e3
num_threads	12	b065943b869c45d1ab9a544997cbd2e3
num_boost_round	2000	b065943b869c45d1ab9a544997cbd2e3
feature_name	auto	b065943b869c45d1ab9a544997cbd2e3
categorical_feature	auto	b065943b869c45d1ab9a544997cbd2e3
keep_training_booster	False	b065943b869c45d1ab9a544997cbd2e3
boosting_type	gbdt	876e004fc22941a5bd0abf6035008d6e
colsample_bytree	0.6521211214797689	876e004fc22941a5bd0abf6035008d6e
learning_rate	0.005394455304087533	876e004fc22941a5bd0abf6035008d6e
max_depth	5	876e004fc22941a5bd0abf6035008d6e
min_child_samples	44	876e004fc22941a5bd0abf6035008d6e
min_child_weight	0.001	876e004fc22941a5bd0abf6035008d6e
min_split_gain	0.2912291401980419	876e004fc22941a5bd0abf6035008d6e
num_leaves	216	876e004fc22941a5bd0abf6035008d6e
random_state	42	876e004fc22941a5bd0abf6035008d6e
reg_alpha	0.00052821153945323	876e004fc22941a5bd0abf6035008d6e
reg_lambda	7.71800699380605e-05	876e004fc22941a5bd0abf6035008d6e
subsample	0.6733618039413735	876e004fc22941a5bd0abf6035008d6e
subsample_for_bin	200000	876e004fc22941a5bd0abf6035008d6e
subsample_freq	0	876e004fc22941a5bd0abf6035008d6e
metric	['None']	876e004fc22941a5bd0abf6035008d6e
verbosity	-1	876e004fc22941a5bd0abf6035008d6e
scale_pos_weight	11.387084592145015	876e004fc22941a5bd0abf6035008d6e
objective	binary	876e004fc22941a5bd0abf6035008d6e
num_threads	12	876e004fc22941a5bd0abf6035008d6e
num_boost_round	2000	876e004fc22941a5bd0abf6035008d6e
feature_name	auto	876e004fc22941a5bd0abf6035008d6e
categorical_feature	auto	876e004fc22941a5bd0abf6035008d6e
keep_training_booster	False	876e004fc22941a5bd0abf6035008d6e
boosting_type	gbdt	77d0e55214db4ecd857415d3af80c800
colsample_bytree	0.5998368910791798	77d0e55214db4ecd857415d3af80c800
learning_rate	0.04777437867054351	77d0e55214db4ecd857415d3af80c800
max_depth	6	77d0e55214db4ecd857415d3af80c800
min_child_samples	97	77d0e55214db4ecd857415d3af80c800
min_child_weight	0.001	77d0e55214db4ecd857415d3af80c800
min_split_gain	0.046450412719997725	77d0e55214db4ecd857415d3af80c800
num_leaves	86	77d0e55214db4ecd857415d3af80c800
random_state	42	77d0e55214db4ecd857415d3af80c800
reg_alpha	0.00042472707398058225	77d0e55214db4ecd857415d3af80c800
reg_lambda	0.0021465011216654484	77d0e55214db4ecd857415d3af80c800
subsample	0.9140703845572055	77d0e55214db4ecd857415d3af80c800
subsample_for_bin	200000	77d0e55214db4ecd857415d3af80c800
subsample_freq	0	77d0e55214db4ecd857415d3af80c800
metric	['None']	77d0e55214db4ecd857415d3af80c800
verbosity	-1	77d0e55214db4ecd857415d3af80c800
scale_pos_weight	11.387084592145015	77d0e55214db4ecd857415d3af80c800
objective	binary	77d0e55214db4ecd857415d3af80c800
num_threads	12	77d0e55214db4ecd857415d3af80c800
num_boost_round	400	77d0e55214db4ecd857415d3af80c800
feature_name	auto	77d0e55214db4ecd857415d3af80c800
categorical_feature	auto	77d0e55214db4ecd857415d3af80c800
keep_training_booster	False	77d0e55214db4ecd857415d3af80c800
boosting_type	gbdt	8af2154e65c646ba85f95ef956f429e3
colsample_bytree	0.6523068845866853	8af2154e65c646ba85f95ef956f429e3
learning_rate	0.04702115628087815	8af2154e65c646ba85f95ef956f429e3
max_depth	12	8af2154e65c646ba85f95ef956f429e3
min_child_samples	194	8af2154e65c646ba85f95ef956f429e3
min_child_weight	0.001	8af2154e65c646ba85f95ef956f429e3
min_split_gain	0.4401524937396013	8af2154e65c646ba85f95ef956f429e3
num_leaves	31	8af2154e65c646ba85f95ef956f429e3
random_state	42	8af2154e65c646ba85f95ef956f429e3
reg_alpha	7.569183361880229e-08	8af2154e65c646ba85f95ef956f429e3
reg_lambda	0.014391207615728067	8af2154e65c646ba85f95ef956f429e3
subsample	0.9233589392465844	8af2154e65c646ba85f95ef956f429e3
subsample_for_bin	200000	8af2154e65c646ba85f95ef956f429e3
subsample_freq	0	8af2154e65c646ba85f95ef956f429e3
metric	['None']	8af2154e65c646ba85f95ef956f429e3
verbosity	-1	8af2154e65c646ba85f95ef956f429e3
scale_pos_weight	11.387084592145015	8af2154e65c646ba85f95ef956f429e3
objective	binary	8af2154e65c646ba85f95ef956f429e3
num_threads	12	8af2154e65c646ba85f95ef956f429e3
num_boost_round	500	8af2154e65c646ba85f95ef956f429e3
feature_name	auto	8af2154e65c646ba85f95ef956f429e3
categorical_feature	auto	8af2154e65c646ba85f95ef956f429e3
keep_training_booster	False	8af2154e65c646ba85f95ef956f429e3
boosting_type	gbdt	546361b43206462abda8503c0473c830
colsample_bytree	0.6558555380447055	546361b43206462abda8503c0473c830
learning_rate	0.007843006551565005	546361b43206462abda8503c0473c830
max_depth	12	546361b43206462abda8503c0473c830
min_child_samples	59	546361b43206462abda8503c0473c830
min_child_weight	0.001	546361b43206462abda8503c0473c830
min_split_gain	0.18485445552552704	546361b43206462abda8503c0473c830
num_leaves	24	546361b43206462abda8503c0473c830
random_state	42	546361b43206462abda8503c0473c830
reg_alpha	0.0004793052550782129	546361b43206462abda8503c0473c830
reg_lambda	0.0008325158565947976	546361b43206462abda8503c0473c830
subsample	0.8650089137415928	546361b43206462abda8503c0473c830
subsample_for_bin	200000	546361b43206462abda8503c0473c830
subsample_freq	0	546361b43206462abda8503c0473c830
metric	['None']	546361b43206462abda8503c0473c830
verbosity	-1	546361b43206462abda8503c0473c830
scale_pos_weight	11.387084592145015	546361b43206462abda8503c0473c830
objective	binary	546361b43206462abda8503c0473c830
num_threads	12	546361b43206462abda8503c0473c830
num_boost_round	1100	546361b43206462abda8503c0473c830
feature_name	auto	546361b43206462abda8503c0473c830
categorical_feature	auto	546361b43206462abda8503c0473c830
keep_training_booster	False	546361b43206462abda8503c0473c830
boosting_type	gbdt	863d9eddfa374352ac9ef04f414aed07
colsample_bytree	0.5442462510259598	863d9eddfa374352ac9ef04f414aed07
learning_rate	0.17877333612826407	863d9eddfa374352ac9ef04f414aed07
max_depth	11	863d9eddfa374352ac9ef04f414aed07
min_child_samples	124	863d9eddfa374352ac9ef04f414aed07
min_child_weight	0.001	863d9eddfa374352ac9ef04f414aed07
min_split_gain	0.32533033076326434	863d9eddfa374352ac9ef04f414aed07
num_leaves	242	863d9eddfa374352ac9ef04f414aed07
random_state	42	863d9eddfa374352ac9ef04f414aed07
reg_alpha	5.805581976088804e-07	863d9eddfa374352ac9ef04f414aed07
reg_lambda	2.5529693461039728e-08	863d9eddfa374352ac9ef04f414aed07
subsample	0.9687496940092467	863d9eddfa374352ac9ef04f414aed07
subsample_for_bin	200000	863d9eddfa374352ac9ef04f414aed07
subsample_freq	0	863d9eddfa374352ac9ef04f414aed07
metric	['None']	863d9eddfa374352ac9ef04f414aed07
verbosity	-1	863d9eddfa374352ac9ef04f414aed07
scale_pos_weight	11.387084592145015	863d9eddfa374352ac9ef04f414aed07
objective	binary	863d9eddfa374352ac9ef04f414aed07
num_threads	12	863d9eddfa374352ac9ef04f414aed07
num_boost_round	1600	863d9eddfa374352ac9ef04f414aed07
feature_name	auto	863d9eddfa374352ac9ef04f414aed07
categorical_feature	auto	863d9eddfa374352ac9ef04f414aed07
keep_training_booster	False	863d9eddfa374352ac9ef04f414aed07
boosting_type	gbdt	761f6f2a81274b38bf29c785c17b9f5c
colsample_bytree	0.5704621124873813	761f6f2a81274b38bf29c785c17b9f5c
learning_rate	0.02097269976216845	761f6f2a81274b38bf29c785c17b9f5c
max_depth	6	761f6f2a81274b38bf29c785c17b9f5c
min_child_samples	63	761f6f2a81274b38bf29c785c17b9f5c
min_child_weight	0.001	761f6f2a81274b38bf29c785c17b9f5c
min_split_gain	0.9868869366005173	761f6f2a81274b38bf29c785c17b9f5c
num_leaves	215	761f6f2a81274b38bf29c785c17b9f5c
random_state	42	761f6f2a81274b38bf29c785c17b9f5c
reg_alpha	0.16587190283399655	761f6f2a81274b38bf29c785c17b9f5c
reg_lambda	4.6876566400928895e-08	761f6f2a81274b38bf29c785c17b9f5c
subsample	0.8170784332632994	761f6f2a81274b38bf29c785c17b9f5c
subsample_for_bin	200000	761f6f2a81274b38bf29c785c17b9f5c
subsample_freq	0	761f6f2a81274b38bf29c785c17b9f5c
metric	['None']	761f6f2a81274b38bf29c785c17b9f5c
verbosity	-1	761f6f2a81274b38bf29c785c17b9f5c
scale_pos_weight	11.387084592145015	761f6f2a81274b38bf29c785c17b9f5c
objective	binary	761f6f2a81274b38bf29c785c17b9f5c
num_threads	12	761f6f2a81274b38bf29c785c17b9f5c
num_boost_round	700	761f6f2a81274b38bf29c785c17b9f5c
feature_name	auto	761f6f2a81274b38bf29c785c17b9f5c
categorical_feature	auto	761f6f2a81274b38bf29c785c17b9f5c
keep_training_booster	False	761f6f2a81274b38bf29c785c17b9f5c
boosting_type	gbdt	014e8bb3efda4a7f9e544ad0c54eda97
colsample_bytree	0.8856351733429728	014e8bb3efda4a7f9e544ad0c54eda97
learning_rate	0.08632815369661433	014e8bb3efda4a7f9e544ad0c54eda97
max_depth	11	014e8bb3efda4a7f9e544ad0c54eda97
min_child_samples	145	014e8bb3efda4a7f9e544ad0c54eda97
min_child_weight	0.001	014e8bb3efda4a7f9e544ad0c54eda97
min_split_gain	0.11586905952512971	014e8bb3efda4a7f9e544ad0c54eda97
num_leaves	17	014e8bb3efda4a7f9e544ad0c54eda97
random_state	42	014e8bb3efda4a7f9e544ad0c54eda97
reg_alpha	4.638759594322625e-08	014e8bb3efda4a7f9e544ad0c54eda97
reg_lambda	1.683416412018213e-05	014e8bb3efda4a7f9e544ad0c54eda97
subsample	0.8916028672163949	014e8bb3efda4a7f9e544ad0c54eda97
subsample_for_bin	200000	014e8bb3efda4a7f9e544ad0c54eda97
subsample_freq	0	014e8bb3efda4a7f9e544ad0c54eda97
metric	['None']	014e8bb3efda4a7f9e544ad0c54eda97
verbosity	-1	014e8bb3efda4a7f9e544ad0c54eda97
scale_pos_weight	11.387084592145015	014e8bb3efda4a7f9e544ad0c54eda97
objective	binary	014e8bb3efda4a7f9e544ad0c54eda97
num_threads	12	014e8bb3efda4a7f9e544ad0c54eda97
num_boost_round	500	014e8bb3efda4a7f9e544ad0c54eda97
feature_name	auto	014e8bb3efda4a7f9e544ad0c54eda97
categorical_feature	auto	014e8bb3efda4a7f9e544ad0c54eda97
keep_training_booster	False	014e8bb3efda4a7f9e544ad0c54eda97
boosting_type	gbdt	889b7c5d83704dd2ac3f3508dcb6bbeb
colsample_bytree	0.864803089169032	889b7c5d83704dd2ac3f3508dcb6bbeb
learning_rate	0.1207017234656905	889b7c5d83704dd2ac3f3508dcb6bbeb
max_depth	3	889b7c5d83704dd2ac3f3508dcb6bbeb
min_child_samples	69	889b7c5d83704dd2ac3f3508dcb6bbeb
min_child_weight	0.001	889b7c5d83704dd2ac3f3508dcb6bbeb
min_split_gain	0.4722149251619493	889b7c5d83704dd2ac3f3508dcb6bbeb
num_leaves	95	889b7c5d83704dd2ac3f3508dcb6bbeb
random_state	42	889b7c5d83704dd2ac3f3508dcb6bbeb
reg_alpha	0.005470376807480391	889b7c5d83704dd2ac3f3508dcb6bbeb
reg_lambda	0.9658611176861268	889b7c5d83704dd2ac3f3508dcb6bbeb
subsample	0.7300733288106989	889b7c5d83704dd2ac3f3508dcb6bbeb
subsample_for_bin	200000	889b7c5d83704dd2ac3f3508dcb6bbeb
subsample_freq	0	889b7c5d83704dd2ac3f3508dcb6bbeb
metric	['None']	889b7c5d83704dd2ac3f3508dcb6bbeb
verbosity	-1	889b7c5d83704dd2ac3f3508dcb6bbeb
scale_pos_weight	11.387084592145015	889b7c5d83704dd2ac3f3508dcb6bbeb
objective	binary	889b7c5d83704dd2ac3f3508dcb6bbeb
num_threads	12	889b7c5d83704dd2ac3f3508dcb6bbeb
num_boost_round	1300	889b7c5d83704dd2ac3f3508dcb6bbeb
feature_name	auto	889b7c5d83704dd2ac3f3508dcb6bbeb
categorical_feature	auto	889b7c5d83704dd2ac3f3508dcb6bbeb
keep_training_booster	False	889b7c5d83704dd2ac3f3508dcb6bbeb
boosting_type	gbdt	ae175d867d8d4942b3953e031f48deea
colsample_bytree	0.7613664146909971	ae175d867d8d4942b3953e031f48deea
learning_rate	0.007772615081694643	ae175d867d8d4942b3953e031f48deea
max_depth	8	ae175d867d8d4942b3953e031f48deea
min_child_samples	157	ae175d867d8d4942b3953e031f48deea
min_child_weight	0.001	ae175d867d8d4942b3953e031f48deea
min_split_gain	0.10789142699330445	ae175d867d8d4942b3953e031f48deea
num_leaves	199	ae175d867d8d4942b3953e031f48deea
random_state	42	ae175d867d8d4942b3953e031f48deea
reg_alpha	7.04480806377519e-05	ae175d867d8d4942b3953e031f48deea
reg_lambda	1.6934490731313353e-08	ae175d867d8d4942b3953e031f48deea
subsample	0.7975182385457563	ae175d867d8d4942b3953e031f48deea
subsample_for_bin	200000	ae175d867d8d4942b3953e031f48deea
subsample_freq	0	ae175d867d8d4942b3953e031f48deea
metric	['None']	ae175d867d8d4942b3953e031f48deea
verbosity	-1	ae175d867d8d4942b3953e031f48deea
scale_pos_weight	11.387084592145015	ae175d867d8d4942b3953e031f48deea
objective	binary	ae175d867d8d4942b3953e031f48deea
num_threads	12	ae175d867d8d4942b3953e031f48deea
num_boost_round	1500	ae175d867d8d4942b3953e031f48deea
feature_name	auto	ae175d867d8d4942b3953e031f48deea
categorical_feature	auto	ae175d867d8d4942b3953e031f48deea
keep_training_booster	False	ae175d867d8d4942b3953e031f48deea
boosting_type	gbdt	c570005822f1468ebc56e3a2e5f3a7be
colsample_bytree	0.5542577005819482	c570005822f1468ebc56e3a2e5f3a7be
learning_rate	0.022292327755663893	c570005822f1468ebc56e3a2e5f3a7be
max_depth	12	c570005822f1468ebc56e3a2e5f3a7be
min_child_samples	194	c570005822f1468ebc56e3a2e5f3a7be
min_child_weight	0.001	c570005822f1468ebc56e3a2e5f3a7be
min_split_gain	0.4732705583942727	c570005822f1468ebc56e3a2e5f3a7be
num_leaves	45	c570005822f1468ebc56e3a2e5f3a7be
random_state	42	c570005822f1468ebc56e3a2e5f3a7be
reg_alpha	1.0575028573348581e-08	c570005822f1468ebc56e3a2e5f3a7be
reg_lambda	0.011353164210190829	c570005822f1468ebc56e3a2e5f3a7be
subsample	0.9827447512786075	c570005822f1468ebc56e3a2e5f3a7be
subsample_for_bin	200000	c570005822f1468ebc56e3a2e5f3a7be
subsample_freq	0	c570005822f1468ebc56e3a2e5f3a7be
metric	['None']	c570005822f1468ebc56e3a2e5f3a7be
verbosity	-1	c570005822f1468ebc56e3a2e5f3a7be
scale_pos_weight	11.387084592145015	c570005822f1468ebc56e3a2e5f3a7be
objective	binary	c570005822f1468ebc56e3a2e5f3a7be
num_threads	12	c570005822f1468ebc56e3a2e5f3a7be
num_boost_round	600	c570005822f1468ebc56e3a2e5f3a7be
feature_name	auto	c570005822f1468ebc56e3a2e5f3a7be
categorical_feature	auto	c570005822f1468ebc56e3a2e5f3a7be
keep_training_booster	False	c570005822f1468ebc56e3a2e5f3a7be
boosting_type	gbdt	6198d6b56d9e4ff5afeca1168f4226b8
colsample_bytree	0.7019903892289381	6198d6b56d9e4ff5afeca1168f4226b8
learning_rate	0.019234463947324584	6198d6b56d9e4ff5afeca1168f4226b8
max_depth	11	6198d6b56d9e4ff5afeca1168f4226b8
min_child_samples	197	6198d6b56d9e4ff5afeca1168f4226b8
min_child_weight	0.001	6198d6b56d9e4ff5afeca1168f4226b8
min_split_gain	0.6377524188803458	6198d6b56d9e4ff5afeca1168f4226b8
num_leaves	24	6198d6b56d9e4ff5afeca1168f4226b8
random_state	42	6198d6b56d9e4ff5afeca1168f4226b8
reg_alpha	2.1639048265016216e-08	6198d6b56d9e4ff5afeca1168f4226b8
reg_lambda	0.01679222302543047	6198d6b56d9e4ff5afeca1168f4226b8
subsample	0.9927787970043556	6198d6b56d9e4ff5afeca1168f4226b8
subsample_for_bin	200000	6198d6b56d9e4ff5afeca1168f4226b8
subsample_freq	0	6198d6b56d9e4ff5afeca1168f4226b8
metric	['None']	6198d6b56d9e4ff5afeca1168f4226b8
verbosity	-1	6198d6b56d9e4ff5afeca1168f4226b8
scale_pos_weight	11.387084592145015	6198d6b56d9e4ff5afeca1168f4226b8
objective	binary	6198d6b56d9e4ff5afeca1168f4226b8
num_threads	12	6198d6b56d9e4ff5afeca1168f4226b8
num_boost_round	1400	6198d6b56d9e4ff5afeca1168f4226b8
feature_name	auto	6198d6b56d9e4ff5afeca1168f4226b8
categorical_feature	auto	6198d6b56d9e4ff5afeca1168f4226b8
keep_training_booster	False	6198d6b56d9e4ff5afeca1168f4226b8
boosting_type	gbdt	16766e90a32c4f369ecd9e9b701ab356
colsample_bytree	0.6359928091600117	16766e90a32c4f369ecd9e9b701ab356
learning_rate	0.015988086182984456	16766e90a32c4f369ecd9e9b701ab356
max_depth	9	16766e90a32c4f369ecd9e9b701ab356
min_child_samples	193	16766e90a32c4f369ecd9e9b701ab356
min_child_weight	0.001	16766e90a32c4f369ecd9e9b701ab356
min_split_gain	0.8539655914065685	16766e90a32c4f369ecd9e9b701ab356
num_leaves	18	16766e90a32c4f369ecd9e9b701ab356
random_state	42	16766e90a32c4f369ecd9e9b701ab356
reg_alpha	5.366546215549973e-07	16766e90a32c4f369ecd9e9b701ab356
reg_lambda	0.8369217391179122	16766e90a32c4f369ecd9e9b701ab356
subsample	0.8464838248738901	16766e90a32c4f369ecd9e9b701ab356
subsample_for_bin	200000	16766e90a32c4f369ecd9e9b701ab356
subsample_freq	0	16766e90a32c4f369ecd9e9b701ab356
metric	['None']	16766e90a32c4f369ecd9e9b701ab356
verbosity	-1	16766e90a32c4f369ecd9e9b701ab356
scale_pos_weight	11.387084592145015	16766e90a32c4f369ecd9e9b701ab356
objective	binary	16766e90a32c4f369ecd9e9b701ab356
num_threads	12	16766e90a32c4f369ecd9e9b701ab356
num_boost_round	1300	16766e90a32c4f369ecd9e9b701ab356
feature_name	auto	16766e90a32c4f369ecd9e9b701ab356
categorical_feature	auto	16766e90a32c4f369ecd9e9b701ab356
keep_training_booster	False	16766e90a32c4f369ecd9e9b701ab356
boosting_type	gbdt	718cc73f4d1b4db98abc0e7b10db5ed6
colsample_bytree	0.8038283444509535	718cc73f4d1b4db98abc0e7b10db5ed6
learning_rate	0.011736381784679461	718cc73f4d1b4db98abc0e7b10db5ed6
max_depth	6	718cc73f4d1b4db98abc0e7b10db5ed6
min_child_samples	195	718cc73f4d1b4db98abc0e7b10db5ed6
min_child_weight	0.001	718cc73f4d1b4db98abc0e7b10db5ed6
min_split_gain	0.5355253700968463	718cc73f4d1b4db98abc0e7b10db5ed6
num_leaves	51	718cc73f4d1b4db98abc0e7b10db5ed6
random_state	42	718cc73f4d1b4db98abc0e7b10db5ed6
reg_alpha	4.031532696227557e-08	718cc73f4d1b4db98abc0e7b10db5ed6
reg_lambda	3.469559868992396	718cc73f4d1b4db98abc0e7b10db5ed6
subsample	0.7486960276886412	718cc73f4d1b4db98abc0e7b10db5ed6
subsample_for_bin	200000	718cc73f4d1b4db98abc0e7b10db5ed6
subsample_freq	0	718cc73f4d1b4db98abc0e7b10db5ed6
metric	['None']	718cc73f4d1b4db98abc0e7b10db5ed6
verbosity	-1	718cc73f4d1b4db98abc0e7b10db5ed6
scale_pos_weight	11.387084592145015	718cc73f4d1b4db98abc0e7b10db5ed6
objective	binary	718cc73f4d1b4db98abc0e7b10db5ed6
num_threads	12	718cc73f4d1b4db98abc0e7b10db5ed6
num_boost_round	800	718cc73f4d1b4db98abc0e7b10db5ed6
feature_name	auto	718cc73f4d1b4db98abc0e7b10db5ed6
categorical_feature	auto	718cc73f4d1b4db98abc0e7b10db5ed6
keep_training_booster	False	718cc73f4d1b4db98abc0e7b10db5ed6
boosting_type	gbdt	9aac8f92473d49cf903225b9a22ad98e
colsample_bytree	0.5822136284710018	9aac8f92473d49cf903225b9a22ad98e
learning_rate	0.031001483782539765	9aac8f92473d49cf903225b9a22ad98e
max_depth	10	9aac8f92473d49cf903225b9a22ad98e
min_child_samples	192	9aac8f92473d49cf903225b9a22ad98e
min_child_weight	0.001	9aac8f92473d49cf903225b9a22ad98e
min_split_gain	0.38152406996538457	9aac8f92473d49cf903225b9a22ad98e
num_leaves	36	9aac8f92473d49cf903225b9a22ad98e
random_state	42	9aac8f92473d49cf903225b9a22ad98e
reg_alpha	4.6842168359768357e-05	9aac8f92473d49cf903225b9a22ad98e
reg_lambda	0.00414068632716559	9aac8f92473d49cf903225b9a22ad98e
subsample	0.9834151703887607	9aac8f92473d49cf903225b9a22ad98e
subsample_for_bin	200000	9aac8f92473d49cf903225b9a22ad98e
subsample_freq	0	9aac8f92473d49cf903225b9a22ad98e
metric	['None']	9aac8f92473d49cf903225b9a22ad98e
verbosity	-1	9aac8f92473d49cf903225b9a22ad98e
scale_pos_weight	11.387084592145015	9aac8f92473d49cf903225b9a22ad98e
objective	binary	9aac8f92473d49cf903225b9a22ad98e
num_threads	12	9aac8f92473d49cf903225b9a22ad98e
num_boost_round	1100	9aac8f92473d49cf903225b9a22ad98e
feature_name	auto	9aac8f92473d49cf903225b9a22ad98e
categorical_feature	auto	9aac8f92473d49cf903225b9a22ad98e
keep_training_booster	False	9aac8f92473d49cf903225b9a22ad98e
boosting_type	gbdt	deb70d2c6e9844ad8ec9a5549a069559
colsample_bytree	0.7033985167080858	deb70d2c6e9844ad8ec9a5549a069559
learning_rate	0.023656811441837348	deb70d2c6e9844ad8ec9a5549a069559
max_depth	11	deb70d2c6e9844ad8ec9a5549a069559
min_child_samples	139	deb70d2c6e9844ad8ec9a5549a069559
min_child_weight	0.001	deb70d2c6e9844ad8ec9a5549a069559
min_split_gain	0.9544362101706378	deb70d2c6e9844ad8ec9a5549a069559
num_leaves	32	deb70d2c6e9844ad8ec9a5549a069559
random_state	42	deb70d2c6e9844ad8ec9a5549a069559
reg_alpha	8.772358105826164e-08	deb70d2c6e9844ad8ec9a5549a069559
reg_lambda	0.32556410395165675	deb70d2c6e9844ad8ec9a5549a069559
subsample	0.98401755980729	deb70d2c6e9844ad8ec9a5549a069559
subsample_for_bin	200000	deb70d2c6e9844ad8ec9a5549a069559
subsample_freq	0	deb70d2c6e9844ad8ec9a5549a069559
metric	['None']	deb70d2c6e9844ad8ec9a5549a069559
boosting_type	gbdt	905dc0ac6a9b46bfa4b2435798fa6880
colsample_bytree	0.5462050291918352	905dc0ac6a9b46bfa4b2435798fa6880
learning_rate	0.012950909817353124	905dc0ac6a9b46bfa4b2435798fa6880
max_depth	11	905dc0ac6a9b46bfa4b2435798fa6880
min_child_samples	168	905dc0ac6a9b46bfa4b2435798fa6880
min_child_weight	0.001	905dc0ac6a9b46bfa4b2435798fa6880
min_split_gain	0.3937997886990157	905dc0ac6a9b46bfa4b2435798fa6880
num_leaves	193	905dc0ac6a9b46bfa4b2435798fa6880
random_state	42	905dc0ac6a9b46bfa4b2435798fa6880
reg_alpha	2.939759012961695e-08	905dc0ac6a9b46bfa4b2435798fa6880
reg_lambda	0.000812372352193318	905dc0ac6a9b46bfa4b2435798fa6880
subsample	0.9601490456411649	905dc0ac6a9b46bfa4b2435798fa6880
subsample_for_bin	200000	905dc0ac6a9b46bfa4b2435798fa6880
subsample_freq	0	905dc0ac6a9b46bfa4b2435798fa6880
metric	['None']	905dc0ac6a9b46bfa4b2435798fa6880
verbosity	-1	905dc0ac6a9b46bfa4b2435798fa6880
scale_pos_weight	11.387084592145015	905dc0ac6a9b46bfa4b2435798fa6880
objective	binary	905dc0ac6a9b46bfa4b2435798fa6880
num_threads	12	905dc0ac6a9b46bfa4b2435798fa6880
num_boost_round	500	905dc0ac6a9b46bfa4b2435798fa6880
feature_name	auto	905dc0ac6a9b46bfa4b2435798fa6880
categorical_feature	auto	905dc0ac6a9b46bfa4b2435798fa6880
keep_training_booster	False	905dc0ac6a9b46bfa4b2435798fa6880
boosting_type	gbdt	3c993ea82ef44d1f91ec5ae384b63d04
colsample_bytree	0.5900404628625717	3c993ea82ef44d1f91ec5ae384b63d04
learning_rate	0.006076118660861203	3c993ea82ef44d1f91ec5ae384b63d04
max_depth	9	3c993ea82ef44d1f91ec5ae384b63d04
min_child_samples	161	3c993ea82ef44d1f91ec5ae384b63d04
min_child_weight	0.001	3c993ea82ef44d1f91ec5ae384b63d04
min_split_gain	0.6938532250072694	3c993ea82ef44d1f91ec5ae384b63d04
num_leaves	69	3c993ea82ef44d1f91ec5ae384b63d04
random_state	42	3c993ea82ef44d1f91ec5ae384b63d04
reg_alpha	3.851164488038485e-08	3c993ea82ef44d1f91ec5ae384b63d04
reg_lambda	3.0121563234709074	3c993ea82ef44d1f91ec5ae384b63d04
subsample	0.9827604719127119	3c993ea82ef44d1f91ec5ae384b63d04
subsample_for_bin	200000	3c993ea82ef44d1f91ec5ae384b63d04
subsample_freq	0	3c993ea82ef44d1f91ec5ae384b63d04
metric	['None']	3c993ea82ef44d1f91ec5ae384b63d04
verbosity	-1	3c993ea82ef44d1f91ec5ae384b63d04
scale_pos_weight	11.387084592145015	3c993ea82ef44d1f91ec5ae384b63d04
objective	binary	3c993ea82ef44d1f91ec5ae384b63d04
num_threads	12	3c993ea82ef44d1f91ec5ae384b63d04
num_boost_round	900	3c993ea82ef44d1f91ec5ae384b63d04
feature_name	auto	3c993ea82ef44d1f91ec5ae384b63d04
categorical_feature	auto	3c993ea82ef44d1f91ec5ae384b63d04
keep_training_booster	False	3c993ea82ef44d1f91ec5ae384b63d04
boosting_type	gbdt	5f4890e2fdc040bfba29e6fba7cf13de
colsample_bytree	0.5468865073174631	5f4890e2fdc040bfba29e6fba7cf13de
learning_rate	0.029336797238353956	5f4890e2fdc040bfba29e6fba7cf13de
max_depth	12	5f4890e2fdc040bfba29e6fba7cf13de
min_child_samples	177	5f4890e2fdc040bfba29e6fba7cf13de
min_child_weight	0.001	5f4890e2fdc040bfba29e6fba7cf13de
min_split_gain	0.9608865216295024	5f4890e2fdc040bfba29e6fba7cf13de
num_leaves	91	5f4890e2fdc040bfba29e6fba7cf13de
random_state	42	5f4890e2fdc040bfba29e6fba7cf13de
reg_alpha	1.1081503575735373e-06	5f4890e2fdc040bfba29e6fba7cf13de
reg_lambda	0.018403203488159832	5f4890e2fdc040bfba29e6fba7cf13de
subsample	0.9340107213444014	5f4890e2fdc040bfba29e6fba7cf13de
subsample_for_bin	200000	5f4890e2fdc040bfba29e6fba7cf13de
subsample_freq	0	5f4890e2fdc040bfba29e6fba7cf13de
metric	['None']	5f4890e2fdc040bfba29e6fba7cf13de
verbosity	-1	5f4890e2fdc040bfba29e6fba7cf13de
scale_pos_weight	11.387084592145015	5f4890e2fdc040bfba29e6fba7cf13de
objective	binary	5f4890e2fdc040bfba29e6fba7cf13de
num_threads	12	5f4890e2fdc040bfba29e6fba7cf13de
num_boost_round	1900	5f4890e2fdc040bfba29e6fba7cf13de
feature_name	auto	5f4890e2fdc040bfba29e6fba7cf13de
categorical_feature	auto	5f4890e2fdc040bfba29e6fba7cf13de
keep_training_booster	False	5f4890e2fdc040bfba29e6fba7cf13de
boosting_type	gbdt	31c19df3feba406bbe273cf28ad356ea
colsample_bytree	0.7420718292950597	31c19df3feba406bbe273cf28ad356ea
learning_rate	0.010462495225003034	31c19df3feba406bbe273cf28ad356ea
max_depth	11	31c19df3feba406bbe273cf28ad356ea
min_child_samples	176	31c19df3feba406bbe273cf28ad356ea
min_child_weight	0.001	31c19df3feba406bbe273cf28ad356ea
min_split_gain	0.7405253279074091	31c19df3feba406bbe273cf28ad356ea
num_leaves	71	31c19df3feba406bbe273cf28ad356ea
random_state	42	31c19df3feba406bbe273cf28ad356ea
reg_alpha	2.9971726100590816e-07	31c19df3feba406bbe273cf28ad356ea
reg_lambda	1.5284407214566573e-06	31c19df3feba406bbe273cf28ad356ea
subsample	0.9622812321342218	31c19df3feba406bbe273cf28ad356ea
subsample_for_bin	200000	31c19df3feba406bbe273cf28ad356ea
subsample_freq	0	31c19df3feba406bbe273cf28ad356ea
metric	['None']	31c19df3feba406bbe273cf28ad356ea
verbosity	-1	31c19df3feba406bbe273cf28ad356ea
scale_pos_weight	11.387084592145015	31c19df3feba406bbe273cf28ad356ea
objective	binary	31c19df3feba406bbe273cf28ad356ea
num_threads	12	31c19df3feba406bbe273cf28ad356ea
num_boost_round	1100	31c19df3feba406bbe273cf28ad356ea
feature_name	auto	31c19df3feba406bbe273cf28ad356ea
categorical_feature	auto	31c19df3feba406bbe273cf28ad356ea
keep_training_booster	False	31c19df3feba406bbe273cf28ad356ea
boosting_type	gbdt	06988d80ee2a49cc847b86b0ba828472
colsample_bytree	0.5999811406530352	06988d80ee2a49cc847b86b0ba828472
learning_rate	0.008101302461883649	06988d80ee2a49cc847b86b0ba828472
max_depth	8	06988d80ee2a49cc847b86b0ba828472
min_child_samples	157	06988d80ee2a49cc847b86b0ba828472
min_child_weight	0.001	06988d80ee2a49cc847b86b0ba828472
min_split_gain	0.12901648671297394	06988d80ee2a49cc847b86b0ba828472
num_leaves	32	06988d80ee2a49cc847b86b0ba828472
random_state	42	06988d80ee2a49cc847b86b0ba828472
reg_alpha	1.5477870059523288e-08	06988d80ee2a49cc847b86b0ba828472
reg_lambda	0.00030429774472021847	06988d80ee2a49cc847b86b0ba828472
subsample	0.8372765616793889	06988d80ee2a49cc847b86b0ba828472
subsample_for_bin	200000	06988d80ee2a49cc847b86b0ba828472
subsample_freq	0	06988d80ee2a49cc847b86b0ba828472
metric	['None']	06988d80ee2a49cc847b86b0ba828472
verbosity	-1	06988d80ee2a49cc847b86b0ba828472
scale_pos_weight	11.387084592145015	06988d80ee2a49cc847b86b0ba828472
objective	binary	06988d80ee2a49cc847b86b0ba828472
num_threads	12	06988d80ee2a49cc847b86b0ba828472
num_boost_round	1100	06988d80ee2a49cc847b86b0ba828472
feature_name	auto	06988d80ee2a49cc847b86b0ba828472
categorical_feature	auto	06988d80ee2a49cc847b86b0ba828472
keep_training_booster	False	06988d80ee2a49cc847b86b0ba828472
boosting_type	gbdt	884482f15ecf455cacf6203986941bd8
colsample_bytree	0.6929069411820266	884482f15ecf455cacf6203986941bd8
learning_rate	0.06727491920575297	884482f15ecf455cacf6203986941bd8
max_depth	7	884482f15ecf455cacf6203986941bd8
min_child_samples	171	884482f15ecf455cacf6203986941bd8
min_child_weight	0.001	884482f15ecf455cacf6203986941bd8
min_split_gain	0.4390788774046062	884482f15ecf455cacf6203986941bd8
num_leaves	28	884482f15ecf455cacf6203986941bd8
random_state	42	884482f15ecf455cacf6203986941bd8
reg_alpha	1.5039245846812254e-08	884482f15ecf455cacf6203986941bd8
reg_lambda	0.009842799356672384	884482f15ecf455cacf6203986941bd8
subsample	0.8822522878305241	884482f15ecf455cacf6203986941bd8
subsample_for_bin	200000	884482f15ecf455cacf6203986941bd8
subsample_freq	0	884482f15ecf455cacf6203986941bd8
metric	['None']	884482f15ecf455cacf6203986941bd8
verbosity	-1	884482f15ecf455cacf6203986941bd8
scale_pos_weight	11.387084592145015	884482f15ecf455cacf6203986941bd8
objective	binary	884482f15ecf455cacf6203986941bd8
num_threads	12	884482f15ecf455cacf6203986941bd8
num_boost_round	1300	884482f15ecf455cacf6203986941bd8
feature_name	auto	884482f15ecf455cacf6203986941bd8
categorical_feature	auto	884482f15ecf455cacf6203986941bd8
keep_training_booster	False	884482f15ecf455cacf6203986941bd8
boosting_type	gbdt	1336414e54eb49e886f22580bd301b28
colsample_bytree	0.8171998760619265	1336414e54eb49e886f22580bd301b28
learning_rate	0.019536843469512077	1336414e54eb49e886f22580bd301b28
max_depth	11	1336414e54eb49e886f22580bd301b28
min_child_samples	85	1336414e54eb49e886f22580bd301b28
min_child_weight	0.001	1336414e54eb49e886f22580bd301b28
min_split_gain	0.8734880440229557	1336414e54eb49e886f22580bd301b28
num_leaves	27	1336414e54eb49e886f22580bd301b28
random_state	42	1336414e54eb49e886f22580bd301b28
reg_alpha	2.2921370293878722e-08	1336414e54eb49e886f22580bd301b28
reg_lambda	0.027984059429983516	1336414e54eb49e886f22580bd301b28
subsample	0.9870622073927007	1336414e54eb49e886f22580bd301b28
subsample_for_bin	200000	1336414e54eb49e886f22580bd301b28
subsample_freq	0	1336414e54eb49e886f22580bd301b28
metric	['None']	1336414e54eb49e886f22580bd301b28
verbosity	-1	1336414e54eb49e886f22580bd301b28
scale_pos_weight	11.387084592145015	1336414e54eb49e886f22580bd301b28
objective	binary	1336414e54eb49e886f22580bd301b28
num_threads	12	1336414e54eb49e886f22580bd301b28
num_boost_round	1700	1336414e54eb49e886f22580bd301b28
feature_name	auto	1336414e54eb49e886f22580bd301b28
categorical_feature	auto	1336414e54eb49e886f22580bd301b28
keep_training_booster	False	1336414e54eb49e886f22580bd301b28
boosting_type	gbdt	b3547d0973f74bf49d4e595aacdb1e3b
colsample_bytree	0.5350600573683102	b3547d0973f74bf49d4e595aacdb1e3b
learning_rate	0.02060577054402945	b3547d0973f74bf49d4e595aacdb1e3b
max_depth	11	b3547d0973f74bf49d4e595aacdb1e3b
min_child_samples	185	b3547d0973f74bf49d4e595aacdb1e3b
min_child_weight	0.001	b3547d0973f74bf49d4e595aacdb1e3b
min_split_gain	0.055609930868964264	b3547d0973f74bf49d4e595aacdb1e3b
num_leaves	59	b3547d0973f74bf49d4e595aacdb1e3b
random_state	42	b3547d0973f74bf49d4e595aacdb1e3b
reg_alpha	4.9888445346091133e-08	b3547d0973f74bf49d4e595aacdb1e3b
reg_lambda	0.00023057285859657932	b3547d0973f74bf49d4e595aacdb1e3b
subsample	0.995108452838346	b3547d0973f74bf49d4e595aacdb1e3b
subsample_for_bin	200000	b3547d0973f74bf49d4e595aacdb1e3b
subsample_freq	0	b3547d0973f74bf49d4e595aacdb1e3b
metric	['None']	b3547d0973f74bf49d4e595aacdb1e3b
verbosity	-1	b3547d0973f74bf49d4e595aacdb1e3b
scale_pos_weight	11.387084592145015	b3547d0973f74bf49d4e595aacdb1e3b
objective	binary	b3547d0973f74bf49d4e595aacdb1e3b
num_threads	12	b3547d0973f74bf49d4e595aacdb1e3b
num_boost_round	900	b3547d0973f74bf49d4e595aacdb1e3b
feature_name	auto	b3547d0973f74bf49d4e595aacdb1e3b
categorical_feature	auto	b3547d0973f74bf49d4e595aacdb1e3b
keep_training_booster	False	b3547d0973f74bf49d4e595aacdb1e3b
boosting_type	gbdt	11cd7d2db6784fe4b02a7ae8f71d8cf2
colsample_bytree	0.6444896184547353	11cd7d2db6784fe4b02a7ae8f71d8cf2
learning_rate	0.039823315466301995	11cd7d2db6784fe4b02a7ae8f71d8cf2
max_depth	10	11cd7d2db6784fe4b02a7ae8f71d8cf2
min_child_samples	129	11cd7d2db6784fe4b02a7ae8f71d8cf2
min_child_weight	0.001	11cd7d2db6784fe4b02a7ae8f71d8cf2
min_split_gain	0.47565123009490934	11cd7d2db6784fe4b02a7ae8f71d8cf2
num_leaves	46	11cd7d2db6784fe4b02a7ae8f71d8cf2
random_state	42	11cd7d2db6784fe4b02a7ae8f71d8cf2
reg_alpha	0.00044956403111670086	11cd7d2db6784fe4b02a7ae8f71d8cf2
reg_lambda	0.1812604814905712	11cd7d2db6784fe4b02a7ae8f71d8cf2
subsample	0.958741240218532	11cd7d2db6784fe4b02a7ae8f71d8cf2
subsample_for_bin	200000	11cd7d2db6784fe4b02a7ae8f71d8cf2
subsample_freq	0	11cd7d2db6784fe4b02a7ae8f71d8cf2
metric	['None']	11cd7d2db6784fe4b02a7ae8f71d8cf2
verbosity	-1	11cd7d2db6784fe4b02a7ae8f71d8cf2
scale_pos_weight	11.387084592145015	11cd7d2db6784fe4b02a7ae8f71d8cf2
objective	binary	11cd7d2db6784fe4b02a7ae8f71d8cf2
num_threads	12	11cd7d2db6784fe4b02a7ae8f71d8cf2
num_boost_round	1500	11cd7d2db6784fe4b02a7ae8f71d8cf2
feature_name	auto	11cd7d2db6784fe4b02a7ae8f71d8cf2
categorical_feature	auto	11cd7d2db6784fe4b02a7ae8f71d8cf2
keep_training_booster	False	11cd7d2db6784fe4b02a7ae8f71d8cf2
boosting_type	gbdt	58b4b9d2beff44d3b6bce2af1c53b954
colsample_bytree	0.8187742201047233	58b4b9d2beff44d3b6bce2af1c53b954
learning_rate	0.007451561675999622	58b4b9d2beff44d3b6bce2af1c53b954
max_depth	11	58b4b9d2beff44d3b6bce2af1c53b954
min_child_samples	176	58b4b9d2beff44d3b6bce2af1c53b954
min_child_weight	0.001	58b4b9d2beff44d3b6bce2af1c53b954
min_split_gain	0.8329125554678293	58b4b9d2beff44d3b6bce2af1c53b954
num_leaves	107	58b4b9d2beff44d3b6bce2af1c53b954
random_state	42	58b4b9d2beff44d3b6bce2af1c53b954
reg_alpha	1.1848298800404606e-07	58b4b9d2beff44d3b6bce2af1c53b954
reg_lambda	0.0018713988134086339	58b4b9d2beff44d3b6bce2af1c53b954
subsample	0.9584031581253472	58b4b9d2beff44d3b6bce2af1c53b954
subsample_for_bin	200000	58b4b9d2beff44d3b6bce2af1c53b954
subsample_freq	0	58b4b9d2beff44d3b6bce2af1c53b954
metric	['None']	58b4b9d2beff44d3b6bce2af1c53b954
verbosity	-1	58b4b9d2beff44d3b6bce2af1c53b954
scale_pos_weight	11.387084592145015	58b4b9d2beff44d3b6bce2af1c53b954
objective	binary	58b4b9d2beff44d3b6bce2af1c53b954
num_threads	12	58b4b9d2beff44d3b6bce2af1c53b954
num_boost_round	1200	58b4b9d2beff44d3b6bce2af1c53b954
feature_name	auto	58b4b9d2beff44d3b6bce2af1c53b954
categorical_feature	auto	58b4b9d2beff44d3b6bce2af1c53b954
keep_training_booster	False	58b4b9d2beff44d3b6bce2af1c53b954
boosting_type	gbdt	a96bb954fdd64eed9d3bb56c6d5ea887
colsample_bytree	0.7273246081280466	a96bb954fdd64eed9d3bb56c6d5ea887
learning_rate	0.00810946930688221	a96bb954fdd64eed9d3bb56c6d5ea887
max_depth	11	a96bb954fdd64eed9d3bb56c6d5ea887
min_child_samples	160	a96bb954fdd64eed9d3bb56c6d5ea887
min_child_weight	0.001	a96bb954fdd64eed9d3bb56c6d5ea887
min_split_gain	0.5713339536524702	a96bb954fdd64eed9d3bb56c6d5ea887
num_leaves	138	a96bb954fdd64eed9d3bb56c6d5ea887
random_state	42	a96bb954fdd64eed9d3bb56c6d5ea887
reg_alpha	1.1418611943890426e-05	a96bb954fdd64eed9d3bb56c6d5ea887
reg_lambda	3.03431346130606e-08	a96bb954fdd64eed9d3bb56c6d5ea887
subsample	0.9764673770469179	a96bb954fdd64eed9d3bb56c6d5ea887
subsample_for_bin	200000	a96bb954fdd64eed9d3bb56c6d5ea887
subsample_freq	0	a96bb954fdd64eed9d3bb56c6d5ea887
metric	['None']	a96bb954fdd64eed9d3bb56c6d5ea887
verbosity	-1	a96bb954fdd64eed9d3bb56c6d5ea887
scale_pos_weight	11.387084592145015	a96bb954fdd64eed9d3bb56c6d5ea887
objective	binary	a96bb954fdd64eed9d3bb56c6d5ea887
num_threads	12	a96bb954fdd64eed9d3bb56c6d5ea887
num_boost_round	700	a96bb954fdd64eed9d3bb56c6d5ea887
feature_name	auto	a96bb954fdd64eed9d3bb56c6d5ea887
categorical_feature	auto	a96bb954fdd64eed9d3bb56c6d5ea887
keep_training_booster	False	a96bb954fdd64eed9d3bb56c6d5ea887
boosting_type	gbdt	ed6d527941fe49ec9efa86d9ecec40b9
colsample_bytree	0.6434318270420052	ed6d527941fe49ec9efa86d9ecec40b9
learning_rate	0.01410821721796888	ed6d527941fe49ec9efa86d9ecec40b9
max_depth	8	ed6d527941fe49ec9efa86d9ecec40b9
min_child_samples	147	ed6d527941fe49ec9efa86d9ecec40b9
min_child_weight	0.001	ed6d527941fe49ec9efa86d9ecec40b9
min_split_gain	0.710557823182027	ed6d527941fe49ec9efa86d9ecec40b9
num_leaves	44	ed6d527941fe49ec9efa86d9ecec40b9
random_state	42	ed6d527941fe49ec9efa86d9ecec40b9
reg_alpha	2.76607339292962e-06	ed6d527941fe49ec9efa86d9ecec40b9
reg_lambda	1.1173016781137549e-07	ed6d527941fe49ec9efa86d9ecec40b9
subsample	0.910504067574063	ed6d527941fe49ec9efa86d9ecec40b9
subsample_for_bin	200000	ed6d527941fe49ec9efa86d9ecec40b9
subsample_freq	0	ed6d527941fe49ec9efa86d9ecec40b9
metric	['None']	ed6d527941fe49ec9efa86d9ecec40b9
verbosity	-1	ed6d527941fe49ec9efa86d9ecec40b9
scale_pos_weight	11.387084592145015	ed6d527941fe49ec9efa86d9ecec40b9
objective	binary	ed6d527941fe49ec9efa86d9ecec40b9
num_threads	12	ed6d527941fe49ec9efa86d9ecec40b9
num_boost_round	1500	ed6d527941fe49ec9efa86d9ecec40b9
feature_name	auto	ed6d527941fe49ec9efa86d9ecec40b9
categorical_feature	auto	ed6d527941fe49ec9efa86d9ecec40b9
keep_training_booster	False	ed6d527941fe49ec9efa86d9ecec40b9
boosting_type	gbdt	9bee251d163640f4b41fe3bb301ce520
colsample_bytree	0.7237727830967822	9bee251d163640f4b41fe3bb301ce520
learning_rate	0.013393928936001442	9bee251d163640f4b41fe3bb301ce520
max_depth	10	9bee251d163640f4b41fe3bb301ce520
min_child_samples	171	9bee251d163640f4b41fe3bb301ce520
min_child_weight	0.001	9bee251d163640f4b41fe3bb301ce520
min_split_gain	0.5289129579851017	9bee251d163640f4b41fe3bb301ce520
num_leaves	31	9bee251d163640f4b41fe3bb301ce520
random_state	42	9bee251d163640f4b41fe3bb301ce520
reg_alpha	6.396562671525069e-08	9bee251d163640f4b41fe3bb301ce520
reg_lambda	0.0003231256947158786	9bee251d163640f4b41fe3bb301ce520
subsample	0.9858386334758013	9bee251d163640f4b41fe3bb301ce520
subsample_for_bin	200000	9bee251d163640f4b41fe3bb301ce520
subsample_freq	0	9bee251d163640f4b41fe3bb301ce520
metric	['None']	9bee251d163640f4b41fe3bb301ce520
verbosity	-1	9bee251d163640f4b41fe3bb301ce520
scale_pos_weight	11.387084592145015	9bee251d163640f4b41fe3bb301ce520
objective	binary	9bee251d163640f4b41fe3bb301ce520
num_threads	12	9bee251d163640f4b41fe3bb301ce520
num_boost_round	1700	9bee251d163640f4b41fe3bb301ce520
feature_name	auto	9bee251d163640f4b41fe3bb301ce520
categorical_feature	auto	9bee251d163640f4b41fe3bb301ce520
keep_training_booster	False	9bee251d163640f4b41fe3bb301ce520
boosting_type	gbdt	2918b242568447af9cdc39919fb7482a
colsample_bytree	0.6032265009941926	2918b242568447af9cdc39919fb7482a
learning_rate	0.012374093895369039	2918b242568447af9cdc39919fb7482a
max_depth	9	2918b242568447af9cdc39919fb7482a
min_child_samples	125	2918b242568447af9cdc39919fb7482a
min_child_weight	0.001	2918b242568447af9cdc39919fb7482a
min_split_gain	0.0898830995293618	2918b242568447af9cdc39919fb7482a
num_leaves	111	2918b242568447af9cdc39919fb7482a
random_state	42	2918b242568447af9cdc39919fb7482a
reg_alpha	4.443774705436987e-08	2918b242568447af9cdc39919fb7482a
reg_lambda	0.5533975528570385	2918b242568447af9cdc39919fb7482a
subsample	0.7838403588261849	2918b242568447af9cdc39919fb7482a
subsample_for_bin	200000	2918b242568447af9cdc39919fb7482a
subsample_freq	0	2918b242568447af9cdc39919fb7482a
metric	['None']	2918b242568447af9cdc39919fb7482a
verbosity	-1	2918b242568447af9cdc39919fb7482a
scale_pos_weight	11.387084592145015	2918b242568447af9cdc39919fb7482a
objective	binary	2918b242568447af9cdc39919fb7482a
num_threads	12	2918b242568447af9cdc39919fb7482a
num_boost_round	400	2918b242568447af9cdc39919fb7482a
feature_name	auto	2918b242568447af9cdc39919fb7482a
categorical_feature	auto	2918b242568447af9cdc39919fb7482a
keep_training_booster	False	2918b242568447af9cdc39919fb7482a
boosting_type	gbdt	f3039f0f77a54e3a87583ce82d69fd41
colsample_bytree	0.5553757617148805	f3039f0f77a54e3a87583ce82d69fd41
learning_rate	0.04613174372172758	f3039f0f77a54e3a87583ce82d69fd41
max_depth	12	f3039f0f77a54e3a87583ce82d69fd41
min_child_samples	183	f3039f0f77a54e3a87583ce82d69fd41
min_child_weight	0.001	f3039f0f77a54e3a87583ce82d69fd41
min_split_gain	0.552962019017778	f3039f0f77a54e3a87583ce82d69fd41
num_leaves	62	f3039f0f77a54e3a87583ce82d69fd41
random_state	42	f3039f0f77a54e3a87583ce82d69fd41
reg_alpha	3.7782377048376816e-08	f3039f0f77a54e3a87583ce82d69fd41
reg_lambda	2.790792922313562e-05	f3039f0f77a54e3a87583ce82d69fd41
subsample	0.9955718533037741	f3039f0f77a54e3a87583ce82d69fd41
subsample_for_bin	200000	f3039f0f77a54e3a87583ce82d69fd41
subsample_freq	0	f3039f0f77a54e3a87583ce82d69fd41
metric	['None']	f3039f0f77a54e3a87583ce82d69fd41
verbosity	-1	f3039f0f77a54e3a87583ce82d69fd41
scale_pos_weight	11.387084592145015	f3039f0f77a54e3a87583ce82d69fd41
objective	binary	f3039f0f77a54e3a87583ce82d69fd41
num_threads	12	f3039f0f77a54e3a87583ce82d69fd41
num_boost_round	300	f3039f0f77a54e3a87583ce82d69fd41
feature_name	auto	f3039f0f77a54e3a87583ce82d69fd41
categorical_feature	auto	f3039f0f77a54e3a87583ce82d69fd41
keep_training_booster	False	f3039f0f77a54e3a87583ce82d69fd41
boosting_type	gbdt	a8986aaa09bb45edaf20a7a2a477b6f0
colsample_bytree	0.7319322053026075	a8986aaa09bb45edaf20a7a2a477b6f0
learning_rate	0.0066529598215995375	a8986aaa09bb45edaf20a7a2a477b6f0
max_depth	11	a8986aaa09bb45edaf20a7a2a477b6f0
min_child_samples	179	a8986aaa09bb45edaf20a7a2a477b6f0
min_child_weight	0.001	a8986aaa09bb45edaf20a7a2a477b6f0
min_split_gain	0.9867290995896246	a8986aaa09bb45edaf20a7a2a477b6f0
num_leaves	77	a8986aaa09bb45edaf20a7a2a477b6f0
random_state	42	a8986aaa09bb45edaf20a7a2a477b6f0
reg_alpha	8.731971108681389e-08	a8986aaa09bb45edaf20a7a2a477b6f0
reg_lambda	1.8262232619251233	a8986aaa09bb45edaf20a7a2a477b6f0
subsample	0.8931388489651251	a8986aaa09bb45edaf20a7a2a477b6f0
subsample_for_bin	200000	a8986aaa09bb45edaf20a7a2a477b6f0
subsample_freq	0	a8986aaa09bb45edaf20a7a2a477b6f0
metric	['None']	a8986aaa09bb45edaf20a7a2a477b6f0
verbosity	-1	a8986aaa09bb45edaf20a7a2a477b6f0
scale_pos_weight	11.387084592145015	a8986aaa09bb45edaf20a7a2a477b6f0
objective	binary	a8986aaa09bb45edaf20a7a2a477b6f0
num_threads	12	a8986aaa09bb45edaf20a7a2a477b6f0
num_boost_round	1400	a8986aaa09bb45edaf20a7a2a477b6f0
feature_name	auto	a8986aaa09bb45edaf20a7a2a477b6f0
categorical_feature	auto	a8986aaa09bb45edaf20a7a2a477b6f0
keep_training_booster	False	a8986aaa09bb45edaf20a7a2a477b6f0
boosting_type	gbdt	c5d632c0f5584ef38bba13efd4e41e85
colsample_bytree	0.7300335537565241	c5d632c0f5584ef38bba13efd4e41e85
learning_rate	0.010237728932827433	c5d632c0f5584ef38bba13efd4e41e85
max_depth	12	c5d632c0f5584ef38bba13efd4e41e85
min_child_samples	200	c5d632c0f5584ef38bba13efd4e41e85
min_child_weight	0.001	c5d632c0f5584ef38bba13efd4e41e85
min_split_gain	0.8309727217751404	c5d632c0f5584ef38bba13efd4e41e85
num_leaves	48	c5d632c0f5584ef38bba13efd4e41e85
random_state	42	c5d632c0f5584ef38bba13efd4e41e85
reg_alpha	1.1581565500499842e-08	c5d632c0f5584ef38bba13efd4e41e85
reg_lambda	4.491103445327812e-07	c5d632c0f5584ef38bba13efd4e41e85
subsample	0.9945090155848271	c5d632c0f5584ef38bba13efd4e41e85
subsample_for_bin	200000	c5d632c0f5584ef38bba13efd4e41e85
subsample_freq	0	c5d632c0f5584ef38bba13efd4e41e85
metric	['None']	c5d632c0f5584ef38bba13efd4e41e85
verbosity	-1	c5d632c0f5584ef38bba13efd4e41e85
scale_pos_weight	11.387084592145015	c5d632c0f5584ef38bba13efd4e41e85
objective	binary	c5d632c0f5584ef38bba13efd4e41e85
num_threads	12	c5d632c0f5584ef38bba13efd4e41e85
num_boost_round	500	c5d632c0f5584ef38bba13efd4e41e85
feature_name	auto	c5d632c0f5584ef38bba13efd4e41e85
categorical_feature	auto	c5d632c0f5584ef38bba13efd4e41e85
keep_training_booster	False	c5d632c0f5584ef38bba13efd4e41e85
boosting_type	gbdt	d54ca38b32404c3ab9603d5c17d370be
colsample_bytree	0.5653723998791877	d54ca38b32404c3ab9603d5c17d370be
learning_rate	0.01278139100276215	d54ca38b32404c3ab9603d5c17d370be
max_depth	11	d54ca38b32404c3ab9603d5c17d370be
min_child_samples	156	d54ca38b32404c3ab9603d5c17d370be
min_child_weight	0.001	d54ca38b32404c3ab9603d5c17d370be
min_split_gain	0.49484432619684693	d54ca38b32404c3ab9603d5c17d370be
num_leaves	39	d54ca38b32404c3ab9603d5c17d370be
random_state	42	d54ca38b32404c3ab9603d5c17d370be
reg_alpha	3.527946353425657e-08	d54ca38b32404c3ab9603d5c17d370be
reg_lambda	0.0039239854123413525	d54ca38b32404c3ab9603d5c17d370be
subsample	0.9607641826021467	d54ca38b32404c3ab9603d5c17d370be
subsample_for_bin	200000	d54ca38b32404c3ab9603d5c17d370be
subsample_freq	0	d54ca38b32404c3ab9603d5c17d370be
metric	['None']	d54ca38b32404c3ab9603d5c17d370be
verbosity	-1	d54ca38b32404c3ab9603d5c17d370be
scale_pos_weight	11.387084592145015	d54ca38b32404c3ab9603d5c17d370be
objective	binary	d54ca38b32404c3ab9603d5c17d370be
num_threads	12	d54ca38b32404c3ab9603d5c17d370be
num_boost_round	300	d54ca38b32404c3ab9603d5c17d370be
feature_name	auto	d54ca38b32404c3ab9603d5c17d370be
categorical_feature	auto	d54ca38b32404c3ab9603d5c17d370be
keep_training_booster	False	d54ca38b32404c3ab9603d5c17d370be
boosting_type	gbdt	74a92f84946a40ec9f5ef59d95735532
colsample_bytree	0.716958134206343	74a92f84946a40ec9f5ef59d95735532
learning_rate	0.007862938511303982	74a92f84946a40ec9f5ef59d95735532
max_depth	12	74a92f84946a40ec9f5ef59d95735532
min_child_samples	166	74a92f84946a40ec9f5ef59d95735532
min_child_weight	0.001	74a92f84946a40ec9f5ef59d95735532
min_split_gain	0.5485651697571834	74a92f84946a40ec9f5ef59d95735532
num_leaves	29	74a92f84946a40ec9f5ef59d95735532
random_state	42	74a92f84946a40ec9f5ef59d95735532
reg_alpha	4.347709412421066e-05	74a92f84946a40ec9f5ef59d95735532
reg_lambda	0.23189274238172022	74a92f84946a40ec9f5ef59d95735532
subsample	0.8713409983827155	74a92f84946a40ec9f5ef59d95735532
subsample_for_bin	200000	74a92f84946a40ec9f5ef59d95735532
subsample_freq	0	74a92f84946a40ec9f5ef59d95735532
metric	['None']	74a92f84946a40ec9f5ef59d95735532
verbosity	-1	74a92f84946a40ec9f5ef59d95735532
scale_pos_weight	11.387084592145015	74a92f84946a40ec9f5ef59d95735532
objective	binary	74a92f84946a40ec9f5ef59d95735532
num_threads	12	74a92f84946a40ec9f5ef59d95735532
num_boost_round	1000	74a92f84946a40ec9f5ef59d95735532
feature_name	auto	74a92f84946a40ec9f5ef59d95735532
categorical_feature	auto	74a92f84946a40ec9f5ef59d95735532
keep_training_booster	False	74a92f84946a40ec9f5ef59d95735532
boosting_type	gbdt	19cbd69551b74540ae49e5172dcbd422
colsample_bytree	0.6531014724157884	19cbd69551b74540ae49e5172dcbd422
learning_rate	0.03834338815367651	19cbd69551b74540ae49e5172dcbd422
max_depth	12	19cbd69551b74540ae49e5172dcbd422
min_child_samples	181	19cbd69551b74540ae49e5172dcbd422
min_child_weight	0.001	19cbd69551b74540ae49e5172dcbd422
min_split_gain	0.7235757254088814	19cbd69551b74540ae49e5172dcbd422
num_leaves	57	19cbd69551b74540ae49e5172dcbd422
random_state	42	19cbd69551b74540ae49e5172dcbd422
reg_alpha	3.39382672084134e-08	19cbd69551b74540ae49e5172dcbd422
reg_lambda	0.00020517436865215576	19cbd69551b74540ae49e5172dcbd422
subsample	0.9338420380668095	19cbd69551b74540ae49e5172dcbd422
subsample_for_bin	200000	19cbd69551b74540ae49e5172dcbd422
subsample_freq	0	19cbd69551b74540ae49e5172dcbd422
metric	['None']	19cbd69551b74540ae49e5172dcbd422
verbosity	-1	19cbd69551b74540ae49e5172dcbd422
scale_pos_weight	11.387084592145015	19cbd69551b74540ae49e5172dcbd422
objective	binary	19cbd69551b74540ae49e5172dcbd422
num_threads	12	19cbd69551b74540ae49e5172dcbd422
num_boost_round	1100	19cbd69551b74540ae49e5172dcbd422
feature_name	auto	19cbd69551b74540ae49e5172dcbd422
categorical_feature	auto	19cbd69551b74540ae49e5172dcbd422
keep_training_booster	False	19cbd69551b74540ae49e5172dcbd422
boosting_type	gbdt	3ed8585907ef4caa8fe4d70cb6b0cc87
colsample_bytree	0.6888806359382149	3ed8585907ef4caa8fe4d70cb6b0cc87
learning_rate	0.019257679709778618	3ed8585907ef4caa8fe4d70cb6b0cc87
max_depth	11	3ed8585907ef4caa8fe4d70cb6b0cc87
min_child_samples	176	3ed8585907ef4caa8fe4d70cb6b0cc87
min_child_weight	0.001	3ed8585907ef4caa8fe4d70cb6b0cc87
min_split_gain	0.532486470104174	3ed8585907ef4caa8fe4d70cb6b0cc87
num_leaves	43	3ed8585907ef4caa8fe4d70cb6b0cc87
random_state	42	3ed8585907ef4caa8fe4d70cb6b0cc87
reg_alpha	2.735469620808165e-08	3ed8585907ef4caa8fe4d70cb6b0cc87
reg_lambda	0.2703892514016185	3ed8585907ef4caa8fe4d70cb6b0cc87
subsample	0.8917267515600074	3ed8585907ef4caa8fe4d70cb6b0cc87
subsample_for_bin	200000	3ed8585907ef4caa8fe4d70cb6b0cc87
subsample_freq	0	3ed8585907ef4caa8fe4d70cb6b0cc87
metric	['None']	3ed8585907ef4caa8fe4d70cb6b0cc87
verbosity	-1	3ed8585907ef4caa8fe4d70cb6b0cc87
scale_pos_weight	11.387084592145015	3ed8585907ef4caa8fe4d70cb6b0cc87
objective	binary	3ed8585907ef4caa8fe4d70cb6b0cc87
num_threads	12	3ed8585907ef4caa8fe4d70cb6b0cc87
num_boost_round	1300	3ed8585907ef4caa8fe4d70cb6b0cc87
feature_name	auto	3ed8585907ef4caa8fe4d70cb6b0cc87
categorical_feature	auto	3ed8585907ef4caa8fe4d70cb6b0cc87
keep_training_booster	False	3ed8585907ef4caa8fe4d70cb6b0cc87
boosting_type	gbdt	e29e156922854739b295baa6f96964b9
colsample_bytree	0.7132559129766879	e29e156922854739b295baa6f96964b9
learning_rate	0.020208026112010388	e29e156922854739b295baa6f96964b9
max_depth	11	e29e156922854739b295baa6f96964b9
min_child_samples	163	e29e156922854739b295baa6f96964b9
min_child_weight	0.001	e29e156922854739b295baa6f96964b9
min_split_gain	0.9372579756016366	e29e156922854739b295baa6f96964b9
num_leaves	24	e29e156922854739b295baa6f96964b9
random_state	42	e29e156922854739b295baa6f96964b9
reg_alpha	1.1060244152929207e-06	e29e156922854739b295baa6f96964b9
reg_lambda	0.9404033184335427	e29e156922854739b295baa6f96964b9
subsample	0.9529836197655169	e29e156922854739b295baa6f96964b9
subsample_for_bin	200000	e29e156922854739b295baa6f96964b9
subsample_freq	0	e29e156922854739b295baa6f96964b9
metric	['None']	e29e156922854739b295baa6f96964b9
verbosity	-1	e29e156922854739b295baa6f96964b9
scale_pos_weight	11.387084592145015	e29e156922854739b295baa6f96964b9
objective	binary	e29e156922854739b295baa6f96964b9
num_threads	12	e29e156922854739b295baa6f96964b9
num_boost_round	1400	e29e156922854739b295baa6f96964b9
feature_name	auto	e29e156922854739b295baa6f96964b9
categorical_feature	auto	e29e156922854739b295baa6f96964b9
keep_training_booster	False	e29e156922854739b295baa6f96964b9
boosting_type	gbdt	337c2ecc590441f4b0d4ed6e6c6d874b
colsample_bytree	0.9029461003229936	337c2ecc590441f4b0d4ed6e6c6d874b
learning_rate	0.015008408890300829	337c2ecc590441f4b0d4ed6e6c6d874b
max_depth	12	337c2ecc590441f4b0d4ed6e6c6d874b
min_child_samples	163	337c2ecc590441f4b0d4ed6e6c6d874b
min_child_weight	0.001	337c2ecc590441f4b0d4ed6e6c6d874b
min_split_gain	0.7845691523888498	337c2ecc590441f4b0d4ed6e6c6d874b
num_leaves	43	337c2ecc590441f4b0d4ed6e6c6d874b
random_state	42	337c2ecc590441f4b0d4ed6e6c6d874b
reg_alpha	1.0328919945560835e-05	337c2ecc590441f4b0d4ed6e6c6d874b
reg_lambda	4.954330796605983	337c2ecc590441f4b0d4ed6e6c6d874b
subsample	0.9867391147532169	337c2ecc590441f4b0d4ed6e6c6d874b
subsample_for_bin	200000	337c2ecc590441f4b0d4ed6e6c6d874b
subsample_freq	0	337c2ecc590441f4b0d4ed6e6c6d874b
metric	['None']	337c2ecc590441f4b0d4ed6e6c6d874b
verbosity	-1	337c2ecc590441f4b0d4ed6e6c6d874b
scale_pos_weight	11.387084592145015	337c2ecc590441f4b0d4ed6e6c6d874b
objective	binary	337c2ecc590441f4b0d4ed6e6c6d874b
num_threads	12	337c2ecc590441f4b0d4ed6e6c6d874b
num_boost_round	1300	337c2ecc590441f4b0d4ed6e6c6d874b
feature_name	auto	337c2ecc590441f4b0d4ed6e6c6d874b
categorical_feature	auto	337c2ecc590441f4b0d4ed6e6c6d874b
keep_training_booster	False	337c2ecc590441f4b0d4ed6e6c6d874b
boosting_type	gbdt	4aca56d551a8462caff8f4910dc5c067
colsample_bytree	0.6279449754041129	4aca56d551a8462caff8f4910dc5c067
learning_rate	0.022702547766408905	4aca56d551a8462caff8f4910dc5c067
max_depth	9	4aca56d551a8462caff8f4910dc5c067
min_child_samples	177	4aca56d551a8462caff8f4910dc5c067
min_child_weight	0.001	4aca56d551a8462caff8f4910dc5c067
min_split_gain	0.4012762318871443	4aca56d551a8462caff8f4910dc5c067
num_leaves	92	4aca56d551a8462caff8f4910dc5c067
random_state	42	4aca56d551a8462caff8f4910dc5c067
reg_alpha	1.9229791144678575e-07	4aca56d551a8462caff8f4910dc5c067
reg_lambda	2.6030933954141378	4aca56d551a8462caff8f4910dc5c067
subsample	0.8559636109934876	4aca56d551a8462caff8f4910dc5c067
subsample_for_bin	200000	4aca56d551a8462caff8f4910dc5c067
subsample_freq	0	4aca56d551a8462caff8f4910dc5c067
metric	['None']	4aca56d551a8462caff8f4910dc5c067
verbosity	-1	4aca56d551a8462caff8f4910dc5c067
scale_pos_weight	11.387084592145015	4aca56d551a8462caff8f4910dc5c067
objective	binary	4aca56d551a8462caff8f4910dc5c067
num_threads	12	4aca56d551a8462caff8f4910dc5c067
num_boost_round	1700	4aca56d551a8462caff8f4910dc5c067
feature_name	auto	4aca56d551a8462caff8f4910dc5c067
categorical_feature	auto	4aca56d551a8462caff8f4910dc5c067
keep_training_booster	False	4aca56d551a8462caff8f4910dc5c067
boosting_type	gbdt	4ed8356cc0124c2687e88834f4d5b105
colsample_bytree	0.6752954342829728	4ed8356cc0124c2687e88834f4d5b105
learning_rate	0.00882913769547172	4ed8356cc0124c2687e88834f4d5b105
max_depth	12	4ed8356cc0124c2687e88834f4d5b105
min_child_samples	199	4ed8356cc0124c2687e88834f4d5b105
min_child_weight	0.001	4ed8356cc0124c2687e88834f4d5b105
min_split_gain	0.5579040211177518	4ed8356cc0124c2687e88834f4d5b105
num_leaves	52	4ed8356cc0124c2687e88834f4d5b105
random_state	42	4ed8356cc0124c2687e88834f4d5b105
reg_alpha	2.9221613515801945e-08	4ed8356cc0124c2687e88834f4d5b105
reg_lambda	0.19549787350975079	4ed8356cc0124c2687e88834f4d5b105
subsample	0.9369672651056878	4ed8356cc0124c2687e88834f4d5b105
subsample_for_bin	200000	4ed8356cc0124c2687e88834f4d5b105
subsample_freq	0	4ed8356cc0124c2687e88834f4d5b105
metric	['None']	4ed8356cc0124c2687e88834f4d5b105
verbosity	-1	4ed8356cc0124c2687e88834f4d5b105
scale_pos_weight	11.387084592145015	4ed8356cc0124c2687e88834f4d5b105
objective	binary	4ed8356cc0124c2687e88834f4d5b105
num_threads	12	4ed8356cc0124c2687e88834f4d5b105
num_boost_round	1800	4ed8356cc0124c2687e88834f4d5b105
feature_name	auto	4ed8356cc0124c2687e88834f4d5b105
categorical_feature	auto	4ed8356cc0124c2687e88834f4d5b105
keep_training_booster	False	4ed8356cc0124c2687e88834f4d5b105
boosting_type	gbdt	bb2f576d862c4a68b3b67f55ee6e56e3
colsample_bytree	0.6461335163766199	bb2f576d862c4a68b3b67f55ee6e56e3
learning_rate	0.0058404211586281585	bb2f576d862c4a68b3b67f55ee6e56e3
max_depth	10	bb2f576d862c4a68b3b67f55ee6e56e3
min_child_samples	147	bb2f576d862c4a68b3b67f55ee6e56e3
min_child_weight	0.001	bb2f576d862c4a68b3b67f55ee6e56e3
min_split_gain	0.8424484301380697	bb2f576d862c4a68b3b67f55ee6e56e3
num_leaves	22	bb2f576d862c4a68b3b67f55ee6e56e3
random_state	42	bb2f576d862c4a68b3b67f55ee6e56e3
reg_alpha	1.562200335938579e-08	bb2f576d862c4a68b3b67f55ee6e56e3
reg_lambda	0.7796632659743427	bb2f576d862c4a68b3b67f55ee6e56e3
subsample	0.9548446769673575	bb2f576d862c4a68b3b67f55ee6e56e3
subsample_for_bin	200000	bb2f576d862c4a68b3b67f55ee6e56e3
subsample_freq	0	bb2f576d862c4a68b3b67f55ee6e56e3
metric	['None']	bb2f576d862c4a68b3b67f55ee6e56e3
verbosity	-1	bb2f576d862c4a68b3b67f55ee6e56e3
scale_pos_weight	11.387084592145015	bb2f576d862c4a68b3b67f55ee6e56e3
objective	binary	bb2f576d862c4a68b3b67f55ee6e56e3
num_threads	12	bb2f576d862c4a68b3b67f55ee6e56e3
num_boost_round	2000	bb2f576d862c4a68b3b67f55ee6e56e3
feature_name	auto	bb2f576d862c4a68b3b67f55ee6e56e3
categorical_feature	auto	bb2f576d862c4a68b3b67f55ee6e56e3
keep_training_booster	False	bb2f576d862c4a68b3b67f55ee6e56e3
boosting_type	gbdt	d4ffdfcc60964dc2a44d6526250c8242
colsample_bytree	0.8275583983982175	d4ffdfcc60964dc2a44d6526250c8242
learning_rate	0.03642018042987162	d4ffdfcc60964dc2a44d6526250c8242
max_depth	11	d4ffdfcc60964dc2a44d6526250c8242
min_child_samples	140	d4ffdfcc60964dc2a44d6526250c8242
min_child_weight	0.001	d4ffdfcc60964dc2a44d6526250c8242
min_split_gain	0.9589558057907516	d4ffdfcc60964dc2a44d6526250c8242
num_leaves	35	d4ffdfcc60964dc2a44d6526250c8242
random_state	42	d4ffdfcc60964dc2a44d6526250c8242
reg_alpha	6.259686438003258e-08	d4ffdfcc60964dc2a44d6526250c8242
reg_lambda	7.678497671640728	d4ffdfcc60964dc2a44d6526250c8242
subsample	0.8388741812197078	d4ffdfcc60964dc2a44d6526250c8242
subsample_for_bin	200000	d4ffdfcc60964dc2a44d6526250c8242
subsample_freq	0	d4ffdfcc60964dc2a44d6526250c8242
metric	['None']	d4ffdfcc60964dc2a44d6526250c8242
verbosity	-1	d4ffdfcc60964dc2a44d6526250c8242
scale_pos_weight	11.387084592145015	d4ffdfcc60964dc2a44d6526250c8242
objective	binary	d4ffdfcc60964dc2a44d6526250c8242
num_threads	12	d4ffdfcc60964dc2a44d6526250c8242
num_boost_round	1100	d4ffdfcc60964dc2a44d6526250c8242
feature_name	auto	d4ffdfcc60964dc2a44d6526250c8242
categorical_feature	auto	d4ffdfcc60964dc2a44d6526250c8242
keep_training_booster	False	d4ffdfcc60964dc2a44d6526250c8242
boosting_type	gbdt	5094306f911645f7960433fa475f3906
colsample_bytree	0.5368944478034514	5094306f911645f7960433fa475f3906
learning_rate	0.009143507231634106	5094306f911645f7960433fa475f3906
max_depth	12	5094306f911645f7960433fa475f3906
min_child_samples	179	5094306f911645f7960433fa475f3906
min_child_weight	0.001	5094306f911645f7960433fa475f3906
min_split_gain	0.48504523891280604	5094306f911645f7960433fa475f3906
num_leaves	86	5094306f911645f7960433fa475f3906
random_state	42	5094306f911645f7960433fa475f3906
reg_alpha	8.431621620338924e-08	5094306f911645f7960433fa475f3906
reg_lambda	0.028562043719592242	5094306f911645f7960433fa475f3906
subsample	0.9478107677647767	5094306f911645f7960433fa475f3906
subsample_for_bin	200000	5094306f911645f7960433fa475f3906
subsample_freq	0	5094306f911645f7960433fa475f3906
metric	['None']	5094306f911645f7960433fa475f3906
verbosity	-1	5094306f911645f7960433fa475f3906
scale_pos_weight	11.387084592145015	5094306f911645f7960433fa475f3906
objective	binary	5094306f911645f7960433fa475f3906
num_threads	12	5094306f911645f7960433fa475f3906
num_boost_round	2000	5094306f911645f7960433fa475f3906
feature_name	auto	5094306f911645f7960433fa475f3906
categorical_feature	auto	5094306f911645f7960433fa475f3906
keep_training_booster	False	5094306f911645f7960433fa475f3906
boosting_type	gbdt	c15aab38a0b749289678168eed8a375f
colsample_bytree	0.6823373789098937	c15aab38a0b749289678168eed8a375f
learning_rate	0.00726104244024699	c15aab38a0b749289678168eed8a375f
max_depth	12	c15aab38a0b749289678168eed8a375f
min_child_samples	198	c15aab38a0b749289678168eed8a375f
min_child_weight	0.001	c15aab38a0b749289678168eed8a375f
min_split_gain	0.44364627783810845	c15aab38a0b749289678168eed8a375f
num_leaves	30	c15aab38a0b749289678168eed8a375f
random_state	42	c15aab38a0b749289678168eed8a375f
reg_alpha	1.4960069428052956e-08	c15aab38a0b749289678168eed8a375f
reg_lambda	0.5188424361454649	c15aab38a0b749289678168eed8a375f
subsample	0.8353423447438755	c15aab38a0b749289678168eed8a375f
subsample_for_bin	200000	c15aab38a0b749289678168eed8a375f
subsample_freq	0	c15aab38a0b749289678168eed8a375f
metric	['None']	c15aab38a0b749289678168eed8a375f
verbosity	-1	c15aab38a0b749289678168eed8a375f
scale_pos_weight	11.387084592145015	c15aab38a0b749289678168eed8a375f
objective	binary	c15aab38a0b749289678168eed8a375f
num_threads	12	c15aab38a0b749289678168eed8a375f
num_boost_round	1500	c15aab38a0b749289678168eed8a375f
feature_name	auto	c15aab38a0b749289678168eed8a375f
categorical_feature	auto	c15aab38a0b749289678168eed8a375f
keep_training_booster	False	c15aab38a0b749289678168eed8a375f
boosting_type	gbdt	0f8c5f9035b34684adc09c8445ef8cea
colsample_bytree	0.5027607483379822	0f8c5f9035b34684adc09c8445ef8cea
learning_rate	0.08429042286968393	0f8c5f9035b34684adc09c8445ef8cea
max_depth	8	0f8c5f9035b34684adc09c8445ef8cea
min_child_samples	197	0f8c5f9035b34684adc09c8445ef8cea
min_child_weight	0.001	0f8c5f9035b34684adc09c8445ef8cea
min_split_gain	0.9651970443054538	0f8c5f9035b34684adc09c8445ef8cea
num_leaves	59	0f8c5f9035b34684adc09c8445ef8cea
random_state	42	0f8c5f9035b34684adc09c8445ef8cea
reg_alpha	2.5654759585986986e-06	0f8c5f9035b34684adc09c8445ef8cea
reg_lambda	1.1215070823077788	0f8c5f9035b34684adc09c8445ef8cea
subsample	0.9118345071619125	0f8c5f9035b34684adc09c8445ef8cea
subsample_for_bin	200000	0f8c5f9035b34684adc09c8445ef8cea
subsample_freq	0	0f8c5f9035b34684adc09c8445ef8cea
metric	['None']	0f8c5f9035b34684adc09c8445ef8cea
verbosity	-1	0f8c5f9035b34684adc09c8445ef8cea
scale_pos_weight	11.387084592145015	0f8c5f9035b34684adc09c8445ef8cea
objective	binary	0f8c5f9035b34684adc09c8445ef8cea
num_threads	12	0f8c5f9035b34684adc09c8445ef8cea
num_boost_round	1300	0f8c5f9035b34684adc09c8445ef8cea
feature_name	auto	0f8c5f9035b34684adc09c8445ef8cea
categorical_feature	auto	0f8c5f9035b34684adc09c8445ef8cea
keep_training_booster	False	0f8c5f9035b34684adc09c8445ef8cea
boosting_type	gbdt	5f60cb1e96ef4d32aba7cf2ba79d8aa2
colsample_bytree	0.6292626091317369	5f60cb1e96ef4d32aba7cf2ba79d8aa2
learning_rate	0.029924919439375367	5f60cb1e96ef4d32aba7cf2ba79d8aa2
max_depth	11	5f60cb1e96ef4d32aba7cf2ba79d8aa2
min_child_samples	195	5f60cb1e96ef4d32aba7cf2ba79d8aa2
min_child_weight	0.001	5f60cb1e96ef4d32aba7cf2ba79d8aa2
min_split_gain	0.5362309619921906	5f60cb1e96ef4d32aba7cf2ba79d8aa2
num_leaves	23	5f60cb1e96ef4d32aba7cf2ba79d8aa2
random_state	42	5f60cb1e96ef4d32aba7cf2ba79d8aa2
reg_alpha	4.469351615652451e-08	5f60cb1e96ef4d32aba7cf2ba79d8aa2
reg_lambda	0.016217864859735816	5f60cb1e96ef4d32aba7cf2ba79d8aa2
subsample	0.9611374320920424	5f60cb1e96ef4d32aba7cf2ba79d8aa2
subsample_for_bin	200000	5f60cb1e96ef4d32aba7cf2ba79d8aa2
subsample_freq	0	5f60cb1e96ef4d32aba7cf2ba79d8aa2
metric	['None']	5f60cb1e96ef4d32aba7cf2ba79d8aa2
verbosity	-1	5f60cb1e96ef4d32aba7cf2ba79d8aa2
scale_pos_weight	11.387084592145015	5f60cb1e96ef4d32aba7cf2ba79d8aa2
objective	binary	5f60cb1e96ef4d32aba7cf2ba79d8aa2
num_threads	12	5f60cb1e96ef4d32aba7cf2ba79d8aa2
num_boost_round	700	5f60cb1e96ef4d32aba7cf2ba79d8aa2
feature_name	auto	5f60cb1e96ef4d32aba7cf2ba79d8aa2
categorical_feature	auto	5f60cb1e96ef4d32aba7cf2ba79d8aa2
keep_training_booster	False	5f60cb1e96ef4d32aba7cf2ba79d8aa2
verbosity	-1	deb70d2c6e9844ad8ec9a5549a069559
scale_pos_weight	11.387084592145015	deb70d2c6e9844ad8ec9a5549a069559
objective	binary	deb70d2c6e9844ad8ec9a5549a069559
num_threads	12	deb70d2c6e9844ad8ec9a5549a069559
num_boost_round	1600	deb70d2c6e9844ad8ec9a5549a069559
feature_name	auto	deb70d2c6e9844ad8ec9a5549a069559
categorical_feature	auto	deb70d2c6e9844ad8ec9a5549a069559
keep_training_booster	False	deb70d2c6e9844ad8ec9a5549a069559
boosting_type	gbdt	651dd8509db8453e9b57f0db626a0bc0
colsample_bytree	0.5058324048907508	651dd8509db8453e9b57f0db626a0bc0
learning_rate	0.02210439489373708	651dd8509db8453e9b57f0db626a0bc0
max_depth	8	651dd8509db8453e9b57f0db626a0bc0
min_child_samples	200	651dd8509db8453e9b57f0db626a0bc0
min_child_weight	0.001	651dd8509db8453e9b57f0db626a0bc0
min_split_gain	0.5006677575585757	651dd8509db8453e9b57f0db626a0bc0
num_leaves	28	651dd8509db8453e9b57f0db626a0bc0
random_state	42	651dd8509db8453e9b57f0db626a0bc0
reg_alpha	1.560218721704164e-07	651dd8509db8453e9b57f0db626a0bc0
reg_lambda	0.02893026406554692	651dd8509db8453e9b57f0db626a0bc0
subsample	0.9995094526767618	651dd8509db8453e9b57f0db626a0bc0
subsample_for_bin	200000	651dd8509db8453e9b57f0db626a0bc0
subsample_freq	0	651dd8509db8453e9b57f0db626a0bc0
metric	['None']	651dd8509db8453e9b57f0db626a0bc0
verbosity	-1	651dd8509db8453e9b57f0db626a0bc0
boosting_type	gbdt	e094133c648a4dcf978411aa6d5934e7
boosting_type	gbdt	a66a3b993e8c4892807fe3212c6626d1
colsample_bytree	0.6698271540700842	a66a3b993e8c4892807fe3212c6626d1
learning_rate	0.018496519789609662	a66a3b993e8c4892807fe3212c6626d1
max_depth	11	a66a3b993e8c4892807fe3212c6626d1
min_child_samples	170	a66a3b993e8c4892807fe3212c6626d1
min_child_weight	0.001	a66a3b993e8c4892807fe3212c6626d1
min_split_gain	0.9204379634001604	a66a3b993e8c4892807fe3212c6626d1
num_leaves	52	a66a3b993e8c4892807fe3212c6626d1
random_state	42	a66a3b993e8c4892807fe3212c6626d1
reg_alpha	0.008254234528821182	a66a3b993e8c4892807fe3212c6626d1
reg_lambda	0.16628882762723923	a66a3b993e8c4892807fe3212c6626d1
subsample	0.8906618330282201	a66a3b993e8c4892807fe3212c6626d1
subsample_for_bin	200000	a66a3b993e8c4892807fe3212c6626d1
subsample_freq	0	a66a3b993e8c4892807fe3212c6626d1
metric	['None']	a66a3b993e8c4892807fe3212c6626d1
verbosity	-1	a66a3b993e8c4892807fe3212c6626d1
scale_pos_weight	11.387084592145015	a66a3b993e8c4892807fe3212c6626d1
objective	binary	a66a3b993e8c4892807fe3212c6626d1
num_threads	12	a66a3b993e8c4892807fe3212c6626d1
num_boost_round	1200	a66a3b993e8c4892807fe3212c6626d1
feature_name	auto	a66a3b993e8c4892807fe3212c6626d1
categorical_feature	auto	a66a3b993e8c4892807fe3212c6626d1
keep_training_booster	False	a66a3b993e8c4892807fe3212c6626d1
boosting_type	gbdt	5c42167498f34202a2d02f90db37735d
colsample_bytree	0.5616003653259288	5c42167498f34202a2d02f90db37735d
learning_rate	0.019868949486179437	5c42167498f34202a2d02f90db37735d
max_depth	12	5c42167498f34202a2d02f90db37735d
min_child_samples	119	5c42167498f34202a2d02f90db37735d
min_child_weight	0.001	5c42167498f34202a2d02f90db37735d
min_split_gain	0.3602299442326387	5c42167498f34202a2d02f90db37735d
num_leaves	58	5c42167498f34202a2d02f90db37735d
random_state	42	5c42167498f34202a2d02f90db37735d
reg_alpha	1.1645443355548444e-08	5c42167498f34202a2d02f90db37735d
reg_lambda	0.3462869748014668	5c42167498f34202a2d02f90db37735d
subsample	0.9325320974488711	5c42167498f34202a2d02f90db37735d
subsample_for_bin	200000	5c42167498f34202a2d02f90db37735d
subsample_freq	0	5c42167498f34202a2d02f90db37735d
metric	['None']	5c42167498f34202a2d02f90db37735d
verbosity	-1	5c42167498f34202a2d02f90db37735d
scale_pos_weight	11.387084592145015	5c42167498f34202a2d02f90db37735d
objective	binary	5c42167498f34202a2d02f90db37735d
num_threads	12	5c42167498f34202a2d02f90db37735d
num_boost_round	800	5c42167498f34202a2d02f90db37735d
feature_name	auto	5c42167498f34202a2d02f90db37735d
categorical_feature	auto	5c42167498f34202a2d02f90db37735d
keep_training_booster	False	5c42167498f34202a2d02f90db37735d
boosting_type	gbdt	802c5ed50bad4391bbb5c72644ab5629
colsample_bytree	0.5956494293852446	802c5ed50bad4391bbb5c72644ab5629
learning_rate	0.029021927083287158	802c5ed50bad4391bbb5c72644ab5629
max_depth	12	802c5ed50bad4391bbb5c72644ab5629
min_child_samples	93	802c5ed50bad4391bbb5c72644ab5629
min_child_weight	0.001	802c5ed50bad4391bbb5c72644ab5629
min_split_gain	0.20445000108271874	802c5ed50bad4391bbb5c72644ab5629
num_leaves	75	802c5ed50bad4391bbb5c72644ab5629
random_state	42	802c5ed50bad4391bbb5c72644ab5629
reg_alpha	3.7173622269197343e-07	802c5ed50bad4391bbb5c72644ab5629
reg_lambda	4.382928133128613	802c5ed50bad4391bbb5c72644ab5629
subsample	0.9626947368419163	802c5ed50bad4391bbb5c72644ab5629
subsample_for_bin	200000	802c5ed50bad4391bbb5c72644ab5629
subsample_freq	0	802c5ed50bad4391bbb5c72644ab5629
metric	['None']	802c5ed50bad4391bbb5c72644ab5629
verbosity	-1	802c5ed50bad4391bbb5c72644ab5629
scale_pos_weight	11.387084592145015	802c5ed50bad4391bbb5c72644ab5629
objective	binary	802c5ed50bad4391bbb5c72644ab5629
num_threads	12	802c5ed50bad4391bbb5c72644ab5629
num_boost_round	600	802c5ed50bad4391bbb5c72644ab5629
feature_name	auto	802c5ed50bad4391bbb5c72644ab5629
categorical_feature	auto	802c5ed50bad4391bbb5c72644ab5629
keep_training_booster	False	802c5ed50bad4391bbb5c72644ab5629
boosting_type	gbdt	b8c92046e4d64195892f204054da11ee
colsample_bytree	0.5284856661351709	b8c92046e4d64195892f204054da11ee
learning_rate	0.026106286065717438	b8c92046e4d64195892f204054da11ee
max_depth	12	b8c92046e4d64195892f204054da11ee
min_child_samples	199	b8c92046e4d64195892f204054da11ee
min_child_weight	0.001	b8c92046e4d64195892f204054da11ee
min_split_gain	0.32575355826861546	b8c92046e4d64195892f204054da11ee
num_leaves	63	b8c92046e4d64195892f204054da11ee
random_state	42	b8c92046e4d64195892f204054da11ee
reg_alpha	2.932475234791457e-08	b8c92046e4d64195892f204054da11ee
reg_lambda	1.3085698336698057	b8c92046e4d64195892f204054da11ee
subsample	0.9186011109283899	b8c92046e4d64195892f204054da11ee
subsample_for_bin	200000	b8c92046e4d64195892f204054da11ee
subsample_freq	0	b8c92046e4d64195892f204054da11ee
metric	['None']	b8c92046e4d64195892f204054da11ee
verbosity	-1	b8c92046e4d64195892f204054da11ee
scale_pos_weight	11.387084592145015	b8c92046e4d64195892f204054da11ee
objective	binary	b8c92046e4d64195892f204054da11ee
num_threads	12	b8c92046e4d64195892f204054da11ee
num_boost_round	600	b8c92046e4d64195892f204054da11ee
feature_name	auto	b8c92046e4d64195892f204054da11ee
categorical_feature	auto	b8c92046e4d64195892f204054da11ee
keep_training_booster	False	b8c92046e4d64195892f204054da11ee
boosting_type	gbdt	6558904b55d747dcbb1151b72104deda
colsample_bytree	0.5329590526283888	6558904b55d747dcbb1151b72104deda
learning_rate	0.022070399089194646	6558904b55d747dcbb1151b72104deda
max_depth	11	6558904b55d747dcbb1151b72104deda
min_child_samples	120	6558904b55d747dcbb1151b72104deda
min_child_weight	0.001	6558904b55d747dcbb1151b72104deda
min_split_gain	0.2616162472642224	6558904b55d747dcbb1151b72104deda
num_leaves	28	6558904b55d747dcbb1151b72104deda
random_state	42	6558904b55d747dcbb1151b72104deda
reg_alpha	8.349444316195358e-08	6558904b55d747dcbb1151b72104deda
reg_lambda	0.23344743454482092	6558904b55d747dcbb1151b72104deda
subsample	0.8603448652926909	6558904b55d747dcbb1151b72104deda
subsample_for_bin	200000	6558904b55d747dcbb1151b72104deda
subsample_freq	0	6558904b55d747dcbb1151b72104deda
metric	['None']	6558904b55d747dcbb1151b72104deda
verbosity	-1	6558904b55d747dcbb1151b72104deda
scale_pos_weight	11.387084592145015	6558904b55d747dcbb1151b72104deda
objective	binary	6558904b55d747dcbb1151b72104deda
num_threads	12	6558904b55d747dcbb1151b72104deda
num_boost_round	1300	6558904b55d747dcbb1151b72104deda
feature_name	auto	6558904b55d747dcbb1151b72104deda
categorical_feature	auto	6558904b55d747dcbb1151b72104deda
keep_training_booster	False	6558904b55d747dcbb1151b72104deda
boosting_type	gbdt	70213c72967b441a8ecd0ad831f5b776
colsample_bytree	0.6461529299845045	70213c72967b441a8ecd0ad831f5b776
learning_rate	0.013867200543441259	70213c72967b441a8ecd0ad831f5b776
max_depth	9	70213c72967b441a8ecd0ad831f5b776
min_child_samples	168	70213c72967b441a8ecd0ad831f5b776
min_child_weight	0.001	70213c72967b441a8ecd0ad831f5b776
min_split_gain	0.9307240396765483	70213c72967b441a8ecd0ad831f5b776
num_leaves	107	70213c72967b441a8ecd0ad831f5b776
random_state	42	70213c72967b441a8ecd0ad831f5b776
reg_alpha	8.832588269965337e-07	70213c72967b441a8ecd0ad831f5b776
reg_lambda	0.024379313225592412	70213c72967b441a8ecd0ad831f5b776
subsample	0.9573043552542423	70213c72967b441a8ecd0ad831f5b776
subsample_for_bin	200000	70213c72967b441a8ecd0ad831f5b776
subsample_freq	0	70213c72967b441a8ecd0ad831f5b776
metric	['None']	70213c72967b441a8ecd0ad831f5b776
verbosity	-1	70213c72967b441a8ecd0ad831f5b776
scale_pos_weight	11.387084592145015	70213c72967b441a8ecd0ad831f5b776
objective	binary	70213c72967b441a8ecd0ad831f5b776
num_threads	12	70213c72967b441a8ecd0ad831f5b776
num_boost_round	1300	70213c72967b441a8ecd0ad831f5b776
feature_name	auto	70213c72967b441a8ecd0ad831f5b776
categorical_feature	auto	70213c72967b441a8ecd0ad831f5b776
keep_training_booster	False	70213c72967b441a8ecd0ad831f5b776
boosting_type	gbdt	10f0304d917b4d91a53520741a9f09f3
colsample_bytree	0.7250102728390222	10f0304d917b4d91a53520741a9f09f3
learning_rate	0.04637007487417106	10f0304d917b4d91a53520741a9f09f3
max_depth	11	10f0304d917b4d91a53520741a9f09f3
min_child_samples	180	10f0304d917b4d91a53520741a9f09f3
min_child_weight	0.001	10f0304d917b4d91a53520741a9f09f3
min_split_gain	0.9059383353888769	10f0304d917b4d91a53520741a9f09f3
num_leaves	73	10f0304d917b4d91a53520741a9f09f3
random_state	42	10f0304d917b4d91a53520741a9f09f3
reg_alpha	6.7462418495216744e-06	10f0304d917b4d91a53520741a9f09f3
reg_lambda	4.977642421780459	10f0304d917b4d91a53520741a9f09f3
subsample	0.935246922881014	10f0304d917b4d91a53520741a9f09f3
subsample_for_bin	200000	10f0304d917b4d91a53520741a9f09f3
subsample_freq	0	10f0304d917b4d91a53520741a9f09f3
metric	['None']	10f0304d917b4d91a53520741a9f09f3
verbosity	-1	10f0304d917b4d91a53520741a9f09f3
scale_pos_weight	11.387084592145015	10f0304d917b4d91a53520741a9f09f3
objective	binary	10f0304d917b4d91a53520741a9f09f3
num_threads	12	10f0304d917b4d91a53520741a9f09f3
num_boost_round	1300	10f0304d917b4d91a53520741a9f09f3
feature_name	auto	10f0304d917b4d91a53520741a9f09f3
categorical_feature	auto	10f0304d917b4d91a53520741a9f09f3
keep_training_booster	False	10f0304d917b4d91a53520741a9f09f3
boosting_type	gbdt	08f786cb8efb4f64b9a2607fd6ca5ee5
colsample_bytree	0.5590191421000466	08f786cb8efb4f64b9a2607fd6ca5ee5
learning_rate	0.006603700389004963	08f786cb8efb4f64b9a2607fd6ca5ee5
max_depth	12	08f786cb8efb4f64b9a2607fd6ca5ee5
min_child_samples	199	08f786cb8efb4f64b9a2607fd6ca5ee5
min_child_weight	0.001	08f786cb8efb4f64b9a2607fd6ca5ee5
min_split_gain	0.41681342081108763	08f786cb8efb4f64b9a2607fd6ca5ee5
num_leaves	46	08f786cb8efb4f64b9a2607fd6ca5ee5
random_state	42	08f786cb8efb4f64b9a2607fd6ca5ee5
reg_alpha	1.2078258445103213e-06	08f786cb8efb4f64b9a2607fd6ca5ee5
reg_lambda	0.00027797859411197285	08f786cb8efb4f64b9a2607fd6ca5ee5
subsample	0.9881900965100113	08f786cb8efb4f64b9a2607fd6ca5ee5
subsample_for_bin	200000	08f786cb8efb4f64b9a2607fd6ca5ee5
subsample_freq	0	08f786cb8efb4f64b9a2607fd6ca5ee5
metric	['None']	08f786cb8efb4f64b9a2607fd6ca5ee5
verbosity	-1	08f786cb8efb4f64b9a2607fd6ca5ee5
scale_pos_weight	11.387084592145015	08f786cb8efb4f64b9a2607fd6ca5ee5
objective	binary	08f786cb8efb4f64b9a2607fd6ca5ee5
num_threads	12	08f786cb8efb4f64b9a2607fd6ca5ee5
num_boost_round	700	08f786cb8efb4f64b9a2607fd6ca5ee5
feature_name	auto	08f786cb8efb4f64b9a2607fd6ca5ee5
categorical_feature	auto	08f786cb8efb4f64b9a2607fd6ca5ee5
keep_training_booster	False	08f786cb8efb4f64b9a2607fd6ca5ee5
boosting_type	gbdt	d1000f6e85de4fe2a8c95dc022bdab8f
boosting_type	gbdt	23f4f5b6b75745cbbfb0974a54367678
colsample_bytree	0.5924275612789519	23f4f5b6b75745cbbfb0974a54367678
learning_rate	0.027321720547806478	23f4f5b6b75745cbbfb0974a54367678
max_depth	10	23f4f5b6b75745cbbfb0974a54367678
min_child_samples	121	23f4f5b6b75745cbbfb0974a54367678
min_child_weight	0.001	23f4f5b6b75745cbbfb0974a54367678
min_split_gain	0.8569214500555228	23f4f5b6b75745cbbfb0974a54367678
num_leaves	44	23f4f5b6b75745cbbfb0974a54367678
random_state	42	23f4f5b6b75745cbbfb0974a54367678
reg_alpha	5.3190110418448e-06	23f4f5b6b75745cbbfb0974a54367678
reg_lambda	8.477444441115797	23f4f5b6b75745cbbfb0974a54367678
subsample	0.9387457499729779	23f4f5b6b75745cbbfb0974a54367678
subsample_for_bin	200000	23f4f5b6b75745cbbfb0974a54367678
subsample_freq	0	23f4f5b6b75745cbbfb0974a54367678
metric	['None']	23f4f5b6b75745cbbfb0974a54367678
verbosity	-1	23f4f5b6b75745cbbfb0974a54367678
scale_pos_weight	11.387084592145015	23f4f5b6b75745cbbfb0974a54367678
objective	binary	23f4f5b6b75745cbbfb0974a54367678
num_threads	12	23f4f5b6b75745cbbfb0974a54367678
num_boost_round	900	23f4f5b6b75745cbbfb0974a54367678
feature_name	auto	23f4f5b6b75745cbbfb0974a54367678
categorical_feature	auto	23f4f5b6b75745cbbfb0974a54367678
keep_training_booster	False	23f4f5b6b75745cbbfb0974a54367678
boosting_type	gbdt	979923580d5349d5968ee3fbca0c330a
colsample_bytree	0.8111023787053867	979923580d5349d5968ee3fbca0c330a
learning_rate	0.020143779138301385	979923580d5349d5968ee3fbca0c330a
max_depth	12	979923580d5349d5968ee3fbca0c330a
min_child_samples	160	979923580d5349d5968ee3fbca0c330a
min_child_weight	0.001	979923580d5349d5968ee3fbca0c330a
min_split_gain	0.43313943101683305	979923580d5349d5968ee3fbca0c330a
num_leaves	80	979923580d5349d5968ee3fbca0c330a
random_state	42	979923580d5349d5968ee3fbca0c330a
reg_alpha	4.655971282491279e-08	979923580d5349d5968ee3fbca0c330a
reg_lambda	4.717204648105889	979923580d5349d5968ee3fbca0c330a
subsample	0.8921319165500052	979923580d5349d5968ee3fbca0c330a
subsample_for_bin	200000	979923580d5349d5968ee3fbca0c330a
subsample_freq	0	979923580d5349d5968ee3fbca0c330a
metric	['None']	979923580d5349d5968ee3fbca0c330a
verbosity	-1	979923580d5349d5968ee3fbca0c330a
scale_pos_weight	11.387084592145015	979923580d5349d5968ee3fbca0c330a
objective	binary	979923580d5349d5968ee3fbca0c330a
num_threads	12	979923580d5349d5968ee3fbca0c330a
num_boost_round	1700	979923580d5349d5968ee3fbca0c330a
feature_name	auto	979923580d5349d5968ee3fbca0c330a
categorical_feature	auto	979923580d5349d5968ee3fbca0c330a
keep_training_booster	False	979923580d5349d5968ee3fbca0c330a
boosting_type	gbdt	bc0ab96304f34a6c848f80daf1fb9a6e
colsample_bytree	0.7189683094686521	bc0ab96304f34a6c848f80daf1fb9a6e
learning_rate	0.04760053540932268	bc0ab96304f34a6c848f80daf1fb9a6e
max_depth	11	bc0ab96304f34a6c848f80daf1fb9a6e
min_child_samples	177	bc0ab96304f34a6c848f80daf1fb9a6e
min_child_weight	0.001	bc0ab96304f34a6c848f80daf1fb9a6e
min_split_gain	0.9433374131737714	bc0ab96304f34a6c848f80daf1fb9a6e
num_leaves	20	bc0ab96304f34a6c848f80daf1fb9a6e
random_state	42	bc0ab96304f34a6c848f80daf1fb9a6e
reg_alpha	1.2485065745840748e-05	bc0ab96304f34a6c848f80daf1fb9a6e
reg_lambda	0.24973674774457516	bc0ab96304f34a6c848f80daf1fb9a6e
subsample	0.8755691385839977	bc0ab96304f34a6c848f80daf1fb9a6e
subsample_for_bin	200000	bc0ab96304f34a6c848f80daf1fb9a6e
subsample_freq	0	bc0ab96304f34a6c848f80daf1fb9a6e
metric	['None']	bc0ab96304f34a6c848f80daf1fb9a6e
verbosity	-1	bc0ab96304f34a6c848f80daf1fb9a6e
scale_pos_weight	11.387084592145015	bc0ab96304f34a6c848f80daf1fb9a6e
objective	binary	bc0ab96304f34a6c848f80daf1fb9a6e
num_threads	12	bc0ab96304f34a6c848f80daf1fb9a6e
num_boost_round	2000	bc0ab96304f34a6c848f80daf1fb9a6e
feature_name	auto	bc0ab96304f34a6c848f80daf1fb9a6e
categorical_feature	auto	bc0ab96304f34a6c848f80daf1fb9a6e
keep_training_booster	False	bc0ab96304f34a6c848f80daf1fb9a6e
boosting_type	gbdt	b58e93020e20438db09d29ad3c13df59
colsample_bytree	0.6361170527293197	b58e93020e20438db09d29ad3c13df59
learning_rate	0.01680330246566231	b58e93020e20438db09d29ad3c13df59
max_depth	10	b58e93020e20438db09d29ad3c13df59
min_child_samples	189	b58e93020e20438db09d29ad3c13df59
min_child_weight	0.001	b58e93020e20438db09d29ad3c13df59
min_split_gain	0.9810304988555096	b58e93020e20438db09d29ad3c13df59
num_leaves	52	b58e93020e20438db09d29ad3c13df59
random_state	42	b58e93020e20438db09d29ad3c13df59
reg_alpha	5.151427107672737e-07	b58e93020e20438db09d29ad3c13df59
reg_lambda	0.21983872494679824	b58e93020e20438db09d29ad3c13df59
subsample	0.8879401383369688	b58e93020e20438db09d29ad3c13df59
subsample_for_bin	200000	b58e93020e20438db09d29ad3c13df59
subsample_freq	0	b58e93020e20438db09d29ad3c13df59
metric	['None']	b58e93020e20438db09d29ad3c13df59
verbosity	-1	b58e93020e20438db09d29ad3c13df59
scale_pos_weight	11.387084592145015	b58e93020e20438db09d29ad3c13df59
objective	binary	b58e93020e20438db09d29ad3c13df59
num_threads	12	b58e93020e20438db09d29ad3c13df59
num_boost_round	1400	b58e93020e20438db09d29ad3c13df59
feature_name	auto	b58e93020e20438db09d29ad3c13df59
categorical_feature	auto	b58e93020e20438db09d29ad3c13df59
keep_training_booster	False	b58e93020e20438db09d29ad3c13df59
boosting_type	gbdt	7eea4fc7e3a546589babe6a0b7310882
colsample_bytree	0.6721204480745828	7eea4fc7e3a546589babe6a0b7310882
learning_rate	0.020387922276105683	7eea4fc7e3a546589babe6a0b7310882
max_depth	11	7eea4fc7e3a546589babe6a0b7310882
min_child_samples	134	7eea4fc7e3a546589babe6a0b7310882
min_child_weight	0.001	7eea4fc7e3a546589babe6a0b7310882
min_split_gain	0.825783747366426	7eea4fc7e3a546589babe6a0b7310882
num_leaves	36	7eea4fc7e3a546589babe6a0b7310882
random_state	42	7eea4fc7e3a546589babe6a0b7310882
reg_alpha	2.8983319563488535e-05	7eea4fc7e3a546589babe6a0b7310882
reg_lambda	0.03516449410396339	7eea4fc7e3a546589babe6a0b7310882
subsample	0.9270106042427875	7eea4fc7e3a546589babe6a0b7310882
subsample_for_bin	200000	7eea4fc7e3a546589babe6a0b7310882
subsample_freq	0	7eea4fc7e3a546589babe6a0b7310882
metric	['None']	7eea4fc7e3a546589babe6a0b7310882
verbosity	-1	7eea4fc7e3a546589babe6a0b7310882
scale_pos_weight	11.387084592145015	7eea4fc7e3a546589babe6a0b7310882
objective	binary	7eea4fc7e3a546589babe6a0b7310882
num_threads	12	7eea4fc7e3a546589babe6a0b7310882
num_boost_round	1600	7eea4fc7e3a546589babe6a0b7310882
feature_name	auto	7eea4fc7e3a546589babe6a0b7310882
categorical_feature	auto	7eea4fc7e3a546589babe6a0b7310882
keep_training_booster	False	7eea4fc7e3a546589babe6a0b7310882
boosting_type	gbdt	518de6201cd84159962c329678dae7c7
colsample_bytree	0.7189459752358323	518de6201cd84159962c329678dae7c7
learning_rate	0.022064897384379587	518de6201cd84159962c329678dae7c7
max_depth	11	518de6201cd84159962c329678dae7c7
min_child_samples	130	518de6201cd84159962c329678dae7c7
min_child_weight	0.001	518de6201cd84159962c329678dae7c7
min_split_gain	0.43723969742899477	518de6201cd84159962c329678dae7c7
num_leaves	52	518de6201cd84159962c329678dae7c7
random_state	42	518de6201cd84159962c329678dae7c7
reg_alpha	3.2278604765932024e-08	518de6201cd84159962c329678dae7c7
reg_lambda	0.03701786211350345	518de6201cd84159962c329678dae7c7
subsample	0.9523778027294003	518de6201cd84159962c329678dae7c7
subsample_for_bin	200000	518de6201cd84159962c329678dae7c7
subsample_freq	0	518de6201cd84159962c329678dae7c7
metric	['None']	518de6201cd84159962c329678dae7c7
verbosity	-1	518de6201cd84159962c329678dae7c7
scale_pos_weight	11.387084592145015	518de6201cd84159962c329678dae7c7
objective	binary	518de6201cd84159962c329678dae7c7
num_threads	12	518de6201cd84159962c329678dae7c7
num_boost_round	1000	518de6201cd84159962c329678dae7c7
feature_name	auto	518de6201cd84159962c329678dae7c7
categorical_feature	auto	518de6201cd84159962c329678dae7c7
keep_training_booster	False	518de6201cd84159962c329678dae7c7
boosting_type	gbdt	2ab6619860f04dd6806c00d08dd3c42d
colsample_bytree	0.7012808880334107	2ab6619860f04dd6806c00d08dd3c42d
learning_rate	0.015495953179627181	2ab6619860f04dd6806c00d08dd3c42d
max_depth	9	2ab6619860f04dd6806c00d08dd3c42d
min_child_samples	179	2ab6619860f04dd6806c00d08dd3c42d
min_child_weight	0.001	2ab6619860f04dd6806c00d08dd3c42d
min_split_gain	0.8274594416458114	2ab6619860f04dd6806c00d08dd3c42d
num_leaves	30	2ab6619860f04dd6806c00d08dd3c42d
random_state	42	2ab6619860f04dd6806c00d08dd3c42d
reg_alpha	1.9410399839386925e-06	2ab6619860f04dd6806c00d08dd3c42d
reg_lambda	0.6797639026802181	2ab6619860f04dd6806c00d08dd3c42d
subsample	0.8044088343802782	2ab6619860f04dd6806c00d08dd3c42d
subsample_for_bin	200000	2ab6619860f04dd6806c00d08dd3c42d
subsample_freq	0	2ab6619860f04dd6806c00d08dd3c42d
metric	['None']	2ab6619860f04dd6806c00d08dd3c42d
verbosity	-1	2ab6619860f04dd6806c00d08dd3c42d
scale_pos_weight	11.387084592145015	2ab6619860f04dd6806c00d08dd3c42d
objective	binary	2ab6619860f04dd6806c00d08dd3c42d
num_threads	12	2ab6619860f04dd6806c00d08dd3c42d
num_boost_round	1100	2ab6619860f04dd6806c00d08dd3c42d
feature_name	auto	2ab6619860f04dd6806c00d08dd3c42d
categorical_feature	auto	2ab6619860f04dd6806c00d08dd3c42d
keep_training_booster	False	2ab6619860f04dd6806c00d08dd3c42d
boosting_type	gbdt	cc29150802304136adce6bad79c64a02
colsample_bytree	0.7741101091255476	cc29150802304136adce6bad79c64a02
learning_rate	0.019740915742825486	cc29150802304136adce6bad79c64a02
max_depth	7	cc29150802304136adce6bad79c64a02
min_child_samples	185	cc29150802304136adce6bad79c64a02
min_child_weight	0.001	cc29150802304136adce6bad79c64a02
min_split_gain	0.8228250685123643	cc29150802304136adce6bad79c64a02
num_leaves	102	cc29150802304136adce6bad79c64a02
random_state	42	cc29150802304136adce6bad79c64a02
reg_alpha	4.15572915164716e-06	cc29150802304136adce6bad79c64a02
reg_lambda	0.19998575412798575	cc29150802304136adce6bad79c64a02
subsample	0.7571356465706973	cc29150802304136adce6bad79c64a02
subsample_for_bin	200000	cc29150802304136adce6bad79c64a02
subsample_freq	0	cc29150802304136adce6bad79c64a02
metric	['None']	cc29150802304136adce6bad79c64a02
verbosity	-1	cc29150802304136adce6bad79c64a02
scale_pos_weight	11.387084592145015	cc29150802304136adce6bad79c64a02
objective	binary	cc29150802304136adce6bad79c64a02
num_threads	12	cc29150802304136adce6bad79c64a02
num_boost_round	1500	cc29150802304136adce6bad79c64a02
feature_name	auto	cc29150802304136adce6bad79c64a02
categorical_feature	auto	cc29150802304136adce6bad79c64a02
keep_training_booster	False	cc29150802304136adce6bad79c64a02
boosting_type	gbdt	e70dd208f60b4acc863c851496a7b8e1
colsample_bytree	0.691091974574234	e70dd208f60b4acc863c851496a7b8e1
learning_rate	0.013004082055473919	e70dd208f60b4acc863c851496a7b8e1
max_depth	9	e70dd208f60b4acc863c851496a7b8e1
min_child_samples	147	e70dd208f60b4acc863c851496a7b8e1
min_child_weight	0.001	e70dd208f60b4acc863c851496a7b8e1
min_split_gain	0.7577122365720286	e70dd208f60b4acc863c851496a7b8e1
num_leaves	55	e70dd208f60b4acc863c851496a7b8e1
random_state	42	e70dd208f60b4acc863c851496a7b8e1
reg_alpha	1.9113384617529177e-06	e70dd208f60b4acc863c851496a7b8e1
reg_lambda	0.48870088355990365	e70dd208f60b4acc863c851496a7b8e1
subsample	0.779799106905367	e70dd208f60b4acc863c851496a7b8e1
subsample_for_bin	200000	e70dd208f60b4acc863c851496a7b8e1
subsample_freq	0	e70dd208f60b4acc863c851496a7b8e1
metric	['None']	e70dd208f60b4acc863c851496a7b8e1
verbosity	-1	e70dd208f60b4acc863c851496a7b8e1
scale_pos_weight	11.387084592145015	e70dd208f60b4acc863c851496a7b8e1
objective	binary	e70dd208f60b4acc863c851496a7b8e1
num_threads	12	e70dd208f60b4acc863c851496a7b8e1
num_boost_round	1000	e70dd208f60b4acc863c851496a7b8e1
feature_name	auto	e70dd208f60b4acc863c851496a7b8e1
categorical_feature	auto	e70dd208f60b4acc863c851496a7b8e1
keep_training_booster	False	e70dd208f60b4acc863c851496a7b8e1
boosting_type	gbdt	0862f531c85046b18a2ec61111e68861
colsample_bytree	0.5247663420794499	0862f531c85046b18a2ec61111e68861
learning_rate	0.011856141659575612	0862f531c85046b18a2ec61111e68861
max_depth	12	0862f531c85046b18a2ec61111e68861
min_child_samples	101	0862f531c85046b18a2ec61111e68861
min_child_weight	0.001	0862f531c85046b18a2ec61111e68861
min_split_gain	0.5959597549894652	0862f531c85046b18a2ec61111e68861
num_leaves	75	0862f531c85046b18a2ec61111e68861
random_state	42	0862f531c85046b18a2ec61111e68861
reg_alpha	1.0119674965185195e-06	0862f531c85046b18a2ec61111e68861
reg_lambda	0.03584783248483397	0862f531c85046b18a2ec61111e68861
subsample	0.8550873054226694	0862f531c85046b18a2ec61111e68861
subsample_for_bin	200000	0862f531c85046b18a2ec61111e68861
subsample_freq	0	0862f531c85046b18a2ec61111e68861
metric	['None']	0862f531c85046b18a2ec61111e68861
verbosity	-1	0862f531c85046b18a2ec61111e68861
scale_pos_weight	11.387084592145015	0862f531c85046b18a2ec61111e68861
objective	binary	0862f531c85046b18a2ec61111e68861
num_threads	12	0862f531c85046b18a2ec61111e68861
num_boost_round	900	0862f531c85046b18a2ec61111e68861
feature_name	auto	0862f531c85046b18a2ec61111e68861
categorical_feature	auto	0862f531c85046b18a2ec61111e68861
keep_training_booster	False	0862f531c85046b18a2ec61111e68861
colsample_bytree	0.7684450980086267	d1000f6e85de4fe2a8c95dc022bdab8f
learning_rate	0.02045482258990639	d1000f6e85de4fe2a8c95dc022bdab8f
max_depth	9	d1000f6e85de4fe2a8c95dc022bdab8f
min_child_samples	197	d1000f6e85de4fe2a8c95dc022bdab8f
min_child_weight	0.001	d1000f6e85de4fe2a8c95dc022bdab8f
min_split_gain	0.9168182104572336	d1000f6e85de4fe2a8c95dc022bdab8f
num_leaves	17	d1000f6e85de4fe2a8c95dc022bdab8f
random_state	42	d1000f6e85de4fe2a8c95dc022bdab8f
reg_alpha	1.7635149720951552e-07	d1000f6e85de4fe2a8c95dc022bdab8f
reg_lambda	0.0026602304040514164	d1000f6e85de4fe2a8c95dc022bdab8f
subsample	0.6776860110863199	d1000f6e85de4fe2a8c95dc022bdab8f
subsample_for_bin	200000	d1000f6e85de4fe2a8c95dc022bdab8f
subsample_freq	0	d1000f6e85de4fe2a8c95dc022bdab8f
metric	['None']	d1000f6e85de4fe2a8c95dc022bdab8f
verbosity	-1	d1000f6e85de4fe2a8c95dc022bdab8f
scale_pos_weight	11.387084592145015	d1000f6e85de4fe2a8c95dc022bdab8f
objective	binary	d1000f6e85de4fe2a8c95dc022bdab8f
num_threads	12	d1000f6e85de4fe2a8c95dc022bdab8f
num_boost_round	1400	d1000f6e85de4fe2a8c95dc022bdab8f
feature_name	auto	d1000f6e85de4fe2a8c95dc022bdab8f
categorical_feature	auto	d1000f6e85de4fe2a8c95dc022bdab8f
keep_training_booster	False	d1000f6e85de4fe2a8c95dc022bdab8f
boosting_type	gbdt	a8ef003494f048faa29d895d18d2d187
colsample_bytree	0.6406677248396816	a8ef003494f048faa29d895d18d2d187
learning_rate	0.060027135863793886	a8ef003494f048faa29d895d18d2d187
max_depth	8	a8ef003494f048faa29d895d18d2d187
min_child_samples	155	a8ef003494f048faa29d895d18d2d187
min_child_weight	0.001	a8ef003494f048faa29d895d18d2d187
min_split_gain	0.5173092314241061	a8ef003494f048faa29d895d18d2d187
num_leaves	51	a8ef003494f048faa29d895d18d2d187
random_state	42	a8ef003494f048faa29d895d18d2d187
reg_alpha	4.675388967824536e-08	a8ef003494f048faa29d895d18d2d187
reg_lambda	0.17301950807725752	a8ef003494f048faa29d895d18d2d187
subsample	0.927986621541142	a8ef003494f048faa29d895d18d2d187
subsample_for_bin	200000	a8ef003494f048faa29d895d18d2d187
subsample_freq	0	a8ef003494f048faa29d895d18d2d187
metric	['None']	a8ef003494f048faa29d895d18d2d187
verbosity	-1	a8ef003494f048faa29d895d18d2d187
scale_pos_weight	11.387084592145015	a8ef003494f048faa29d895d18d2d187
objective	binary	a8ef003494f048faa29d895d18d2d187
num_threads	12	a8ef003494f048faa29d895d18d2d187
num_boost_round	400	a8ef003494f048faa29d895d18d2d187
feature_name	auto	a8ef003494f048faa29d895d18d2d187
categorical_feature	auto	a8ef003494f048faa29d895d18d2d187
keep_training_booster	False	a8ef003494f048faa29d895d18d2d187
scale_pos_weight	11.387084592145015	651dd8509db8453e9b57f0db626a0bc0
objective	binary	651dd8509db8453e9b57f0db626a0bc0
num_threads	12	651dd8509db8453e9b57f0db626a0bc0
num_boost_round	600	651dd8509db8453e9b57f0db626a0bc0
feature_name	auto	651dd8509db8453e9b57f0db626a0bc0
categorical_feature	auto	651dd8509db8453e9b57f0db626a0bc0
keep_training_booster	False	651dd8509db8453e9b57f0db626a0bc0
boosting_type	gbdt	4a86e315bd1b42e4a441cf540b75416d
colsample_bytree	0.7317095935012669	4a86e315bd1b42e4a441cf540b75416d
learning_rate	0.0557291009983691	4a86e315bd1b42e4a441cf540b75416d
max_depth	11	4a86e315bd1b42e4a441cf540b75416d
min_child_samples	197	4a86e315bd1b42e4a441cf540b75416d
min_child_weight	0.001	4a86e315bd1b42e4a441cf540b75416d
min_split_gain	0.29021594929629446	4a86e315bd1b42e4a441cf540b75416d
num_leaves	23	4a86e315bd1b42e4a441cf540b75416d
random_state	42	4a86e315bd1b42e4a441cf540b75416d
reg_alpha	4.724746677199647e-08	4a86e315bd1b42e4a441cf540b75416d
reg_lambda	0.00030753273284213583	4a86e315bd1b42e4a441cf540b75416d
subsample	0.9646376617736891	4a86e315bd1b42e4a441cf540b75416d
subsample_for_bin	200000	4a86e315bd1b42e4a441cf540b75416d
subsample_freq	0	4a86e315bd1b42e4a441cf540b75416d
metric	['None']	4a86e315bd1b42e4a441cf540b75416d
verbosity	-1	4a86e315bd1b42e4a441cf540b75416d
scale_pos_weight	11.387084592145015	4a86e315bd1b42e4a441cf540b75416d
objective	binary	4a86e315bd1b42e4a441cf540b75416d
num_threads	12	4a86e315bd1b42e4a441cf540b75416d
num_boost_round	700	4a86e315bd1b42e4a441cf540b75416d
feature_name	auto	4a86e315bd1b42e4a441cf540b75416d
categorical_feature	auto	4a86e315bd1b42e4a441cf540b75416d
keep_training_booster	False	4a86e315bd1b42e4a441cf540b75416d
boosting_type	gbdt	7594e7f61c11418997699b81d6b68aac
colsample_bytree	0.560498615001207	7594e7f61c11418997699b81d6b68aac
learning_rate	0.05995070668329852	7594e7f61c11418997699b81d6b68aac
max_depth	12	7594e7f61c11418997699b81d6b68aac
min_child_samples	127	7594e7f61c11418997699b81d6b68aac
min_child_weight	0.001	7594e7f61c11418997699b81d6b68aac
min_split_gain	0.37545131107774216	7594e7f61c11418997699b81d6b68aac
num_leaves	31	7594e7f61c11418997699b81d6b68aac
random_state	42	7594e7f61c11418997699b81d6b68aac
reg_alpha	2.315554709176436e-06	7594e7f61c11418997699b81d6b68aac
reg_lambda	0.0014618750314294396	7594e7f61c11418997699b81d6b68aac
subsample	0.9463366422274183	7594e7f61c11418997699b81d6b68aac
subsample_for_bin	200000	7594e7f61c11418997699b81d6b68aac
subsample_freq	0	7594e7f61c11418997699b81d6b68aac
metric	['None']	7594e7f61c11418997699b81d6b68aac
verbosity	-1	7594e7f61c11418997699b81d6b68aac
scale_pos_weight	11.387084592145015	7594e7f61c11418997699b81d6b68aac
objective	binary	7594e7f61c11418997699b81d6b68aac
num_threads	12	7594e7f61c11418997699b81d6b68aac
num_boost_round	300	7594e7f61c11418997699b81d6b68aac
feature_name	auto	7594e7f61c11418997699b81d6b68aac
categorical_feature	auto	7594e7f61c11418997699b81d6b68aac
keep_training_booster	False	7594e7f61c11418997699b81d6b68aac
boosting_type	gbdt	8883ec417d31449b9c035b2913e2c586
colsample_bytree	0.6035747395147177	8883ec417d31449b9c035b2913e2c586
learning_rate	0.029485236420239272	8883ec417d31449b9c035b2913e2c586
max_depth	11	8883ec417d31449b9c035b2913e2c586
min_child_samples	193	8883ec417d31449b9c035b2913e2c586
min_child_weight	0.001	8883ec417d31449b9c035b2913e2c586
min_split_gain	0.6560250967642893	8883ec417d31449b9c035b2913e2c586
num_leaves	59	8883ec417d31449b9c035b2913e2c586
random_state	42	8883ec417d31449b9c035b2913e2c586
reg_alpha	1.3069398698176176e-06	8883ec417d31449b9c035b2913e2c586
reg_lambda	0.20170922827600019	8883ec417d31449b9c035b2913e2c586
subsample	0.959142778480886	8883ec417d31449b9c035b2913e2c586
subsample_for_bin	200000	8883ec417d31449b9c035b2913e2c586
subsample_freq	0	8883ec417d31449b9c035b2913e2c586
metric	['None']	8883ec417d31449b9c035b2913e2c586
verbosity	-1	8883ec417d31449b9c035b2913e2c586
scale_pos_weight	11.387084592145015	8883ec417d31449b9c035b2913e2c586
objective	binary	8883ec417d31449b9c035b2913e2c586
num_threads	12	8883ec417d31449b9c035b2913e2c586
num_boost_round	500	8883ec417d31449b9c035b2913e2c586
feature_name	auto	8883ec417d31449b9c035b2913e2c586
categorical_feature	auto	8883ec417d31449b9c035b2913e2c586
keep_training_booster	False	8883ec417d31449b9c035b2913e2c586
boosting_type	gbdt	fd9968abd7b9464aa499ac3910ae6d59
colsample_bytree	0.6116603098172054	fd9968abd7b9464aa499ac3910ae6d59
learning_rate	0.007604360713310007	fd9968abd7b9464aa499ac3910ae6d59
max_depth	6	fd9968abd7b9464aa499ac3910ae6d59
min_child_samples	186	fd9968abd7b9464aa499ac3910ae6d59
min_child_weight	0.001	fd9968abd7b9464aa499ac3910ae6d59
min_split_gain	0.7819540355347722	fd9968abd7b9464aa499ac3910ae6d59
num_leaves	173	fd9968abd7b9464aa499ac3910ae6d59
random_state	42	fd9968abd7b9464aa499ac3910ae6d59
reg_alpha	0.006866068303285839	fd9968abd7b9464aa499ac3910ae6d59
reg_lambda	1.0990064385609308	fd9968abd7b9464aa499ac3910ae6d59
subsample	0.7832244798485336	fd9968abd7b9464aa499ac3910ae6d59
subsample_for_bin	200000	fd9968abd7b9464aa499ac3910ae6d59
subsample_freq	0	fd9968abd7b9464aa499ac3910ae6d59
metric	['None']	fd9968abd7b9464aa499ac3910ae6d59
verbosity	-1	fd9968abd7b9464aa499ac3910ae6d59
scale_pos_weight	11.387084592145015	fd9968abd7b9464aa499ac3910ae6d59
objective	binary	fd9968abd7b9464aa499ac3910ae6d59
num_threads	12	fd9968abd7b9464aa499ac3910ae6d59
boosting_type	gbdt	69b74a9c9f174a25b25bca9453b251dd
colsample_bytree	0.5643580353846138	69b74a9c9f174a25b25bca9453b251dd
learning_rate	0.04128015345530156	69b74a9c9f174a25b25bca9453b251dd
max_depth	12	69b74a9c9f174a25b25bca9453b251dd
min_child_samples	181	69b74a9c9f174a25b25bca9453b251dd
min_child_weight	0.001	69b74a9c9f174a25b25bca9453b251dd
min_split_gain	0.5026055723853189	69b74a9c9f174a25b25bca9453b251dd
num_leaves	21	69b74a9c9f174a25b25bca9453b251dd
random_state	42	69b74a9c9f174a25b25bca9453b251dd
reg_alpha	5.6014859804466974e-08	69b74a9c9f174a25b25bca9453b251dd
reg_lambda	0.03559516654652246	69b74a9c9f174a25b25bca9453b251dd
subsample	0.9866712302157853	69b74a9c9f174a25b25bca9453b251dd
subsample_for_bin	200000	69b74a9c9f174a25b25bca9453b251dd
subsample_freq	0	69b74a9c9f174a25b25bca9453b251dd
metric	['None']	69b74a9c9f174a25b25bca9453b251dd
verbosity	-1	69b74a9c9f174a25b25bca9453b251dd
scale_pos_weight	11.387084592145015	69b74a9c9f174a25b25bca9453b251dd
objective	binary	69b74a9c9f174a25b25bca9453b251dd
num_threads	12	69b74a9c9f174a25b25bca9453b251dd
num_boost_round	600	69b74a9c9f174a25b25bca9453b251dd
feature_name	auto	69b74a9c9f174a25b25bca9453b251dd
categorical_feature	auto	69b74a9c9f174a25b25bca9453b251dd
keep_training_booster	False	69b74a9c9f174a25b25bca9453b251dd
boosting_type	gbdt	fb402d7ff6d741018d6a91ea10972f05
colsample_bytree	0.5075138676961806	fb402d7ff6d741018d6a91ea10972f05
learning_rate	0.03480433196545308	fb402d7ff6d741018d6a91ea10972f05
max_depth	12	fb402d7ff6d741018d6a91ea10972f05
min_child_samples	139	fb402d7ff6d741018d6a91ea10972f05
min_child_weight	0.001	fb402d7ff6d741018d6a91ea10972f05
min_split_gain	0.4971598489493627	fb402d7ff6d741018d6a91ea10972f05
num_leaves	49	fb402d7ff6d741018d6a91ea10972f05
random_state	42	fb402d7ff6d741018d6a91ea10972f05
reg_alpha	1.197312462889697e-07	fb402d7ff6d741018d6a91ea10972f05
reg_lambda	0.003692769077886854	fb402d7ff6d741018d6a91ea10972f05
subsample	0.986955713982942	fb402d7ff6d741018d6a91ea10972f05
subsample_for_bin	200000	fb402d7ff6d741018d6a91ea10972f05
subsample_freq	0	fb402d7ff6d741018d6a91ea10972f05
metric	['None']	fb402d7ff6d741018d6a91ea10972f05
verbosity	-1	fb402d7ff6d741018d6a91ea10972f05
scale_pos_weight	11.387084592145015	fb402d7ff6d741018d6a91ea10972f05
objective	binary	fb402d7ff6d741018d6a91ea10972f05
num_threads	12	fb402d7ff6d741018d6a91ea10972f05
num_boost_round	600	fb402d7ff6d741018d6a91ea10972f05
feature_name	auto	fb402d7ff6d741018d6a91ea10972f05
categorical_feature	auto	fb402d7ff6d741018d6a91ea10972f05
keep_training_booster	False	fb402d7ff6d741018d6a91ea10972f05
num_boost_round	1900	fd9968abd7b9464aa499ac3910ae6d59
feature_name	auto	fd9968abd7b9464aa499ac3910ae6d59
categorical_feature	auto	fd9968abd7b9464aa499ac3910ae6d59
keep_training_booster	False	fd9968abd7b9464aa499ac3910ae6d59
boosting_type	gbdt	4b6e2f4862564695a32ae677d3ebd136
colsample_bytree	0.5511662643545036	4b6e2f4862564695a32ae677d3ebd136
learning_rate	0.008038037548022473	4b6e2f4862564695a32ae677d3ebd136
max_depth	12	4b6e2f4862564695a32ae677d3ebd136
min_child_samples	120	4b6e2f4862564695a32ae677d3ebd136
min_child_weight	0.001	4b6e2f4862564695a32ae677d3ebd136
min_split_gain	0.06161058403080233	4b6e2f4862564695a32ae677d3ebd136
num_leaves	87	4b6e2f4862564695a32ae677d3ebd136
random_state	42	4b6e2f4862564695a32ae677d3ebd136
reg_alpha	1.9220125229300828e-08	4b6e2f4862564695a32ae677d3ebd136
reg_lambda	0.13190125192871519	4b6e2f4862564695a32ae677d3ebd136
subsample	0.96561433814342	4b6e2f4862564695a32ae677d3ebd136
subsample_for_bin	200000	4b6e2f4862564695a32ae677d3ebd136
subsample_freq	0	4b6e2f4862564695a32ae677d3ebd136
metric	['None']	4b6e2f4862564695a32ae677d3ebd136
verbosity	-1	4b6e2f4862564695a32ae677d3ebd136
scale_pos_weight	11.387084592145015	4b6e2f4862564695a32ae677d3ebd136
objective	binary	4b6e2f4862564695a32ae677d3ebd136
num_threads	12	4b6e2f4862564695a32ae677d3ebd136
num_boost_round	600	4b6e2f4862564695a32ae677d3ebd136
feature_name	auto	4b6e2f4862564695a32ae677d3ebd136
categorical_feature	auto	4b6e2f4862564695a32ae677d3ebd136
keep_training_booster	False	4b6e2f4862564695a32ae677d3ebd136
boosting_type	gbdt	a8008dd2ea1b43f196f1024d66cd3866
colsample_bytree	0.5530022413762853	a8008dd2ea1b43f196f1024d66cd3866
learning_rate	0.02001812997043294	a8008dd2ea1b43f196f1024d66cd3866
max_depth	7	a8008dd2ea1b43f196f1024d66cd3866
min_child_samples	200	a8008dd2ea1b43f196f1024d66cd3866
min_child_weight	0.001	a8008dd2ea1b43f196f1024d66cd3866
min_split_gain	0.9584030310383423	a8008dd2ea1b43f196f1024d66cd3866
num_leaves	63	a8008dd2ea1b43f196f1024d66cd3866
random_state	42	a8008dd2ea1b43f196f1024d66cd3866
reg_alpha	2.276425013038133e-05	a8008dd2ea1b43f196f1024d66cd3866
reg_lambda	0.18255362631569344	a8008dd2ea1b43f196f1024d66cd3866
subsample	0.893693043707286	a8008dd2ea1b43f196f1024d66cd3866
subsample_for_bin	200000	a8008dd2ea1b43f196f1024d66cd3866
subsample_freq	0	a8008dd2ea1b43f196f1024d66cd3866
metric	['None']	a8008dd2ea1b43f196f1024d66cd3866
verbosity	-1	a8008dd2ea1b43f196f1024d66cd3866
scale_pos_weight	11.387084592145015	a8008dd2ea1b43f196f1024d66cd3866
objective	binary	a8008dd2ea1b43f196f1024d66cd3866
num_threads	12	a8008dd2ea1b43f196f1024d66cd3866
colsample_bytree	0.5130000688649476	e094133c648a4dcf978411aa6d5934e7
learning_rate	0.029029988122206713	e094133c648a4dcf978411aa6d5934e7
max_depth	12	e094133c648a4dcf978411aa6d5934e7
min_child_samples	97	e094133c648a4dcf978411aa6d5934e7
min_child_weight	0.001	e094133c648a4dcf978411aa6d5934e7
min_split_gain	0.520992993573428	e094133c648a4dcf978411aa6d5934e7
num_leaves	57	e094133c648a4dcf978411aa6d5934e7
random_state	42	e094133c648a4dcf978411aa6d5934e7
reg_alpha	3.218176934793742e-08	e094133c648a4dcf978411aa6d5934e7
reg_lambda	0.011906122093578483	e094133c648a4dcf978411aa6d5934e7
subsample	0.9982853451380838	e094133c648a4dcf978411aa6d5934e7
subsample_for_bin	200000	e094133c648a4dcf978411aa6d5934e7
subsample_freq	0	e094133c648a4dcf978411aa6d5934e7
metric	['None']	e094133c648a4dcf978411aa6d5934e7
verbosity	-1	e094133c648a4dcf978411aa6d5934e7
scale_pos_weight	11.387084592145015	e094133c648a4dcf978411aa6d5934e7
objective	binary	e094133c648a4dcf978411aa6d5934e7
num_threads	12	e094133c648a4dcf978411aa6d5934e7
num_boost_round	800	e094133c648a4dcf978411aa6d5934e7
feature_name	auto	e094133c648a4dcf978411aa6d5934e7
categorical_feature	auto	e094133c648a4dcf978411aa6d5934e7
keep_training_booster	False	e094133c648a4dcf978411aa6d5934e7
boosting_type	gbdt	fca3189b071b4c8aae99a36fec28a55a
colsample_bytree	0.6120013449509752	fca3189b071b4c8aae99a36fec28a55a
learning_rate	0.018764542721594397	fca3189b071b4c8aae99a36fec28a55a
max_depth	10	fca3189b071b4c8aae99a36fec28a55a
min_child_samples	199	fca3189b071b4c8aae99a36fec28a55a
min_child_weight	0.001	fca3189b071b4c8aae99a36fec28a55a
min_split_gain	0.6883093025546256	fca3189b071b4c8aae99a36fec28a55a
num_leaves	45	fca3189b071b4c8aae99a36fec28a55a
random_state	42	fca3189b071b4c8aae99a36fec28a55a
reg_alpha	5.848390059965247e-06	fca3189b071b4c8aae99a36fec28a55a
reg_lambda	5.412152780984232	fca3189b071b4c8aae99a36fec28a55a
subsample	0.904235350210559	fca3189b071b4c8aae99a36fec28a55a
subsample_for_bin	200000	fca3189b071b4c8aae99a36fec28a55a
subsample_freq	0	fca3189b071b4c8aae99a36fec28a55a
metric	['None']	fca3189b071b4c8aae99a36fec28a55a
verbosity	-1	fca3189b071b4c8aae99a36fec28a55a
scale_pos_weight	11.387084592145015	fca3189b071b4c8aae99a36fec28a55a
objective	binary	fca3189b071b4c8aae99a36fec28a55a
num_threads	12	fca3189b071b4c8aae99a36fec28a55a
num_boost_round	200	fca3189b071b4c8aae99a36fec28a55a
feature_name	auto	fca3189b071b4c8aae99a36fec28a55a
categorical_feature	auto	fca3189b071b4c8aae99a36fec28a55a
keep_training_booster	False	fca3189b071b4c8aae99a36fec28a55a
boosting_type	gbdt	7c8b46c7a5b748aa8f1d0b39f7af527e
colsample_bytree	0.6123164479786982	7c8b46c7a5b748aa8f1d0b39f7af527e
learning_rate	0.04055822541036841	7c8b46c7a5b748aa8f1d0b39f7af527e
max_depth	12	7c8b46c7a5b748aa8f1d0b39f7af527e
min_child_samples	170	7c8b46c7a5b748aa8f1d0b39f7af527e
min_child_weight	0.001	7c8b46c7a5b748aa8f1d0b39f7af527e
min_split_gain	0.5448033421918906	7c8b46c7a5b748aa8f1d0b39f7af527e
num_leaves	40	7c8b46c7a5b748aa8f1d0b39f7af527e
random_state	42	7c8b46c7a5b748aa8f1d0b39f7af527e
reg_alpha	0.0010790951110892933	7c8b46c7a5b748aa8f1d0b39f7af527e
reg_lambda	0.15868386052212577	7c8b46c7a5b748aa8f1d0b39f7af527e
subsample	0.9919658052673163	7c8b46c7a5b748aa8f1d0b39f7af527e
subsample_for_bin	200000	7c8b46c7a5b748aa8f1d0b39f7af527e
subsample_freq	0	7c8b46c7a5b748aa8f1d0b39f7af527e
metric	['None']	7c8b46c7a5b748aa8f1d0b39f7af527e
verbosity	-1	7c8b46c7a5b748aa8f1d0b39f7af527e
scale_pos_weight	11.387084592145015	7c8b46c7a5b748aa8f1d0b39f7af527e
objective	binary	7c8b46c7a5b748aa8f1d0b39f7af527e
num_threads	12	7c8b46c7a5b748aa8f1d0b39f7af527e
num_boost_round	600	7c8b46c7a5b748aa8f1d0b39f7af527e
feature_name	auto	7c8b46c7a5b748aa8f1d0b39f7af527e
categorical_feature	auto	7c8b46c7a5b748aa8f1d0b39f7af527e
keep_training_booster	False	7c8b46c7a5b748aa8f1d0b39f7af527e
boosting_type	gbdt	3543bc1d263645d99771e0034c716e7b
colsample_bytree	0.5773746721616915	3543bc1d263645d99771e0034c716e7b
learning_rate	0.08850946367600245	3543bc1d263645d99771e0034c716e7b
max_depth	11	3543bc1d263645d99771e0034c716e7b
min_child_samples	170	3543bc1d263645d99771e0034c716e7b
min_child_weight	0.001	3543bc1d263645d99771e0034c716e7b
min_split_gain	0.5483478513007068	3543bc1d263645d99771e0034c716e7b
num_leaves	55	3543bc1d263645d99771e0034c716e7b
random_state	42	3543bc1d263645d99771e0034c716e7b
reg_alpha	1.0393004118607545e-06	3543bc1d263645d99771e0034c716e7b
reg_lambda	0.4123714606308708	3543bc1d263645d99771e0034c716e7b
subsample	0.9773617715091726	3543bc1d263645d99771e0034c716e7b
subsample_for_bin	200000	3543bc1d263645d99771e0034c716e7b
subsample_freq	0	3543bc1d263645d99771e0034c716e7b
metric	['None']	3543bc1d263645d99771e0034c716e7b
verbosity	-1	3543bc1d263645d99771e0034c716e7b
scale_pos_weight	11.387084592145015	3543bc1d263645d99771e0034c716e7b
objective	binary	3543bc1d263645d99771e0034c716e7b
num_threads	12	3543bc1d263645d99771e0034c716e7b
num_boost_round	500	3543bc1d263645d99771e0034c716e7b
feature_name	auto	3543bc1d263645d99771e0034c716e7b
categorical_feature	auto	3543bc1d263645d99771e0034c716e7b
keep_training_booster	False	3543bc1d263645d99771e0034c716e7b
boosting_type	gbdt	c88117b6aafc456082337e849f1bf075
colsample_bytree	0.5361720832879091	c88117b6aafc456082337e849f1bf075
learning_rate	0.15304134162499708	c88117b6aafc456082337e849f1bf075
max_depth	12	c88117b6aafc456082337e849f1bf075
min_child_samples	194	c88117b6aafc456082337e849f1bf075
min_child_weight	0.001	c88117b6aafc456082337e849f1bf075
min_split_gain	0.6793299439213197	c88117b6aafc456082337e849f1bf075
num_leaves	20	c88117b6aafc456082337e849f1bf075
random_state	42	c88117b6aafc456082337e849f1bf075
reg_alpha	9.391906412819896e-08	c88117b6aafc456082337e849f1bf075
reg_lambda	0.0003677120396781816	c88117b6aafc456082337e849f1bf075
subsample	0.9964073007548848	c88117b6aafc456082337e849f1bf075
subsample_for_bin	200000	c88117b6aafc456082337e849f1bf075
subsample_freq	0	c88117b6aafc456082337e849f1bf075
metric	['None']	c88117b6aafc456082337e849f1bf075
verbosity	-1	c88117b6aafc456082337e849f1bf075
scale_pos_weight	11.387084592145015	c88117b6aafc456082337e849f1bf075
objective	binary	c88117b6aafc456082337e849f1bf075
num_threads	12	c88117b6aafc456082337e849f1bf075
num_boost_round	1200	c88117b6aafc456082337e849f1bf075
feature_name	auto	c88117b6aafc456082337e849f1bf075
categorical_feature	auto	c88117b6aafc456082337e849f1bf075
keep_training_booster	False	c88117b6aafc456082337e849f1bf075
boosting_type	gbdt	aa2f79a2f19d42db9cb8620483e02b5e
colsample_bytree	0.5038376157576366	aa2f79a2f19d42db9cb8620483e02b5e
learning_rate	0.02093792969252501	aa2f79a2f19d42db9cb8620483e02b5e
max_depth	11	aa2f79a2f19d42db9cb8620483e02b5e
min_child_samples	126	aa2f79a2f19d42db9cb8620483e02b5e
min_child_weight	0.001	aa2f79a2f19d42db9cb8620483e02b5e
min_split_gain	0.3093256016830575	aa2f79a2f19d42db9cb8620483e02b5e
num_leaves	110	aa2f79a2f19d42db9cb8620483e02b5e
random_state	42	aa2f79a2f19d42db9cb8620483e02b5e
reg_alpha	3.512049970765783e-07	aa2f79a2f19d42db9cb8620483e02b5e
reg_lambda	0.02667691669589344	aa2f79a2f19d42db9cb8620483e02b5e
subsample	0.925626341241681	aa2f79a2f19d42db9cb8620483e02b5e
subsample_for_bin	200000	aa2f79a2f19d42db9cb8620483e02b5e
subsample_freq	0	aa2f79a2f19d42db9cb8620483e02b5e
metric	['None']	aa2f79a2f19d42db9cb8620483e02b5e
verbosity	-1	aa2f79a2f19d42db9cb8620483e02b5e
scale_pos_weight	11.387084592145015	aa2f79a2f19d42db9cb8620483e02b5e
objective	binary	aa2f79a2f19d42db9cb8620483e02b5e
num_threads	12	aa2f79a2f19d42db9cb8620483e02b5e
num_boost_round	300	aa2f79a2f19d42db9cb8620483e02b5e
feature_name	auto	aa2f79a2f19d42db9cb8620483e02b5e
categorical_feature	auto	aa2f79a2f19d42db9cb8620483e02b5e
keep_training_booster	False	aa2f79a2f19d42db9cb8620483e02b5e
boosting_type	gbdt	804bc8eb2efe4ead940fa0c158126ca0
colsample_bytree	0.5316335583221977	804bc8eb2efe4ead940fa0c158126ca0
learning_rate	0.015558661006171516	804bc8eb2efe4ead940fa0c158126ca0
max_depth	12	804bc8eb2efe4ead940fa0c158126ca0
min_child_samples	186	804bc8eb2efe4ead940fa0c158126ca0
min_child_weight	0.001	804bc8eb2efe4ead940fa0c158126ca0
min_split_gain	0.7959481082490345	804bc8eb2efe4ead940fa0c158126ca0
num_leaves	36	804bc8eb2efe4ead940fa0c158126ca0
random_state	42	804bc8eb2efe4ead940fa0c158126ca0
reg_alpha	8.387785625854567e-05	804bc8eb2efe4ead940fa0c158126ca0
reg_lambda	0.07477713066310461	804bc8eb2efe4ead940fa0c158126ca0
subsample	0.9498287330555968	804bc8eb2efe4ead940fa0c158126ca0
subsample_for_bin	200000	804bc8eb2efe4ead940fa0c158126ca0
subsample_freq	0	804bc8eb2efe4ead940fa0c158126ca0
metric	['None']	804bc8eb2efe4ead940fa0c158126ca0
verbosity	-1	804bc8eb2efe4ead940fa0c158126ca0
scale_pos_weight	11.387084592145015	804bc8eb2efe4ead940fa0c158126ca0
objective	binary	804bc8eb2efe4ead940fa0c158126ca0
num_threads	12	804bc8eb2efe4ead940fa0c158126ca0
num_boost_round	1000	804bc8eb2efe4ead940fa0c158126ca0
feature_name	auto	804bc8eb2efe4ead940fa0c158126ca0
categorical_feature	auto	804bc8eb2efe4ead940fa0c158126ca0
keep_training_booster	False	804bc8eb2efe4ead940fa0c158126ca0
boosting_type	gbdt	329d6d6fd07d4659b5300ae5ad320063
colsample_bytree	0.8809949115967088	329d6d6fd07d4659b5300ae5ad320063
learning_rate	0.05841189635630588	329d6d6fd07d4659b5300ae5ad320063
max_depth	7	329d6d6fd07d4659b5300ae5ad320063
min_child_samples	98	329d6d6fd07d4659b5300ae5ad320063
min_child_weight	0.001	329d6d6fd07d4659b5300ae5ad320063
min_split_gain	0.5449380653665857	329d6d6fd07d4659b5300ae5ad320063
num_leaves	181	329d6d6fd07d4659b5300ae5ad320063
random_state	42	329d6d6fd07d4659b5300ae5ad320063
reg_alpha	0.39773226315621346	329d6d6fd07d4659b5300ae5ad320063
reg_lambda	1.0772284778102629e-05	329d6d6fd07d4659b5300ae5ad320063
subsample	0.9163612447043101	329d6d6fd07d4659b5300ae5ad320063
subsample_for_bin	200000	329d6d6fd07d4659b5300ae5ad320063
subsample_freq	0	329d6d6fd07d4659b5300ae5ad320063
metric	['None']	329d6d6fd07d4659b5300ae5ad320063
verbosity	-1	329d6d6fd07d4659b5300ae5ad320063
scale_pos_weight	11.387084592145015	329d6d6fd07d4659b5300ae5ad320063
objective	binary	329d6d6fd07d4659b5300ae5ad320063
num_threads	12	329d6d6fd07d4659b5300ae5ad320063
num_boost_round	1500	329d6d6fd07d4659b5300ae5ad320063
feature_name	auto	329d6d6fd07d4659b5300ae5ad320063
categorical_feature	auto	329d6d6fd07d4659b5300ae5ad320063
keep_training_booster	False	329d6d6fd07d4659b5300ae5ad320063
boosting_type	gbdt	0260b00d3be4497b9ca6fbdcf0fb56f3
colsample_bytree	0.6902844604482308	0260b00d3be4497b9ca6fbdcf0fb56f3
learning_rate	0.10505721944042942	0260b00d3be4497b9ca6fbdcf0fb56f3
max_depth	12	0260b00d3be4497b9ca6fbdcf0fb56f3
min_child_samples	183	0260b00d3be4497b9ca6fbdcf0fb56f3
min_child_weight	0.001	0260b00d3be4497b9ca6fbdcf0fb56f3
min_split_gain	0.46860703307259477	0260b00d3be4497b9ca6fbdcf0fb56f3
num_leaves	136	0260b00d3be4497b9ca6fbdcf0fb56f3
random_state	42	0260b00d3be4497b9ca6fbdcf0fb56f3
reg_alpha	2.359603756160979e-05	0260b00d3be4497b9ca6fbdcf0fb56f3
reg_lambda	0.0008704994132573947	0260b00d3be4497b9ca6fbdcf0fb56f3
subsample	0.8040537775615212	0260b00d3be4497b9ca6fbdcf0fb56f3
subsample_for_bin	200000	0260b00d3be4497b9ca6fbdcf0fb56f3
subsample_freq	0	0260b00d3be4497b9ca6fbdcf0fb56f3
metric	['None']	0260b00d3be4497b9ca6fbdcf0fb56f3
verbosity	-1	0260b00d3be4497b9ca6fbdcf0fb56f3
scale_pos_weight	11.387084592145015	0260b00d3be4497b9ca6fbdcf0fb56f3
objective	binary	0260b00d3be4497b9ca6fbdcf0fb56f3
num_threads	12	0260b00d3be4497b9ca6fbdcf0fb56f3
num_boost_round	900	0260b00d3be4497b9ca6fbdcf0fb56f3
feature_name	auto	0260b00d3be4497b9ca6fbdcf0fb56f3
categorical_feature	auto	0260b00d3be4497b9ca6fbdcf0fb56f3
keep_training_booster	False	0260b00d3be4497b9ca6fbdcf0fb56f3
boosting_type	gbdt	e8d9a9ae1a314ef4822cb690114b565a
colsample_bytree	0.5009592718057839	e8d9a9ae1a314ef4822cb690114b565a
learning_rate	0.05180675532334693	e8d9a9ae1a314ef4822cb690114b565a
max_depth	12	e8d9a9ae1a314ef4822cb690114b565a
min_child_samples	199	e8d9a9ae1a314ef4822cb690114b565a
min_child_weight	0.001	e8d9a9ae1a314ef4822cb690114b565a
min_split_gain	0.7111272590731766	e8d9a9ae1a314ef4822cb690114b565a
num_leaves	115	e8d9a9ae1a314ef4822cb690114b565a
random_state	42	e8d9a9ae1a314ef4822cb690114b565a
reg_alpha	2.799154024719983e-08	e8d9a9ae1a314ef4822cb690114b565a
reg_lambda	0.0827761878616625	e8d9a9ae1a314ef4822cb690114b565a
subsample	0.9752959749906198	e8d9a9ae1a314ef4822cb690114b565a
subsample_for_bin	200000	e8d9a9ae1a314ef4822cb690114b565a
subsample_freq	0	e8d9a9ae1a314ef4822cb690114b565a
metric	['None']	e8d9a9ae1a314ef4822cb690114b565a
verbosity	-1	e8d9a9ae1a314ef4822cb690114b565a
scale_pos_weight	11.387084592145015	e8d9a9ae1a314ef4822cb690114b565a
objective	binary	e8d9a9ae1a314ef4822cb690114b565a
num_threads	12	e8d9a9ae1a314ef4822cb690114b565a
num_boost_round	1000	e8d9a9ae1a314ef4822cb690114b565a
feature_name	auto	e8d9a9ae1a314ef4822cb690114b565a
categorical_feature	auto	e8d9a9ae1a314ef4822cb690114b565a
keep_training_booster	False	e8d9a9ae1a314ef4822cb690114b565a
boosting_type	gbdt	0561a4c2b698400f949c0e76eef5fbdc
colsample_bytree	0.5136165328289238	0561a4c2b698400f949c0e76eef5fbdc
learning_rate	0.05157732430279213	0561a4c2b698400f949c0e76eef5fbdc
max_depth	11	0561a4c2b698400f949c0e76eef5fbdc
min_child_samples	138	0561a4c2b698400f949c0e76eef5fbdc
min_child_weight	0.001	0561a4c2b698400f949c0e76eef5fbdc
min_split_gain	0.6832798570733426	0561a4c2b698400f949c0e76eef5fbdc
num_leaves	54	0561a4c2b698400f949c0e76eef5fbdc
random_state	42	0561a4c2b698400f949c0e76eef5fbdc
reg_alpha	1.2587146083544201e-06	0561a4c2b698400f949c0e76eef5fbdc
reg_lambda	0.007007806816170971	0561a4c2b698400f949c0e76eef5fbdc
subsample	0.9507982069375642	0561a4c2b698400f949c0e76eef5fbdc
subsample_for_bin	200000	0561a4c2b698400f949c0e76eef5fbdc
subsample_freq	0	0561a4c2b698400f949c0e76eef5fbdc
metric	['None']	0561a4c2b698400f949c0e76eef5fbdc
verbosity	-1	0561a4c2b698400f949c0e76eef5fbdc
scale_pos_weight	11.387084592145015	0561a4c2b698400f949c0e76eef5fbdc
objective	binary	0561a4c2b698400f949c0e76eef5fbdc
num_threads	12	0561a4c2b698400f949c0e76eef5fbdc
num_boost_round	400	0561a4c2b698400f949c0e76eef5fbdc
feature_name	auto	0561a4c2b698400f949c0e76eef5fbdc
categorical_feature	auto	0561a4c2b698400f949c0e76eef5fbdc
keep_training_booster	False	0561a4c2b698400f949c0e76eef5fbdc
boosting_type	gbdt	40baf7c768a8472dac8cadf8920e416c
colsample_bytree	0.5279554817527723	40baf7c768a8472dac8cadf8920e416c
learning_rate	0.03663298440431181	40baf7c768a8472dac8cadf8920e416c
max_depth	12	40baf7c768a8472dac8cadf8920e416c
min_child_samples	155	40baf7c768a8472dac8cadf8920e416c
min_child_weight	0.001	40baf7c768a8472dac8cadf8920e416c
min_split_gain	0.24358439699537943	40baf7c768a8472dac8cadf8920e416c
num_leaves	22	40baf7c768a8472dac8cadf8920e416c
random_state	42	40baf7c768a8472dac8cadf8920e416c
reg_alpha	1.2625592096592566e-08	40baf7c768a8472dac8cadf8920e416c
reg_lambda	0.0032180371918658366	40baf7c768a8472dac8cadf8920e416c
subsample	0.9347467905458472	40baf7c768a8472dac8cadf8920e416c
subsample_for_bin	200000	40baf7c768a8472dac8cadf8920e416c
subsample_freq	0	40baf7c768a8472dac8cadf8920e416c
metric	['None']	40baf7c768a8472dac8cadf8920e416c
verbosity	-1	40baf7c768a8472dac8cadf8920e416c
scale_pos_weight	11.387084592145015	40baf7c768a8472dac8cadf8920e416c
objective	binary	40baf7c768a8472dac8cadf8920e416c
num_threads	12	40baf7c768a8472dac8cadf8920e416c
num_boost_round	300	40baf7c768a8472dac8cadf8920e416c
feature_name	auto	40baf7c768a8472dac8cadf8920e416c
categorical_feature	auto	40baf7c768a8472dac8cadf8920e416c
keep_training_booster	False	40baf7c768a8472dac8cadf8920e416c
num_boost_round	1800	a8008dd2ea1b43f196f1024d66cd3866
boosting_type	gbdt	c174b51cb9ef4197a069b455c2ae15f6
colsample_bytree	0.7945853496535786	c174b51cb9ef4197a069b455c2ae15f6
learning_rate	0.037253569652732806	c174b51cb9ef4197a069b455c2ae15f6
max_depth	10	c174b51cb9ef4197a069b455c2ae15f6
min_child_samples	173	c174b51cb9ef4197a069b455c2ae15f6
min_child_weight	0.001	c174b51cb9ef4197a069b455c2ae15f6
min_split_gain	0.5946964959442397	c174b51cb9ef4197a069b455c2ae15f6
num_leaves	95	c174b51cb9ef4197a069b455c2ae15f6
random_state	42	c174b51cb9ef4197a069b455c2ae15f6
reg_alpha	3.044416293533101e-07	c174b51cb9ef4197a069b455c2ae15f6
reg_lambda	0.606375530653603	c174b51cb9ef4197a069b455c2ae15f6
subsample	0.9825596971785199	c174b51cb9ef4197a069b455c2ae15f6
subsample_for_bin	200000	c174b51cb9ef4197a069b455c2ae15f6
subsample_freq	0	c174b51cb9ef4197a069b455c2ae15f6
metric	['None']	c174b51cb9ef4197a069b455c2ae15f6
verbosity	-1	c174b51cb9ef4197a069b455c2ae15f6
scale_pos_weight	11.387084592145015	c174b51cb9ef4197a069b455c2ae15f6
objective	binary	c174b51cb9ef4197a069b455c2ae15f6
num_threads	12	c174b51cb9ef4197a069b455c2ae15f6
num_boost_round	200	c174b51cb9ef4197a069b455c2ae15f6
feature_name	auto	c174b51cb9ef4197a069b455c2ae15f6
categorical_feature	auto	c174b51cb9ef4197a069b455c2ae15f6
keep_training_booster	False	c174b51cb9ef4197a069b455c2ae15f6
boosting_type	gbdt	82eba4c14c7b4ac791e397f13b4544de
colsample_bytree	0.6434990556635459	82eba4c14c7b4ac791e397f13b4544de
learning_rate	0.05218031411650868	82eba4c14c7b4ac791e397f13b4544de
max_depth	10	82eba4c14c7b4ac791e397f13b4544de
min_child_samples	179	82eba4c14c7b4ac791e397f13b4544de
min_child_weight	0.001	82eba4c14c7b4ac791e397f13b4544de
min_split_gain	0.9213987847025095	82eba4c14c7b4ac791e397f13b4544de
num_leaves	53	82eba4c14c7b4ac791e397f13b4544de
random_state	42	82eba4c14c7b4ac791e397f13b4544de
reg_alpha	1.0145942097573968e-07	82eba4c14c7b4ac791e397f13b4544de
reg_lambda	0.016465159890363935	82eba4c14c7b4ac791e397f13b4544de
subsample	0.8460845294669189	82eba4c14c7b4ac791e397f13b4544de
subsample_for_bin	200000	82eba4c14c7b4ac791e397f13b4544de
subsample_freq	0	82eba4c14c7b4ac791e397f13b4544de
metric	['None']	82eba4c14c7b4ac791e397f13b4544de
verbosity	-1	82eba4c14c7b4ac791e397f13b4544de
scale_pos_weight	11.387084592145015	82eba4c14c7b4ac791e397f13b4544de
objective	binary	82eba4c14c7b4ac791e397f13b4544de
num_threads	12	82eba4c14c7b4ac791e397f13b4544de
num_boost_round	1300	82eba4c14c7b4ac791e397f13b4544de
feature_name	auto	82eba4c14c7b4ac791e397f13b4544de
categorical_feature	auto	82eba4c14c7b4ac791e397f13b4544de
keep_training_booster	False	82eba4c14c7b4ac791e397f13b4544de
boosting_type	gbdt	982fe4200d6b4f95a5e5e436b1885c0b
colsample_bytree	0.6508303211110862	982fe4200d6b4f95a5e5e436b1885c0b
learning_rate	0.015887235185696864	982fe4200d6b4f95a5e5e436b1885c0b
max_depth	7	982fe4200d6b4f95a5e5e436b1885c0b
min_child_samples	175	982fe4200d6b4f95a5e5e436b1885c0b
min_child_weight	0.001	982fe4200d6b4f95a5e5e436b1885c0b
min_split_gain	0.7584475123602993	982fe4200d6b4f95a5e5e436b1885c0b
num_leaves	50	982fe4200d6b4f95a5e5e436b1885c0b
random_state	42	982fe4200d6b4f95a5e5e436b1885c0b
reg_alpha	4.1703239211329973e-07	982fe4200d6b4f95a5e5e436b1885c0b
reg_lambda	0.0015284756759219116	982fe4200d6b4f95a5e5e436b1885c0b
subsample	0.8365228631702074	982fe4200d6b4f95a5e5e436b1885c0b
subsample_for_bin	200000	982fe4200d6b4f95a5e5e436b1885c0b
subsample_freq	0	982fe4200d6b4f95a5e5e436b1885c0b
metric	['None']	982fe4200d6b4f95a5e5e436b1885c0b
verbosity	-1	982fe4200d6b4f95a5e5e436b1885c0b
scale_pos_weight	11.387084592145015	982fe4200d6b4f95a5e5e436b1885c0b
objective	binary	982fe4200d6b4f95a5e5e436b1885c0b
num_threads	12	982fe4200d6b4f95a5e5e436b1885c0b
num_boost_round	2000	982fe4200d6b4f95a5e5e436b1885c0b
feature_name	auto	982fe4200d6b4f95a5e5e436b1885c0b
categorical_feature	auto	982fe4200d6b4f95a5e5e436b1885c0b
keep_training_booster	False	982fe4200d6b4f95a5e5e436b1885c0b
feature_name	auto	a8008dd2ea1b43f196f1024d66cd3866
categorical_feature	auto	a8008dd2ea1b43f196f1024d66cd3866
keep_training_booster	False	a8008dd2ea1b43f196f1024d66cd3866
boosting_type	gbdt	8dd5e097c3e7404b8bb68ce4d54c81da
colsample_bytree	0.6215035197755712	8dd5e097c3e7404b8bb68ce4d54c81da
learning_rate	0.014636549459235633	8dd5e097c3e7404b8bb68ce4d54c81da
max_depth	11	8dd5e097c3e7404b8bb68ce4d54c81da
min_child_samples	122	8dd5e097c3e7404b8bb68ce4d54c81da
min_child_weight	0.001	8dd5e097c3e7404b8bb68ce4d54c81da
min_split_gain	0.38796746444109864	8dd5e097c3e7404b8bb68ce4d54c81da
num_leaves	55	8dd5e097c3e7404b8bb68ce4d54c81da
random_state	42	8dd5e097c3e7404b8bb68ce4d54c81da
reg_alpha	7.787981717647637e-08	8dd5e097c3e7404b8bb68ce4d54c81da
reg_lambda	1.6088916146405634	8dd5e097c3e7404b8bb68ce4d54c81da
subsample	0.9234159320000446	8dd5e097c3e7404b8bb68ce4d54c81da
subsample_for_bin	200000	8dd5e097c3e7404b8bb68ce4d54c81da
subsample_freq	0	8dd5e097c3e7404b8bb68ce4d54c81da
metric	['None']	8dd5e097c3e7404b8bb68ce4d54c81da
verbosity	-1	8dd5e097c3e7404b8bb68ce4d54c81da
scale_pos_weight	11.387084592145015	8dd5e097c3e7404b8bb68ce4d54c81da
objective	binary	8dd5e097c3e7404b8bb68ce4d54c81da
num_threads	12	8dd5e097c3e7404b8bb68ce4d54c81da
num_boost_round	600	8dd5e097c3e7404b8bb68ce4d54c81da
boosting_type	gbdt	581effbe4a2f4945aaadeb01b564b851
colsample_bytree	0.6507825074858644	581effbe4a2f4945aaadeb01b564b851
learning_rate	0.056241703566116956	581effbe4a2f4945aaadeb01b564b851
max_depth	11	581effbe4a2f4945aaadeb01b564b851
min_child_samples	154	581effbe4a2f4945aaadeb01b564b851
min_child_weight	0.001	581effbe4a2f4945aaadeb01b564b851
min_split_gain	0.42720122264691907	581effbe4a2f4945aaadeb01b564b851
num_leaves	24	581effbe4a2f4945aaadeb01b564b851
random_state	42	581effbe4a2f4945aaadeb01b564b851
reg_alpha	6.727773296782298e-08	581effbe4a2f4945aaadeb01b564b851
reg_lambda	0.004682369226096957	581effbe4a2f4945aaadeb01b564b851
subsample	0.7728690106458456	581effbe4a2f4945aaadeb01b564b851
subsample_for_bin	200000	581effbe4a2f4945aaadeb01b564b851
subsample_freq	0	581effbe4a2f4945aaadeb01b564b851
metric	['None']	581effbe4a2f4945aaadeb01b564b851
verbosity	-1	581effbe4a2f4945aaadeb01b564b851
scale_pos_weight	11.387084592145015	581effbe4a2f4945aaadeb01b564b851
objective	binary	581effbe4a2f4945aaadeb01b564b851
num_threads	12	581effbe4a2f4945aaadeb01b564b851
num_boost_round	900	581effbe4a2f4945aaadeb01b564b851
feature_name	auto	581effbe4a2f4945aaadeb01b564b851
categorical_feature	auto	581effbe4a2f4945aaadeb01b564b851
keep_training_booster	False	581effbe4a2f4945aaadeb01b564b851
boosting_type	gbdt	d90190edced44c048d8f32ec24d761bb
colsample_bytree	0.5751388587762748	d90190edced44c048d8f32ec24d761bb
learning_rate	0.01871469589304053	d90190edced44c048d8f32ec24d761bb
max_depth	9	d90190edced44c048d8f32ec24d761bb
min_child_samples	134	d90190edced44c048d8f32ec24d761bb
min_child_weight	0.001	d90190edced44c048d8f32ec24d761bb
min_split_gain	0.9546055357763985	d90190edced44c048d8f32ec24d761bb
num_leaves	90	d90190edced44c048d8f32ec24d761bb
random_state	42	d90190edced44c048d8f32ec24d761bb
reg_alpha	3.01548287096939e-07	d90190edced44c048d8f32ec24d761bb
reg_lambda	1.4014349763954945	d90190edced44c048d8f32ec24d761bb
subsample	0.7030993950268065	d90190edced44c048d8f32ec24d761bb
subsample_for_bin	200000	d90190edced44c048d8f32ec24d761bb
subsample_freq	0	d90190edced44c048d8f32ec24d761bb
metric	['None']	d90190edced44c048d8f32ec24d761bb
verbosity	-1	d90190edced44c048d8f32ec24d761bb
scale_pos_weight	11.387084592145015	d90190edced44c048d8f32ec24d761bb
objective	binary	d90190edced44c048d8f32ec24d761bb
num_threads	12	d90190edced44c048d8f32ec24d761bb
num_boost_round	1900	d90190edced44c048d8f32ec24d761bb
feature_name	auto	d90190edced44c048d8f32ec24d761bb
categorical_feature	auto	d90190edced44c048d8f32ec24d761bb
keep_training_booster	False	d90190edced44c048d8f32ec24d761bb
boosting_type	gbdt	3ac81d7485e549e392a19922b5afb56d
colsample_bytree	0.588871619099407	3ac81d7485e549e392a19922b5afb56d
learning_rate	0.034091775226855504	3ac81d7485e549e392a19922b5afb56d
max_depth	11	3ac81d7485e549e392a19922b5afb56d
min_child_samples	197	3ac81d7485e549e392a19922b5afb56d
min_child_weight	0.001	3ac81d7485e549e392a19922b5afb56d
min_split_gain	0.5394638517842171	3ac81d7485e549e392a19922b5afb56d
num_leaves	40	3ac81d7485e549e392a19922b5afb56d
random_state	42	3ac81d7485e549e392a19922b5afb56d
reg_alpha	5.777887738476337e-08	3ac81d7485e549e392a19922b5afb56d
reg_lambda	0.03012789094938503	3ac81d7485e549e392a19922b5afb56d
subsample	0.9168988020596762	3ac81d7485e549e392a19922b5afb56d
subsample_for_bin	200000	3ac81d7485e549e392a19922b5afb56d
subsample_freq	0	3ac81d7485e549e392a19922b5afb56d
metric	['None']	3ac81d7485e549e392a19922b5afb56d
verbosity	-1	3ac81d7485e549e392a19922b5afb56d
scale_pos_weight	11.387084592145015	3ac81d7485e549e392a19922b5afb56d
objective	binary	3ac81d7485e549e392a19922b5afb56d
num_threads	12	3ac81d7485e549e392a19922b5afb56d
num_boost_round	500	3ac81d7485e549e392a19922b5afb56d
feature_name	auto	3ac81d7485e549e392a19922b5afb56d
categorical_feature	auto	3ac81d7485e549e392a19922b5afb56d
keep_training_booster	False	3ac81d7485e549e392a19922b5afb56d
boosting_type	gbdt	9310e0296fef46229d141a34118600f6
colsample_bytree	0.5638465995774167	9310e0296fef46229d141a34118600f6
learning_rate	0.043629005093107985	9310e0296fef46229d141a34118600f6
max_depth	11	9310e0296fef46229d141a34118600f6
min_child_samples	194	9310e0296fef46229d141a34118600f6
min_child_weight	0.001	9310e0296fef46229d141a34118600f6
min_split_gain	0.4807909484940105	9310e0296fef46229d141a34118600f6
num_leaves	19	9310e0296fef46229d141a34118600f6
random_state	42	9310e0296fef46229d141a34118600f6
reg_alpha	3.1589637766097725e-08	9310e0296fef46229d141a34118600f6
reg_lambda	8.287753510111855	9310e0296fef46229d141a34118600f6
subsample	0.9969324862392331	9310e0296fef46229d141a34118600f6
subsample_for_bin	200000	9310e0296fef46229d141a34118600f6
subsample_freq	0	9310e0296fef46229d141a34118600f6
metric	['None']	9310e0296fef46229d141a34118600f6
verbosity	-1	9310e0296fef46229d141a34118600f6
scale_pos_weight	11.387084592145015	9310e0296fef46229d141a34118600f6
objective	binary	9310e0296fef46229d141a34118600f6
num_threads	12	9310e0296fef46229d141a34118600f6
num_boost_round	1100	9310e0296fef46229d141a34118600f6
feature_name	auto	9310e0296fef46229d141a34118600f6
categorical_feature	auto	9310e0296fef46229d141a34118600f6
keep_training_booster	False	9310e0296fef46229d141a34118600f6
boosting_type	gbdt	8dd0782b26a647b0924ccd9a97b01735
colsample_bytree	0.6205275874964242	8dd0782b26a647b0924ccd9a97b01735
learning_rate	0.052025281824683	8dd0782b26a647b0924ccd9a97b01735
max_depth	11	8dd0782b26a647b0924ccd9a97b01735
min_child_samples	176	8dd0782b26a647b0924ccd9a97b01735
min_child_weight	0.001	8dd0782b26a647b0924ccd9a97b01735
min_split_gain	0.5013570174469671	8dd0782b26a647b0924ccd9a97b01735
num_leaves	26	8dd0782b26a647b0924ccd9a97b01735
random_state	42	8dd0782b26a647b0924ccd9a97b01735
reg_alpha	6.080775164714881e-08	8dd0782b26a647b0924ccd9a97b01735
reg_lambda	7.060102547614765	8dd0782b26a647b0924ccd9a97b01735
subsample	0.9550595797012819	8dd0782b26a647b0924ccd9a97b01735
subsample_for_bin	200000	8dd0782b26a647b0924ccd9a97b01735
subsample_freq	0	8dd0782b26a647b0924ccd9a97b01735
metric	['None']	8dd0782b26a647b0924ccd9a97b01735
verbosity	-1	8dd0782b26a647b0924ccd9a97b01735
scale_pos_weight	11.387084592145015	8dd0782b26a647b0924ccd9a97b01735
objective	binary	8dd0782b26a647b0924ccd9a97b01735
num_threads	12	8dd0782b26a647b0924ccd9a97b01735
num_boost_round	1000	8dd0782b26a647b0924ccd9a97b01735
feature_name	auto	8dd0782b26a647b0924ccd9a97b01735
categorical_feature	auto	8dd0782b26a647b0924ccd9a97b01735
keep_training_booster	False	8dd0782b26a647b0924ccd9a97b01735
boosting_type	gbdt	17cdd4ed361b4c6aa962d390cb1f5fc5
colsample_bytree	0.5502816763648806	17cdd4ed361b4c6aa962d390cb1f5fc5
learning_rate	0.023889447179649116	17cdd4ed361b4c6aa962d390cb1f5fc5
max_depth	11	17cdd4ed361b4c6aa962d390cb1f5fc5
min_child_samples	189	17cdd4ed361b4c6aa962d390cb1f5fc5
min_child_weight	0.001	17cdd4ed361b4c6aa962d390cb1f5fc5
min_split_gain	0.7587109446041786	17cdd4ed361b4c6aa962d390cb1f5fc5
num_leaves	26	17cdd4ed361b4c6aa962d390cb1f5fc5
random_state	42	17cdd4ed361b4c6aa962d390cb1f5fc5
reg_alpha	2.5876270506315506e-08	17cdd4ed361b4c6aa962d390cb1f5fc5
reg_lambda	1.7380795812428735	17cdd4ed361b4c6aa962d390cb1f5fc5
subsample	0.9329058752585103	17cdd4ed361b4c6aa962d390cb1f5fc5
subsample_for_bin	200000	17cdd4ed361b4c6aa962d390cb1f5fc5
subsample_freq	0	17cdd4ed361b4c6aa962d390cb1f5fc5
metric	['None']	17cdd4ed361b4c6aa962d390cb1f5fc5
verbosity	-1	17cdd4ed361b4c6aa962d390cb1f5fc5
scale_pos_weight	11.387084592145015	17cdd4ed361b4c6aa962d390cb1f5fc5
objective	binary	17cdd4ed361b4c6aa962d390cb1f5fc5
num_threads	12	17cdd4ed361b4c6aa962d390cb1f5fc5
num_boost_round	1100	17cdd4ed361b4c6aa962d390cb1f5fc5
feature_name	auto	17cdd4ed361b4c6aa962d390cb1f5fc5
categorical_feature	auto	17cdd4ed361b4c6aa962d390cb1f5fc5
keep_training_booster	False	17cdd4ed361b4c6aa962d390cb1f5fc5
boosting_type	gbdt	3401268c42cb4248abf5eb0c4fca768a
colsample_bytree	0.5778805431006951	3401268c42cb4248abf5eb0c4fca768a
learning_rate	0.05424720393250283	3401268c42cb4248abf5eb0c4fca768a
max_depth	8	3401268c42cb4248abf5eb0c4fca768a
min_child_samples	187	3401268c42cb4248abf5eb0c4fca768a
min_child_weight	0.001	3401268c42cb4248abf5eb0c4fca768a
min_split_gain	0.5539055851371202	3401268c42cb4248abf5eb0c4fca768a
num_leaves	55	3401268c42cb4248abf5eb0c4fca768a
random_state	42	3401268c42cb4248abf5eb0c4fca768a
reg_alpha	3.0813746644642906e-07	3401268c42cb4248abf5eb0c4fca768a
reg_lambda	2.648649498531214	3401268c42cb4248abf5eb0c4fca768a
subsample	0.9762238009759409	3401268c42cb4248abf5eb0c4fca768a
subsample_for_bin	200000	3401268c42cb4248abf5eb0c4fca768a
subsample_freq	0	3401268c42cb4248abf5eb0c4fca768a
metric	['None']	3401268c42cb4248abf5eb0c4fca768a
verbosity	-1	3401268c42cb4248abf5eb0c4fca768a
scale_pos_weight	11.387084592145015	3401268c42cb4248abf5eb0c4fca768a
objective	binary	3401268c42cb4248abf5eb0c4fca768a
num_threads	12	3401268c42cb4248abf5eb0c4fca768a
num_boost_round	1400	3401268c42cb4248abf5eb0c4fca768a
feature_name	auto	3401268c42cb4248abf5eb0c4fca768a
categorical_feature	auto	3401268c42cb4248abf5eb0c4fca768a
keep_training_booster	False	3401268c42cb4248abf5eb0c4fca768a
boosting_type	gbdt	701e73d0f1184acd9682089de7c9c496
colsample_bytree	0.5112754832510545	701e73d0f1184acd9682089de7c9c496
learning_rate	0.01806664949852473	701e73d0f1184acd9682089de7c9c496
max_depth	12	701e73d0f1184acd9682089de7c9c496
min_child_samples	179	701e73d0f1184acd9682089de7c9c496
min_child_weight	0.001	701e73d0f1184acd9682089de7c9c496
min_split_gain	0.48231384982691355	701e73d0f1184acd9682089de7c9c496
num_leaves	22	701e73d0f1184acd9682089de7c9c496
random_state	42	701e73d0f1184acd9682089de7c9c496
reg_alpha	3.1059136568620956e-07	701e73d0f1184acd9682089de7c9c496
reg_lambda	0.05570640054989467	701e73d0f1184acd9682089de7c9c496
subsample	0.9727144888951085	701e73d0f1184acd9682089de7c9c496
subsample_for_bin	200000	701e73d0f1184acd9682089de7c9c496
subsample_freq	0	701e73d0f1184acd9682089de7c9c496
metric	['None']	701e73d0f1184acd9682089de7c9c496
verbosity	-1	701e73d0f1184acd9682089de7c9c496
scale_pos_weight	11.387084592145015	701e73d0f1184acd9682089de7c9c496
objective	binary	701e73d0f1184acd9682089de7c9c496
num_threads	12	701e73d0f1184acd9682089de7c9c496
num_boost_round	600	701e73d0f1184acd9682089de7c9c496
feature_name	auto	701e73d0f1184acd9682089de7c9c496
categorical_feature	auto	701e73d0f1184acd9682089de7c9c496
keep_training_booster	False	701e73d0f1184acd9682089de7c9c496
boosting_type	gbdt	8e5b753561c44b3195234ef62f8f47b2
boosting_type	gbdt	cfd7a5c4650749a99227270f7490d366
colsample_bytree	0.6676244590015054	8e5b753561c44b3195234ef62f8f47b2
learning_rate	0.01897222702003954	8e5b753561c44b3195234ef62f8f47b2
max_depth	12	8e5b753561c44b3195234ef62f8f47b2
min_child_samples	200	8e5b753561c44b3195234ef62f8f47b2
min_child_weight	0.001	8e5b753561c44b3195234ef62f8f47b2
min_split_gain	0.8973125466964056	8e5b753561c44b3195234ef62f8f47b2
num_leaves	69	8e5b753561c44b3195234ef62f8f47b2
random_state	42	8e5b753561c44b3195234ef62f8f47b2
reg_alpha	2.960345049939783e-08	8e5b753561c44b3195234ef62f8f47b2
reg_lambda	1.7004353699422081	8e5b753561c44b3195234ef62f8f47b2
subsample	0.9996129374264743	8e5b753561c44b3195234ef62f8f47b2
subsample_for_bin	200000	8e5b753561c44b3195234ef62f8f47b2
subsample_freq	0	8e5b753561c44b3195234ef62f8f47b2
metric	['None']	8e5b753561c44b3195234ef62f8f47b2
verbosity	-1	8e5b753561c44b3195234ef62f8f47b2
scale_pos_weight	11.387084592145015	8e5b753561c44b3195234ef62f8f47b2
objective	binary	8e5b753561c44b3195234ef62f8f47b2
num_threads	12	8e5b753561c44b3195234ef62f8f47b2
num_boost_round	500	8e5b753561c44b3195234ef62f8f47b2
feature_name	auto	8e5b753561c44b3195234ef62f8f47b2
categorical_feature	auto	8e5b753561c44b3195234ef62f8f47b2
keep_training_booster	False	8e5b753561c44b3195234ef62f8f47b2
boosting_type	gbdt	86e01e0667ec427599d0c10de411791f
colsample_bytree	0.5841474910242411	86e01e0667ec427599d0c10de411791f
learning_rate	0.009718262306071025	86e01e0667ec427599d0c10de411791f
max_depth	5	86e01e0667ec427599d0c10de411791f
min_child_samples	173	86e01e0667ec427599d0c10de411791f
min_child_weight	0.001	86e01e0667ec427599d0c10de411791f
min_split_gain	0.906533665136291	86e01e0667ec427599d0c10de411791f
num_leaves	71	86e01e0667ec427599d0c10de411791f
random_state	42	86e01e0667ec427599d0c10de411791f
reg_alpha	6.794630786113977e-07	86e01e0667ec427599d0c10de411791f
reg_lambda	1.251103303566855	86e01e0667ec427599d0c10de411791f
subsample	0.8441086914895144	86e01e0667ec427599d0c10de411791f
subsample_for_bin	200000	86e01e0667ec427599d0c10de411791f
subsample_freq	0	86e01e0667ec427599d0c10de411791f
metric	['None']	86e01e0667ec427599d0c10de411791f
verbosity	-1	86e01e0667ec427599d0c10de411791f
scale_pos_weight	11.387084592145015	86e01e0667ec427599d0c10de411791f
objective	binary	86e01e0667ec427599d0c10de411791f
num_threads	12	86e01e0667ec427599d0c10de411791f
num_boost_round	1900	86e01e0667ec427599d0c10de411791f
feature_name	auto	86e01e0667ec427599d0c10de411791f
categorical_feature	auto	86e01e0667ec427599d0c10de411791f
keep_training_booster	False	86e01e0667ec427599d0c10de411791f
feature_name	auto	8dd5e097c3e7404b8bb68ce4d54c81da
categorical_feature	auto	8dd5e097c3e7404b8bb68ce4d54c81da
keep_training_booster	False	8dd5e097c3e7404b8bb68ce4d54c81da
colsample_bytree	0.5349259927975965	bf5751b68e994a81998944e44b1b573d
learning_rate	0.008781484068877297	bf5751b68e994a81998944e44b1b573d
max_depth	5	bf5751b68e994a81998944e44b1b573d
min_child_samples	179	bf5751b68e994a81998944e44b1b573d
min_child_weight	0.001	bf5751b68e994a81998944e44b1b573d
min_split_gain	0.9783435381372595	bf5751b68e994a81998944e44b1b573d
num_leaves	63	bf5751b68e994a81998944e44b1b573d
random_state	42	bf5751b68e994a81998944e44b1b573d
reg_alpha	9.527041813550099	bf5751b68e994a81998944e44b1b573d
reg_lambda	0.019135432963578617	bf5751b68e994a81998944e44b1b573d
subsample	0.8216895305455624	bf5751b68e994a81998944e44b1b573d
subsample_for_bin	200000	bf5751b68e994a81998944e44b1b573d
subsample_freq	0	bf5751b68e994a81998944e44b1b573d
metric	['None']	bf5751b68e994a81998944e44b1b573d
verbosity	-1	bf5751b68e994a81998944e44b1b573d
scale_pos_weight	11.387084592145015	bf5751b68e994a81998944e44b1b573d
objective	binary	bf5751b68e994a81998944e44b1b573d
num_threads	12	bf5751b68e994a81998944e44b1b573d
num_boost_round	1700	bf5751b68e994a81998944e44b1b573d
feature_name	auto	bf5751b68e994a81998944e44b1b573d
categorical_feature	auto	bf5751b68e994a81998944e44b1b573d
keep_training_booster	False	bf5751b68e994a81998944e44b1b573d
boosting_type	gbdt	5e4c9e7de52d47a391919bb68173e02c
colsample_bytree	0.9245650678006332	5e4c9e7de52d47a391919bb68173e02c
learning_rate	0.011008586960475547	5e4c9e7de52d47a391919bb68173e02c
max_depth	7	5e4c9e7de52d47a391919bb68173e02c
min_child_samples	59	5e4c9e7de52d47a391919bb68173e02c
min_child_weight	0.001	5e4c9e7de52d47a391919bb68173e02c
min_split_gain	0.6470189407523153	5e4c9e7de52d47a391919bb68173e02c
num_leaves	110	5e4c9e7de52d47a391919bb68173e02c
random_state	42	5e4c9e7de52d47a391919bb68173e02c
reg_alpha	0.00025754456940169996	5e4c9e7de52d47a391919bb68173e02c
reg_lambda	0.006688004870044283	5e4c9e7de52d47a391919bb68173e02c
subsample	0.6365597233927656	5e4c9e7de52d47a391919bb68173e02c
subsample_for_bin	200000	5e4c9e7de52d47a391919bb68173e02c
subsample_freq	0	5e4c9e7de52d47a391919bb68173e02c
metric	['None']	5e4c9e7de52d47a391919bb68173e02c
verbosity	-1	5e4c9e7de52d47a391919bb68173e02c
scale_pos_weight	11.387084592145015	5e4c9e7de52d47a391919bb68173e02c
objective	binary	5e4c9e7de52d47a391919bb68173e02c
num_threads	12	5e4c9e7de52d47a391919bb68173e02c
num_boost_round	1500	5e4c9e7de52d47a391919bb68173e02c
feature_name	auto	5e4c9e7de52d47a391919bb68173e02c
categorical_feature	auto	5e4c9e7de52d47a391919bb68173e02c
boosting_type	gbdt	cf02466f55074fecb9cf4a06f6468695
colsample_bytree	0.8481874025763952	cf02466f55074fecb9cf4a06f6468695
learning_rate	0.011575949176671388	cf02466f55074fecb9cf4a06f6468695
max_depth	7	cf02466f55074fecb9cf4a06f6468695
min_child_samples	174	cf02466f55074fecb9cf4a06f6468695
min_child_weight	0.001	cf02466f55074fecb9cf4a06f6468695
min_split_gain	0.8962954841759379	cf02466f55074fecb9cf4a06f6468695
num_leaves	36	cf02466f55074fecb9cf4a06f6468695
random_state	42	cf02466f55074fecb9cf4a06f6468695
reg_alpha	0.000880299562368459	cf02466f55074fecb9cf4a06f6468695
reg_lambda	0.44112204430182267	cf02466f55074fecb9cf4a06f6468695
subsample	0.9340635162178816	cf02466f55074fecb9cf4a06f6468695
subsample_for_bin	200000	cf02466f55074fecb9cf4a06f6468695
subsample_freq	0	cf02466f55074fecb9cf4a06f6468695
metric	['None']	cf02466f55074fecb9cf4a06f6468695
verbosity	-1	cf02466f55074fecb9cf4a06f6468695
scale_pos_weight	11.387084592145015	cf02466f55074fecb9cf4a06f6468695
objective	binary	cf02466f55074fecb9cf4a06f6468695
num_threads	12	cf02466f55074fecb9cf4a06f6468695
num_boost_round	1900	cf02466f55074fecb9cf4a06f6468695
feature_name	auto	cf02466f55074fecb9cf4a06f6468695
categorical_feature	auto	cf02466f55074fecb9cf4a06f6468695
keep_training_booster	False	cf02466f55074fecb9cf4a06f6468695
boosting_type	gbdt	ea474e0674fd492c81f549be6c166cd2
colsample_bytree	0.674649971494822	ea474e0674fd492c81f549be6c166cd2
learning_rate	0.02159302558818962	ea474e0674fd492c81f549be6c166cd2
max_depth	4	ea474e0674fd492c81f549be6c166cd2
min_child_samples	157	ea474e0674fd492c81f549be6c166cd2
min_child_weight	0.001	ea474e0674fd492c81f549be6c166cd2
min_split_gain	0.8256831676197012	ea474e0674fd492c81f549be6c166cd2
num_leaves	132	ea474e0674fd492c81f549be6c166cd2
random_state	42	ea474e0674fd492c81f549be6c166cd2
reg_alpha	2.3186922054597788e-07	ea474e0674fd492c81f549be6c166cd2
reg_lambda	2.732241363452164	ea474e0674fd492c81f549be6c166cd2
subsample	0.7931735426835079	ea474e0674fd492c81f549be6c166cd2
subsample_for_bin	200000	ea474e0674fd492c81f549be6c166cd2
subsample_freq	0	ea474e0674fd492c81f549be6c166cd2
metric	['None']	ea474e0674fd492c81f549be6c166cd2
verbosity	-1	ea474e0674fd492c81f549be6c166cd2
scale_pos_weight	11.387084592145015	ea474e0674fd492c81f549be6c166cd2
objective	binary	ea474e0674fd492c81f549be6c166cd2
num_threads	12	ea474e0674fd492c81f549be6c166cd2
num_boost_round	1800	ea474e0674fd492c81f549be6c166cd2
feature_name	auto	ea474e0674fd492c81f549be6c166cd2
categorical_feature	auto	ea474e0674fd492c81f549be6c166cd2
keep_training_booster	False	ea474e0674fd492c81f549be6c166cd2
boosting_type	gbdt	09141ce7bff34a53b91aedc1c71e0d1c
colsample_bytree	0.6679343336664079	09141ce7bff34a53b91aedc1c71e0d1c
learning_rate	0.011659051506876749	09141ce7bff34a53b91aedc1c71e0d1c
max_depth	6	09141ce7bff34a53b91aedc1c71e0d1c
min_child_samples	175	09141ce7bff34a53b91aedc1c71e0d1c
min_child_weight	0.001	09141ce7bff34a53b91aedc1c71e0d1c
min_split_gain	0.8917232327385313	09141ce7bff34a53b91aedc1c71e0d1c
num_leaves	113	09141ce7bff34a53b91aedc1c71e0d1c
random_state	42	09141ce7bff34a53b91aedc1c71e0d1c
reg_alpha	1.9432606915152858e-07	09141ce7bff34a53b91aedc1c71e0d1c
reg_lambda	8.608570633790311	09141ce7bff34a53b91aedc1c71e0d1c
subsample	0.9446830777563866	09141ce7bff34a53b91aedc1c71e0d1c
subsample_for_bin	200000	09141ce7bff34a53b91aedc1c71e0d1c
subsample_freq	0	09141ce7bff34a53b91aedc1c71e0d1c
metric	['None']	09141ce7bff34a53b91aedc1c71e0d1c
verbosity	-1	09141ce7bff34a53b91aedc1c71e0d1c
scale_pos_weight	11.387084592145015	09141ce7bff34a53b91aedc1c71e0d1c
objective	binary	09141ce7bff34a53b91aedc1c71e0d1c
num_threads	12	09141ce7bff34a53b91aedc1c71e0d1c
num_boost_round	1900	09141ce7bff34a53b91aedc1c71e0d1c
feature_name	auto	09141ce7bff34a53b91aedc1c71e0d1c
categorical_feature	auto	09141ce7bff34a53b91aedc1c71e0d1c
keep_training_booster	False	09141ce7bff34a53b91aedc1c71e0d1c
boosting_type	gbdt	ed12fbe584314822bdbf2b28e61fd9f4
colsample_bytree	0.8759846119853718	ed12fbe584314822bdbf2b28e61fd9f4
learning_rate	0.007110283344377877	ed12fbe584314822bdbf2b28e61fd9f4
max_depth	12	ed12fbe584314822bdbf2b28e61fd9f4
min_child_samples	121	ed12fbe584314822bdbf2b28e61fd9f4
min_child_weight	0.001	ed12fbe584314822bdbf2b28e61fd9f4
min_split_gain	0.179666174260813	ed12fbe584314822bdbf2b28e61fd9f4
num_leaves	134	ed12fbe584314822bdbf2b28e61fd9f4
random_state	42	ed12fbe584314822bdbf2b28e61fd9f4
reg_alpha	0.23694389183954392	ed12fbe584314822bdbf2b28e61fd9f4
reg_lambda	1.6126173245525298e-05	ed12fbe584314822bdbf2b28e61fd9f4
subsample	0.8536124095182277	ed12fbe584314822bdbf2b28e61fd9f4
subsample_for_bin	200000	ed12fbe584314822bdbf2b28e61fd9f4
subsample_freq	0	ed12fbe584314822bdbf2b28e61fd9f4
metric	['None']	ed12fbe584314822bdbf2b28e61fd9f4
verbosity	-1	ed12fbe584314822bdbf2b28e61fd9f4
scale_pos_weight	11.387084592145015	ed12fbe584314822bdbf2b28e61fd9f4
objective	binary	ed12fbe584314822bdbf2b28e61fd9f4
num_threads	12	ed12fbe584314822bdbf2b28e61fd9f4
num_boost_round	500	ed12fbe584314822bdbf2b28e61fd9f4
feature_name	auto	ed12fbe584314822bdbf2b28e61fd9f4
categorical_feature	auto	ed12fbe584314822bdbf2b28e61fd9f4
keep_training_booster	False	ed12fbe584314822bdbf2b28e61fd9f4
boosting_type	gbdt	bf5751b68e994a81998944e44b1b573d
colsample_bytree	0.8754289525640705	cfd7a5c4650749a99227270f7490d366
learning_rate	0.009363117454001701	cfd7a5c4650749a99227270f7490d366
max_depth	7	cfd7a5c4650749a99227270f7490d366
min_child_samples	174	cfd7a5c4650749a99227270f7490d366
min_child_weight	0.001	cfd7a5c4650749a99227270f7490d366
min_split_gain	0.9222659858550093	cfd7a5c4650749a99227270f7490d366
num_leaves	20	cfd7a5c4650749a99227270f7490d366
random_state	42	cfd7a5c4650749a99227270f7490d366
reg_alpha	0.034388000757576316	cfd7a5c4650749a99227270f7490d366
reg_lambda	0.031706830384361874	cfd7a5c4650749a99227270f7490d366
subsample	0.9506910573640106	cfd7a5c4650749a99227270f7490d366
subsample_for_bin	200000	cfd7a5c4650749a99227270f7490d366
subsample_freq	0	cfd7a5c4650749a99227270f7490d366
metric	['None']	cfd7a5c4650749a99227270f7490d366
verbosity	-1	cfd7a5c4650749a99227270f7490d366
scale_pos_weight	11.387084592145015	cfd7a5c4650749a99227270f7490d366
objective	binary	cfd7a5c4650749a99227270f7490d366
num_threads	12	cfd7a5c4650749a99227270f7490d366
num_boost_round	2000	cfd7a5c4650749a99227270f7490d366
feature_name	auto	cfd7a5c4650749a99227270f7490d366
categorical_feature	auto	cfd7a5c4650749a99227270f7490d366
keep_training_booster	False	cfd7a5c4650749a99227270f7490d366
boosting_type	gbdt	8f70bc6c911d4d3daac5817bcbceb1c8
colsample_bytree	0.8555029910567422	8f70bc6c911d4d3daac5817bcbceb1c8
learning_rate	0.018100161514489548	8f70bc6c911d4d3daac5817bcbceb1c8
max_depth	6	8f70bc6c911d4d3daac5817bcbceb1c8
min_child_samples	151	8f70bc6c911d4d3daac5817bcbceb1c8
min_child_weight	0.001	8f70bc6c911d4d3daac5817bcbceb1c8
min_split_gain	0.7974476731126692	8f70bc6c911d4d3daac5817bcbceb1c8
num_leaves	69	8f70bc6c911d4d3daac5817bcbceb1c8
random_state	42	8f70bc6c911d4d3daac5817bcbceb1c8
reg_alpha	6.976283287830457e-05	8f70bc6c911d4d3daac5817bcbceb1c8
reg_lambda	0.6221326977600845	8f70bc6c911d4d3daac5817bcbceb1c8
subsample	0.941128148096261	8f70bc6c911d4d3daac5817bcbceb1c8
subsample_for_bin	200000	8f70bc6c911d4d3daac5817bcbceb1c8
subsample_freq	0	8f70bc6c911d4d3daac5817bcbceb1c8
metric	['None']	8f70bc6c911d4d3daac5817bcbceb1c8
verbosity	-1	8f70bc6c911d4d3daac5817bcbceb1c8
scale_pos_weight	11.387084592145015	8f70bc6c911d4d3daac5817bcbceb1c8
objective	binary	8f70bc6c911d4d3daac5817bcbceb1c8
num_threads	12	8f70bc6c911d4d3daac5817bcbceb1c8
num_boost_round	1900	8f70bc6c911d4d3daac5817bcbceb1c8
feature_name	auto	8f70bc6c911d4d3daac5817bcbceb1c8
categorical_feature	auto	8f70bc6c911d4d3daac5817bcbceb1c8
keep_training_booster	False	8f70bc6c911d4d3daac5817bcbceb1c8
boosting_type	gbdt	491c6531e590476ba6d0e4c3f8ee4002
colsample_bytree	0.8001976064831829	491c6531e590476ba6d0e4c3f8ee4002
learning_rate	0.008234136821859432	491c6531e590476ba6d0e4c3f8ee4002
max_depth	5	491c6531e590476ba6d0e4c3f8ee4002
min_child_samples	182	491c6531e590476ba6d0e4c3f8ee4002
min_child_weight	0.001	491c6531e590476ba6d0e4c3f8ee4002
min_split_gain	0.916966081300495	491c6531e590476ba6d0e4c3f8ee4002
num_leaves	78	491c6531e590476ba6d0e4c3f8ee4002
random_state	42	491c6531e590476ba6d0e4c3f8ee4002
reg_alpha	0.024526660637921895	491c6531e590476ba6d0e4c3f8ee4002
reg_lambda	0.42782103125739596	491c6531e590476ba6d0e4c3f8ee4002
subsample	0.8380397299311264	491c6531e590476ba6d0e4c3f8ee4002
subsample_for_bin	200000	491c6531e590476ba6d0e4c3f8ee4002
subsample_freq	0	491c6531e590476ba6d0e4c3f8ee4002
metric	['None']	491c6531e590476ba6d0e4c3f8ee4002
verbosity	-1	491c6531e590476ba6d0e4c3f8ee4002
scale_pos_weight	11.387084592145015	491c6531e590476ba6d0e4c3f8ee4002
objective	binary	491c6531e590476ba6d0e4c3f8ee4002
num_threads	12	491c6531e590476ba6d0e4c3f8ee4002
num_boost_round	1400	491c6531e590476ba6d0e4c3f8ee4002
feature_name	auto	491c6531e590476ba6d0e4c3f8ee4002
categorical_feature	auto	491c6531e590476ba6d0e4c3f8ee4002
keep_training_booster	False	491c6531e590476ba6d0e4c3f8ee4002
boosting_type	gbdt	111954c77263486eb7b19f050d26b75a
colsample_bytree	0.6342372756179282	111954c77263486eb7b19f050d26b75a
learning_rate	0.00869915538950525	111954c77263486eb7b19f050d26b75a
max_depth	7	111954c77263486eb7b19f050d26b75a
min_child_samples	199	111954c77263486eb7b19f050d26b75a
min_child_weight	0.001	111954c77263486eb7b19f050d26b75a
min_split_gain	0.9597953986755302	111954c77263486eb7b19f050d26b75a
num_leaves	77	111954c77263486eb7b19f050d26b75a
random_state	42	111954c77263486eb7b19f050d26b75a
reg_alpha	6.176533070453376e-05	111954c77263486eb7b19f050d26b75a
reg_lambda	0.691035233119511	111954c77263486eb7b19f050d26b75a
subsample	0.8747731747970292	111954c77263486eb7b19f050d26b75a
subsample_for_bin	200000	111954c77263486eb7b19f050d26b75a
subsample_freq	0	111954c77263486eb7b19f050d26b75a
metric	['None']	111954c77263486eb7b19f050d26b75a
verbosity	-1	111954c77263486eb7b19f050d26b75a
scale_pos_weight	11.387084592145015	111954c77263486eb7b19f050d26b75a
objective	binary	111954c77263486eb7b19f050d26b75a
num_threads	12	111954c77263486eb7b19f050d26b75a
num_boost_round	1800	111954c77263486eb7b19f050d26b75a
feature_name	auto	111954c77263486eb7b19f050d26b75a
categorical_feature	auto	111954c77263486eb7b19f050d26b75a
keep_training_booster	False	111954c77263486eb7b19f050d26b75a
boosting_type	gbdt	9c1ced865d204984869839b7cd4f6859
boosting_type	gbdt	c2857623dd374caeb05d44680f352000
colsample_bytree	0.828935553805857	9c1ced865d204984869839b7cd4f6859
learning_rate	0.009323045041957873	9c1ced865d204984869839b7cd4f6859
max_depth	9	9c1ced865d204984869839b7cd4f6859
min_child_samples	155	9c1ced865d204984869839b7cd4f6859
min_child_weight	0.001	9c1ced865d204984869839b7cd4f6859
min_split_gain	0.6213262872671248	9c1ced865d204984869839b7cd4f6859
num_leaves	78	9c1ced865d204984869839b7cd4f6859
random_state	42	9c1ced865d204984869839b7cd4f6859
reg_alpha	0.0008067879065938065	9c1ced865d204984869839b7cd4f6859
reg_lambda	0.0031056329583057287	9c1ced865d204984869839b7cd4f6859
subsample	0.8736698547983791	9c1ced865d204984869839b7cd4f6859
subsample_for_bin	200000	9c1ced865d204984869839b7cd4f6859
subsample_freq	0	9c1ced865d204984869839b7cd4f6859
metric	['None']	9c1ced865d204984869839b7cd4f6859
verbosity	-1	9c1ced865d204984869839b7cd4f6859
scale_pos_weight	11.387084592145015	9c1ced865d204984869839b7cd4f6859
objective	binary	9c1ced865d204984869839b7cd4f6859
num_threads	12	9c1ced865d204984869839b7cd4f6859
num_boost_round	1400	9c1ced865d204984869839b7cd4f6859
feature_name	auto	9c1ced865d204984869839b7cd4f6859
categorical_feature	auto	9c1ced865d204984869839b7cd4f6859
keep_training_booster	False	9c1ced865d204984869839b7cd4f6859
boosting_type	gbdt	a6e212b95bfc4605a1be9024004fb49f
colsample_bytree	0.5127819822306073	a6e212b95bfc4605a1be9024004fb49f
learning_rate	0.03681548109766895	a6e212b95bfc4605a1be9024004fb49f
max_depth	11	a6e212b95bfc4605a1be9024004fb49f
min_child_samples	199	a6e212b95bfc4605a1be9024004fb49f
min_child_weight	0.001	a6e212b95bfc4605a1be9024004fb49f
min_split_gain	0.40817107915692386	a6e212b95bfc4605a1be9024004fb49f
num_leaves	63	a6e212b95bfc4605a1be9024004fb49f
random_state	42	a6e212b95bfc4605a1be9024004fb49f
reg_alpha	6.067461006017809e-07	a6e212b95bfc4605a1be9024004fb49f
reg_lambda	8.400867662460353	a6e212b95bfc4605a1be9024004fb49f
subsample	0.9778528330828616	a6e212b95bfc4605a1be9024004fb49f
subsample_for_bin	200000	a6e212b95bfc4605a1be9024004fb49f
subsample_freq	0	a6e212b95bfc4605a1be9024004fb49f
metric	['None']	a6e212b95bfc4605a1be9024004fb49f
verbosity	-1	a6e212b95bfc4605a1be9024004fb49f
scale_pos_weight	11.387084592145015	a6e212b95bfc4605a1be9024004fb49f
objective	binary	a6e212b95bfc4605a1be9024004fb49f
num_threads	12	a6e212b95bfc4605a1be9024004fb49f
num_boost_round	1100	a6e212b95bfc4605a1be9024004fb49f
feature_name	auto	a6e212b95bfc4605a1be9024004fb49f
categorical_feature	auto	a6e212b95bfc4605a1be9024004fb49f
keep_training_booster	False	a6e212b95bfc4605a1be9024004fb49f
boosting_type	gbdt	49388c150ccb4b929ee16b2bb07bb27f
colsample_bytree	0.6496437467839511	49388c150ccb4b929ee16b2bb07bb27f
learning_rate	0.017914489140958653	49388c150ccb4b929ee16b2bb07bb27f
max_depth	8	49388c150ccb4b929ee16b2bb07bb27f
min_child_samples	170	49388c150ccb4b929ee16b2bb07bb27f
min_child_weight	0.001	49388c150ccb4b929ee16b2bb07bb27f
min_split_gain	0.7749988205163159	49388c150ccb4b929ee16b2bb07bb27f
num_leaves	145	49388c150ccb4b929ee16b2bb07bb27f
random_state	42	49388c150ccb4b929ee16b2bb07bb27f
reg_alpha	0.0012557380652863488	49388c150ccb4b929ee16b2bb07bb27f
reg_lambda	5.337920078392265	49388c150ccb4b929ee16b2bb07bb27f
subsample	0.8722878023232424	49388c150ccb4b929ee16b2bb07bb27f
subsample_for_bin	200000	49388c150ccb4b929ee16b2bb07bb27f
subsample_freq	0	49388c150ccb4b929ee16b2bb07bb27f
metric	['None']	49388c150ccb4b929ee16b2bb07bb27f
verbosity	-1	49388c150ccb4b929ee16b2bb07bb27f
scale_pos_weight	11.387084592145015	49388c150ccb4b929ee16b2bb07bb27f
objective	binary	49388c150ccb4b929ee16b2bb07bb27f
num_threads	12	49388c150ccb4b929ee16b2bb07bb27f
num_boost_round	1600	49388c150ccb4b929ee16b2bb07bb27f
feature_name	auto	49388c150ccb4b929ee16b2bb07bb27f
categorical_feature	auto	49388c150ccb4b929ee16b2bb07bb27f
keep_training_booster	False	49388c150ccb4b929ee16b2bb07bb27f
boosting_type	gbdt	6e7d042ef55247409d9390031ff02a47
colsample_bytree	0.5596683932406346	6e7d042ef55247409d9390031ff02a47
learning_rate	0.008148141951605483	6e7d042ef55247409d9390031ff02a47
max_depth	7	6e7d042ef55247409d9390031ff02a47
min_child_samples	164	6e7d042ef55247409d9390031ff02a47
min_child_weight	0.001	6e7d042ef55247409d9390031ff02a47
min_split_gain	0.943944829537651	6e7d042ef55247409d9390031ff02a47
num_leaves	102	6e7d042ef55247409d9390031ff02a47
random_state	42	6e7d042ef55247409d9390031ff02a47
reg_alpha	0.0021220855230236514	6e7d042ef55247409d9390031ff02a47
reg_lambda	0.5524211955867047	6e7d042ef55247409d9390031ff02a47
subsample	0.8798426905120079	6e7d042ef55247409d9390031ff02a47
subsample_for_bin	200000	6e7d042ef55247409d9390031ff02a47
subsample_freq	0	6e7d042ef55247409d9390031ff02a47
metric	['None']	6e7d042ef55247409d9390031ff02a47
verbosity	-1	6e7d042ef55247409d9390031ff02a47
scale_pos_weight	11.387084592145015	6e7d042ef55247409d9390031ff02a47
objective	binary	6e7d042ef55247409d9390031ff02a47
num_threads	12	6e7d042ef55247409d9390031ff02a47
num_boost_round	1500	6e7d042ef55247409d9390031ff02a47
feature_name	auto	6e7d042ef55247409d9390031ff02a47
categorical_feature	auto	6e7d042ef55247409d9390031ff02a47
keep_training_booster	False	6e7d042ef55247409d9390031ff02a47
boosting_type	gbdt	5dfe43d07bae4c3e8be8f52e18ee4e21
colsample_bytree	0.5664715640492398	c2857623dd374caeb05d44680f352000
learning_rate	0.006739562017742049	c2857623dd374caeb05d44680f352000
max_depth	9	c2857623dd374caeb05d44680f352000
min_child_samples	185	c2857623dd374caeb05d44680f352000
min_child_weight	0.001	c2857623dd374caeb05d44680f352000
min_split_gain	0.8189274173140663	c2857623dd374caeb05d44680f352000
num_leaves	25	c2857623dd374caeb05d44680f352000
random_state	42	c2857623dd374caeb05d44680f352000
reg_alpha	0.00025752665109285406	c2857623dd374caeb05d44680f352000
reg_lambda	1.3145742058992387	c2857623dd374caeb05d44680f352000
subsample	0.8908667079926562	c2857623dd374caeb05d44680f352000
subsample_for_bin	200000	c2857623dd374caeb05d44680f352000
subsample_freq	0	c2857623dd374caeb05d44680f352000
metric	['None']	c2857623dd374caeb05d44680f352000
verbosity	-1	c2857623dd374caeb05d44680f352000
scale_pos_weight	11.387084592145015	c2857623dd374caeb05d44680f352000
objective	binary	c2857623dd374caeb05d44680f352000
num_threads	12	c2857623dd374caeb05d44680f352000
num_boost_round	2000	c2857623dd374caeb05d44680f352000
feature_name	auto	c2857623dd374caeb05d44680f352000
categorical_feature	auto	c2857623dd374caeb05d44680f352000
keep_training_booster	False	c2857623dd374caeb05d44680f352000
boosting_type	gbdt	3919fe95d06c45a48568942d0a5d55ac
colsample_bytree	0.8199826117513526	3919fe95d06c45a48568942d0a5d55ac
learning_rate	0.015104784158861814	3919fe95d06c45a48568942d0a5d55ac
max_depth	9	3919fe95d06c45a48568942d0a5d55ac
min_child_samples	175	3919fe95d06c45a48568942d0a5d55ac
min_child_weight	0.001	3919fe95d06c45a48568942d0a5d55ac
min_split_gain	0.9192977022372937	3919fe95d06c45a48568942d0a5d55ac
num_leaves	16	3919fe95d06c45a48568942d0a5d55ac
random_state	42	3919fe95d06c45a48568942d0a5d55ac
reg_alpha	8.955679144257246e-05	3919fe95d06c45a48568942d0a5d55ac
reg_lambda	0.0031597907802225693	3919fe95d06c45a48568942d0a5d55ac
subsample	0.9145875555505578	3919fe95d06c45a48568942d0a5d55ac
subsample_for_bin	200000	3919fe95d06c45a48568942d0a5d55ac
subsample_freq	0	3919fe95d06c45a48568942d0a5d55ac
metric	['None']	3919fe95d06c45a48568942d0a5d55ac
verbosity	-1	3919fe95d06c45a48568942d0a5d55ac
scale_pos_weight	11.387084592145015	3919fe95d06c45a48568942d0a5d55ac
objective	binary	3919fe95d06c45a48568942d0a5d55ac
num_threads	12	3919fe95d06c45a48568942d0a5d55ac
num_boost_round	1600	3919fe95d06c45a48568942d0a5d55ac
feature_name	auto	3919fe95d06c45a48568942d0a5d55ac
categorical_feature	auto	3919fe95d06c45a48568942d0a5d55ac
keep_training_booster	False	3919fe95d06c45a48568942d0a5d55ac
boosting_type	gbdt	9e05181cd24c4328ad2c35ebdb23abc7
colsample_bytree	0.6185693410770199	9e05181cd24c4328ad2c35ebdb23abc7
learning_rate	0.009513651537022279	9e05181cd24c4328ad2c35ebdb23abc7
max_depth	7	9e05181cd24c4328ad2c35ebdb23abc7
min_child_samples	181	9e05181cd24c4328ad2c35ebdb23abc7
min_child_weight	0.001	9e05181cd24c4328ad2c35ebdb23abc7
min_split_gain	0.9427451968143907	9e05181cd24c4328ad2c35ebdb23abc7
num_leaves	99	9e05181cd24c4328ad2c35ebdb23abc7
random_state	42	9e05181cd24c4328ad2c35ebdb23abc7
reg_alpha	0.00013623063739690372	9e05181cd24c4328ad2c35ebdb23abc7
reg_lambda	0.0012128930113913207	9e05181cd24c4328ad2c35ebdb23abc7
subsample	0.9005068766750306	9e05181cd24c4328ad2c35ebdb23abc7
subsample_for_bin	200000	9e05181cd24c4328ad2c35ebdb23abc7
subsample_freq	0	9e05181cd24c4328ad2c35ebdb23abc7
metric	['None']	9e05181cd24c4328ad2c35ebdb23abc7
verbosity	-1	9e05181cd24c4328ad2c35ebdb23abc7
scale_pos_weight	11.387084592145015	9e05181cd24c4328ad2c35ebdb23abc7
objective	binary	9e05181cd24c4328ad2c35ebdb23abc7
num_threads	12	9e05181cd24c4328ad2c35ebdb23abc7
num_boost_round	1900	9e05181cd24c4328ad2c35ebdb23abc7
feature_name	auto	9e05181cd24c4328ad2c35ebdb23abc7
categorical_feature	auto	9e05181cd24c4328ad2c35ebdb23abc7
keep_training_booster	False	9e05181cd24c4328ad2c35ebdb23abc7
boosting_type	gbdt	99058e32615c47359503e260cbce6d91
colsample_bytree	0.5779096131044882	99058e32615c47359503e260cbce6d91
learning_rate	0.012023933744877426	99058e32615c47359503e260cbce6d91
max_depth	12	99058e32615c47359503e260cbce6d91
min_child_samples	177	99058e32615c47359503e260cbce6d91
min_child_weight	0.001	99058e32615c47359503e260cbce6d91
min_split_gain	0.7390605313530002	99058e32615c47359503e260cbce6d91
num_leaves	55	99058e32615c47359503e260cbce6d91
random_state	42	99058e32615c47359503e260cbce6d91
reg_alpha	1.1252118421739763e-07	99058e32615c47359503e260cbce6d91
reg_lambda	0.5484503039646199	99058e32615c47359503e260cbce6d91
subsample	0.9642509203916305	99058e32615c47359503e260cbce6d91
subsample_for_bin	200000	99058e32615c47359503e260cbce6d91
subsample_freq	0	99058e32615c47359503e260cbce6d91
metric	['None']	99058e32615c47359503e260cbce6d91
verbosity	-1	99058e32615c47359503e260cbce6d91
scale_pos_weight	11.387084592145015	99058e32615c47359503e260cbce6d91
objective	binary	99058e32615c47359503e260cbce6d91
num_threads	12	99058e32615c47359503e260cbce6d91
num_boost_round	1100	99058e32615c47359503e260cbce6d91
feature_name	auto	99058e32615c47359503e260cbce6d91
categorical_feature	auto	99058e32615c47359503e260cbce6d91
keep_training_booster	False	99058e32615c47359503e260cbce6d91
boosting_type	gbdt	08b5f55856b74797a4e16456167adfd5
boosting_type	gbdt	6d7c5305df6349cebc54d4fa9a31214a
colsample_bytree	0.7181081773415378	6d7c5305df6349cebc54d4fa9a31214a
learning_rate	0.006743239895450936	6d7c5305df6349cebc54d4fa9a31214a
max_depth	4	6d7c5305df6349cebc54d4fa9a31214a
min_child_samples	158	6d7c5305df6349cebc54d4fa9a31214a
min_child_weight	0.001	6d7c5305df6349cebc54d4fa9a31214a
min_split_gain	0.9382531778994866	6d7c5305df6349cebc54d4fa9a31214a
num_leaves	24	6d7c5305df6349cebc54d4fa9a31214a
random_state	42	6d7c5305df6349cebc54d4fa9a31214a
reg_alpha	2.83068755397093e-05	6d7c5305df6349cebc54d4fa9a31214a
reg_lambda	5.052808845123115	6d7c5305df6349cebc54d4fa9a31214a
subsample	0.9083163008353108	6d7c5305df6349cebc54d4fa9a31214a
subsample_for_bin	200000	6d7c5305df6349cebc54d4fa9a31214a
subsample_freq	0	6d7c5305df6349cebc54d4fa9a31214a
metric	['None']	6d7c5305df6349cebc54d4fa9a31214a
verbosity	-1	6d7c5305df6349cebc54d4fa9a31214a
scale_pos_weight	11.387084592145015	6d7c5305df6349cebc54d4fa9a31214a
objective	binary	6d7c5305df6349cebc54d4fa9a31214a
num_threads	12	6d7c5305df6349cebc54d4fa9a31214a
num_boost_round	2000	6d7c5305df6349cebc54d4fa9a31214a
feature_name	auto	6d7c5305df6349cebc54d4fa9a31214a
categorical_feature	auto	6d7c5305df6349cebc54d4fa9a31214a
keep_training_booster	False	6d7c5305df6349cebc54d4fa9a31214a
boosting_type	gbdt	27593188f9b74471b4e76392b99287d0
colsample_bytree	0.5972595957416558	27593188f9b74471b4e76392b99287d0
learning_rate	0.015839566472926673	27593188f9b74471b4e76392b99287d0
max_depth	6	27593188f9b74471b4e76392b99287d0
min_child_samples	194	27593188f9b74471b4e76392b99287d0
min_child_weight	0.001	27593188f9b74471b4e76392b99287d0
min_split_gain	0.9138060114444426	27593188f9b74471b4e76392b99287d0
num_leaves	90	27593188f9b74471b4e76392b99287d0
random_state	42	27593188f9b74471b4e76392b99287d0
reg_alpha	0.0014611543264071171	27593188f9b74471b4e76392b99287d0
reg_lambda	0.07518081760754068	27593188f9b74471b4e76392b99287d0
subsample	0.8427447970449645	27593188f9b74471b4e76392b99287d0
subsample_for_bin	200000	27593188f9b74471b4e76392b99287d0
subsample_freq	0	27593188f9b74471b4e76392b99287d0
metric	['None']	27593188f9b74471b4e76392b99287d0
verbosity	-1	27593188f9b74471b4e76392b99287d0
scale_pos_weight	11.387084592145015	27593188f9b74471b4e76392b99287d0
objective	binary	27593188f9b74471b4e76392b99287d0
num_threads	12	27593188f9b74471b4e76392b99287d0
num_boost_round	1800	27593188f9b74471b4e76392b99287d0
feature_name	auto	27593188f9b74471b4e76392b99287d0
categorical_feature	auto	27593188f9b74471b4e76392b99287d0
keep_training_booster	False	27593188f9b74471b4e76392b99287d0
boosting_type	gbdt	caa44697e4d24e98b6d5f91363319ce0
colsample_bytree	0.5933727094757248	caa44697e4d24e98b6d5f91363319ce0
learning_rate	0.00941328096625608	caa44697e4d24e98b6d5f91363319ce0
max_depth	6	caa44697e4d24e98b6d5f91363319ce0
min_child_samples	195	caa44697e4d24e98b6d5f91363319ce0
min_child_weight	0.001	caa44697e4d24e98b6d5f91363319ce0
min_split_gain	0.9710385379667719	caa44697e4d24e98b6d5f91363319ce0
num_leaves	66	caa44697e4d24e98b6d5f91363319ce0
random_state	42	caa44697e4d24e98b6d5f91363319ce0
reg_alpha	8.82735559419228e-08	caa44697e4d24e98b6d5f91363319ce0
reg_lambda	0.06813689863633364	caa44697e4d24e98b6d5f91363319ce0
subsample	0.7822878107088873	caa44697e4d24e98b6d5f91363319ce0
subsample_for_bin	200000	caa44697e4d24e98b6d5f91363319ce0
subsample_freq	0	caa44697e4d24e98b6d5f91363319ce0
metric	['None']	caa44697e4d24e98b6d5f91363319ce0
verbosity	-1	caa44697e4d24e98b6d5f91363319ce0
scale_pos_weight	11.387084592145015	caa44697e4d24e98b6d5f91363319ce0
objective	binary	caa44697e4d24e98b6d5f91363319ce0
num_threads	12	caa44697e4d24e98b6d5f91363319ce0
num_boost_round	1400	caa44697e4d24e98b6d5f91363319ce0
feature_name	auto	caa44697e4d24e98b6d5f91363319ce0
categorical_feature	auto	caa44697e4d24e98b6d5f91363319ce0
keep_training_booster	False	caa44697e4d24e98b6d5f91363319ce0
boosting_type	gbdt	079ff97d445546cbb52ed19b2d617517
colsample_bytree	0.6456130890798712	079ff97d445546cbb52ed19b2d617517
learning_rate	0.022576402789028543	079ff97d445546cbb52ed19b2d617517
max_depth	6	079ff97d445546cbb52ed19b2d617517
min_child_samples	185	079ff97d445546cbb52ed19b2d617517
min_child_weight	0.001	079ff97d445546cbb52ed19b2d617517
min_split_gain	0.8810771996796978	079ff97d445546cbb52ed19b2d617517
num_leaves	67	079ff97d445546cbb52ed19b2d617517
random_state	42	079ff97d445546cbb52ed19b2d617517
reg_alpha	0.0016125702233888827	079ff97d445546cbb52ed19b2d617517
reg_lambda	0.17002217127618346	079ff97d445546cbb52ed19b2d617517
subsample	0.9259141635330289	079ff97d445546cbb52ed19b2d617517
subsample_for_bin	200000	079ff97d445546cbb52ed19b2d617517
subsample_freq	0	079ff97d445546cbb52ed19b2d617517
metric	['None']	079ff97d445546cbb52ed19b2d617517
verbosity	-1	079ff97d445546cbb52ed19b2d617517
scale_pos_weight	11.387084592145015	079ff97d445546cbb52ed19b2d617517
objective	binary	079ff97d445546cbb52ed19b2d617517
num_threads	12	079ff97d445546cbb52ed19b2d617517
num_boost_round	1300	079ff97d445546cbb52ed19b2d617517
feature_name	auto	079ff97d445546cbb52ed19b2d617517
categorical_feature	auto	079ff97d445546cbb52ed19b2d617517
keep_training_booster	False	079ff97d445546cbb52ed19b2d617517
colsample_bytree	0.9522850146871285	5dfe43d07bae4c3e8be8f52e18ee4e21
colsample_bytree	0.7813315922110001	08b5f55856b74797a4e16456167adfd5
learning_rate	0.016950818766182565	08b5f55856b74797a4e16456167adfd5
max_depth	12	08b5f55856b74797a4e16456167adfd5
min_child_samples	148	08b5f55856b74797a4e16456167adfd5
min_child_weight	0.001	08b5f55856b74797a4e16456167adfd5
min_split_gain	0.8782959916631211	08b5f55856b74797a4e16456167adfd5
num_leaves	27	08b5f55856b74797a4e16456167adfd5
random_state	42	08b5f55856b74797a4e16456167adfd5
reg_alpha	1.910571559663047e-06	08b5f55856b74797a4e16456167adfd5
reg_lambda	0.07958071320631267	08b5f55856b74797a4e16456167adfd5
subsample	0.9051290039358246	08b5f55856b74797a4e16456167adfd5
subsample_for_bin	200000	08b5f55856b74797a4e16456167adfd5
subsample_freq	0	08b5f55856b74797a4e16456167adfd5
metric	['None']	08b5f55856b74797a4e16456167adfd5
verbosity	-1	08b5f55856b74797a4e16456167adfd5
scale_pos_weight	11.387084592145015	08b5f55856b74797a4e16456167adfd5
objective	binary	08b5f55856b74797a4e16456167adfd5
num_threads	12	08b5f55856b74797a4e16456167adfd5
num_boost_round	1000	08b5f55856b74797a4e16456167adfd5
feature_name	auto	08b5f55856b74797a4e16456167adfd5
categorical_feature	auto	08b5f55856b74797a4e16456167adfd5
keep_training_booster	False	08b5f55856b74797a4e16456167adfd5
boosting_type	gbdt	d936f59062f2489586c8c6aa48246a22
colsample_bytree	0.6863759245128079	d936f59062f2489586c8c6aa48246a22
learning_rate	0.01910406126999991	d936f59062f2489586c8c6aa48246a22
max_depth	11	d936f59062f2489586c8c6aa48246a22
min_child_samples	143	d936f59062f2489586c8c6aa48246a22
min_child_weight	0.001	d936f59062f2489586c8c6aa48246a22
min_split_gain	0.5571650409750787	d936f59062f2489586c8c6aa48246a22
num_leaves	70	d936f59062f2489586c8c6aa48246a22
random_state	42	d936f59062f2489586c8c6aa48246a22
reg_alpha	2.2411050821190194e-08	d936f59062f2489586c8c6aa48246a22
reg_lambda	0.18105236416522716	d936f59062f2489586c8c6aa48246a22
subsample	0.8201422827722181	d936f59062f2489586c8c6aa48246a22
subsample_for_bin	200000	d936f59062f2489586c8c6aa48246a22
subsample_freq	0	d936f59062f2489586c8c6aa48246a22
metric	['None']	d936f59062f2489586c8c6aa48246a22
verbosity	-1	d936f59062f2489586c8c6aa48246a22
scale_pos_weight	11.387084592145015	d936f59062f2489586c8c6aa48246a22
objective	binary	d936f59062f2489586c8c6aa48246a22
num_threads	12	d936f59062f2489586c8c6aa48246a22
num_boost_round	1200	d936f59062f2489586c8c6aa48246a22
feature_name	auto	d936f59062f2489586c8c6aa48246a22
categorical_feature	auto	d936f59062f2489586c8c6aa48246a22
keep_training_booster	False	d936f59062f2489586c8c6aa48246a22
boosting_type	gbdt	7d1d89bca5f64345807b2f8710248857
colsample_bytree	0.6079300300012002	7d1d89bca5f64345807b2f8710248857
learning_rate	0.007933206511955452	7d1d89bca5f64345807b2f8710248857
max_depth	8	7d1d89bca5f64345807b2f8710248857
min_child_samples	188	7d1d89bca5f64345807b2f8710248857
min_child_weight	0.001	7d1d89bca5f64345807b2f8710248857
min_split_gain	0.8740099167109199	7d1d89bca5f64345807b2f8710248857
num_leaves	66	7d1d89bca5f64345807b2f8710248857
random_state	42	7d1d89bca5f64345807b2f8710248857
reg_alpha	0.0007080105713522617	7d1d89bca5f64345807b2f8710248857
reg_lambda	0.004001156830642675	7d1d89bca5f64345807b2f8710248857
subsample	0.8001001874647777	7d1d89bca5f64345807b2f8710248857
subsample_for_bin	200000	7d1d89bca5f64345807b2f8710248857
subsample_freq	0	7d1d89bca5f64345807b2f8710248857
metric	['None']	7d1d89bca5f64345807b2f8710248857
verbosity	-1	7d1d89bca5f64345807b2f8710248857
scale_pos_weight	11.387084592145015	7d1d89bca5f64345807b2f8710248857
objective	binary	7d1d89bca5f64345807b2f8710248857
num_threads	12	7d1d89bca5f64345807b2f8710248857
num_boost_round	1400	7d1d89bca5f64345807b2f8710248857
feature_name	auto	7d1d89bca5f64345807b2f8710248857
categorical_feature	auto	7d1d89bca5f64345807b2f8710248857
keep_training_booster	False	7d1d89bca5f64345807b2f8710248857
boosting_type	gbdt	0f815fdf0e0645fcbc9bd75f41904b44
colsample_bytree	0.6250727866216197	0f815fdf0e0645fcbc9bd75f41904b44
learning_rate	0.010193533785936732	0f815fdf0e0645fcbc9bd75f41904b44
max_depth	6	0f815fdf0e0645fcbc9bd75f41904b44
min_child_samples	194	0f815fdf0e0645fcbc9bd75f41904b44
min_child_weight	0.001	0f815fdf0e0645fcbc9bd75f41904b44
min_split_gain	0.7842451543493054	0f815fdf0e0645fcbc9bd75f41904b44
num_leaves	122	0f815fdf0e0645fcbc9bd75f41904b44
random_state	42	0f815fdf0e0645fcbc9bd75f41904b44
reg_alpha	0.00030163860170690307	0f815fdf0e0645fcbc9bd75f41904b44
reg_lambda	0.1384705625969152	0f815fdf0e0645fcbc9bd75f41904b44
subsample	0.8141503373716132	0f815fdf0e0645fcbc9bd75f41904b44
subsample_for_bin	200000	0f815fdf0e0645fcbc9bd75f41904b44
subsample_freq	0	0f815fdf0e0645fcbc9bd75f41904b44
metric	['None']	0f815fdf0e0645fcbc9bd75f41904b44
verbosity	-1	0f815fdf0e0645fcbc9bd75f41904b44
scale_pos_weight	11.387084592145015	0f815fdf0e0645fcbc9bd75f41904b44
objective	binary	0f815fdf0e0645fcbc9bd75f41904b44
num_threads	12	0f815fdf0e0645fcbc9bd75f41904b44
num_boost_round	1800	0f815fdf0e0645fcbc9bd75f41904b44
feature_name	auto	0f815fdf0e0645fcbc9bd75f41904b44
categorical_feature	auto	0f815fdf0e0645fcbc9bd75f41904b44
keep_training_booster	False	0f815fdf0e0645fcbc9bd75f41904b44
boosting_type	gbdt	fd3500958da74eb280182de207c1c9f1
colsample_bytree	0.6226089626930339	fd3500958da74eb280182de207c1c9f1
learning_rate	0.030085932922054304	fd3500958da74eb280182de207c1c9f1
max_depth	7	fd3500958da74eb280182de207c1c9f1
min_child_samples	185	fd3500958da74eb280182de207c1c9f1
min_child_weight	0.001	fd3500958da74eb280182de207c1c9f1
min_split_gain	0.8213523897756629	fd3500958da74eb280182de207c1c9f1
num_leaves	98	fd3500958da74eb280182de207c1c9f1
random_state	42	fd3500958da74eb280182de207c1c9f1
reg_alpha	0.005998947625204122	fd3500958da74eb280182de207c1c9f1
reg_lambda	0.10077964658391204	fd3500958da74eb280182de207c1c9f1
subsample	0.8040603757316338	fd3500958da74eb280182de207c1c9f1
subsample_for_bin	200000	fd3500958da74eb280182de207c1c9f1
subsample_freq	0	fd3500958da74eb280182de207c1c9f1
metric	['None']	fd3500958da74eb280182de207c1c9f1
verbosity	-1	fd3500958da74eb280182de207c1c9f1
scale_pos_weight	11.387084592145015	fd3500958da74eb280182de207c1c9f1
objective	binary	fd3500958da74eb280182de207c1c9f1
num_threads	12	fd3500958da74eb280182de207c1c9f1
num_boost_round	2000	fd3500958da74eb280182de207c1c9f1
feature_name	auto	fd3500958da74eb280182de207c1c9f1
categorical_feature	auto	fd3500958da74eb280182de207c1c9f1
keep_training_booster	False	fd3500958da74eb280182de207c1c9f1
boosting_type	gbdt	64b0900a1e964558863d196db339900c
colsample_bytree	0.5563538297280505	64b0900a1e964558863d196db339900c
learning_rate	0.008520480123768805	64b0900a1e964558863d196db339900c
max_depth	5	64b0900a1e964558863d196db339900c
min_child_samples	200	64b0900a1e964558863d196db339900c
min_child_weight	0.001	64b0900a1e964558863d196db339900c
min_split_gain	0.9741534758325058	64b0900a1e964558863d196db339900c
num_leaves	160	64b0900a1e964558863d196db339900c
random_state	42	64b0900a1e964558863d196db339900c
reg_alpha	0.000856165073571691	64b0900a1e964558863d196db339900c
reg_lambda	0.12850297505302366	64b0900a1e964558863d196db339900c
subsample	0.9090144601416087	64b0900a1e964558863d196db339900c
subsample_for_bin	200000	64b0900a1e964558863d196db339900c
subsample_freq	0	64b0900a1e964558863d196db339900c
metric	['None']	64b0900a1e964558863d196db339900c
verbosity	-1	64b0900a1e964558863d196db339900c
scale_pos_weight	11.387084592145015	64b0900a1e964558863d196db339900c
objective	binary	64b0900a1e964558863d196db339900c
num_threads	12	64b0900a1e964558863d196db339900c
num_boost_round	1800	64b0900a1e964558863d196db339900c
feature_name	auto	64b0900a1e964558863d196db339900c
categorical_feature	auto	64b0900a1e964558863d196db339900c
keep_training_booster	False	64b0900a1e964558863d196db339900c
boosting_type	gbdt	c1dbce29b41c445ba8138ce9811b0068
colsample_bytree	0.5792607082097607	c1dbce29b41c445ba8138ce9811b0068
learning_rate	0.028075861273541593	c1dbce29b41c445ba8138ce9811b0068
max_depth	9	c1dbce29b41c445ba8138ce9811b0068
min_child_samples	172	c1dbce29b41c445ba8138ce9811b0068
min_child_weight	0.001	c1dbce29b41c445ba8138ce9811b0068
min_split_gain	0.7878487830935438	c1dbce29b41c445ba8138ce9811b0068
num_leaves	87	c1dbce29b41c445ba8138ce9811b0068
random_state	42	c1dbce29b41c445ba8138ce9811b0068
reg_alpha	3.293593727273559e-08	c1dbce29b41c445ba8138ce9811b0068
reg_lambda	1.5946326367222985	c1dbce29b41c445ba8138ce9811b0068
subsample	0.8640470130985846	c1dbce29b41c445ba8138ce9811b0068
subsample_for_bin	200000	c1dbce29b41c445ba8138ce9811b0068
subsample_freq	0	c1dbce29b41c445ba8138ce9811b0068
metric	['None']	c1dbce29b41c445ba8138ce9811b0068
verbosity	-1	c1dbce29b41c445ba8138ce9811b0068
scale_pos_weight	11.387084592145015	c1dbce29b41c445ba8138ce9811b0068
objective	binary	c1dbce29b41c445ba8138ce9811b0068
num_threads	12	c1dbce29b41c445ba8138ce9811b0068
num_boost_round	900	c1dbce29b41c445ba8138ce9811b0068
feature_name	auto	c1dbce29b41c445ba8138ce9811b0068
categorical_feature	auto	c1dbce29b41c445ba8138ce9811b0068
keep_training_booster	False	c1dbce29b41c445ba8138ce9811b0068
learning_rate	0.03148529294947063	5dfe43d07bae4c3e8be8f52e18ee4e21
max_depth	4	5dfe43d07bae4c3e8be8f52e18ee4e21
min_child_samples	72	5dfe43d07bae4c3e8be8f52e18ee4e21
min_child_weight	0.001	5dfe43d07bae4c3e8be8f52e18ee4e21
min_split_gain	0.5691798661389267	5dfe43d07bae4c3e8be8f52e18ee4e21
num_leaves	19	5dfe43d07bae4c3e8be8f52e18ee4e21
random_state	42	5dfe43d07bae4c3e8be8f52e18ee4e21
reg_alpha	1.0349301504319199e-08	5dfe43d07bae4c3e8be8f52e18ee4e21
reg_lambda	0.16539749108945306	5dfe43d07bae4c3e8be8f52e18ee4e21
subsample	0.7723735658481918	5dfe43d07bae4c3e8be8f52e18ee4e21
subsample_for_bin	200000	5dfe43d07bae4c3e8be8f52e18ee4e21
subsample_freq	0	5dfe43d07bae4c3e8be8f52e18ee4e21
metric	['None']	5dfe43d07bae4c3e8be8f52e18ee4e21
verbosity	-1	5dfe43d07bae4c3e8be8f52e18ee4e21
scale_pos_weight	11.387084592145015	5dfe43d07bae4c3e8be8f52e18ee4e21
objective	binary	5dfe43d07bae4c3e8be8f52e18ee4e21
num_threads	12	5dfe43d07bae4c3e8be8f52e18ee4e21
num_boost_round	1000	5dfe43d07bae4c3e8be8f52e18ee4e21
feature_name	auto	5dfe43d07bae4c3e8be8f52e18ee4e21
categorical_feature	auto	5dfe43d07bae4c3e8be8f52e18ee4e21
keep_training_booster	False	5dfe43d07bae4c3e8be8f52e18ee4e21
boosting_type	gbdt	373663ce084a43b8bfb50018919a65db
colsample_bytree	0.5692256535957113	373663ce084a43b8bfb50018919a65db
learning_rate	0.005291512573586452	373663ce084a43b8bfb50018919a65db
max_depth	6	373663ce084a43b8bfb50018919a65db
boosting_type	gbdt	dc2d72393aae497781f7a6cceff926d7
colsample_bytree	0.6576286995296715	dc2d72393aae497781f7a6cceff926d7
learning_rate	0.006315719260799896	dc2d72393aae497781f7a6cceff926d7
max_depth	6	dc2d72393aae497781f7a6cceff926d7
min_child_samples	144	dc2d72393aae497781f7a6cceff926d7
min_child_weight	0.001	dc2d72393aae497781f7a6cceff926d7
min_split_gain	0.42956018175096283	dc2d72393aae497781f7a6cceff926d7
num_leaves	145	dc2d72393aae497781f7a6cceff926d7
random_state	42	dc2d72393aae497781f7a6cceff926d7
reg_alpha	1.9502169317471424e-06	dc2d72393aae497781f7a6cceff926d7
reg_lambda	0.0004914845984864027	dc2d72393aae497781f7a6cceff926d7
subsample	0.8419217411928052	dc2d72393aae497781f7a6cceff926d7
subsample_for_bin	200000	dc2d72393aae497781f7a6cceff926d7
subsample_freq	0	dc2d72393aae497781f7a6cceff926d7
metric	['None']	dc2d72393aae497781f7a6cceff926d7
verbosity	-1	dc2d72393aae497781f7a6cceff926d7
scale_pos_weight	11.387084592145015	dc2d72393aae497781f7a6cceff926d7
objective	binary	dc2d72393aae497781f7a6cceff926d7
num_threads	12	dc2d72393aae497781f7a6cceff926d7
num_boost_round	1800	dc2d72393aae497781f7a6cceff926d7
feature_name	auto	dc2d72393aae497781f7a6cceff926d7
categorical_feature	auto	dc2d72393aae497781f7a6cceff926d7
keep_training_booster	False	dc2d72393aae497781f7a6cceff926d7
boosting_type	gbdt	82bdb95fb73945928fc4add300efc29e
colsample_bytree	0.6837192285119622	82bdb95fb73945928fc4add300efc29e
learning_rate	0.027701523838319184	82bdb95fb73945928fc4add300efc29e
max_depth	5	82bdb95fb73945928fc4add300efc29e
min_child_samples	143	82bdb95fb73945928fc4add300efc29e
min_child_weight	0.001	82bdb95fb73945928fc4add300efc29e
min_split_gain	0.9889903222323636	82bdb95fb73945928fc4add300efc29e
num_leaves	52	82bdb95fb73945928fc4add300efc29e
random_state	42	82bdb95fb73945928fc4add300efc29e
reg_alpha	0.0006910828341608623	82bdb95fb73945928fc4add300efc29e
reg_lambda	0.013763647051022062	82bdb95fb73945928fc4add300efc29e
subsample	0.7892120493748713	82bdb95fb73945928fc4add300efc29e
subsample_for_bin	200000	82bdb95fb73945928fc4add300efc29e
subsample_freq	0	82bdb95fb73945928fc4add300efc29e
metric	['None']	82bdb95fb73945928fc4add300efc29e
verbosity	-1	82bdb95fb73945928fc4add300efc29e
scale_pos_weight	11.387084592145015	82bdb95fb73945928fc4add300efc29e
objective	binary	82bdb95fb73945928fc4add300efc29e
num_threads	12	82bdb95fb73945928fc4add300efc29e
num_boost_round	1400	82bdb95fb73945928fc4add300efc29e
feature_name	auto	82bdb95fb73945928fc4add300efc29e
categorical_feature	auto	82bdb95fb73945928fc4add300efc29e
keep_training_booster	False	82bdb95fb73945928fc4add300efc29e
boosting_type	gbdt	c04b03a1eb034e30ab0dbfd07f0a56bc
colsample_bytree	0.6476441628684413	c04b03a1eb034e30ab0dbfd07f0a56bc
learning_rate	0.029115079233346098	c04b03a1eb034e30ab0dbfd07f0a56bc
max_depth	11	c04b03a1eb034e30ab0dbfd07f0a56bc
min_child_samples	94	c04b03a1eb034e30ab0dbfd07f0a56bc
min_child_weight	0.001	c04b03a1eb034e30ab0dbfd07f0a56bc
min_split_gain	0.5319701700431346	c04b03a1eb034e30ab0dbfd07f0a56bc
num_leaves	24	c04b03a1eb034e30ab0dbfd07f0a56bc
random_state	42	c04b03a1eb034e30ab0dbfd07f0a56bc
reg_alpha	1.4895019868129381e-08	c04b03a1eb034e30ab0dbfd07f0a56bc
reg_lambda	0.19273881322029524	c04b03a1eb034e30ab0dbfd07f0a56bc
subsample	0.8297790449736874	c04b03a1eb034e30ab0dbfd07f0a56bc
subsample_for_bin	200000	c04b03a1eb034e30ab0dbfd07f0a56bc
subsample_freq	0	c04b03a1eb034e30ab0dbfd07f0a56bc
metric	['None']	c04b03a1eb034e30ab0dbfd07f0a56bc
verbosity	-1	c04b03a1eb034e30ab0dbfd07f0a56bc
scale_pos_weight	11.387084592145015	c04b03a1eb034e30ab0dbfd07f0a56bc
objective	binary	c04b03a1eb034e30ab0dbfd07f0a56bc
num_threads	12	c04b03a1eb034e30ab0dbfd07f0a56bc
num_boost_round	500	c04b03a1eb034e30ab0dbfd07f0a56bc
feature_name	auto	c04b03a1eb034e30ab0dbfd07f0a56bc
categorical_feature	auto	c04b03a1eb034e30ab0dbfd07f0a56bc
keep_training_booster	False	c04b03a1eb034e30ab0dbfd07f0a56bc
boosting_type	gbdt	61939d5dc91f45f0b71ee70059923014
colsample_bytree	0.6661619943917091	61939d5dc91f45f0b71ee70059923014
learning_rate	0.005233053679132509	61939d5dc91f45f0b71ee70059923014
max_depth	4	61939d5dc91f45f0b71ee70059923014
min_child_samples	151	61939d5dc91f45f0b71ee70059923014
min_child_weight	0.001	61939d5dc91f45f0b71ee70059923014
min_split_gain	0.7423336860096259	61939d5dc91f45f0b71ee70059923014
num_leaves	83	61939d5dc91f45f0b71ee70059923014
random_state	42	61939d5dc91f45f0b71ee70059923014
reg_alpha	0.00020877740516138935	61939d5dc91f45f0b71ee70059923014
reg_lambda	0.20037859755264273	61939d5dc91f45f0b71ee70059923014
subsample	0.7332780437572323	61939d5dc91f45f0b71ee70059923014
subsample_for_bin	200000	61939d5dc91f45f0b71ee70059923014
subsample_freq	0	61939d5dc91f45f0b71ee70059923014
metric	['None']	61939d5dc91f45f0b71ee70059923014
verbosity	-1	61939d5dc91f45f0b71ee70059923014
scale_pos_weight	11.387084592145015	61939d5dc91f45f0b71ee70059923014
objective	binary	61939d5dc91f45f0b71ee70059923014
num_threads	12	61939d5dc91f45f0b71ee70059923014
num_boost_round	2000	61939d5dc91f45f0b71ee70059923014
feature_name	auto	61939d5dc91f45f0b71ee70059923014
categorical_feature	auto	61939d5dc91f45f0b71ee70059923014
keep_training_booster	False	61939d5dc91f45f0b71ee70059923014
boosting_type	gbdt	e62dd40594234fe2b1e7032791dd20a8
colsample_bytree	0.519973483905232	e62dd40594234fe2b1e7032791dd20a8
learning_rate	0.023974968479582533	e62dd40594234fe2b1e7032791dd20a8
max_depth	12	e62dd40594234fe2b1e7032791dd20a8
min_child_samples	164	e62dd40594234fe2b1e7032791dd20a8
min_child_weight	0.001	e62dd40594234fe2b1e7032791dd20a8
min_split_gain	0.6177119571214889	e62dd40594234fe2b1e7032791dd20a8
num_leaves	68	e62dd40594234fe2b1e7032791dd20a8
random_state	42	e62dd40594234fe2b1e7032791dd20a8
reg_alpha	2.6388723302019686e-08	e62dd40594234fe2b1e7032791dd20a8
reg_lambda	0.00017587680130113815	e62dd40594234fe2b1e7032791dd20a8
subsample	0.9558979046670405	e62dd40594234fe2b1e7032791dd20a8
subsample_for_bin	200000	e62dd40594234fe2b1e7032791dd20a8
subsample_freq	0	e62dd40594234fe2b1e7032791dd20a8
metric	['None']	e62dd40594234fe2b1e7032791dd20a8
verbosity	-1	e62dd40594234fe2b1e7032791dd20a8
scale_pos_weight	11.387084592145015	e62dd40594234fe2b1e7032791dd20a8
objective	binary	e62dd40594234fe2b1e7032791dd20a8
num_threads	12	e62dd40594234fe2b1e7032791dd20a8
num_boost_round	800	e62dd40594234fe2b1e7032791dd20a8
feature_name	auto	e62dd40594234fe2b1e7032791dd20a8
categorical_feature	auto	e62dd40594234fe2b1e7032791dd20a8
keep_training_booster	False	e62dd40594234fe2b1e7032791dd20a8
boosting_type	gbdt	20e40ce2d6c44003bb759ab6e1351170
colsample_bytree	0.6838140598566192	20e40ce2d6c44003bb759ab6e1351170
learning_rate	0.006645415575999285	20e40ce2d6c44003bb759ab6e1351170
max_depth	5	20e40ce2d6c44003bb759ab6e1351170
min_child_samples	194	20e40ce2d6c44003bb759ab6e1351170
min_child_weight	0.001	20e40ce2d6c44003bb759ab6e1351170
min_split_gain	0.6247777733196003	20e40ce2d6c44003bb759ab6e1351170
num_leaves	120	20e40ce2d6c44003bb759ab6e1351170
random_state	42	20e40ce2d6c44003bb759ab6e1351170
reg_alpha	0.0005915061843828179	20e40ce2d6c44003bb759ab6e1351170
reg_lambda	0.004568255769252197	20e40ce2d6c44003bb759ab6e1351170
subsample	0.8574426387761802	20e40ce2d6c44003bb759ab6e1351170
subsample_for_bin	200000	20e40ce2d6c44003bb759ab6e1351170
subsample_freq	0	20e40ce2d6c44003bb759ab6e1351170
metric	['None']	20e40ce2d6c44003bb759ab6e1351170
verbosity	-1	20e40ce2d6c44003bb759ab6e1351170
scale_pos_weight	11.387084592145015	20e40ce2d6c44003bb759ab6e1351170
objective	binary	20e40ce2d6c44003bb759ab6e1351170
num_threads	12	20e40ce2d6c44003bb759ab6e1351170
num_boost_round	1500	20e40ce2d6c44003bb759ab6e1351170
feature_name	auto	20e40ce2d6c44003bb759ab6e1351170
categorical_feature	auto	20e40ce2d6c44003bb759ab6e1351170
keep_training_booster	False	20e40ce2d6c44003bb759ab6e1351170
min_child_samples	140	373663ce084a43b8bfb50018919a65db
min_child_weight	0.001	373663ce084a43b8bfb50018919a65db
min_split_gain	0.8663981247894031	373663ce084a43b8bfb50018919a65db
num_leaves	113	373663ce084a43b8bfb50018919a65db
random_state	42	373663ce084a43b8bfb50018919a65db
reg_alpha	3.5190285862242926e-07	373663ce084a43b8bfb50018919a65db
reg_lambda	0.9378806707415056	373663ce084a43b8bfb50018919a65db
subsample	0.8631042882402734	373663ce084a43b8bfb50018919a65db
subsample_for_bin	200000	373663ce084a43b8bfb50018919a65db
subsample_freq	0	373663ce084a43b8bfb50018919a65db
metric	['None']	373663ce084a43b8bfb50018919a65db
verbosity	-1	373663ce084a43b8bfb50018919a65db
scale_pos_weight	11.387084592145015	373663ce084a43b8bfb50018919a65db
objective	binary	373663ce084a43b8bfb50018919a65db
num_threads	12	373663ce084a43b8bfb50018919a65db
num_boost_round	1900	373663ce084a43b8bfb50018919a65db
feature_name	auto	373663ce084a43b8bfb50018919a65db
categorical_feature	auto	373663ce084a43b8bfb50018919a65db
keep_training_booster	False	373663ce084a43b8bfb50018919a65db
boosting_type	gbdt	8c20356faa924d4fb9eba650a0792cc3
colsample_bytree	0.6132930028953423	8c20356faa924d4fb9eba650a0792cc3
learning_rate	0.02565839240394001	8c20356faa924d4fb9eba650a0792cc3
max_depth	11	8c20356faa924d4fb9eba650a0792cc3
min_child_samples	182	8c20356faa924d4fb9eba650a0792cc3
min_child_weight	0.001	8c20356faa924d4fb9eba650a0792cc3
min_split_gain	0.9432144585616353	8c20356faa924d4fb9eba650a0792cc3
num_leaves	39	8c20356faa924d4fb9eba650a0792cc3
random_state	42	8c20356faa924d4fb9eba650a0792cc3
reg_alpha	9.41369102730751e-06	8c20356faa924d4fb9eba650a0792cc3
reg_lambda	3.5146773837355028	8c20356faa924d4fb9eba650a0792cc3
subsample	0.9589287293368202	8c20356faa924d4fb9eba650a0792cc3
subsample_for_bin	200000	8c20356faa924d4fb9eba650a0792cc3
subsample_freq	0	8c20356faa924d4fb9eba650a0792cc3
metric	['None']	8c20356faa924d4fb9eba650a0792cc3
verbosity	-1	8c20356faa924d4fb9eba650a0792cc3
scale_pos_weight	11.387084592145015	8c20356faa924d4fb9eba650a0792cc3
objective	binary	8c20356faa924d4fb9eba650a0792cc3
num_threads	12	8c20356faa924d4fb9eba650a0792cc3
num_boost_round	1400	8c20356faa924d4fb9eba650a0792cc3
feature_name	auto	8c20356faa924d4fb9eba650a0792cc3
categorical_feature	auto	8c20356faa924d4fb9eba650a0792cc3
keep_training_booster	False	8c20356faa924d4fb9eba650a0792cc3
keep_training_booster	False	5e4c9e7de52d47a391919bb68173e02c
boosting_type	gbdt	81cc585288d144dbaed1346c79c254ca
colsample_bytree	0.8120029084136385	81cc585288d144dbaed1346c79c254ca
learning_rate	0.009129145494639107	81cc585288d144dbaed1346c79c254ca
max_depth	8	81cc585288d144dbaed1346c79c254ca
min_child_samples	194	81cc585288d144dbaed1346c79c254ca
min_child_weight	0.001	81cc585288d144dbaed1346c79c254ca
min_split_gain	0.8959235976740556	81cc585288d144dbaed1346c79c254ca
num_leaves	58	81cc585288d144dbaed1346c79c254ca
random_state	42	81cc585288d144dbaed1346c79c254ca
reg_alpha	0.0028116239565969966	81cc585288d144dbaed1346c79c254ca
reg_lambda	9.165816406158376	81cc585288d144dbaed1346c79c254ca
subsample	0.9863011342334264	81cc585288d144dbaed1346c79c254ca
subsample_for_bin	200000	81cc585288d144dbaed1346c79c254ca
subsample_freq	0	81cc585288d144dbaed1346c79c254ca
metric	['None']	81cc585288d144dbaed1346c79c254ca
verbosity	-1	81cc585288d144dbaed1346c79c254ca
scale_pos_weight	11.387084592145015	81cc585288d144dbaed1346c79c254ca
objective	binary	81cc585288d144dbaed1346c79c254ca
num_threads	12	81cc585288d144dbaed1346c79c254ca
num_boost_round	1900	81cc585288d144dbaed1346c79c254ca
feature_name	auto	81cc585288d144dbaed1346c79c254ca
categorical_feature	auto	81cc585288d144dbaed1346c79c254ca
keep_training_booster	False	81cc585288d144dbaed1346c79c254ca
boosting_type	gbdt	729adea5b08d4ad4a4653e52efbafee9
colsample_bytree	0.6181053680363445	729adea5b08d4ad4a4653e52efbafee9
learning_rate	0.05486970956783451	729adea5b08d4ad4a4653e52efbafee9
max_depth	12	729adea5b08d4ad4a4653e52efbafee9
min_child_samples	171	729adea5b08d4ad4a4653e52efbafee9
min_child_weight	0.001	729adea5b08d4ad4a4653e52efbafee9
min_split_gain	0.41109814861769006	729adea5b08d4ad4a4653e52efbafee9
num_leaves	45	729adea5b08d4ad4a4653e52efbafee9
random_state	42	729adea5b08d4ad4a4653e52efbafee9
reg_alpha	3.956361386419908e-08	729adea5b08d4ad4a4653e52efbafee9
reg_lambda	0.010118678588937587	729adea5b08d4ad4a4653e52efbafee9
subsample	0.9903662671698567	729adea5b08d4ad4a4653e52efbafee9
subsample_for_bin	200000	729adea5b08d4ad4a4653e52efbafee9
subsample_freq	0	729adea5b08d4ad4a4653e52efbafee9
metric	['None']	729adea5b08d4ad4a4653e52efbafee9
verbosity	-1	729adea5b08d4ad4a4653e52efbafee9
scale_pos_weight	11.387084592145015	729adea5b08d4ad4a4653e52efbafee9
objective	binary	729adea5b08d4ad4a4653e52efbafee9
num_threads	12	729adea5b08d4ad4a4653e52efbafee9
num_boost_round	900	729adea5b08d4ad4a4653e52efbafee9
feature_name	auto	729adea5b08d4ad4a4653e52efbafee9
categorical_feature	auto	729adea5b08d4ad4a4653e52efbafee9
keep_training_booster	False	729adea5b08d4ad4a4653e52efbafee9
boosting_type	gbdt	aea8d7c689ae4b289a07ea312f8cd967
colsample_bytree	0.7925843863267319	aea8d7c689ae4b289a07ea312f8cd967
learning_rate	0.02715972438071041	aea8d7c689ae4b289a07ea312f8cd967
max_depth	6	aea8d7c689ae4b289a07ea312f8cd967
min_child_samples	33	aea8d7c689ae4b289a07ea312f8cd967
min_child_weight	0.001	aea8d7c689ae4b289a07ea312f8cd967
min_split_gain	0.23974382600474564	aea8d7c689ae4b289a07ea312f8cd967
num_leaves	241	aea8d7c689ae4b289a07ea312f8cd967
random_state	42	aea8d7c689ae4b289a07ea312f8cd967
reg_alpha	0.00016070015808282795	aea8d7c689ae4b289a07ea312f8cd967
reg_lambda	4.259210438047804e-08	aea8d7c689ae4b289a07ea312f8cd967
subsample	0.9439272477982594	aea8d7c689ae4b289a07ea312f8cd967
subsample_for_bin	200000	aea8d7c689ae4b289a07ea312f8cd967
subsample_freq	0	aea8d7c689ae4b289a07ea312f8cd967
metric	['None']	aea8d7c689ae4b289a07ea312f8cd967
verbosity	-1	aea8d7c689ae4b289a07ea312f8cd967
scale_pos_weight	11.387084592145015	aea8d7c689ae4b289a07ea312f8cd967
objective	binary	aea8d7c689ae4b289a07ea312f8cd967
num_threads	12	aea8d7c689ae4b289a07ea312f8cd967
num_boost_round	1500	aea8d7c689ae4b289a07ea312f8cd967
feature_name	auto	aea8d7c689ae4b289a07ea312f8cd967
categorical_feature	auto	aea8d7c689ae4b289a07ea312f8cd967
keep_training_booster	False	aea8d7c689ae4b289a07ea312f8cd967
boosting_type	gbdt	c3c64461db474abfb41a7918f0836f40
colsample_bytree	0.5697615327691696	c3c64461db474abfb41a7918f0836f40
learning_rate	0.012451214922823278	c3c64461db474abfb41a7918f0836f40
max_depth	6	c3c64461db474abfb41a7918f0836f40
min_child_samples	176	c3c64461db474abfb41a7918f0836f40
min_child_weight	0.001	c3c64461db474abfb41a7918f0836f40
min_split_gain	0.8093604739406617	c3c64461db474abfb41a7918f0836f40
num_leaves	41	c3c64461db474abfb41a7918f0836f40
random_state	42	c3c64461db474abfb41a7918f0836f40
reg_alpha	9.9649919793938e-07	c3c64461db474abfb41a7918f0836f40
reg_lambda	8.695556370497968	c3c64461db474abfb41a7918f0836f40
subsample	0.7604597191803699	c3c64461db474abfb41a7918f0836f40
subsample_for_bin	200000	c3c64461db474abfb41a7918f0836f40
subsample_freq	0	c3c64461db474abfb41a7918f0836f40
metric	['None']	c3c64461db474abfb41a7918f0836f40
verbosity	-1	c3c64461db474abfb41a7918f0836f40
scale_pos_weight	11.387084592145015	c3c64461db474abfb41a7918f0836f40
objective	binary	c3c64461db474abfb41a7918f0836f40
num_threads	12	c3c64461db474abfb41a7918f0836f40
num_boost_round	1800	c3c64461db474abfb41a7918f0836f40
feature_name	auto	c3c64461db474abfb41a7918f0836f40
categorical_feature	auto	c3c64461db474abfb41a7918f0836f40
keep_training_booster	False	c3c64461db474abfb41a7918f0836f40
boosting_type	gbdt	52134bc6efa44da38234f805e719543d
colsample_bytree	0.5901100855517072	52134bc6efa44da38234f805e719543d
learning_rate	0.009210894345214006	52134bc6efa44da38234f805e719543d
max_depth	6	52134bc6efa44da38234f805e719543d
min_child_samples	195	52134bc6efa44da38234f805e719543d
min_child_weight	0.001	52134bc6efa44da38234f805e719543d
min_split_gain	0.8924199232757127	52134bc6efa44da38234f805e719543d
num_leaves	109	52134bc6efa44da38234f805e719543d
random_state	42	52134bc6efa44da38234f805e719543d
reg_alpha	6.339957970082356e-07	52134bc6efa44da38234f805e719543d
reg_lambda	5.6880421010004865	52134bc6efa44da38234f805e719543d
subsample	0.759585147461204	52134bc6efa44da38234f805e719543d
subsample_for_bin	200000	52134bc6efa44da38234f805e719543d
subsample_freq	0	52134bc6efa44da38234f805e719543d
metric	['None']	52134bc6efa44da38234f805e719543d
verbosity	-1	52134bc6efa44da38234f805e719543d
scale_pos_weight	11.387084592145015	52134bc6efa44da38234f805e719543d
objective	binary	52134bc6efa44da38234f805e719543d
num_threads	12	52134bc6efa44da38234f805e719543d
num_boost_round	1900	52134bc6efa44da38234f805e719543d
feature_name	auto	52134bc6efa44da38234f805e719543d
categorical_feature	auto	52134bc6efa44da38234f805e719543d
keep_training_booster	False	52134bc6efa44da38234f805e719543d
boosting_type	gbdt	7263fee2dbbf4c2c8d21f11ee7cfb4d5
colsample_bytree	0.6165385271597418	7263fee2dbbf4c2c8d21f11ee7cfb4d5
learning_rate	0.00906799212630801	7263fee2dbbf4c2c8d21f11ee7cfb4d5
max_depth	6	7263fee2dbbf4c2c8d21f11ee7cfb4d5
min_child_samples	194	7263fee2dbbf4c2c8d21f11ee7cfb4d5
min_child_weight	0.001	7263fee2dbbf4c2c8d21f11ee7cfb4d5
min_split_gain	0.9252088036735588	7263fee2dbbf4c2c8d21f11ee7cfb4d5
num_leaves	39	7263fee2dbbf4c2c8d21f11ee7cfb4d5
random_state	42	7263fee2dbbf4c2c8d21f11ee7cfb4d5
reg_alpha	1.4321413817799762e-05	7263fee2dbbf4c2c8d21f11ee7cfb4d5
reg_lambda	1.5829655607003414	7263fee2dbbf4c2c8d21f11ee7cfb4d5
subsample	0.8427578022275364	7263fee2dbbf4c2c8d21f11ee7cfb4d5
subsample_for_bin	200000	7263fee2dbbf4c2c8d21f11ee7cfb4d5
subsample_freq	0	7263fee2dbbf4c2c8d21f11ee7cfb4d5
metric	['None']	7263fee2dbbf4c2c8d21f11ee7cfb4d5
verbosity	-1	7263fee2dbbf4c2c8d21f11ee7cfb4d5
scale_pos_weight	11.387084592145015	7263fee2dbbf4c2c8d21f11ee7cfb4d5
objective	binary	7263fee2dbbf4c2c8d21f11ee7cfb4d5
num_threads	12	7263fee2dbbf4c2c8d21f11ee7cfb4d5
num_boost_round	1800	7263fee2dbbf4c2c8d21f11ee7cfb4d5
feature_name	auto	7263fee2dbbf4c2c8d21f11ee7cfb4d5
categorical_feature	auto	7263fee2dbbf4c2c8d21f11ee7cfb4d5
keep_training_booster	False	7263fee2dbbf4c2c8d21f11ee7cfb4d5
boosting_type	gbdt	858e7d66bbc44d07b4318652fe66bf8a
colsample_bytree	0.5371588925570063	858e7d66bbc44d07b4318652fe66bf8a
learning_rate	0.025284630077571316	858e7d66bbc44d07b4318652fe66bf8a
max_depth	7	858e7d66bbc44d07b4318652fe66bf8a
min_child_samples	155	858e7d66bbc44d07b4318652fe66bf8a
min_child_weight	0.001	858e7d66bbc44d07b4318652fe66bf8a
min_split_gain	0.7918269588922303	858e7d66bbc44d07b4318652fe66bf8a
num_leaves	22	858e7d66bbc44d07b4318652fe66bf8a
random_state	42	858e7d66bbc44d07b4318652fe66bf8a
reg_alpha	4.5669401496055296e-06	858e7d66bbc44d07b4318652fe66bf8a
reg_lambda	1.0248086640894238	858e7d66bbc44d07b4318652fe66bf8a
subsample	0.7722961572613877	858e7d66bbc44d07b4318652fe66bf8a
subsample_for_bin	200000	858e7d66bbc44d07b4318652fe66bf8a
subsample_freq	0	858e7d66bbc44d07b4318652fe66bf8a
metric	['None']	858e7d66bbc44d07b4318652fe66bf8a
verbosity	-1	858e7d66bbc44d07b4318652fe66bf8a
scale_pos_weight	11.387084592145015	858e7d66bbc44d07b4318652fe66bf8a
objective	binary	858e7d66bbc44d07b4318652fe66bf8a
num_threads	12	858e7d66bbc44d07b4318652fe66bf8a
num_boost_round	1500	858e7d66bbc44d07b4318652fe66bf8a
feature_name	auto	858e7d66bbc44d07b4318652fe66bf8a
categorical_feature	auto	858e7d66bbc44d07b4318652fe66bf8a
keep_training_booster	False	858e7d66bbc44d07b4318652fe66bf8a
learning_rate	0.023889447179649116	5cfc620daab64d35912dd7df3c7d139d
n_estimators	1100	5cfc620daab64d35912dd7df3c7d139d
num_leaves	26	5cfc620daab64d35912dd7df3c7d139d
max_depth	11	5cfc620daab64d35912dd7df3c7d139d
min_child_samples	189	5cfc620daab64d35912dd7df3c7d139d
subsample	0.9329058752585103	5cfc620daab64d35912dd7df3c7d139d
colsample_bytree	0.5502816763648806	5cfc620daab64d35912dd7df3c7d139d
reg_alpha	2.5876270506315506e-08	5cfc620daab64d35912dd7df3c7d139d
reg_lambda	1.7380795812428735	5cfc620daab64d35912dd7df3c7d139d
min_split_gain	0.7587109446041786	5cfc620daab64d35912dd7df3c7d139d
boosting_type	gbdt	1858617a3b064a73a5af67ad947b5cdf
colsample_bytree	0.5502816763648806	1858617a3b064a73a5af67ad947b5cdf
learning_rate	0.023889447179649116	1858617a3b064a73a5af67ad947b5cdf
max_depth	11	1858617a3b064a73a5af67ad947b5cdf
min_child_samples	189	1858617a3b064a73a5af67ad947b5cdf
min_child_weight	0.001	1858617a3b064a73a5af67ad947b5cdf
min_split_gain	0.7587109446041786	1858617a3b064a73a5af67ad947b5cdf
num_leaves	26	1858617a3b064a73a5af67ad947b5cdf
random_state	42	1858617a3b064a73a5af67ad947b5cdf
reg_alpha	2.5876270506315506e-08	1858617a3b064a73a5af67ad947b5cdf
reg_lambda	1.7380795812428735	1858617a3b064a73a5af67ad947b5cdf
subsample	0.9329058752585103	1858617a3b064a73a5af67ad947b5cdf
subsample_for_bin	200000	1858617a3b064a73a5af67ad947b5cdf
subsample_freq	0	1858617a3b064a73a5af67ad947b5cdf
verbosity	-1	1858617a3b064a73a5af67ad947b5cdf
scale_pos_weight	11.387084592145015	1858617a3b064a73a5af67ad947b5cdf
objective	binary	1858617a3b064a73a5af67ad947b5cdf
boosting_type	gbdt	b93a661f89624444924de260e56e2235
colsample_bytree	0.5663859441789123	b93a661f89624444924de260e56e2235
learning_rate	0.019640801193765482	b93a661f89624444924de260e56e2235
max_depth	7	b93a661f89624444924de260e56e2235
min_child_samples	121	b93a661f89624444924de260e56e2235
min_child_weight	0.001	b93a661f89624444924de260e56e2235
min_split_gain	0.6684071448079378	b93a661f89624444924de260e56e2235
num_leaves	53	b93a661f89624444924de260e56e2235
random_state	42	b93a661f89624444924de260e56e2235
reg_alpha	5.1114320340056775e-06	b93a661f89624444924de260e56e2235
reg_lambda	0.33089695229084015	b93a661f89624444924de260e56e2235
subsample	0.8382273244510264	b93a661f89624444924de260e56e2235
subsample_for_bin	200000	b93a661f89624444924de260e56e2235
subsample_freq	0	b93a661f89624444924de260e56e2235
metric	['None']	b93a661f89624444924de260e56e2235
verbosity	-1	b93a661f89624444924de260e56e2235
scale_pos_weight	11.387084592145015	b93a661f89624444924de260e56e2235
objective	binary	b93a661f89624444924de260e56e2235
num_threads	12	b93a661f89624444924de260e56e2235
num_boost_round	1600	b93a661f89624444924de260e56e2235
feature_name	auto	b93a661f89624444924de260e56e2235
categorical_feature	auto	b93a661f89624444924de260e56e2235
keep_training_booster	False	b93a661f89624444924de260e56e2235
boosting_type	gbdt	b3a13dff7789467091ec52640e9adc99
colsample_bytree	0.641722655844017	b3a13dff7789467091ec52640e9adc99
learning_rate	0.037485021282373986	b3a13dff7789467091ec52640e9adc99
max_depth	5	b3a13dff7789467091ec52640e9adc99
min_child_samples	182	b3a13dff7789467091ec52640e9adc99
min_child_weight	0.001	b3a13dff7789467091ec52640e9adc99
min_split_gain	0.7570135220583402	b3a13dff7789467091ec52640e9adc99
num_leaves	53	b3a13dff7789467091ec52640e9adc99
random_state	42	b3a13dff7789467091ec52640e9adc99
reg_alpha	1.6642969285693707e-08	b3a13dff7789467091ec52640e9adc99
reg_lambda	7.1072477665654965	b3a13dff7789467091ec52640e9adc99
subsample	0.8160907624204282	b3a13dff7789467091ec52640e9adc99
subsample_for_bin	200000	b3a13dff7789467091ec52640e9adc99
subsample_freq	0	b3a13dff7789467091ec52640e9adc99
metric	['None']	b3a13dff7789467091ec52640e9adc99
verbosity	-1	b3a13dff7789467091ec52640e9adc99
scale_pos_weight	11.387084592145015	b3a13dff7789467091ec52640e9adc99
objective	binary	b3a13dff7789467091ec52640e9adc99
num_threads	12	b3a13dff7789467091ec52640e9adc99
num_boost_round	1600	b3a13dff7789467091ec52640e9adc99
feature_name	auto	b3a13dff7789467091ec52640e9adc99
categorical_feature	auto	b3a13dff7789467091ec52640e9adc99
keep_training_booster	False	b3a13dff7789467091ec52640e9adc99
boosting_type	gbdt	aaa258948ae9488bb474a158d63f9148
colsample_bytree	0.5631607114333013	aaa258948ae9488bb474a158d63f9148
learning_rate	0.00863185756949593	aaa258948ae9488bb474a158d63f9148
max_depth	4	aaa258948ae9488bb474a158d63f9148
min_child_samples	154	aaa258948ae9488bb474a158d63f9148
min_child_weight	0.001	aaa258948ae9488bb474a158d63f9148
min_split_gain	0.6816041217980622	aaa258948ae9488bb474a158d63f9148
num_leaves	24	aaa258948ae9488bb474a158d63f9148
random_state	42	aaa258948ae9488bb474a158d63f9148
reg_alpha	1.2747635446693478e-07	aaa258948ae9488bb474a158d63f9148
reg_lambda	0.13293474925928692	aaa258948ae9488bb474a158d63f9148
subsample	0.7414790744948541	aaa258948ae9488bb474a158d63f9148
subsample_for_bin	200000	aaa258948ae9488bb474a158d63f9148
subsample_freq	0	aaa258948ae9488bb474a158d63f9148
metric	['None']	aaa258948ae9488bb474a158d63f9148
verbosity	-1	aaa258948ae9488bb474a158d63f9148
scale_pos_weight	11.387084592145015	aaa258948ae9488bb474a158d63f9148
objective	binary	aaa258948ae9488bb474a158d63f9148
num_threads	12	aaa258948ae9488bb474a158d63f9148
num_boost_round	1400	aaa258948ae9488bb474a158d63f9148
feature_name	auto	aaa258948ae9488bb474a158d63f9148
categorical_feature	auto	aaa258948ae9488bb474a158d63f9148
keep_training_booster	False	aaa258948ae9488bb474a158d63f9148
boosting_type	gbdt	91efa9c98d164aedac595d534867cfa9
colsample_bytree	0.6191219074130395	91efa9c98d164aedac595d534867cfa9
learning_rate	0.008762334202033777	91efa9c98d164aedac595d534867cfa9
max_depth	9	91efa9c98d164aedac595d534867cfa9
min_child_samples	200	91efa9c98d164aedac595d534867cfa9
min_child_weight	0.001	91efa9c98d164aedac595d534867cfa9
min_split_gain	0.9358712821641777	91efa9c98d164aedac595d534867cfa9
num_leaves	40	91efa9c98d164aedac595d534867cfa9
random_state	42	91efa9c98d164aedac595d534867cfa9
reg_alpha	0.052193427474854955	91efa9c98d164aedac595d534867cfa9
reg_lambda	5.043580974679158	91efa9c98d164aedac595d534867cfa9
subsample	0.644134472611332	91efa9c98d164aedac595d534867cfa9
subsample_for_bin	200000	91efa9c98d164aedac595d534867cfa9
subsample_freq	0	91efa9c98d164aedac595d534867cfa9
metric	['None']	91efa9c98d164aedac595d534867cfa9
verbosity	-1	91efa9c98d164aedac595d534867cfa9
scale_pos_weight	10.973208018824504	91efa9c98d164aedac595d534867cfa9
objective	binary	91efa9c98d164aedac595d534867cfa9
num_threads	12	91efa9c98d164aedac595d534867cfa9
num_boost_round	2000	91efa9c98d164aedac595d534867cfa9
feature_name	auto	91efa9c98d164aedac595d534867cfa9
categorical_feature	auto	91efa9c98d164aedac595d534867cfa9
keep_training_booster	False	91efa9c98d164aedac595d534867cfa9
boosting_type	gbdt	97fb30d77c874bbe909e9b34ff9ab219
metric	['binary']	1858617a3b064a73a5af67ad947b5cdf
num_threads	12	1858617a3b064a73a5af67ad947b5cdf
num_boost_round	1100	1858617a3b064a73a5af67ad947b5cdf
feature_name	auto	1858617a3b064a73a5af67ad947b5cdf
categorical_feature	auto	1858617a3b064a73a5af67ad947b5cdf
keep_training_booster	False	1858617a3b064a73a5af67ad947b5cdf
boosting_type	gbdt	2cb17c9ab3fb42f6a309da1001231d6f
colsample_bytree	0.5290418060840998	2cb17c9ab3fb42f6a309da1001231d6f
learning_rate	0.019906996673933378	2cb17c9ab3fb42f6a309da1001231d6f
max_depth	8	2cb17c9ab3fb42f6a309da1001231d6f
min_child_samples	39	2cb17c9ab3fb42f6a309da1001231d6f
min_child_weight	0.001	2cb17c9ab3fb42f6a309da1001231d6f
min_split_gain	0.7080725777960455	2cb17c9ab3fb42f6a309da1001231d6f
num_leaves	192	2cb17c9ab3fb42f6a309da1001231d6f
random_state	42	2cb17c9ab3fb42f6a309da1001231d6f
reg_alpha	0.6245760287469893	2cb17c9ab3fb42f6a309da1001231d6f
reg_lambda	0.002570603566117598	2cb17c9ab3fb42f6a309da1001231d6f
subsample	0.662397808134481	2cb17c9ab3fb42f6a309da1001231d6f
subsample_for_bin	200000	2cb17c9ab3fb42f6a309da1001231d6f
subsample_freq	0	2cb17c9ab3fb42f6a309da1001231d6f
metric	['None']	2cb17c9ab3fb42f6a309da1001231d6f
verbosity	-1	2cb17c9ab3fb42f6a309da1001231d6f
scale_pos_weight	5.858354548834764	2cb17c9ab3fb42f6a309da1001231d6f
objective	binary	2cb17c9ab3fb42f6a309da1001231d6f
num_threads	12	2cb17c9ab3fb42f6a309da1001231d6f
num_boost_round	2000	2cb17c9ab3fb42f6a309da1001231d6f
feature_name	auto	2cb17c9ab3fb42f6a309da1001231d6f
categorical_feature	auto	2cb17c9ab3fb42f6a309da1001231d6f
keep_training_booster	False	2cb17c9ab3fb42f6a309da1001231d6f
boosting_type	gbdt	343a984aca99424a9ea4fde70eae7fd6
colsample_bytree	0.762378215816119	343a984aca99424a9ea4fde70eae7fd6
learning_rate	0.17898794163735265	343a984aca99424a9ea4fde70eae7fd6
max_depth	4	343a984aca99424a9ea4fde70eae7fd6
min_child_samples	45	343a984aca99424a9ea4fde70eae7fd6
min_child_weight	0.001	343a984aca99424a9ea4fde70eae7fd6
min_split_gain	0.6118528947223795	343a984aca99424a9ea4fde70eae7fd6
num_leaves	67	343a984aca99424a9ea4fde70eae7fd6
random_state	42	343a984aca99424a9ea4fde70eae7fd6
reg_alpha	7.71800699380605e-05	343a984aca99424a9ea4fde70eae7fd6
reg_lambda	4.17890272377219e-06	343a984aca99424a9ea4fde70eae7fd6
subsample	0.7216968971838151	343a984aca99424a9ea4fde70eae7fd6
subsample_for_bin	200000	343a984aca99424a9ea4fde70eae7fd6
subsample_freq	0	343a984aca99424a9ea4fde70eae7fd6
metric	['None']	343a984aca99424a9ea4fde70eae7fd6
verbosity	-1	343a984aca99424a9ea4fde70eae7fd6
scale_pos_weight	6.9082210196374145	343a984aca99424a9ea4fde70eae7fd6
objective	binary	343a984aca99424a9ea4fde70eae7fd6
num_threads	12	343a984aca99424a9ea4fde70eae7fd6
num_boost_round	1700	343a984aca99424a9ea4fde70eae7fd6
feature_name	auto	343a984aca99424a9ea4fde70eae7fd6
categorical_feature	auto	343a984aca99424a9ea4fde70eae7fd6
keep_training_booster	False	343a984aca99424a9ea4fde70eae7fd6
boosting_type	gbdt	639bd817783446149d47dfcd0926f1a0
colsample_bytree	0.7200762468698007	639bd817783446149d47dfcd0926f1a0
learning_rate	0.16563097558837167	639bd817783446149d47dfcd0926f1a0
max_depth	6	639bd817783446149d47dfcd0926f1a0
min_child_samples	28	639bd817783446149d47dfcd0926f1a0
min_child_weight	0.001	639bd817783446149d47dfcd0926f1a0
min_split_gain	0.034388521115218396	639bd817783446149d47dfcd0926f1a0
num_leaves	210	639bd817783446149d47dfcd0926f1a0
random_state	42	639bd817783446149d47dfcd0926f1a0
reg_alpha	1.254134495897175e-07	639bd817783446149d47dfcd0926f1a0
reg_lambda	0.00028614897264046574	639bd817783446149d47dfcd0926f1a0
subsample	0.8736932106048627	639bd817783446149d47dfcd0926f1a0
subsample_for_bin	200000	639bd817783446149d47dfcd0926f1a0
subsample_freq	0	639bd817783446149d47dfcd0926f1a0
metric	['None']	639bd817783446149d47dfcd0926f1a0
verbosity	-1	639bd817783446149d47dfcd0926f1a0
scale_pos_weight	20.083896964456528	639bd817783446149d47dfcd0926f1a0
objective	binary	639bd817783446149d47dfcd0926f1a0
num_threads	12	639bd817783446149d47dfcd0926f1a0
num_boost_round	2000	639bd817783446149d47dfcd0926f1a0
feature_name	auto	639bd817783446149d47dfcd0926f1a0
categorical_feature	auto	639bd817783446149d47dfcd0926f1a0
keep_training_booster	False	639bd817783446149d47dfcd0926f1a0
boosting_type	gbdt	2dd58258a1c14b7e9fbbcf0a30084f7d
colsample_bytree	0.9847923138822793	2dd58258a1c14b7e9fbbcf0a30084f7d
learning_rate	0.012988262560967663	2dd58258a1c14b7e9fbbcf0a30084f7d
max_depth	8	2dd58258a1c14b7e9fbbcf0a30084f7d
min_child_samples	114	2dd58258a1c14b7e9fbbcf0a30084f7d
min_child_weight	0.001	2dd58258a1c14b7e9fbbcf0a30084f7d
min_split_gain	0.8948273504276488	2dd58258a1c14b7e9fbbcf0a30084f7d
num_leaves	91	2dd58258a1c14b7e9fbbcf0a30084f7d
random_state	42	2dd58258a1c14b7e9fbbcf0a30084f7d
reg_alpha	0.09466630153726856	2dd58258a1c14b7e9fbbcf0a30084f7d
reg_lambda	2.854239907497756	2dd58258a1c14b7e9fbbcf0a30084f7d
subsample	0.6739417822102108	2dd58258a1c14b7e9fbbcf0a30084f7d
subsample_for_bin	200000	2dd58258a1c14b7e9fbbcf0a30084f7d
subsample_freq	0	2dd58258a1c14b7e9fbbcf0a30084f7d
metric	['None']	2dd58258a1c14b7e9fbbcf0a30084f7d
verbosity	-1	2dd58258a1c14b7e9fbbcf0a30084f7d
scale_pos_weight	13.042300650838149	2dd58258a1c14b7e9fbbcf0a30084f7d
objective	binary	2dd58258a1c14b7e9fbbcf0a30084f7d
boosting_type	gbdt	fe50acdbb80f44b3b833e6da5d8494d5
colsample_bytree	0.7962072844310213	fe50acdbb80f44b3b833e6da5d8494d5
learning_rate	0.014689372953975089	fe50acdbb80f44b3b833e6da5d8494d5
max_depth	10	fe50acdbb80f44b3b833e6da5d8494d5
min_child_samples	48	fe50acdbb80f44b3b833e6da5d8494d5
min_child_weight	0.001	fe50acdbb80f44b3b833e6da5d8494d5
min_split_gain	0.17052412368729153	fe50acdbb80f44b3b833e6da5d8494d5
num_leaves	125	fe50acdbb80f44b3b833e6da5d8494d5
random_state	42	fe50acdbb80f44b3b833e6da5d8494d5
reg_alpha	2.6185068507773707e-08	fe50acdbb80f44b3b833e6da5d8494d5
reg_lambda	0.0029369981104377003	fe50acdbb80f44b3b833e6da5d8494d5
subsample	0.8056937753654446	fe50acdbb80f44b3b833e6da5d8494d5
subsample_for_bin	200000	fe50acdbb80f44b3b833e6da5d8494d5
subsample_freq	0	fe50acdbb80f44b3b833e6da5d8494d5
metric	['None']	fe50acdbb80f44b3b833e6da5d8494d5
verbosity	-1	fe50acdbb80f44b3b833e6da5d8494d5
scale_pos_weight	6.2308531062260375	fe50acdbb80f44b3b833e6da5d8494d5
objective	binary	fe50acdbb80f44b3b833e6da5d8494d5
num_threads	12	fe50acdbb80f44b3b833e6da5d8494d5
num_boost_round	800	fe50acdbb80f44b3b833e6da5d8494d5
feature_name	auto	fe50acdbb80f44b3b833e6da5d8494d5
categorical_feature	auto	fe50acdbb80f44b3b833e6da5d8494d5
keep_training_booster	False	fe50acdbb80f44b3b833e6da5d8494d5
boosting_type	gbdt	7cabb843d24d4b86a34757eaf1696d59
colsample_bytree	0.528584133660177	7cabb843d24d4b86a34757eaf1696d59
learning_rate	0.0076470873393797295	7cabb843d24d4b86a34757eaf1696d59
max_depth	12	7cabb843d24d4b86a34757eaf1696d59
min_child_samples	169	7cabb843d24d4b86a34757eaf1696d59
min_child_weight	0.001	7cabb843d24d4b86a34757eaf1696d59
min_split_gain	0.8031693737219934	7cabb843d24d4b86a34757eaf1696d59
num_leaves	109	7cabb843d24d4b86a34757eaf1696d59
random_state	42	7cabb843d24d4b86a34757eaf1696d59
reg_alpha	1.6264276970839615	7cabb843d24d4b86a34757eaf1696d59
reg_lambda	0.006438257323447379	7cabb843d24d4b86a34757eaf1696d59
subsample	0.6339865750949791	7cabb843d24d4b86a34757eaf1696d59
subsample_for_bin	200000	7cabb843d24d4b86a34757eaf1696d59
subsample_freq	0	7cabb843d24d4b86a34757eaf1696d59
metric	['None']	7cabb843d24d4b86a34757eaf1696d59
verbosity	-1	7cabb843d24d4b86a34757eaf1696d59
scale_pos_weight	8.299229128853806	7cabb843d24d4b86a34757eaf1696d59
objective	binary	7cabb843d24d4b86a34757eaf1696d59
num_threads	12	7cabb843d24d4b86a34757eaf1696d59
num_boost_round	1400	7cabb843d24d4b86a34757eaf1696d59
feature_name	auto	7cabb843d24d4b86a34757eaf1696d59
categorical_feature	auto	7cabb843d24d4b86a34757eaf1696d59
keep_training_booster	False	7cabb843d24d4b86a34757eaf1696d59
boosting_type	gbdt	4ad932f7dcda4517b7b5cc0c8beac404
colsample_bytree	0.6522714442344962	4ad932f7dcda4517b7b5cc0c8beac404
learning_rate	0.005230215294531294	4ad932f7dcda4517b7b5cc0c8beac404
max_depth	9	4ad932f7dcda4517b7b5cc0c8beac404
min_child_samples	184	4ad932f7dcda4517b7b5cc0c8beac404
min_child_weight	0.001	4ad932f7dcda4517b7b5cc0c8beac404
min_split_gain	0.8140632329072721	4ad932f7dcda4517b7b5cc0c8beac404
num_leaves	23	4ad932f7dcda4517b7b5cc0c8beac404
random_state	42	4ad932f7dcda4517b7b5cc0c8beac404
reg_alpha	0.005634282127898045	4ad932f7dcda4517b7b5cc0c8beac404
reg_lambda	8.909654467893856e-05	4ad932f7dcda4517b7b5cc0c8beac404
subsample	0.6065845137364402	4ad932f7dcda4517b7b5cc0c8beac404
subsample_for_bin	200000	4ad932f7dcda4517b7b5cc0c8beac404
subsample_freq	0	4ad932f7dcda4517b7b5cc0c8beac404
metric	['None']	4ad932f7dcda4517b7b5cc0c8beac404
verbosity	-1	4ad932f7dcda4517b7b5cc0c8beac404
scale_pos_weight	7.5598186719899125	4ad932f7dcda4517b7b5cc0c8beac404
objective	binary	4ad932f7dcda4517b7b5cc0c8beac404
num_threads	12	4ad932f7dcda4517b7b5cc0c8beac404
num_boost_round	1900	4ad932f7dcda4517b7b5cc0c8beac404
feature_name	auto	4ad932f7dcda4517b7b5cc0c8beac404
categorical_feature	auto	4ad932f7dcda4517b7b5cc0c8beac404
keep_training_booster	False	4ad932f7dcda4517b7b5cc0c8beac404
boosting_type	gbdt	9ee14964976f41c9a0d4773391dc1b89
colsample_bytree	0.5224052655996813	9ee14964976f41c9a0d4773391dc1b89
learning_rate	0.018781321930748714	9ee14964976f41c9a0d4773391dc1b89
max_depth	10	9ee14964976f41c9a0d4773391dc1b89
min_child_samples	111	9ee14964976f41c9a0d4773391dc1b89
min_child_weight	0.001	9ee14964976f41c9a0d4773391dc1b89
min_split_gain	0.846166400841145	9ee14964976f41c9a0d4773391dc1b89
num_leaves	88	9ee14964976f41c9a0d4773391dc1b89
random_state	42	9ee14964976f41c9a0d4773391dc1b89
reg_alpha	0.00022824846606627822	9ee14964976f41c9a0d4773391dc1b89
reg_lambda	2.2908811303434547e-05	9ee14964976f41c9a0d4773391dc1b89
subsample	0.7757023180213315	9ee14964976f41c9a0d4773391dc1b89
subsample_for_bin	200000	9ee14964976f41c9a0d4773391dc1b89
subsample_freq	0	9ee14964976f41c9a0d4773391dc1b89
metric	['None']	9ee14964976f41c9a0d4773391dc1b89
verbosity	-1	9ee14964976f41c9a0d4773391dc1b89
scale_pos_weight	6.909419892287117	9ee14964976f41c9a0d4773391dc1b89
objective	binary	9ee14964976f41c9a0d4773391dc1b89
num_threads	12	9ee14964976f41c9a0d4773391dc1b89
num_boost_round	2000	9ee14964976f41c9a0d4773391dc1b89
feature_name	auto	9ee14964976f41c9a0d4773391dc1b89
categorical_feature	auto	9ee14964976f41c9a0d4773391dc1b89
keep_training_booster	False	9ee14964976f41c9a0d4773391dc1b89
num_threads	12	2dd58258a1c14b7e9fbbcf0a30084f7d
num_boost_round	1400	2dd58258a1c14b7e9fbbcf0a30084f7d
feature_name	auto	2dd58258a1c14b7e9fbbcf0a30084f7d
categorical_feature	auto	2dd58258a1c14b7e9fbbcf0a30084f7d
keep_training_booster	False	2dd58258a1c14b7e9fbbcf0a30084f7d
boosting_type	gbdt	b6ad1bd3b5e24e56a38c6e514a836fbb
colsample_bytree	0.6356745158869479	b6ad1bd3b5e24e56a38c6e514a836fbb
learning_rate	0.14992285132527539	b6ad1bd3b5e24e56a38c6e514a836fbb
max_depth	3	b6ad1bd3b5e24e56a38c6e514a836fbb
min_child_samples	72	b6ad1bd3b5e24e56a38c6e514a836fbb
min_child_weight	0.001	b6ad1bd3b5e24e56a38c6e514a836fbb
min_split_gain	0.28093450968738076	b6ad1bd3b5e24e56a38c6e514a836fbb
num_leaves	63	b6ad1bd3b5e24e56a38c6e514a836fbb
random_state	42	b6ad1bd3b5e24e56a38c6e514a836fbb
reg_alpha	0.28749982347407854	b6ad1bd3b5e24e56a38c6e514a836fbb
reg_lambda	1.6247252885719427e-05	b6ad1bd3b5e24e56a38c6e514a836fbb
subsample	0.7554709158757928	b6ad1bd3b5e24e56a38c6e514a836fbb
subsample_for_bin	200000	b6ad1bd3b5e24e56a38c6e514a836fbb
subsample_freq	0	b6ad1bd3b5e24e56a38c6e514a836fbb
metric	['None']	b6ad1bd3b5e24e56a38c6e514a836fbb
verbosity	-1	b6ad1bd3b5e24e56a38c6e514a836fbb
scale_pos_weight	12.081424671801622	b6ad1bd3b5e24e56a38c6e514a836fbb
objective	binary	b6ad1bd3b5e24e56a38c6e514a836fbb
num_threads	12	b6ad1bd3b5e24e56a38c6e514a836fbb
num_boost_round	300	b6ad1bd3b5e24e56a38c6e514a836fbb
feature_name	auto	b6ad1bd3b5e24e56a38c6e514a836fbb
categorical_feature	auto	b6ad1bd3b5e24e56a38c6e514a836fbb
keep_training_booster	False	b6ad1bd3b5e24e56a38c6e514a836fbb
boosting_type	gbdt	3d117da059cf48f1b0389bf9323ce232
colsample_bytree	0.5027610585618012	3d117da059cf48f1b0389bf9323ce232
learning_rate	0.00840889766039911	3d117da059cf48f1b0389bf9323ce232
max_depth	12	3d117da059cf48f1b0389bf9323ce232
min_child_samples	157	3d117da059cf48f1b0389bf9323ce232
min_child_weight	0.001	3d117da059cf48f1b0389bf9323ce232
min_split_gain	0.7290071680409873	3d117da059cf48f1b0389bf9323ce232
num_leaves	33	3d117da059cf48f1b0389bf9323ce232
random_state	42	3d117da059cf48f1b0389bf9323ce232
reg_alpha	0.2183498289760726	3d117da059cf48f1b0389bf9323ce232
reg_lambda	0.022999378190815954	3d117da059cf48f1b0389bf9323ce232
subsample	0.679486272613669	3d117da059cf48f1b0389bf9323ce232
subsample_for_bin	200000	3d117da059cf48f1b0389bf9323ce232
subsample_freq	0	3d117da059cf48f1b0389bf9323ce232
metric	['None']	3d117da059cf48f1b0389bf9323ce232
verbosity	-1	3d117da059cf48f1b0389bf9323ce232
scale_pos_weight	16.585690981760212	3d117da059cf48f1b0389bf9323ce232
objective	binary	3d117da059cf48f1b0389bf9323ce232
num_threads	12	3d117da059cf48f1b0389bf9323ce232
num_boost_round	1700	3d117da059cf48f1b0389bf9323ce232
feature_name	auto	3d117da059cf48f1b0389bf9323ce232
categorical_feature	auto	3d117da059cf48f1b0389bf9323ce232
keep_training_booster	False	3d117da059cf48f1b0389bf9323ce232
boosting_type	gbdt	175caae5af7f4140b4ecae075484bb7b
colsample_bytree	0.5317791751430119	175caae5af7f4140b4ecae075484bb7b
learning_rate	0.006570432809105998	175caae5af7f4140b4ecae075484bb7b
max_depth	11	175caae5af7f4140b4ecae075484bb7b
min_child_samples	129	175caae5af7f4140b4ecae075484bb7b
min_child_weight	0.001	175caae5af7f4140b4ecae075484bb7b
min_split_gain	0.7296061783380641	175caae5af7f4140b4ecae075484bb7b
num_leaves	43	175caae5af7f4140b4ecae075484bb7b
random_state	42	175caae5af7f4140b4ecae075484bb7b
reg_alpha	6.292756043818863e-06	175caae5af7f4140b4ecae075484bb7b
reg_lambda	8.445977074223802e-06	175caae5af7f4140b4ecae075484bb7b
subsample	0.7323592099410596	175caae5af7f4140b4ecae075484bb7b
subsample_for_bin	200000	175caae5af7f4140b4ecae075484bb7b
subsample_freq	0	175caae5af7f4140b4ecae075484bb7b
metric	['None']	175caae5af7f4140b4ecae075484bb7b
verbosity	-1	175caae5af7f4140b4ecae075484bb7b
scale_pos_weight	13.779402841758058	175caae5af7f4140b4ecae075484bb7b
objective	binary	175caae5af7f4140b4ecae075484bb7b
num_threads	12	175caae5af7f4140b4ecae075484bb7b
num_boost_round	800	175caae5af7f4140b4ecae075484bb7b
feature_name	auto	175caae5af7f4140b4ecae075484bb7b
categorical_feature	auto	175caae5af7f4140b4ecae075484bb7b
keep_training_booster	False	175caae5af7f4140b4ecae075484bb7b
boosting_type	gbdt	37b22dee0c674dc0ae4c25e6ee9d21d1
colsample_bytree	0.8854835899772805	37b22dee0c674dc0ae4c25e6ee9d21d1
learning_rate	0.13192832331971246	37b22dee0c674dc0ae4c25e6ee9d21d1
max_depth	10	37b22dee0c674dc0ae4c25e6ee9d21d1
min_child_samples	155	37b22dee0c674dc0ae4c25e6ee9d21d1
min_child_weight	0.001	37b22dee0c674dc0ae4c25e6ee9d21d1
min_split_gain	0.42754101835854963	37b22dee0c674dc0ae4c25e6ee9d21d1
num_leaves	44	37b22dee0c674dc0ae4c25e6ee9d21d1
random_state	42	37b22dee0c674dc0ae4c25e6ee9d21d1
reg_alpha	0.0002780739892288472	37b22dee0c674dc0ae4c25e6ee9d21d1
reg_lambda	0.0005065186776865479	37b22dee0c674dc0ae4c25e6ee9d21d1
subsample	0.8245108790277985	37b22dee0c674dc0ae4c25e6ee9d21d1
subsample_for_bin	200000	37b22dee0c674dc0ae4c25e6ee9d21d1
subsample_freq	0	37b22dee0c674dc0ae4c25e6ee9d21d1
metric	['None']	37b22dee0c674dc0ae4c25e6ee9d21d1
verbosity	-1	37b22dee0c674dc0ae4c25e6ee9d21d1
scale_pos_weight	5.897750424054917	37b22dee0c674dc0ae4c25e6ee9d21d1
objective	binary	37b22dee0c674dc0ae4c25e6ee9d21d1
num_threads	12	37b22dee0c674dc0ae4c25e6ee9d21d1
num_boost_round	1000	37b22dee0c674dc0ae4c25e6ee9d21d1
feature_name	auto	37b22dee0c674dc0ae4c25e6ee9d21d1
categorical_feature	auto	37b22dee0c674dc0ae4c25e6ee9d21d1
keep_training_booster	False	37b22dee0c674dc0ae4c25e6ee9d21d1
boosting_type	gbdt	5b7ac14d710141e0ae9db4df5d76863d
colsample_bytree	0.6246461145744375	5b7ac14d710141e0ae9db4df5d76863d
learning_rate	0.007444208747312283	5b7ac14d710141e0ae9db4df5d76863d
max_depth	6	5b7ac14d710141e0ae9db4df5d76863d
min_child_samples	107	5b7ac14d710141e0ae9db4df5d76863d
min_child_weight	0.001	5b7ac14d710141e0ae9db4df5d76863d
min_split_gain	0.22879816549162246	5b7ac14d710141e0ae9db4df5d76863d
num_leaves	169	5b7ac14d710141e0ae9db4df5d76863d
random_state	42	5b7ac14d710141e0ae9db4df5d76863d
reg_alpha	4.9368087974032924e-05	5b7ac14d710141e0ae9db4df5d76863d
reg_lambda	0.06308995924905789	5b7ac14d710141e0ae9db4df5d76863d
subsample	0.9630265895704372	5b7ac14d710141e0ae9db4df5d76863d
subsample_for_bin	200000	5b7ac14d710141e0ae9db4df5d76863d
subsample_freq	0	5b7ac14d710141e0ae9db4df5d76863d
metric	['None']	5b7ac14d710141e0ae9db4df5d76863d
verbosity	-1	5b7ac14d710141e0ae9db4df5d76863d
scale_pos_weight	6.334744091555487	5b7ac14d710141e0ae9db4df5d76863d
objective	binary	5b7ac14d710141e0ae9db4df5d76863d
num_threads	12	5b7ac14d710141e0ae9db4df5d76863d
num_boost_round	200	5b7ac14d710141e0ae9db4df5d76863d
feature_name	auto	5b7ac14d710141e0ae9db4df5d76863d
categorical_feature	auto	5b7ac14d710141e0ae9db4df5d76863d
keep_training_booster	False	5b7ac14d710141e0ae9db4df5d76863d
boosting_type	gbdt	cbe54d84d2f84e4b982ad2d27427c7a7
colsample_bytree	0.5459496369644187	cbe54d84d2f84e4b982ad2d27427c7a7
learning_rate	0.069591953203214	cbe54d84d2f84e4b982ad2d27427c7a7
max_depth	5	cbe54d84d2f84e4b982ad2d27427c7a7
min_child_samples	93	cbe54d84d2f84e4b982ad2d27427c7a7
min_child_weight	0.001	cbe54d84d2f84e4b982ad2d27427c7a7
min_split_gain	0.23729316652735474	cbe54d84d2f84e4b982ad2d27427c7a7
num_leaves	57	cbe54d84d2f84e4b982ad2d27427c7a7
random_state	42	cbe54d84d2f84e4b982ad2d27427c7a7
reg_alpha	8.17160203546872	cbe54d84d2f84e4b982ad2d27427c7a7
reg_lambda	0.00022810424935319995	cbe54d84d2f84e4b982ad2d27427c7a7
subsample	0.7468529318605425	cbe54d84d2f84e4b982ad2d27427c7a7
subsample_for_bin	200000	cbe54d84d2f84e4b982ad2d27427c7a7
subsample_freq	0	cbe54d84d2f84e4b982ad2d27427c7a7
metric	['None']	cbe54d84d2f84e4b982ad2d27427c7a7
verbosity	-1	cbe54d84d2f84e4b982ad2d27427c7a7
scale_pos_weight	7.558771938467413	cbe54d84d2f84e4b982ad2d27427c7a7
objective	binary	cbe54d84d2f84e4b982ad2d27427c7a7
num_threads	12	cbe54d84d2f84e4b982ad2d27427c7a7
num_boost_round	700	cbe54d84d2f84e4b982ad2d27427c7a7
feature_name	auto	cbe54d84d2f84e4b982ad2d27427c7a7
categorical_feature	auto	cbe54d84d2f84e4b982ad2d27427c7a7
keep_training_booster	False	cbe54d84d2f84e4b982ad2d27427c7a7
colsample_bytree	0.5426815320800851	7f39848a745a4f55b4b6f53656bbea09
learning_rate	0.00820001793333359	7f39848a745a4f55b4b6f53656bbea09
max_depth	11	7f39848a745a4f55b4b6f53656bbea09
min_child_samples	156	7f39848a745a4f55b4b6f53656bbea09
min_child_weight	0.001	7f39848a745a4f55b4b6f53656bbea09
min_split_gain	0.8837526106556846	7f39848a745a4f55b4b6f53656bbea09
num_leaves	42	7f39848a745a4f55b4b6f53656bbea09
random_state	42	7f39848a745a4f55b4b6f53656bbea09
reg_alpha	0.06684393231840235	7f39848a745a4f55b4b6f53656bbea09
reg_lambda	7.83002365566361e-06	7f39848a745a4f55b4b6f53656bbea09
subsample	0.7547164338330148	7f39848a745a4f55b4b6f53656bbea09
subsample_for_bin	200000	7f39848a745a4f55b4b6f53656bbea09
subsample_freq	0	7f39848a745a4f55b4b6f53656bbea09
metric	['None']	7f39848a745a4f55b4b6f53656bbea09
verbosity	-1	7f39848a745a4f55b4b6f53656bbea09
scale_pos_weight	7.727831464876293	7f39848a745a4f55b4b6f53656bbea09
objective	binary	7f39848a745a4f55b4b6f53656bbea09
num_threads	12	7f39848a745a4f55b4b6f53656bbea09
num_boost_round	1900	7f39848a745a4f55b4b6f53656bbea09
feature_name	auto	7f39848a745a4f55b4b6f53656bbea09
categorical_feature	auto	7f39848a745a4f55b4b6f53656bbea09
keep_training_booster	False	7f39848a745a4f55b4b6f53656bbea09
boosting_type	gbdt	82ae9253c99347c28805e14bb275d4e1
colsample_bytree	0.5062260141933643	82ae9253c99347c28805e14bb275d4e1
learning_rate	0.014113339369436522	82ae9253c99347c28805e14bb275d4e1
max_depth	9	82ae9253c99347c28805e14bb275d4e1
min_child_samples	124	82ae9253c99347c28805e14bb275d4e1
min_child_weight	0.001	82ae9253c99347c28805e14bb275d4e1
min_split_gain	0.9025610583897513	82ae9253c99347c28805e14bb275d4e1
num_leaves	32	82ae9253c99347c28805e14bb275d4e1
random_state	42	82ae9253c99347c28805e14bb275d4e1
reg_alpha	0.11316222273590461	82ae9253c99347c28805e14bb275d4e1
reg_lambda	0.0011383734175509671	82ae9253c99347c28805e14bb275d4e1
subsample	0.8731872345697332	82ae9253c99347c28805e14bb275d4e1
subsample_for_bin	200000	82ae9253c99347c28805e14bb275d4e1
subsample_freq	0	82ae9253c99347c28805e14bb275d4e1
metric	['None']	82ae9253c99347c28805e14bb275d4e1
verbosity	-1	82ae9253c99347c28805e14bb275d4e1
scale_pos_weight	9.207207144877492	82ae9253c99347c28805e14bb275d4e1
objective	binary	82ae9253c99347c28805e14bb275d4e1
num_threads	12	82ae9253c99347c28805e14bb275d4e1
num_boost_round	1800	82ae9253c99347c28805e14bb275d4e1
boosting_type	gbdt	e5c01080e79f4145ae6c1fbbeb6dab7f
colsample_bytree	0.5200589513951025	e5c01080e79f4145ae6c1fbbeb6dab7f
learning_rate	0.16477757410854557	e5c01080e79f4145ae6c1fbbeb6dab7f
max_depth	3	e5c01080e79f4145ae6c1fbbeb6dab7f
min_child_samples	102	e5c01080e79f4145ae6c1fbbeb6dab7f
min_child_weight	0.001	e5c01080e79f4145ae6c1fbbeb6dab7f
min_split_gain	0.3101142860313057	e5c01080e79f4145ae6c1fbbeb6dab7f
num_leaves	51	e5c01080e79f4145ae6c1fbbeb6dab7f
random_state	42	e5c01080e79f4145ae6c1fbbeb6dab7f
reg_alpha	2.612775477586644	e5c01080e79f4145ae6c1fbbeb6dab7f
reg_lambda	0.00012127980991816303	e5c01080e79f4145ae6c1fbbeb6dab7f
subsample	0.7111700096487206	e5c01080e79f4145ae6c1fbbeb6dab7f
subsample_for_bin	200000	e5c01080e79f4145ae6c1fbbeb6dab7f
subsample_freq	0	e5c01080e79f4145ae6c1fbbeb6dab7f
metric	['None']	e5c01080e79f4145ae6c1fbbeb6dab7f
verbosity	-1	e5c01080e79f4145ae6c1fbbeb6dab7f
scale_pos_weight	19.623889885737498	e5c01080e79f4145ae6c1fbbeb6dab7f
objective	binary	e5c01080e79f4145ae6c1fbbeb6dab7f
num_threads	12	e5c01080e79f4145ae6c1fbbeb6dab7f
num_boost_round	400	e5c01080e79f4145ae6c1fbbeb6dab7f
feature_name	auto	e5c01080e79f4145ae6c1fbbeb6dab7f
categorical_feature	auto	e5c01080e79f4145ae6c1fbbeb6dab7f
keep_training_booster	False	e5c01080e79f4145ae6c1fbbeb6dab7f
boosting_type	gbdt	db19dbd296a547468d99e1eac5c48d91
colsample_bytree	0.5277920881263479	db19dbd296a547468d99e1eac5c48d91
learning_rate	0.011258609362548825	db19dbd296a547468d99e1eac5c48d91
max_depth	10	db19dbd296a547468d99e1eac5c48d91
min_child_samples	177	db19dbd296a547468d99e1eac5c48d91
min_child_weight	0.001	db19dbd296a547468d99e1eac5c48d91
min_split_gain	0.7254839236198967	db19dbd296a547468d99e1eac5c48d91
num_leaves	80	db19dbd296a547468d99e1eac5c48d91
random_state	42	db19dbd296a547468d99e1eac5c48d91
reg_alpha	3.011894718483981	db19dbd296a547468d99e1eac5c48d91
reg_lambda	0.14514062097144495	db19dbd296a547468d99e1eac5c48d91
subsample	0.6075534126225095	db19dbd296a547468d99e1eac5c48d91
subsample_for_bin	200000	db19dbd296a547468d99e1eac5c48d91
subsample_freq	0	db19dbd296a547468d99e1eac5c48d91
metric	['None']	db19dbd296a547468d99e1eac5c48d91
verbosity	-1	db19dbd296a547468d99e1eac5c48d91
scale_pos_weight	15.96022327817276	db19dbd296a547468d99e1eac5c48d91
objective	binary	db19dbd296a547468d99e1eac5c48d91
num_threads	12	db19dbd296a547468d99e1eac5c48d91
num_boost_round	1900	db19dbd296a547468d99e1eac5c48d91
feature_name	auto	db19dbd296a547468d99e1eac5c48d91
categorical_feature	auto	db19dbd296a547468d99e1eac5c48d91
keep_training_booster	False	db19dbd296a547468d99e1eac5c48d91
boosting_type	gbdt	5ca501b4ad684b6d8ca4c0d74bc38d7d
colsample_bytree	0.7529077810378197	5ca501b4ad684b6d8ca4c0d74bc38d7d
learning_rate	0.08726232858031546	5ca501b4ad684b6d8ca4c0d74bc38d7d
max_depth	5	5ca501b4ad684b6d8ca4c0d74bc38d7d
min_child_samples	97	5ca501b4ad684b6d8ca4c0d74bc38d7d
min_child_weight	0.001	5ca501b4ad684b6d8ca4c0d74bc38d7d
min_split_gain	0.5225246502761467	5ca501b4ad684b6d8ca4c0d74bc38d7d
num_leaves	122	5ca501b4ad684b6d8ca4c0d74bc38d7d
random_state	42	5ca501b4ad684b6d8ca4c0d74bc38d7d
reg_alpha	0.23103849303604457	5ca501b4ad684b6d8ca4c0d74bc38d7d
reg_lambda	9.560224410309003e-05	5ca501b4ad684b6d8ca4c0d74bc38d7d
subsample	0.8259524664510207	5ca501b4ad684b6d8ca4c0d74bc38d7d
subsample_for_bin	200000	5ca501b4ad684b6d8ca4c0d74bc38d7d
subsample_freq	0	5ca501b4ad684b6d8ca4c0d74bc38d7d
metric	['None']	5ca501b4ad684b6d8ca4c0d74bc38d7d
verbosity	-1	5ca501b4ad684b6d8ca4c0d74bc38d7d
scale_pos_weight	10.522111660344333	5ca501b4ad684b6d8ca4c0d74bc38d7d
objective	binary	5ca501b4ad684b6d8ca4c0d74bc38d7d
num_threads	12	5ca501b4ad684b6d8ca4c0d74bc38d7d
num_boost_round	900	5ca501b4ad684b6d8ca4c0d74bc38d7d
feature_name	auto	5ca501b4ad684b6d8ca4c0d74bc38d7d
categorical_feature	auto	5ca501b4ad684b6d8ca4c0d74bc38d7d
keep_training_booster	False	5ca501b4ad684b6d8ca4c0d74bc38d7d
boosting_type	gbdt	920842c57a5a49bb87e14ce762de0e6f
colsample_bytree	0.5185363670533426	920842c57a5a49bb87e14ce762de0e6f
learning_rate	0.018009813582048697	920842c57a5a49bb87e14ce762de0e6f
max_depth	5	920842c57a5a49bb87e14ce762de0e6f
min_child_samples	102	920842c57a5a49bb87e14ce762de0e6f
min_child_weight	0.001	920842c57a5a49bb87e14ce762de0e6f
min_split_gain	0.8081790664083908	920842c57a5a49bb87e14ce762de0e6f
num_leaves	55	920842c57a5a49bb87e14ce762de0e6f
random_state	42	920842c57a5a49bb87e14ce762de0e6f
reg_alpha	1.65244827758869	920842c57a5a49bb87e14ce762de0e6f
reg_lambda	0.7435729018258338	920842c57a5a49bb87e14ce762de0e6f
subsample	0.6508396905818342	920842c57a5a49bb87e14ce762de0e6f
subsample_for_bin	200000	920842c57a5a49bb87e14ce762de0e6f
subsample_freq	0	920842c57a5a49bb87e14ce762de0e6f
metric	['None']	920842c57a5a49bb87e14ce762de0e6f
verbosity	-1	920842c57a5a49bb87e14ce762de0e6f
scale_pos_weight	22.631687313520587	920842c57a5a49bb87e14ce762de0e6f
objective	binary	920842c57a5a49bb87e14ce762de0e6f
num_threads	12	920842c57a5a49bb87e14ce762de0e6f
num_boost_round	1400	920842c57a5a49bb87e14ce762de0e6f
feature_name	auto	920842c57a5a49bb87e14ce762de0e6f
categorical_feature	auto	920842c57a5a49bb87e14ce762de0e6f
keep_training_booster	False	920842c57a5a49bb87e14ce762de0e6f
boosting_type	gbdt	12c0eb897e9e4e799fa7e402ede53e68
colsample_bytree	0.6094259631665798	12c0eb897e9e4e799fa7e402ede53e68
learning_rate	0.010634782624276721	12c0eb897e9e4e799fa7e402ede53e68
max_depth	4	12c0eb897e9e4e799fa7e402ede53e68
min_child_samples	97	12c0eb897e9e4e799fa7e402ede53e68
min_child_weight	0.001	12c0eb897e9e4e799fa7e402ede53e68
min_split_gain	0.6575208494781593	12c0eb897e9e4e799fa7e402ede53e68
num_leaves	94	12c0eb897e9e4e799fa7e402ede53e68
random_state	42	12c0eb897e9e4e799fa7e402ede53e68
reg_alpha	0.32464516037818625	12c0eb897e9e4e799fa7e402ede53e68
reg_lambda	0.006332004126368831	12c0eb897e9e4e799fa7e402ede53e68
subsample	0.6930431333486554	12c0eb897e9e4e799fa7e402ede53e68
subsample_for_bin	200000	12c0eb897e9e4e799fa7e402ede53e68
subsample_freq	0	12c0eb897e9e4e799fa7e402ede53e68
metric	['None']	12c0eb897e9e4e799fa7e402ede53e68
verbosity	-1	12c0eb897e9e4e799fa7e402ede53e68
scale_pos_weight	20.89053996146356	12c0eb897e9e4e799fa7e402ede53e68
objective	binary	12c0eb897e9e4e799fa7e402ede53e68
num_threads	12	12c0eb897e9e4e799fa7e402ede53e68
num_boost_round	1800	12c0eb897e9e4e799fa7e402ede53e68
feature_name	auto	12c0eb897e9e4e799fa7e402ede53e68
categorical_feature	auto	12c0eb897e9e4e799fa7e402ede53e68
keep_training_booster	False	12c0eb897e9e4e799fa7e402ede53e68
boosting_type	gbdt	dab10324d6874b25b032b2e41b538db5
colsample_bytree	0.5909496520719795	dab10324d6874b25b032b2e41b538db5
learning_rate	0.13377548113346238	dab10324d6874b25b032b2e41b538db5
max_depth	4	dab10324d6874b25b032b2e41b538db5
min_child_samples	68	dab10324d6874b25b032b2e41b538db5
min_child_weight	0.001	dab10324d6874b25b032b2e41b538db5
min_split_gain	0.09729472999688926	dab10324d6874b25b032b2e41b538db5
num_leaves	84	dab10324d6874b25b032b2e41b538db5
random_state	42	dab10324d6874b25b032b2e41b538db5
reg_alpha	7.9094522420916755	dab10324d6874b25b032b2e41b538db5
reg_lambda	2.2595983666714804e-06	dab10324d6874b25b032b2e41b538db5
subsample	0.7398336046630319	dab10324d6874b25b032b2e41b538db5
subsample_for_bin	200000	dab10324d6874b25b032b2e41b538db5
subsample_freq	0	dab10324d6874b25b032b2e41b538db5
metric	['None']	dab10324d6874b25b032b2e41b538db5
verbosity	-1	dab10324d6874b25b032b2e41b538db5
scale_pos_weight	7.572488060692366	dab10324d6874b25b032b2e41b538db5
objective	binary	dab10324d6874b25b032b2e41b538db5
num_threads	12	dab10324d6874b25b032b2e41b538db5
num_boost_round	400	dab10324d6874b25b032b2e41b538db5
feature_name	auto	dab10324d6874b25b032b2e41b538db5
categorical_feature	auto	dab10324d6874b25b032b2e41b538db5
keep_training_booster	False	dab10324d6874b25b032b2e41b538db5
boosting_type	gbdt	0fa292059a01459388a9848f32021680
colsample_bytree	0.6950443049317041	0fa292059a01459388a9848f32021680
learning_rate	0.1424747999275456	0fa292059a01459388a9848f32021680
max_depth	3	0fa292059a01459388a9848f32021680
min_child_samples	33	0fa292059a01459388a9848f32021680
min_child_weight	0.001	0fa292059a01459388a9848f32021680
min_split_gain	0.05919198998769859	0fa292059a01459388a9848f32021680
num_leaves	85	0fa292059a01459388a9848f32021680
random_state	42	0fa292059a01459388a9848f32021680
reg_alpha	7.951186589740594	0fa292059a01459388a9848f32021680
reg_lambda	0.00013619793530537415	0fa292059a01459388a9848f32021680
subsample	0.8802679844794365	0fa292059a01459388a9848f32021680
subsample_for_bin	200000	0fa292059a01459388a9848f32021680
subsample_freq	0	0fa292059a01459388a9848f32021680
metric	['None']	0fa292059a01459388a9848f32021680
verbosity	-1	0fa292059a01459388a9848f32021680
scale_pos_weight	15.505006536502231	0fa292059a01459388a9848f32021680
objective	binary	0fa292059a01459388a9848f32021680
num_threads	12	0fa292059a01459388a9848f32021680
num_boost_round	400	0fa292059a01459388a9848f32021680
feature_name	auto	0fa292059a01459388a9848f32021680
categorical_feature	auto	0fa292059a01459388a9848f32021680
keep_training_booster	False	0fa292059a01459388a9848f32021680
colsample_bytree	0.6804649046004829	97fb30d77c874bbe909e9b34ff9ab219
learning_rate	0.013212170847008953	97fb30d77c874bbe909e9b34ff9ab219
max_depth	10	97fb30d77c874bbe909e9b34ff9ab219
min_child_samples	199	97fb30d77c874bbe909e9b34ff9ab219
min_child_weight	0.001	97fb30d77c874bbe909e9b34ff9ab219
min_split_gain	0.9899084954873785	97fb30d77c874bbe909e9b34ff9ab219
num_leaves	166	97fb30d77c874bbe909e9b34ff9ab219
random_state	42	97fb30d77c874bbe909e9b34ff9ab219
reg_alpha	0.015161403723457714	97fb30d77c874bbe909e9b34ff9ab219
reg_lambda	0.0017730748065215346	97fb30d77c874bbe909e9b34ff9ab219
subsample	0.6642172472094173	97fb30d77c874bbe909e9b34ff9ab219
subsample_for_bin	200000	97fb30d77c874bbe909e9b34ff9ab219
subsample_freq	0	97fb30d77c874bbe909e9b34ff9ab219
metric	['None']	97fb30d77c874bbe909e9b34ff9ab219
verbosity	-1	97fb30d77c874bbe909e9b34ff9ab219
scale_pos_weight	11.85814394874013	97fb30d77c874bbe909e9b34ff9ab219
objective	binary	97fb30d77c874bbe909e9b34ff9ab219
num_threads	12	97fb30d77c874bbe909e9b34ff9ab219
num_boost_round	1800	97fb30d77c874bbe909e9b34ff9ab219
feature_name	auto	97fb30d77c874bbe909e9b34ff9ab219
categorical_feature	auto	97fb30d77c874bbe909e9b34ff9ab219
keep_training_booster	False	97fb30d77c874bbe909e9b34ff9ab219
boosting_type	gbdt	5271cb97dc8e4421816e4fbc4e06b329
colsample_bytree	0.7791044151451426	5271cb97dc8e4421816e4fbc4e06b329
boosting_type	gbdt	464465db08d54ca3890683e7f08018cd
colsample_bytree	0.657626649945382	464465db08d54ca3890683e7f08018cd
learning_rate	0.018857798567794022	464465db08d54ca3890683e7f08018cd
max_depth	4	464465db08d54ca3890683e7f08018cd
min_child_samples	118	464465db08d54ca3890683e7f08018cd
min_child_weight	0.001	464465db08d54ca3890683e7f08018cd
min_split_gain	0.9194077032854729	464465db08d54ca3890683e7f08018cd
num_leaves	24	464465db08d54ca3890683e7f08018cd
random_state	42	464465db08d54ca3890683e7f08018cd
reg_alpha	1.2793440056026084	464465db08d54ca3890683e7f08018cd
reg_lambda	1.7532127861413447	464465db08d54ca3890683e7f08018cd
subsample	0.7308111113157129	464465db08d54ca3890683e7f08018cd
subsample_for_bin	200000	464465db08d54ca3890683e7f08018cd
subsample_freq	0	464465db08d54ca3890683e7f08018cd
metric	['None']	464465db08d54ca3890683e7f08018cd
verbosity	-1	464465db08d54ca3890683e7f08018cd
scale_pos_weight	13.71736112864101	464465db08d54ca3890683e7f08018cd
objective	binary	464465db08d54ca3890683e7f08018cd
num_threads	12	464465db08d54ca3890683e7f08018cd
num_boost_round	700	464465db08d54ca3890683e7f08018cd
feature_name	auto	464465db08d54ca3890683e7f08018cd
categorical_feature	auto	464465db08d54ca3890683e7f08018cd
keep_training_booster	False	464465db08d54ca3890683e7f08018cd
boosting_type	gbdt	2719cadee66a4cddb04bd6047c0bdea1
colsample_bytree	0.5890686384698496	2719cadee66a4cddb04bd6047c0bdea1
learning_rate	0.06056935483491206	2719cadee66a4cddb04bd6047c0bdea1
max_depth	7	2719cadee66a4cddb04bd6047c0bdea1
min_child_samples	78	2719cadee66a4cddb04bd6047c0bdea1
min_child_weight	0.001	2719cadee66a4cddb04bd6047c0bdea1
min_split_gain	0.9107099985733853	2719cadee66a4cddb04bd6047c0bdea1
num_leaves	16	2719cadee66a4cddb04bd6047c0bdea1
random_state	42	2719cadee66a4cddb04bd6047c0bdea1
reg_alpha	0.0005077460307670194	2719cadee66a4cddb04bd6047c0bdea1
reg_lambda	0.04949861914267087	2719cadee66a4cddb04bd6047c0bdea1
subsample	0.6132391031580616	2719cadee66a4cddb04bd6047c0bdea1
subsample_for_bin	200000	2719cadee66a4cddb04bd6047c0bdea1
subsample_freq	0	2719cadee66a4cddb04bd6047c0bdea1
metric	['None']	2719cadee66a4cddb04bd6047c0bdea1
verbosity	-1	2719cadee66a4cddb04bd6047c0bdea1
scale_pos_weight	18.162631160237627	2719cadee66a4cddb04bd6047c0bdea1
objective	binary	2719cadee66a4cddb04bd6047c0bdea1
num_threads	12	2719cadee66a4cddb04bd6047c0bdea1
num_boost_round	1400	2719cadee66a4cddb04bd6047c0bdea1
feature_name	auto	2719cadee66a4cddb04bd6047c0bdea1
categorical_feature	auto	2719cadee66a4cddb04bd6047c0bdea1
keep_training_booster	False	2719cadee66a4cddb04bd6047c0bdea1
boosting_type	gbdt	7da83a5b702d4cd9a3b6288e6ec4a963
colsample_bytree	0.7760583194683204	7da83a5b702d4cd9a3b6288e6ec4a963
learning_rate	0.19553097820229431	7da83a5b702d4cd9a3b6288e6ec4a963
max_depth	3	7da83a5b702d4cd9a3b6288e6ec4a963
min_child_samples	93	7da83a5b702d4cd9a3b6288e6ec4a963
min_child_weight	0.001	7da83a5b702d4cd9a3b6288e6ec4a963
min_split_gain	0.231311596482478	7da83a5b702d4cd9a3b6288e6ec4a963
num_leaves	85	7da83a5b702d4cd9a3b6288e6ec4a963
random_state	42	7da83a5b702d4cd9a3b6288e6ec4a963
reg_alpha	0.0001548125154313919	7da83a5b702d4cd9a3b6288e6ec4a963
reg_lambda	5.384937959109988e-08	7da83a5b702d4cd9a3b6288e6ec4a963
subsample	0.6041736019184253	7da83a5b702d4cd9a3b6288e6ec4a963
subsample_for_bin	200000	7da83a5b702d4cd9a3b6288e6ec4a963
subsample_freq	0	7da83a5b702d4cd9a3b6288e6ec4a963
metric	['None']	7da83a5b702d4cd9a3b6288e6ec4a963
verbosity	-1	7da83a5b702d4cd9a3b6288e6ec4a963
scale_pos_weight	7.957332882001401	7da83a5b702d4cd9a3b6288e6ec4a963
objective	binary	7da83a5b702d4cd9a3b6288e6ec4a963
num_threads	12	7da83a5b702d4cd9a3b6288e6ec4a963
num_boost_round	300	7da83a5b702d4cd9a3b6288e6ec4a963
feature_name	auto	7da83a5b702d4cd9a3b6288e6ec4a963
categorical_feature	auto	7da83a5b702d4cd9a3b6288e6ec4a963
keep_training_booster	False	7da83a5b702d4cd9a3b6288e6ec4a963
boosting_type	gbdt	a88dec410f58417cb1ad18c7cb2485f3
colsample_bytree	0.6634396711887434	a88dec410f58417cb1ad18c7cb2485f3
learning_rate	0.13976395204576772	a88dec410f58417cb1ad18c7cb2485f3
max_depth	5	a88dec410f58417cb1ad18c7cb2485f3
min_child_samples	122	a88dec410f58417cb1ad18c7cb2485f3
min_child_weight	0.001	a88dec410f58417cb1ad18c7cb2485f3
min_split_gain	0.422271941016514	a88dec410f58417cb1ad18c7cb2485f3
num_leaves	67	a88dec410f58417cb1ad18c7cb2485f3
random_state	42	a88dec410f58417cb1ad18c7cb2485f3
reg_alpha	0.0069291157449864575	a88dec410f58417cb1ad18c7cb2485f3
reg_lambda	0.37770489908457827	a88dec410f58417cb1ad18c7cb2485f3
subsample	0.7061074997638268	a88dec410f58417cb1ad18c7cb2485f3
subsample_for_bin	200000	a88dec410f58417cb1ad18c7cb2485f3
subsample_freq	0	a88dec410f58417cb1ad18c7cb2485f3
metric	['None']	a88dec410f58417cb1ad18c7cb2485f3
verbosity	-1	a88dec410f58417cb1ad18c7cb2485f3
scale_pos_weight	9.796317372840827	a88dec410f58417cb1ad18c7cb2485f3
objective	binary	a88dec410f58417cb1ad18c7cb2485f3
num_threads	12	a88dec410f58417cb1ad18c7cb2485f3
num_boost_round	200	a88dec410f58417cb1ad18c7cb2485f3
feature_name	auto	a88dec410f58417cb1ad18c7cb2485f3
categorical_feature	auto	a88dec410f58417cb1ad18c7cb2485f3
keep_training_booster	False	a88dec410f58417cb1ad18c7cb2485f3
boosting_type	gbdt	57a6a6513f3d4a139635fb009beabe0e
colsample_bytree	0.5838292342822339	57a6a6513f3d4a139635fb009beabe0e
learning_rate	0.13583504770489477	57a6a6513f3d4a139635fb009beabe0e
max_depth	5	57a6a6513f3d4a139635fb009beabe0e
min_child_samples	69	57a6a6513f3d4a139635fb009beabe0e
min_child_weight	0.001	57a6a6513f3d4a139635fb009beabe0e
min_split_gain	0.025231417030903966	57a6a6513f3d4a139635fb009beabe0e
num_leaves	100	57a6a6513f3d4a139635fb009beabe0e
random_state	42	57a6a6513f3d4a139635fb009beabe0e
reg_alpha	1.8263210218788382	57a6a6513f3d4a139635fb009beabe0e
reg_lambda	3.0901543164396807e-07	57a6a6513f3d4a139635fb009beabe0e
subsample	0.7861679299696946	57a6a6513f3d4a139635fb009beabe0e
subsample_for_bin	200000	57a6a6513f3d4a139635fb009beabe0e
subsample_freq	0	57a6a6513f3d4a139635fb009beabe0e
metric	['None']	57a6a6513f3d4a139635fb009beabe0e
verbosity	-1	57a6a6513f3d4a139635fb009beabe0e
scale_pos_weight	7.5755283180956505	57a6a6513f3d4a139635fb009beabe0e
objective	binary	57a6a6513f3d4a139635fb009beabe0e
num_threads	12	57a6a6513f3d4a139635fb009beabe0e
num_boost_round	300	57a6a6513f3d4a139635fb009beabe0e
feature_name	auto	57a6a6513f3d4a139635fb009beabe0e
categorical_feature	auto	57a6a6513f3d4a139635fb009beabe0e
keep_training_booster	False	57a6a6513f3d4a139635fb009beabe0e
boosting_type	gbdt	23cfec62bb2b4c81b834e33e1d64015a
colsample_bytree	0.6818699097091601	23cfec62bb2b4c81b834e33e1d64015a
learning_rate	0.009398591858209016	23cfec62bb2b4c81b834e33e1d64015a
max_depth	9	23cfec62bb2b4c81b834e33e1d64015a
min_child_samples	194	23cfec62bb2b4c81b834e33e1d64015a
min_child_weight	0.001	23cfec62bb2b4c81b834e33e1d64015a
min_split_gain	0.9292917713841117	23cfec62bb2b4c81b834e33e1d64015a
num_leaves	28	23cfec62bb2b4c81b834e33e1d64015a
random_state	42	23cfec62bb2b4c81b834e33e1d64015a
reg_alpha	0.15251864577664764	23cfec62bb2b4c81b834e33e1d64015a
reg_lambda	0.0012962045879447224	23cfec62bb2b4c81b834e33e1d64015a
subsample	0.7139145004321513	23cfec62bb2b4c81b834e33e1d64015a
subsample_for_bin	200000	23cfec62bb2b4c81b834e33e1d64015a
subsample_freq	0	23cfec62bb2b4c81b834e33e1d64015a
metric	['None']	23cfec62bb2b4c81b834e33e1d64015a
verbosity	-1	23cfec62bb2b4c81b834e33e1d64015a
scale_pos_weight	6.773680116184095	23cfec62bb2b4c81b834e33e1d64015a
objective	binary	23cfec62bb2b4c81b834e33e1d64015a
num_threads	12	23cfec62bb2b4c81b834e33e1d64015a
num_boost_round	1800	23cfec62bb2b4c81b834e33e1d64015a
feature_name	auto	23cfec62bb2b4c81b834e33e1d64015a
categorical_feature	auto	23cfec62bb2b4c81b834e33e1d64015a
keep_training_booster	False	23cfec62bb2b4c81b834e33e1d64015a
boosting_type	gbdt	99f8a6c1a99042518e4a0ef2de67cbd0
colsample_bytree	0.5971068500036539	99f8a6c1a99042518e4a0ef2de67cbd0
learning_rate	0.018043679513671664	99f8a6c1a99042518e4a0ef2de67cbd0
max_depth	12	99f8a6c1a99042518e4a0ef2de67cbd0
min_child_samples	112	99f8a6c1a99042518e4a0ef2de67cbd0
min_child_weight	0.001	99f8a6c1a99042518e4a0ef2de67cbd0
min_split_gain	0.8857592714194129	99f8a6c1a99042518e4a0ef2de67cbd0
num_leaves	54	99f8a6c1a99042518e4a0ef2de67cbd0
random_state	42	99f8a6c1a99042518e4a0ef2de67cbd0
reg_alpha	0.024425093374677166	99f8a6c1a99042518e4a0ef2de67cbd0
reg_lambda	0.0009349828269196155	99f8a6c1a99042518e4a0ef2de67cbd0
subsample	0.82769572965346	99f8a6c1a99042518e4a0ef2de67cbd0
subsample_for_bin	200000	99f8a6c1a99042518e4a0ef2de67cbd0
subsample_freq	0	99f8a6c1a99042518e4a0ef2de67cbd0
metric	['None']	99f8a6c1a99042518e4a0ef2de67cbd0
verbosity	-1	99f8a6c1a99042518e4a0ef2de67cbd0
scale_pos_weight	9.528157953063166	99f8a6c1a99042518e4a0ef2de67cbd0
objective	binary	99f8a6c1a99042518e4a0ef2de67cbd0
num_threads	12	99f8a6c1a99042518e4a0ef2de67cbd0
num_boost_round	1400	99f8a6c1a99042518e4a0ef2de67cbd0
feature_name	auto	99f8a6c1a99042518e4a0ef2de67cbd0
categorical_feature	auto	99f8a6c1a99042518e4a0ef2de67cbd0
keep_training_booster	False	99f8a6c1a99042518e4a0ef2de67cbd0
feature_name	auto	82ae9253c99347c28805e14bb275d4e1
categorical_feature	auto	82ae9253c99347c28805e14bb275d4e1
keep_training_booster	False	82ae9253c99347c28805e14bb275d4e1
boosting_type	gbdt	143106f491a142fa98764b4036346fc5
colsample_bytree	0.5564032001041205	143106f491a142fa98764b4036346fc5
learning_rate	0.011372950957176553	143106f491a142fa98764b4036346fc5
max_depth	12	143106f491a142fa98764b4036346fc5
min_child_samples	173	143106f491a142fa98764b4036346fc5
min_child_weight	0.001	143106f491a142fa98764b4036346fc5
min_split_gain	0.97813001087252	143106f491a142fa98764b4036346fc5
num_leaves	21	143106f491a142fa98764b4036346fc5
random_state	42	143106f491a142fa98764b4036346fc5
reg_alpha	0.08129751354478712	143106f491a142fa98764b4036346fc5
reg_lambda	0.0011960289229646338	143106f491a142fa98764b4036346fc5
subsample	0.9218800138335924	143106f491a142fa98764b4036346fc5
subsample_for_bin	200000	143106f491a142fa98764b4036346fc5
subsample_freq	0	143106f491a142fa98764b4036346fc5
metric	['None']	143106f491a142fa98764b4036346fc5
verbosity	-1	143106f491a142fa98764b4036346fc5
scale_pos_weight	11.555748412060307	143106f491a142fa98764b4036346fc5
objective	binary	143106f491a142fa98764b4036346fc5
num_threads	12	143106f491a142fa98764b4036346fc5
num_boost_round	2000	143106f491a142fa98764b4036346fc5
feature_name	auto	143106f491a142fa98764b4036346fc5
boosting_type	gbdt	bdb2446748cb45d9b995eaf2595da298
colsample_bytree	0.5151056897669468	bdb2446748cb45d9b995eaf2595da298
learning_rate	0.03900126567930021	bdb2446748cb45d9b995eaf2595da298
max_depth	3	bdb2446748cb45d9b995eaf2595da298
min_child_samples	67	bdb2446748cb45d9b995eaf2595da298
min_child_weight	0.001	bdb2446748cb45d9b995eaf2595da298
min_split_gain	0.35790391952629647	bdb2446748cb45d9b995eaf2595da298
num_leaves	46	bdb2446748cb45d9b995eaf2595da298
random_state	42	bdb2446748cb45d9b995eaf2595da298
reg_alpha	0.045688012229333816	bdb2446748cb45d9b995eaf2595da298
reg_lambda	1.3435057213096238e-06	bdb2446748cb45d9b995eaf2595da298
subsample	0.6492784953183137	bdb2446748cb45d9b995eaf2595da298
subsample_for_bin	200000	bdb2446748cb45d9b995eaf2595da298
subsample_freq	0	bdb2446748cb45d9b995eaf2595da298
metric	['None']	bdb2446748cb45d9b995eaf2595da298
verbosity	-1	bdb2446748cb45d9b995eaf2595da298
scale_pos_weight	10.363848518305758	bdb2446748cb45d9b995eaf2595da298
objective	binary	bdb2446748cb45d9b995eaf2595da298
num_threads	12	bdb2446748cb45d9b995eaf2595da298
num_boost_round	400	bdb2446748cb45d9b995eaf2595da298
feature_name	auto	bdb2446748cb45d9b995eaf2595da298
categorical_feature	auto	bdb2446748cb45d9b995eaf2595da298
keep_training_booster	False	bdb2446748cb45d9b995eaf2595da298
boosting_type	gbdt	52254688abc64f459641607d3a8dfb6a
colsample_bytree	0.6038820060357183	52254688abc64f459641607d3a8dfb6a
learning_rate	0.03596702848483272	52254688abc64f459641607d3a8dfb6a
max_depth	5	52254688abc64f459641607d3a8dfb6a
min_child_samples	94	52254688abc64f459641607d3a8dfb6a
min_child_weight	0.001	52254688abc64f459641607d3a8dfb6a
min_split_gain	0.44545319958824425	52254688abc64f459641607d3a8dfb6a
num_leaves	101	52254688abc64f459641607d3a8dfb6a
random_state	42	52254688abc64f459641607d3a8dfb6a
reg_alpha	0.902844372129161	52254688abc64f459641607d3a8dfb6a
reg_lambda	7.872794666458144	52254688abc64f459641607d3a8dfb6a
subsample	0.6471856157936653	52254688abc64f459641607d3a8dfb6a
subsample_for_bin	200000	52254688abc64f459641607d3a8dfb6a
subsample_freq	0	52254688abc64f459641607d3a8dfb6a
metric	['None']	52254688abc64f459641607d3a8dfb6a
verbosity	-1	52254688abc64f459641607d3a8dfb6a
scale_pos_weight	18.783265030846266	52254688abc64f459641607d3a8dfb6a
objective	binary	52254688abc64f459641607d3a8dfb6a
num_threads	12	52254688abc64f459641607d3a8dfb6a
num_boost_round	1400	52254688abc64f459641607d3a8dfb6a
feature_name	auto	52254688abc64f459641607d3a8dfb6a
categorical_feature	auto	52254688abc64f459641607d3a8dfb6a
keep_training_booster	False	52254688abc64f459641607d3a8dfb6a
boosting_type	gbdt	7d976b24c40b49f396e96bc3fb05fd94
colsample_bytree	0.7634990783502911	7d976b24c40b49f396e96bc3fb05fd94
learning_rate	0.1261994467784223	7d976b24c40b49f396e96bc3fb05fd94
max_depth	7	7d976b24c40b49f396e96bc3fb05fd94
min_child_samples	53	7d976b24c40b49f396e96bc3fb05fd94
min_child_weight	0.001	7d976b24c40b49f396e96bc3fb05fd94
min_split_gain	0.18409669053588562	7d976b24c40b49f396e96bc3fb05fd94
num_leaves	33	7d976b24c40b49f396e96bc3fb05fd94
random_state	42	7d976b24c40b49f396e96bc3fb05fd94
reg_alpha	0.030211083470335114	7d976b24c40b49f396e96bc3fb05fd94
reg_lambda	5.731693508268391e-06	7d976b24c40b49f396e96bc3fb05fd94
subsample	0.7448166922390483	7d976b24c40b49f396e96bc3fb05fd94
subsample_for_bin	200000	7d976b24c40b49f396e96bc3fb05fd94
subsample_freq	0	7d976b24c40b49f396e96bc3fb05fd94
metric	['None']	7d976b24c40b49f396e96bc3fb05fd94
verbosity	-1	7d976b24c40b49f396e96bc3fb05fd94
scale_pos_weight	12.927587631985295	7d976b24c40b49f396e96bc3fb05fd94
objective	binary	7d976b24c40b49f396e96bc3fb05fd94
num_threads	12	7d976b24c40b49f396e96bc3fb05fd94
num_boost_round	400	7d976b24c40b49f396e96bc3fb05fd94
feature_name	auto	7d976b24c40b49f396e96bc3fb05fd94
categorical_feature	auto	7d976b24c40b49f396e96bc3fb05fd94
keep_training_booster	False	7d976b24c40b49f396e96bc3fb05fd94
boosting_type	gbdt	c30e3c7d28f94109946cce7fcb30cba5
colsample_bytree	0.5873461870299027	c30e3c7d28f94109946cce7fcb30cba5
learning_rate	0.021346606254132126	c30e3c7d28f94109946cce7fcb30cba5
max_depth	8	c30e3c7d28f94109946cce7fcb30cba5
min_child_samples	120	c30e3c7d28f94109946cce7fcb30cba5
min_child_weight	0.001	c30e3c7d28f94109946cce7fcb30cba5
min_split_gain	0.9248752616839189	c30e3c7d28f94109946cce7fcb30cba5
num_leaves	47	c30e3c7d28f94109946cce7fcb30cba5
random_state	42	c30e3c7d28f94109946cce7fcb30cba5
reg_alpha	1.667981296019169	c30e3c7d28f94109946cce7fcb30cba5
reg_lambda	5.493481260012609	c30e3c7d28f94109946cce7fcb30cba5
subsample	0.6632126410633059	c30e3c7d28f94109946cce7fcb30cba5
subsample_for_bin	200000	c30e3c7d28f94109946cce7fcb30cba5
subsample_freq	0	c30e3c7d28f94109946cce7fcb30cba5
metric	['None']	c30e3c7d28f94109946cce7fcb30cba5
verbosity	-1	c30e3c7d28f94109946cce7fcb30cba5
scale_pos_weight	20.89770905224029	c30e3c7d28f94109946cce7fcb30cba5
objective	binary	c30e3c7d28f94109946cce7fcb30cba5
num_threads	12	c30e3c7d28f94109946cce7fcb30cba5
num_boost_round	1500	c30e3c7d28f94109946cce7fcb30cba5
feature_name	auto	c30e3c7d28f94109946cce7fcb30cba5
categorical_feature	auto	c30e3c7d28f94109946cce7fcb30cba5
keep_training_booster	False	c30e3c7d28f94109946cce7fcb30cba5
boosting_type	gbdt	1bb7906f11194fa6b7498584acfcaac0
colsample_bytree	0.706704144474952	1bb7906f11194fa6b7498584acfcaac0
learning_rate	0.1888497478312666	1bb7906f11194fa6b7498584acfcaac0
max_depth	3	1bb7906f11194fa6b7498584acfcaac0
min_child_samples	10	1bb7906f11194fa6b7498584acfcaac0
min_child_weight	0.001	1bb7906f11194fa6b7498584acfcaac0
min_split_gain	0.31727261448302624	1bb7906f11194fa6b7498584acfcaac0
num_leaves	125	1bb7906f11194fa6b7498584acfcaac0
random_state	42	1bb7906f11194fa6b7498584acfcaac0
reg_alpha	0.10972420122952672	1bb7906f11194fa6b7498584acfcaac0
reg_lambda	1.3450870805904874e-06	1bb7906f11194fa6b7498584acfcaac0
subsample	0.6911022362243655	1bb7906f11194fa6b7498584acfcaac0
subsample_for_bin	200000	1bb7906f11194fa6b7498584acfcaac0
subsample_freq	0	1bb7906f11194fa6b7498584acfcaac0
metric	['None']	1bb7906f11194fa6b7498584acfcaac0
verbosity	-1	1bb7906f11194fa6b7498584acfcaac0
scale_pos_weight	10.005657493319507	1bb7906f11194fa6b7498584acfcaac0
objective	binary	1bb7906f11194fa6b7498584acfcaac0
num_threads	12	1bb7906f11194fa6b7498584acfcaac0
num_boost_round	800	1bb7906f11194fa6b7498584acfcaac0
feature_name	auto	1bb7906f11194fa6b7498584acfcaac0
categorical_feature	auto	1bb7906f11194fa6b7498584acfcaac0
keep_training_booster	False	1bb7906f11194fa6b7498584acfcaac0
boosting_type	gbdt	350e32e8aae5456fb766e828852e52f8
colsample_bytree	0.6024115909873102	350e32e8aae5456fb766e828852e52f8
learning_rate	0.12167265785399009	350e32e8aae5456fb766e828852e52f8
max_depth	4	350e32e8aae5456fb766e828852e52f8
min_child_samples	28	350e32e8aae5456fb766e828852e52f8
min_child_weight	0.001	350e32e8aae5456fb766e828852e52f8
min_split_gain	0.044869539889531435	350e32e8aae5456fb766e828852e52f8
num_leaves	58	350e32e8aae5456fb766e828852e52f8
random_state	42	350e32e8aae5456fb766e828852e52f8
reg_alpha	0.9198829192658928	350e32e8aae5456fb766e828852e52f8
reg_lambda	1.0850439363329438e-05	350e32e8aae5456fb766e828852e52f8
subsample	0.6236817978045375	350e32e8aae5456fb766e828852e52f8
subsample_for_bin	200000	350e32e8aae5456fb766e828852e52f8
subsample_freq	0	350e32e8aae5456fb766e828852e52f8
metric	['None']	350e32e8aae5456fb766e828852e52f8
verbosity	-1	350e32e8aae5456fb766e828852e52f8
scale_pos_weight	6.352576378273318	350e32e8aae5456fb766e828852e52f8
objective	binary	350e32e8aae5456fb766e828852e52f8
num_threads	12	350e32e8aae5456fb766e828852e52f8
num_boost_round	200	350e32e8aae5456fb766e828852e52f8
feature_name	auto	350e32e8aae5456fb766e828852e52f8
categorical_feature	auto	350e32e8aae5456fb766e828852e52f8
keep_training_booster	False	350e32e8aae5456fb766e828852e52f8
boosting_type	gbdt	5aa083ca632a4a3ba6f7762d0c339e85
colsample_bytree	0.551710539504788	5aa083ca632a4a3ba6f7762d0c339e85
learning_rate	0.04126943872785554	5aa083ca632a4a3ba6f7762d0c339e85
max_depth	3	5aa083ca632a4a3ba6f7762d0c339e85
min_child_samples	61	5aa083ca632a4a3ba6f7762d0c339e85
min_child_weight	0.001	5aa083ca632a4a3ba6f7762d0c339e85
min_split_gain	0.7991485157395222	5aa083ca632a4a3ba6f7762d0c339e85
num_leaves	55	5aa083ca632a4a3ba6f7762d0c339e85
random_state	42	5aa083ca632a4a3ba6f7762d0c339e85
reg_alpha	0.4670152517218261	5aa083ca632a4a3ba6f7762d0c339e85
reg_lambda	0.0695792198662603	5aa083ca632a4a3ba6f7762d0c339e85
subsample	0.6500878127806533	5aa083ca632a4a3ba6f7762d0c339e85
subsample_for_bin	200000	5aa083ca632a4a3ba6f7762d0c339e85
subsample_freq	0	5aa083ca632a4a3ba6f7762d0c339e85
metric	['None']	5aa083ca632a4a3ba6f7762d0c339e85
verbosity	-1	5aa083ca632a4a3ba6f7762d0c339e85
scale_pos_weight	21.544378234286793	5aa083ca632a4a3ba6f7762d0c339e85
objective	binary	5aa083ca632a4a3ba6f7762d0c339e85
num_threads	12	5aa083ca632a4a3ba6f7762d0c339e85
num_boost_round	1000	5aa083ca632a4a3ba6f7762d0c339e85
feature_name	auto	5aa083ca632a4a3ba6f7762d0c339e85
categorical_feature	auto	5aa083ca632a4a3ba6f7762d0c339e85
keep_training_booster	False	5aa083ca632a4a3ba6f7762d0c339e85
boosting_type	gbdt	2bc4f68109344e3d8099ec77369d61d3
colsample_bytree	0.538356078203797	2bc4f68109344e3d8099ec77369d61d3
learning_rate	0.007238913167113362	2bc4f68109344e3d8099ec77369d61d3
max_depth	6	2bc4f68109344e3d8099ec77369d61d3
min_child_samples	19	2bc4f68109344e3d8099ec77369d61d3
min_child_weight	0.001	2bc4f68109344e3d8099ec77369d61d3
min_split_gain	0.7933131924596051	2bc4f68109344e3d8099ec77369d61d3
num_leaves	57	2bc4f68109344e3d8099ec77369d61d3
random_state	42	2bc4f68109344e3d8099ec77369d61d3
reg_alpha	1.9146777834690751	2bc4f68109344e3d8099ec77369d61d3
reg_lambda	6.985311619230334	2bc4f68109344e3d8099ec77369d61d3
subsample	0.6979622184753436	2bc4f68109344e3d8099ec77369d61d3
subsample_for_bin	200000	2bc4f68109344e3d8099ec77369d61d3
subsample_freq	0	2bc4f68109344e3d8099ec77369d61d3
metric	['None']	2bc4f68109344e3d8099ec77369d61d3
verbosity	-1	2bc4f68109344e3d8099ec77369d61d3
scale_pos_weight	18.996746030543004	2bc4f68109344e3d8099ec77369d61d3
objective	binary	2bc4f68109344e3d8099ec77369d61d3
num_threads	12	2bc4f68109344e3d8099ec77369d61d3
num_boost_round	1300	2bc4f68109344e3d8099ec77369d61d3
feature_name	auto	2bc4f68109344e3d8099ec77369d61d3
categorical_feature	auto	2bc4f68109344e3d8099ec77369d61d3
keep_training_booster	False	2bc4f68109344e3d8099ec77369d61d3
boosting_type	gbdt	2715b04b5bad4a7ca933580943a2814a
colsample_bytree	0.5682552143096355	2715b04b5bad4a7ca933580943a2814a
boosting_type	gbdt	dfdba455d2f94583a9a6c822f573f830
colsample_bytree	0.7244930078488313	dfdba455d2f94583a9a6c822f573f830
learning_rate	0.11273266389270985	dfdba455d2f94583a9a6c822f573f830
max_depth	3	dfdba455d2f94583a9a6c822f573f830
min_child_samples	143	dfdba455d2f94583a9a6c822f573f830
min_child_weight	0.001	dfdba455d2f94583a9a6c822f573f830
min_split_gain	0.5129582309871092	dfdba455d2f94583a9a6c822f573f830
num_leaves	131	dfdba455d2f94583a9a6c822f573f830
random_state	42	dfdba455d2f94583a9a6c822f573f830
reg_alpha	3.0267774617190484	dfdba455d2f94583a9a6c822f573f830
reg_lambda	1.563786183646186e-05	dfdba455d2f94583a9a6c822f573f830
subsample	0.6968380294623591	dfdba455d2f94583a9a6c822f573f830
subsample_for_bin	200000	dfdba455d2f94583a9a6c822f573f830
subsample_freq	0	dfdba455d2f94583a9a6c822f573f830
metric	['None']	dfdba455d2f94583a9a6c822f573f830
verbosity	-1	dfdba455d2f94583a9a6c822f573f830
scale_pos_weight	12.078982806079727	dfdba455d2f94583a9a6c822f573f830
objective	binary	dfdba455d2f94583a9a6c822f573f830
num_threads	12	dfdba455d2f94583a9a6c822f573f830
num_boost_round	300	dfdba455d2f94583a9a6c822f573f830
feature_name	auto	dfdba455d2f94583a9a6c822f573f830
categorical_feature	auto	dfdba455d2f94583a9a6c822f573f830
keep_training_booster	False	dfdba455d2f94583a9a6c822f573f830
boosting_type	gbdt	993859e43a124bfbba2b2ebb47441c36
colsample_bytree	0.5663819176707715	993859e43a124bfbba2b2ebb47441c36
learning_rate	0.034074594553357276	993859e43a124bfbba2b2ebb47441c36
max_depth	7	993859e43a124bfbba2b2ebb47441c36
min_child_samples	181	993859e43a124bfbba2b2ebb47441c36
min_child_weight	0.001	993859e43a124bfbba2b2ebb47441c36
min_split_gain	0.5695666816709969	993859e43a124bfbba2b2ebb47441c36
num_leaves	73	993859e43a124bfbba2b2ebb47441c36
random_state	42	993859e43a124bfbba2b2ebb47441c36
reg_alpha	0.0005451992123428715	993859e43a124bfbba2b2ebb47441c36
reg_lambda	0.023934707530452255	993859e43a124bfbba2b2ebb47441c36
subsample	0.6191943836066558	993859e43a124bfbba2b2ebb47441c36
subsample_for_bin	200000	993859e43a124bfbba2b2ebb47441c36
subsample_freq	0	993859e43a124bfbba2b2ebb47441c36
metric	['None']	993859e43a124bfbba2b2ebb47441c36
verbosity	-1	993859e43a124bfbba2b2ebb47441c36
scale_pos_weight	15.042098798225815	993859e43a124bfbba2b2ebb47441c36
objective	binary	993859e43a124bfbba2b2ebb47441c36
num_threads	12	993859e43a124bfbba2b2ebb47441c36
num_boost_round	2000	993859e43a124bfbba2b2ebb47441c36
feature_name	auto	993859e43a124bfbba2b2ebb47441c36
categorical_feature	auto	993859e43a124bfbba2b2ebb47441c36
keep_training_booster	False	993859e43a124bfbba2b2ebb47441c36
boosting_type	gbdt	621e30a66f4f4f2c9e8e5d2e3d26b6f9
colsample_bytree	0.5489883068868612	621e30a66f4f4f2c9e8e5d2e3d26b6f9
learning_rate	0.1805317892191556	621e30a66f4f4f2c9e8e5d2e3d26b6f9
max_depth	6	621e30a66f4f4f2c9e8e5d2e3d26b6f9
min_child_samples	86	621e30a66f4f4f2c9e8e5d2e3d26b6f9
min_child_weight	0.001	621e30a66f4f4f2c9e8e5d2e3d26b6f9
min_split_gain	0.3878471790677668	621e30a66f4f4f2c9e8e5d2e3d26b6f9
num_leaves	84	621e30a66f4f4f2c9e8e5d2e3d26b6f9
random_state	42	621e30a66f4f4f2c9e8e5d2e3d26b6f9
reg_alpha	0.0005936465031381338	621e30a66f4f4f2c9e8e5d2e3d26b6f9
reg_lambda	0.00014894124233600818	621e30a66f4f4f2c9e8e5d2e3d26b6f9
subsample	0.7848195420365872	621e30a66f4f4f2c9e8e5d2e3d26b6f9
subsample_for_bin	200000	621e30a66f4f4f2c9e8e5d2e3d26b6f9
subsample_freq	0	621e30a66f4f4f2c9e8e5d2e3d26b6f9
metric	['None']	621e30a66f4f4f2c9e8e5d2e3d26b6f9
verbosity	-1	621e30a66f4f4f2c9e8e5d2e3d26b6f9
scale_pos_weight	13.239448789104845	621e30a66f4f4f2c9e8e5d2e3d26b6f9
objective	binary	621e30a66f4f4f2c9e8e5d2e3d26b6f9
num_threads	12	621e30a66f4f4f2c9e8e5d2e3d26b6f9
num_boost_round	400	621e30a66f4f4f2c9e8e5d2e3d26b6f9
feature_name	auto	621e30a66f4f4f2c9e8e5d2e3d26b6f9
categorical_feature	auto	621e30a66f4f4f2c9e8e5d2e3d26b6f9
keep_training_booster	False	621e30a66f4f4f2c9e8e5d2e3d26b6f9
boosting_type	gbdt	b49827a8551c45039120e727c2742f3c
colsample_bytree	0.6588625816396239	b49827a8551c45039120e727c2742f3c
learning_rate	0.07285249713960873	b49827a8551c45039120e727c2742f3c
max_depth	5	b49827a8551c45039120e727c2742f3c
min_child_samples	150	b49827a8551c45039120e727c2742f3c
min_child_weight	0.001	b49827a8551c45039120e727c2742f3c
min_split_gain	0.14577678942913763	b49827a8551c45039120e727c2742f3c
num_leaves	108	b49827a8551c45039120e727c2742f3c
random_state	42	b49827a8551c45039120e727c2742f3c
reg_alpha	5.534232260437328	b49827a8551c45039120e727c2742f3c
reg_lambda	0.0015208931631418596	b49827a8551c45039120e727c2742f3c
subsample	0.7825850283553379	b49827a8551c45039120e727c2742f3c
subsample_for_bin	200000	b49827a8551c45039120e727c2742f3c
subsample_freq	0	b49827a8551c45039120e727c2742f3c
metric	['None']	b49827a8551c45039120e727c2742f3c
verbosity	-1	b49827a8551c45039120e727c2742f3c
scale_pos_weight	6.110861848446735	b49827a8551c45039120e727c2742f3c
objective	binary	b49827a8551c45039120e727c2742f3c
num_threads	12	b49827a8551c45039120e727c2742f3c
num_boost_round	300	b49827a8551c45039120e727c2742f3c
feature_name	auto	b49827a8551c45039120e727c2742f3c
categorical_feature	auto	b49827a8551c45039120e727c2742f3c
keep_training_booster	False	b49827a8551c45039120e727c2742f3c
learning_rate	0.018585016146974484	2715b04b5bad4a7ca933580943a2814a
max_depth	9	2715b04b5bad4a7ca933580943a2814a
min_child_samples	170	2715b04b5bad4a7ca933580943a2814a
min_child_weight	0.001	2715b04b5bad4a7ca933580943a2814a
min_split_gain	0.6424160860823234	2715b04b5bad4a7ca933580943a2814a
num_leaves	142	2715b04b5bad4a7ca933580943a2814a
random_state	42	2715b04b5bad4a7ca933580943a2814a
reg_alpha	5.491898123113631	2715b04b5bad4a7ca933580943a2814a
reg_lambda	0.4575233116807033	2715b04b5bad4a7ca933580943a2814a
subsample	0.6992262672398903	2715b04b5bad4a7ca933580943a2814a
subsample_for_bin	200000	2715b04b5bad4a7ca933580943a2814a
subsample_freq	0	2715b04b5bad4a7ca933580943a2814a
metric	['None']	2715b04b5bad4a7ca933580943a2814a
verbosity	-1	2715b04b5bad4a7ca933580943a2814a
scale_pos_weight	16.200146128823665	2715b04b5bad4a7ca933580943a2814a
objective	binary	2715b04b5bad4a7ca933580943a2814a
num_threads	12	2715b04b5bad4a7ca933580943a2814a
num_boost_round	1000	2715b04b5bad4a7ca933580943a2814a
feature_name	auto	2715b04b5bad4a7ca933580943a2814a
categorical_feature	auto	2715b04b5bad4a7ca933580943a2814a
keep_training_booster	False	2715b04b5bad4a7ca933580943a2814a
boosting_type	gbdt	d8b6ad6854ce4c91948c621ba3b09130
colsample_bytree	0.6365145724444983	d8b6ad6854ce4c91948c621ba3b09130
learning_rate	0.00913498379656048	d8b6ad6854ce4c91948c621ba3b09130
max_depth	8	d8b6ad6854ce4c91948c621ba3b09130
min_child_samples	149	d8b6ad6854ce4c91948c621ba3b09130
min_child_weight	0.001	d8b6ad6854ce4c91948c621ba3b09130
min_split_gain	0.601043444599279	d8b6ad6854ce4c91948c621ba3b09130
num_leaves	100	d8b6ad6854ce4c91948c621ba3b09130
random_state	42	d8b6ad6854ce4c91948c621ba3b09130
reg_alpha	4.868863356095848	d8b6ad6854ce4c91948c621ba3b09130
reg_lambda	0.3208609569956594	d8b6ad6854ce4c91948c621ba3b09130
subsample	0.6232519283147646	d8b6ad6854ce4c91948c621ba3b09130
subsample_for_bin	200000	d8b6ad6854ce4c91948c621ba3b09130
subsample_freq	0	d8b6ad6854ce4c91948c621ba3b09130
metric	['None']	d8b6ad6854ce4c91948c621ba3b09130
verbosity	-1	d8b6ad6854ce4c91948c621ba3b09130
scale_pos_weight	15.728938240351576	d8b6ad6854ce4c91948c621ba3b09130
objective	binary	d8b6ad6854ce4c91948c621ba3b09130
num_threads	12	d8b6ad6854ce4c91948c621ba3b09130
num_boost_round	2000	d8b6ad6854ce4c91948c621ba3b09130
feature_name	auto	d8b6ad6854ce4c91948c621ba3b09130
categorical_feature	auto	d8b6ad6854ce4c91948c621ba3b09130
keep_training_booster	False	d8b6ad6854ce4c91948c621ba3b09130
boosting_type	gbdt	b4b583974c19441a99bf1809f32d97ac
colsample_bytree	0.564292259346312	b4b583974c19441a99bf1809f32d97ac
learning_rate	0.011577263427778775	b4b583974c19441a99bf1809f32d97ac
max_depth	9	b4b583974c19441a99bf1809f32d97ac
min_child_samples	195	b4b583974c19441a99bf1809f32d97ac
min_child_weight	0.001	b4b583974c19441a99bf1809f32d97ac
min_split_gain	0.958925552774792	b4b583974c19441a99bf1809f32d97ac
num_leaves	53	b4b583974c19441a99bf1809f32d97ac
random_state	42	b4b583974c19441a99bf1809f32d97ac
reg_alpha	0.9281870637828892	b4b583974c19441a99bf1809f32d97ac
reg_lambda	0.0026280061745596133	b4b583974c19441a99bf1809f32d97ac
subsample	0.626445924986861	b4b583974c19441a99bf1809f32d97ac
subsample_for_bin	200000	b4b583974c19441a99bf1809f32d97ac
subsample_freq	0	b4b583974c19441a99bf1809f32d97ac
metric	['None']	b4b583974c19441a99bf1809f32d97ac
verbosity	-1	b4b583974c19441a99bf1809f32d97ac
scale_pos_weight	8.164341553194664	b4b583974c19441a99bf1809f32d97ac
objective	binary	b4b583974c19441a99bf1809f32d97ac
num_threads	12	b4b583974c19441a99bf1809f32d97ac
num_boost_round	1800	b4b583974c19441a99bf1809f32d97ac
feature_name	auto	b4b583974c19441a99bf1809f32d97ac
categorical_feature	auto	b4b583974c19441a99bf1809f32d97ac
keep_training_booster	False	b4b583974c19441a99bf1809f32d97ac
boosting_type	gbdt	a83392e9cd7a4265b05f9abeced43638
colsample_bytree	0.519804528224078	a83392e9cd7a4265b05f9abeced43638
learning_rate	0.009996277981878073	a83392e9cd7a4265b05f9abeced43638
max_depth	10	a83392e9cd7a4265b05f9abeced43638
min_child_samples	152	a83392e9cd7a4265b05f9abeced43638
min_child_weight	0.001	a83392e9cd7a4265b05f9abeced43638
min_split_gain	0.9729919748187932	a83392e9cd7a4265b05f9abeced43638
num_leaves	63	a83392e9cd7a4265b05f9abeced43638
random_state	42	a83392e9cd7a4265b05f9abeced43638
reg_alpha	0.04451369071907941	a83392e9cd7a4265b05f9abeced43638
reg_lambda	0.000541908056243735	a83392e9cd7a4265b05f9abeced43638
subsample	0.7721501592597411	a83392e9cd7a4265b05f9abeced43638
subsample_for_bin	200000	a83392e9cd7a4265b05f9abeced43638
subsample_freq	0	a83392e9cd7a4265b05f9abeced43638
metric	['None']	a83392e9cd7a4265b05f9abeced43638
verbosity	-1	a83392e9cd7a4265b05f9abeced43638
scale_pos_weight	7.006230393101542	a83392e9cd7a4265b05f9abeced43638
objective	binary	a83392e9cd7a4265b05f9abeced43638
num_threads	12	a83392e9cd7a4265b05f9abeced43638
num_boost_round	2000	a83392e9cd7a4265b05f9abeced43638
feature_name	auto	a83392e9cd7a4265b05f9abeced43638
categorical_feature	auto	a83392e9cd7a4265b05f9abeced43638
keep_training_booster	False	a83392e9cd7a4265b05f9abeced43638
boosting_type	gbdt	e465ea368468417f95c02d9736ea13d2
colsample_bytree	0.7188872864077105	e465ea368468417f95c02d9736ea13d2
learning_rate	0.021013855544428372	e465ea368468417f95c02d9736ea13d2
boosting_type	gbdt	b7b0e8f2158c4888aa058c14df7a1439
colsample_bytree	0.5429473827223538	b7b0e8f2158c4888aa058c14df7a1439
learning_rate	0.011560160341903061	b7b0e8f2158c4888aa058c14df7a1439
max_depth	7	b7b0e8f2158c4888aa058c14df7a1439
min_child_samples	132	b7b0e8f2158c4888aa058c14df7a1439
min_child_weight	0.001	b7b0e8f2158c4888aa058c14df7a1439
min_split_gain	0.5441380890127447	b7b0e8f2158c4888aa058c14df7a1439
num_leaves	29	b7b0e8f2158c4888aa058c14df7a1439
random_state	42	b7b0e8f2158c4888aa058c14df7a1439
reg_alpha	2.762323282221408	b7b0e8f2158c4888aa058c14df7a1439
reg_lambda	0.0017187530595080176	b7b0e8f2158c4888aa058c14df7a1439
subsample	0.6006432996628117	b7b0e8f2158c4888aa058c14df7a1439
subsample_for_bin	200000	b7b0e8f2158c4888aa058c14df7a1439
subsample_freq	0	b7b0e8f2158c4888aa058c14df7a1439
metric	['None']	b7b0e8f2158c4888aa058c14df7a1439
verbosity	-1	b7b0e8f2158c4888aa058c14df7a1439
scale_pos_weight	17.84295687691639	b7b0e8f2158c4888aa058c14df7a1439
objective	binary	b7b0e8f2158c4888aa058c14df7a1439
num_threads	12	b7b0e8f2158c4888aa058c14df7a1439
num_boost_round	1300	b7b0e8f2158c4888aa058c14df7a1439
feature_name	auto	b7b0e8f2158c4888aa058c14df7a1439
categorical_feature	auto	b7b0e8f2158c4888aa058c14df7a1439
keep_training_booster	False	b7b0e8f2158c4888aa058c14df7a1439
boosting_type	gbdt	308716eedad140d8b8c2c920a5203a28
colsample_bytree	0.6839973726321618	308716eedad140d8b8c2c920a5203a28
learning_rate	0.013627551500172263	308716eedad140d8b8c2c920a5203a28
max_depth	8	308716eedad140d8b8c2c920a5203a28
min_child_samples	158	308716eedad140d8b8c2c920a5203a28
min_child_weight	0.001	308716eedad140d8b8c2c920a5203a28
min_split_gain	0.790505586135446	308716eedad140d8b8c2c920a5203a28
num_leaves	86	308716eedad140d8b8c2c920a5203a28
random_state	42	308716eedad140d8b8c2c920a5203a28
reg_alpha	8.230274912935192	308716eedad140d8b8c2c920a5203a28
reg_lambda	0.6841391373443207	308716eedad140d8b8c2c920a5203a28
subsample	0.7812222058400381	308716eedad140d8b8c2c920a5203a28
subsample_for_bin	200000	308716eedad140d8b8c2c920a5203a28
subsample_freq	0	308716eedad140d8b8c2c920a5203a28
metric	['None']	308716eedad140d8b8c2c920a5203a28
verbosity	-1	308716eedad140d8b8c2c920a5203a28
scale_pos_weight	6.499268157524451	308716eedad140d8b8c2c920a5203a28
objective	binary	308716eedad140d8b8c2c920a5203a28
num_threads	12	308716eedad140d8b8c2c920a5203a28
num_boost_round	1600	308716eedad140d8b8c2c920a5203a28
feature_name	auto	308716eedad140d8b8c2c920a5203a28
categorical_feature	auto	308716eedad140d8b8c2c920a5203a28
keep_training_booster	False	308716eedad140d8b8c2c920a5203a28
learning_rate	0.021439594787690596	5271cb97dc8e4421816e4fbc4e06b329
max_depth	9	5271cb97dc8e4421816e4fbc4e06b329
min_child_samples	141	5271cb97dc8e4421816e4fbc4e06b329
min_child_weight	0.001	5271cb97dc8e4421816e4fbc4e06b329
min_split_gain	0.9449186276616703	5271cb97dc8e4421816e4fbc4e06b329
num_leaves	21	5271cb97dc8e4421816e4fbc4e06b329
random_state	42	5271cb97dc8e4421816e4fbc4e06b329
reg_alpha	0.04016242866099254	5271cb97dc8e4421816e4fbc4e06b329
reg_lambda	2.01287079783129e-05	5271cb97dc8e4421816e4fbc4e06b329
subsample	0.770105069807001	5271cb97dc8e4421816e4fbc4e06b329
subsample_for_bin	200000	5271cb97dc8e4421816e4fbc4e06b329
subsample_freq	0	5271cb97dc8e4421816e4fbc4e06b329
metric	['None']	5271cb97dc8e4421816e4fbc4e06b329
verbosity	-1	5271cb97dc8e4421816e4fbc4e06b329
scale_pos_weight	9.98094208319898	5271cb97dc8e4421816e4fbc4e06b329
objective	binary	5271cb97dc8e4421816e4fbc4e06b329
num_threads	12	5271cb97dc8e4421816e4fbc4e06b329
num_boost_round	1900	5271cb97dc8e4421816e4fbc4e06b329
feature_name	auto	5271cb97dc8e4421816e4fbc4e06b329
categorical_feature	auto	5271cb97dc8e4421816e4fbc4e06b329
keep_training_booster	False	5271cb97dc8e4421816e4fbc4e06b329
boosting_type	gbdt	193b290a18504fa8a42991b624278dbf
colsample_bytree	0.5053522405554715	193b290a18504fa8a42991b624278dbf
learning_rate	0.006956636523336151	193b290a18504fa8a42991b624278dbf
max_depth	10	193b290a18504fa8a42991b624278dbf
min_child_samples	145	193b290a18504fa8a42991b624278dbf
min_child_weight	0.001	193b290a18504fa8a42991b624278dbf
min_split_gain	0.761725514169032	193b290a18504fa8a42991b624278dbf
num_leaves	133	193b290a18504fa8a42991b624278dbf
random_state	42	193b290a18504fa8a42991b624278dbf
reg_alpha	0.7267534828377916	193b290a18504fa8a42991b624278dbf
reg_lambda	0.0005017782266484109	193b290a18504fa8a42991b624278dbf
subsample	0.7821650044149895	193b290a18504fa8a42991b624278dbf
subsample_for_bin	200000	193b290a18504fa8a42991b624278dbf
subsample_freq	0	193b290a18504fa8a42991b624278dbf
metric	['None']	193b290a18504fa8a42991b624278dbf
verbosity	-1	193b290a18504fa8a42991b624278dbf
scale_pos_weight	7.938136460399286	193b290a18504fa8a42991b624278dbf
objective	binary	193b290a18504fa8a42991b624278dbf
num_threads	12	193b290a18504fa8a42991b624278dbf
num_boost_round	1900	193b290a18504fa8a42991b624278dbf
feature_name	auto	193b290a18504fa8a42991b624278dbf
categorical_feature	auto	193b290a18504fa8a42991b624278dbf
keep_training_booster	False	193b290a18504fa8a42991b624278dbf
boosting_type	gbdt	384089aee8ff469e884eb523460d2e23
colsample_bytree	0.7926619728229696	384089aee8ff469e884eb523460d2e23
boosting_type	gbdt	95bce22e5e554d8298e264b28c9e8fc5
colsample_bytree	0.5422123262073374	95bce22e5e554d8298e264b28c9e8fc5
learning_rate	0.014017554361306604	95bce22e5e554d8298e264b28c9e8fc5
max_depth	6	95bce22e5e554d8298e264b28c9e8fc5
min_child_samples	106	95bce22e5e554d8298e264b28c9e8fc5
min_child_weight	0.001	95bce22e5e554d8298e264b28c9e8fc5
min_split_gain	0.9342666867151753	95bce22e5e554d8298e264b28c9e8fc5
num_leaves	89	95bce22e5e554d8298e264b28c9e8fc5
random_state	42	95bce22e5e554d8298e264b28c9e8fc5
reg_alpha	0.8918445590981444	95bce22e5e554d8298e264b28c9e8fc5
reg_lambda	0.03350387194258371	95bce22e5e554d8298e264b28c9e8fc5
subsample	0.7063524812159057	95bce22e5e554d8298e264b28c9e8fc5
subsample_for_bin	200000	95bce22e5e554d8298e264b28c9e8fc5
subsample_freq	0	95bce22e5e554d8298e264b28c9e8fc5
metric	['None']	95bce22e5e554d8298e264b28c9e8fc5
verbosity	-1	95bce22e5e554d8298e264b28c9e8fc5
scale_pos_weight	22.0067876938087	95bce22e5e554d8298e264b28c9e8fc5
objective	binary	95bce22e5e554d8298e264b28c9e8fc5
num_threads	12	95bce22e5e554d8298e264b28c9e8fc5
num_boost_round	900	95bce22e5e554d8298e264b28c9e8fc5
feature_name	auto	95bce22e5e554d8298e264b28c9e8fc5
categorical_feature	auto	95bce22e5e554d8298e264b28c9e8fc5
keep_training_booster	False	95bce22e5e554d8298e264b28c9e8fc5
boosting_type	gbdt	bc449f79816a40b389ab2d1898b1b8f4
colsample_bytree	0.5285451174029698	bc449f79816a40b389ab2d1898b1b8f4
learning_rate	0.020003224465058513	bc449f79816a40b389ab2d1898b1b8f4
max_depth	11	bc449f79816a40b389ab2d1898b1b8f4
min_child_samples	112	bc449f79816a40b389ab2d1898b1b8f4
min_child_weight	0.001	bc449f79816a40b389ab2d1898b1b8f4
min_split_gain	0.9352604684002743	bc449f79816a40b389ab2d1898b1b8f4
num_leaves	144	bc449f79816a40b389ab2d1898b1b8f4
random_state	42	bc449f79816a40b389ab2d1898b1b8f4
reg_alpha	0.5433418554425958	bc449f79816a40b389ab2d1898b1b8f4
reg_lambda	8.602189114778029e-05	bc449f79816a40b389ab2d1898b1b8f4
subsample	0.7001172213949027	bc449f79816a40b389ab2d1898b1b8f4
subsample_for_bin	200000	bc449f79816a40b389ab2d1898b1b8f4
subsample_freq	0	bc449f79816a40b389ab2d1898b1b8f4
metric	['None']	bc449f79816a40b389ab2d1898b1b8f4
verbosity	-1	bc449f79816a40b389ab2d1898b1b8f4
scale_pos_weight	12.779652827331496	bc449f79816a40b389ab2d1898b1b8f4
objective	binary	bc449f79816a40b389ab2d1898b1b8f4
num_threads	12	bc449f79816a40b389ab2d1898b1b8f4
num_boost_round	1700	bc449f79816a40b389ab2d1898b1b8f4
feature_name	auto	bc449f79816a40b389ab2d1898b1b8f4
categorical_feature	auto	bc449f79816a40b389ab2d1898b1b8f4
keep_training_booster	False	bc449f79816a40b389ab2d1898b1b8f4
boosting_type	gbdt	9c030b074f6740f7b9f76b2dddeffb8c
colsample_bytree	0.653729189855531	9c030b074f6740f7b9f76b2dddeffb8c
learning_rate	0.009583924220182585	9c030b074f6740f7b9f76b2dddeffb8c
max_depth	7	9c030b074f6740f7b9f76b2dddeffb8c
min_child_samples	179	9c030b074f6740f7b9f76b2dddeffb8c
min_child_weight	0.001	9c030b074f6740f7b9f76b2dddeffb8c
min_split_gain	0.7435756164510439	9c030b074f6740f7b9f76b2dddeffb8c
num_leaves	62	9c030b074f6740f7b9f76b2dddeffb8c
random_state	42	9c030b074f6740f7b9f76b2dddeffb8c
reg_alpha	3.9167947182799785	9c030b074f6740f7b9f76b2dddeffb8c
reg_lambda	0.1551187602419573	9c030b074f6740f7b9f76b2dddeffb8c
subsample	0.6059751290810297	9c030b074f6740f7b9f76b2dddeffb8c
subsample_for_bin	200000	9c030b074f6740f7b9f76b2dddeffb8c
subsample_freq	0	9c030b074f6740f7b9f76b2dddeffb8c
metric	['None']	9c030b074f6740f7b9f76b2dddeffb8c
verbosity	-1	9c030b074f6740f7b9f76b2dddeffb8c
scale_pos_weight	7.811796637479143	9c030b074f6740f7b9f76b2dddeffb8c
objective	binary	9c030b074f6740f7b9f76b2dddeffb8c
num_threads	12	9c030b074f6740f7b9f76b2dddeffb8c
num_boost_round	800	9c030b074f6740f7b9f76b2dddeffb8c
feature_name	auto	9c030b074f6740f7b9f76b2dddeffb8c
categorical_feature	auto	9c030b074f6740f7b9f76b2dddeffb8c
keep_training_booster	False	9c030b074f6740f7b9f76b2dddeffb8c
learning_rate	0.012294409268766269	384089aee8ff469e884eb523460d2e23
max_depth	8	384089aee8ff469e884eb523460d2e23
min_child_samples	197	384089aee8ff469e884eb523460d2e23
min_child_weight	0.001	384089aee8ff469e884eb523460d2e23
min_split_gain	0.7524065032252609	384089aee8ff469e884eb523460d2e23
num_leaves	55	384089aee8ff469e884eb523460d2e23
random_state	42	384089aee8ff469e884eb523460d2e23
reg_alpha	2.4826609730085605	384089aee8ff469e884eb523460d2e23
reg_lambda	5.920699718825093e-06	384089aee8ff469e884eb523460d2e23
subsample	0.7850705147744741	384089aee8ff469e884eb523460d2e23
subsample_for_bin	200000	384089aee8ff469e884eb523460d2e23
subsample_freq	0	384089aee8ff469e884eb523460d2e23
metric	['None']	384089aee8ff469e884eb523460d2e23
verbosity	-1	384089aee8ff469e884eb523460d2e23
scale_pos_weight	6.7540810017566075	384089aee8ff469e884eb523460d2e23
objective	binary	384089aee8ff469e884eb523460d2e23
num_threads	12	384089aee8ff469e884eb523460d2e23
num_boost_round	1900	384089aee8ff469e884eb523460d2e23
feature_name	auto	384089aee8ff469e884eb523460d2e23
categorical_feature	auto	384089aee8ff469e884eb523460d2e23
keep_training_booster	False	384089aee8ff469e884eb523460d2e23
boosting_type	gbdt	ea05524904e94189b607f30d35114cf5
colsample_bytree	0.5213602568096799	ea05524904e94189b607f30d35114cf5
learning_rate	0.02142983794315545	ea05524904e94189b607f30d35114cf5
boosting_type	gbdt	0b2d11961fe2427d959a976e2033ca2e
colsample_bytree	0.7038312838648472	0b2d11961fe2427d959a976e2033ca2e
learning_rate	0.005175976015285142	0b2d11961fe2427d959a976e2033ca2e
max_depth	11	0b2d11961fe2427d959a976e2033ca2e
min_child_samples	149	0b2d11961fe2427d959a976e2033ca2e
min_child_weight	0.001	0b2d11961fe2427d959a976e2033ca2e
min_split_gain	0.9737764411341876	0b2d11961fe2427d959a976e2033ca2e
num_leaves	101	0b2d11961fe2427d959a976e2033ca2e
random_state	42	0b2d11961fe2427d959a976e2033ca2e
reg_alpha	5.435551106522063	0b2d11961fe2427d959a976e2033ca2e
reg_lambda	1.6985219510373455e-05	0b2d11961fe2427d959a976e2033ca2e
subsample	0.6653175229926603	0b2d11961fe2427d959a976e2033ca2e
subsample_for_bin	200000	0b2d11961fe2427d959a976e2033ca2e
subsample_freq	0	0b2d11961fe2427d959a976e2033ca2e
metric	['None']	0b2d11961fe2427d959a976e2033ca2e
verbosity	-1	0b2d11961fe2427d959a976e2033ca2e
scale_pos_weight	21.33461652946667	0b2d11961fe2427d959a976e2033ca2e
objective	binary	0b2d11961fe2427d959a976e2033ca2e
num_threads	12	0b2d11961fe2427d959a976e2033ca2e
num_boost_round	2000	0b2d11961fe2427d959a976e2033ca2e
feature_name	auto	0b2d11961fe2427d959a976e2033ca2e
categorical_feature	auto	0b2d11961fe2427d959a976e2033ca2e
keep_training_booster	False	0b2d11961fe2427d959a976e2033ca2e
boosting_type	gbdt	bbf38d0761d14a96a7f6af68d83b297c
colsample_bytree	0.5285311866449302	bbf38d0761d14a96a7f6af68d83b297c
learning_rate	0.01657199162187146	bbf38d0761d14a96a7f6af68d83b297c
max_depth	11	bbf38d0761d14a96a7f6af68d83b297c
min_child_samples	141	bbf38d0761d14a96a7f6af68d83b297c
min_child_weight	0.001	bbf38d0761d14a96a7f6af68d83b297c
min_split_gain	0.9525557587637858	bbf38d0761d14a96a7f6af68d83b297c
num_leaves	37	bbf38d0761d14a96a7f6af68d83b297c
random_state	42	bbf38d0761d14a96a7f6af68d83b297c
reg_alpha	0.10662424317727932	bbf38d0761d14a96a7f6af68d83b297c
reg_lambda	0.0031350434684262263	bbf38d0761d14a96a7f6af68d83b297c
subsample	0.8003727037304308	bbf38d0761d14a96a7f6af68d83b297c
subsample_for_bin	200000	bbf38d0761d14a96a7f6af68d83b297c
subsample_freq	0	bbf38d0761d14a96a7f6af68d83b297c
metric	['None']	bbf38d0761d14a96a7f6af68d83b297c
verbosity	-1	bbf38d0761d14a96a7f6af68d83b297c
scale_pos_weight	8.447276080788637	bbf38d0761d14a96a7f6af68d83b297c
objective	binary	bbf38d0761d14a96a7f6af68d83b297c
num_threads	12	bbf38d0761d14a96a7f6af68d83b297c
num_boost_round	1700	bbf38d0761d14a96a7f6af68d83b297c
feature_name	auto	bbf38d0761d14a96a7f6af68d83b297c
categorical_feature	auto	bbf38d0761d14a96a7f6af68d83b297c
keep_training_booster	False	bbf38d0761d14a96a7f6af68d83b297c
max_depth	7	ea05524904e94189b607f30d35114cf5
min_child_samples	126	ea05524904e94189b607f30d35114cf5
min_child_weight	0.001	ea05524904e94189b607f30d35114cf5
min_split_gain	0.8946879226903186	ea05524904e94189b607f30d35114cf5
num_leaves	84	ea05524904e94189b607f30d35114cf5
random_state	42	ea05524904e94189b607f30d35114cf5
reg_alpha	0.01596724667983096	ea05524904e94189b607f30d35114cf5
reg_lambda	1.640283234709612e-06	ea05524904e94189b607f30d35114cf5
subsample	0.9783389979059883	ea05524904e94189b607f30d35114cf5
subsample_for_bin	200000	ea05524904e94189b607f30d35114cf5
subsample_freq	0	ea05524904e94189b607f30d35114cf5
metric	['None']	ea05524904e94189b607f30d35114cf5
verbosity	-1	ea05524904e94189b607f30d35114cf5
scale_pos_weight	10.410156330832425	ea05524904e94189b607f30d35114cf5
objective	binary	ea05524904e94189b607f30d35114cf5
num_threads	12	ea05524904e94189b607f30d35114cf5
num_boost_round	1800	ea05524904e94189b607f30d35114cf5
feature_name	auto	ea05524904e94189b607f30d35114cf5
categorical_feature	auto	ea05524904e94189b607f30d35114cf5
keep_training_booster	False	ea05524904e94189b607f30d35114cf5
categorical_feature	auto	143106f491a142fa98764b4036346fc5
keep_training_booster	False	143106f491a142fa98764b4036346fc5
boosting_type	gbdt	5098e5701fc04d33a5d78ff3e0c2d8f2
colsample_bytree	0.6420813928536784	5098e5701fc04d33a5d78ff3e0c2d8f2
learning_rate	0.014540359388872904	5098e5701fc04d33a5d78ff3e0c2d8f2
max_depth	12	5098e5701fc04d33a5d78ff3e0c2d8f2
min_child_samples	144	5098e5701fc04d33a5d78ff3e0c2d8f2
min_child_weight	0.001	5098e5701fc04d33a5d78ff3e0c2d8f2
min_split_gain	0.9368026484361918	5098e5701fc04d33a5d78ff3e0c2d8f2
num_leaves	62	5098e5701fc04d33a5d78ff3e0c2d8f2
random_state	42	5098e5701fc04d33a5d78ff3e0c2d8f2
reg_alpha	1.8814770991435485	5098e5701fc04d33a5d78ff3e0c2d8f2
reg_lambda	0.00023636417661046115	5098e5701fc04d33a5d78ff3e0c2d8f2
subsample	0.9053402634333482	5098e5701fc04d33a5d78ff3e0c2d8f2
subsample_for_bin	200000	5098e5701fc04d33a5d78ff3e0c2d8f2
subsample_freq	0	5098e5701fc04d33a5d78ff3e0c2d8f2
metric	['None']	5098e5701fc04d33a5d78ff3e0c2d8f2
verbosity	-1	5098e5701fc04d33a5d78ff3e0c2d8f2
scale_pos_weight	10.732528767586551	5098e5701fc04d33a5d78ff3e0c2d8f2
objective	binary	5098e5701fc04d33a5d78ff3e0c2d8f2
num_threads	12	5098e5701fc04d33a5d78ff3e0c2d8f2
num_boost_round	1800	5098e5701fc04d33a5d78ff3e0c2d8f2
feature_name	auto	5098e5701fc04d33a5d78ff3e0c2d8f2
categorical_feature	auto	5098e5701fc04d33a5d78ff3e0c2d8f2
keep_training_booster	False	5098e5701fc04d33a5d78ff3e0c2d8f2
min_child_samples	126	0b4fd1f6f7d84dfe891162a68110faa4
min_child_weight	0.001	0b4fd1f6f7d84dfe891162a68110faa4
boosting_type	gbdt	000523ae15fd47739ed9fccc383746ef
colsample_bytree	0.578518690977603	000523ae15fd47739ed9fccc383746ef
learning_rate	0.009494579594625512	000523ae15fd47739ed9fccc383746ef
max_depth	9	000523ae15fd47739ed9fccc383746ef
min_child_samples	173	000523ae15fd47739ed9fccc383746ef
min_child_weight	0.001	000523ae15fd47739ed9fccc383746ef
min_split_gain	0.9444465697119552	000523ae15fd47739ed9fccc383746ef
num_leaves	41	000523ae15fd47739ed9fccc383746ef
random_state	42	000523ae15fd47739ed9fccc383746ef
reg_alpha	6.637436512588276	000523ae15fd47739ed9fccc383746ef
reg_lambda	3.337739166698195	000523ae15fd47739ed9fccc383746ef
subsample	0.64558258492716	000523ae15fd47739ed9fccc383746ef
subsample_for_bin	200000	000523ae15fd47739ed9fccc383746ef
subsample_freq	0	000523ae15fd47739ed9fccc383746ef
metric	['None']	000523ae15fd47739ed9fccc383746ef
verbosity	-1	000523ae15fd47739ed9fccc383746ef
scale_pos_weight	8.7721136712784	000523ae15fd47739ed9fccc383746ef
objective	binary	000523ae15fd47739ed9fccc383746ef
num_threads	12	000523ae15fd47739ed9fccc383746ef
num_boost_round	1400	000523ae15fd47739ed9fccc383746ef
feature_name	auto	000523ae15fd47739ed9fccc383746ef
categorical_feature	auto	000523ae15fd47739ed9fccc383746ef
keep_training_booster	False	000523ae15fd47739ed9fccc383746ef
boosting_type	gbdt	d720a01642da4ff5b01c61771cdf9d91
colsample_bytree	0.5255972521680382	d720a01642da4ff5b01c61771cdf9d91
learning_rate	0.019083649807922834	d720a01642da4ff5b01c61771cdf9d91
max_depth	8	d720a01642da4ff5b01c61771cdf9d91
min_child_samples	195	d720a01642da4ff5b01c61771cdf9d91
min_child_weight	0.001	d720a01642da4ff5b01c61771cdf9d91
min_split_gain	0.8560599422124928	d720a01642da4ff5b01c61771cdf9d91
num_leaves	92	d720a01642da4ff5b01c61771cdf9d91
random_state	42	d720a01642da4ff5b01c61771cdf9d91
reg_alpha	0.08858224629102181	d720a01642da4ff5b01c61771cdf9d91
reg_lambda	0.0006871921810349488	d720a01642da4ff5b01c61771cdf9d91
subsample	0.7139499357209302	d720a01642da4ff5b01c61771cdf9d91
subsample_for_bin	200000	d720a01642da4ff5b01c61771cdf9d91
subsample_freq	0	d720a01642da4ff5b01c61771cdf9d91
metric	['None']	d720a01642da4ff5b01c61771cdf9d91
verbosity	-1	d720a01642da4ff5b01c61771cdf9d91
scale_pos_weight	6.9980154820796665	d720a01642da4ff5b01c61771cdf9d91
objective	binary	d720a01642da4ff5b01c61771cdf9d91
num_threads	12	d720a01642da4ff5b01c61771cdf9d91
num_boost_round	1600	d720a01642da4ff5b01c61771cdf9d91
feature_name	auto	d720a01642da4ff5b01c61771cdf9d91
categorical_feature	auto	d720a01642da4ff5b01c61771cdf9d91
keep_training_booster	False	d720a01642da4ff5b01c61771cdf9d91
boosting_type	gbdt	4fe6b8e9bbef4cb49dd0b503775f095e
colsample_bytree	0.673681709883973	4fe6b8e9bbef4cb49dd0b503775f095e
learning_rate	0.009381344003679012	4fe6b8e9bbef4cb49dd0b503775f095e
max_depth	8	4fe6b8e9bbef4cb49dd0b503775f095e
min_child_samples	182	4fe6b8e9bbef4cb49dd0b503775f095e
min_child_weight	0.001	4fe6b8e9bbef4cb49dd0b503775f095e
min_split_gain	0.9221406275479853	4fe6b8e9bbef4cb49dd0b503775f095e
num_leaves	52	4fe6b8e9bbef4cb49dd0b503775f095e
random_state	42	4fe6b8e9bbef4cb49dd0b503775f095e
reg_alpha	1.8969406991735402	4fe6b8e9bbef4cb49dd0b503775f095e
reg_lambda	0.05748490526982532	4fe6b8e9bbef4cb49dd0b503775f095e
subsample	0.6533790980402921	4fe6b8e9bbef4cb49dd0b503775f095e
subsample_for_bin	200000	4fe6b8e9bbef4cb49dd0b503775f095e
subsample_freq	0	4fe6b8e9bbef4cb49dd0b503775f095e
metric	['None']	4fe6b8e9bbef4cb49dd0b503775f095e
verbosity	-1	4fe6b8e9bbef4cb49dd0b503775f095e
scale_pos_weight	9.24541116706947	4fe6b8e9bbef4cb49dd0b503775f095e
objective	binary	4fe6b8e9bbef4cb49dd0b503775f095e
num_threads	12	4fe6b8e9bbef4cb49dd0b503775f095e
num_boost_round	1900	4fe6b8e9bbef4cb49dd0b503775f095e
feature_name	auto	4fe6b8e9bbef4cb49dd0b503775f095e
categorical_feature	auto	4fe6b8e9bbef4cb49dd0b503775f095e
keep_training_booster	False	4fe6b8e9bbef4cb49dd0b503775f095e
boosting_type	gbdt	c9bd89e9733b418e8a4c762cccf8aa2d
colsample_bytree	0.847574890617717	c9bd89e9733b418e8a4c762cccf8aa2d
learning_rate	0.006087599919668414	c9bd89e9733b418e8a4c762cccf8aa2d
max_depth	10	c9bd89e9733b418e8a4c762cccf8aa2d
min_child_samples	154	c9bd89e9733b418e8a4c762cccf8aa2d
min_child_weight	0.001	c9bd89e9733b418e8a4c762cccf8aa2d
min_split_gain	0.5696352497178928	c9bd89e9733b418e8a4c762cccf8aa2d
num_leaves	45	c9bd89e9733b418e8a4c762cccf8aa2d
random_state	42	c9bd89e9733b418e8a4c762cccf8aa2d
reg_alpha	0.08217598022456452	c9bd89e9733b418e8a4c762cccf8aa2d
reg_lambda	0.05874625937337175	c9bd89e9733b418e8a4c762cccf8aa2d
subsample	0.6340902458348492	c9bd89e9733b418e8a4c762cccf8aa2d
subsample_for_bin	200000	c9bd89e9733b418e8a4c762cccf8aa2d
subsample_freq	0	c9bd89e9733b418e8a4c762cccf8aa2d
metric	['None']	c9bd89e9733b418e8a4c762cccf8aa2d
verbosity	-1	c9bd89e9733b418e8a4c762cccf8aa2d
scale_pos_weight	8.53534399168156	c9bd89e9733b418e8a4c762cccf8aa2d
objective	binary	c9bd89e9733b418e8a4c762cccf8aa2d
num_threads	12	c9bd89e9733b418e8a4c762cccf8aa2d
num_boost_round	1700	c9bd89e9733b418e8a4c762cccf8aa2d
feature_name	auto	c9bd89e9733b418e8a4c762cccf8aa2d
categorical_feature	auto	c9bd89e9733b418e8a4c762cccf8aa2d
keep_training_booster	False	c9bd89e9733b418e8a4c762cccf8aa2d
boosting_type	gbdt	61bef132335149da8fc1bcd646945380
colsample_bytree	0.6479796032512872	61bef132335149da8fc1bcd646945380
learning_rate	0.02253883197685354	61bef132335149da8fc1bcd646945380
max_depth	10	61bef132335149da8fc1bcd646945380
min_child_samples	181	61bef132335149da8fc1bcd646945380
min_child_weight	0.001	61bef132335149da8fc1bcd646945380
min_split_gain	0.7879698713709545	61bef132335149da8fc1bcd646945380
num_leaves	45	61bef132335149da8fc1bcd646945380
random_state	42	61bef132335149da8fc1bcd646945380
reg_alpha	2.0183022331320677	61bef132335149da8fc1bcd646945380
reg_lambda	0.00034156226989627553	61bef132335149da8fc1bcd646945380
subsample	0.6036443063855811	61bef132335149da8fc1bcd646945380
subsample_for_bin	200000	61bef132335149da8fc1bcd646945380
subsample_freq	0	61bef132335149da8fc1bcd646945380
metric	['None']	61bef132335149da8fc1bcd646945380
verbosity	-1	61bef132335149da8fc1bcd646945380
scale_pos_weight	6.724160106645212	61bef132335149da8fc1bcd646945380
objective	binary	61bef132335149da8fc1bcd646945380
num_threads	12	61bef132335149da8fc1bcd646945380
num_boost_round	1700	61bef132335149da8fc1bcd646945380
feature_name	auto	61bef132335149da8fc1bcd646945380
categorical_feature	auto	61bef132335149da8fc1bcd646945380
keep_training_booster	False	61bef132335149da8fc1bcd646945380
max_depth	11	e465ea368468417f95c02d9736ea13d2
min_child_samples	175	e465ea368468417f95c02d9736ea13d2
min_child_weight	0.001	e465ea368468417f95c02d9736ea13d2
min_split_gain	0.9785512551506619	e465ea368468417f95c02d9736ea13d2
num_leaves	50	e465ea368468417f95c02d9736ea13d2
random_state	42	e465ea368468417f95c02d9736ea13d2
reg_alpha	0.0015082321971075835	e465ea368468417f95c02d9736ea13d2
reg_lambda	0.00011321490340905076	e465ea368468417f95c02d9736ea13d2
subsample	0.7601821382893423	e465ea368468417f95c02d9736ea13d2
subsample_for_bin	200000	e465ea368468417f95c02d9736ea13d2
subsample_freq	0	e465ea368468417f95c02d9736ea13d2
metric	['None']	e465ea368468417f95c02d9736ea13d2
verbosity	-1	e465ea368468417f95c02d9736ea13d2
scale_pos_weight	6.14802020895621	e465ea368468417f95c02d9736ea13d2
objective	binary	e465ea368468417f95c02d9736ea13d2
num_threads	12	e465ea368468417f95c02d9736ea13d2
num_boost_round	1300	e465ea368468417f95c02d9736ea13d2
feature_name	auto	e465ea368468417f95c02d9736ea13d2
categorical_feature	auto	e465ea368468417f95c02d9736ea13d2
keep_training_booster	False	e465ea368468417f95c02d9736ea13d2
boosting_type	gbdt	59630d004d38484f8b30f453b17fd561
colsample_bytree	0.5385012325387949	59630d004d38484f8b30f453b17fd561
learning_rate	0.005777564027283836	59630d004d38484f8b30f453b17fd561
max_depth	8	59630d004d38484f8b30f453b17fd561
min_child_samples	157	59630d004d38484f8b30f453b17fd561
min_child_weight	0.001	59630d004d38484f8b30f453b17fd561
min_split_gain	0.8615475131537453	59630d004d38484f8b30f453b17fd561
num_leaves	29	59630d004d38484f8b30f453b17fd561
random_state	42	59630d004d38484f8b30f453b17fd561
reg_alpha	0.08995323126050014	59630d004d38484f8b30f453b17fd561
reg_lambda	0.0015564971290448855	59630d004d38484f8b30f453b17fd561
subsample	0.8570503470562615	59630d004d38484f8b30f453b17fd561
subsample_for_bin	200000	59630d004d38484f8b30f453b17fd561
subsample_freq	0	59630d004d38484f8b30f453b17fd561
metric	['None']	59630d004d38484f8b30f453b17fd561
verbosity	-1	59630d004d38484f8b30f453b17fd561
scale_pos_weight	9.890224068050776	59630d004d38484f8b30f453b17fd561
objective	binary	59630d004d38484f8b30f453b17fd561
num_threads	12	59630d004d38484f8b30f453b17fd561
num_boost_round	1400	59630d004d38484f8b30f453b17fd561
feature_name	auto	59630d004d38484f8b30f453b17fd561
categorical_feature	auto	59630d004d38484f8b30f453b17fd561
keep_training_booster	False	59630d004d38484f8b30f453b17fd561
boosting_type	gbdt	212e3cc9c33a469097370a89878e6e0d
colsample_bytree	0.563499431160104	212e3cc9c33a469097370a89878e6e0d
learning_rate	0.021566330741360332	212e3cc9c33a469097370a89878e6e0d
max_depth	12	212e3cc9c33a469097370a89878e6e0d
min_child_samples	188	212e3cc9c33a469097370a89878e6e0d
min_child_weight	0.001	212e3cc9c33a469097370a89878e6e0d
min_split_gain	0.9358002282455508	212e3cc9c33a469097370a89878e6e0d
num_leaves	25	212e3cc9c33a469097370a89878e6e0d
random_state	42	212e3cc9c33a469097370a89878e6e0d
reg_alpha	3.5516185197744364e-05	212e3cc9c33a469097370a89878e6e0d
reg_lambda	0.008169692442985753	212e3cc9c33a469097370a89878e6e0d
subsample	0.9990290262863499	212e3cc9c33a469097370a89878e6e0d
subsample_for_bin	200000	212e3cc9c33a469097370a89878e6e0d
subsample_freq	0	212e3cc9c33a469097370a89878e6e0d
metric	['None']	212e3cc9c33a469097370a89878e6e0d
verbosity	-1	212e3cc9c33a469097370a89878e6e0d
scale_pos_weight	9.303797449061529	212e3cc9c33a469097370a89878e6e0d
objective	binary	212e3cc9c33a469097370a89878e6e0d
num_threads	12	212e3cc9c33a469097370a89878e6e0d
num_boost_round	1800	212e3cc9c33a469097370a89878e6e0d
feature_name	auto	212e3cc9c33a469097370a89878e6e0d
categorical_feature	auto	212e3cc9c33a469097370a89878e6e0d
keep_training_booster	False	212e3cc9c33a469097370a89878e6e0d
boosting_type	gbdt	0b4fd1f6f7d84dfe891162a68110faa4
colsample_bytree	0.5372904047384068	0b4fd1f6f7d84dfe891162a68110faa4
learning_rate	0.017518714048320855	0b4fd1f6f7d84dfe891162a68110faa4
max_depth	11	0b4fd1f6f7d84dfe891162a68110faa4
boosting_type	gbdt	8c036e2f01ae4dce9b24165f8105ca06
colsample_bytree	0.6971251509952499	8c036e2f01ae4dce9b24165f8105ca06
learning_rate	0.02936351682211008	8c036e2f01ae4dce9b24165f8105ca06
max_depth	4	8c036e2f01ae4dce9b24165f8105ca06
min_child_samples	188	8c036e2f01ae4dce9b24165f8105ca06
min_child_weight	0.001	8c036e2f01ae4dce9b24165f8105ca06
min_split_gain	0.7596193745713401	8c036e2f01ae4dce9b24165f8105ca06
num_leaves	85	8c036e2f01ae4dce9b24165f8105ca06
random_state	42	8c036e2f01ae4dce9b24165f8105ca06
reg_alpha	3.8136925370882158	8c036e2f01ae4dce9b24165f8105ca06
reg_lambda	0.20976616619557575	8c036e2f01ae4dce9b24165f8105ca06
subsample	0.6603052079464569	8c036e2f01ae4dce9b24165f8105ca06
subsample_for_bin	200000	8c036e2f01ae4dce9b24165f8105ca06
subsample_freq	0	8c036e2f01ae4dce9b24165f8105ca06
metric	['None']	8c036e2f01ae4dce9b24165f8105ca06
verbosity	-1	8c036e2f01ae4dce9b24165f8105ca06
scale_pos_weight	8.36776078981576	8c036e2f01ae4dce9b24165f8105ca06
objective	binary	8c036e2f01ae4dce9b24165f8105ca06
num_threads	12	8c036e2f01ae4dce9b24165f8105ca06
num_boost_round	2000	8c036e2f01ae4dce9b24165f8105ca06
feature_name	auto	8c036e2f01ae4dce9b24165f8105ca06
categorical_feature	auto	8c036e2f01ae4dce9b24165f8105ca06
keep_training_booster	False	8c036e2f01ae4dce9b24165f8105ca06
boosting_type	gbdt	532603551a954e97bc6f82485f631d2e
colsample_bytree	0.6311246794155184	532603551a954e97bc6f82485f631d2e
learning_rate	0.18569283120073724	532603551a954e97bc6f82485f631d2e
max_depth	3	532603551a954e97bc6f82485f631d2e
min_child_samples	39	532603551a954e97bc6f82485f631d2e
min_child_weight	0.001	532603551a954e97bc6f82485f631d2e
min_split_gain	0.2647253712970834	532603551a954e97bc6f82485f631d2e
num_leaves	53	532603551a954e97bc6f82485f631d2e
random_state	42	532603551a954e97bc6f82485f631d2e
reg_alpha	0.06877776017356528	532603551a954e97bc6f82485f631d2e
reg_lambda	0.008946843527696821	532603551a954e97bc6f82485f631d2e
subsample	0.774349431721902	532603551a954e97bc6f82485f631d2e
subsample_for_bin	200000	532603551a954e97bc6f82485f631d2e
subsample_freq	0	532603551a954e97bc6f82485f631d2e
metric	['None']	532603551a954e97bc6f82485f631d2e
verbosity	-1	532603551a954e97bc6f82485f631d2e
scale_pos_weight	7.113614384300022	532603551a954e97bc6f82485f631d2e
objective	binary	532603551a954e97bc6f82485f631d2e
num_threads	12	532603551a954e97bc6f82485f631d2e
num_boost_round	600	532603551a954e97bc6f82485f631d2e
feature_name	auto	532603551a954e97bc6f82485f631d2e
categorical_feature	auto	532603551a954e97bc6f82485f631d2e
keep_training_booster	False	532603551a954e97bc6f82485f631d2e
boosting_type	gbdt	a4fe1e00ac0e4e67b019e182ca42dfa5
colsample_bytree	0.6658283703435164	a4fe1e00ac0e4e67b019e182ca42dfa5
learning_rate	0.0060528773476784675	a4fe1e00ac0e4e67b019e182ca42dfa5
max_depth	7	a4fe1e00ac0e4e67b019e182ca42dfa5
min_child_samples	156	a4fe1e00ac0e4e67b019e182ca42dfa5
min_child_weight	0.001	a4fe1e00ac0e4e67b019e182ca42dfa5
min_split_gain	0.9954604691241354	a4fe1e00ac0e4e67b019e182ca42dfa5
num_leaves	48	a4fe1e00ac0e4e67b019e182ca42dfa5
random_state	42	a4fe1e00ac0e4e67b019e182ca42dfa5
reg_alpha	1.3506382051830916	a4fe1e00ac0e4e67b019e182ca42dfa5
reg_lambda	0.11269191626345548	a4fe1e00ac0e4e67b019e182ca42dfa5
subsample	0.7002398560929418	a4fe1e00ac0e4e67b019e182ca42dfa5
subsample_for_bin	200000	a4fe1e00ac0e4e67b019e182ca42dfa5
subsample_freq	0	a4fe1e00ac0e4e67b019e182ca42dfa5
metric	['None']	a4fe1e00ac0e4e67b019e182ca42dfa5
verbosity	-1	a4fe1e00ac0e4e67b019e182ca42dfa5
scale_pos_weight	10.55084517559326	a4fe1e00ac0e4e67b019e182ca42dfa5
objective	binary	a4fe1e00ac0e4e67b019e182ca42dfa5
num_threads	12	a4fe1e00ac0e4e67b019e182ca42dfa5
num_boost_round	1900	a4fe1e00ac0e4e67b019e182ca42dfa5
feature_name	auto	a4fe1e00ac0e4e67b019e182ca42dfa5
categorical_feature	auto	a4fe1e00ac0e4e67b019e182ca42dfa5
keep_training_booster	False	a4fe1e00ac0e4e67b019e182ca42dfa5
boosting_type	gbdt	2b432c32784143a9b9d3be8670c9b2de
colsample_bytree	0.6116591351342204	2b432c32784143a9b9d3be8670c9b2de
learning_rate	0.013250643651636685	2b432c32784143a9b9d3be8670c9b2de
max_depth	10	2b432c32784143a9b9d3be8670c9b2de
min_child_samples	81	2b432c32784143a9b9d3be8670c9b2de
min_child_weight	0.001	2b432c32784143a9b9d3be8670c9b2de
min_split_gain	0.9980746365750306	2b432c32784143a9b9d3be8670c9b2de
num_leaves	114	2b432c32784143a9b9d3be8670c9b2de
random_state	42	2b432c32784143a9b9d3be8670c9b2de
reg_alpha	4.8220969241451055	2b432c32784143a9b9d3be8670c9b2de
reg_lambda	0.26184147606247943	2b432c32784143a9b9d3be8670c9b2de
subsample	0.6861932256431861	2b432c32784143a9b9d3be8670c9b2de
subsample_for_bin	200000	2b432c32784143a9b9d3be8670c9b2de
subsample_freq	0	2b432c32784143a9b9d3be8670c9b2de
metric	['None']	2b432c32784143a9b9d3be8670c9b2de
verbosity	-1	2b432c32784143a9b9d3be8670c9b2de
scale_pos_weight	8.690910564789396	2b432c32784143a9b9d3be8670c9b2de
objective	binary	2b432c32784143a9b9d3be8670c9b2de
num_threads	12	2b432c32784143a9b9d3be8670c9b2de
num_boost_round	1100	2b432c32784143a9b9d3be8670c9b2de
feature_name	auto	2b432c32784143a9b9d3be8670c9b2de
categorical_feature	auto	2b432c32784143a9b9d3be8670c9b2de
keep_training_booster	False	2b432c32784143a9b9d3be8670c9b2de
boosting_type	gbdt	7f39848a745a4f55b4b6f53656bbea09
min_split_gain	0.9320780526572225	0b4fd1f6f7d84dfe891162a68110faa4
num_leaves	26	0b4fd1f6f7d84dfe891162a68110faa4
random_state	42	0b4fd1f6f7d84dfe891162a68110faa4
reg_alpha	1.8784451218573852	0b4fd1f6f7d84dfe891162a68110faa4
reg_lambda	2.5019212952559258	0b4fd1f6f7d84dfe891162a68110faa4
subsample	0.9389197100972241	0b4fd1f6f7d84dfe891162a68110faa4
subsample_for_bin	200000	0b4fd1f6f7d84dfe891162a68110faa4
subsample_freq	0	0b4fd1f6f7d84dfe891162a68110faa4
metric	['None']	0b4fd1f6f7d84dfe891162a68110faa4
verbosity	-1	0b4fd1f6f7d84dfe891162a68110faa4
scale_pos_weight	6.659437967652092	0b4fd1f6f7d84dfe891162a68110faa4
objective	binary	0b4fd1f6f7d84dfe891162a68110faa4
num_threads	12	0b4fd1f6f7d84dfe891162a68110faa4
num_boost_round	2000	0b4fd1f6f7d84dfe891162a68110faa4
feature_name	auto	0b4fd1f6f7d84dfe891162a68110faa4
categorical_feature	auto	0b4fd1f6f7d84dfe891162a68110faa4
keep_training_booster	False	0b4fd1f6f7d84dfe891162a68110faa4
boosting_type	gbdt	5731165fd9d341c093634c24885b4b80
colsample_bytree	0.6898537589425668	5731165fd9d341c093634c24885b4b80
learning_rate	0.06973209023736525	5731165fd9d341c093634c24885b4b80
max_depth	6	5731165fd9d341c093634c24885b4b80
min_child_samples	29	5731165fd9d341c093634c24885b4b80
min_child_weight	0.001	5731165fd9d341c093634c24885b4b80
min_split_gain	0.8661391477618954	5731165fd9d341c093634c24885b4b80
num_leaves	39	5731165fd9d341c093634c24885b4b80
random_state	42	5731165fd9d341c093634c24885b4b80
reg_alpha	0.45789380133113544	5731165fd9d341c093634c24885b4b80
reg_lambda	6.315590090425227e-05	5731165fd9d341c093634c24885b4b80
subsample	0.8478715991740299	5731165fd9d341c093634c24885b4b80
subsample_for_bin	200000	5731165fd9d341c093634c24885b4b80
subsample_freq	0	5731165fd9d341c093634c24885b4b80
metric	['None']	5731165fd9d341c093634c24885b4b80
verbosity	-1	5731165fd9d341c093634c24885b4b80
scale_pos_weight	12.069818853915585	5731165fd9d341c093634c24885b4b80
objective	binary	5731165fd9d341c093634c24885b4b80
num_threads	12	5731165fd9d341c093634c24885b4b80
num_boost_round	800	5731165fd9d341c093634c24885b4b80
feature_name	auto	5731165fd9d341c093634c24885b4b80
categorical_feature	auto	5731165fd9d341c093634c24885b4b80
keep_training_booster	False	5731165fd9d341c093634c24885b4b80
boosting_type	gbdt	531d154bc65c4e3c9e3e691c91d4e598
colsample_bytree	0.6338314767350522	531d154bc65c4e3c9e3e691c91d4e598
learning_rate	0.02232892079977442	531d154bc65c4e3c9e3e691c91d4e598
max_depth	8	531d154bc65c4e3c9e3e691c91d4e598
min_child_samples	79	531d154bc65c4e3c9e3e691c91d4e598
min_child_weight	0.001	531d154bc65c4e3c9e3e691c91d4e598
min_split_gain	0.6751635253506578	531d154bc65c4e3c9e3e691c91d4e598
num_leaves	72	531d154bc65c4e3c9e3e691c91d4e598
random_state	42	531d154bc65c4e3c9e3e691c91d4e598
reg_alpha	3.3801297017161595e-05	531d154bc65c4e3c9e3e691c91d4e598
reg_lambda	0.06978947339465665	531d154bc65c4e3c9e3e691c91d4e598
subsample	0.8285114132513767	531d154bc65c4e3c9e3e691c91d4e598
subsample_for_bin	200000	531d154bc65c4e3c9e3e691c91d4e598
subsample_freq	0	531d154bc65c4e3c9e3e691c91d4e598
metric	['None']	531d154bc65c4e3c9e3e691c91d4e598
verbosity	-1	531d154bc65c4e3c9e3e691c91d4e598
scale_pos_weight	5.789968151750439	531d154bc65c4e3c9e3e691c91d4e598
objective	binary	531d154bc65c4e3c9e3e691c91d4e598
num_threads	12	531d154bc65c4e3c9e3e691c91d4e598
num_boost_round	1300	531d154bc65c4e3c9e3e691c91d4e598
feature_name	auto	531d154bc65c4e3c9e3e691c91d4e598
categorical_feature	auto	531d154bc65c4e3c9e3e691c91d4e598
keep_training_booster	False	531d154bc65c4e3c9e3e691c91d4e598
decision_threshold	0.64	be0003b4c09f45a384716a36faaa3fde
boosting_type	gbdt	c8478da13b1d44e09ff6954fe7f8ceb5
colsample_bytree	0.5249429603653432	c8478da13b1d44e09ff6954fe7f8ceb5
learning_rate	0.009274600242896704	c8478da13b1d44e09ff6954fe7f8ceb5
max_depth	11	c8478da13b1d44e09ff6954fe7f8ceb5
min_child_samples	165	c8478da13b1d44e09ff6954fe7f8ceb5
min_child_weight	0.001	c8478da13b1d44e09ff6954fe7f8ceb5
min_split_gain	0.9841812542261728	c8478da13b1d44e09ff6954fe7f8ceb5
num_leaves	25	c8478da13b1d44e09ff6954fe7f8ceb5
random_state	42	c8478da13b1d44e09ff6954fe7f8ceb5
reg_alpha	0.0095252160061514	c8478da13b1d44e09ff6954fe7f8ceb5
reg_lambda	0.003604675489967244	c8478da13b1d44e09ff6954fe7f8ceb5
subsample	0.9413319560424297	c8478da13b1d44e09ff6954fe7f8ceb5
subsample_for_bin	200000	c8478da13b1d44e09ff6954fe7f8ceb5
subsample_freq	0	c8478da13b1d44e09ff6954fe7f8ceb5
metric	['None']	c8478da13b1d44e09ff6954fe7f8ceb5
verbosity	-1	c8478da13b1d44e09ff6954fe7f8ceb5
scale_pos_weight	14.112361038225451	c8478da13b1d44e09ff6954fe7f8ceb5
objective	binary	c8478da13b1d44e09ff6954fe7f8ceb5
num_threads	12	c8478da13b1d44e09ff6954fe7f8ceb5
num_boost_round	2000	c8478da13b1d44e09ff6954fe7f8ceb5
feature_name	auto	c8478da13b1d44e09ff6954fe7f8ceb5
categorical_feature	auto	c8478da13b1d44e09ff6954fe7f8ceb5
keep_training_booster	False	c8478da13b1d44e09ff6954fe7f8ceb5
boosting_type	gbdt	8c6c444e121e4c82ad5345c29fcd297d
colsample_bytree	0.6146246966063932	8c6c444e121e4c82ad5345c29fcd297d
learning_rate	0.041221891016057215	8c6c444e121e4c82ad5345c29fcd297d
max_depth	3	8c6c444e121e4c82ad5345c29fcd297d
min_child_samples	37	8c6c444e121e4c82ad5345c29fcd297d
min_child_weight	0.001	8c6c444e121e4c82ad5345c29fcd297d
min_split_gain	0.42193689418196856	8c6c444e121e4c82ad5345c29fcd297d
num_leaves	50	8c6c444e121e4c82ad5345c29fcd297d
random_state	42	8c6c444e121e4c82ad5345c29fcd297d
reg_alpha	0.0018966597953653918	8c6c444e121e4c82ad5345c29fcd297d
reg_lambda	9.664479889736525e-05	8c6c444e121e4c82ad5345c29fcd297d
subsample	0.7882951673893144	8c6c444e121e4c82ad5345c29fcd297d
subsample_for_bin	200000	8c6c444e121e4c82ad5345c29fcd297d
subsample_freq	0	8c6c444e121e4c82ad5345c29fcd297d
metric	['None']	8c6c444e121e4c82ad5345c29fcd297d
verbosity	-1	8c6c444e121e4c82ad5345c29fcd297d
scale_pos_weight	14.33224308672612	8c6c444e121e4c82ad5345c29fcd297d
objective	binary	8c6c444e121e4c82ad5345c29fcd297d
num_threads	12	8c6c444e121e4c82ad5345c29fcd297d
num_boost_round	800	8c6c444e121e4c82ad5345c29fcd297d
feature_name	auto	8c6c444e121e4c82ad5345c29fcd297d
categorical_feature	auto	8c6c444e121e4c82ad5345c29fcd297d
keep_training_booster	False	8c6c444e121e4c82ad5345c29fcd297d
boosting_type	gbdt	7166345b17ac40e3a6384bc3e57a4e38
colsample_bytree	0.6666723078085206	7166345b17ac40e3a6384bc3e57a4e38
learning_rate	0.010418212931682982	7166345b17ac40e3a6384bc3e57a4e38
max_depth	10	7166345b17ac40e3a6384bc3e57a4e38
min_child_samples	58	7166345b17ac40e3a6384bc3e57a4e38
min_child_weight	0.001	7166345b17ac40e3a6384bc3e57a4e38
min_split_gain	0.5566867997859054	7166345b17ac40e3a6384bc3e57a4e38
num_leaves	86	7166345b17ac40e3a6384bc3e57a4e38
random_state	42	7166345b17ac40e3a6384bc3e57a4e38
reg_alpha	9.858025573799954e-08	7166345b17ac40e3a6384bc3e57a4e38
reg_lambda	0.023122123331506806	7166345b17ac40e3a6384bc3e57a4e38
subsample	0.858126396808339	7166345b17ac40e3a6384bc3e57a4e38
subsample_for_bin	200000	7166345b17ac40e3a6384bc3e57a4e38
subsample_freq	0	7166345b17ac40e3a6384bc3e57a4e38
metric	['None']	7166345b17ac40e3a6384bc3e57a4e38
verbosity	-1	7166345b17ac40e3a6384bc3e57a4e38
scale_pos_weight	9.442698039260552	7166345b17ac40e3a6384bc3e57a4e38
objective	binary	7166345b17ac40e3a6384bc3e57a4e38
num_threads	12	7166345b17ac40e3a6384bc3e57a4e38
num_boost_round	2000	7166345b17ac40e3a6384bc3e57a4e38
feature_name	auto	7166345b17ac40e3a6384bc3e57a4e38
categorical_feature	auto	7166345b17ac40e3a6384bc3e57a4e38
keep_training_booster	False	7166345b17ac40e3a6384bc3e57a4e38
boosting_type	gbdt	2593c87053c24c5ab46a701293e5da1c
colsample_bytree	0.5993876556861738	2593c87053c24c5ab46a701293e5da1c
learning_rate	0.011157233093258	2593c87053c24c5ab46a701293e5da1c
max_depth	11	2593c87053c24c5ab46a701293e5da1c
min_child_samples	192	2593c87053c24c5ab46a701293e5da1c
min_child_weight	0.001	2593c87053c24c5ab46a701293e5da1c
min_split_gain	0.5864215267620299	2593c87053c24c5ab46a701293e5da1c
num_leaves	53	2593c87053c24c5ab46a701293e5da1c
random_state	42	2593c87053c24c5ab46a701293e5da1c
reg_alpha	0.0032413606977574573	2593c87053c24c5ab46a701293e5da1c
reg_lambda	3.401125515785922e-06	2593c87053c24c5ab46a701293e5da1c
subsample	0.7973169567497974	2593c87053c24c5ab46a701293e5da1c
subsample_for_bin	200000	2593c87053c24c5ab46a701293e5da1c
subsample_freq	0	2593c87053c24c5ab46a701293e5da1c
metric	['None']	2593c87053c24c5ab46a701293e5da1c
verbosity	-1	2593c87053c24c5ab46a701293e5da1c
scale_pos_weight	6.378719047798661	2593c87053c24c5ab46a701293e5da1c
objective	binary	2593c87053c24c5ab46a701293e5da1c
num_threads	12	2593c87053c24c5ab46a701293e5da1c
num_boost_round	1700	2593c87053c24c5ab46a701293e5da1c
feature_name	auto	2593c87053c24c5ab46a701293e5da1c
categorical_feature	auto	2593c87053c24c5ab46a701293e5da1c
keep_training_booster	False	2593c87053c24c5ab46a701293e5da1c
boosting_type	gbdt	0a433fa3378a4b90b664cc4fde90ed21
colsample_bytree	0.6432198256214745	0a433fa3378a4b90b664cc4fde90ed21
learning_rate	0.10239289334804869	0a433fa3378a4b90b664cc4fde90ed21
max_depth	3	0a433fa3378a4b90b664cc4fde90ed21
min_child_samples	54	0a433fa3378a4b90b664cc4fde90ed21
min_child_weight	0.001	0a433fa3378a4b90b664cc4fde90ed21
min_split_gain	0.6145840111711345	0a433fa3378a4b90b664cc4fde90ed21
num_leaves	40	0a433fa3378a4b90b664cc4fde90ed21
random_state	42	0a433fa3378a4b90b664cc4fde90ed21
reg_alpha	0.40638637974259173	0a433fa3378a4b90b664cc4fde90ed21
reg_lambda	2.2333801478714486e-05	0a433fa3378a4b90b664cc4fde90ed21
subsample	0.7953945022779402	0a433fa3378a4b90b664cc4fde90ed21
subsample_for_bin	200000	0a433fa3378a4b90b664cc4fde90ed21
subsample_freq	0	0a433fa3378a4b90b664cc4fde90ed21
metric	['None']	0a433fa3378a4b90b664cc4fde90ed21
verbosity	-1	0a433fa3378a4b90b664cc4fde90ed21
scale_pos_weight	11.378146786555948	0a433fa3378a4b90b664cc4fde90ed21
objective	binary	0a433fa3378a4b90b664cc4fde90ed21
num_threads	12	0a433fa3378a4b90b664cc4fde90ed21
num_boost_round	700	0a433fa3378a4b90b664cc4fde90ed21
feature_name	auto	0a433fa3378a4b90b664cc4fde90ed21
categorical_feature	auto	0a433fa3378a4b90b664cc4fde90ed21
keep_training_booster	False	0a433fa3378a4b90b664cc4fde90ed21
boosting_type	gbdt	6fd1e2f0387c42e6bc1b573547aa39c7
colsample_bytree	0.6372348809243162	6fd1e2f0387c42e6bc1b573547aa39c7
learning_rate	0.009607506697250287	6fd1e2f0387c42e6bc1b573547aa39c7
max_depth	9	6fd1e2f0387c42e6bc1b573547aa39c7
min_child_samples	104	6fd1e2f0387c42e6bc1b573547aa39c7
min_child_weight	0.001	6fd1e2f0387c42e6bc1b573547aa39c7
min_split_gain	0.6380235979248903	6fd1e2f0387c42e6bc1b573547aa39c7
num_leaves	40	6fd1e2f0387c42e6bc1b573547aa39c7
random_state	42	6fd1e2f0387c42e6bc1b573547aa39c7
reg_alpha	0.0002942435137235678	6fd1e2f0387c42e6bc1b573547aa39c7
reg_lambda	0.1067607604087638	6fd1e2f0387c42e6bc1b573547aa39c7
subsample	0.795249261912288	6fd1e2f0387c42e6bc1b573547aa39c7
subsample_for_bin	200000	6fd1e2f0387c42e6bc1b573547aa39c7
subsample_freq	0	6fd1e2f0387c42e6bc1b573547aa39c7
metric	['None']	6fd1e2f0387c42e6bc1b573547aa39c7
verbosity	-1	6fd1e2f0387c42e6bc1b573547aa39c7
scale_pos_weight	6.550762140637399	6fd1e2f0387c42e6bc1b573547aa39c7
objective	binary	6fd1e2f0387c42e6bc1b573547aa39c7
num_threads	12	6fd1e2f0387c42e6bc1b573547aa39c7
num_boost_round	1700	6fd1e2f0387c42e6bc1b573547aa39c7
feature_name	auto	6fd1e2f0387c42e6bc1b573547aa39c7
categorical_feature	auto	6fd1e2f0387c42e6bc1b573547aa39c7
keep_training_booster	False	6fd1e2f0387c42e6bc1b573547aa39c7
boosting_type	gbdt	7305560d783f4197a5a7e63dcb91495c
colsample_bytree	0.7041827084960136	7305560d783f4197a5a7e63dcb91495c
learning_rate	0.1356515219051228	7305560d783f4197a5a7e63dcb91495c
max_depth	3	7305560d783f4197a5a7e63dcb91495c
min_child_samples	79	7305560d783f4197a5a7e63dcb91495c
min_child_weight	0.001	7305560d783f4197a5a7e63dcb91495c
min_split_gain	0.9315414362363468	7305560d783f4197a5a7e63dcb91495c
num_leaves	27	7305560d783f4197a5a7e63dcb91495c
random_state	42	7305560d783f4197a5a7e63dcb91495c
reg_alpha	0.1957689827799687	7305560d783f4197a5a7e63dcb91495c
reg_lambda	0.00232819645075314	7305560d783f4197a5a7e63dcb91495c
subsample	0.7426156916500762	7305560d783f4197a5a7e63dcb91495c
subsample_for_bin	200000	7305560d783f4197a5a7e63dcb91495c
subsample_freq	0	7305560d783f4197a5a7e63dcb91495c
metric	['None']	7305560d783f4197a5a7e63dcb91495c
verbosity	-1	7305560d783f4197a5a7e63dcb91495c
scale_pos_weight	9.677212438494303	7305560d783f4197a5a7e63dcb91495c
objective	binary	7305560d783f4197a5a7e63dcb91495c
num_threads	12	7305560d783f4197a5a7e63dcb91495c
num_boost_round	200	7305560d783f4197a5a7e63dcb91495c
feature_name	auto	7305560d783f4197a5a7e63dcb91495c
categorical_feature	auto	7305560d783f4197a5a7e63dcb91495c
keep_training_booster	False	7305560d783f4197a5a7e63dcb91495c
boosting_type	gbdt	af4fa3186c554df8bd52d00efdd3b518
boosting_type	gbdt	14f0de2bdc004a6ca97d19b2d9dad96b
colsample_bytree	0.6662746902143135	14f0de2bdc004a6ca97d19b2d9dad96b
learning_rate	0.009070961424860887	14f0de2bdc004a6ca97d19b2d9dad96b
max_depth	8	14f0de2bdc004a6ca97d19b2d9dad96b
min_child_samples	152	14f0de2bdc004a6ca97d19b2d9dad96b
min_child_weight	0.001	14f0de2bdc004a6ca97d19b2d9dad96b
min_split_gain	0.5213572523400359	14f0de2bdc004a6ca97d19b2d9dad96b
num_leaves	43	14f0de2bdc004a6ca97d19b2d9dad96b
random_state	42	14f0de2bdc004a6ca97d19b2d9dad96b
reg_alpha	2.6836993957181347e-05	14f0de2bdc004a6ca97d19b2d9dad96b
reg_lambda	0.020461507679510344	14f0de2bdc004a6ca97d19b2d9dad96b
subsample	0.7792608312281377	14f0de2bdc004a6ca97d19b2d9dad96b
subsample_for_bin	200000	14f0de2bdc004a6ca97d19b2d9dad96b
subsample_freq	0	14f0de2bdc004a6ca97d19b2d9dad96b
metric	['None']	14f0de2bdc004a6ca97d19b2d9dad96b
verbosity	-1	14f0de2bdc004a6ca97d19b2d9dad96b
scale_pos_weight	7.410366330435042	14f0de2bdc004a6ca97d19b2d9dad96b
objective	binary	14f0de2bdc004a6ca97d19b2d9dad96b
num_threads	12	14f0de2bdc004a6ca97d19b2d9dad96b
num_boost_round	1400	14f0de2bdc004a6ca97d19b2d9dad96b
feature_name	auto	14f0de2bdc004a6ca97d19b2d9dad96b
categorical_feature	auto	14f0de2bdc004a6ca97d19b2d9dad96b
keep_training_booster	False	14f0de2bdc004a6ca97d19b2d9dad96b
boosting_type	gbdt	e04590dc86674c0985b160f47a15d939
colsample_bytree	0.5295922797697495	e04590dc86674c0985b160f47a15d939
learning_rate	0.01850227528775329	e04590dc86674c0985b160f47a15d939
max_depth	7	e04590dc86674c0985b160f47a15d939
min_child_samples	106	e04590dc86674c0985b160f47a15d939
min_child_weight	0.001	e04590dc86674c0985b160f47a15d939
min_split_gain	0.9591788244602052	e04590dc86674c0985b160f47a15d939
num_leaves	28	e04590dc86674c0985b160f47a15d939
random_state	42	e04590dc86674c0985b160f47a15d939
reg_alpha	0.004134395469964295	e04590dc86674c0985b160f47a15d939
reg_lambda	0.00779270304340887	e04590dc86674c0985b160f47a15d939
subsample	0.8967577593860206	e04590dc86674c0985b160f47a15d939
subsample_for_bin	200000	e04590dc86674c0985b160f47a15d939
subsample_freq	0	e04590dc86674c0985b160f47a15d939
metric	['None']	e04590dc86674c0985b160f47a15d939
verbosity	-1	e04590dc86674c0985b160f47a15d939
scale_pos_weight	7.478909398083074	e04590dc86674c0985b160f47a15d939
objective	binary	e04590dc86674c0985b160f47a15d939
num_threads	12	e04590dc86674c0985b160f47a15d939
num_boost_round	1700	e04590dc86674c0985b160f47a15d939
feature_name	auto	e04590dc86674c0985b160f47a15d939
categorical_feature	auto	e04590dc86674c0985b160f47a15d939
keep_training_booster	False	e04590dc86674c0985b160f47a15d939
boosting_type	gbdt	08a4d70131f54e81bd0d47a5448e3d43
colsample_bytree	0.7225126905282213	08a4d70131f54e81bd0d47a5448e3d43
learning_rate	0.005905292682698739	08a4d70131f54e81bd0d47a5448e3d43
max_depth	8	08a4d70131f54e81bd0d47a5448e3d43
min_child_samples	91	08a4d70131f54e81bd0d47a5448e3d43
min_child_weight	0.001	08a4d70131f54e81bd0d47a5448e3d43
min_split_gain	0.474656855195457	08a4d70131f54e81bd0d47a5448e3d43
num_leaves	44	08a4d70131f54e81bd0d47a5448e3d43
random_state	42	08a4d70131f54e81bd0d47a5448e3d43
reg_alpha	0.030341422015972213	08a4d70131f54e81bd0d47a5448e3d43
reg_lambda	9.761634529741567	08a4d70131f54e81bd0d47a5448e3d43
subsample	0.7969141731767329	08a4d70131f54e81bd0d47a5448e3d43
subsample_for_bin	200000	08a4d70131f54e81bd0d47a5448e3d43
subsample_freq	0	08a4d70131f54e81bd0d47a5448e3d43
metric	['None']	08a4d70131f54e81bd0d47a5448e3d43
verbosity	-1	08a4d70131f54e81bd0d47a5448e3d43
scale_pos_weight	7.02278374147551	08a4d70131f54e81bd0d47a5448e3d43
objective	binary	08a4d70131f54e81bd0d47a5448e3d43
num_threads	12	08a4d70131f54e81bd0d47a5448e3d43
num_boost_round	1500	08a4d70131f54e81bd0d47a5448e3d43
feature_name	auto	08a4d70131f54e81bd0d47a5448e3d43
categorical_feature	auto	08a4d70131f54e81bd0d47a5448e3d43
keep_training_booster	False	08a4d70131f54e81bd0d47a5448e3d43
boosting_type	gbdt	7f16b61fe03848238ff296583f7d49f5
colsample_bytree	0.5100639497083347	7f16b61fe03848238ff296583f7d49f5
learning_rate	0.02075187353517992	7f16b61fe03848238ff296583f7d49f5
max_depth	9	7f16b61fe03848238ff296583f7d49f5
min_child_samples	129	7f16b61fe03848238ff296583f7d49f5
min_child_weight	0.001	7f16b61fe03848238ff296583f7d49f5
min_split_gain	0.8939537727993108	7f16b61fe03848238ff296583f7d49f5
num_leaves	18	7f16b61fe03848238ff296583f7d49f5
random_state	42	7f16b61fe03848238ff296583f7d49f5
reg_alpha	0.3454084619881241	7f16b61fe03848238ff296583f7d49f5
reg_lambda	0.0001504668732257192	7f16b61fe03848238ff296583f7d49f5
subsample	0.8428932582539711	7f16b61fe03848238ff296583f7d49f5
subsample_for_bin	200000	7f16b61fe03848238ff296583f7d49f5
subsample_freq	0	7f16b61fe03848238ff296583f7d49f5
metric	['None']	7f16b61fe03848238ff296583f7d49f5
verbosity	-1	7f16b61fe03848238ff296583f7d49f5
scale_pos_weight	10.235529788054816	7f16b61fe03848238ff296583f7d49f5
objective	binary	7f16b61fe03848238ff296583f7d49f5
num_threads	12	7f16b61fe03848238ff296583f7d49f5
num_boost_round	1600	7f16b61fe03848238ff296583f7d49f5
feature_name	auto	7f16b61fe03848238ff296583f7d49f5
categorical_feature	auto	7f16b61fe03848238ff296583f7d49f5
keep_training_booster	False	7f16b61fe03848238ff296583f7d49f5
boosting_type	gbdt	0e6ba24868c9455f9324ff11fa6f37c0
colsample_bytree	0.5227156063452794	0e6ba24868c9455f9324ff11fa6f37c0
learning_rate	0.02033113534570485	0e6ba24868c9455f9324ff11fa6f37c0
max_depth	11	0e6ba24868c9455f9324ff11fa6f37c0
min_child_samples	144	0e6ba24868c9455f9324ff11fa6f37c0
min_child_weight	0.001	0e6ba24868c9455f9324ff11fa6f37c0
min_split_gain	0.9753925897889566	0e6ba24868c9455f9324ff11fa6f37c0
num_leaves	42	0e6ba24868c9455f9324ff11fa6f37c0
random_state	42	0e6ba24868c9455f9324ff11fa6f37c0
reg_alpha	0.30112548914506787	0e6ba24868c9455f9324ff11fa6f37c0
reg_lambda	1.6194601020365726e-07	0e6ba24868c9455f9324ff11fa6f37c0
subsample	0.781598733824245	0e6ba24868c9455f9324ff11fa6f37c0
subsample_for_bin	200000	0e6ba24868c9455f9324ff11fa6f37c0
subsample_freq	0	0e6ba24868c9455f9324ff11fa6f37c0
metric	['None']	0e6ba24868c9455f9324ff11fa6f37c0
verbosity	-1	0e6ba24868c9455f9324ff11fa6f37c0
scale_pos_weight	8.32962398033492	0e6ba24868c9455f9324ff11fa6f37c0
objective	binary	0e6ba24868c9455f9324ff11fa6f37c0
num_threads	12	0e6ba24868c9455f9324ff11fa6f37c0
num_boost_round	1700	0e6ba24868c9455f9324ff11fa6f37c0
feature_name	auto	0e6ba24868c9455f9324ff11fa6f37c0
categorical_feature	auto	0e6ba24868c9455f9324ff11fa6f37c0
keep_training_booster	False	0e6ba24868c9455f9324ff11fa6f37c0
boosting_type	gbdt	3a54e130da3a488e9cddd8f564b50636
colsample_bytree	0.6018379940032436	3a54e130da3a488e9cddd8f564b50636
learning_rate	0.16555462506314614	3a54e130da3a488e9cddd8f564b50636
max_depth	3	3a54e130da3a488e9cddd8f564b50636
min_child_samples	11	3a54e130da3a488e9cddd8f564b50636
min_child_weight	0.001	3a54e130da3a488e9cddd8f564b50636
min_split_gain	0.3889359771804523	3a54e130da3a488e9cddd8f564b50636
num_leaves	16	3a54e130da3a488e9cddd8f564b50636
random_state	42	3a54e130da3a488e9cddd8f564b50636
reg_alpha	0.397496150533177	3a54e130da3a488e9cddd8f564b50636
reg_lambda	2.7374961563255747e-08	3a54e130da3a488e9cddd8f564b50636
subsample	0.801649428125013	3a54e130da3a488e9cddd8f564b50636
subsample_for_bin	200000	3a54e130da3a488e9cddd8f564b50636
subsample_freq	0	3a54e130da3a488e9cddd8f564b50636
metric	['None']	3a54e130da3a488e9cddd8f564b50636
verbosity	-1	3a54e130da3a488e9cddd8f564b50636
scale_pos_weight	10.3735082980578	3a54e130da3a488e9cddd8f564b50636
objective	binary	3a54e130da3a488e9cddd8f564b50636
num_threads	12	3a54e130da3a488e9cddd8f564b50636
num_boost_round	300	3a54e130da3a488e9cddd8f564b50636
feature_name	auto	3a54e130da3a488e9cddd8f564b50636
categorical_feature	auto	3a54e130da3a488e9cddd8f564b50636
keep_training_booster	False	3a54e130da3a488e9cddd8f564b50636
boosting_type	gbdt	196f279c8b2a47a3ae0b5e4069634bfe
colsample_bytree	0.7028158624619697	196f279c8b2a47a3ae0b5e4069634bfe
learning_rate	0.1668271287248888	196f279c8b2a47a3ae0b5e4069634bfe
max_depth	4	196f279c8b2a47a3ae0b5e4069634bfe
min_child_samples	89	196f279c8b2a47a3ae0b5e4069634bfe
min_child_weight	0.001	196f279c8b2a47a3ae0b5e4069634bfe
min_split_gain	0.6764721574076317	196f279c8b2a47a3ae0b5e4069634bfe
num_leaves	27	196f279c8b2a47a3ae0b5e4069634bfe
random_state	42	196f279c8b2a47a3ae0b5e4069634bfe
reg_alpha	0.11094187538099776	196f279c8b2a47a3ae0b5e4069634bfe
reg_lambda	2.1565924359117937e-06	196f279c8b2a47a3ae0b5e4069634bfe
subsample	0.8673486960987788	196f279c8b2a47a3ae0b5e4069634bfe
subsample_for_bin	200000	196f279c8b2a47a3ae0b5e4069634bfe
subsample_freq	0	196f279c8b2a47a3ae0b5e4069634bfe
metric	['None']	196f279c8b2a47a3ae0b5e4069634bfe
verbosity	-1	196f279c8b2a47a3ae0b5e4069634bfe
scale_pos_weight	10.087144313881433	196f279c8b2a47a3ae0b5e4069634bfe
objective	binary	196f279c8b2a47a3ae0b5e4069634bfe
num_threads	12	196f279c8b2a47a3ae0b5e4069634bfe
num_boost_round	1000	196f279c8b2a47a3ae0b5e4069634bfe
feature_name	auto	196f279c8b2a47a3ae0b5e4069634bfe
categorical_feature	auto	196f279c8b2a47a3ae0b5e4069634bfe
keep_training_booster	False	196f279c8b2a47a3ae0b5e4069634bfe
colsample_bytree	0.6922274663159009	af4fa3186c554df8bd52d00efdd3b518
learning_rate	0.13633209197186708	af4fa3186c554df8bd52d00efdd3b518
max_depth	3	af4fa3186c554df8bd52d00efdd3b518
min_child_samples	57	af4fa3186c554df8bd52d00efdd3b518
min_child_weight	0.001	af4fa3186c554df8bd52d00efdd3b518
min_split_gain	0.08371559958052305	af4fa3186c554df8bd52d00efdd3b518
num_leaves	116	af4fa3186c554df8bd52d00efdd3b518
random_state	42	af4fa3186c554df8bd52d00efdd3b518
reg_alpha	0.0272174459495107	af4fa3186c554df8bd52d00efdd3b518
reg_lambda	2.250092962315527e-07	af4fa3186c554df8bd52d00efdd3b518
subsample	0.7153614751389372	af4fa3186c554df8bd52d00efdd3b518
subsample_for_bin	200000	af4fa3186c554df8bd52d00efdd3b518
subsample_freq	0	af4fa3186c554df8bd52d00efdd3b518
metric	['None']	af4fa3186c554df8bd52d00efdd3b518
verbosity	-1	af4fa3186c554df8bd52d00efdd3b518
scale_pos_weight	16.995197790713345	af4fa3186c554df8bd52d00efdd3b518
objective	binary	af4fa3186c554df8bd52d00efdd3b518
num_threads	12	af4fa3186c554df8bd52d00efdd3b518
num_boost_round	300	af4fa3186c554df8bd52d00efdd3b518
feature_name	auto	af4fa3186c554df8bd52d00efdd3b518
categorical_feature	auto	af4fa3186c554df8bd52d00efdd3b518
keep_training_booster	False	af4fa3186c554df8bd52d00efdd3b518
boosting_type	gbdt	e6f37d31a9df48adbf7ce400630985f2
colsample_bytree	0.5279926917649457	e6f37d31a9df48adbf7ce400630985f2
learning_rate	0.03328447427285721	e6f37d31a9df48adbf7ce400630985f2
max_depth	9	e6f37d31a9df48adbf7ce400630985f2
min_child_samples	79	e6f37d31a9df48adbf7ce400630985f2
min_child_weight	0.001	e6f37d31a9df48adbf7ce400630985f2
min_split_gain	0.573024757250299	e6f37d31a9df48adbf7ce400630985f2
num_leaves	18	e6f37d31a9df48adbf7ce400630985f2
random_state	42	e6f37d31a9df48adbf7ce400630985f2
reg_alpha	0.002958308173816128	e6f37d31a9df48adbf7ce400630985f2
reg_lambda	6.376766128139896e-05	e6f37d31a9df48adbf7ce400630985f2
subsample	0.9509402559744826	e6f37d31a9df48adbf7ce400630985f2
subsample_for_bin	200000	e6f37d31a9df48adbf7ce400630985f2
subsample_freq	0	e6f37d31a9df48adbf7ce400630985f2
metric	['None']	e6f37d31a9df48adbf7ce400630985f2
verbosity	-1	e6f37d31a9df48adbf7ce400630985f2
scale_pos_weight	12.052912741568086	e6f37d31a9df48adbf7ce400630985f2
objective	binary	e6f37d31a9df48adbf7ce400630985f2
num_threads	12	e6f37d31a9df48adbf7ce400630985f2
num_boost_round	1500	e6f37d31a9df48adbf7ce400630985f2
feature_name	auto	e6f37d31a9df48adbf7ce400630985f2
categorical_feature	auto	e6f37d31a9df48adbf7ce400630985f2
keep_training_booster	False	e6f37d31a9df48adbf7ce400630985f2
boosting_type	gbdt	5219ab1ee77e4d0a9b2ea76665637741
colsample_bytree	0.6666401446687448	5219ab1ee77e4d0a9b2ea76665637741
learning_rate	0.08833111198472042	5219ab1ee77e4d0a9b2ea76665637741
max_depth	3	5219ab1ee77e4d0a9b2ea76665637741
min_child_samples	63	5219ab1ee77e4d0a9b2ea76665637741
min_child_weight	0.001	5219ab1ee77e4d0a9b2ea76665637741
min_split_gain	0.6490446720990635	5219ab1ee77e4d0a9b2ea76665637741
num_leaves	50	5219ab1ee77e4d0a9b2ea76665637741
random_state	42	5219ab1ee77e4d0a9b2ea76665637741
reg_alpha	1.0927137289974445	5219ab1ee77e4d0a9b2ea76665637741
reg_lambda	3.80213010945521e-06	5219ab1ee77e4d0a9b2ea76665637741
subsample	0.761242919839575	5219ab1ee77e4d0a9b2ea76665637741
subsample_for_bin	200000	5219ab1ee77e4d0a9b2ea76665637741
subsample_freq	0	5219ab1ee77e4d0a9b2ea76665637741
metric	['None']	5219ab1ee77e4d0a9b2ea76665637741
verbosity	-1	5219ab1ee77e4d0a9b2ea76665637741
scale_pos_weight	9.793336089516606	5219ab1ee77e4d0a9b2ea76665637741
objective	binary	5219ab1ee77e4d0a9b2ea76665637741
num_threads	12	5219ab1ee77e4d0a9b2ea76665637741
num_boost_round	600	5219ab1ee77e4d0a9b2ea76665637741
feature_name	auto	5219ab1ee77e4d0a9b2ea76665637741
categorical_feature	auto	5219ab1ee77e4d0a9b2ea76665637741
keep_training_booster	False	5219ab1ee77e4d0a9b2ea76665637741
boosting_type	gbdt	b7a96024f405468da0046f142f3fba28
colsample_bytree	0.5421740563058711	b7a96024f405468da0046f142f3fba28
learning_rate	0.031050917261285737	b7a96024f405468da0046f142f3fba28
max_depth	10	b7a96024f405468da0046f142f3fba28
min_child_samples	76	b7a96024f405468da0046f142f3fba28
min_child_weight	0.001	b7a96024f405468da0046f142f3fba28
min_split_gain	0.4136188073796735	b7a96024f405468da0046f142f3fba28
num_leaves	24	b7a96024f405468da0046f142f3fba28
random_state	42	b7a96024f405468da0046f142f3fba28
reg_alpha	0.0073540554628326125	b7a96024f405468da0046f142f3fba28
reg_lambda	6.125229221387823e-08	b7a96024f405468da0046f142f3fba28
subsample	0.9892228142517961	b7a96024f405468da0046f142f3fba28
subsample_for_bin	200000	b7a96024f405468da0046f142f3fba28
subsample_freq	0	b7a96024f405468da0046f142f3fba28
metric	['None']	b7a96024f405468da0046f142f3fba28
verbosity	-1	b7a96024f405468da0046f142f3fba28
scale_pos_weight	10.20935920792569	b7a96024f405468da0046f142f3fba28
objective	binary	b7a96024f405468da0046f142f3fba28
num_threads	12	b7a96024f405468da0046f142f3fba28
num_boost_round	1900	b7a96024f405468da0046f142f3fba28
feature_name	auto	b7a96024f405468da0046f142f3fba28
categorical_feature	auto	b7a96024f405468da0046f142f3fba28
keep_training_booster	False	b7a96024f405468da0046f142f3fba28
boosting_type	gbdt	cc82112ae9004ab48a54576c09abb51e
colsample_bytree	0.6888196253426562	cc82112ae9004ab48a54576c09abb51e
learning_rate	0.029752412489983636	cc82112ae9004ab48a54576c09abb51e
max_depth	8	cc82112ae9004ab48a54576c09abb51e
min_child_samples	94	cc82112ae9004ab48a54576c09abb51e
min_child_weight	0.001	cc82112ae9004ab48a54576c09abb51e
min_split_gain	0.6200808248694168	cc82112ae9004ab48a54576c09abb51e
num_leaves	42	cc82112ae9004ab48a54576c09abb51e
random_state	42	cc82112ae9004ab48a54576c09abb51e
reg_alpha	7.6340879209702415	cc82112ae9004ab48a54576c09abb51e
reg_lambda	0.00018453984344067725	cc82112ae9004ab48a54576c09abb51e
subsample	0.9309229078766047	cc82112ae9004ab48a54576c09abb51e
subsample_for_bin	200000	cc82112ae9004ab48a54576c09abb51e
subsample_freq	0	cc82112ae9004ab48a54576c09abb51e
metric	['None']	cc82112ae9004ab48a54576c09abb51e
verbosity	-1	cc82112ae9004ab48a54576c09abb51e
scale_pos_weight	12.445428412304377	cc82112ae9004ab48a54576c09abb51e
objective	binary	cc82112ae9004ab48a54576c09abb51e
num_threads	12	cc82112ae9004ab48a54576c09abb51e
num_boost_round	1600	cc82112ae9004ab48a54576c09abb51e
feature_name	auto	cc82112ae9004ab48a54576c09abb51e
categorical_feature	auto	cc82112ae9004ab48a54576c09abb51e
keep_training_booster	False	cc82112ae9004ab48a54576c09abb51e
boosting_type	gbdt	df12860a7b4a46e9abaef76ff774590e
colsample_bytree	0.5056007564603201	df12860a7b4a46e9abaef76ff774590e
learning_rate	0.0529937280210431	df12860a7b4a46e9abaef76ff774590e
max_depth	11	df12860a7b4a46e9abaef76ff774590e
min_child_samples	44	df12860a7b4a46e9abaef76ff774590e
min_child_weight	0.001	df12860a7b4a46e9abaef76ff774590e
min_split_gain	0.8007325809361638	df12860a7b4a46e9abaef76ff774590e
num_leaves	40	df12860a7b4a46e9abaef76ff774590e
random_state	42	df12860a7b4a46e9abaef76ff774590e
reg_alpha	6.517338321873673e-05	df12860a7b4a46e9abaef76ff774590e
reg_lambda	3.2843220364876286e-08	df12860a7b4a46e9abaef76ff774590e
subsample	0.9549882822441564	df12860a7b4a46e9abaef76ff774590e
subsample_for_bin	200000	df12860a7b4a46e9abaef76ff774590e
subsample_freq	0	df12860a7b4a46e9abaef76ff774590e
metric	['None']	df12860a7b4a46e9abaef76ff774590e
verbosity	-1	df12860a7b4a46e9abaef76ff774590e
scale_pos_weight	14.191265382788487	df12860a7b4a46e9abaef76ff774590e
objective	binary	df12860a7b4a46e9abaef76ff774590e
num_threads	12	df12860a7b4a46e9abaef76ff774590e
num_boost_round	1100	df12860a7b4a46e9abaef76ff774590e
feature_name	auto	df12860a7b4a46e9abaef76ff774590e
categorical_feature	auto	df12860a7b4a46e9abaef76ff774590e
keep_training_booster	False	df12860a7b4a46e9abaef76ff774590e
boosting_type	gbdt	a45d4a14e3cb4767b85a0dd503888266
colsample_bytree	0.8651530331161601	a45d4a14e3cb4767b85a0dd503888266
learning_rate	0.006080944418698224	a45d4a14e3cb4767b85a0dd503888266
max_depth	8	a45d4a14e3cb4767b85a0dd503888266
min_child_samples	200	a45d4a14e3cb4767b85a0dd503888266
min_child_weight	0.001	a45d4a14e3cb4767b85a0dd503888266
min_split_gain	0.8825401744758807	a45d4a14e3cb4767b85a0dd503888266
num_leaves	26	a45d4a14e3cb4767b85a0dd503888266
random_state	42	a45d4a14e3cb4767b85a0dd503888266
reg_alpha	0.3690501654969244	a45d4a14e3cb4767b85a0dd503888266
reg_lambda	0.16974713057803645	a45d4a14e3cb4767b85a0dd503888266
subsample	0.7100367952708824	a45d4a14e3cb4767b85a0dd503888266
subsample_for_bin	200000	a45d4a14e3cb4767b85a0dd503888266
subsample_freq	0	a45d4a14e3cb4767b85a0dd503888266
metric	['None']	a45d4a14e3cb4767b85a0dd503888266
verbosity	-1	a45d4a14e3cb4767b85a0dd503888266
scale_pos_weight	5.914034229197102	a45d4a14e3cb4767b85a0dd503888266
objective	binary	a45d4a14e3cb4767b85a0dd503888266
num_threads	12	a45d4a14e3cb4767b85a0dd503888266
num_boost_round	2000	a45d4a14e3cb4767b85a0dd503888266
feature_name	auto	a45d4a14e3cb4767b85a0dd503888266
categorical_feature	auto	a45d4a14e3cb4767b85a0dd503888266
keep_training_booster	False	a45d4a14e3cb4767b85a0dd503888266
boosting_type	gbdt	91fb3e7556b448e794bc7f57497b4ac4
colsample_bytree	0.5794835018781548	91fb3e7556b448e794bc7f57497b4ac4
learning_rate	0.0542225674021792	91fb3e7556b448e794bc7f57497b4ac4
max_depth	8	91fb3e7556b448e794bc7f57497b4ac4
min_child_samples	114	91fb3e7556b448e794bc7f57497b4ac4
min_child_weight	0.001	91fb3e7556b448e794bc7f57497b4ac4
min_split_gain	0.8918832476543879	91fb3e7556b448e794bc7f57497b4ac4
num_leaves	25	91fb3e7556b448e794bc7f57497b4ac4
random_state	42	91fb3e7556b448e794bc7f57497b4ac4
reg_alpha	0.2640289115902581	91fb3e7556b448e794bc7f57497b4ac4
reg_lambda	3.0586288728908526e-07	91fb3e7556b448e794bc7f57497b4ac4
subsample	0.8604002701075983	91fb3e7556b448e794bc7f57497b4ac4
subsample_for_bin	200000	91fb3e7556b448e794bc7f57497b4ac4
subsample_freq	0	91fb3e7556b448e794bc7f57497b4ac4
metric	['None']	91fb3e7556b448e794bc7f57497b4ac4
verbosity	-1	91fb3e7556b448e794bc7f57497b4ac4
scale_pos_weight	10.732660341665701	91fb3e7556b448e794bc7f57497b4ac4
objective	binary	91fb3e7556b448e794bc7f57497b4ac4
num_threads	12	91fb3e7556b448e794bc7f57497b4ac4
num_boost_round	1400	91fb3e7556b448e794bc7f57497b4ac4
feature_name	auto	91fb3e7556b448e794bc7f57497b4ac4
categorical_feature	auto	91fb3e7556b448e794bc7f57497b4ac4
keep_training_booster	False	91fb3e7556b448e794bc7f57497b4ac4
boosting_type	gbdt	28adcc19e5354574966fd00385b49f1a
boosting_type	gbdt	fd79d84e5b9a463e8c5d9ad2eebe966f
colsample_bytree	0.6471480296513442	28adcc19e5354574966fd00385b49f1a
learning_rate	0.04202743242458905	28adcc19e5354574966fd00385b49f1a
max_depth	7	28adcc19e5354574966fd00385b49f1a
min_child_samples	160	28adcc19e5354574966fd00385b49f1a
min_child_weight	0.001	28adcc19e5354574966fd00385b49f1a
min_split_gain	0.49124045762394253	28adcc19e5354574966fd00385b49f1a
num_leaves	29	28adcc19e5354574966fd00385b49f1a
random_state	42	28adcc19e5354574966fd00385b49f1a
reg_alpha	0.0001650462447391626	28adcc19e5354574966fd00385b49f1a
reg_lambda	0.0006064530888204645	28adcc19e5354574966fd00385b49f1a
subsample	0.8615430961676558	28adcc19e5354574966fd00385b49f1a
subsample_for_bin	200000	28adcc19e5354574966fd00385b49f1a
subsample_freq	0	28adcc19e5354574966fd00385b49f1a
metric	['None']	28adcc19e5354574966fd00385b49f1a
verbosity	-1	28adcc19e5354574966fd00385b49f1a
scale_pos_weight	12.280996068517236	28adcc19e5354574966fd00385b49f1a
objective	binary	28adcc19e5354574966fd00385b49f1a
num_threads	12	28adcc19e5354574966fd00385b49f1a
num_boost_round	1300	28adcc19e5354574966fd00385b49f1a
feature_name	auto	28adcc19e5354574966fd00385b49f1a
categorical_feature	auto	28adcc19e5354574966fd00385b49f1a
keep_training_booster	False	28adcc19e5354574966fd00385b49f1a
colsample_bytree	0.5068129049267083	fd79d84e5b9a463e8c5d9ad2eebe966f
learning_rate	0.01135212208520884	fd79d84e5b9a463e8c5d9ad2eebe966f
max_depth	7	fd79d84e5b9a463e8c5d9ad2eebe966f
min_child_samples	51	fd79d84e5b9a463e8c5d9ad2eebe966f
min_child_weight	0.001	fd79d84e5b9a463e8c5d9ad2eebe966f
min_split_gain	0.631200506904325	fd79d84e5b9a463e8c5d9ad2eebe966f
num_leaves	44	fd79d84e5b9a463e8c5d9ad2eebe966f
random_state	42	fd79d84e5b9a463e8c5d9ad2eebe966f
reg_alpha	0.03559635429439679	fd79d84e5b9a463e8c5d9ad2eebe966f
reg_lambda	0.02747843162368718	fd79d84e5b9a463e8c5d9ad2eebe966f
subsample	0.935457427357381	fd79d84e5b9a463e8c5d9ad2eebe966f
subsample_for_bin	200000	fd79d84e5b9a463e8c5d9ad2eebe966f
subsample_freq	0	fd79d84e5b9a463e8c5d9ad2eebe966f
metric	['None']	fd79d84e5b9a463e8c5d9ad2eebe966f
verbosity	-1	fd79d84e5b9a463e8c5d9ad2eebe966f
scale_pos_weight	14.052365305208294	fd79d84e5b9a463e8c5d9ad2eebe966f
objective	binary	fd79d84e5b9a463e8c5d9ad2eebe966f
num_threads	12	fd79d84e5b9a463e8c5d9ad2eebe966f
num_boost_round	1300	fd79d84e5b9a463e8c5d9ad2eebe966f
feature_name	auto	fd79d84e5b9a463e8c5d9ad2eebe966f
categorical_feature	auto	fd79d84e5b9a463e8c5d9ad2eebe966f
keep_training_booster	False	fd79d84e5b9a463e8c5d9ad2eebe966f
boosting_type	gbdt	bd4a6462eb314b5cb3c57f9db508a4e4
colsample_bytree	0.6063738944447375	bd4a6462eb314b5cb3c57f9db508a4e4
learning_rate	0.009980456667119145	bd4a6462eb314b5cb3c57f9db508a4e4
max_depth	8	bd4a6462eb314b5cb3c57f9db508a4e4
min_child_samples	150	bd4a6462eb314b5cb3c57f9db508a4e4
min_child_weight	0.001	bd4a6462eb314b5cb3c57f9db508a4e4
min_split_gain	0.7885286174547826	bd4a6462eb314b5cb3c57f9db508a4e4
num_leaves	51	bd4a6462eb314b5cb3c57f9db508a4e4
random_state	42	bd4a6462eb314b5cb3c57f9db508a4e4
reg_alpha	0.00023392462802900862	bd4a6462eb314b5cb3c57f9db508a4e4
reg_lambda	0.003962240303367272	bd4a6462eb314b5cb3c57f9db508a4e4
subsample	0.7849879832047355	bd4a6462eb314b5cb3c57f9db508a4e4
subsample_for_bin	200000	bd4a6462eb314b5cb3c57f9db508a4e4
subsample_freq	0	bd4a6462eb314b5cb3c57f9db508a4e4
metric	['None']	bd4a6462eb314b5cb3c57f9db508a4e4
verbosity	-1	bd4a6462eb314b5cb3c57f9db508a4e4
scale_pos_weight	8.222483243259754	bd4a6462eb314b5cb3c57f9db508a4e4
objective	binary	bd4a6462eb314b5cb3c57f9db508a4e4
num_threads	12	bd4a6462eb314b5cb3c57f9db508a4e4
num_boost_round	2000	bd4a6462eb314b5cb3c57f9db508a4e4
feature_name	auto	bd4a6462eb314b5cb3c57f9db508a4e4
categorical_feature	auto	bd4a6462eb314b5cb3c57f9db508a4e4
keep_training_booster	False	bd4a6462eb314b5cb3c57f9db508a4e4
boosting_type	gbdt	3405dcc6ebdd44609d0d260aa28f3122
colsample_bytree	0.5058810922284768	3405dcc6ebdd44609d0d260aa28f3122
learning_rate	0.03201485514653126	3405dcc6ebdd44609d0d260aa28f3122
max_depth	10	3405dcc6ebdd44609d0d260aa28f3122
min_child_samples	65	3405dcc6ebdd44609d0d260aa28f3122
min_child_weight	0.001	3405dcc6ebdd44609d0d260aa28f3122
min_split_gain	0.4266027325896275	3405dcc6ebdd44609d0d260aa28f3122
num_leaves	57	3405dcc6ebdd44609d0d260aa28f3122
random_state	42	3405dcc6ebdd44609d0d260aa28f3122
reg_alpha	0.0014691883642611358	3405dcc6ebdd44609d0d260aa28f3122
reg_lambda	1.4184298102701466e-05	3405dcc6ebdd44609d0d260aa28f3122
subsample	0.93376891683751	3405dcc6ebdd44609d0d260aa28f3122
subsample_for_bin	200000	3405dcc6ebdd44609d0d260aa28f3122
subsample_freq	0	3405dcc6ebdd44609d0d260aa28f3122
metric	['None']	3405dcc6ebdd44609d0d260aa28f3122
verbosity	-1	3405dcc6ebdd44609d0d260aa28f3122
scale_pos_weight	9.518469608693069	3405dcc6ebdd44609d0d260aa28f3122
objective	binary	3405dcc6ebdd44609d0d260aa28f3122
num_threads	12	3405dcc6ebdd44609d0d260aa28f3122
num_boost_round	1000	3405dcc6ebdd44609d0d260aa28f3122
feature_name	auto	3405dcc6ebdd44609d0d260aa28f3122
categorical_feature	auto	3405dcc6ebdd44609d0d260aa28f3122
keep_training_booster	False	3405dcc6ebdd44609d0d260aa28f3122
boosting_type	gbdt	ee5e81cfc9ad4fda8222a171057e4ffc
colsample_bytree	0.6640480380506635	ee5e81cfc9ad4fda8222a171057e4ffc
learning_rate	0.0542669012687501	ee5e81cfc9ad4fda8222a171057e4ffc
max_depth	11	ee5e81cfc9ad4fda8222a171057e4ffc
min_child_samples	36	ee5e81cfc9ad4fda8222a171057e4ffc
min_child_weight	0.001	ee5e81cfc9ad4fda8222a171057e4ffc
min_split_gain	0.510577522899833	ee5e81cfc9ad4fda8222a171057e4ffc
num_leaves	127	ee5e81cfc9ad4fda8222a171057e4ffc
random_state	42	ee5e81cfc9ad4fda8222a171057e4ffc
reg_alpha	0.00793077558059099	ee5e81cfc9ad4fda8222a171057e4ffc
reg_lambda	0.0001791159768191704	ee5e81cfc9ad4fda8222a171057e4ffc
subsample	0.9594046418647678	ee5e81cfc9ad4fda8222a171057e4ffc
subsample_for_bin	200000	ee5e81cfc9ad4fda8222a171057e4ffc
subsample_freq	0	ee5e81cfc9ad4fda8222a171057e4ffc
metric	['None']	ee5e81cfc9ad4fda8222a171057e4ffc
verbosity	-1	ee5e81cfc9ad4fda8222a171057e4ffc
scale_pos_weight	14.225780581224148	ee5e81cfc9ad4fda8222a171057e4ffc
objective	binary	ee5e81cfc9ad4fda8222a171057e4ffc
num_threads	12	ee5e81cfc9ad4fda8222a171057e4ffc
num_boost_round	1600	ee5e81cfc9ad4fda8222a171057e4ffc
feature_name	auto	ee5e81cfc9ad4fda8222a171057e4ffc
categorical_feature	auto	ee5e81cfc9ad4fda8222a171057e4ffc
keep_training_booster	False	ee5e81cfc9ad4fda8222a171057e4ffc
boosting_type	gbdt	cca09d0a7a824be1b885d47ad28e10a4
colsample_bytree	0.5822687207576418	cca09d0a7a824be1b885d47ad28e10a4
learning_rate	0.027238676074925496	cca09d0a7a824be1b885d47ad28e10a4
max_depth	10	cca09d0a7a824be1b885d47ad28e10a4
min_child_samples	149	cca09d0a7a824be1b885d47ad28e10a4
min_child_weight	0.001	cca09d0a7a824be1b885d47ad28e10a4
min_split_gain	0.8126937384850643	cca09d0a7a824be1b885d47ad28e10a4
num_leaves	33	cca09d0a7a824be1b885d47ad28e10a4
random_state	42	cca09d0a7a824be1b885d47ad28e10a4
reg_alpha	0.018891887672315342	cca09d0a7a824be1b885d47ad28e10a4
reg_lambda	0.2947369556759584	cca09d0a7a824be1b885d47ad28e10a4
subsample	0.8179689535344578	cca09d0a7a824be1b885d47ad28e10a4
subsample_for_bin	200000	cca09d0a7a824be1b885d47ad28e10a4
subsample_freq	0	cca09d0a7a824be1b885d47ad28e10a4
metric	['None']	cca09d0a7a824be1b885d47ad28e10a4
verbosity	-1	cca09d0a7a824be1b885d47ad28e10a4
scale_pos_weight	10.508927955823541	cca09d0a7a824be1b885d47ad28e10a4
objective	binary	cca09d0a7a824be1b885d47ad28e10a4
num_threads	12	cca09d0a7a824be1b885d47ad28e10a4
num_boost_round	1900	cca09d0a7a824be1b885d47ad28e10a4
feature_name	auto	cca09d0a7a824be1b885d47ad28e10a4
categorical_feature	auto	cca09d0a7a824be1b885d47ad28e10a4
keep_training_booster	False	cca09d0a7a824be1b885d47ad28e10a4
boosting_type	gbdt	8d81437cc3714f6982ae885c3c81bacf
colsample_bytree	0.733986330835854	8d81437cc3714f6982ae885c3c81bacf
learning_rate	0.011885561792700805	8d81437cc3714f6982ae885c3c81bacf
max_depth	9	8d81437cc3714f6982ae885c3c81bacf
min_child_samples	184	8d81437cc3714f6982ae885c3c81bacf
min_child_weight	0.001	8d81437cc3714f6982ae885c3c81bacf
min_split_gain	0.765478108744752	8d81437cc3714f6982ae885c3c81bacf
num_leaves	31	8d81437cc3714f6982ae885c3c81bacf
random_state	42	8d81437cc3714f6982ae885c3c81bacf
reg_alpha	0.005861204116212288	8d81437cc3714f6982ae885c3c81bacf
reg_lambda	0.01500404779678781	8d81437cc3714f6982ae885c3c81bacf
subsample	0.6534310646381599	8d81437cc3714f6982ae885c3c81bacf
subsample_for_bin	200000	8d81437cc3714f6982ae885c3c81bacf
subsample_freq	0	8d81437cc3714f6982ae885c3c81bacf
metric	['None']	8d81437cc3714f6982ae885c3c81bacf
verbosity	-1	8d81437cc3714f6982ae885c3c81bacf
scale_pos_weight	6.594652790323598	8d81437cc3714f6982ae885c3c81bacf
objective	binary	8d81437cc3714f6982ae885c3c81bacf
num_threads	12	8d81437cc3714f6982ae885c3c81bacf
num_boost_round	1400	8d81437cc3714f6982ae885c3c81bacf
feature_name	auto	8d81437cc3714f6982ae885c3c81bacf
categorical_feature	auto	8d81437cc3714f6982ae885c3c81bacf
keep_training_booster	False	8d81437cc3714f6982ae885c3c81bacf
boosting_type	gbdt	3e09014e17a84af3b1624fa0068fa0a7
colsample_bytree	0.7713904253608797	3e09014e17a84af3b1624fa0068fa0a7
learning_rate	0.014314710225791748	3e09014e17a84af3b1624fa0068fa0a7
max_depth	6	3e09014e17a84af3b1624fa0068fa0a7
min_child_samples	160	3e09014e17a84af3b1624fa0068fa0a7
min_child_weight	0.001	3e09014e17a84af3b1624fa0068fa0a7
min_split_gain	0.8490916758402642	3e09014e17a84af3b1624fa0068fa0a7
num_leaves	68	3e09014e17a84af3b1624fa0068fa0a7
random_state	42	3e09014e17a84af3b1624fa0068fa0a7
reg_alpha	0.0014640277404793485	3e09014e17a84af3b1624fa0068fa0a7
reg_lambda	1.7642216340319755e-05	3e09014e17a84af3b1624fa0068fa0a7
subsample	0.7552715822244092	3e09014e17a84af3b1624fa0068fa0a7
subsample_for_bin	200000	3e09014e17a84af3b1624fa0068fa0a7
subsample_freq	0	3e09014e17a84af3b1624fa0068fa0a7
metric	['None']	3e09014e17a84af3b1624fa0068fa0a7
verbosity	-1	3e09014e17a84af3b1624fa0068fa0a7
scale_pos_weight	7.3848575200011135	3e09014e17a84af3b1624fa0068fa0a7
objective	binary	3e09014e17a84af3b1624fa0068fa0a7
num_threads	12	3e09014e17a84af3b1624fa0068fa0a7
num_boost_round	1300	3e09014e17a84af3b1624fa0068fa0a7
feature_name	auto	3e09014e17a84af3b1624fa0068fa0a7
categorical_feature	auto	3e09014e17a84af3b1624fa0068fa0a7
keep_training_booster	False	3e09014e17a84af3b1624fa0068fa0a7
boosting_type	gbdt	c599cc0f5ca645e989b7478887d03f28
colsample_bytree	0.5736529769710234	c599cc0f5ca645e989b7478887d03f28
learning_rate	0.008023028997542335	c599cc0f5ca645e989b7478887d03f28
max_depth	12	c599cc0f5ca645e989b7478887d03f28
min_child_samples	155	c599cc0f5ca645e989b7478887d03f28
min_child_weight	0.001	c599cc0f5ca645e989b7478887d03f28
min_split_gain	0.9049568700508089	c599cc0f5ca645e989b7478887d03f28
num_leaves	45	c599cc0f5ca645e989b7478887d03f28
random_state	42	c599cc0f5ca645e989b7478887d03f28
reg_alpha	0.015199158102265898	c599cc0f5ca645e989b7478887d03f28
reg_lambda	0.0019086872282237251	c599cc0f5ca645e989b7478887d03f28
subsample	0.7782522480729215	c599cc0f5ca645e989b7478887d03f28
subsample_for_bin	200000	c599cc0f5ca645e989b7478887d03f28
subsample_freq	0	c599cc0f5ca645e989b7478887d03f28
metric	['None']	c599cc0f5ca645e989b7478887d03f28
verbosity	-1	c599cc0f5ca645e989b7478887d03f28
scale_pos_weight	6.701493375685155	c599cc0f5ca645e989b7478887d03f28
objective	binary	c599cc0f5ca645e989b7478887d03f28
num_threads	12	c599cc0f5ca645e989b7478887d03f28
num_boost_round	2000	c599cc0f5ca645e989b7478887d03f28
feature_name	auto	c599cc0f5ca645e989b7478887d03f28
categorical_feature	auto	c599cc0f5ca645e989b7478887d03f28
keep_training_booster	False	c599cc0f5ca645e989b7478887d03f28
boosting_type	gbdt	de0278a9f23d4eea946bc673a797c3c2
colsample_bytree	0.5878377701142659	de0278a9f23d4eea946bc673a797c3c2
learning_rate	0.011169126659351512	de0278a9f23d4eea946bc673a797c3c2
max_depth	10	de0278a9f23d4eea946bc673a797c3c2
min_child_samples	61	de0278a9f23d4eea946bc673a797c3c2
min_child_weight	0.001	de0278a9f23d4eea946bc673a797c3c2
min_split_gain	0.6538129649523259	de0278a9f23d4eea946bc673a797c3c2
num_leaves	44	de0278a9f23d4eea946bc673a797c3c2
random_state	42	de0278a9f23d4eea946bc673a797c3c2
reg_alpha	0.00037423090145040957	de0278a9f23d4eea946bc673a797c3c2
reg_lambda	0.7575055664022463	de0278a9f23d4eea946bc673a797c3c2
subsample	0.7550110091275205	de0278a9f23d4eea946bc673a797c3c2
subsample_for_bin	200000	de0278a9f23d4eea946bc673a797c3c2
subsample_freq	0	de0278a9f23d4eea946bc673a797c3c2
metric	['None']	de0278a9f23d4eea946bc673a797c3c2
verbosity	-1	de0278a9f23d4eea946bc673a797c3c2
scale_pos_weight	5.95804305674549	de0278a9f23d4eea946bc673a797c3c2
objective	binary	de0278a9f23d4eea946bc673a797c3c2
num_threads	12	de0278a9f23d4eea946bc673a797c3c2
num_boost_round	1900	de0278a9f23d4eea946bc673a797c3c2
feature_name	auto	de0278a9f23d4eea946bc673a797c3c2
categorical_feature	auto	de0278a9f23d4eea946bc673a797c3c2
keep_training_booster	False	de0278a9f23d4eea946bc673a797c3c2
boosting_type	gbdt	200e44c932ce4dad8671cd5da9b409d9
colsample_bytree	0.6242306861526586	200e44c932ce4dad8671cd5da9b409d9
learning_rate	0.02451615807219685	200e44c932ce4dad8671cd5da9b409d9
max_depth	8	200e44c932ce4dad8671cd5da9b409d9
min_child_samples	98	200e44c932ce4dad8671cd5da9b409d9
min_child_weight	0.001	200e44c932ce4dad8671cd5da9b409d9
min_split_gain	0.9967598855271436	200e44c932ce4dad8671cd5da9b409d9
num_leaves	76	200e44c932ce4dad8671cd5da9b409d9
random_state	42	200e44c932ce4dad8671cd5da9b409d9
reg_alpha	0.012613214242061929	200e44c932ce4dad8671cd5da9b409d9
reg_lambda	0.005870416798250251	200e44c932ce4dad8671cd5da9b409d9
subsample	0.8497482441803571	200e44c932ce4dad8671cd5da9b409d9
subsample_for_bin	200000	200e44c932ce4dad8671cd5da9b409d9
subsample_freq	0	200e44c932ce4dad8671cd5da9b409d9
metric	['None']	200e44c932ce4dad8671cd5da9b409d9
verbosity	-1	200e44c932ce4dad8671cd5da9b409d9
scale_pos_weight	13.825716811510357	200e44c932ce4dad8671cd5da9b409d9
objective	binary	200e44c932ce4dad8671cd5da9b409d9
num_threads	12	200e44c932ce4dad8671cd5da9b409d9
num_boost_round	1500	200e44c932ce4dad8671cd5da9b409d9
feature_name	auto	200e44c932ce4dad8671cd5da9b409d9
categorical_feature	auto	200e44c932ce4dad8671cd5da9b409d9
keep_training_booster	False	200e44c932ce4dad8671cd5da9b409d9
boosting_type	gbdt	130f444dde0c42df9f6abc1bd79d9b77
colsample_bytree	0.514551586985151	130f444dde0c42df9f6abc1bd79d9b77
learning_rate	0.010114316589159072	130f444dde0c42df9f6abc1bd79d9b77
max_depth	10	130f444dde0c42df9f6abc1bd79d9b77
min_child_samples	113	130f444dde0c42df9f6abc1bd79d9b77
min_child_weight	0.001	130f444dde0c42df9f6abc1bd79d9b77
min_split_gain	0.9637933147437198	130f444dde0c42df9f6abc1bd79d9b77
num_leaves	22	130f444dde0c42df9f6abc1bd79d9b77
random_state	42	130f444dde0c42df9f6abc1bd79d9b77
reg_alpha	0.3766847971574277	130f444dde0c42df9f6abc1bd79d9b77
reg_lambda	2.085708540703966e-05	130f444dde0c42df9f6abc1bd79d9b77
subsample	0.9008205975465168	130f444dde0c42df9f6abc1bd79d9b77
subsample_for_bin	200000	130f444dde0c42df9f6abc1bd79d9b77
subsample_freq	0	130f444dde0c42df9f6abc1bd79d9b77
metric	['None']	130f444dde0c42df9f6abc1bd79d9b77
verbosity	-1	130f444dde0c42df9f6abc1bd79d9b77
scale_pos_weight	9.548391782950576	130f444dde0c42df9f6abc1bd79d9b77
objective	binary	130f444dde0c42df9f6abc1bd79d9b77
num_threads	12	130f444dde0c42df9f6abc1bd79d9b77
num_boost_round	1700	130f444dde0c42df9f6abc1bd79d9b77
feature_name	auto	130f444dde0c42df9f6abc1bd79d9b77
categorical_feature	auto	130f444dde0c42df9f6abc1bd79d9b77
keep_training_booster	False	130f444dde0c42df9f6abc1bd79d9b77
boosting_type	gbdt	117e0e60760d44ac9ef154cceb212171
colsample_bytree	0.7483566753371147	117e0e60760d44ac9ef154cceb212171
learning_rate	0.012660760147665819	117e0e60760d44ac9ef154cceb212171
max_depth	7	117e0e60760d44ac9ef154cceb212171
min_child_samples	178	117e0e60760d44ac9ef154cceb212171
min_child_weight	0.001	117e0e60760d44ac9ef154cceb212171
min_split_gain	0.9260868171506578	117e0e60760d44ac9ef154cceb212171
num_leaves	24	117e0e60760d44ac9ef154cceb212171
random_state	42	117e0e60760d44ac9ef154cceb212171
reg_alpha	0.4580099151857546	117e0e60760d44ac9ef154cceb212171
reg_lambda	0.0003866894914373545	117e0e60760d44ac9ef154cceb212171
subsample	0.7335303237949943	117e0e60760d44ac9ef154cceb212171
subsample_for_bin	200000	117e0e60760d44ac9ef154cceb212171
subsample_freq	0	117e0e60760d44ac9ef154cceb212171
metric	['None']	117e0e60760d44ac9ef154cceb212171
verbosity	-1	117e0e60760d44ac9ef154cceb212171
scale_pos_weight	6.722732379979262	117e0e60760d44ac9ef154cceb212171
objective	binary	117e0e60760d44ac9ef154cceb212171
num_threads	12	117e0e60760d44ac9ef154cceb212171
num_boost_round	1500	117e0e60760d44ac9ef154cceb212171
feature_name	auto	117e0e60760d44ac9ef154cceb212171
categorical_feature	auto	117e0e60760d44ac9ef154cceb212171
keep_training_booster	False	117e0e60760d44ac9ef154cceb212171
boosting_type	gbdt	cd47568195194bd4b3b7f694f1a08f9a
colsample_bytree	0.650045271562327	cd47568195194bd4b3b7f694f1a08f9a
learning_rate	0.1973874477568451	cd47568195194bd4b3b7f694f1a08f9a
max_depth	5	cd47568195194bd4b3b7f694f1a08f9a
min_child_samples	60	cd47568195194bd4b3b7f694f1a08f9a
min_child_weight	0.001	cd47568195194bd4b3b7f694f1a08f9a
min_split_gain	0.2279683596150731	cd47568195194bd4b3b7f694f1a08f9a
num_leaves	44	cd47568195194bd4b3b7f694f1a08f9a
random_state	42	cd47568195194bd4b3b7f694f1a08f9a
reg_alpha	0.271309678784822	cd47568195194bd4b3b7f694f1a08f9a
reg_lambda	5.691403097475019e-05	cd47568195194bd4b3b7f694f1a08f9a
subsample	0.724176515946681	cd47568195194bd4b3b7f694f1a08f9a
subsample_for_bin	200000	cd47568195194bd4b3b7f694f1a08f9a
subsample_freq	0	cd47568195194bd4b3b7f694f1a08f9a
metric	['None']	cd47568195194bd4b3b7f694f1a08f9a
verbosity	-1	cd47568195194bd4b3b7f694f1a08f9a
scale_pos_weight	13.747096054574826	cd47568195194bd4b3b7f694f1a08f9a
objective	binary	cd47568195194bd4b3b7f694f1a08f9a
num_threads	12	cd47568195194bd4b3b7f694f1a08f9a
num_boost_round	700	cd47568195194bd4b3b7f694f1a08f9a
feature_name	auto	cd47568195194bd4b3b7f694f1a08f9a
categorical_feature	auto	cd47568195194bd4b3b7f694f1a08f9a
keep_training_booster	False	cd47568195194bd4b3b7f694f1a08f9a
boosting_type	gbdt	e3ca2557a9f543f7952783569ae86534
colsample_bytree	0.590756234039426	e3ca2557a9f543f7952783569ae86534
learning_rate	0.018587752792006054	e3ca2557a9f543f7952783569ae86534
max_depth	8	e3ca2557a9f543f7952783569ae86534
min_child_samples	78	e3ca2557a9f543f7952783569ae86534
min_child_weight	0.001	e3ca2557a9f543f7952783569ae86534
min_split_gain	0.6159799435147645	e3ca2557a9f543f7952783569ae86534
num_leaves	21	e3ca2557a9f543f7952783569ae86534
random_state	42	e3ca2557a9f543f7952783569ae86534
reg_alpha	4.80060073200805e-05	e3ca2557a9f543f7952783569ae86534
reg_lambda	8.924710265839636e-06	e3ca2557a9f543f7952783569ae86534
subsample	0.9147550720518165	e3ca2557a9f543f7952783569ae86534
subsample_for_bin	200000	e3ca2557a9f543f7952783569ae86534
subsample_freq	0	e3ca2557a9f543f7952783569ae86534
metric	['None']	e3ca2557a9f543f7952783569ae86534
verbosity	-1	e3ca2557a9f543f7952783569ae86534
scale_pos_weight	15.227494779177537	e3ca2557a9f543f7952783569ae86534
objective	binary	e3ca2557a9f543f7952783569ae86534
num_threads	12	e3ca2557a9f543f7952783569ae86534
num_boost_round	1200	e3ca2557a9f543f7952783569ae86534
feature_name	auto	e3ca2557a9f543f7952783569ae86534
categorical_feature	auto	e3ca2557a9f543f7952783569ae86534
keep_training_booster	False	e3ca2557a9f543f7952783569ae86534
boosting_type	gbdt	2ad9ddee054f4a0fa0c5e251a177dd6a
colsample_bytree	0.5447611110390245	2ad9ddee054f4a0fa0c5e251a177dd6a
learning_rate	0.007375391396898292	2ad9ddee054f4a0fa0c5e251a177dd6a
max_depth	10	2ad9ddee054f4a0fa0c5e251a177dd6a
min_child_samples	145	2ad9ddee054f4a0fa0c5e251a177dd6a
min_child_weight	0.001	2ad9ddee054f4a0fa0c5e251a177dd6a
min_split_gain	0.7234412856344183	2ad9ddee054f4a0fa0c5e251a177dd6a
num_leaves	25	2ad9ddee054f4a0fa0c5e251a177dd6a
random_state	42	2ad9ddee054f4a0fa0c5e251a177dd6a
reg_alpha	5.0861565202877	2ad9ddee054f4a0fa0c5e251a177dd6a
reg_lambda	2.024159385259417e-06	2ad9ddee054f4a0fa0c5e251a177dd6a
subsample	0.6920980987079451	2ad9ddee054f4a0fa0c5e251a177dd6a
subsample_for_bin	200000	2ad9ddee054f4a0fa0c5e251a177dd6a
subsample_freq	0	2ad9ddee054f4a0fa0c5e251a177dd6a
metric	['None']	2ad9ddee054f4a0fa0c5e251a177dd6a
verbosity	-1	2ad9ddee054f4a0fa0c5e251a177dd6a
scale_pos_weight	7.116475404068116	2ad9ddee054f4a0fa0c5e251a177dd6a
objective	binary	2ad9ddee054f4a0fa0c5e251a177dd6a
num_threads	12	2ad9ddee054f4a0fa0c5e251a177dd6a
num_boost_round	1500	2ad9ddee054f4a0fa0c5e251a177dd6a
feature_name	auto	2ad9ddee054f4a0fa0c5e251a177dd6a
categorical_feature	auto	2ad9ddee054f4a0fa0c5e251a177dd6a
keep_training_booster	False	2ad9ddee054f4a0fa0c5e251a177dd6a
boosting_type	gbdt	62ca7fadf67347b29ca9598d327eebd2
colsample_bytree	0.7526911343277014	62ca7fadf67347b29ca9598d327eebd2
learning_rate	0.009422638566587553	62ca7fadf67347b29ca9598d327eebd2
max_depth	9	62ca7fadf67347b29ca9598d327eebd2
min_child_samples	161	62ca7fadf67347b29ca9598d327eebd2
min_child_weight	0.001	62ca7fadf67347b29ca9598d327eebd2
min_split_gain	0.9176693133289302	62ca7fadf67347b29ca9598d327eebd2
num_leaves	28	62ca7fadf67347b29ca9598d327eebd2
random_state	42	62ca7fadf67347b29ca9598d327eebd2
reg_alpha	0.1820653468526353	62ca7fadf67347b29ca9598d327eebd2
reg_lambda	0.003215616853907577	62ca7fadf67347b29ca9598d327eebd2
subsample	0.7778479329600754	62ca7fadf67347b29ca9598d327eebd2
subsample_for_bin	200000	62ca7fadf67347b29ca9598d327eebd2
subsample_freq	0	62ca7fadf67347b29ca9598d327eebd2
metric	['None']	62ca7fadf67347b29ca9598d327eebd2
verbosity	-1	62ca7fadf67347b29ca9598d327eebd2
scale_pos_weight	8.562822517725856	62ca7fadf67347b29ca9598d327eebd2
objective	binary	62ca7fadf67347b29ca9598d327eebd2
num_threads	12	62ca7fadf67347b29ca9598d327eebd2
num_boost_round	1100	62ca7fadf67347b29ca9598d327eebd2
feature_name	auto	62ca7fadf67347b29ca9598d327eebd2
categorical_feature	auto	62ca7fadf67347b29ca9598d327eebd2
keep_training_booster	False	62ca7fadf67347b29ca9598d327eebd2
boosting_type	gbdt	ba4d5a30aa02426d9e1536625f3ebe6a
colsample_bytree	0.515809444813316	ba4d5a30aa02426d9e1536625f3ebe6a
learning_rate	0.019671733810898387	ba4d5a30aa02426d9e1536625f3ebe6a
max_depth	8	ba4d5a30aa02426d9e1536625f3ebe6a
min_child_samples	159	ba4d5a30aa02426d9e1536625f3ebe6a
min_child_weight	0.001	ba4d5a30aa02426d9e1536625f3ebe6a
min_split_gain	0.8504483722930862	ba4d5a30aa02426d9e1536625f3ebe6a
num_leaves	45	ba4d5a30aa02426d9e1536625f3ebe6a
random_state	42	ba4d5a30aa02426d9e1536625f3ebe6a
reg_alpha	0.5742528351921208	ba4d5a30aa02426d9e1536625f3ebe6a
reg_lambda	0.0005765448325228298	ba4d5a30aa02426d9e1536625f3ebe6a
subsample	0.7992174808417942	ba4d5a30aa02426d9e1536625f3ebe6a
subsample_for_bin	200000	ba4d5a30aa02426d9e1536625f3ebe6a
subsample_freq	0	ba4d5a30aa02426d9e1536625f3ebe6a
metric	['None']	ba4d5a30aa02426d9e1536625f3ebe6a
verbosity	-1	ba4d5a30aa02426d9e1536625f3ebe6a
scale_pos_weight	8.278015932164617	ba4d5a30aa02426d9e1536625f3ebe6a
objective	binary	ba4d5a30aa02426d9e1536625f3ebe6a
num_threads	12	ba4d5a30aa02426d9e1536625f3ebe6a
num_boost_round	1800	ba4d5a30aa02426d9e1536625f3ebe6a
feature_name	auto	ba4d5a30aa02426d9e1536625f3ebe6a
categorical_feature	auto	ba4d5a30aa02426d9e1536625f3ebe6a
keep_training_booster	False	ba4d5a30aa02426d9e1536625f3ebe6a
boosting_type	gbdt	98d0deba9dd641d281274cbf802081fb
colsample_bytree	0.7508387850512054	98d0deba9dd641d281274cbf802081fb
learning_rate	0.09311251758748842	98d0deba9dd641d281274cbf802081fb
max_depth	3	98d0deba9dd641d281274cbf802081fb
min_child_samples	58	98d0deba9dd641d281274cbf802081fb
min_child_weight	0.001	98d0deba9dd641d281274cbf802081fb
min_split_gain	0.2021253035351069	98d0deba9dd641d281274cbf802081fb
num_leaves	32	98d0deba9dd641d281274cbf802081fb
random_state	42	98d0deba9dd641d281274cbf802081fb
reg_alpha	6.751646079254488	98d0deba9dd641d281274cbf802081fb
reg_lambda	0.00011141608884005852	98d0deba9dd641d281274cbf802081fb
subsample	0.792132680728726	98d0deba9dd641d281274cbf802081fb
subsample_for_bin	200000	98d0deba9dd641d281274cbf802081fb
subsample_freq	0	98d0deba9dd641d281274cbf802081fb
metric	['None']	98d0deba9dd641d281274cbf802081fb
verbosity	-1	98d0deba9dd641d281274cbf802081fb
scale_pos_weight	9.51017897512216	98d0deba9dd641d281274cbf802081fb
objective	binary	98d0deba9dd641d281274cbf802081fb
num_threads	12	98d0deba9dd641d281274cbf802081fb
num_boost_round	400	98d0deba9dd641d281274cbf802081fb
feature_name	auto	98d0deba9dd641d281274cbf802081fb
categorical_feature	auto	98d0deba9dd641d281274cbf802081fb
keep_training_booster	False	98d0deba9dd641d281274cbf802081fb
boosting_type	gbdt	30bde976c0b84a36b835f3d18848103c
colsample_bytree	0.8127305598929422	30bde976c0b84a36b835f3d18848103c
learning_rate	0.02312592998782562	30bde976c0b84a36b835f3d18848103c
max_depth	4	30bde976c0b84a36b835f3d18848103c
min_child_samples	123	30bde976c0b84a36b835f3d18848103c
min_child_weight	0.001	30bde976c0b84a36b835f3d18848103c
min_split_gain	0.8826374975823396	30bde976c0b84a36b835f3d18848103c
num_leaves	32	30bde976c0b84a36b835f3d18848103c
random_state	42	30bde976c0b84a36b835f3d18848103c
reg_alpha	0.1518187224504486	30bde976c0b84a36b835f3d18848103c
reg_lambda	5.761909981599147e-06	30bde976c0b84a36b835f3d18848103c
subsample	0.7422577880610672	30bde976c0b84a36b835f3d18848103c
subsample_for_bin	200000	30bde976c0b84a36b835f3d18848103c
subsample_freq	0	30bde976c0b84a36b835f3d18848103c
metric	['None']	30bde976c0b84a36b835f3d18848103c
verbosity	-1	30bde976c0b84a36b835f3d18848103c
scale_pos_weight	8.906567493104951	30bde976c0b84a36b835f3d18848103c
objective	binary	30bde976c0b84a36b835f3d18848103c
num_threads	12	30bde976c0b84a36b835f3d18848103c
num_boost_round	1200	30bde976c0b84a36b835f3d18848103c
feature_name	auto	30bde976c0b84a36b835f3d18848103c
categorical_feature	auto	30bde976c0b84a36b835f3d18848103c
keep_training_booster	False	30bde976c0b84a36b835f3d18848103c
boosting_type	gbdt	b4689faec3f7445fbe0ba427b0859231
colsample_bytree	0.5545564050583209	b4689faec3f7445fbe0ba427b0859231
learning_rate	0.07641338815442512	b4689faec3f7445fbe0ba427b0859231
max_depth	5	b4689faec3f7445fbe0ba427b0859231
min_child_samples	50	b4689faec3f7445fbe0ba427b0859231
min_child_weight	0.001	b4689faec3f7445fbe0ba427b0859231
min_split_gain	0.6807139917707304	b4689faec3f7445fbe0ba427b0859231
num_leaves	77	b4689faec3f7445fbe0ba427b0859231
random_state	42	b4689faec3f7445fbe0ba427b0859231
reg_alpha	1.089690289680184	b4689faec3f7445fbe0ba427b0859231
reg_lambda	1.1556402629758683e-07	b4689faec3f7445fbe0ba427b0859231
subsample	0.9070063445386135	b4689faec3f7445fbe0ba427b0859231
subsample_for_bin	200000	b4689faec3f7445fbe0ba427b0859231
subsample_freq	0	b4689faec3f7445fbe0ba427b0859231
metric	['None']	b4689faec3f7445fbe0ba427b0859231
verbosity	-1	b4689faec3f7445fbe0ba427b0859231
scale_pos_weight	17.254205056894392	b4689faec3f7445fbe0ba427b0859231
objective	binary	b4689faec3f7445fbe0ba427b0859231
num_threads	12	b4689faec3f7445fbe0ba427b0859231
num_boost_round	300	b4689faec3f7445fbe0ba427b0859231
feature_name	auto	b4689faec3f7445fbe0ba427b0859231
categorical_feature	auto	b4689faec3f7445fbe0ba427b0859231
keep_training_booster	False	b4689faec3f7445fbe0ba427b0859231
boosting_type	gbdt	aa9da8551d8a425785523304e9c547f3
colsample_bytree	0.5119641565057074	aa9da8551d8a425785523304e9c547f3
learning_rate	0.04416612191568167	aa9da8551d8a425785523304e9c547f3
max_depth	11	aa9da8551d8a425785523304e9c547f3
min_child_samples	90	aa9da8551d8a425785523304e9c547f3
min_child_weight	0.001	aa9da8551d8a425785523304e9c547f3
min_split_gain	0.22993725057021241	aa9da8551d8a425785523304e9c547f3
num_leaves	69	aa9da8551d8a425785523304e9c547f3
random_state	42	aa9da8551d8a425785523304e9c547f3
reg_alpha	0.1255069026492738	aa9da8551d8a425785523304e9c547f3
reg_lambda	1.8494862367894857e-05	aa9da8551d8a425785523304e9c547f3
subsample	0.9078931381591626	aa9da8551d8a425785523304e9c547f3
subsample_for_bin	200000	aa9da8551d8a425785523304e9c547f3
subsample_freq	0	aa9da8551d8a425785523304e9c547f3
metric	['None']	aa9da8551d8a425785523304e9c547f3
verbosity	-1	aa9da8551d8a425785523304e9c547f3
scale_pos_weight	20.301009107047037	aa9da8551d8a425785523304e9c547f3
objective	binary	aa9da8551d8a425785523304e9c547f3
num_threads	12	aa9da8551d8a425785523304e9c547f3
num_boost_round	1500	aa9da8551d8a425785523304e9c547f3
feature_name	auto	aa9da8551d8a425785523304e9c547f3
categorical_feature	auto	aa9da8551d8a425785523304e9c547f3
keep_training_booster	False	aa9da8551d8a425785523304e9c547f3
boosting_type	gbdt	f9ede5de86ea4f9b8ac1a181ddd36d72
colsample_bytree	0.6025952501670364	f9ede5de86ea4f9b8ac1a181ddd36d72
learning_rate	0.00704967062413391	f9ede5de86ea4f9b8ac1a181ddd36d72
max_depth	7	f9ede5de86ea4f9b8ac1a181ddd36d72
min_child_samples	72	f9ede5de86ea4f9b8ac1a181ddd36d72
min_child_weight	0.001	f9ede5de86ea4f9b8ac1a181ddd36d72
min_split_gain	0.4865343237463503	f9ede5de86ea4f9b8ac1a181ddd36d72
num_leaves	24	f9ede5de86ea4f9b8ac1a181ddd36d72
random_state	42	f9ede5de86ea4f9b8ac1a181ddd36d72
reg_alpha	0.0011326543252314278	f9ede5de86ea4f9b8ac1a181ddd36d72
reg_lambda	0.009071443083022148	f9ede5de86ea4f9b8ac1a181ddd36d72
subsample	0.8690666440180973	f9ede5de86ea4f9b8ac1a181ddd36d72
subsample_for_bin	200000	f9ede5de86ea4f9b8ac1a181ddd36d72
subsample_freq	0	f9ede5de86ea4f9b8ac1a181ddd36d72
metric	['None']	f9ede5de86ea4f9b8ac1a181ddd36d72
verbosity	-1	f9ede5de86ea4f9b8ac1a181ddd36d72
scale_pos_weight	6.949926933491424	f9ede5de86ea4f9b8ac1a181ddd36d72
objective	binary	f9ede5de86ea4f9b8ac1a181ddd36d72
num_threads	12	f9ede5de86ea4f9b8ac1a181ddd36d72
num_boost_round	1900	f9ede5de86ea4f9b8ac1a181ddd36d72
feature_name	auto	f9ede5de86ea4f9b8ac1a181ddd36d72
categorical_feature	auto	f9ede5de86ea4f9b8ac1a181ddd36d72
keep_training_booster	False	f9ede5de86ea4f9b8ac1a181ddd36d72
boosting_type	gbdt	569e3af54f5549d389c2817c8ccf9823
colsample_bytree	0.557611539770609	569e3af54f5549d389c2817c8ccf9823
learning_rate	0.009003684200253352	569e3af54f5549d389c2817c8ccf9823
max_depth	7	569e3af54f5549d389c2817c8ccf9823
min_child_samples	54	569e3af54f5549d389c2817c8ccf9823
min_child_weight	0.001	569e3af54f5549d389c2817c8ccf9823
min_split_gain	0.9710587128820266	569e3af54f5549d389c2817c8ccf9823
num_leaves	126	569e3af54f5549d389c2817c8ccf9823
random_state	42	569e3af54f5549d389c2817c8ccf9823
reg_alpha	0.0028659059580175067	569e3af54f5549d389c2817c8ccf9823
reg_lambda	0.021255984222569878	569e3af54f5549d389c2817c8ccf9823
subsample	0.7750488511568043	569e3af54f5549d389c2817c8ccf9823
subsample_for_bin	200000	569e3af54f5549d389c2817c8ccf9823
subsample_freq	0	569e3af54f5549d389c2817c8ccf9823
metric	['None']	569e3af54f5549d389c2817c8ccf9823
verbosity	-1	569e3af54f5549d389c2817c8ccf9823
scale_pos_weight	6.160281889582822	569e3af54f5549d389c2817c8ccf9823
objective	binary	569e3af54f5549d389c2817c8ccf9823
num_threads	12	569e3af54f5549d389c2817c8ccf9823
num_boost_round	1700	569e3af54f5549d389c2817c8ccf9823
feature_name	auto	569e3af54f5549d389c2817c8ccf9823
categorical_feature	auto	569e3af54f5549d389c2817c8ccf9823
keep_training_booster	False	569e3af54f5549d389c2817c8ccf9823
boosting_type	gbdt	f0d12270c17441cb82afdc0ff9f70809
colsample_bytree	0.646304759632159	f0d12270c17441cb82afdc0ff9f70809
learning_rate	0.008223124165150744	f0d12270c17441cb82afdc0ff9f70809
max_depth	8	f0d12270c17441cb82afdc0ff9f70809
min_child_samples	83	f0d12270c17441cb82afdc0ff9f70809
min_child_weight	0.001	f0d12270c17441cb82afdc0ff9f70809
min_split_gain	0.5636001148409445	f0d12270c17441cb82afdc0ff9f70809
num_leaves	38	f0d12270c17441cb82afdc0ff9f70809
random_state	42	f0d12270c17441cb82afdc0ff9f70809
reg_alpha	1.964440235472728e-06	f0d12270c17441cb82afdc0ff9f70809
reg_lambda	3.853512645517251	f0d12270c17441cb82afdc0ff9f70809
subsample	0.7054099328933197	f0d12270c17441cb82afdc0ff9f70809
subsample_for_bin	200000	f0d12270c17441cb82afdc0ff9f70809
subsample_freq	0	f0d12270c17441cb82afdc0ff9f70809
metric	['None']	f0d12270c17441cb82afdc0ff9f70809
verbosity	-1	f0d12270c17441cb82afdc0ff9f70809
scale_pos_weight	8.154331026305538	f0d12270c17441cb82afdc0ff9f70809
objective	binary	f0d12270c17441cb82afdc0ff9f70809
num_threads	12	f0d12270c17441cb82afdc0ff9f70809
num_boost_round	1700	f0d12270c17441cb82afdc0ff9f70809
feature_name	auto	f0d12270c17441cb82afdc0ff9f70809
categorical_feature	auto	f0d12270c17441cb82afdc0ff9f70809
keep_training_booster	False	f0d12270c17441cb82afdc0ff9f70809
boosting_type	gbdt	eb16c82079fd4ba591d99f8201df04d1
colsample_bytree	0.5535978865341082	eb16c82079fd4ba591d99f8201df04d1
learning_rate	0.02365173861848883	eb16c82079fd4ba591d99f8201df04d1
max_depth	11	eb16c82079fd4ba591d99f8201df04d1
min_child_samples	177	eb16c82079fd4ba591d99f8201df04d1
min_child_weight	0.001	eb16c82079fd4ba591d99f8201df04d1
min_split_gain	0.6271306451351905	eb16c82079fd4ba591d99f8201df04d1
num_leaves	41	eb16c82079fd4ba591d99f8201df04d1
random_state	42	eb16c82079fd4ba591d99f8201df04d1
reg_alpha	0.21411902543135894	eb16c82079fd4ba591d99f8201df04d1
reg_lambda	8.600215498827504e-05	eb16c82079fd4ba591d99f8201df04d1
subsample	0.9726094111173599	eb16c82079fd4ba591d99f8201df04d1
subsample_for_bin	200000	eb16c82079fd4ba591d99f8201df04d1
subsample_freq	0	eb16c82079fd4ba591d99f8201df04d1
metric	['None']	eb16c82079fd4ba591d99f8201df04d1
verbosity	-1	eb16c82079fd4ba591d99f8201df04d1
scale_pos_weight	13.095959853978172	eb16c82079fd4ba591d99f8201df04d1
objective	binary	eb16c82079fd4ba591d99f8201df04d1
num_threads	12	eb16c82079fd4ba591d99f8201df04d1
num_boost_round	1600	eb16c82079fd4ba591d99f8201df04d1
feature_name	auto	eb16c82079fd4ba591d99f8201df04d1
categorical_feature	auto	eb16c82079fd4ba591d99f8201df04d1
keep_training_booster	False	eb16c82079fd4ba591d99f8201df04d1
boosting_type	gbdt	7c916e1a7e7d4b44be04309d6b501d6f
colsample_bytree	0.6209429299254621	7c916e1a7e7d4b44be04309d6b501d6f
learning_rate	0.04199216895299991	7c916e1a7e7d4b44be04309d6b501d6f
max_depth	4	7c916e1a7e7d4b44be04309d6b501d6f
min_child_samples	131	7c916e1a7e7d4b44be04309d6b501d6f
min_child_weight	0.001	7c916e1a7e7d4b44be04309d6b501d6f
min_split_gain	0.17745973872042142	7c916e1a7e7d4b44be04309d6b501d6f
num_leaves	46	7c916e1a7e7d4b44be04309d6b501d6f
random_state	42	7c916e1a7e7d4b44be04309d6b501d6f
reg_alpha	0.13827385194719252	7c916e1a7e7d4b44be04309d6b501d6f
reg_lambda	4.006310459040347e-06	7c916e1a7e7d4b44be04309d6b501d6f
subsample	0.838425295289261	7c916e1a7e7d4b44be04309d6b501d6f
subsample_for_bin	200000	7c916e1a7e7d4b44be04309d6b501d6f
subsample_freq	0	7c916e1a7e7d4b44be04309d6b501d6f
metric	['None']	7c916e1a7e7d4b44be04309d6b501d6f
verbosity	-1	7c916e1a7e7d4b44be04309d6b501d6f
scale_pos_weight	16.521433048585088	7c916e1a7e7d4b44be04309d6b501d6f
objective	binary	7c916e1a7e7d4b44be04309d6b501d6f
num_threads	12	7c916e1a7e7d4b44be04309d6b501d6f
num_boost_round	400	7c916e1a7e7d4b44be04309d6b501d6f
feature_name	auto	7c916e1a7e7d4b44be04309d6b501d6f
categorical_feature	auto	7c916e1a7e7d4b44be04309d6b501d6f
keep_training_booster	False	7c916e1a7e7d4b44be04309d6b501d6f
boosting_type	gbdt	52e3ecc8bd264c6bb75dd7e13c9c3713
colsample_bytree	0.5018656773178228	52e3ecc8bd264c6bb75dd7e13c9c3713
learning_rate	0.011819945850761397	52e3ecc8bd264c6bb75dd7e13c9c3713
max_depth	12	52e3ecc8bd264c6bb75dd7e13c9c3713
min_child_samples	33	52e3ecc8bd264c6bb75dd7e13c9c3713
min_child_weight	0.001	52e3ecc8bd264c6bb75dd7e13c9c3713
min_split_gain	0.6694687290852026	52e3ecc8bd264c6bb75dd7e13c9c3713
num_leaves	65	52e3ecc8bd264c6bb75dd7e13c9c3713
random_state	42	52e3ecc8bd264c6bb75dd7e13c9c3713
reg_alpha	0.00016577828400570795	52e3ecc8bd264c6bb75dd7e13c9c3713
reg_lambda	4.445816310549661	52e3ecc8bd264c6bb75dd7e13c9c3713
subsample	0.718292413684184	52e3ecc8bd264c6bb75dd7e13c9c3713
subsample_for_bin	200000	52e3ecc8bd264c6bb75dd7e13c9c3713
subsample_freq	0	52e3ecc8bd264c6bb75dd7e13c9c3713
metric	['None']	52e3ecc8bd264c6bb75dd7e13c9c3713
verbosity	-1	52e3ecc8bd264c6bb75dd7e13c9c3713
scale_pos_weight	5.95889372654137	52e3ecc8bd264c6bb75dd7e13c9c3713
objective	binary	52e3ecc8bd264c6bb75dd7e13c9c3713
num_threads	12	52e3ecc8bd264c6bb75dd7e13c9c3713
num_boost_round	1700	52e3ecc8bd264c6bb75dd7e13c9c3713
feature_name	auto	52e3ecc8bd264c6bb75dd7e13c9c3713
categorical_feature	auto	52e3ecc8bd264c6bb75dd7e13c9c3713
keep_training_booster	False	52e3ecc8bd264c6bb75dd7e13c9c3713
boosting_type	gbdt	2e7a3710bd5e4ee2ad9d870e16e43be0
colsample_bytree	0.5063770853216771	2e7a3710bd5e4ee2ad9d870e16e43be0
learning_rate	0.030349274056853212	2e7a3710bd5e4ee2ad9d870e16e43be0
max_depth	9	2e7a3710bd5e4ee2ad9d870e16e43be0
min_child_samples	50	2e7a3710bd5e4ee2ad9d870e16e43be0
min_child_weight	0.001	2e7a3710bd5e4ee2ad9d870e16e43be0
min_split_gain	0.9839648971472656	2e7a3710bd5e4ee2ad9d870e16e43be0
num_leaves	66	2e7a3710bd5e4ee2ad9d870e16e43be0
random_state	42	2e7a3710bd5e4ee2ad9d870e16e43be0
reg_alpha	2.7412104337658824e-05	2e7a3710bd5e4ee2ad9d870e16e43be0
reg_lambda	0.8589908145846848	2e7a3710bd5e4ee2ad9d870e16e43be0
subsample	0.6247819423095022	2e7a3710bd5e4ee2ad9d870e16e43be0
subsample_for_bin	200000	2e7a3710bd5e4ee2ad9d870e16e43be0
subsample_freq	0	2e7a3710bd5e4ee2ad9d870e16e43be0
metric	['None']	2e7a3710bd5e4ee2ad9d870e16e43be0
verbosity	-1	2e7a3710bd5e4ee2ad9d870e16e43be0
scale_pos_weight	5.795465292257733	2e7a3710bd5e4ee2ad9d870e16e43be0
objective	binary	2e7a3710bd5e4ee2ad9d870e16e43be0
num_threads	12	2e7a3710bd5e4ee2ad9d870e16e43be0
num_boost_round	1400	2e7a3710bd5e4ee2ad9d870e16e43be0
feature_name	auto	2e7a3710bd5e4ee2ad9d870e16e43be0
categorical_feature	auto	2e7a3710bd5e4ee2ad9d870e16e43be0
keep_training_booster	False	2e7a3710bd5e4ee2ad9d870e16e43be0
boosting_type	gbdt	c2a98b6d06ba4b14ac81cdaaacee8d9b
colsample_bytree	0.572605366894961	c2a98b6d06ba4b14ac81cdaaacee8d9b
learning_rate	0.011452825703095923	c2a98b6d06ba4b14ac81cdaaacee8d9b
max_depth	10	c2a98b6d06ba4b14ac81cdaaacee8d9b
min_child_samples	149	c2a98b6d06ba4b14ac81cdaaacee8d9b
min_child_weight	0.001	c2a98b6d06ba4b14ac81cdaaacee8d9b
min_split_gain	0.5940328373415352	c2a98b6d06ba4b14ac81cdaaacee8d9b
num_leaves	24	c2a98b6d06ba4b14ac81cdaaacee8d9b
random_state	42	c2a98b6d06ba4b14ac81cdaaacee8d9b
reg_alpha	0.09284874644789747	c2a98b6d06ba4b14ac81cdaaacee8d9b
reg_lambda	0.0073751124068874	c2a98b6d06ba4b14ac81cdaaacee8d9b
subsample	0.9607917349109154	c2a98b6d06ba4b14ac81cdaaacee8d9b
subsample_for_bin	200000	c2a98b6d06ba4b14ac81cdaaacee8d9b
subsample_freq	0	c2a98b6d06ba4b14ac81cdaaacee8d9b
metric	['None']	c2a98b6d06ba4b14ac81cdaaacee8d9b
verbosity	-1	c2a98b6d06ba4b14ac81cdaaacee8d9b
scale_pos_weight	8.187623799515526	c2a98b6d06ba4b14ac81cdaaacee8d9b
objective	binary	c2a98b6d06ba4b14ac81cdaaacee8d9b
num_threads	12	c2a98b6d06ba4b14ac81cdaaacee8d9b
num_boost_round	1700	c2a98b6d06ba4b14ac81cdaaacee8d9b
feature_name	auto	c2a98b6d06ba4b14ac81cdaaacee8d9b
categorical_feature	auto	c2a98b6d06ba4b14ac81cdaaacee8d9b
keep_training_booster	False	c2a98b6d06ba4b14ac81cdaaacee8d9b
boosting_type	gbdt	f4eb85ac7f484c7b9665388a9a0d3e8f
colsample_bytree	0.5740984549483329	f4eb85ac7f484c7b9665388a9a0d3e8f
learning_rate	0.013736040656752163	f4eb85ac7f484c7b9665388a9a0d3e8f
max_depth	11	f4eb85ac7f484c7b9665388a9a0d3e8f
min_child_samples	125	f4eb85ac7f484c7b9665388a9a0d3e8f
min_child_weight	0.001	f4eb85ac7f484c7b9665388a9a0d3e8f
min_split_gain	0.6607870808005711	f4eb85ac7f484c7b9665388a9a0d3e8f
num_leaves	74	f4eb85ac7f484c7b9665388a9a0d3e8f
random_state	42	f4eb85ac7f484c7b9665388a9a0d3e8f
reg_alpha	0.03331165427188687	f4eb85ac7f484c7b9665388a9a0d3e8f
reg_lambda	0.002623199658697043	f4eb85ac7f484c7b9665388a9a0d3e8f
subsample	0.9458619012234757	f4eb85ac7f484c7b9665388a9a0d3e8f
subsample_for_bin	200000	f4eb85ac7f484c7b9665388a9a0d3e8f
subsample_freq	0	f4eb85ac7f484c7b9665388a9a0d3e8f
metric	['None']	f4eb85ac7f484c7b9665388a9a0d3e8f
verbosity	-1	f4eb85ac7f484c7b9665388a9a0d3e8f
scale_pos_weight	9.840612643779203	f4eb85ac7f484c7b9665388a9a0d3e8f
objective	binary	f4eb85ac7f484c7b9665388a9a0d3e8f
num_threads	12	f4eb85ac7f484c7b9665388a9a0d3e8f
num_boost_round	1800	f4eb85ac7f484c7b9665388a9a0d3e8f
feature_name	auto	f4eb85ac7f484c7b9665388a9a0d3e8f
categorical_feature	auto	f4eb85ac7f484c7b9665388a9a0d3e8f
keep_training_booster	False	f4eb85ac7f484c7b9665388a9a0d3e8f
boosting_type	gbdt	d3f4b439155d4a1f8452de974a8fd530
colsample_bytree	0.5226400837872687	d3f4b439155d4a1f8452de974a8fd530
learning_rate	0.018000762793129902	d3f4b439155d4a1f8452de974a8fd530
max_depth	12	d3f4b439155d4a1f8452de974a8fd530
min_child_samples	43	d3f4b439155d4a1f8452de974a8fd530
min_child_weight	0.001	d3f4b439155d4a1f8452de974a8fd530
min_split_gain	0.7903502993641182	d3f4b439155d4a1f8452de974a8fd530
num_leaves	43	d3f4b439155d4a1f8452de974a8fd530
random_state	42	d3f4b439155d4a1f8452de974a8fd530
reg_alpha	0.0002817157767953278	d3f4b439155d4a1f8452de974a8fd530
reg_lambda	0.21999801842146954	d3f4b439155d4a1f8452de974a8fd530
subsample	0.7604548953317878	d3f4b439155d4a1f8452de974a8fd530
subsample_for_bin	200000	d3f4b439155d4a1f8452de974a8fd530
subsample_freq	0	d3f4b439155d4a1f8452de974a8fd530
metric	['None']	d3f4b439155d4a1f8452de974a8fd530
verbosity	-1	d3f4b439155d4a1f8452de974a8fd530
scale_pos_weight	6.939917398196654	d3f4b439155d4a1f8452de974a8fd530
objective	binary	d3f4b439155d4a1f8452de974a8fd530
num_threads	12	d3f4b439155d4a1f8452de974a8fd530
num_boost_round	1800	d3f4b439155d4a1f8452de974a8fd530
feature_name	auto	d3f4b439155d4a1f8452de974a8fd530
categorical_feature	auto	d3f4b439155d4a1f8452de974a8fd530
keep_training_booster	False	d3f4b439155d4a1f8452de974a8fd530
boosting_type	gbdt	2d0fdb5b0ebe4654b38066951cec3ae8
colsample_bytree	0.5214717092766936	2d0fdb5b0ebe4654b38066951cec3ae8
learning_rate	0.028747222759102135	2d0fdb5b0ebe4654b38066951cec3ae8
max_depth	11	2d0fdb5b0ebe4654b38066951cec3ae8
min_child_samples	66	2d0fdb5b0ebe4654b38066951cec3ae8
min_child_weight	0.001	2d0fdb5b0ebe4654b38066951cec3ae8
min_split_gain	0.5236076266695184	2d0fdb5b0ebe4654b38066951cec3ae8
num_leaves	135	2d0fdb5b0ebe4654b38066951cec3ae8
random_state	42	2d0fdb5b0ebe4654b38066951cec3ae8
reg_alpha	0.0003093065857857488	2d0fdb5b0ebe4654b38066951cec3ae8
reg_lambda	1.507955631260532	2d0fdb5b0ebe4654b38066951cec3ae8
subsample	0.73307059430347	2d0fdb5b0ebe4654b38066951cec3ae8
subsample_for_bin	200000	2d0fdb5b0ebe4654b38066951cec3ae8
subsample_freq	0	2d0fdb5b0ebe4654b38066951cec3ae8
metric	['None']	2d0fdb5b0ebe4654b38066951cec3ae8
verbosity	-1	2d0fdb5b0ebe4654b38066951cec3ae8
scale_pos_weight	6.958456437464818	2d0fdb5b0ebe4654b38066951cec3ae8
objective	binary	2d0fdb5b0ebe4654b38066951cec3ae8
num_threads	12	2d0fdb5b0ebe4654b38066951cec3ae8
num_boost_round	1600	2d0fdb5b0ebe4654b38066951cec3ae8
feature_name	auto	2d0fdb5b0ebe4654b38066951cec3ae8
categorical_feature	auto	2d0fdb5b0ebe4654b38066951cec3ae8
keep_training_booster	False	2d0fdb5b0ebe4654b38066951cec3ae8
boosting_type	gbdt	d6ab3fd3b7be407a86383f867d0d3987
colsample_bytree	0.508249344206506	d6ab3fd3b7be407a86383f867d0d3987
learning_rate	0.011293954395889557	d6ab3fd3b7be407a86383f867d0d3987
max_depth	11	d6ab3fd3b7be407a86383f867d0d3987
min_child_samples	50	d6ab3fd3b7be407a86383f867d0d3987
min_child_weight	0.001	d6ab3fd3b7be407a86383f867d0d3987
min_split_gain	0.6258946699000524	d6ab3fd3b7be407a86383f867d0d3987
num_leaves	90	d6ab3fd3b7be407a86383f867d0d3987
random_state	42	d6ab3fd3b7be407a86383f867d0d3987
reg_alpha	9.515342638575556e-07	d6ab3fd3b7be407a86383f867d0d3987
reg_lambda	1.846478427868903	d6ab3fd3b7be407a86383f867d0d3987
subsample	0.653546568161646	d6ab3fd3b7be407a86383f867d0d3987
subsample_for_bin	200000	d6ab3fd3b7be407a86383f867d0d3987
subsample_freq	0	d6ab3fd3b7be407a86383f867d0d3987
metric	['None']	d6ab3fd3b7be407a86383f867d0d3987
verbosity	-1	d6ab3fd3b7be407a86383f867d0d3987
scale_pos_weight	6.284034416713881	d6ab3fd3b7be407a86383f867d0d3987
objective	binary	d6ab3fd3b7be407a86383f867d0d3987
num_threads	12	d6ab3fd3b7be407a86383f867d0d3987
num_boost_round	2000	d6ab3fd3b7be407a86383f867d0d3987
feature_name	auto	d6ab3fd3b7be407a86383f867d0d3987
categorical_feature	auto	d6ab3fd3b7be407a86383f867d0d3987
keep_training_booster	False	d6ab3fd3b7be407a86383f867d0d3987
boosting_type	gbdt	571b8fa9bdad427a9816b5b5144622ef
colsample_bytree	0.5247634002430699	571b8fa9bdad427a9816b5b5144622ef
learning_rate	0.036811925059417085	571b8fa9bdad427a9816b5b5144622ef
max_depth	11	571b8fa9bdad427a9816b5b5144622ef
min_child_samples	107	571b8fa9bdad427a9816b5b5144622ef
min_child_weight	0.001	571b8fa9bdad427a9816b5b5144622ef
min_split_gain	0.48393020425200994	571b8fa9bdad427a9816b5b5144622ef
num_leaves	22	571b8fa9bdad427a9816b5b5144622ef
random_state	42	571b8fa9bdad427a9816b5b5144622ef
reg_alpha	5.879024399375716e-05	571b8fa9bdad427a9816b5b5144622ef
reg_lambda	0.0012533359535508196	571b8fa9bdad427a9816b5b5144622ef
subsample	0.9322635967108934	571b8fa9bdad427a9816b5b5144622ef
subsample_for_bin	200000	571b8fa9bdad427a9816b5b5144622ef
subsample_freq	0	571b8fa9bdad427a9816b5b5144622ef
metric	['None']	571b8fa9bdad427a9816b5b5144622ef
verbosity	-1	571b8fa9bdad427a9816b5b5144622ef
scale_pos_weight	11.254566001503637	571b8fa9bdad427a9816b5b5144622ef
objective	binary	571b8fa9bdad427a9816b5b5144622ef
num_threads	12	571b8fa9bdad427a9816b5b5144622ef
num_boost_round	1900	571b8fa9bdad427a9816b5b5144622ef
feature_name	auto	571b8fa9bdad427a9816b5b5144622ef
categorical_feature	auto	571b8fa9bdad427a9816b5b5144622ef
keep_training_booster	False	571b8fa9bdad427a9816b5b5144622ef
boosting_type	gbdt	11b06d8ded174450aaa0563cd01e2137
colsample_bytree	0.5099557704341822	11b06d8ded174450aaa0563cd01e2137
learning_rate	0.019101544614712737	11b06d8ded174450aaa0563cd01e2137
max_depth	9	11b06d8ded174450aaa0563cd01e2137
min_child_samples	166	11b06d8ded174450aaa0563cd01e2137
min_child_weight	0.001	11b06d8ded174450aaa0563cd01e2137
min_split_gain	0.8044758185582193	11b06d8ded174450aaa0563cd01e2137
num_leaves	17	11b06d8ded174450aaa0563cd01e2137
random_state	42	11b06d8ded174450aaa0563cd01e2137
reg_alpha	0.03375132419145999	11b06d8ded174450aaa0563cd01e2137
reg_lambda	0.0003533138041734524	11b06d8ded174450aaa0563cd01e2137
subsample	0.7215045212155486	11b06d8ded174450aaa0563cd01e2137
subsample_for_bin	200000	11b06d8ded174450aaa0563cd01e2137
subsample_freq	0	11b06d8ded174450aaa0563cd01e2137
metric	['None']	11b06d8ded174450aaa0563cd01e2137
verbosity	-1	11b06d8ded174450aaa0563cd01e2137
scale_pos_weight	11.101147100020404	11b06d8ded174450aaa0563cd01e2137
objective	binary	11b06d8ded174450aaa0563cd01e2137
num_threads	12	11b06d8ded174450aaa0563cd01e2137
num_boost_round	1100	11b06d8ded174450aaa0563cd01e2137
feature_name	auto	11b06d8ded174450aaa0563cd01e2137
categorical_feature	auto	11b06d8ded174450aaa0563cd01e2137
keep_training_booster	False	11b06d8ded174450aaa0563cd01e2137
boosting_type	gbdt	19c7ae8c940042a9bea5484d5c7a996f
colsample_bytree	0.6667451849720825	19c7ae8c940042a9bea5484d5c7a996f
learning_rate	0.0908144035876354	19c7ae8c940042a9bea5484d5c7a996f
max_depth	3	19c7ae8c940042a9bea5484d5c7a996f
min_child_samples	95	19c7ae8c940042a9bea5484d5c7a996f
min_child_weight	0.001	19c7ae8c940042a9bea5484d5c7a996f
min_split_gain	0.5660734651466586	19c7ae8c940042a9bea5484d5c7a996f
num_leaves	26	19c7ae8c940042a9bea5484d5c7a996f
random_state	42	19c7ae8c940042a9bea5484d5c7a996f
reg_alpha	0.0030213908784066526	19c7ae8c940042a9bea5484d5c7a996f
reg_lambda	1.1928230359367983e-05	19c7ae8c940042a9bea5484d5c7a996f
subsample	0.7525508719918959	19c7ae8c940042a9bea5484d5c7a996f
subsample_for_bin	200000	19c7ae8c940042a9bea5484d5c7a996f
subsample_freq	0	19c7ae8c940042a9bea5484d5c7a996f
metric	['None']	19c7ae8c940042a9bea5484d5c7a996f
verbosity	-1	19c7ae8c940042a9bea5484d5c7a996f
scale_pos_weight	15.396648194254345	19c7ae8c940042a9bea5484d5c7a996f
objective	binary	19c7ae8c940042a9bea5484d5c7a996f
num_threads	12	19c7ae8c940042a9bea5484d5c7a996f
num_boost_round	700	19c7ae8c940042a9bea5484d5c7a996f
feature_name	auto	19c7ae8c940042a9bea5484d5c7a996f
categorical_feature	auto	19c7ae8c940042a9bea5484d5c7a996f
keep_training_booster	False	19c7ae8c940042a9bea5484d5c7a996f
boosting_type	gbdt	e9f2cf11fabd4422a3404f41f7e12593
colsample_bytree	0.5736582990276853	e9f2cf11fabd4422a3404f41f7e12593
learning_rate	0.04924378914058314	e9f2cf11fabd4422a3404f41f7e12593
max_depth	10	e9f2cf11fabd4422a3404f41f7e12593
min_child_samples	139	e9f2cf11fabd4422a3404f41f7e12593
min_child_weight	0.001	e9f2cf11fabd4422a3404f41f7e12593
min_split_gain	0.6488953201126991	e9f2cf11fabd4422a3404f41f7e12593
num_leaves	33	e9f2cf11fabd4422a3404f41f7e12593
random_state	42	e9f2cf11fabd4422a3404f41f7e12593
reg_alpha	2.2669201978569267	e9f2cf11fabd4422a3404f41f7e12593
reg_lambda	9.635915157289954e-06	e9f2cf11fabd4422a3404f41f7e12593
subsample	0.9981027591723918	e9f2cf11fabd4422a3404f41f7e12593
subsample_for_bin	200000	e9f2cf11fabd4422a3404f41f7e12593
subsample_freq	0	e9f2cf11fabd4422a3404f41f7e12593
metric	['None']	e9f2cf11fabd4422a3404f41f7e12593
verbosity	-1	e9f2cf11fabd4422a3404f41f7e12593
scale_pos_weight	8.11712892199463	e9f2cf11fabd4422a3404f41f7e12593
objective	binary	e9f2cf11fabd4422a3404f41f7e12593
num_threads	12	e9f2cf11fabd4422a3404f41f7e12593
num_boost_round	1900	e9f2cf11fabd4422a3404f41f7e12593
feature_name	auto	e9f2cf11fabd4422a3404f41f7e12593
categorical_feature	auto	e9f2cf11fabd4422a3404f41f7e12593
keep_training_booster	False	e9f2cf11fabd4422a3404f41f7e12593
boosting_type	gbdt	3e93389d94ca40148d153412a6cddbcb
colsample_bytree	0.5785513326495632	3e93389d94ca40148d153412a6cddbcb
learning_rate	0.030526536964541457	3e93389d94ca40148d153412a6cddbcb
max_depth	11	3e93389d94ca40148d153412a6cddbcb
min_child_samples	123	3e93389d94ca40148d153412a6cddbcb
min_child_weight	0.001	3e93389d94ca40148d153412a6cddbcb
min_split_gain	0.7025218673990258	3e93389d94ca40148d153412a6cddbcb
num_leaves	62	3e93389d94ca40148d153412a6cddbcb
random_state	42	3e93389d94ca40148d153412a6cddbcb
reg_alpha	0.8355043027982066	3e93389d94ca40148d153412a6cddbcb
reg_lambda	0.0072543589930273555	3e93389d94ca40148d153412a6cddbcb
subsample	0.8911287866718725	3e93389d94ca40148d153412a6cddbcb
subsample_for_bin	200000	3e93389d94ca40148d153412a6cddbcb
subsample_freq	0	3e93389d94ca40148d153412a6cddbcb
metric	['None']	3e93389d94ca40148d153412a6cddbcb
verbosity	-1	3e93389d94ca40148d153412a6cddbcb
scale_pos_weight	14.952112474180426	3e93389d94ca40148d153412a6cddbcb
objective	binary	3e93389d94ca40148d153412a6cddbcb
num_threads	12	3e93389d94ca40148d153412a6cddbcb
num_boost_round	1200	3e93389d94ca40148d153412a6cddbcb
feature_name	auto	3e93389d94ca40148d153412a6cddbcb
categorical_feature	auto	3e93389d94ca40148d153412a6cddbcb
keep_training_booster	False	3e93389d94ca40148d153412a6cddbcb
boosting_type	gbdt	fea20651e3e744068c1d02e03e73f652
colsample_bytree	0.5135318802128952	fea20651e3e744068c1d02e03e73f652
learning_rate	0.024201092445476694	fea20651e3e744068c1d02e03e73f652
max_depth	11	fea20651e3e744068c1d02e03e73f652
min_child_samples	160	fea20651e3e744068c1d02e03e73f652
min_child_weight	0.001	fea20651e3e744068c1d02e03e73f652
min_split_gain	0.6338874409454974	fea20651e3e744068c1d02e03e73f652
num_leaves	20	fea20651e3e744068c1d02e03e73f652
random_state	42	fea20651e3e744068c1d02e03e73f652
reg_alpha	1.3308507075818699	fea20651e3e744068c1d02e03e73f652
reg_lambda	0.0011684804054293352	fea20651e3e744068c1d02e03e73f652
subsample	0.988825396142518	fea20651e3e744068c1d02e03e73f652
subsample_for_bin	200000	fea20651e3e744068c1d02e03e73f652
subsample_freq	0	fea20651e3e744068c1d02e03e73f652
metric	['None']	fea20651e3e744068c1d02e03e73f652
verbosity	-1	fea20651e3e744068c1d02e03e73f652
scale_pos_weight	11.351331709156439	fea20651e3e744068c1d02e03e73f652
objective	binary	fea20651e3e744068c1d02e03e73f652
num_threads	12	fea20651e3e744068c1d02e03e73f652
num_boost_round	1700	fea20651e3e744068c1d02e03e73f652
feature_name	auto	fea20651e3e744068c1d02e03e73f652
categorical_feature	auto	fea20651e3e744068c1d02e03e73f652
keep_training_booster	False	fea20651e3e744068c1d02e03e73f652
boosting_type	gbdt	87f145f9b3b4496f901df95d56e470b8
colsample_bytree	0.6354677847305555	87f145f9b3b4496f901df95d56e470b8
learning_rate	0.03424635531298697	87f145f9b3b4496f901df95d56e470b8
max_depth	12	87f145f9b3b4496f901df95d56e470b8
min_child_samples	186	87f145f9b3b4496f901df95d56e470b8
min_child_weight	0.001	87f145f9b3b4496f901df95d56e470b8
min_split_gain	0.39600550746304564	87f145f9b3b4496f901df95d56e470b8
num_leaves	16	87f145f9b3b4496f901df95d56e470b8
random_state	42	87f145f9b3b4496f901df95d56e470b8
reg_alpha	2.976588749845515	87f145f9b3b4496f901df95d56e470b8
reg_lambda	0.00014697558336513155	87f145f9b3b4496f901df95d56e470b8
subsample	0.9486354199968638	87f145f9b3b4496f901df95d56e470b8
subsample_for_bin	200000	87f145f9b3b4496f901df95d56e470b8
subsample_freq	0	87f145f9b3b4496f901df95d56e470b8
metric	['None']	87f145f9b3b4496f901df95d56e470b8
verbosity	-1	87f145f9b3b4496f901df95d56e470b8
scale_pos_weight	8.89558665437483	87f145f9b3b4496f901df95d56e470b8
objective	binary	87f145f9b3b4496f901df95d56e470b8
num_threads	12	87f145f9b3b4496f901df95d56e470b8
num_boost_round	1400	87f145f9b3b4496f901df95d56e470b8
feature_name	auto	87f145f9b3b4496f901df95d56e470b8
categorical_feature	auto	87f145f9b3b4496f901df95d56e470b8
keep_training_booster	False	87f145f9b3b4496f901df95d56e470b8
boosting_type	gbdt	35ea2431d44b4d5197234e1257f742e7
colsample_bytree	0.545032103754449	35ea2431d44b4d5197234e1257f742e7
learning_rate	0.012250368446755736	35ea2431d44b4d5197234e1257f742e7
max_depth	11	35ea2431d44b4d5197234e1257f742e7
min_child_samples	189	35ea2431d44b4d5197234e1257f742e7
min_child_weight	0.001	35ea2431d44b4d5197234e1257f742e7
min_split_gain	0.8899156550092469	35ea2431d44b4d5197234e1257f742e7
num_leaves	20	35ea2431d44b4d5197234e1257f742e7
random_state	42	35ea2431d44b4d5197234e1257f742e7
reg_alpha	0.13352104374037735	35ea2431d44b4d5197234e1257f742e7
reg_lambda	0.03877636988376764	35ea2431d44b4d5197234e1257f742e7
subsample	0.8497471292045536	35ea2431d44b4d5197234e1257f742e7
subsample_for_bin	200000	35ea2431d44b4d5197234e1257f742e7
subsample_freq	0	35ea2431d44b4d5197234e1257f742e7
metric	['None']	35ea2431d44b4d5197234e1257f742e7
verbosity	-1	35ea2431d44b4d5197234e1257f742e7
scale_pos_weight	9.873374339376017	35ea2431d44b4d5197234e1257f742e7
objective	binary	35ea2431d44b4d5197234e1257f742e7
num_threads	12	35ea2431d44b4d5197234e1257f742e7
num_boost_round	1400	35ea2431d44b4d5197234e1257f742e7
feature_name	auto	35ea2431d44b4d5197234e1257f742e7
categorical_feature	auto	35ea2431d44b4d5197234e1257f742e7
keep_training_booster	False	35ea2431d44b4d5197234e1257f742e7
boosting_type	gbdt	c23e0bcb7b334d3aae37f42aa4aaa09d
colsample_bytree	0.677132363052244	c23e0bcb7b334d3aae37f42aa4aaa09d
learning_rate	0.011529736061585031	c23e0bcb7b334d3aae37f42aa4aaa09d
max_depth	10	c23e0bcb7b334d3aae37f42aa4aaa09d
min_child_samples	131	c23e0bcb7b334d3aae37f42aa4aaa09d
min_child_weight	0.001	c23e0bcb7b334d3aae37f42aa4aaa09d
min_split_gain	0.5152534279778256	c23e0bcb7b334d3aae37f42aa4aaa09d
num_leaves	46	c23e0bcb7b334d3aae37f42aa4aaa09d
random_state	42	c23e0bcb7b334d3aae37f42aa4aaa09d
reg_alpha	0.10504240666728291	c23e0bcb7b334d3aae37f42aa4aaa09d
reg_lambda	0.45862301894757956	c23e0bcb7b334d3aae37f42aa4aaa09d
subsample	0.9731510084174848	c23e0bcb7b334d3aae37f42aa4aaa09d
subsample_for_bin	200000	c23e0bcb7b334d3aae37f42aa4aaa09d
subsample_freq	0	c23e0bcb7b334d3aae37f42aa4aaa09d
metric	['None']	c23e0bcb7b334d3aae37f42aa4aaa09d
verbosity	-1	c23e0bcb7b334d3aae37f42aa4aaa09d
scale_pos_weight	7.67312393632328	c23e0bcb7b334d3aae37f42aa4aaa09d
objective	binary	c23e0bcb7b334d3aae37f42aa4aaa09d
num_threads	12	c23e0bcb7b334d3aae37f42aa4aaa09d
num_boost_round	1600	c23e0bcb7b334d3aae37f42aa4aaa09d
feature_name	auto	c23e0bcb7b334d3aae37f42aa4aaa09d
categorical_feature	auto	c23e0bcb7b334d3aae37f42aa4aaa09d
keep_training_booster	False	c23e0bcb7b334d3aae37f42aa4aaa09d
boosting_type	gbdt	faefe080fefc45eabc2137abcdf3ef0c
colsample_bytree	0.6155803521801907	faefe080fefc45eabc2137abcdf3ef0c
learning_rate	0.007219238402990219	faefe080fefc45eabc2137abcdf3ef0c
max_depth	8	faefe080fefc45eabc2137abcdf3ef0c
min_child_samples	181	faefe080fefc45eabc2137abcdf3ef0c
min_child_weight	0.001	faefe080fefc45eabc2137abcdf3ef0c
min_split_gain	0.7688352266542714	faefe080fefc45eabc2137abcdf3ef0c
num_leaves	38	faefe080fefc45eabc2137abcdf3ef0c
random_state	42	faefe080fefc45eabc2137abcdf3ef0c
reg_alpha	0.09014609898504795	faefe080fefc45eabc2137abcdf3ef0c
reg_lambda	8.732256180530879e-05	faefe080fefc45eabc2137abcdf3ef0c
subsample	0.8360384926366266	faefe080fefc45eabc2137abcdf3ef0c
subsample_for_bin	200000	faefe080fefc45eabc2137abcdf3ef0c
subsample_freq	0	faefe080fefc45eabc2137abcdf3ef0c
metric	['None']	faefe080fefc45eabc2137abcdf3ef0c
verbosity	-1	faefe080fefc45eabc2137abcdf3ef0c
scale_pos_weight	5.710284392267491	faefe080fefc45eabc2137abcdf3ef0c
objective	binary	faefe080fefc45eabc2137abcdf3ef0c
num_threads	12	faefe080fefc45eabc2137abcdf3ef0c
num_boost_round	1600	faefe080fefc45eabc2137abcdf3ef0c
feature_name	auto	faefe080fefc45eabc2137abcdf3ef0c
categorical_feature	auto	faefe080fefc45eabc2137abcdf3ef0c
keep_training_booster	False	faefe080fefc45eabc2137abcdf3ef0c
boosting_type	gbdt	96479ef023f34b15a8033d9c5657d9dc
colsample_bytree	0.5502767751730292	96479ef023f34b15a8033d9c5657d9dc
learning_rate	0.031747898482494694	96479ef023f34b15a8033d9c5657d9dc
max_depth	11	96479ef023f34b15a8033d9c5657d9dc
min_child_samples	104	96479ef023f34b15a8033d9c5657d9dc
min_child_weight	0.001	96479ef023f34b15a8033d9c5657d9dc
min_split_gain	0.8249814919563143	96479ef023f34b15a8033d9c5657d9dc
num_leaves	27	96479ef023f34b15a8033d9c5657d9dc
random_state	42	96479ef023f34b15a8033d9c5657d9dc
reg_alpha	6.466429577804258	96479ef023f34b15a8033d9c5657d9dc
reg_lambda	0.0018428391264229068	96479ef023f34b15a8033d9c5657d9dc
subsample	0.960016812872005	96479ef023f34b15a8033d9c5657d9dc
subsample_for_bin	200000	96479ef023f34b15a8033d9c5657d9dc
subsample_freq	0	96479ef023f34b15a8033d9c5657d9dc
metric	['None']	96479ef023f34b15a8033d9c5657d9dc
verbosity	-1	96479ef023f34b15a8033d9c5657d9dc
scale_pos_weight	10.772166912738953	96479ef023f34b15a8033d9c5657d9dc
objective	binary	96479ef023f34b15a8033d9c5657d9dc
num_threads	12	96479ef023f34b15a8033d9c5657d9dc
num_boost_round	1400	96479ef023f34b15a8033d9c5657d9dc
feature_name	auto	96479ef023f34b15a8033d9c5657d9dc
categorical_feature	auto	96479ef023f34b15a8033d9c5657d9dc
keep_training_booster	False	96479ef023f34b15a8033d9c5657d9dc
boosting_type	gbdt	a643f1f3cf3147aaa764aafd4114e6ff
colsample_bytree	0.5033854071215006	a643f1f3cf3147aaa764aafd4114e6ff
learning_rate	0.008862463173320258	a643f1f3cf3147aaa764aafd4114e6ff
max_depth	11	a643f1f3cf3147aaa764aafd4114e6ff
min_child_samples	179	a643f1f3cf3147aaa764aafd4114e6ff
min_child_weight	0.001	a643f1f3cf3147aaa764aafd4114e6ff
min_split_gain	0.8635689788159091	a643f1f3cf3147aaa764aafd4114e6ff
num_leaves	31	a643f1f3cf3147aaa764aafd4114e6ff
random_state	42	a643f1f3cf3147aaa764aafd4114e6ff
reg_alpha	0.0017962831710334876	a643f1f3cf3147aaa764aafd4114e6ff
reg_lambda	8.642870093954437e-06	a643f1f3cf3147aaa764aafd4114e6ff
subsample	0.7624618644882202	a643f1f3cf3147aaa764aafd4114e6ff
subsample_for_bin	200000	a643f1f3cf3147aaa764aafd4114e6ff
subsample_freq	0	a643f1f3cf3147aaa764aafd4114e6ff
metric	['None']	a643f1f3cf3147aaa764aafd4114e6ff
verbosity	-1	a643f1f3cf3147aaa764aafd4114e6ff
scale_pos_weight	10.875515427325976	a643f1f3cf3147aaa764aafd4114e6ff
objective	binary	a643f1f3cf3147aaa764aafd4114e6ff
num_threads	12	a643f1f3cf3147aaa764aafd4114e6ff
num_boost_round	1800	a643f1f3cf3147aaa764aafd4114e6ff
feature_name	auto	a643f1f3cf3147aaa764aafd4114e6ff
categorical_feature	auto	a643f1f3cf3147aaa764aafd4114e6ff
keep_training_booster	False	a643f1f3cf3147aaa764aafd4114e6ff
boosting_type	gbdt	1918bf94daa7417a9f9a9bbe2f473d24
colsample_bytree	0.7372665398361368	1918bf94daa7417a9f9a9bbe2f473d24
learning_rate	0.037865780596077536	1918bf94daa7417a9f9a9bbe2f473d24
max_depth	4	1918bf94daa7417a9f9a9bbe2f473d24
min_child_samples	190	1918bf94daa7417a9f9a9bbe2f473d24
min_child_weight	0.001	1918bf94daa7417a9f9a9bbe2f473d24
min_split_gain	0.9643414024502944	1918bf94daa7417a9f9a9bbe2f473d24
num_leaves	28	1918bf94daa7417a9f9a9bbe2f473d24
random_state	42	1918bf94daa7417a9f9a9bbe2f473d24
reg_alpha	1.5549299141606798	1918bf94daa7417a9f9a9bbe2f473d24
reg_lambda	0.0001386723468176686	1918bf94daa7417a9f9a9bbe2f473d24
subsample	0.7917144761952524	1918bf94daa7417a9f9a9bbe2f473d24
subsample_for_bin	200000	1918bf94daa7417a9f9a9bbe2f473d24
subsample_freq	0	1918bf94daa7417a9f9a9bbe2f473d24
metric	['None']	1918bf94daa7417a9f9a9bbe2f473d24
verbosity	-1	1918bf94daa7417a9f9a9bbe2f473d24
scale_pos_weight	6.1245499163963775	1918bf94daa7417a9f9a9bbe2f473d24
objective	binary	1918bf94daa7417a9f9a9bbe2f473d24
num_threads	12	1918bf94daa7417a9f9a9bbe2f473d24
num_boost_round	1400	1918bf94daa7417a9f9a9bbe2f473d24
feature_name	auto	1918bf94daa7417a9f9a9bbe2f473d24
categorical_feature	auto	1918bf94daa7417a9f9a9bbe2f473d24
keep_training_booster	False	1918bf94daa7417a9f9a9bbe2f473d24
boosting_type	gbdt	6975e9f2410b4b48a24bb54de3773f71
colsample_bytree	0.5676893951570642	6975e9f2410b4b48a24bb54de3773f71
learning_rate	0.04776858865868095	6975e9f2410b4b48a24bb54de3773f71
max_depth	12	6975e9f2410b4b48a24bb54de3773f71
min_child_samples	86	6975e9f2410b4b48a24bb54de3773f71
min_child_weight	0.001	6975e9f2410b4b48a24bb54de3773f71
min_split_gain	0.9303167649131846	6975e9f2410b4b48a24bb54de3773f71
num_leaves	87	6975e9f2410b4b48a24bb54de3773f71
random_state	42	6975e9f2410b4b48a24bb54de3773f71
reg_alpha	5.424000251458459	6975e9f2410b4b48a24bb54de3773f71
reg_lambda	1.0384921459132219e-05	6975e9f2410b4b48a24bb54de3773f71
subsample	0.9438150078917156	6975e9f2410b4b48a24bb54de3773f71
subsample_for_bin	200000	6975e9f2410b4b48a24bb54de3773f71
subsample_freq	0	6975e9f2410b4b48a24bb54de3773f71
metric	['None']	6975e9f2410b4b48a24bb54de3773f71
verbosity	-1	6975e9f2410b4b48a24bb54de3773f71
scale_pos_weight	12.33280769612754	6975e9f2410b4b48a24bb54de3773f71
objective	binary	6975e9f2410b4b48a24bb54de3773f71
num_threads	12	6975e9f2410b4b48a24bb54de3773f71
num_boost_round	1400	6975e9f2410b4b48a24bb54de3773f71
feature_name	auto	6975e9f2410b4b48a24bb54de3773f71
categorical_feature	auto	6975e9f2410b4b48a24bb54de3773f71
keep_training_booster	False	6975e9f2410b4b48a24bb54de3773f71
boosting_type	gbdt	e4ff17e0741440b49a2e374cba8fc594
colsample_bytree	0.7317135755158947	e4ff17e0741440b49a2e374cba8fc594
learning_rate	0.01250327194021913	e4ff17e0741440b49a2e374cba8fc594
max_depth	4	e4ff17e0741440b49a2e374cba8fc594
min_child_samples	198	e4ff17e0741440b49a2e374cba8fc594
min_child_weight	0.001	e4ff17e0741440b49a2e374cba8fc594
min_split_gain	0.6682519800894291	e4ff17e0741440b49a2e374cba8fc594
num_leaves	31	e4ff17e0741440b49a2e374cba8fc594
random_state	42	e4ff17e0741440b49a2e374cba8fc594
reg_alpha	0.0038562141649568053	e4ff17e0741440b49a2e374cba8fc594
reg_lambda	0.0018396852825085272	e4ff17e0741440b49a2e374cba8fc594
subsample	0.7003869699519749	e4ff17e0741440b49a2e374cba8fc594
subsample_for_bin	200000	e4ff17e0741440b49a2e374cba8fc594
subsample_freq	0	e4ff17e0741440b49a2e374cba8fc594
metric	['None']	e4ff17e0741440b49a2e374cba8fc594
verbosity	-1	e4ff17e0741440b49a2e374cba8fc594
scale_pos_weight	8.071934444826828	e4ff17e0741440b49a2e374cba8fc594
objective	binary	e4ff17e0741440b49a2e374cba8fc594
num_threads	12	e4ff17e0741440b49a2e374cba8fc594
num_boost_round	1500	e4ff17e0741440b49a2e374cba8fc594
feature_name	auto	e4ff17e0741440b49a2e374cba8fc594
categorical_feature	auto	e4ff17e0741440b49a2e374cba8fc594
keep_training_booster	False	e4ff17e0741440b49a2e374cba8fc594
boosting_type	gbdt	c7ca2abd948b4f7a8f5ef910fcb0e754
colsample_bytree	0.5107424259304466	c7ca2abd948b4f7a8f5ef910fcb0e754
learning_rate	0.022399613850462668	c7ca2abd948b4f7a8f5ef910fcb0e754
max_depth	9	c7ca2abd948b4f7a8f5ef910fcb0e754
min_child_samples	74	c7ca2abd948b4f7a8f5ef910fcb0e754
min_child_weight	0.001	c7ca2abd948b4f7a8f5ef910fcb0e754
min_split_gain	0.8664162919797492	c7ca2abd948b4f7a8f5ef910fcb0e754
num_leaves	17	c7ca2abd948b4f7a8f5ef910fcb0e754
random_state	42	c7ca2abd948b4f7a8f5ef910fcb0e754
reg_alpha	0.3291009011947689	c7ca2abd948b4f7a8f5ef910fcb0e754
reg_lambda	0.014134381734761847	c7ca2abd948b4f7a8f5ef910fcb0e754
subsample	0.9949329843642837	c7ca2abd948b4f7a8f5ef910fcb0e754
subsample_for_bin	200000	c7ca2abd948b4f7a8f5ef910fcb0e754
subsample_freq	0	c7ca2abd948b4f7a8f5ef910fcb0e754
metric	['None']	c7ca2abd948b4f7a8f5ef910fcb0e754
verbosity	-1	c7ca2abd948b4f7a8f5ef910fcb0e754
scale_pos_weight	11.499114883280225	c7ca2abd948b4f7a8f5ef910fcb0e754
objective	binary	c7ca2abd948b4f7a8f5ef910fcb0e754
num_threads	12	c7ca2abd948b4f7a8f5ef910fcb0e754
num_boost_round	700	c7ca2abd948b4f7a8f5ef910fcb0e754
feature_name	auto	c7ca2abd948b4f7a8f5ef910fcb0e754
categorical_feature	auto	c7ca2abd948b4f7a8f5ef910fcb0e754
keep_training_booster	False	c7ca2abd948b4f7a8f5ef910fcb0e754
boosting_type	gbdt	ce2b0e6b82744bb9ab441eb5516e4bb9
colsample_bytree	0.5323313974507468	ce2b0e6b82744bb9ab441eb5516e4bb9
learning_rate	0.01074455192323162	ce2b0e6b82744bb9ab441eb5516e4bb9
max_depth	9	ce2b0e6b82744bb9ab441eb5516e4bb9
min_child_samples	158	ce2b0e6b82744bb9ab441eb5516e4bb9
min_child_weight	0.001	ce2b0e6b82744bb9ab441eb5516e4bb9
min_split_gain	0.7339092772333528	ce2b0e6b82744bb9ab441eb5516e4bb9
num_leaves	22	ce2b0e6b82744bb9ab441eb5516e4bb9
random_state	42	ce2b0e6b82744bb9ab441eb5516e4bb9
reg_alpha	0.0016098672014329609	ce2b0e6b82744bb9ab441eb5516e4bb9
reg_lambda	0.00018034103697845173	ce2b0e6b82744bb9ab441eb5516e4bb9
subsample	0.9873470948039075	ce2b0e6b82744bb9ab441eb5516e4bb9
subsample_for_bin	200000	ce2b0e6b82744bb9ab441eb5516e4bb9
subsample_freq	0	ce2b0e6b82744bb9ab441eb5516e4bb9
metric	['None']	ce2b0e6b82744bb9ab441eb5516e4bb9
verbosity	-1	ce2b0e6b82744bb9ab441eb5516e4bb9
scale_pos_weight	6.29718597928158	ce2b0e6b82744bb9ab441eb5516e4bb9
objective	binary	ce2b0e6b82744bb9ab441eb5516e4bb9
num_threads	12	ce2b0e6b82744bb9ab441eb5516e4bb9
num_boost_round	1900	ce2b0e6b82744bb9ab441eb5516e4bb9
feature_name	auto	ce2b0e6b82744bb9ab441eb5516e4bb9
categorical_feature	auto	ce2b0e6b82744bb9ab441eb5516e4bb9
keep_training_booster	False	ce2b0e6b82744bb9ab441eb5516e4bb9
boosting_type	gbdt	bec59faddbfa49baa60c2a3653cd5dbd
colsample_bytree	0.5751896550084875	bec59faddbfa49baa60c2a3653cd5dbd
learning_rate	0.009446226926813942	bec59faddbfa49baa60c2a3653cd5dbd
max_depth	10	bec59faddbfa49baa60c2a3653cd5dbd
min_child_samples	13	bec59faddbfa49baa60c2a3653cd5dbd
min_child_weight	0.001	bec59faddbfa49baa60c2a3653cd5dbd
min_split_gain	0.6514775449062056	bec59faddbfa49baa60c2a3653cd5dbd
num_leaves	104	bec59faddbfa49baa60c2a3653cd5dbd
random_state	42	bec59faddbfa49baa60c2a3653cd5dbd
reg_alpha	1.3616356412080934	bec59faddbfa49baa60c2a3653cd5dbd
reg_lambda	0.34695423888700183	bec59faddbfa49baa60c2a3653cd5dbd
subsample	0.7137255238214322	bec59faddbfa49baa60c2a3653cd5dbd
subsample_for_bin	200000	bec59faddbfa49baa60c2a3653cd5dbd
subsample_freq	0	bec59faddbfa49baa60c2a3653cd5dbd
metric	['None']	bec59faddbfa49baa60c2a3653cd5dbd
verbosity	-1	bec59faddbfa49baa60c2a3653cd5dbd
scale_pos_weight	7.045263559450873	bec59faddbfa49baa60c2a3653cd5dbd
objective	binary	bec59faddbfa49baa60c2a3653cd5dbd
num_threads	12	bec59faddbfa49baa60c2a3653cd5dbd
num_boost_round	1700	bec59faddbfa49baa60c2a3653cd5dbd
feature_name	auto	bec59faddbfa49baa60c2a3653cd5dbd
categorical_feature	auto	bec59faddbfa49baa60c2a3653cd5dbd
keep_training_booster	False	bec59faddbfa49baa60c2a3653cd5dbd
learning_rate	0.03328447427285721	cceff74de09a44f48ae9e027c5f35536
n_estimators	1500	cceff74de09a44f48ae9e027c5f35536
num_leaves	18	cceff74de09a44f48ae9e027c5f35536
max_depth	9	cceff74de09a44f48ae9e027c5f35536
min_child_samples	79	cceff74de09a44f48ae9e027c5f35536
subsample	0.9509402559744826	cceff74de09a44f48ae9e027c5f35536
colsample_bytree	0.5279926917649457	cceff74de09a44f48ae9e027c5f35536
reg_alpha	0.002958308173816128	cceff74de09a44f48ae9e027c5f35536
reg_lambda	6.376766128139896e-05	cceff74de09a44f48ae9e027c5f35536
min_split_gain	0.573024757250299	cceff74de09a44f48ae9e027c5f35536
scale_pos_weight	12.052912741568086	cceff74de09a44f48ae9e027c5f35536
boosting_type	gbdt	9e379079e72747be9cc278ce97ad8b11
colsample_bytree	0.5279926917649457	9e379079e72747be9cc278ce97ad8b11
learning_rate	0.03328447427285721	9e379079e72747be9cc278ce97ad8b11
max_depth	9	9e379079e72747be9cc278ce97ad8b11
min_child_samples	79	9e379079e72747be9cc278ce97ad8b11
min_child_weight	0.001	9e379079e72747be9cc278ce97ad8b11
min_split_gain	0.573024757250299	9e379079e72747be9cc278ce97ad8b11
num_leaves	18	9e379079e72747be9cc278ce97ad8b11
random_state	42	9e379079e72747be9cc278ce97ad8b11
reg_alpha	0.002958308173816128	9e379079e72747be9cc278ce97ad8b11
reg_lambda	6.376766128139896e-05	9e379079e72747be9cc278ce97ad8b11
subsample	0.9509402559744826	9e379079e72747be9cc278ce97ad8b11
subsample_for_bin	200000	9e379079e72747be9cc278ce97ad8b11
subsample_freq	0	9e379079e72747be9cc278ce97ad8b11
scale_pos_weight	11.387084592145015	9e379079e72747be9cc278ce97ad8b11
verbosity	-1	9e379079e72747be9cc278ce97ad8b11
objective	binary	9e379079e72747be9cc278ce97ad8b11
metric	['binary']	9e379079e72747be9cc278ce97ad8b11
num_threads	12	9e379079e72747be9cc278ce97ad8b11
num_boost_round	1500	9e379079e72747be9cc278ce97ad8b11
feature_name	auto	9e379079e72747be9cc278ce97ad8b11
categorical_feature	auto	9e379079e72747be9cc278ce97ad8b11
keep_training_booster	False	9e379079e72747be9cc278ce97ad8b11
memory	None	033ebefb766e4bfa8282ab39cec5c865
steps	[('preprocessador', ColumnTransformer(transformers=[('numericas',\n                                 Pipeline(steps=[('scaler', StandardScaler())]),\n                                 ['AMT_ANNUITY', 'AMT_CREDIT',\n                                  'AMT_GOODS_PRICE', 'AMT_INCOME_TOTAL',\n                                  'AMT_REQ_CREDIT_BUREAU_DAY',\n                                  'AMT_REQ_CREDIT_BUREAU_HOUR',\n                                  'AMT_REQ_CREDIT_BUREAU_MON',\n                                  'AMT_REQ_CREDIT_BUREAU_QRT',\n                                  'AMT_REQ_CREDIT_BUREAU_WEEK',\n                                  'AMT_REQ_CREDIT_BUREAU_YEAR',\n                                  'APARTMENTS_AVG', 'APART...\n                                                                 unknown_value=-1))]),\n                                 ['EMERGENCYSTATE_MODE', 'FLAG_OWN_CAR',\n                                  'FLAG_OWN_REALTY', 'FONDKAPREMONT_MODE',\n                                  'HOUSETYPE_MODE', 'NAME_CONTRACT_TYPE',\n                                  'NAME_EDUCATION_TYPE', 'NAME_FAMILY_STATUS',\n                                  'NAME_HOUSING_TYPE', 'NAME_INCOME_TYPE',\n                                  'NAME_TYPE_SUITE', 'OCCUPATION_TYPE',\n                                  'ORGANIZATION_TYPE', 'WALLSMATERIAL_MODE',\n                                  'WEEKDAY_APPR_PROCESS_START'])],\n                  verbose_feature_names_out=False)), ('modelo', LGBMClassifier(colsample_bytree=0.5279926917649457,\n               learning_rate=0.03328447427285721, max_depth=9,\n               min_child_samples=79, min_split_gain=0.573024757250299,\n               n_estimators=1500, n_jobs=-1, num_leaves=18, objective='binary',\n               random_state=42, reg_alpha=0.002958308173816128,\n               reg_lambda=6.376766128139896e-05,\n               scale_pos_weight=12.052912741568086,\n               subsample=0.9509402559744826, verbosity=-1))]	033ebefb766e4bfa8282ab39cec5c865
transform_input	None	033ebefb766e4bfa8282ab39cec5c865
verbose	False	033ebefb766e4bfa8282ab39cec5c865
preprocessador	ColumnTransformer(transformers=[('numericas',\n                                 Pipeline(steps=[('scaler', StandardScaler())]),\n                                 ['AMT_ANNUITY', 'AMT_CREDIT',\n                                  'AMT_GOODS_PRICE', 'AMT_INCOME_TOTAL',\n                                  'AMT_REQ_CREDIT_BUREAU_DAY',\n                                  'AMT_REQ_CREDIT_BUREAU_HOUR',\n                                  'AMT_REQ_CREDIT_BUREAU_MON',\n                                  'AMT_REQ_CREDIT_BUREAU_QRT',\n                                  'AMT_REQ_CREDIT_BUREAU_WEEK',\n                                  'AMT_REQ_CREDIT_BUREAU_YEAR',\n                                  'APARTMENTS_AVG', 'APART...\n                                                                 unknown_value=-1))]),\n                                 ['EMERGENCYSTATE_MODE', 'FLAG_OWN_CAR',\n                                  'FLAG_OWN_REALTY', 'FONDKAPREMONT_MODE',\n                                  'HOUSETYPE_MODE', 'NAME_CONTRACT_TYPE',\n                                  'NAME_EDUCATION_TYPE', 'NAME_FAMILY_STATUS',\n                                  'NAME_HOUSING_TYPE', 'NAME_INCOME_TYPE',\n                                  'NAME_TYPE_SUITE', 'OCCUPATION_TYPE',\n                                  'ORGANIZATION_TYPE', 'WALLSMATERIAL_MODE',\n                                  'WEEKDAY_APPR_PROCESS_START'])],\n                  verbose_feature_names_out=False)	033ebefb766e4bfa8282ab39cec5c865
modelo	LGBMClassifier(colsample_bytree=0.5279926917649457,\n               learning_rate=0.03328447427285721, max_depth=9,\n               min_child_samples=79, min_split_gain=0.573024757250299,\n               n_estimators=1500, n_jobs=-1, num_leaves=18, objective='binary',\n               random_state=42, reg_alpha=0.002958308173816128,\n               reg_lambda=6.376766128139896e-05,\n               scale_pos_weight=12.052912741568086,\n               subsample=0.9509402559744826, verbosity=-1)	033ebefb766e4bfa8282ab39cec5c865
preprocessador__n_jobs	None	033ebefb766e4bfa8282ab39cec5c865
preprocessador__remainder	drop	033ebefb766e4bfa8282ab39cec5c865
preprocessador__sparse_threshold	0.3	033ebefb766e4bfa8282ab39cec5c865
preprocessador__transformer_weights	None	033ebefb766e4bfa8282ab39cec5c865
preprocessador__transformers	[('numericas', Pipeline(steps=[('scaler', StandardScaler())]), ['AMT_ANNUITY', 'AMT_CREDIT', 'AMT_GOODS_PRICE', 'AMT_INCOME_TOTAL', 'AMT_REQ_CREDIT_BUREAU_DAY', 'AMT_REQ_CREDIT_BUREAU_HOUR', 'AMT_REQ_CREDIT_BUREAU_MON', 'AMT_REQ_CREDIT_BUREAU_QRT', 'AMT_REQ_CREDIT_BUREAU_WEEK', 'AMT_REQ_CREDIT_BUREAU_YEAR', 'APARTMENTS_AVG', 'APARTMENTS_missing', 'BASEMENTAREA_AVG', 'BASEMENTAREA_missing', 'CNT_CHILDREN', 'CNT_FAM_MEMBERS', 'COMMONAREA_AVG', 'COMMONAREA_missing', 'COMPROMETIMENTO_RENDA_PCT', 'DAYS_BIRTH', 'DAYS_EMPLOYED', 'DAYS_ID_PUBLISH', 'DAYS_LAST_PHONE_CHANGE', 'DAYS_REGISTRATION', 'DEF_30_CNT_SOCIAL_CIRCLE', 'DEF_60_CNT_SOCIAL_CIRCLE', 'ELEVATORS_AVG', 'ELEVATORS_missing', 'ENTRANCES_AVG', 'ENTRANCES_missing', 'EXT_SOURCE_1', 'EXT_SOURCE_2', 'EXT_SOURCE_3', 'EXT_SOURCE_COMPLT_MEAN', 'EXT_SOURCE_COMPLT_SUM', 'FLAG_CONT_MOBILE', 'FLAG_DOCUMENT_11', 'FLAG_DOCUMENT_13', 'FLAG_DOCUMENT_14', 'FLAG_DOCUMENT_15', 'FLAG_DOCUMENT_16', 'FLAG_DOCUMENT_17', 'FLAG_DOCUMENT_18', 'FLAG_DOCUMENT_19', 'FLAG_DOCUMENT_20', 'FLAG_DOCUMENT_21', 'FLAG_DOCUMENT_3', 'FLAG_DOCUMENT_5', 'FLAG_DOCUMENT_6', 'FLAG_DOCUMENT_7', 'FLAG_DOCUMENT_8', 'FLAG_DOCUMENT_9', 'FLAG_EMAIL', 'FLAG_EMP_PHONE', 'FLAG_PHONE', 'FLAG_WORK_PHONE', 'FLOORSMAX_AVG', 'FLOORSMAX_MEDI', 'FLOORSMAX_MODE', 'FLOORSMIN_MEDI', 'FLOORSMIN_missing', 'HOUR_APPR_PROCESS_START', 'LANDAREA_MEDI', 'LANDAREA_missing', 'LIVE_CITY_NOT_WORK_CITY', 'LIVE_REGION_NOT_WORK_REGION', 'LIVINGAPARTMENTS_AVG', 'LIVINGAPARTMENTS_missing', 'LIVINGAREA_AVG', 'LIVINGAREA_missing', 'NONLIVINGAPARTMENTS_AVG', 'NONLIVINGAPARTMENTS_missing', 'NONLIVINGAREA_AVG', 'NONLIVINGAREA_missing', 'OBS_30_CNT_SOCIAL_CIRCLE', 'OBS_60_CNT_SOCIAL_CIRCLE', 'OWN_CAR_AGE', 'REGION_POPULATION_RELATIVE', 'REGION_RATING_CLIENT', 'REGION_RATING_CLIENT_W_CITY', 'REG_CITY_NOT_LIVE_CITY', 'REG_CITY_NOT_WORK_CITY', 'REG_REGION_NOT_LIVE_REGION', 'REG_REGION_NOT_WORK_REGION', 'TOTALAREA_MODE', 'YEARS_BEGINEXPLUATATION_AVG', 'YEARS_BEGINEXPLUATATION_MEDI', 'YEARS_BEGINEXPLUATATION_MODE', 'YEARS_BUILD_MODE', 'YEARS_BUILD_missing']), ('categoricas', Pipeline(steps=[('encoder',\n                 OrdinalEncoder(handle_unknown='use_encoded_value',\n                                unknown_value=-1))]), ['EMERGENCYSTATE_MODE', 'FLAG_OWN_CAR', 'FLAG_OWN_REALTY', 'FONDKAPREMONT_MODE', 'HOUSETYPE_MODE', 'NAME_CONTRACT_TYPE', 'NAME_EDUCATION_TYPE', 'NAME_FAMILY_STATUS', 'NAME_HOUSING_TYPE', 'NAME_INCOME_TYPE', 'NAME_TYPE_SUITE', 'OCCUPATION_TYPE', 'ORGANIZATION_TYPE', 'WALLSMATERIAL_MODE', 'WEEKDAY_APPR_PROCESS_START'])]	033ebefb766e4bfa8282ab39cec5c865
preprocessador__verbose	False	033ebefb766e4bfa8282ab39cec5c865
preprocessador__verbose_feature_names_out	False	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas	Pipeline(steps=[('scaler', StandardScaler())])	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas	Pipeline(steps=[('encoder',\n                 OrdinalEncoder(handle_unknown='use_encoded_value',\n                                unknown_value=-1))])	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas__memory	None	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas__steps	[('scaler', StandardScaler())]	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas__transform_input	None	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas__verbose	False	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas__scaler	StandardScaler()	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas__scaler__copy	True	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas__scaler__with_mean	True	033ebefb766e4bfa8282ab39cec5c865
preprocessador__numericas__scaler__with_std	True	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__memory	None	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__steps	[('encoder', OrdinalEncoder(handle_unknown='use_encoded_value', unknown_value=-1))]	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__transform_input	None	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__verbose	False	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__encoder	OrdinalEncoder(handle_unknown='use_encoded_value', unknown_value=-1)	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__encoder__categories	auto	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__encoder__dtype	<class 'numpy.float64'>	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__encoder__encoded_missing_value	nan	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__encoder__handle_unknown	use_encoded_value	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__encoder__max_categories	None	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__encoder__min_frequency	None	033ebefb766e4bfa8282ab39cec5c865
preprocessador__categoricas__encoder__unknown_value	-1	033ebefb766e4bfa8282ab39cec5c865
modelo__boosting_type	gbdt	033ebefb766e4bfa8282ab39cec5c865
modelo__class_weight	None	033ebefb766e4bfa8282ab39cec5c865
modelo__colsample_bytree	0.5279926917649457	033ebefb766e4bfa8282ab39cec5c865
modelo__importance_type	split	033ebefb766e4bfa8282ab39cec5c865
modelo__learning_rate	0.03328447427285721	033ebefb766e4bfa8282ab39cec5c865
modelo__max_depth	9	033ebefb766e4bfa8282ab39cec5c865
modelo__min_child_samples	79	033ebefb766e4bfa8282ab39cec5c865
modelo__min_child_weight	0.001	033ebefb766e4bfa8282ab39cec5c865
modelo__min_split_gain	0.573024757250299	033ebefb766e4bfa8282ab39cec5c865
modelo__n_estimators	1500	033ebefb766e4bfa8282ab39cec5c865
modelo__n_jobs	-1	033ebefb766e4bfa8282ab39cec5c865
modelo__num_leaves	18	033ebefb766e4bfa8282ab39cec5c865
modelo__objective	binary	033ebefb766e4bfa8282ab39cec5c865
modelo__random_state	42	033ebefb766e4bfa8282ab39cec5c865
modelo__reg_alpha	0.002958308173816128	033ebefb766e4bfa8282ab39cec5c865
modelo__reg_lambda	6.376766128139896e-05	033ebefb766e4bfa8282ab39cec5c865
modelo__subsample	0.9509402559744826	033ebefb766e4bfa8282ab39cec5c865
modelo__subsample_for_bin	200000	033ebefb766e4bfa8282ab39cec5c865
modelo__subsample_freq	0	033ebefb766e4bfa8282ab39cec5c865
modelo__scale_pos_weight	12.052912741568086	033ebefb766e4bfa8282ab39cec5c865
modelo__verbosity	-1	033ebefb766e4bfa8282ab39cec5c865
memory	None	be0003b4c09f45a384716a36faaa3fde
steps	[('preprocessador', ColumnTransformer(transformers=[('numericas',\n                                 Pipeline(steps=[('scaler', StandardScaler())]),\n                                 ['AMT_ANNUITY', 'AMT_CREDIT',\n                                  'AMT_GOODS_PRICE', 'AMT_INCOME_TOTAL',\n                                  'AMT_REQ_CREDIT_BUREAU_DAY',\n                                  'AMT_REQ_CREDIT_BUREAU_HOUR',\n                                  'AMT_REQ_CREDIT_BUREAU_MON',\n                                  'AMT_REQ_CREDIT_BUREAU_QRT',\n                                  'AMT_REQ_CREDIT_BUREAU_WEEK',\n                                  'AMT_REQ_CREDIT_BUREAU_YEAR',\n                                  'APARTMENTS_AVG', 'APART...\n                                                                 unknown_value=-1))]),\n                                 ['EMERGENCYSTATE_MODE', 'FLAG_OWN_CAR',\n                                  'FLAG_OWN_REALTY', 'FONDKAPREMONT_MODE',\n                                  'HOUSETYPE_MODE', 'NAME_CONTRACT_TYPE',\n                                  'NAME_EDUCATION_TYPE', 'NAME_FAMILY_STATUS',\n                                  'NAME_HOUSING_TYPE', 'NAME_INCOME_TYPE',\n                                  'NAME_TYPE_SUITE', 'OCCUPATION_TYPE',\n                                  'ORGANIZATION_TYPE', 'WALLSMATERIAL_MODE',\n                                  'WEEKDAY_APPR_PROCESS_START'])],\n                  verbose_feature_names_out=False)), ('modelo', LGBMClassifier(colsample_bytree=0.5279926917649457,\n               learning_rate=0.03328447427285721, max_depth=9,\n               min_child_samples=79, min_split_gain=0.573024757250299,\n               n_estimators=1500, n_jobs=-1, num_leaves=18, objective='binary',\n               random_state=42, reg_alpha=0.002958308173816128,\n               reg_lambda=6.376766128139896e-05,\n               scale_pos_weight=12.052912741568086,\n               subsample=0.9509402559744826, verbosity=-1))]	be0003b4c09f45a384716a36faaa3fde
transform_input	None	be0003b4c09f45a384716a36faaa3fde
verbose	False	be0003b4c09f45a384716a36faaa3fde
preprocessador	ColumnTransformer(transformers=[('numericas',\n                                 Pipeline(steps=[('scaler', StandardScaler())]),\n                                 ['AMT_ANNUITY', 'AMT_CREDIT',\n                                  'AMT_GOODS_PRICE', 'AMT_INCOME_TOTAL',\n                                  'AMT_REQ_CREDIT_BUREAU_DAY',\n                                  'AMT_REQ_CREDIT_BUREAU_HOUR',\n                                  'AMT_REQ_CREDIT_BUREAU_MON',\n                                  'AMT_REQ_CREDIT_BUREAU_QRT',\n                                  'AMT_REQ_CREDIT_BUREAU_WEEK',\n                                  'AMT_REQ_CREDIT_BUREAU_YEAR',\n                                  'APARTMENTS_AVG', 'APART...\n                                                                 unknown_value=-1))]),\n                                 ['EMERGENCYSTATE_MODE', 'FLAG_OWN_CAR',\n                                  'FLAG_OWN_REALTY', 'FONDKAPREMONT_MODE',\n                                  'HOUSETYPE_MODE', 'NAME_CONTRACT_TYPE',\n                                  'NAME_EDUCATION_TYPE', 'NAME_FAMILY_STATUS',\n                                  'NAME_HOUSING_TYPE', 'NAME_INCOME_TYPE',\n                                  'NAME_TYPE_SUITE', 'OCCUPATION_TYPE',\n                                  'ORGANIZATION_TYPE', 'WALLSMATERIAL_MODE',\n                                  'WEEKDAY_APPR_PROCESS_START'])],\n                  verbose_feature_names_out=False)	be0003b4c09f45a384716a36faaa3fde
modelo	LGBMClassifier(colsample_bytree=0.5279926917649457,\n               learning_rate=0.03328447427285721, max_depth=9,\n               min_child_samples=79, min_split_gain=0.573024757250299,\n               n_estimators=1500, n_jobs=-1, num_leaves=18, objective='binary',\n               random_state=42, reg_alpha=0.002958308173816128,\n               reg_lambda=6.376766128139896e-05,\n               scale_pos_weight=12.052912741568086,\n               subsample=0.9509402559744826, verbosity=-1)	be0003b4c09f45a384716a36faaa3fde
preprocessador__n_jobs	None	be0003b4c09f45a384716a36faaa3fde
preprocessador__remainder	drop	be0003b4c09f45a384716a36faaa3fde
preprocessador__sparse_threshold	0.3	be0003b4c09f45a384716a36faaa3fde
preprocessador__transformer_weights	None	be0003b4c09f45a384716a36faaa3fde
preprocessador__transformers	[('numericas', Pipeline(steps=[('scaler', StandardScaler())]), ['AMT_ANNUITY', 'AMT_CREDIT', 'AMT_GOODS_PRICE', 'AMT_INCOME_TOTAL', 'AMT_REQ_CREDIT_BUREAU_DAY', 'AMT_REQ_CREDIT_BUREAU_HOUR', 'AMT_REQ_CREDIT_BUREAU_MON', 'AMT_REQ_CREDIT_BUREAU_QRT', 'AMT_REQ_CREDIT_BUREAU_WEEK', 'AMT_REQ_CREDIT_BUREAU_YEAR', 'APARTMENTS_AVG', 'APARTMENTS_missing', 'BASEMENTAREA_AVG', 'BASEMENTAREA_missing', 'CNT_CHILDREN', 'CNT_FAM_MEMBERS', 'COMMONAREA_AVG', 'COMMONAREA_missing', 'COMPROMETIMENTO_RENDA_PCT', 'DAYS_BIRTH', 'DAYS_EMPLOYED', 'DAYS_ID_PUBLISH', 'DAYS_LAST_PHONE_CHANGE', 'DAYS_REGISTRATION', 'DEF_30_CNT_SOCIAL_CIRCLE', 'DEF_60_CNT_SOCIAL_CIRCLE', 'ELEVATORS_AVG', 'ELEVATORS_missing', 'ENTRANCES_AVG', 'ENTRANCES_missing', 'EXT_SOURCE_1', 'EXT_SOURCE_2', 'EXT_SOURCE_3', 'EXT_SOURCE_COMPLT_MEAN', 'EXT_SOURCE_COMPLT_SUM', 'FLAG_CONT_MOBILE', 'FLAG_DOCUMENT_11', 'FLAG_DOCUMENT_13', 'FLAG_DOCUMENT_14', 'FLAG_DOCUMENT_15', 'FLAG_DOCUMENT_16', 'FLAG_DOCUMENT_17', 'FLAG_DOCUMENT_18', 'FLAG_DOCUMENT_19', 'FLAG_DOCUMENT_20', 'FLAG_DOCUMENT_21', 'FLAG_DOCUMENT_3', 'FLAG_DOCUMENT_5', 'FLAG_DOCUMENT_6', 'FLAG_DOCUMENT_7', 'FLAG_DOCUMENT_8', 'FLAG_DOCUMENT_9', 'FLAG_EMAIL', 'FLAG_EMP_PHONE', 'FLAG_PHONE', 'FLAG_WORK_PHONE', 'FLOORSMAX_AVG', 'FLOORSMAX_MEDI', 'FLOORSMAX_MODE', 'FLOORSMIN_MEDI', 'FLOORSMIN_missing', 'HOUR_APPR_PROCESS_START', 'LANDAREA_MEDI', 'LANDAREA_missing', 'LIVE_CITY_NOT_WORK_CITY', 'LIVE_REGION_NOT_WORK_REGION', 'LIVINGAPARTMENTS_AVG', 'LIVINGAPARTMENTS_missing', 'LIVINGAREA_AVG', 'LIVINGAREA_missing', 'NONLIVINGAPARTMENTS_AVG', 'NONLIVINGAPARTMENTS_missing', 'NONLIVINGAREA_AVG', 'NONLIVINGAREA_missing', 'OBS_30_CNT_SOCIAL_CIRCLE', 'OBS_60_CNT_SOCIAL_CIRCLE', 'OWN_CAR_AGE', 'REGION_POPULATION_RELATIVE', 'REGION_RATING_CLIENT', 'REGION_RATING_CLIENT_W_CITY', 'REG_CITY_NOT_LIVE_CITY', 'REG_CITY_NOT_WORK_CITY', 'REG_REGION_NOT_LIVE_REGION', 'REG_REGION_NOT_WORK_REGION', 'TOTALAREA_MODE', 'YEARS_BEGINEXPLUATATION_AVG', 'YEARS_BEGINEXPLUATATION_MEDI', 'YEARS_BEGINEXPLUATATION_MODE', 'YEARS_BUILD_MODE', 'YEARS_BUILD_missing']), ('categoricas', Pipeline(steps=[('encoder',\n                 OrdinalEncoder(handle_unknown='use_encoded_value',\n                                unknown_value=-1))]), ['EMERGENCYSTATE_MODE', 'FLAG_OWN_CAR', 'FLAG_OWN_REALTY', 'FONDKAPREMONT_MODE', 'HOUSETYPE_MODE', 'NAME_CONTRACT_TYPE', 'NAME_EDUCATION_TYPE', 'NAME_FAMILY_STATUS', 'NAME_HOUSING_TYPE', 'NAME_INCOME_TYPE', 'NAME_TYPE_SUITE', 'OCCUPATION_TYPE', 'ORGANIZATION_TYPE', 'WALLSMATERIAL_MODE', 'WEEKDAY_APPR_PROCESS_START'])]	be0003b4c09f45a384716a36faaa3fde
preprocessador__verbose	False	be0003b4c09f45a384716a36faaa3fde
preprocessador__verbose_feature_names_out	False	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas	Pipeline(steps=[('scaler', StandardScaler())])	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas	Pipeline(steps=[('encoder',\n                 OrdinalEncoder(handle_unknown='use_encoded_value',\n                                unknown_value=-1))])	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas__memory	None	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas__steps	[('scaler', StandardScaler())]	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas__transform_input	None	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas__verbose	False	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas__scaler	StandardScaler()	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas__scaler__copy	True	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas__scaler__with_mean	True	be0003b4c09f45a384716a36faaa3fde
preprocessador__numericas__scaler__with_std	True	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__memory	None	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__steps	[('encoder', OrdinalEncoder(handle_unknown='use_encoded_value', unknown_value=-1))]	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__transform_input	None	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__verbose	False	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__encoder	OrdinalEncoder(handle_unknown='use_encoded_value', unknown_value=-1)	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__encoder__categories	auto	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__encoder__dtype	<class 'numpy.float64'>	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__encoder__encoded_missing_value	nan	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__encoder__handle_unknown	use_encoded_value	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__encoder__max_categories	None	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__encoder__min_frequency	None	be0003b4c09f45a384716a36faaa3fde
preprocessador__categoricas__encoder__unknown_value	-1	be0003b4c09f45a384716a36faaa3fde
modelo__boosting_type	gbdt	be0003b4c09f45a384716a36faaa3fde
modelo__class_weight	None	be0003b4c09f45a384716a36faaa3fde
modelo__colsample_bytree	0.5279926917649457	be0003b4c09f45a384716a36faaa3fde
modelo__importance_type	split	be0003b4c09f45a384716a36faaa3fde
modelo__learning_rate	0.03328447427285721	be0003b4c09f45a384716a36faaa3fde
modelo__max_depth	9	be0003b4c09f45a384716a36faaa3fde
modelo__min_child_samples	79	be0003b4c09f45a384716a36faaa3fde
modelo__min_child_weight	0.001	be0003b4c09f45a384716a36faaa3fde
modelo__min_split_gain	0.573024757250299	be0003b4c09f45a384716a36faaa3fde
modelo__n_estimators	1500	be0003b4c09f45a384716a36faaa3fde
modelo__n_jobs	-1	be0003b4c09f45a384716a36faaa3fde
modelo__num_leaves	18	be0003b4c09f45a384716a36faaa3fde
modelo__objective	binary	be0003b4c09f45a384716a36faaa3fde
modelo__random_state	42	be0003b4c09f45a384716a36faaa3fde
modelo__reg_alpha	0.002958308173816128	be0003b4c09f45a384716a36faaa3fde
modelo__reg_lambda	6.376766128139896e-05	be0003b4c09f45a384716a36faaa3fde
modelo__subsample	0.9509402559744826	be0003b4c09f45a384716a36faaa3fde
modelo__subsample_for_bin	200000	be0003b4c09f45a384716a36faaa3fde
modelo__subsample_freq	0	be0003b4c09f45a384716a36faaa3fde
modelo__scale_pos_weight	12.052912741568086	be0003b4c09f45a384716a36faaa3fde
modelo__verbosity	-1	be0003b4c09f45a384716a36faaa3fde
\.


--
-- Data for Name: registered_model_aliases; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.registered_model_aliases (alias, version, name) FROM stdin;
\.


--
-- Data for Name: registered_model_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.registered_model_tags (key, value, name) FROM stdin;
\.


--
-- Data for Name: registered_models; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.registered_models (name, creation_time, last_updated_time, description) FROM stdin;
\.


--
-- Data for Name: runs; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.runs (run_uuid, name, source_type, source_name, entry_point_name, user_id, status, start_time, end_time, source_version, lifecycle_stage, artifact_uri, experiment_id, deleted_time) FROM stdin;
1c1474a4dc0a42e595b137a2ff7eb3cd	Random Forest	UNKNOWN			eduar	FINISHED	1784572419121	1784572665238		active	/mlflow/artifacts/1/1c1474a4dc0a42e595b137a2ff7eb3cd/artifacts	1	\N
87bee9e02af04727a439076b5099ea26	LightGBM	UNKNOWN			eduar	FINISHED	1784572665329	1784572691631		active	/mlflow/artifacts/1/87bee9e02af04727a439076b5099ea26/artifacts	1	\N
a0d9d4037d9a483e8ff2887e8c35e79a	XGBoost	UNKNOWN			eduar	FINISHED	1784572691687	1784572720627		active	/mlflow/artifacts/1/a0d9d4037d9a483e8ff2887e8c35e79a/artifacts	1	\N
f5a3d1a3c4ed4af69451b19e8ca99b44	cross-validation	UNKNOWN			eduar	FINISHED	1784572418853	1784572720672		active	/mlflow/artifacts/1/f5a3d1a3c4ed4af69451b19e8ca99b44/artifacts	1	\N
64d0075ce861402aa333540e2cfb3177	Random Forest	UNKNOWN			eduar	FAILED	1784639656195	1784639806896		active	/mlflow/artifacts/2/64d0075ce861402aa333540e2cfb3177/artifacts	2	\N
5182637ae0084c8c9a5b790208db545b	test-set-evaluation	UNKNOWN			eduar	FAILED	1784639655819	1784639807042		active	/mlflow/artifacts/2/5182637ae0084c8c9a5b790208db545b/artifacts	2	\N
7ad743cafe754961865d8d9048d97887	Random Forest	UNKNOWN			eduar	FINISHED	1784639847180	1784639992195		active	/mlflow/artifacts/2/7ad743cafe754961865d8d9048d97887/artifacts	2	\N
9899a48432a34cb39a199dcf5ae28c28	LightGBM	UNKNOWN			eduar	FINISHED	1784639992287	1784640008178		active	/mlflow/artifacts/2/9899a48432a34cb39a199dcf5ae28c28/artifacts	2	\N
f8b1be9aa8b34c36a0d398fea269c222	XGBoost	UNKNOWN			eduar	FINISHED	1784640008251	1784640024361		active	/mlflow/artifacts/2/f8b1be9aa8b34c36a0d398fea269c222/artifacts	2	\N
8274a5b2f12040bc9cd010d478f47bb2	test-set-evaluation	UNKNOWN			eduar	FINISHED	1784639846798	1784640024405		active	/mlflow/artifacts/2/8274a5b2f12040bc9cd010d478f47bb2/artifacts	2	\N
b065943b869c45d1ab9a544997cbd2e3	trial-0	UNKNOWN			eduar	FINISHED	1784641456005	1784641519100		active	/mlflow/artifacts/3/b065943b869c45d1ab9a544997cbd2e3/artifacts	3	\N
876e004fc22941a5bd0abf6035008d6e	trial-1	UNKNOWN			eduar	FINISHED	1784641519184	1784641555515		active	/mlflow/artifacts/3/876e004fc22941a5bd0abf6035008d6e/artifacts	3	\N
77d0e55214db4ecd857415d3af80c800	trial-2	UNKNOWN			eduar	FINISHED	1784641555601	1784641572109		active	/mlflow/artifacts/3/77d0e55214db4ecd857415d3af80c800/artifacts	3	\N
8af2154e65c646ba85f95ef956f429e3	trial-3	UNKNOWN			eduar	FINISHED	1784641572203	1784641603707		active	/mlflow/artifacts/3/8af2154e65c646ba85f95ef956f429e3/artifacts	3	\N
546361b43206462abda8503c0473c830	trial-4	UNKNOWN			eduar	FINISHED	1784641603799	1784641635079		active	/mlflow/artifacts/3/546361b43206462abda8503c0473c830/artifacts	3	\N
863d9eddfa374352ac9ef04f414aed07	trial-5	UNKNOWN			eduar	FINISHED	1784641635150	1784641664010		active	/mlflow/artifacts/3/863d9eddfa374352ac9ef04f414aed07/artifacts	3	\N
761f6f2a81274b38bf29c785c17b9f5c	trial-6	UNKNOWN			eduar	FINISHED	1784641664075	1784641684314		active	/mlflow/artifacts/3/761f6f2a81274b38bf29c785c17b9f5c/artifacts	3	\N
014e8bb3efda4a7f9e544ad0c54eda97	trial-7	UNKNOWN			eduar	FINISHED	1784641684370	1784641700027		active	/mlflow/artifacts/3/014e8bb3efda4a7f9e544ad0c54eda97/artifacts	3	\N
889b7c5d83704dd2ac3f3508dcb6bbeb	trial-8	UNKNOWN			eduar	FINISHED	1784641700103	1784641719427		active	/mlflow/artifacts/3/889b7c5d83704dd2ac3f3508dcb6bbeb/artifacts	3	\N
ae175d867d8d4942b3953e031f48deea	trial-9	UNKNOWN			eduar	FINISHED	1784641719521	1784641766208		active	/mlflow/artifacts/3/ae175d867d8d4942b3953e031f48deea/artifacts	3	\N
c570005822f1468ebc56e3a2e5f3a7be	trial-10	UNKNOWN			eduar	FINISHED	1784641766331	1784641788283		active	/mlflow/artifacts/3/c570005822f1468ebc56e3a2e5f3a7be/artifacts	3	\N
6198d6b56d9e4ff5afeca1168f4226b8	trial-11	UNKNOWN			eduar	FINISHED	1784641788428	1784641825291		active	/mlflow/artifacts/3/6198d6b56d9e4ff5afeca1168f4226b8/artifacts	3	\N
905dc0ac6a9b46bfa4b2435798fa6880	trial-12	UNKNOWN			eduar	FINISHED	1784641825471	1784641873290		active	/mlflow/artifacts/3/905dc0ac6a9b46bfa4b2435798fa6880/artifacts	3	\N
3c993ea82ef44d1f91ec5ae384b63d04	trial-13	UNKNOWN			eduar	FINISHED	1784641873444	1784641916768		active	/mlflow/artifacts/3/3c993ea82ef44d1f91ec5ae384b63d04/artifacts	3	\N
5f4890e2fdc040bfba29e6fba7cf13de	trial-14	UNKNOWN			eduar	FINISHED	1784641916925	1784641980891		active	/mlflow/artifacts/3/5f4890e2fdc040bfba29e6fba7cf13de/artifacts	3	\N
31c19df3feba406bbe273cf28ad356ea	trial-15	UNKNOWN			eduar	FINISHED	1784641981051	1784642051381		active	/mlflow/artifacts/3/31c19df3feba406bbe273cf28ad356ea/artifacts	3	\N
06988d80ee2a49cc847b86b0ba828472	trial-16	UNKNOWN			eduar	FINISHED	1784642051547	1784642096901		active	/mlflow/artifacts/3/06988d80ee2a49cc847b86b0ba828472/artifacts	3	\N
884482f15ecf455cacf6203986941bd8	trial-17	UNKNOWN			eduar	FINISHED	1784642099722	1784642128771		active	/mlflow/artifacts/3/884482f15ecf455cacf6203986941bd8/artifacts	3	\N
1336414e54eb49e886f22580bd301b28	trial-18	UNKNOWN			eduar	FINISHED	1784642128904	1784642165970		active	/mlflow/artifacts/3/1336414e54eb49e886f22580bd301b28/artifacts	3	\N
b3547d0973f74bf49d4e595aacdb1e3b	trial-19	UNKNOWN			eduar	FINISHED	1784642166114	1784642198882		active	/mlflow/artifacts/3/b3547d0973f74bf49d4e595aacdb1e3b/artifacts	3	\N
11cd7d2db6784fe4b02a7ae8f71d8cf2	trial-20	UNKNOWN			eduar	FINISHED	1784642199016	1784642245867		active	/mlflow/artifacts/3/11cd7d2db6784fe4b02a7ae8f71d8cf2/artifacts	3	\N
58b4b9d2beff44d3b6bce2af1c53b954	trial-21	UNKNOWN			eduar	FINISHED	1784642246005	1784642348963		active	/mlflow/artifacts/3/58b4b9d2beff44d3b6bce2af1c53b954/artifacts	3	\N
a96bb954fdd64eed9d3bb56c6d5ea887	trial-22	UNKNOWN			eduar	FINISHED	1784642349153	1784642412650		active	/mlflow/artifacts/3/a96bb954fdd64eed9d3bb56c6d5ea887/artifacts	3	\N
ed6d527941fe49ec9efa86d9ecec40b9	trial-23	UNKNOWN			eduar	FINISHED	1784642412810	1784642448674		active	/mlflow/artifacts/3/ed6d527941fe49ec9efa86d9ecec40b9/artifacts	3	\N
9bee251d163640f4b41fe3bb301ce520	trial-24	UNKNOWN			eduar	FINISHED	1784642448814	1784642482545		active	/mlflow/artifacts/3/9bee251d163640f4b41fe3bb301ce520/artifacts	3	\N
c5d632c0f5584ef38bba13efd4e41e85	trial-25	UNKNOWN			eduar	FINISHED	1784642482673	1784642508372		active	/mlflow/artifacts/3/c5d632c0f5584ef38bba13efd4e41e85/artifacts	3	\N
d54ca38b32404c3ab9603d5c17d370be	trial-26	UNKNOWN			eduar	FINISHED	1784642508468	1784642526934		active	/mlflow/artifacts/3/d54ca38b32404c3ab9603d5c17d370be/artifacts	3	\N
5cfc620daab64d35912dd7df3c7d139d	optuna-search	UNKNOWN			eduar	FINISHED	1784641455826	1784646313900		active	/mlflow/artifacts/3/5cfc620daab64d35912dd7df3c7d139d/artifacts	3	\N
74a92f84946a40ec9f5ef59d95735532	trial-27	UNKNOWN			eduar	FINISHED	1784642527100	1784642554102		active	/mlflow/artifacts/3/74a92f84946a40ec9f5ef59d95735532/artifacts	3	\N
4aca56d551a8462caff8f4910dc5c067	trial-32	UNKNOWN			eduar	FINISHED	1784642670752	1784642713645		active	/mlflow/artifacts/3/4aca56d551a8462caff8f4910dc5c067/artifacts	3	\N
4ed8356cc0124c2687e88834f4d5b105	trial-33	UNKNOWN			eduar	FINISHED	1784642713802	1784642761868		active	/mlflow/artifacts/3/4ed8356cc0124c2687e88834f4d5b105/artifacts	3	\N
6558904b55d747dcbb1151b72104deda	trial-42	UNKNOWN			eduar	FINISHED	1784643001674	1784643048913		active	/mlflow/artifacts/3/6558904b55d747dcbb1151b72104deda/artifacts	3	\N
19cbd69551b74540ae49e5172dcbd422	trial-28	UNKNOWN			eduar	FINISHED	1784642554227	1784642580457		active	/mlflow/artifacts/3/19cbd69551b74540ae49e5172dcbd422/artifacts	3	\N
5c42167498f34202a2d02f90db37735d	trial-39	UNKNOWN			eduar	FINISHED	1784642933096	1784642959420		active	/mlflow/artifacts/3/5c42167498f34202a2d02f90db37735d/artifacts	3	\N
3ed8585907ef4caa8fe4d70cb6b0cc87	trial-29	UNKNOWN			eduar	FINISHED	1784642580615	1784642612597		active	/mlflow/artifacts/3/3ed8585907ef4caa8fe4d70cb6b0cc87/artifacts	3	\N
5094306f911645f7960433fa475f3906	trial-36	UNKNOWN			eduar	FINISHED	1784642819351	1784642867585		active	/mlflow/artifacts/3/5094306f911645f7960433fa475f3906/artifacts	3	\N
c15aab38a0b749289678168eed8a375f	trial-37	UNKNOWN			eduar	FINISHED	1784642867691	1784642901504		active	/mlflow/artifacts/3/c15aab38a0b749289678168eed8a375f/artifacts	3	\N
e29e156922854739b295baa6f96964b9	trial-30	UNKNOWN			eduar	FINISHED	1784642612732	1784642639520		active	/mlflow/artifacts/3/e29e156922854739b295baa6f96964b9/artifacts	3	\N
d4ffdfcc60964dc2a44d6526250c8242	trial-35	UNKNOWN			eduar	FINISHED	1784642796582	1784642819213		active	/mlflow/artifacts/3/d4ffdfcc60964dc2a44d6526250c8242/artifacts	3	\N
802c5ed50bad4391bbb5c72644ab5629	trial-40	UNKNOWN			eduar	FINISHED	1784642959525	1784642979516		active	/mlflow/artifacts/3/802c5ed50bad4391bbb5c72644ab5629/artifacts	3	\N
337c2ecc590441f4b0d4ed6e6c6d874b	trial-31	UNKNOWN			eduar	FINISHED	1784642639657	1784642670639		active	/mlflow/artifacts/3/337c2ecc590441f4b0d4ed6e6c6d874b/artifacts	3	\N
bb2f576d862c4a68b3b67f55ee6e56e3	trial-34	UNKNOWN			eduar	FINISHED	1784642761986	1784642796457		active	/mlflow/artifacts/3/bb2f576d862c4a68b3b67f55ee6e56e3/artifacts	3	\N
a66a3b993e8c4892807fe3212c6626d1	trial-38	UNKNOWN			eduar	FINISHED	1784642901623	1784642932965		active	/mlflow/artifacts/3/a66a3b993e8c4892807fe3212c6626d1/artifacts	3	\N
b8c92046e4d64195892f204054da11ee	trial-41	UNKNOWN			eduar	FINISHED	1784642979619	1784643001542		active	/mlflow/artifacts/3/b8c92046e4d64195892f204054da11ee/artifacts	3	\N
23f4f5b6b75745cbbfb0974a54367678	trial-43	UNKNOWN			eduar	FINISHED	1784643049051	1784643089269		active	/mlflow/artifacts/3/23f4f5b6b75745cbbfb0974a54367678/artifacts	3	\N
979923580d5349d5968ee3fbca0c330a	trial-44	UNKNOWN			eduar	FINISHED	1784643089410	1784643161900		active	/mlflow/artifacts/3/979923580d5349d5968ee3fbca0c330a/artifacts	3	\N
bc0ab96304f34a6c848f80daf1fb9a6e	trial-45	UNKNOWN			eduar	FINISHED	1784643162086	1784643190125		active	/mlflow/artifacts/3/bc0ab96304f34a6c848f80daf1fb9a6e/artifacts	3	\N
b58e93020e20438db09d29ad3c13df59	trial-46	UNKNOWN			eduar	FINISHED	1784643190252	1784643222173		active	/mlflow/artifacts/3/b58e93020e20438db09d29ad3c13df59/artifacts	3	\N
70213c72967b441a8ecd0ad831f5b776	trial-47	UNKNOWN			eduar	FINISHED	1784643222316	1784643261511		active	/mlflow/artifacts/3/70213c72967b441a8ecd0ad831f5b776/artifacts	3	\N
7eea4fc7e3a546589babe6a0b7310882	trial-48	UNKNOWN			eduar	FINISHED	1784643261626	1784643293572		active	/mlflow/artifacts/3/7eea4fc7e3a546589babe6a0b7310882/artifacts	3	\N
518de6201cd84159962c329678dae7c7	trial-49	UNKNOWN			eduar	FINISHED	1784643293687	1784643318847		active	/mlflow/artifacts/3/518de6201cd84159962c329678dae7c7/artifacts	3	\N
2ab6619860f04dd6806c00d08dd3c42d	trial-50	UNKNOWN			eduar	FINISHED	1784643318989	1784643344678		active	/mlflow/artifacts/3/2ab6619860f04dd6806c00d08dd3c42d/artifacts	3	\N
cc29150802304136adce6bad79c64a02	trial-51	UNKNOWN			eduar	FINISHED	1784643344789	1784643383784		active	/mlflow/artifacts/3/cc29150802304136adce6bad79c64a02/artifacts	3	\N
e70dd208f60b4acc863c851496a7b8e1	trial-52	UNKNOWN			eduar	FINISHED	1784643383964	1784643409622		active	/mlflow/artifacts/3/e70dd208f60b4acc863c851496a7b8e1/artifacts	3	\N
16766e90a32c4f369ecd9e9b701ab356	trial-53	UNKNOWN			eduar	FINISHED	1784643409738	1784643434234		active	/mlflow/artifacts/3/16766e90a32c4f369ecd9e9b701ab356/artifacts	3	\N
2918b242568447af9cdc39919fb7482a	trial-54	UNKNOWN			eduar	FINISHED	1784643434382	1784643455420		active	/mlflow/artifacts/3/2918b242568447af9cdc39919fb7482a/artifacts	3	\N
0f8c5f9035b34684adc09c8445ef8cea	trial-55	UNKNOWN			eduar	FINISHED	1784643455544	1784643481746		active	/mlflow/artifacts/3/0f8c5f9035b34684adc09c8445ef8cea/artifacts	3	\N
10f0304d917b4d91a53520741a9f09f3	trial-56	UNKNOWN			eduar	FINISHED	1784643481880	1784643524235		active	/mlflow/artifacts/3/10f0304d917b4d91a53520741a9f09f3/artifacts	3	\N
0862f531c85046b18a2ec61111e68861	trial-57	UNKNOWN			eduar	FINISHED	1784643524368	1784643561466		active	/mlflow/artifacts/3/0862f531c85046b18a2ec61111e68861/artifacts	3	\N
718cc73f4d1b4db98abc0e7b10db5ed6	trial-58	UNKNOWN			eduar	FINISHED	1784643561615	1784643584391		active	/mlflow/artifacts/3/718cc73f4d1b4db98abc0e7b10db5ed6/artifacts	3	\N
f3039f0f77a54e3a87583ce82d69fd41	trial-59	UNKNOWN			eduar	FINISHED	1784643584525	1784643600465		active	/mlflow/artifacts/3/f3039f0f77a54e3a87583ce82d69fd41/artifacts	3	\N
5f60cb1e96ef4d32aba7cf2ba79d8aa2	trial-60	UNKNOWN			eduar	FINISHED	1784643600617	1784643621628		active	/mlflow/artifacts/3/5f60cb1e96ef4d32aba7cf2ba79d8aa2/artifacts	3	\N
a8986aaa09bb45edaf20a7a2a477b6f0	trial-61	UNKNOWN			eduar	FINISHED	1784643621777	1784643680727		active	/mlflow/artifacts/3/a8986aaa09bb45edaf20a7a2a477b6f0/artifacts	3	\N
9aac8f92473d49cf903225b9a22ad98e	trial-62	UNKNOWN			eduar	FINISHED	1784643680860	1784643710677		active	/mlflow/artifacts/3/9aac8f92473d49cf903225b9a22ad98e/artifacts	3	\N
08f786cb8efb4f64b9a2607fd6ca5ee5	trial-63	UNKNOWN			eduar	FINISHED	1784643710799	1784643740864		active	/mlflow/artifacts/3/08f786cb8efb4f64b9a2607fd6ca5ee5/artifacts	3	\N
d1000f6e85de4fe2a8c95dc022bdab8f	trial-64	UNKNOWN			eduar	FINISHED	1784643740978	1784643782347		active	/mlflow/artifacts/3/d1000f6e85de4fe2a8c95dc022bdab8f/artifacts	3	\N
deb70d2c6e9844ad8ec9a5549a069559	trial-65	UNKNOWN			eduar	FINISHED	1784643782481	1784643816855		active	/mlflow/artifacts/3/deb70d2c6e9844ad8ec9a5549a069559/artifacts	3	\N
a8ef003494f048faa29d895d18d2d187	trial-66	UNKNOWN			eduar	FINISHED	1784643816976	1784643843158		active	/mlflow/artifacts/3/a8ef003494f048faa29d895d18d2d187/artifacts	3	\N
651dd8509db8453e9b57f0db626a0bc0	trial-67	UNKNOWN			eduar	FINISHED	1784643843299	1784643863246		active	/mlflow/artifacts/3/651dd8509db8453e9b57f0db626a0bc0/artifacts	3	\N
69b74a9c9f174a25b25bca9453b251dd	trial-68	UNKNOWN			eduar	FINISHED	1784643863352	1784643882631		active	/mlflow/artifacts/3/69b74a9c9f174a25b25bca9453b251dd/artifacts	3	\N
4a86e315bd1b42e4a441cf540b75416d	trial-69	UNKNOWN			eduar	FINISHED	1784643882761	1784643900284		active	/mlflow/artifacts/3/4a86e315bd1b42e4a441cf540b75416d/artifacts	3	\N
fb402d7ff6d741018d6a91ea10972f05	trial-70	UNKNOWN			eduar	FINISHED	1784643900407	1784643918746		active	/mlflow/artifacts/3/fb402d7ff6d741018d6a91ea10972f05/artifacts	3	\N
e094133c648a4dcf978411aa6d5934e7	trial-71	UNKNOWN			eduar	FINISHED	1784643918870	1784643943321		active	/mlflow/artifacts/3/e094133c648a4dcf978411aa6d5934e7/artifacts	3	\N
7594e7f61c11418997699b81d6b68aac	trial-72	UNKNOWN			eduar	FINISHED	1784643943466	1784643958093		active	/mlflow/artifacts/3/7594e7f61c11418997699b81d6b68aac/artifacts	3	\N
8883ec417d31449b9c035b2913e2c586	trial-73	UNKNOWN			eduar	FINISHED	1784643958221	1784643975999		active	/mlflow/artifacts/3/8883ec417d31449b9c035b2913e2c586/artifacts	3	\N
fca3189b071b4c8aae99a36fec28a55a	trial-74	UNKNOWN			eduar	FINISHED	1784643976134	1784643989279		active	/mlflow/artifacts/3/fca3189b071b4c8aae99a36fec28a55a/artifacts	3	\N
7c8b46c7a5b748aa8f1d0b39f7af527e	trial-75	UNKNOWN			eduar	FINISHED	1784643989431	1784644006573		active	/mlflow/artifacts/3/7c8b46c7a5b748aa8f1d0b39f7af527e/artifacts	3	\N
3543bc1d263645d99771e0034c716e7b	trial-76	UNKNOWN			eduar	FINISHED	1784644006684	1784644025022		active	/mlflow/artifacts/3/3543bc1d263645d99771e0034c716e7b/artifacts	3	\N
c88117b6aafc456082337e849f1bf075	trial-77	UNKNOWN			eduar	FINISHED	1784644025127	1784644049803		active	/mlflow/artifacts/3/c88117b6aafc456082337e849f1bf075/artifacts	3	\N
aa2f79a2f19d42db9cb8620483e02b5e	trial-78	UNKNOWN			eduar	FINISHED	1784644049908	1784644068632		active	/mlflow/artifacts/3/aa2f79a2f19d42db9cb8620483e02b5e/artifacts	3	\N
804bc8eb2efe4ead940fa0c158126ca0	trial-79	UNKNOWN			eduar	FINISHED	1784644068789	1784644097504		active	/mlflow/artifacts/3/804bc8eb2efe4ead940fa0c158126ca0/artifacts	3	\N
329d6d6fd07d4659b5300ae5ad320063	trial-80	UNKNOWN			eduar	FINISHED	1784644097619	1784644130623		active	/mlflow/artifacts/3/329d6d6fd07d4659b5300ae5ad320063/artifacts	3	\N
0260b00d3be4497b9ca6fbdcf0fb56f3	trial-81	UNKNOWN			eduar	FINISHED	1784644130796	1784644159094		active	/mlflow/artifacts/3/0260b00d3be4497b9ca6fbdcf0fb56f3/artifacts	3	\N
e8d9a9ae1a314ef4822cb690114b565a	trial-82	UNKNOWN			eduar	FINISHED	1784644159212	1784644186733		active	/mlflow/artifacts/3/e8d9a9ae1a314ef4822cb690114b565a/artifacts	3	\N
c174b51cb9ef4197a069b455c2ae15f6	trial-83	UNKNOWN			eduar	FINISHED	1784644186842	1784644201820		active	/mlflow/artifacts/3/c174b51cb9ef4197a069b455c2ae15f6/artifacts	3	\N
0561a4c2b698400f949c0e76eef5fbdc	trial-84	UNKNOWN			eduar	FINISHED	1784644201958	1784644219363		active	/mlflow/artifacts/3/0561a4c2b698400f949c0e76eef5fbdc/artifacts	3	\N
581effbe4a2f4945aaadeb01b564b851	trial-85	UNKNOWN			eduar	FINISHED	1784644219481	1784644239966		active	/mlflow/artifacts/3/581effbe4a2f4945aaadeb01b564b851/artifacts	3	\N
d90190edced44c048d8f32ec24d761bb	trial-86	UNKNOWN			eduar	FINISHED	1784644240073	1784644287469		active	/mlflow/artifacts/3/d90190edced44c048d8f32ec24d761bb/artifacts	3	\N
3ac81d7485e549e392a19922b5afb56d	trial-87	UNKNOWN			eduar	FINISHED	1784644287615	1784644306122		active	/mlflow/artifacts/3/3ac81d7485e549e392a19922b5afb56d/artifacts	3	\N
9310e0296fef46229d141a34118600f6	trial-88	UNKNOWN			eduar	FINISHED	1784644306227	1784644326071		active	/mlflow/artifacts/3/9310e0296fef46229d141a34118600f6/artifacts	3	\N
17cdd4ed361b4c6aa962d390cb1f5fc5	trial-90	UNKNOWN			eduar	FINISHED	1784644347028	1784644372275		active	/mlflow/artifacts/3/17cdd4ed361b4c6aa962d390cb1f5fc5/artifacts	3	\N
cf02466f55074fecb9cf4a06f6468695	trial-94	UNKNOWN			eduar	FINISHED	1784644445636	1784644488313		active	/mlflow/artifacts/3/cf02466f55074fecb9cf4a06f6468695/artifacts	3	\N
8f70bc6c911d4d3daac5817bcbceb1c8	trial-96	UNKNOWN			eduar	FINISHED	1784644522276	1784644563005		active	/mlflow/artifacts/3/8f70bc6c911d4d3daac5817bcbceb1c8/artifacts	3	\N
491c6531e590476ba6d0e4c3f8ee4002	trial-97	UNKNOWN			eduar	FINISHED	1784644563170	1784644603450		active	/mlflow/artifacts/3/491c6531e590476ba6d0e4c3f8ee4002/artifacts	3	\N
c2857623dd374caeb05d44680f352000	trial-100	UNKNOWN			eduar	FINISHED	1784644684581	1784644719055		active	/mlflow/artifacts/3/c2857623dd374caeb05d44680f352000/artifacts	3	\N
8dd0782b26a647b0924ccd9a97b01735	trial-89	UNKNOWN			eduar	FINISHED	1784644326182	1784644346909		active	/mlflow/artifacts/3/8dd0782b26a647b0924ccd9a97b01735/artifacts	3	\N
8e5b753561c44b3195234ef62f8f47b2	trial-93	UNKNOWN			eduar	FINISHED	1784644424476	1784644445532		active	/mlflow/artifacts/3/8e5b753561c44b3195234ef62f8f47b2/artifacts	3	\N
a6e212b95bfc4605a1be9024004fb49f	trial-101	UNKNOWN			eduar	FINISHED	1784644719179	1784644751828		active	/mlflow/artifacts/3/a6e212b95bfc4605a1be9024004fb49f/artifacts	3	\N
3401268c42cb4248abf5eb0c4fca768a	trial-91	UNKNOWN			eduar	FINISHED	1784644372416	1784644407091		active	/mlflow/artifacts/3/3401268c42cb4248abf5eb0c4fca768a/artifacts	3	\N
701e73d0f1184acd9682089de7c9c496	trial-92	UNKNOWN			eduar	FINISHED	1784644407220	1784644424345		active	/mlflow/artifacts/3/701e73d0f1184acd9682089de7c9c496/artifacts	3	\N
cfd7a5c4650749a99227270f7490d366	trial-95	UNKNOWN			eduar	FINISHED	1784644488457	1784644522143		active	/mlflow/artifacts/3/cfd7a5c4650749a99227270f7490d366/artifacts	3	\N
111954c77263486eb7b19f050d26b75a	trial-98	UNKNOWN			eduar	FINISHED	1784644603595	1784644645930		active	/mlflow/artifacts/3/111954c77263486eb7b19f050d26b75a/artifacts	3	\N
9c1ced865d204984869839b7cd4f6859	trial-99	UNKNOWN			eduar	FINISHED	1784644646075	1784644684466		active	/mlflow/artifacts/3/9c1ced865d204984869839b7cd4f6859/artifacts	3	\N
3919fe95d06c45a48568942d0a5d55ac	trial-102	UNKNOWN			eduar	FINISHED	1784644751943	1784644802605		active	/mlflow/artifacts/3/3919fe95d06c45a48568942d0a5d55ac/artifacts	3	\N
9e05181cd24c4328ad2c35ebdb23abc7	trial-103	UNKNOWN			eduar	FINISHED	1784644802724	1784644848627		active	/mlflow/artifacts/3/9e05181cd24c4328ad2c35ebdb23abc7/artifacts	3	\N
99058e32615c47359503e260cbce6d91	trial-104	UNKNOWN			eduar	FINISHED	1784644848753	1784644882280		active	/mlflow/artifacts/3/99058e32615c47359503e260cbce6d91/artifacts	3	\N
6d7c5305df6349cebc54d4fa9a31214a	trial-105	UNKNOWN			eduar	FINISHED	1784644882419	1784644913579		active	/mlflow/artifacts/3/6d7c5305df6349cebc54d4fa9a31214a/artifacts	3	\N
08b5f55856b74797a4e16456167adfd5	trial-106	UNKNOWN			eduar	FINISHED	1784644913691	1784644937423		active	/mlflow/artifacts/3/08b5f55856b74797a4e16456167adfd5/artifacts	3	\N
d936f59062f2489586c8c6aa48246a22	trial-107	UNKNOWN			eduar	FINISHED	1784644937524	1784644968355		active	/mlflow/artifacts/3/d936f59062f2489586c8c6aa48246a22/artifacts	3	\N
49388c150ccb4b929ee16b2bb07bb27f	trial-108	UNKNOWN			eduar	FINISHED	1784644968483	1784645006505		active	/mlflow/artifacts/3/49388c150ccb4b929ee16b2bb07bb27f/artifacts	3	\N
27593188f9b74471b4e76392b99287d0	trial-109	UNKNOWN			eduar	FINISHED	1784645006635	1784645041155		active	/mlflow/artifacts/3/27593188f9b74471b4e76392b99287d0/artifacts	3	\N
7d1d89bca5f64345807b2f8710248857	trial-110	UNKNOWN			eduar	FINISHED	1784645041271	1784645079904		active	/mlflow/artifacts/3/7d1d89bca5f64345807b2f8710248857/artifacts	3	\N
0f815fdf0e0645fcbc9bd75f41904b44	trial-111	UNKNOWN			eduar	FINISHED	1784645080065	1784645114594		active	/mlflow/artifacts/3/0f815fdf0e0645fcbc9bd75f41904b44/artifacts	3	\N
fd3500958da74eb280182de207c1c9f1	trial-112	UNKNOWN			eduar	FINISHED	1784645114735	1784645153066		active	/mlflow/artifacts/3/fd3500958da74eb280182de207c1c9f1/artifacts	3	\N
64b0900a1e964558863d196db339900c	trial-113	UNKNOWN			eduar	FINISHED	1784645153192	1784645182922		active	/mlflow/artifacts/3/64b0900a1e964558863d196db339900c/artifacts	3	\N
dc2d72393aae497781f7a6cceff926d7	trial-114	UNKNOWN			eduar	FINISHED	1784645183068	1784645220531		active	/mlflow/artifacts/3/dc2d72393aae497781f7a6cceff926d7/artifacts	3	\N
82bdb95fb73945928fc4add300efc29e	trial-115	UNKNOWN			eduar	FINISHED	1784645220669	1784645247316		active	/mlflow/artifacts/3/82bdb95fb73945928fc4add300efc29e/artifacts	3	\N
c04b03a1eb034e30ab0dbfd07f0a56bc	trial-116	UNKNOWN			eduar	FINISHED	1784645247440	1784645264534		active	/mlflow/artifacts/3/c04b03a1eb034e30ab0dbfd07f0a56bc/artifacts	3	\N
61939d5dc91f45f0b71ee70059923014	trial-117	UNKNOWN			eduar	FINISHED	1784645264681	1784645293653		active	/mlflow/artifacts/3/61939d5dc91f45f0b71ee70059923014/artifacts	3	\N
e62dd40594234fe2b1e7032791dd20a8	trial-118	UNKNOWN			eduar	FINISHED	1784645293767	1784645319644		active	/mlflow/artifacts/3/e62dd40594234fe2b1e7032791dd20a8/artifacts	3	\N
fd9968abd7b9464aa499ac3910ae6d59	trial-119	UNKNOWN			eduar	FINISHED	1784645319759	1784645356805		active	/mlflow/artifacts/3/fd9968abd7b9464aa499ac3910ae6d59/artifacts	3	\N
40baf7c768a8472dac8cadf8920e416c	trial-120	UNKNOWN			eduar	FINISHED	1784645356930	1784645371260		active	/mlflow/artifacts/3/40baf7c768a8472dac8cadf8920e416c/artifacts	3	\N
4b6e2f4862564695a32ae677d3ebd136	trial-121	UNKNOWN			eduar	FINISHED	1784645371387	1784645397457		active	/mlflow/artifacts/3/4b6e2f4862564695a32ae677d3ebd136/artifacts	3	\N
82eba4c14c7b4ac791e397f13b4544de	trial-122	UNKNOWN			eduar	FINISHED	1784645397564	1784645427082		active	/mlflow/artifacts/3/82eba4c14c7b4ac791e397f13b4544de/artifacts	3	\N
86e01e0667ec427599d0c10de411791f	trial-123	UNKNOWN			eduar	FINISHED	1784645427201	1784645464073		active	/mlflow/artifacts/3/86e01e0667ec427599d0c10de411791f/artifacts	3	\N
982fe4200d6b4f95a5e5e436b1885c0b	trial-124	UNKNOWN			eduar	FINISHED	1784645464201	1784645502463		active	/mlflow/artifacts/3/982fe4200d6b4f95a5e5e436b1885c0b/artifacts	3	\N
ea474e0674fd492c81f549be6c166cd2	trial-125	UNKNOWN			eduar	FINISHED	1784645502578	1784645529647		active	/mlflow/artifacts/3/ea474e0674fd492c81f549be6c166cd2/artifacts	3	\N
6e7d042ef55247409d9390031ff02a47	trial-126	UNKNOWN			eduar	FINISHED	1784645529759	1784645564625		active	/mlflow/artifacts/3/6e7d042ef55247409d9390031ff02a47/artifacts	3	\N
caa44697e4d24e98b6d5f91363319ce0	trial-127	UNKNOWN			eduar	FINISHED	1784645564768	1784645597336		active	/mlflow/artifacts/3/caa44697e4d24e98b6d5f91363319ce0/artifacts	3	\N
09141ce7bff34a53b91aedc1c71e0d1c	trial-128	UNKNOWN			eduar	FINISHED	1784645597475	1784645638831		active	/mlflow/artifacts/3/09141ce7bff34a53b91aedc1c71e0d1c/artifacts	3	\N
c1dbce29b41c445ba8138ce9811b0068	trial-129	UNKNOWN			eduar	FINISHED	1784645638959	1784645665782		active	/mlflow/artifacts/3/c1dbce29b41c445ba8138ce9811b0068/artifacts	3	\N
20e40ce2d6c44003bb759ab6e1351170	trial-130	UNKNOWN			eduar	FINISHED	1784645665916	1784645695294		active	/mlflow/artifacts/3/20e40ce2d6c44003bb759ab6e1351170/artifacts	3	\N
079ff97d445546cbb52ed19b2d617517	trial-131	UNKNOWN			eduar	FINISHED	1784645695412	1784645721625		active	/mlflow/artifacts/3/079ff97d445546cbb52ed19b2d617517/artifacts	3	\N
a8008dd2ea1b43f196f1024d66cd3866	trial-132	UNKNOWN			eduar	FINISHED	1784645721795	1784645764495		active	/mlflow/artifacts/3/a8008dd2ea1b43f196f1024d66cd3866/artifacts	3	\N
ed12fbe584314822bdbf2b28e61fd9f4	trial-133	UNKNOWN			eduar	FINISHED	1784645764627	1784645791345		active	/mlflow/artifacts/3/ed12fbe584314822bdbf2b28e61fd9f4/artifacts	3	\N
8dd5e097c3e7404b8bb68ce4d54c81da	trial-134	UNKNOWN			eduar	FINISHED	1784645791460	1784645811347		active	/mlflow/artifacts/3/8dd5e097c3e7404b8bb68ce4d54c81da/artifacts	3	\N
5dfe43d07bae4c3e8be8f52e18ee4e21	trial-135	UNKNOWN			eduar	FINISHED	1784645811471	1784645830343		active	/mlflow/artifacts/3/5dfe43d07bae4c3e8be8f52e18ee4e21/artifacts	3	\N
373663ce084a43b8bfb50018919a65db	trial-136	UNKNOWN			eduar	FINISHED	1784645830462	1784645874535		active	/mlflow/artifacts/3/373663ce084a43b8bfb50018919a65db/artifacts	3	\N
bf5751b68e994a81998944e44b1b573d	trial-137	UNKNOWN			eduar	FINISHED	1784645874650	1784645910453		active	/mlflow/artifacts/3/bf5751b68e994a81998944e44b1b573d/artifacts	3	\N
8c20356faa924d4fb9eba650a0792cc3	trial-138	UNKNOWN			eduar	FINISHED	1784645910567	1784645937101		active	/mlflow/artifacts/3/8c20356faa924d4fb9eba650a0792cc3/artifacts	3	\N
5e4c9e7de52d47a391919bb68173e02c	trial-139	UNKNOWN			eduar	FINISHED	1784645937222	1784645976980		active	/mlflow/artifacts/3/5e4c9e7de52d47a391919bb68173e02c/artifacts	3	\N
81cc585288d144dbaed1346c79c254ca	trial-140	UNKNOWN			eduar	FINISHED	1784645977118	1784646022432		active	/mlflow/artifacts/3/81cc585288d144dbaed1346c79c254ca/artifacts	3	\N
729adea5b08d4ad4a4653e52efbafee9	trial-141	UNKNOWN			eduar	FINISHED	1784646022555	1784646042811		active	/mlflow/artifacts/3/729adea5b08d4ad4a4653e52efbafee9/artifacts	3	\N
aea8d7c689ae4b289a07ea312f8cd967	trial-142	UNKNOWN			eduar	FINISHED	1784646042959	1784646074328		active	/mlflow/artifacts/3/aea8d7c689ae4b289a07ea312f8cd967/artifacts	3	\N
c3c64461db474abfb41a7918f0836f40	trial-143	UNKNOWN			eduar	FINISHED	1784646074506	1784646114605		active	/mlflow/artifacts/3/c3c64461db474abfb41a7918f0836f40/artifacts	3	\N
52134bc6efa44da38234f805e719543d	trial-144	UNKNOWN			eduar	FINISHED	1784646114750	1784646153922		active	/mlflow/artifacts/3/52134bc6efa44da38234f805e719543d/artifacts	3	\N
7263fee2dbbf4c2c8d21f11ee7cfb4d5	trial-145	UNKNOWN			eduar	FINISHED	1784646154088	1784646192759		active	/mlflow/artifacts/3/7263fee2dbbf4c2c8d21f11ee7cfb4d5/artifacts	3	\N
858e7d66bbc44d07b4318652fe66bf8a	trial-146	UNKNOWN			eduar	FINISHED	1784646192940	1784646222106		active	/mlflow/artifacts/3/858e7d66bbc44d07b4318652fe66bf8a/artifacts	3	\N
b93a661f89624444924de260e56e2235	trial-147	UNKNOWN			eduar	FINISHED	1784646222225	1784646260201		active	/mlflow/artifacts/3/b93a661f89624444924de260e56e2235/artifacts	3	\N
b3a13dff7789467091ec52640e9adc99	trial-148	UNKNOWN			eduar	FINISHED	1784646260348	1784646289415		active	/mlflow/artifacts/3/b3a13dff7789467091ec52640e9adc99/artifacts	3	\N
aaa258948ae9488bb474a158d63f9148	trial-149	UNKNOWN			eduar	FINISHED	1784646289552	1784646313677		active	/mlflow/artifacts/3/aaa258948ae9488bb474a158d63f9148/artifacts	3	\N
f63cff703fe14c219fa8ae960e639722	champion-model	UNKNOWN			eduar	FAILED	1784652632101	1784652646813		active	/mlflow/artifacts/4/f63cff703fe14c219fa8ae960e639722/artifacts	4	\N
a1238f4eb0434cd690f334476cb2ad9c	champion-model	UNKNOWN			eduar	FAILED	1784652673527	1784652678346		active	/mlflow/artifacts/4/a1238f4eb0434cd690f334476cb2ad9c/artifacts	4	\N
1858617a3b064a73a5af67ad947b5cdf	gifted-trout-680	UNKNOWN			eduar	FAILED	1784657959834	1784657989139		active	/mlflow/artifacts/4/1858617a3b064a73a5af67ad947b5cdf/artifacts	4	\N
2cb17c9ab3fb42f6a309da1001231d6f	trial-0	UNKNOWN			eduar	FINISHED	1784660037232	1784660102122		active	/mlflow/artifacts/3/2cb17c9ab3fb42f6a309da1001231d6f/artifacts	3	\N
343a984aca99424a9ea4fde70eae7fd6	trial-1	UNKNOWN			eduar	FINISHED	1784660102247	1784660148719		active	/mlflow/artifacts/3/343a984aca99424a9ea4fde70eae7fd6/artifacts	3	\N
fe50acdbb80f44b3b833e6da5d8494d5	trial-2	UNKNOWN			eduar	FINISHED	1784660148798	1784660197958		active	/mlflow/artifacts/3/fe50acdbb80f44b3b833e6da5d8494d5/artifacts	3	\N
639bd817783446149d47dfcd0926f1a0	trial-3	UNKNOWN			eduar	FINISHED	1784660198040	1784660238860		active	/mlflow/artifacts/3/639bd817783446149d47dfcd0926f1a0/artifacts	3	\N
2dd58258a1c14b7e9fbbcf0a30084f7d	trial-4	UNKNOWN			eduar	FINISHED	1784660238937	1784660284607		active	/mlflow/artifacts/3/2dd58258a1c14b7e9fbbcf0a30084f7d/artifacts	3	\N
b6ad1bd3b5e24e56a38c6e514a836fbb	trial-5	UNKNOWN			eduar	FINISHED	1784660284693	1784660297878		active	/mlflow/artifacts/3/b6ad1bd3b5e24e56a38c6e514a836fbb/artifacts	3	\N
3d117da059cf48f1b0389bf9323ce232	trial-6	UNKNOWN			eduar	FINISHED	1784660297939	1784660343236		active	/mlflow/artifacts/3/3d117da059cf48f1b0389bf9323ce232/artifacts	3	\N
175caae5af7f4140b4ecae075484bb7b	trial-7	UNKNOWN			eduar	FINISHED	1784660343326	1784660367505		active	/mlflow/artifacts/3/175caae5af7f4140b4ecae075484bb7b/artifacts	3	\N
37b22dee0c674dc0ae4c25e6ee9d21d1	trial-8	UNKNOWN			eduar	FINISHED	1784660367572	1784660403472		active	/mlflow/artifacts/3/37b22dee0c674dc0ae4c25e6ee9d21d1/artifacts	3	\N
5b7ac14d710141e0ae9db4df5d76863d	trial-9	UNKNOWN			eduar	FINISHED	1784660403537	1784660427920		active	/mlflow/artifacts/3/5b7ac14d710141e0ae9db4df5d76863d/artifacts	3	\N
e5c01080e79f4145ae6c1fbbeb6dab7f	trial-10	UNKNOWN			eduar	FINISHED	1784660428087	1784660444119		active	/mlflow/artifacts/3/e5c01080e79f4145ae6c1fbbeb6dab7f/artifacts	3	\N
db19dbd296a547468d99e1eac5c48d91	trial-11	UNKNOWN			eduar	FINISHED	1784660444264	1784660521442		active	/mlflow/artifacts/3/db19dbd296a547468d99e1eac5c48d91/artifacts	3	\N
5ca501b4ad684b6d8ca4c0d74bc38d7d	trial-12	UNKNOWN			eduar	FINISHED	1784660521604	1784660545231		active	/mlflow/artifacts/3/5ca501b4ad684b6d8ca4c0d74bc38d7d/artifacts	3	\N
920842c57a5a49bb87e14ce762de0e6f	trial-13	UNKNOWN			eduar	FINISHED	1784660545355	1784660572608		active	/mlflow/artifacts/3/920842c57a5a49bb87e14ce762de0e6f/artifacts	3	\N
12c0eb897e9e4e799fa7e402ede53e68	trial-14	UNKNOWN			eduar	FINISHED	1784660572734	1784660604655		active	/mlflow/artifacts/3/12c0eb897e9e4e799fa7e402ede53e68/artifacts	3	\N
464465db08d54ca3890683e7f08018cd	trial-15	UNKNOWN			eduar	FINISHED	1784660604763	1784660624001		active	/mlflow/artifacts/3/464465db08d54ca3890683e7f08018cd/artifacts	3	\N
2719cadee66a4cddb04bd6047c0bdea1	trial-16	UNKNOWN			eduar	FINISHED	1784660624118	1784660649545		active	/mlflow/artifacts/3/2719cadee66a4cddb04bd6047c0bdea1/artifacts	3	\N
7da83a5b702d4cd9a3b6288e6ec4a963	trial-17	UNKNOWN			eduar	FINISHED	1784660649662	1784660664180		active	/mlflow/artifacts/3/7da83a5b702d4cd9a3b6288e6ec4a963/artifacts	3	\N
dab10324d6874b25b032b2e41b538db5	trial-18	UNKNOWN			eduar	FINISHED	1784660664291	1784660679446		active	/mlflow/artifacts/3/dab10324d6874b25b032b2e41b538db5/artifacts	3	\N
cceff74de09a44f48ae9e027c5f35536	optuna-search	UNKNOWN			eduar	FINISHED	1784660037022	1784665118681		active	/mlflow/artifacts/3/cceff74de09a44f48ae9e027c5f35536/artifacts	3	\N
0fa292059a01459388a9848f32021680	trial-19	UNKNOWN			eduar	FINISHED	1784660679574	1784660699785		active	/mlflow/artifacts/3/0fa292059a01459388a9848f32021680/artifacts	3	\N
a88dec410f58417cb1ad18c7cb2485f3	trial-20	UNKNOWN			eduar	FINISHED	1784660699912	1784660717291		active	/mlflow/artifacts/3/a88dec410f58417cb1ad18c7cb2485f3/artifacts	3	\N
bdb2446748cb45d9b995eaf2595da298	trial-22	UNKNOWN			eduar	FINISHED	1784660732435	1784660747751		active	/mlflow/artifacts/3/bdb2446748cb45d9b995eaf2595da298/artifacts	3	\N
5aa083ca632a4a3ba6f7762d0c339e85	trial-28	UNKNOWN			eduar	FINISHED	1784660870259	1784660893885		active	/mlflow/artifacts/3/5aa083ca632a4a3ba6f7762d0c339e85/artifacts	3	\N
dfdba455d2f94583a9a6c822f573f830	trial-29	UNKNOWN			eduar	FINISHED	1784660894005	1784660907915		active	/mlflow/artifacts/3/dfdba455d2f94583a9a6c822f573f830/artifacts	3	\N
2715b04b5bad4a7ca933580943a2814a	trial-32	UNKNOWN			eduar	FINISHED	1784660999325	1784661037702		active	/mlflow/artifacts/3/2715b04b5bad4a7ca933580943a2814a/artifacts	3	\N
95bce22e5e554d8298e264b28c9e8fc5	trial-37	UNKNOWN			eduar	FINISHED	1784661157246	1784661185461		active	/mlflow/artifacts/3/95bce22e5e554d8298e264b28c9e8fc5/artifacts	3	\N
bc449f79816a40b389ab2d1898b1b8f4	trial-38	UNKNOWN			eduar	FINISHED	1784661185594	1784661255161		active	/mlflow/artifacts/3/bc449f79816a40b389ab2d1898b1b8f4/artifacts	3	\N
0b2d11961fe2427d959a976e2033ca2e	trial-39	UNKNOWN			eduar	FINISHED	1784661255293	1784661324544		active	/mlflow/artifacts/3/0b2d11961fe2427d959a976e2033ca2e/artifacts	3	\N
308716eedad140d8b8c2c920a5203a28	trial-41	UNKNOWN			eduar	FINISHED	1784661365201	1784661413640		active	/mlflow/artifacts/3/308716eedad140d8b8c2c920a5203a28/artifacts	3	\N
d720a01642da4ff5b01c61771cdf9d91	trial-43	UNKNOWN			eduar	FINISHED	1784661453794	1784661488270		active	/mlflow/artifacts/3/d720a01642da4ff5b01c61771cdf9d91/artifacts	3	\N
c9bd89e9733b418e8a4c762cccf8aa2d	trial-46	UNKNOWN			eduar	FINISHED	1784661564396	1784661612285		active	/mlflow/artifacts/3/c9bd89e9733b418e8a4c762cccf8aa2d/artifacts	3	\N
61bef132335149da8fc1bcd646945380	trial-47	UNKNOWN			eduar	FINISHED	1784661612426	1784661643315		active	/mlflow/artifacts/3/61bef132335149da8fc1bcd646945380/artifacts	3	\N
57a6a6513f3d4a139635fb009beabe0e	trial-21	UNKNOWN			eduar	FINISHED	1784660717411	1784660732319		active	/mlflow/artifacts/3/57a6a6513f3d4a139635fb009beabe0e/artifacts	3	\N
9c030b074f6740f7b9f76b2dddeffb8c	trial-44	UNKNOWN			eduar	FINISHED	1784661488399	1784661517006		active	/mlflow/artifacts/3/9c030b074f6740f7b9f76b2dddeffb8c/artifacts	3	\N
4fe6b8e9bbef4cb49dd0b503775f095e	trial-45	UNKNOWN			eduar	FINISHED	1784661517180	1784661564265		active	/mlflow/artifacts/3/4fe6b8e9bbef4cb49dd0b503775f095e/artifacts	3	\N
52254688abc64f459641607d3a8dfb6a	trial-23	UNKNOWN			eduar	FINISHED	1784660747893	1784660774019		active	/mlflow/artifacts/3/52254688abc64f459641607d3a8dfb6a/artifacts	3	\N
7d976b24c40b49f396e96bc3fb05fd94	trial-24	UNKNOWN			eduar	FINISHED	1784660774163	1784660790228		active	/mlflow/artifacts/3/7d976b24c40b49f396e96bc3fb05fd94/artifacts	3	\N
c30e3c7d28f94109946cce7fcb30cba5	trial-25	UNKNOWN			eduar	FINISHED	1784660790375	1784660834811		active	/mlflow/artifacts/3/c30e3c7d28f94109946cce7fcb30cba5/artifacts	3	\N
2bc4f68109344e3d8099ec77369d61d3	trial-30	UNKNOWN			eduar	FINISHED	1784660908044	1784660947163		active	/mlflow/artifacts/3/2bc4f68109344e3d8099ec77369d61d3/artifacts	3	\N
d8b6ad6854ce4c91948c621ba3b09130	trial-34	UNKNOWN			eduar	FINISHED	1784661072189	1784661125660		active	/mlflow/artifacts/3/d8b6ad6854ce4c91948c621ba3b09130/artifacts	3	\N
621e30a66f4f4f2c9e8e5d2e3d26b6f9	trial-35	UNKNOWN			eduar	FINISHED	1784661125786	1784661142697		active	/mlflow/artifacts/3/621e30a66f4f4f2c9e8e5d2e3d26b6f9/artifacts	3	\N
b49827a8551c45039120e727c2742f3c	trial-36	UNKNOWN			eduar	FINISHED	1784661142815	1784661157111		active	/mlflow/artifacts/3/b49827a8551c45039120e727c2742f3c/artifacts	3	\N
b4b583974c19441a99bf1809f32d97ac	trial-42	UNKNOWN			eduar	FINISHED	1784661413764	1784661453653		active	/mlflow/artifacts/3/b4b583974c19441a99bf1809f32d97ac/artifacts	3	\N
532603551a954e97bc6f82485f631d2e	trial-49	UNKNOWN			eduar	FINISHED	1784661672006	1784661688433		active	/mlflow/artifacts/3/532603551a954e97bc6f82485f631d2e/artifacts	3	\N
1bb7906f11194fa6b7498584acfcaac0	trial-26	UNKNOWN			eduar	FINISHED	1784660834971	1784660855945		active	/mlflow/artifacts/3/1bb7906f11194fa6b7498584acfcaac0/artifacts	3	\N
350e32e8aae5456fb766e828852e52f8	trial-27	UNKNOWN			eduar	FINISHED	1784660856077	1784660870119		active	/mlflow/artifacts/3/350e32e8aae5456fb766e828852e52f8/artifacts	3	\N
993859e43a124bfbba2b2ebb47441c36	trial-31	UNKNOWN			eduar	FINISHED	1784660947268	1784660999147		active	/mlflow/artifacts/3/993859e43a124bfbba2b2ebb47441c36/artifacts	3	\N
b7b0e8f2158c4888aa058c14df7a1439	trial-33	UNKNOWN			eduar	FINISHED	1784661037901	1784661072039		active	/mlflow/artifacts/3/b7b0e8f2158c4888aa058c14df7a1439/artifacts	3	\N
000523ae15fd47739ed9fccc383746ef	trial-40	UNKNOWN			eduar	FINISHED	1784661324657	1784661365067		active	/mlflow/artifacts/3/000523ae15fd47739ed9fccc383746ef/artifacts	3	\N
8c036e2f01ae4dce9b24165f8105ca06	trial-48	UNKNOWN			eduar	FINISHED	1784661643474	1784661671883		active	/mlflow/artifacts/3/8c036e2f01ae4dce9b24165f8105ca06/artifacts	3	\N
a4fe1e00ac0e4e67b019e182ca42dfa5	trial-50	UNKNOWN			eduar	FINISHED	1784661688570	1784661727795		active	/mlflow/artifacts/3/a4fe1e00ac0e4e67b019e182ca42dfa5/artifacts	3	\N
2b432c32784143a9b9d3be8670c9b2de	trial-51	UNKNOWN			eduar	FINISHED	1784661727934	1784661761803		active	/mlflow/artifacts/3/2b432c32784143a9b9d3be8670c9b2de/artifacts	3	\N
91efa9c98d164aedac595d534867cfa9	trial-52	UNKNOWN			eduar	FINISHED	1784661761930	1784661799037		active	/mlflow/artifacts/3/91efa9c98d164aedac595d534867cfa9/artifacts	3	\N
7cabb843d24d4b86a34757eaf1696d59	trial-53	UNKNOWN			eduar	FINISHED	1784661799147	1784661850555		active	/mlflow/artifacts/3/7cabb843d24d4b86a34757eaf1696d59/artifacts	3	\N
cbe54d84d2f84e4b982ad2d27427c7a7	trial-54	UNKNOWN			eduar	FINISHED	1784661850695	1784661867442		active	/mlflow/artifacts/3/cbe54d84d2f84e4b982ad2d27427c7a7/artifacts	3	\N
97fb30d77c874bbe909e9b34ff9ab219	trial-55	UNKNOWN			eduar	FINISHED	1784661867572	1784661917860		active	/mlflow/artifacts/3/97fb30d77c874bbe909e9b34ff9ab219/artifacts	3	\N
23cfec62bb2b4c81b834e33e1d64015a	trial-56	UNKNOWN			eduar	FINISHED	1784661917994	1784661949146		active	/mlflow/artifacts/3/23cfec62bb2b4c81b834e33e1d64015a/artifacts	3	\N
4ad932f7dcda4517b7b5cc0c8beac404	trial-57	UNKNOWN			eduar	FINISHED	1784661949295	1784661984302		active	/mlflow/artifacts/3/4ad932f7dcda4517b7b5cc0c8beac404/artifacts	3	\N
a83392e9cd7a4265b05f9abeced43638	trial-58	UNKNOWN			eduar	FINISHED	1784661984428	1784662029307		active	/mlflow/artifacts/3/a83392e9cd7a4265b05f9abeced43638/artifacts	3	\N
5271cb97dc8e4421816e4fbc4e06b329	trial-59	UNKNOWN			eduar	FINISHED	1784662029432	1784662058355		active	/mlflow/artifacts/3/5271cb97dc8e4421816e4fbc4e06b329/artifacts	3	\N
193b290a18504fa8a42991b624278dbf	trial-60	UNKNOWN			eduar	FINISHED	1784662058477	1784662117906		active	/mlflow/artifacts/3/193b290a18504fa8a42991b624278dbf/artifacts	3	\N
384089aee8ff469e884eb523460d2e23	trial-61	UNKNOWN			eduar	FINISHED	1784662118046	1784662169908		active	/mlflow/artifacts/3/384089aee8ff469e884eb523460d2e23/artifacts	3	\N
9ee14964976f41c9a0d4773391dc1b89	trial-62	UNKNOWN			eduar	FINISHED	1784662170037	1784662245291		active	/mlflow/artifacts/3/9ee14964976f41c9a0d4773391dc1b89/artifacts	3	\N
bbf38d0761d14a96a7f6af68d83b297c	trial-63	UNKNOWN			eduar	FINISHED	1784662245489	1784662277713		active	/mlflow/artifacts/3/bbf38d0761d14a96a7f6af68d83b297c/artifacts	3	\N
e465ea368468417f95c02d9736ea13d2	trial-64	UNKNOWN			eduar	FINISHED	1784662277847	1784662307595		active	/mlflow/artifacts/3/e465ea368468417f95c02d9736ea13d2/artifacts	3	\N
7f39848a745a4f55b4b6f53656bbea09	trial-65	UNKNOWN			eduar	FINISHED	1784662307724	1784662344927		active	/mlflow/artifacts/3/7f39848a745a4f55b4b6f53656bbea09/artifacts	3	\N
99f8a6c1a99042518e4a0ef2de67cbd0	trial-66	UNKNOWN			eduar	FINISHED	1784662345069	1784662373687		active	/mlflow/artifacts/3/99f8a6c1a99042518e4a0ef2de67cbd0/artifacts	3	\N
82ae9253c99347c28805e14bb275d4e1	trial-67	UNKNOWN			eduar	FINISHED	1784662373815	1784662405202		active	/mlflow/artifacts/3/82ae9253c99347c28805e14bb275d4e1/artifacts	3	\N
ea05524904e94189b607f30d35114cf5	trial-68	UNKNOWN			eduar	FINISHED	1784662405336	1784662448623		active	/mlflow/artifacts/3/ea05524904e94189b607f30d35114cf5/artifacts	3	\N
59630d004d38484f8b30f453b17fd561	trial-69	UNKNOWN			eduar	FINISHED	1784662448730	1784662477910		active	/mlflow/artifacts/3/59630d004d38484f8b30f453b17fd561/artifacts	3	\N
143106f491a142fa98764b4036346fc5	trial-70	UNKNOWN			eduar	FINISHED	1784662478037	1784662508193		active	/mlflow/artifacts/3/143106f491a142fa98764b4036346fc5/artifacts	3	\N
212e3cc9c33a469097370a89878e6e0d	trial-71	UNKNOWN			eduar	FINISHED	1784662508321	1784662543442		active	/mlflow/artifacts/3/212e3cc9c33a469097370a89878e6e0d/artifacts	3	\N
5098e5701fc04d33a5d78ff3e0c2d8f2	trial-72	UNKNOWN			eduar	FINISHED	1784662543562	1784662590373		active	/mlflow/artifacts/3/5098e5701fc04d33a5d78ff3e0c2d8f2/artifacts	3	\N
0b4fd1f6f7d84dfe891162a68110faa4	trial-73	UNKNOWN			eduar	FINISHED	1784662590495	1784662626252		active	/mlflow/artifacts/3/0b4fd1f6f7d84dfe891162a68110faa4/artifacts	3	\N
c8478da13b1d44e09ff6954fe7f8ceb5	trial-74	UNKNOWN			eduar	FINISHED	1784662626376	1784662659972		active	/mlflow/artifacts/3/c8478da13b1d44e09ff6954fe7f8ceb5/artifacts	3	\N
2593c87053c24c5ab46a701293e5da1c	trial-75	UNKNOWN			eduar	FINISHED	1784662660112	1784662702866		active	/mlflow/artifacts/3/2593c87053c24c5ab46a701293e5da1c/artifacts	3	\N
0a433fa3378a4b90b664cc4fde90ed21	trial-76	UNKNOWN			eduar	FINISHED	1784662702996	1784662721091		active	/mlflow/artifacts/3/0a433fa3378a4b90b664cc4fde90ed21/artifacts	3	\N
5731165fd9d341c093634c24885b4b80	trial-77	UNKNOWN			eduar	FINISHED	1784662721254	1784662740284		active	/mlflow/artifacts/3/5731165fd9d341c093634c24885b4b80/artifacts	3	\N
6fd1e2f0387c42e6bc1b573547aa39c7	trial-78	UNKNOWN			eduar	FINISHED	1784662740401	1784662772888		active	/mlflow/artifacts/3/6fd1e2f0387c42e6bc1b573547aa39c7/artifacts	3	\N
8c6c444e121e4c82ad5345c29fcd297d	trial-79	UNKNOWN			eduar	FINISHED	1784662773002	1784662789036		active	/mlflow/artifacts/3/8c6c444e121e4c82ad5345c29fcd297d/artifacts	3	\N
14f0de2bdc004a6ca97d19b2d9dad96b	trial-80	UNKNOWN			eduar	FINISHED	1784662789160	1784662821745		active	/mlflow/artifacts/3/14f0de2bdc004a6ca97d19b2d9dad96b/artifacts	3	\N
7f16b61fe03848238ff296583f7d49f5	trial-81	UNKNOWN			eduar	FINISHED	1784662821882	1784662846744		active	/mlflow/artifacts/3/7f16b61fe03848238ff296583f7d49f5/artifacts	3	\N
531d154bc65c4e3c9e3e691c91d4e598	trial-82	UNKNOWN			eduar	FINISHED	1784662846866	1784662877045		active	/mlflow/artifacts/3/531d154bc65c4e3c9e3e691c91d4e598/artifacts	3	\N
7166345b17ac40e3a6384bc3e57a4e38	trial-83	UNKNOWN			eduar	FINISHED	1784662877176	1784662941925		active	/mlflow/artifacts/3/7166345b17ac40e3a6384bc3e57a4e38/artifacts	3	\N
e04590dc86674c0985b160f47a15d939	trial-84	UNKNOWN			eduar	FINISHED	1784662942049	1784662970832		active	/mlflow/artifacts/3/e04590dc86674c0985b160f47a15d939/artifacts	3	\N
08a4d70131f54e81bd0d47a5448e3d43	trial-85	UNKNOWN			eduar	FINISHED	1784662970954	1784663006424		active	/mlflow/artifacts/3/08a4d70131f54e81bd0d47a5448e3d43/artifacts	3	\N
3a54e130da3a488e9cddd8f564b50636	trial-86	UNKNOWN			eduar	FINISHED	1784663006540	1784663019453		active	/mlflow/artifacts/3/3a54e130da3a488e9cddd8f564b50636/artifacts	3	\N
196f279c8b2a47a3ae0b5e4069634bfe	trial-87	UNKNOWN			eduar	FINISHED	1784663019583	1784663038202		active	/mlflow/artifacts/3/196f279c8b2a47a3ae0b5e4069634bfe/artifacts	3	\N
7305560d783f4197a5a7e63dcb91495c	trial-88	UNKNOWN			eduar	FINISHED	1784663038355	1784663051285		active	/mlflow/artifacts/3/7305560d783f4197a5a7e63dcb91495c/artifacts	3	\N
af4fa3186c554df8bd52d00efdd3b518	trial-89	UNKNOWN			eduar	FINISHED	1784663051395	1784663063738		active	/mlflow/artifacts/3/af4fa3186c554df8bd52d00efdd3b518/artifacts	3	\N
0e6ba24868c9455f9324ff11fa6f37c0	trial-90	UNKNOWN			eduar	FINISHED	1784663063881	1784663095175		active	/mlflow/artifacts/3/0e6ba24868c9455f9324ff11fa6f37c0/artifacts	3	\N
e6f37d31a9df48adbf7ce400630985f2	trial-91	UNKNOWN			eduar	FINISHED	1784663095293	1784663125643		active	/mlflow/artifacts/3/e6f37d31a9df48adbf7ce400630985f2/artifacts	3	\N
5219ab1ee77e4d0a9b2ea76665637741	trial-92	UNKNOWN			eduar	FINISHED	1784663125778	1784663139917		active	/mlflow/artifacts/3/5219ab1ee77e4d0a9b2ea76665637741/artifacts	3	\N
b7a96024f405468da0046f142f3fba28	trial-93	UNKNOWN			eduar	FINISHED	1784663140073	1784663168275		active	/mlflow/artifacts/3/b7a96024f405468da0046f142f3fba28/artifacts	3	\N
cc82112ae9004ab48a54576c09abb51e	trial-94	UNKNOWN			eduar	FINISHED	1784663168403	1784663198365		active	/mlflow/artifacts/3/cc82112ae9004ab48a54576c09abb51e/artifacts	3	\N
df12860a7b4a46e9abaef76ff774590e	trial-95	UNKNOWN			eduar	FINISHED	1784663198496	1784663224775		active	/mlflow/artifacts/3/df12860a7b4a46e9abaef76ff774590e/artifacts	3	\N
a45d4a14e3cb4767b85a0dd503888266	trial-96	UNKNOWN			eduar	FINISHED	1784663224947	1784663264791		active	/mlflow/artifacts/3/a45d4a14e3cb4767b85a0dd503888266/artifacts	3	\N
91fb3e7556b448e794bc7f57497b4ac4	trial-97	UNKNOWN			eduar	FINISHED	1784663264918	1784663288463		active	/mlflow/artifacts/3/91fb3e7556b448e794bc7f57497b4ac4/artifacts	3	\N
28adcc19e5354574966fd00385b49f1a	trial-98	UNKNOWN			eduar	FINISHED	1784663288656	1784663312331		active	/mlflow/artifacts/3/28adcc19e5354574966fd00385b49f1a/artifacts	3	\N
fd79d84e5b9a463e8c5d9ad2eebe966f	trial-99	UNKNOWN			eduar	FINISHED	1784663312479	1784663346618		active	/mlflow/artifacts/3/fd79d84e5b9a463e8c5d9ad2eebe966f/artifacts	3	\N
bd4a6462eb314b5cb3c57f9db508a4e4	trial-100	UNKNOWN			eduar	FINISHED	1784663346738	1784663386799		active	/mlflow/artifacts/3/bd4a6462eb314b5cb3c57f9db508a4e4/artifacts	3	\N
3405dcc6ebdd44609d0d260aa28f3122	trial-101	UNKNOWN			eduar	FINISHED	1784663386924	1784663413939		active	/mlflow/artifacts/3/3405dcc6ebdd44609d0d260aa28f3122/artifacts	3	\N
ee5e81cfc9ad4fda8222a171057e4ffc	trial-102	UNKNOWN			eduar	FINISHED	1784663414096	1784663457589		active	/mlflow/artifacts/3/ee5e81cfc9ad4fda8222a171057e4ffc/artifacts	3	\N
cca09d0a7a824be1b885d47ad28e10a4	trial-103	UNKNOWN			eduar	FINISHED	1784663457733	1784663494609		active	/mlflow/artifacts/3/cca09d0a7a824be1b885d47ad28e10a4/artifacts	3	\N
c599cc0f5ca645e989b7478887d03f28	trial-104	UNKNOWN			eduar	FINISHED	1784663494728	1784663536084		active	/mlflow/artifacts/3/c599cc0f5ca645e989b7478887d03f28/artifacts	3	\N
de0278a9f23d4eea946bc673a797c3c2	trial-105	UNKNOWN			eduar	FINISHED	1784663536210	1784663578621		active	/mlflow/artifacts/3/de0278a9f23d4eea946bc673a797c3c2/artifacts	3	\N
130f444dde0c42df9f6abc1bd79d9b77	trial-106	UNKNOWN			eduar	FINISHED	1784663578766	1784663617222		active	/mlflow/artifacts/3/130f444dde0c42df9f6abc1bd79d9b77/artifacts	3	\N
e3ca2557a9f543f7952783569ae86534	trial-107	UNKNOWN			eduar	FINISHED	1784663617334	1784663640498		active	/mlflow/artifacts/3/e3ca2557a9f543f7952783569ae86534/artifacts	3	\N
2ad9ddee054f4a0fa0c5e251a177dd6a	trial-108	UNKNOWN			eduar	FINISHED	1784663640612	1784663669094		active	/mlflow/artifacts/3/2ad9ddee054f4a0fa0c5e251a177dd6a/artifacts	3	\N
117e0e60760d44ac9ef154cceb212171	trial-109	UNKNOWN			eduar	FINISHED	1784663669223	1784663698820		active	/mlflow/artifacts/3/117e0e60760d44ac9ef154cceb212171/artifacts	3	\N
62ca7fadf67347b29ca9598d327eebd2	trial-110	UNKNOWN			eduar	FINISHED	1784663698988	1784663725393		active	/mlflow/artifacts/3/62ca7fadf67347b29ca9598d327eebd2/artifacts	3	\N
ba4d5a30aa02426d9e1536625f3ebe6a	trial-111	UNKNOWN			eduar	FINISHED	1784663725540	1784663768355		active	/mlflow/artifacts/3/ba4d5a30aa02426d9e1536625f3ebe6a/artifacts	3	\N
98d0deba9dd641d281274cbf802081fb	trial-112	UNKNOWN			eduar	FINISHED	1784663768487	1784663781535		active	/mlflow/artifacts/3/98d0deba9dd641d281274cbf802081fb/artifacts	3	\N
cd47568195194bd4b3b7f694f1a08f9a	trial-113	UNKNOWN			eduar	FINISHED	1784663781679	1784663798180		active	/mlflow/artifacts/3/cd47568195194bd4b3b7f694f1a08f9a/artifacts	3	\N
30bde976c0b84a36b835f3d18848103c	trial-114	UNKNOWN			eduar	FINISHED	1784663798307	1784663819006		active	/mlflow/artifacts/3/30bde976c0b84a36b835f3d18848103c/artifacts	3	\N
200e44c932ce4dad8671cd5da9b409d9	trial-115	UNKNOWN			eduar	FINISHED	1784663819145	1784663852671		active	/mlflow/artifacts/3/200e44c932ce4dad8671cd5da9b409d9/artifacts	3	\N
8d81437cc3714f6982ae885c3c81bacf	trial-116	UNKNOWN			eduar	FINISHED	1784663852848	1784663885291		active	/mlflow/artifacts/3/8d81437cc3714f6982ae885c3c81bacf/artifacts	3	\N
3e09014e17a84af3b1624fa0068fa0a7	trial-117	UNKNOWN			eduar	FINISHED	1784663885511	1784663919015		active	/mlflow/artifacts/3/3e09014e17a84af3b1624fa0068fa0a7/artifacts	3	\N
b4689faec3f7445fbe0ba427b0859231	trial-118	UNKNOWN			eduar	FINISHED	1784663919146	1784663934095		active	/mlflow/artifacts/3/b4689faec3f7445fbe0ba427b0859231/artifacts	3	\N
aa9da8551d8a425785523304e9c547f3	trial-119	UNKNOWN			eduar	FINISHED	1784663934221	1784663979147		active	/mlflow/artifacts/3/aa9da8551d8a425785523304e9c547f3/artifacts	3	\N
f9ede5de86ea4f9b8ac1a181ddd36d72	trial-120	UNKNOWN			eduar	FINISHED	1784663979273	1784664012673		active	/mlflow/artifacts/3/f9ede5de86ea4f9b8ac1a181ddd36d72/artifacts	3	\N
569e3af54f5549d389c2817c8ccf9823	trial-121	UNKNOWN			eduar	FINISHED	1784664012802	1784664057523		active	/mlflow/artifacts/3/569e3af54f5549d389c2817c8ccf9823/artifacts	3	\N
f0d12270c17441cb82afdc0ff9f70809	trial-122	UNKNOWN			eduar	FINISHED	1784664057678	1784664092676		active	/mlflow/artifacts/3/f0d12270c17441cb82afdc0ff9f70809/artifacts	3	\N
52e3ecc8bd264c6bb75dd7e13c9c3713	trial-123	UNKNOWN			eduar	FINISHED	1784664092846	1784664139380		active	/mlflow/artifacts/3/52e3ecc8bd264c6bb75dd7e13c9c3713/artifacts	3	\N
2e7a3710bd5e4ee2ad9d870e16e43be0	trial-124	UNKNOWN			eduar	FINISHED	1784664139508	1784664177425		active	/mlflow/artifacts/3/2e7a3710bd5e4ee2ad9d870e16e43be0/artifacts	3	\N
d3f4b439155d4a1f8452de974a8fd530	trial-125	UNKNOWN			eduar	FINISHED	1784664177577	1784664236871		active	/mlflow/artifacts/3/d3f4b439155d4a1f8452de974a8fd530/artifacts	3	\N
2d0fdb5b0ebe4654b38066951cec3ae8	trial-126	UNKNOWN			eduar	FINISHED	1784664237083	1784664292716		active	/mlflow/artifacts/3/2d0fdb5b0ebe4654b38066951cec3ae8/artifacts	3	\N
d6ab3fd3b7be407a86383f867d0d3987	trial-127	UNKNOWN			eduar	FINISHED	1784664292835	1784664336450		active	/mlflow/artifacts/3/d6ab3fd3b7be407a86383f867d0d3987/artifacts	3	\N
571b8fa9bdad427a9816b5b5144622ef	trial-128	UNKNOWN			eduar	FINISHED	1784664336571	1784664372642		active	/mlflow/artifacts/3/571b8fa9bdad427a9816b5b5144622ef/artifacts	3	\N
11b06d8ded174450aaa0563cd01e2137	trial-129	UNKNOWN			eduar	FINISHED	1784664372788	1784664396772		active	/mlflow/artifacts/3/11b06d8ded174450aaa0563cd01e2137/artifacts	3	\N
fea20651e3e744068c1d02e03e73f652	trial-130	UNKNOWN			eduar	FINISHED	1784664396892	1784664428903		active	/mlflow/artifacts/3/fea20651e3e744068c1d02e03e73f652/artifacts	3	\N
35ea2431d44b4d5197234e1257f742e7	trial-131	UNKNOWN			eduar	FINISHED	1784664429032	1784664466880		active	/mlflow/artifacts/3/35ea2431d44b4d5197234e1257f742e7/artifacts	3	\N
19c7ae8c940042a9bea5484d5c7a996f	trial-132	UNKNOWN			eduar	FINISHED	1784664467051	1784664486054		active	/mlflow/artifacts/3/19c7ae8c940042a9bea5484d5c7a996f/artifacts	3	\N
c2a98b6d06ba4b14ac81cdaaacee8d9b	trial-133	UNKNOWN			eduar	FINISHED	1784664486180	1784664521998		active	/mlflow/artifacts/3/c2a98b6d06ba4b14ac81cdaaacee8d9b/artifacts	3	\N
87f145f9b3b4496f901df95d56e470b8	trial-134	UNKNOWN			eduar	FINISHED	1784664522125	1784664548337		active	/mlflow/artifacts/3/87f145f9b3b4496f901df95d56e470b8/artifacts	3	\N
c23e0bcb7b334d3aae37f42aa4aaa09d	trial-135	UNKNOWN			eduar	FINISHED	1784664548501	1784664602134		active	/mlflow/artifacts/3/c23e0bcb7b334d3aae37f42aa4aaa09d/artifacts	3	\N
f4eb85ac7f484c7b9665388a9a0d3e8f	trial-136	UNKNOWN			eduar	FINISHED	1784664602324	1784664691422		active	/mlflow/artifacts/3/f4eb85ac7f484c7b9665388a9a0d3e8f/artifacts	3	\N
e9f2cf11fabd4422a3404f41f7e12593	trial-137	UNKNOWN			eduar	FINISHED	1784664691571	1784664735150		active	/mlflow/artifacts/3/e9f2cf11fabd4422a3404f41f7e12593/artifacts	3	\N
faefe080fefc45eabc2137abcdf3ef0c	trial-138	UNKNOWN			eduar	FINISHED	1784664735294	1784664784055		active	/mlflow/artifacts/3/faefe080fefc45eabc2137abcdf3ef0c/artifacts	3	\N
96479ef023f34b15a8033d9c5657d9dc	trial-139	UNKNOWN			eduar	FINISHED	1784664784173	1784664812466		active	/mlflow/artifacts/3/96479ef023f34b15a8033d9c5657d9dc/artifacts	3	\N
3e93389d94ca40148d153412a6cddbcb	trial-140	UNKNOWN			eduar	FINISHED	1784664812625	1784664844619		active	/mlflow/artifacts/3/3e93389d94ca40148d153412a6cddbcb/artifacts	3	\N
eb16c82079fd4ba591d99f8201df04d1	trial-141	UNKNOWN			eduar	FINISHED	1784664844776	1784664881386		active	/mlflow/artifacts/3/eb16c82079fd4ba591d99f8201df04d1/artifacts	3	\N
a643f1f3cf3147aaa764aafd4114e6ff	trial-142	UNKNOWN			eduar	FINISHED	1784664881510	1784664919193		active	/mlflow/artifacts/3/a643f1f3cf3147aaa764aafd4114e6ff/artifacts	3	\N
e4ff17e0741440b49a2e374cba8fc594	trial-143	UNKNOWN			eduar	FINISHED	1784664919323	1784664941551		active	/mlflow/artifacts/3/e4ff17e0741440b49a2e374cba8fc594/artifacts	3	\N
1918bf94daa7417a9f9a9bbe2f473d24	trial-144	UNKNOWN			eduar	FINISHED	1784664941711	1784664963217		active	/mlflow/artifacts/3/1918bf94daa7417a9f9a9bbe2f473d24/artifacts	3	\N
6975e9f2410b4b48a24bb54de3773f71	trial-145	UNKNOWN			eduar	FINISHED	1784664963349	1784664997670		active	/mlflow/artifacts/3/6975e9f2410b4b48a24bb54de3773f71/artifacts	3	\N
c7ca2abd948b4f7a8f5ef910fcb0e754	trial-146	UNKNOWN			eduar	FINISHED	1784664997788	1784665017598		active	/mlflow/artifacts/3/c7ca2abd948b4f7a8f5ef910fcb0e754/artifacts	3	\N
7c916e1a7e7d4b44be04309d6b501d6f	trial-147	UNKNOWN			eduar	FINISHED	1784665017773	1784665031197		active	/mlflow/artifacts/3/7c916e1a7e7d4b44be04309d6b501d6f/artifacts	3	\N
ce2b0e6b82744bb9ab441eb5516e4bb9	trial-148	UNKNOWN			eduar	FINISHED	1784665031335	1784665066373		active	/mlflow/artifacts/3/ce2b0e6b82744bb9ab441eb5516e4bb9/artifacts	3	\N
bec59faddbfa49baa60c2a3653cd5dbd	trial-149	UNKNOWN			eduar	FINISHED	1784665066501	1784665118476		active	/mlflow/artifacts/3/bec59faddbfa49baa60c2a3653cd5dbd/artifacts	3	\N
9e379079e72747be9cc278ce97ad8b11	blushing-stag-187	UNKNOWN			eduar	FAILED	1784665128824	1784665158658		active	/mlflow/artifacts/3/9e379079e72747be9cc278ce97ad8b11/artifacts	3	\N
033ebefb766e4bfa8282ab39cec5c865	champion-model	UNKNOWN			eduar	FAILED	1784668277712	1784669903361		active	/mlflow/artifacts/4/033ebefb766e4bfa8282ab39cec5c865/artifacts	4	\N
be0003b4c09f45a384716a36faaa3fde	champion-model	UNKNOWN			eduar	FAILED	1784670068068	1784670241680		active	/mlflow/artifacts/4/be0003b4c09f45a384716a36faaa3fde/artifacts	4	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	eduar	f5a3d1a3c4ed4af69451b19e8ca99b44
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	f5a3d1a3c4ed4af69451b19e8ca99b44
mlflow.source.type	LOCAL	f5a3d1a3c4ed4af69451b19e8ca99b44
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	f5a3d1a3c4ed4af69451b19e8ca99b44
mlflow.runName	cross-validation	f5a3d1a3c4ed4af69451b19e8ca99b44
stage	model_selection	f5a3d1a3c4ed4af69451b19e8ca99b44
metric	PR_AUC	f5a3d1a3c4ed4af69451b19e8ca99b44
mlflow.user	eduar	1c1474a4dc0a42e595b137a2ff7eb3cd
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	1c1474a4dc0a42e595b137a2ff7eb3cd
mlflow.source.type	LOCAL	1c1474a4dc0a42e595b137a2ff7eb3cd
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	1c1474a4dc0a42e595b137a2ff7eb3cd
mlflow.parentRunId	f5a3d1a3c4ed4af69451b19e8ca99b44	1c1474a4dc0a42e595b137a2ff7eb3cd
mlflow.runName	Random Forest	1c1474a4dc0a42e595b137a2ff7eb3cd
mlflow.user	eduar	87bee9e02af04727a439076b5099ea26
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	87bee9e02af04727a439076b5099ea26
mlflow.source.type	LOCAL	87bee9e02af04727a439076b5099ea26
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	87bee9e02af04727a439076b5099ea26
mlflow.parentRunId	f5a3d1a3c4ed4af69451b19e8ca99b44	87bee9e02af04727a439076b5099ea26
mlflow.runName	LightGBM	87bee9e02af04727a439076b5099ea26
mlflow.user	eduar	a0d9d4037d9a483e8ff2887e8c35e79a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a0d9d4037d9a483e8ff2887e8c35e79a
mlflow.source.type	LOCAL	a0d9d4037d9a483e8ff2887e8c35e79a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a0d9d4037d9a483e8ff2887e8c35e79a
mlflow.parentRunId	f5a3d1a3c4ed4af69451b19e8ca99b44	a0d9d4037d9a483e8ff2887e8c35e79a
mlflow.runName	XGBoost	a0d9d4037d9a483e8ff2887e8c35e79a
mlflow.user	eduar	5182637ae0084c8c9a5b790208db545b
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5182637ae0084c8c9a5b790208db545b
mlflow.source.type	LOCAL	5182637ae0084c8c9a5b790208db545b
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5182637ae0084c8c9a5b790208db545b
mlflow.runName	test-set-evaluation	5182637ae0084c8c9a5b790208db545b
stage	test_evaluation	5182637ae0084c8c9a5b790208db545b
selection_metric	PR_AUC	5182637ae0084c8c9a5b790208db545b
mlflow.user	eduar	64d0075ce861402aa333540e2cfb3177
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	64d0075ce861402aa333540e2cfb3177
mlflow.source.type	LOCAL	64d0075ce861402aa333540e2cfb3177
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	64d0075ce861402aa333540e2cfb3177
mlflow.parentRunId	5182637ae0084c8c9a5b790208db545b	64d0075ce861402aa333540e2cfb3177
mlflow.runName	Random Forest	64d0075ce861402aa333540e2cfb3177
mlflow.user	eduar	8274a5b2f12040bc9cd010d478f47bb2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8274a5b2f12040bc9cd010d478f47bb2
mlflow.source.type	LOCAL	8274a5b2f12040bc9cd010d478f47bb2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8274a5b2f12040bc9cd010d478f47bb2
mlflow.runName	test-set-evaluation	8274a5b2f12040bc9cd010d478f47bb2
stage	test_evaluation	8274a5b2f12040bc9cd010d478f47bb2
selection_metric	PR_AUC	8274a5b2f12040bc9cd010d478f47bb2
mlflow.user	eduar	7ad743cafe754961865d8d9048d97887
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7ad743cafe754961865d8d9048d97887
mlflow.source.type	LOCAL	7ad743cafe754961865d8d9048d97887
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7ad743cafe754961865d8d9048d97887
mlflow.parentRunId	8274a5b2f12040bc9cd010d478f47bb2	7ad743cafe754961865d8d9048d97887
mlflow.runName	Random Forest	7ad743cafe754961865d8d9048d97887
mlflow.user	eduar	9899a48432a34cb39a199dcf5ae28c28
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9899a48432a34cb39a199dcf5ae28c28
mlflow.source.type	LOCAL	9899a48432a34cb39a199dcf5ae28c28
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9899a48432a34cb39a199dcf5ae28c28
mlflow.parentRunId	8274a5b2f12040bc9cd010d478f47bb2	9899a48432a34cb39a199dcf5ae28c28
mlflow.runName	LightGBM	9899a48432a34cb39a199dcf5ae28c28
mlflow.user	eduar	f8b1be9aa8b34c36a0d398fea269c222
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	f8b1be9aa8b34c36a0d398fea269c222
mlflow.source.type	LOCAL	f8b1be9aa8b34c36a0d398fea269c222
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	f8b1be9aa8b34c36a0d398fea269c222
mlflow.parentRunId	8274a5b2f12040bc9cd010d478f47bb2	f8b1be9aa8b34c36a0d398fea269c222
mlflow.runName	XGBoost	f8b1be9aa8b34c36a0d398fea269c222
mlflow.user	eduar	5cfc620daab64d35912dd7df3c7d139d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5cfc620daab64d35912dd7df3c7d139d
mlflow.source.type	LOCAL	5cfc620daab64d35912dd7df3c7d139d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5cfc620daab64d35912dd7df3c7d139d
mlflow.runName	optuna-search	5cfc620daab64d35912dd7df3c7d139d
mlflow.user	eduar	b065943b869c45d1ab9a544997cbd2e3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b065943b869c45d1ab9a544997cbd2e3
mlflow.source.type	LOCAL	b065943b869c45d1ab9a544997cbd2e3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b065943b869c45d1ab9a544997cbd2e3
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	b065943b869c45d1ab9a544997cbd2e3
mlflow.runName	trial-0	b065943b869c45d1ab9a544997cbd2e3
mlflow.user	eduar	876e004fc22941a5bd0abf6035008d6e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	876e004fc22941a5bd0abf6035008d6e
mlflow.source.type	LOCAL	876e004fc22941a5bd0abf6035008d6e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	876e004fc22941a5bd0abf6035008d6e
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	876e004fc22941a5bd0abf6035008d6e
mlflow.runName	trial-1	876e004fc22941a5bd0abf6035008d6e
mlflow.user	eduar	77d0e55214db4ecd857415d3af80c800
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	77d0e55214db4ecd857415d3af80c800
mlflow.source.type	LOCAL	77d0e55214db4ecd857415d3af80c800
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	77d0e55214db4ecd857415d3af80c800
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	77d0e55214db4ecd857415d3af80c800
mlflow.runName	trial-2	77d0e55214db4ecd857415d3af80c800
mlflow.user	eduar	8af2154e65c646ba85f95ef956f429e3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8af2154e65c646ba85f95ef956f429e3
mlflow.source.type	LOCAL	8af2154e65c646ba85f95ef956f429e3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8af2154e65c646ba85f95ef956f429e3
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	8af2154e65c646ba85f95ef956f429e3
mlflow.runName	trial-3	8af2154e65c646ba85f95ef956f429e3
mlflow.user	eduar	0b2d11961fe2427d959a976e2033ca2e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0b2d11961fe2427d959a976e2033ca2e
mlflow.source.type	LOCAL	0b2d11961fe2427d959a976e2033ca2e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0b2d11961fe2427d959a976e2033ca2e
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	0b2d11961fe2427d959a976e2033ca2e
mlflow.runName	trial-39	0b2d11961fe2427d959a976e2033ca2e
mlflow.user	eduar	c9bd89e9733b418e8a4c762cccf8aa2d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c9bd89e9733b418e8a4c762cccf8aa2d
mlflow.source.type	LOCAL	c9bd89e9733b418e8a4c762cccf8aa2d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c9bd89e9733b418e8a4c762cccf8aa2d
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	c9bd89e9733b418e8a4c762cccf8aa2d
mlflow.runName	trial-46	c9bd89e9733b418e8a4c762cccf8aa2d
mlflow.user	eduar	cbe54d84d2f84e4b982ad2d27427c7a7
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	cbe54d84d2f84e4b982ad2d27427c7a7
mlflow.source.type	LOCAL	cbe54d84d2f84e4b982ad2d27427c7a7
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	cbe54d84d2f84e4b982ad2d27427c7a7
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	cbe54d84d2f84e4b982ad2d27427c7a7
mlflow.runName	trial-54	cbe54d84d2f84e4b982ad2d27427c7a7
mlflow.user	eduar	a83392e9cd7a4265b05f9abeced43638
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a83392e9cd7a4265b05f9abeced43638
mlflow.source.type	LOCAL	a83392e9cd7a4265b05f9abeced43638
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a83392e9cd7a4265b05f9abeced43638
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	a83392e9cd7a4265b05f9abeced43638
mlflow.runName	trial-58	a83392e9cd7a4265b05f9abeced43638
mlflow.user	eduar	99f8a6c1a99042518e4a0ef2de67cbd0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	99f8a6c1a99042518e4a0ef2de67cbd0
mlflow.source.type	LOCAL	99f8a6c1a99042518e4a0ef2de67cbd0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	99f8a6c1a99042518e4a0ef2de67cbd0
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	99f8a6c1a99042518e4a0ef2de67cbd0
mlflow.runName	trial-66	99f8a6c1a99042518e4a0ef2de67cbd0
mlflow.user	eduar	3e93389d94ca40148d153412a6cddbcb
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3e93389d94ca40148d153412a6cddbcb
mlflow.source.type	LOCAL	3e93389d94ca40148d153412a6cddbcb
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3e93389d94ca40148d153412a6cddbcb
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	3e93389d94ca40148d153412a6cddbcb
mlflow.runName	trial-140	3e93389d94ca40148d153412a6cddbcb
mlflow.user	eduar	546361b43206462abda8503c0473c830
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	546361b43206462abda8503c0473c830
mlflow.source.type	LOCAL	546361b43206462abda8503c0473c830
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	546361b43206462abda8503c0473c830
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	546361b43206462abda8503c0473c830
mlflow.runName	trial-4	546361b43206462abda8503c0473c830
mlflow.user	eduar	863d9eddfa374352ac9ef04f414aed07
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	863d9eddfa374352ac9ef04f414aed07
mlflow.source.type	LOCAL	863d9eddfa374352ac9ef04f414aed07
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	863d9eddfa374352ac9ef04f414aed07
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	863d9eddfa374352ac9ef04f414aed07
mlflow.runName	trial-5	863d9eddfa374352ac9ef04f414aed07
mlflow.user	eduar	761f6f2a81274b38bf29c785c17b9f5c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	761f6f2a81274b38bf29c785c17b9f5c
mlflow.source.type	LOCAL	761f6f2a81274b38bf29c785c17b9f5c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	761f6f2a81274b38bf29c785c17b9f5c
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	761f6f2a81274b38bf29c785c17b9f5c
mlflow.runName	trial-6	761f6f2a81274b38bf29c785c17b9f5c
mlflow.user	eduar	000523ae15fd47739ed9fccc383746ef
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	000523ae15fd47739ed9fccc383746ef
mlflow.source.type	LOCAL	000523ae15fd47739ed9fccc383746ef
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	000523ae15fd47739ed9fccc383746ef
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	000523ae15fd47739ed9fccc383746ef
mlflow.runName	trial-40	000523ae15fd47739ed9fccc383746ef
mlflow.user	eduar	8c036e2f01ae4dce9b24165f8105ca06
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8c036e2f01ae4dce9b24165f8105ca06
mlflow.source.type	LOCAL	8c036e2f01ae4dce9b24165f8105ca06
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8c036e2f01ae4dce9b24165f8105ca06
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	8c036e2f01ae4dce9b24165f8105ca06
mlflow.runName	trial-48	8c036e2f01ae4dce9b24165f8105ca06
mlflow.user	eduar	a4fe1e00ac0e4e67b019e182ca42dfa5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a4fe1e00ac0e4e67b019e182ca42dfa5
mlflow.source.type	LOCAL	a4fe1e00ac0e4e67b019e182ca42dfa5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a4fe1e00ac0e4e67b019e182ca42dfa5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	a4fe1e00ac0e4e67b019e182ca42dfa5
mlflow.runName	trial-50	a4fe1e00ac0e4e67b019e182ca42dfa5
mlflow.user	eduar	2b432c32784143a9b9d3be8670c9b2de
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2b432c32784143a9b9d3be8670c9b2de
mlflow.source.type	LOCAL	2b432c32784143a9b9d3be8670c9b2de
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2b432c32784143a9b9d3be8670c9b2de
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2b432c32784143a9b9d3be8670c9b2de
mlflow.runName	trial-51	2b432c32784143a9b9d3be8670c9b2de
mlflow.user	eduar	4ad932f7dcda4517b7b5cc0c8beac404
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	4ad932f7dcda4517b7b5cc0c8beac404
mlflow.source.type	LOCAL	4ad932f7dcda4517b7b5cc0c8beac404
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	4ad932f7dcda4517b7b5cc0c8beac404
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	4ad932f7dcda4517b7b5cc0c8beac404
mlflow.runName	trial-57	4ad932f7dcda4517b7b5cc0c8beac404
mlflow.user	eduar	193b290a18504fa8a42991b624278dbf
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	193b290a18504fa8a42991b624278dbf
mlflow.source.type	LOCAL	193b290a18504fa8a42991b624278dbf
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	193b290a18504fa8a42991b624278dbf
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	193b290a18504fa8a42991b624278dbf
mlflow.runName	trial-60	193b290a18504fa8a42991b624278dbf
mlflow.user	eduar	bbf38d0761d14a96a7f6af68d83b297c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	bbf38d0761d14a96a7f6af68d83b297c
mlflow.source.type	LOCAL	bbf38d0761d14a96a7f6af68d83b297c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	bbf38d0761d14a96a7f6af68d83b297c
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	bbf38d0761d14a96a7f6af68d83b297c
mlflow.runName	trial-63	bbf38d0761d14a96a7f6af68d83b297c
mlflow.user	eduar	e465ea368468417f95c02d9736ea13d2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e465ea368468417f95c02d9736ea13d2
mlflow.source.type	LOCAL	e465ea368468417f95c02d9736ea13d2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e465ea368468417f95c02d9736ea13d2
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	e465ea368468417f95c02d9736ea13d2
mlflow.runName	trial-64	e465ea368468417f95c02d9736ea13d2
mlflow.user	eduar	82ae9253c99347c28805e14bb275d4e1
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	82ae9253c99347c28805e14bb275d4e1
mlflow.source.type	LOCAL	82ae9253c99347c28805e14bb275d4e1
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	82ae9253c99347c28805e14bb275d4e1
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	82ae9253c99347c28805e14bb275d4e1
mlflow.runName	trial-67	82ae9253c99347c28805e14bb275d4e1
mlflow.user	eduar	eb16c82079fd4ba591d99f8201df04d1
mlflow.user	eduar	014e8bb3efda4a7f9e544ad0c54eda97
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	014e8bb3efda4a7f9e544ad0c54eda97
mlflow.source.type	LOCAL	014e8bb3efda4a7f9e544ad0c54eda97
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	014e8bb3efda4a7f9e544ad0c54eda97
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	014e8bb3efda4a7f9e544ad0c54eda97
mlflow.runName	trial-7	014e8bb3efda4a7f9e544ad0c54eda97
mlflow.user	eduar	889b7c5d83704dd2ac3f3508dcb6bbeb
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	889b7c5d83704dd2ac3f3508dcb6bbeb
mlflow.source.type	LOCAL	889b7c5d83704dd2ac3f3508dcb6bbeb
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	889b7c5d83704dd2ac3f3508dcb6bbeb
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	889b7c5d83704dd2ac3f3508dcb6bbeb
mlflow.runName	trial-8	889b7c5d83704dd2ac3f3508dcb6bbeb
mlflow.user	eduar	ae175d867d8d4942b3953e031f48deea
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	ae175d867d8d4942b3953e031f48deea
mlflow.source.type	LOCAL	ae175d867d8d4942b3953e031f48deea
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	ae175d867d8d4942b3953e031f48deea
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	ae175d867d8d4942b3953e031f48deea
mlflow.runName	trial-9	ae175d867d8d4942b3953e031f48deea
mlflow.user	eduar	c570005822f1468ebc56e3a2e5f3a7be
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c570005822f1468ebc56e3a2e5f3a7be
mlflow.source.type	LOCAL	c570005822f1468ebc56e3a2e5f3a7be
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c570005822f1468ebc56e3a2e5f3a7be
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c570005822f1468ebc56e3a2e5f3a7be
mlflow.runName	trial-10	c570005822f1468ebc56e3a2e5f3a7be
mlflow.user	eduar	6198d6b56d9e4ff5afeca1168f4226b8
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	6198d6b56d9e4ff5afeca1168f4226b8
mlflow.source.type	LOCAL	6198d6b56d9e4ff5afeca1168f4226b8
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	6198d6b56d9e4ff5afeca1168f4226b8
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	6198d6b56d9e4ff5afeca1168f4226b8
mlflow.runName	trial-11	6198d6b56d9e4ff5afeca1168f4226b8
mlflow.user	eduar	905dc0ac6a9b46bfa4b2435798fa6880
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	905dc0ac6a9b46bfa4b2435798fa6880
mlflow.source.type	LOCAL	905dc0ac6a9b46bfa4b2435798fa6880
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	905dc0ac6a9b46bfa4b2435798fa6880
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	905dc0ac6a9b46bfa4b2435798fa6880
mlflow.runName	trial-12	905dc0ac6a9b46bfa4b2435798fa6880
mlflow.user	eduar	3c993ea82ef44d1f91ec5ae384b63d04
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3c993ea82ef44d1f91ec5ae384b63d04
mlflow.source.type	LOCAL	3c993ea82ef44d1f91ec5ae384b63d04
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3c993ea82ef44d1f91ec5ae384b63d04
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	3c993ea82ef44d1f91ec5ae384b63d04
mlflow.runName	trial-13	3c993ea82ef44d1f91ec5ae384b63d04
mlflow.user	eduar	5f4890e2fdc040bfba29e6fba7cf13de
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5f4890e2fdc040bfba29e6fba7cf13de
mlflow.source.type	LOCAL	5f4890e2fdc040bfba29e6fba7cf13de
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5f4890e2fdc040bfba29e6fba7cf13de
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	5f4890e2fdc040bfba29e6fba7cf13de
mlflow.runName	trial-14	5f4890e2fdc040bfba29e6fba7cf13de
mlflow.user	eduar	31c19df3feba406bbe273cf28ad356ea
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	31c19df3feba406bbe273cf28ad356ea
mlflow.source.type	LOCAL	31c19df3feba406bbe273cf28ad356ea
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	31c19df3feba406bbe273cf28ad356ea
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	31c19df3feba406bbe273cf28ad356ea
mlflow.runName	trial-15	31c19df3feba406bbe273cf28ad356ea
mlflow.user	eduar	06988d80ee2a49cc847b86b0ba828472
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	06988d80ee2a49cc847b86b0ba828472
mlflow.source.type	LOCAL	06988d80ee2a49cc847b86b0ba828472
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	06988d80ee2a49cc847b86b0ba828472
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	06988d80ee2a49cc847b86b0ba828472
mlflow.runName	trial-16	06988d80ee2a49cc847b86b0ba828472
mlflow.user	eduar	884482f15ecf455cacf6203986941bd8
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	884482f15ecf455cacf6203986941bd8
mlflow.source.type	LOCAL	884482f15ecf455cacf6203986941bd8
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	884482f15ecf455cacf6203986941bd8
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	884482f15ecf455cacf6203986941bd8
mlflow.runName	trial-17	884482f15ecf455cacf6203986941bd8
mlflow.user	eduar	1336414e54eb49e886f22580bd301b28
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	1336414e54eb49e886f22580bd301b28
mlflow.source.type	LOCAL	1336414e54eb49e886f22580bd301b28
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	1336414e54eb49e886f22580bd301b28
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	1336414e54eb49e886f22580bd301b28
mlflow.runName	trial-18	1336414e54eb49e886f22580bd301b28
mlflow.user	eduar	b3547d0973f74bf49d4e595aacdb1e3b
mlflow.source.type	LOCAL	337c2ecc590441f4b0d4ed6e6c6d874b
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b3547d0973f74bf49d4e595aacdb1e3b
mlflow.source.type	LOCAL	b3547d0973f74bf49d4e595aacdb1e3b
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b3547d0973f74bf49d4e595aacdb1e3b
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	b3547d0973f74bf49d4e595aacdb1e3b
mlflow.runName	trial-19	b3547d0973f74bf49d4e595aacdb1e3b
mlflow.user	eduar	11cd7d2db6784fe4b02a7ae8f71d8cf2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	11cd7d2db6784fe4b02a7ae8f71d8cf2
mlflow.source.type	LOCAL	11cd7d2db6784fe4b02a7ae8f71d8cf2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	11cd7d2db6784fe4b02a7ae8f71d8cf2
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	11cd7d2db6784fe4b02a7ae8f71d8cf2
mlflow.runName	trial-20	11cd7d2db6784fe4b02a7ae8f71d8cf2
mlflow.user	eduar	58b4b9d2beff44d3b6bce2af1c53b954
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	58b4b9d2beff44d3b6bce2af1c53b954
mlflow.source.type	LOCAL	58b4b9d2beff44d3b6bce2af1c53b954
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	58b4b9d2beff44d3b6bce2af1c53b954
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	58b4b9d2beff44d3b6bce2af1c53b954
mlflow.runName	trial-21	58b4b9d2beff44d3b6bce2af1c53b954
mlflow.user	eduar	a96bb954fdd64eed9d3bb56c6d5ea887
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a96bb954fdd64eed9d3bb56c6d5ea887
mlflow.source.type	LOCAL	a96bb954fdd64eed9d3bb56c6d5ea887
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a96bb954fdd64eed9d3bb56c6d5ea887
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	a96bb954fdd64eed9d3bb56c6d5ea887
mlflow.runName	trial-22	a96bb954fdd64eed9d3bb56c6d5ea887
mlflow.user	eduar	ed6d527941fe49ec9efa86d9ecec40b9
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	ed6d527941fe49ec9efa86d9ecec40b9
mlflow.source.type	LOCAL	ed6d527941fe49ec9efa86d9ecec40b9
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	ed6d527941fe49ec9efa86d9ecec40b9
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	ed6d527941fe49ec9efa86d9ecec40b9
mlflow.runName	trial-23	ed6d527941fe49ec9efa86d9ecec40b9
mlflow.user	eduar	9bee251d163640f4b41fe3bb301ce520
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9bee251d163640f4b41fe3bb301ce520
mlflow.source.type	LOCAL	9bee251d163640f4b41fe3bb301ce520
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9bee251d163640f4b41fe3bb301ce520
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	9bee251d163640f4b41fe3bb301ce520
mlflow.runName	trial-24	9bee251d163640f4b41fe3bb301ce520
mlflow.user	eduar	c5d632c0f5584ef38bba13efd4e41e85
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c5d632c0f5584ef38bba13efd4e41e85
mlflow.source.type	LOCAL	c5d632c0f5584ef38bba13efd4e41e85
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c5d632c0f5584ef38bba13efd4e41e85
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c5d632c0f5584ef38bba13efd4e41e85
mlflow.runName	trial-25	c5d632c0f5584ef38bba13efd4e41e85
mlflow.user	eduar	d54ca38b32404c3ab9603d5c17d370be
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d54ca38b32404c3ab9603d5c17d370be
mlflow.source.type	LOCAL	d54ca38b32404c3ab9603d5c17d370be
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d54ca38b32404c3ab9603d5c17d370be
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	d54ca38b32404c3ab9603d5c17d370be
mlflow.runName	trial-26	d54ca38b32404c3ab9603d5c17d370be
mlflow.user	eduar	74a92f84946a40ec9f5ef59d95735532
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	74a92f84946a40ec9f5ef59d95735532
mlflow.source.type	LOCAL	74a92f84946a40ec9f5ef59d95735532
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	74a92f84946a40ec9f5ef59d95735532
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	74a92f84946a40ec9f5ef59d95735532
mlflow.runName	trial-27	74a92f84946a40ec9f5ef59d95735532
mlflow.user	eduar	19cbd69551b74540ae49e5172dcbd422
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	19cbd69551b74540ae49e5172dcbd422
mlflow.source.type	LOCAL	19cbd69551b74540ae49e5172dcbd422
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	19cbd69551b74540ae49e5172dcbd422
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	19cbd69551b74540ae49e5172dcbd422
mlflow.runName	trial-28	19cbd69551b74540ae49e5172dcbd422
mlflow.user	eduar	3ed8585907ef4caa8fe4d70cb6b0cc87
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3ed8585907ef4caa8fe4d70cb6b0cc87
mlflow.source.type	LOCAL	3ed8585907ef4caa8fe4d70cb6b0cc87
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3ed8585907ef4caa8fe4d70cb6b0cc87
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	3ed8585907ef4caa8fe4d70cb6b0cc87
mlflow.runName	trial-29	3ed8585907ef4caa8fe4d70cb6b0cc87
mlflow.user	eduar	e29e156922854739b295baa6f96964b9
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e29e156922854739b295baa6f96964b9
mlflow.source.type	LOCAL	e29e156922854739b295baa6f96964b9
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e29e156922854739b295baa6f96964b9
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	e29e156922854739b295baa6f96964b9
mlflow.runName	trial-30	e29e156922854739b295baa6f96964b9
mlflow.user	eduar	337c2ecc590441f4b0d4ed6e6c6d874b
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	337c2ecc590441f4b0d4ed6e6c6d874b
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	337c2ecc590441f4b0d4ed6e6c6d874b
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	337c2ecc590441f4b0d4ed6e6c6d874b
mlflow.runName	trial-31	337c2ecc590441f4b0d4ed6e6c6d874b
mlflow.user	eduar	308716eedad140d8b8c2c920a5203a28
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	308716eedad140d8b8c2c920a5203a28
mlflow.source.type	LOCAL	308716eedad140d8b8c2c920a5203a28
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	308716eedad140d8b8c2c920a5203a28
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	308716eedad140d8b8c2c920a5203a28
mlflow.runName	trial-41	308716eedad140d8b8c2c920a5203a28
mlflow.user	eduar	61bef132335149da8fc1bcd646945380
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	61bef132335149da8fc1bcd646945380
mlflow.source.type	LOCAL	61bef132335149da8fc1bcd646945380
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	61bef132335149da8fc1bcd646945380
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	61bef132335149da8fc1bcd646945380
mlflow.runName	trial-47	61bef132335149da8fc1bcd646945380
mlflow.user	eduar	91efa9c98d164aedac595d534867cfa9
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	91efa9c98d164aedac595d534867cfa9
mlflow.source.type	LOCAL	91efa9c98d164aedac595d534867cfa9
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	91efa9c98d164aedac595d534867cfa9
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	91efa9c98d164aedac595d534867cfa9
mlflow.runName	trial-52	91efa9c98d164aedac595d534867cfa9
mlflow.user	eduar	7cabb843d24d4b86a34757eaf1696d59
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7cabb843d24d4b86a34757eaf1696d59
mlflow.source.type	LOCAL	7cabb843d24d4b86a34757eaf1696d59
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7cabb843d24d4b86a34757eaf1696d59
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	7cabb843d24d4b86a34757eaf1696d59
mlflow.runName	trial-53	7cabb843d24d4b86a34757eaf1696d59
mlflow.user	eduar	9ee14964976f41c9a0d4773391dc1b89
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9ee14964976f41c9a0d4773391dc1b89
mlflow.source.type	LOCAL	9ee14964976f41c9a0d4773391dc1b89
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9ee14964976f41c9a0d4773391dc1b89
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	9ee14964976f41c9a0d4773391dc1b89
mlflow.runName	trial-62	9ee14964976f41c9a0d4773391dc1b89
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	eb16c82079fd4ba591d99f8201df04d1
mlflow.source.type	LOCAL	eb16c82079fd4ba591d99f8201df04d1
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	eb16c82079fd4ba591d99f8201df04d1
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	eb16c82079fd4ba591d99f8201df04d1
mlflow.runName	trial-141	eb16c82079fd4ba591d99f8201df04d1
mlflow.user	eduar	e4ff17e0741440b49a2e374cba8fc594
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e4ff17e0741440b49a2e374cba8fc594
mlflow.source.type	LOCAL	e4ff17e0741440b49a2e374cba8fc594
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e4ff17e0741440b49a2e374cba8fc594
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	e4ff17e0741440b49a2e374cba8fc594
mlflow.runName	trial-143	e4ff17e0741440b49a2e374cba8fc594
mlflow.user	eduar	c7ca2abd948b4f7a8f5ef910fcb0e754
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c7ca2abd948b4f7a8f5ef910fcb0e754
mlflow.source.type	LOCAL	c7ca2abd948b4f7a8f5ef910fcb0e754
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c7ca2abd948b4f7a8f5ef910fcb0e754
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	c7ca2abd948b4f7a8f5ef910fcb0e754
mlflow.runName	trial-146	c7ca2abd948b4f7a8f5ef910fcb0e754
mlflow.user	eduar	7c916e1a7e7d4b44be04309d6b501d6f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7c916e1a7e7d4b44be04309d6b501d6f
mlflow.source.type	LOCAL	7c916e1a7e7d4b44be04309d6b501d6f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7c916e1a7e7d4b44be04309d6b501d6f
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	7c916e1a7e7d4b44be04309d6b501d6f
mlflow.runName	trial-147	7c916e1a7e7d4b44be04309d6b501d6f
mlflow.user	eduar	4aca56d551a8462caff8f4910dc5c067
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	4aca56d551a8462caff8f4910dc5c067
mlflow.source.type	LOCAL	4aca56d551a8462caff8f4910dc5c067
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	4aca56d551a8462caff8f4910dc5c067
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	4aca56d551a8462caff8f4910dc5c067
mlflow.runName	trial-32	4aca56d551a8462caff8f4910dc5c067
mlflow.user	eduar	4ed8356cc0124c2687e88834f4d5b105
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	4ed8356cc0124c2687e88834f4d5b105
mlflow.source.type	LOCAL	4ed8356cc0124c2687e88834f4d5b105
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	4ed8356cc0124c2687e88834f4d5b105
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	4ed8356cc0124c2687e88834f4d5b105
mlflow.runName	trial-33	4ed8356cc0124c2687e88834f4d5b105
mlflow.user	eduar	bb2f576d862c4a68b3b67f55ee6e56e3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	bb2f576d862c4a68b3b67f55ee6e56e3
mlflow.source.type	LOCAL	bb2f576d862c4a68b3b67f55ee6e56e3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	bb2f576d862c4a68b3b67f55ee6e56e3
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	bb2f576d862c4a68b3b67f55ee6e56e3
mlflow.runName	trial-34	bb2f576d862c4a68b3b67f55ee6e56e3
mlflow.user	eduar	d4ffdfcc60964dc2a44d6526250c8242
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d4ffdfcc60964dc2a44d6526250c8242
mlflow.source.type	LOCAL	d4ffdfcc60964dc2a44d6526250c8242
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d4ffdfcc60964dc2a44d6526250c8242
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	d4ffdfcc60964dc2a44d6526250c8242
mlflow.runName	trial-35	d4ffdfcc60964dc2a44d6526250c8242
mlflow.user	eduar	5094306f911645f7960433fa475f3906
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5094306f911645f7960433fa475f3906
mlflow.source.type	LOCAL	5094306f911645f7960433fa475f3906
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5094306f911645f7960433fa475f3906
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	5094306f911645f7960433fa475f3906
mlflow.runName	trial-36	5094306f911645f7960433fa475f3906
mlflow.user	eduar	c15aab38a0b749289678168eed8a375f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c15aab38a0b749289678168eed8a375f
mlflow.source.type	LOCAL	c15aab38a0b749289678168eed8a375f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c15aab38a0b749289678168eed8a375f
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c15aab38a0b749289678168eed8a375f
mlflow.runName	trial-37	c15aab38a0b749289678168eed8a375f
mlflow.user	eduar	a66a3b993e8c4892807fe3212c6626d1
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a66a3b993e8c4892807fe3212c6626d1
mlflow.source.type	LOCAL	a66a3b993e8c4892807fe3212c6626d1
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a66a3b993e8c4892807fe3212c6626d1
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	a66a3b993e8c4892807fe3212c6626d1
mlflow.runName	trial-38	a66a3b993e8c4892807fe3212c6626d1
mlflow.user	eduar	5c42167498f34202a2d02f90db37735d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5c42167498f34202a2d02f90db37735d
mlflow.source.type	LOCAL	5c42167498f34202a2d02f90db37735d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5c42167498f34202a2d02f90db37735d
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	5c42167498f34202a2d02f90db37735d
mlflow.runName	trial-39	5c42167498f34202a2d02f90db37735d
mlflow.user	eduar	802c5ed50bad4391bbb5c72644ab5629
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	802c5ed50bad4391bbb5c72644ab5629
mlflow.source.type	LOCAL	802c5ed50bad4391bbb5c72644ab5629
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	802c5ed50bad4391bbb5c72644ab5629
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	802c5ed50bad4391bbb5c72644ab5629
mlflow.runName	trial-40	802c5ed50bad4391bbb5c72644ab5629
mlflow.user	eduar	b8c92046e4d64195892f204054da11ee
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b8c92046e4d64195892f204054da11ee
mlflow.source.type	LOCAL	b8c92046e4d64195892f204054da11ee
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b8c92046e4d64195892f204054da11ee
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	b8c92046e4d64195892f204054da11ee
mlflow.runName	trial-41	b8c92046e4d64195892f204054da11ee
mlflow.user	eduar	6558904b55d747dcbb1151b72104deda
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	6558904b55d747dcbb1151b72104deda
mlflow.source.type	LOCAL	6558904b55d747dcbb1151b72104deda
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	6558904b55d747dcbb1151b72104deda
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	6558904b55d747dcbb1151b72104deda
mlflow.runName	trial-42	6558904b55d747dcbb1151b72104deda
mlflow.user	eduar	23f4f5b6b75745cbbfb0974a54367678
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	23f4f5b6b75745cbbfb0974a54367678
mlflow.source.type	LOCAL	23f4f5b6b75745cbbfb0974a54367678
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	23f4f5b6b75745cbbfb0974a54367678
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	23f4f5b6b75745cbbfb0974a54367678
mlflow.runName	trial-43	23f4f5b6b75745cbbfb0974a54367678
mlflow.user	eduar	979923580d5349d5968ee3fbca0c330a
mlflow.user	eduar	b58e93020e20438db09d29ad3c13df59
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	979923580d5349d5968ee3fbca0c330a
mlflow.source.type	LOCAL	979923580d5349d5968ee3fbca0c330a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	979923580d5349d5968ee3fbca0c330a
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	979923580d5349d5968ee3fbca0c330a
mlflow.runName	trial-44	979923580d5349d5968ee3fbca0c330a
mlflow.user	eduar	bc0ab96304f34a6c848f80daf1fb9a6e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	bc0ab96304f34a6c848f80daf1fb9a6e
mlflow.source.type	LOCAL	bc0ab96304f34a6c848f80daf1fb9a6e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	bc0ab96304f34a6c848f80daf1fb9a6e
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	bc0ab96304f34a6c848f80daf1fb9a6e
mlflow.runName	trial-45	bc0ab96304f34a6c848f80daf1fb9a6e
mlflow.user	eduar	b4b583974c19441a99bf1809f32d97ac
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b4b583974c19441a99bf1809f32d97ac
mlflow.source.type	LOCAL	b4b583974c19441a99bf1809f32d97ac
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b4b583974c19441a99bf1809f32d97ac
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	b4b583974c19441a99bf1809f32d97ac
mlflow.runName	trial-42	b4b583974c19441a99bf1809f32d97ac
mlflow.user	eduar	a643f1f3cf3147aaa764aafd4114e6ff
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a643f1f3cf3147aaa764aafd4114e6ff
mlflow.source.type	LOCAL	a643f1f3cf3147aaa764aafd4114e6ff
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a643f1f3cf3147aaa764aafd4114e6ff
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	a643f1f3cf3147aaa764aafd4114e6ff
mlflow.runName	trial-142	a643f1f3cf3147aaa764aafd4114e6ff
mlflow.user	eduar	6975e9f2410b4b48a24bb54de3773f71
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	6975e9f2410b4b48a24bb54de3773f71
mlflow.source.type	LOCAL	6975e9f2410b4b48a24bb54de3773f71
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	6975e9f2410b4b48a24bb54de3773f71
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	6975e9f2410b4b48a24bb54de3773f71
mlflow.runName	trial-145	6975e9f2410b4b48a24bb54de3773f71
mlflow.user	eduar	ce2b0e6b82744bb9ab441eb5516e4bb9
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	ce2b0e6b82744bb9ab441eb5516e4bb9
mlflow.source.type	LOCAL	ce2b0e6b82744bb9ab441eb5516e4bb9
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	ce2b0e6b82744bb9ab441eb5516e4bb9
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	ce2b0e6b82744bb9ab441eb5516e4bb9
mlflow.runName	trial-148	ce2b0e6b82744bb9ab441eb5516e4bb9
mlflow.user	eduar	033ebefb766e4bfa8282ab39cec5c865
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	033ebefb766e4bfa8282ab39cec5c865
mlflow.source.type	LOCAL	033ebefb766e4bfa8282ab39cec5c865
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	033ebefb766e4bfa8282ab39cec5c865
mlflow.runName	champion-model	033ebefb766e4bfa8282ab39cec5c865
estimator_name	Pipeline	be0003b4c09f45a384716a36faaa3fde
estimator_class	sklearn.pipeline.Pipeline	be0003b4c09f45a384716a36faaa3fde
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b58e93020e20438db09d29ad3c13df59
mlflow.source.type	LOCAL	b58e93020e20438db09d29ad3c13df59
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b58e93020e20438db09d29ad3c13df59
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	b58e93020e20438db09d29ad3c13df59
mlflow.runName	trial-46	b58e93020e20438db09d29ad3c13df59
mlflow.user	eduar	70213c72967b441a8ecd0ad831f5b776
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	70213c72967b441a8ecd0ad831f5b776
mlflow.source.type	LOCAL	70213c72967b441a8ecd0ad831f5b776
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	70213c72967b441a8ecd0ad831f5b776
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	70213c72967b441a8ecd0ad831f5b776
mlflow.runName	trial-47	70213c72967b441a8ecd0ad831f5b776
mlflow.user	eduar	7eea4fc7e3a546589babe6a0b7310882
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7eea4fc7e3a546589babe6a0b7310882
mlflow.source.type	LOCAL	7eea4fc7e3a546589babe6a0b7310882
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7eea4fc7e3a546589babe6a0b7310882
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	7eea4fc7e3a546589babe6a0b7310882
mlflow.runName	trial-48	7eea4fc7e3a546589babe6a0b7310882
mlflow.user	eduar	518de6201cd84159962c329678dae7c7
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	518de6201cd84159962c329678dae7c7
mlflow.source.type	LOCAL	518de6201cd84159962c329678dae7c7
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	518de6201cd84159962c329678dae7c7
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	518de6201cd84159962c329678dae7c7
mlflow.runName	trial-49	518de6201cd84159962c329678dae7c7
mlflow.user	eduar	2ab6619860f04dd6806c00d08dd3c42d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2ab6619860f04dd6806c00d08dd3c42d
mlflow.source.type	LOCAL	2ab6619860f04dd6806c00d08dd3c42d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2ab6619860f04dd6806c00d08dd3c42d
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	2ab6619860f04dd6806c00d08dd3c42d
mlflow.runName	trial-50	2ab6619860f04dd6806c00d08dd3c42d
mlflow.user	eduar	cc29150802304136adce6bad79c64a02
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	cc29150802304136adce6bad79c64a02
mlflow.source.type	LOCAL	cc29150802304136adce6bad79c64a02
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	cc29150802304136adce6bad79c64a02
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	cc29150802304136adce6bad79c64a02
mlflow.runName	trial-51	cc29150802304136adce6bad79c64a02
mlflow.user	eduar	e70dd208f60b4acc863c851496a7b8e1
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e70dd208f60b4acc863c851496a7b8e1
mlflow.source.type	LOCAL	e70dd208f60b4acc863c851496a7b8e1
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e70dd208f60b4acc863c851496a7b8e1
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	e70dd208f60b4acc863c851496a7b8e1
mlflow.runName	trial-52	e70dd208f60b4acc863c851496a7b8e1
mlflow.user	eduar	16766e90a32c4f369ecd9e9b701ab356
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	16766e90a32c4f369ecd9e9b701ab356
mlflow.source.type	LOCAL	16766e90a32c4f369ecd9e9b701ab356
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	16766e90a32c4f369ecd9e9b701ab356
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	16766e90a32c4f369ecd9e9b701ab356
mlflow.runName	trial-53	16766e90a32c4f369ecd9e9b701ab356
mlflow.user	eduar	2918b242568447af9cdc39919fb7482a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2918b242568447af9cdc39919fb7482a
mlflow.source.type	LOCAL	2918b242568447af9cdc39919fb7482a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2918b242568447af9cdc39919fb7482a
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	2918b242568447af9cdc39919fb7482a
mlflow.runName	trial-54	2918b242568447af9cdc39919fb7482a
mlflow.user	eduar	0f8c5f9035b34684adc09c8445ef8cea
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0f8c5f9035b34684adc09c8445ef8cea
mlflow.source.type	LOCAL	0f8c5f9035b34684adc09c8445ef8cea
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0f8c5f9035b34684adc09c8445ef8cea
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	0f8c5f9035b34684adc09c8445ef8cea
mlflow.runName	trial-55	0f8c5f9035b34684adc09c8445ef8cea
mlflow.user	eduar	10f0304d917b4d91a53520741a9f09f3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	10f0304d917b4d91a53520741a9f09f3
mlflow.source.type	LOCAL	10f0304d917b4d91a53520741a9f09f3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	10f0304d917b4d91a53520741a9f09f3
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	10f0304d917b4d91a53520741a9f09f3
mlflow.runName	trial-56	10f0304d917b4d91a53520741a9f09f3
mlflow.user	eduar	0862f531c85046b18a2ec61111e68861
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0862f531c85046b18a2ec61111e68861
mlflow.source.type	LOCAL	0862f531c85046b18a2ec61111e68861
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0862f531c85046b18a2ec61111e68861
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	0862f531c85046b18a2ec61111e68861
mlflow.runName	trial-57	0862f531c85046b18a2ec61111e68861
mlflow.user	eduar	718cc73f4d1b4db98abc0e7b10db5ed6
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	718cc73f4d1b4db98abc0e7b10db5ed6
mlflow.source.type	LOCAL	718cc73f4d1b4db98abc0e7b10db5ed6
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	718cc73f4d1b4db98abc0e7b10db5ed6
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	718cc73f4d1b4db98abc0e7b10db5ed6
mlflow.runName	trial-58	718cc73f4d1b4db98abc0e7b10db5ed6
mlflow.user	eduar	d720a01642da4ff5b01c61771cdf9d91
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d720a01642da4ff5b01c61771cdf9d91
mlflow.source.type	LOCAL	d720a01642da4ff5b01c61771cdf9d91
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d720a01642da4ff5b01c61771cdf9d91
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	d720a01642da4ff5b01c61771cdf9d91
mlflow.runName	trial-43	d720a01642da4ff5b01c61771cdf9d91
mlflow.user	eduar	bec59faddbfa49baa60c2a3653cd5dbd
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	bec59faddbfa49baa60c2a3653cd5dbd
mlflow.source.type	LOCAL	bec59faddbfa49baa60c2a3653cd5dbd
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	bec59faddbfa49baa60c2a3653cd5dbd
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	bec59faddbfa49baa60c2a3653cd5dbd
mlflow.runName	trial-149	bec59faddbfa49baa60c2a3653cd5dbd
stage	production	033ebefb766e4bfa8282ab39cec5c865
mlflow.user	eduar	f3039f0f77a54e3a87583ce82d69fd41
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	f3039f0f77a54e3a87583ce82d69fd41
mlflow.source.type	LOCAL	f3039f0f77a54e3a87583ce82d69fd41
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	f3039f0f77a54e3a87583ce82d69fd41
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	f3039f0f77a54e3a87583ce82d69fd41
mlflow.runName	trial-59	f3039f0f77a54e3a87583ce82d69fd41
mlflow.user	eduar	9c030b074f6740f7b9f76b2dddeffb8c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9c030b074f6740f7b9f76b2dddeffb8c
mlflow.source.type	LOCAL	9c030b074f6740f7b9f76b2dddeffb8c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9c030b074f6740f7b9f76b2dddeffb8c
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	9c030b074f6740f7b9f76b2dddeffb8c
mlflow.runName	trial-44	9c030b074f6740f7b9f76b2dddeffb8c
mlflow.user	eduar	4fe6b8e9bbef4cb49dd0b503775f095e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	4fe6b8e9bbef4cb49dd0b503775f095e
mlflow.source.type	LOCAL	4fe6b8e9bbef4cb49dd0b503775f095e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	4fe6b8e9bbef4cb49dd0b503775f095e
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	4fe6b8e9bbef4cb49dd0b503775f095e
mlflow.runName	trial-45	4fe6b8e9bbef4cb49dd0b503775f095e
mlflow.user	eduar	23cfec62bb2b4c81b834e33e1d64015a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	23cfec62bb2b4c81b834e33e1d64015a
mlflow.source.type	LOCAL	23cfec62bb2b4c81b834e33e1d64015a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	23cfec62bb2b4c81b834e33e1d64015a
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	23cfec62bb2b4c81b834e33e1d64015a
mlflow.runName	trial-56	23cfec62bb2b4c81b834e33e1d64015a
mlflow.user	eduar	384089aee8ff469e884eb523460d2e23
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	384089aee8ff469e884eb523460d2e23
mlflow.source.type	LOCAL	384089aee8ff469e884eb523460d2e23
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	384089aee8ff469e884eb523460d2e23
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	384089aee8ff469e884eb523460d2e23
mlflow.runName	trial-61	384089aee8ff469e884eb523460d2e23
mlflow.user	eduar	ea05524904e94189b607f30d35114cf5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	ea05524904e94189b607f30d35114cf5
mlflow.source.type	LOCAL	ea05524904e94189b607f30d35114cf5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	ea05524904e94189b607f30d35114cf5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	ea05524904e94189b607f30d35114cf5
mlflow.runName	trial-68	ea05524904e94189b607f30d35114cf5
model_role	champion	be0003b4c09f45a384716a36faaa3fde
mlflow.user	eduar	5f60cb1e96ef4d32aba7cf2ba79d8aa2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5f60cb1e96ef4d32aba7cf2ba79d8aa2
mlflow.source.type	LOCAL	5f60cb1e96ef4d32aba7cf2ba79d8aa2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5f60cb1e96ef4d32aba7cf2ba79d8aa2
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	5f60cb1e96ef4d32aba7cf2ba79d8aa2
mlflow.runName	trial-60	5f60cb1e96ef4d32aba7cf2ba79d8aa2
mlflow.user	eduar	a8986aaa09bb45edaf20a7a2a477b6f0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a8986aaa09bb45edaf20a7a2a477b6f0
mlflow.source.type	LOCAL	a8986aaa09bb45edaf20a7a2a477b6f0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a8986aaa09bb45edaf20a7a2a477b6f0
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	a8986aaa09bb45edaf20a7a2a477b6f0
mlflow.runName	trial-61	a8986aaa09bb45edaf20a7a2a477b6f0
mlflow.user	eduar	9aac8f92473d49cf903225b9a22ad98e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9aac8f92473d49cf903225b9a22ad98e
mlflow.source.type	LOCAL	9aac8f92473d49cf903225b9a22ad98e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9aac8f92473d49cf903225b9a22ad98e
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	9aac8f92473d49cf903225b9a22ad98e
mlflow.runName	trial-62	9aac8f92473d49cf903225b9a22ad98e
mlflow.user	eduar	08f786cb8efb4f64b9a2607fd6ca5ee5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	08f786cb8efb4f64b9a2607fd6ca5ee5
mlflow.source.type	LOCAL	08f786cb8efb4f64b9a2607fd6ca5ee5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	08f786cb8efb4f64b9a2607fd6ca5ee5
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	08f786cb8efb4f64b9a2607fd6ca5ee5
mlflow.runName	trial-63	08f786cb8efb4f64b9a2607fd6ca5ee5
mlflow.user	eduar	d1000f6e85de4fe2a8c95dc022bdab8f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d1000f6e85de4fe2a8c95dc022bdab8f
mlflow.source.type	LOCAL	d1000f6e85de4fe2a8c95dc022bdab8f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d1000f6e85de4fe2a8c95dc022bdab8f
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	d1000f6e85de4fe2a8c95dc022bdab8f
mlflow.runName	trial-64	d1000f6e85de4fe2a8c95dc022bdab8f
mlflow.user	eduar	deb70d2c6e9844ad8ec9a5549a069559
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	deb70d2c6e9844ad8ec9a5549a069559
mlflow.source.type	LOCAL	deb70d2c6e9844ad8ec9a5549a069559
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	deb70d2c6e9844ad8ec9a5549a069559
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	deb70d2c6e9844ad8ec9a5549a069559
mlflow.runName	trial-65	deb70d2c6e9844ad8ec9a5549a069559
mlflow.user	eduar	a8ef003494f048faa29d895d18d2d187
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a8ef003494f048faa29d895d18d2d187
mlflow.source.type	LOCAL	a8ef003494f048faa29d895d18d2d187
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a8ef003494f048faa29d895d18d2d187
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	a8ef003494f048faa29d895d18d2d187
mlflow.runName	trial-66	a8ef003494f048faa29d895d18d2d187
mlflow.user	eduar	651dd8509db8453e9b57f0db626a0bc0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	651dd8509db8453e9b57f0db626a0bc0
mlflow.source.type	LOCAL	651dd8509db8453e9b57f0db626a0bc0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	651dd8509db8453e9b57f0db626a0bc0
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	651dd8509db8453e9b57f0db626a0bc0
mlflow.runName	trial-67	651dd8509db8453e9b57f0db626a0bc0
mlflow.user	eduar	69b74a9c9f174a25b25bca9453b251dd
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	69b74a9c9f174a25b25bca9453b251dd
mlflow.source.type	LOCAL	69b74a9c9f174a25b25bca9453b251dd
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	69b74a9c9f174a25b25bca9453b251dd
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	69b74a9c9f174a25b25bca9453b251dd
mlflow.runName	trial-68	69b74a9c9f174a25b25bca9453b251dd
mlflow.user	eduar	4a86e315bd1b42e4a441cf540b75416d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	4a86e315bd1b42e4a441cf540b75416d
mlflow.source.type	LOCAL	4a86e315bd1b42e4a441cf540b75416d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	4a86e315bd1b42e4a441cf540b75416d
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	4a86e315bd1b42e4a441cf540b75416d
mlflow.runName	trial-69	4a86e315bd1b42e4a441cf540b75416d
mlflow.user	eduar	fb402d7ff6d741018d6a91ea10972f05
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	fb402d7ff6d741018d6a91ea10972f05
mlflow.source.type	LOCAL	fb402d7ff6d741018d6a91ea10972f05
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	fb402d7ff6d741018d6a91ea10972f05
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	fb402d7ff6d741018d6a91ea10972f05
mlflow.runName	trial-70	fb402d7ff6d741018d6a91ea10972f05
mlflow.user	eduar	e094133c648a4dcf978411aa6d5934e7
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e094133c648a4dcf978411aa6d5934e7
mlflow.source.type	LOCAL	e094133c648a4dcf978411aa6d5934e7
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e094133c648a4dcf978411aa6d5934e7
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	e094133c648a4dcf978411aa6d5934e7
mlflow.runName	trial-71	e094133c648a4dcf978411aa6d5934e7
mlflow.user	eduar	7594e7f61c11418997699b81d6b68aac
mlflow.user	eduar	8883ec417d31449b9c035b2913e2c586
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7594e7f61c11418997699b81d6b68aac
mlflow.source.type	LOCAL	7594e7f61c11418997699b81d6b68aac
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7594e7f61c11418997699b81d6b68aac
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	7594e7f61c11418997699b81d6b68aac
mlflow.runName	trial-72	7594e7f61c11418997699b81d6b68aac
mlflow.user	eduar	532603551a954e97bc6f82485f631d2e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	532603551a954e97bc6f82485f631d2e
mlflow.source.type	LOCAL	532603551a954e97bc6f82485f631d2e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	532603551a954e97bc6f82485f631d2e
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	532603551a954e97bc6f82485f631d2e
mlflow.runName	trial-49	532603551a954e97bc6f82485f631d2e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8883ec417d31449b9c035b2913e2c586
mlflow.source.type	LOCAL	8883ec417d31449b9c035b2913e2c586
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8883ec417d31449b9c035b2913e2c586
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	8883ec417d31449b9c035b2913e2c586
mlflow.runName	trial-73	8883ec417d31449b9c035b2913e2c586
mlflow.user	eduar	97fb30d77c874bbe909e9b34ff9ab219
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	97fb30d77c874bbe909e9b34ff9ab219
mlflow.source.type	LOCAL	97fb30d77c874bbe909e9b34ff9ab219
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	97fb30d77c874bbe909e9b34ff9ab219
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	97fb30d77c874bbe909e9b34ff9ab219
mlflow.runName	trial-55	97fb30d77c874bbe909e9b34ff9ab219
mlflow.user	eduar	5271cb97dc8e4421816e4fbc4e06b329
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5271cb97dc8e4421816e4fbc4e06b329
mlflow.source.type	LOCAL	5271cb97dc8e4421816e4fbc4e06b329
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5271cb97dc8e4421816e4fbc4e06b329
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	5271cb97dc8e4421816e4fbc4e06b329
mlflow.runName	trial-59	5271cb97dc8e4421816e4fbc4e06b329
mlflow.user	eduar	7f39848a745a4f55b4b6f53656bbea09
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7f39848a745a4f55b4b6f53656bbea09
mlflow.source.type	LOCAL	7f39848a745a4f55b4b6f53656bbea09
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7f39848a745a4f55b4b6f53656bbea09
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	7f39848a745a4f55b4b6f53656bbea09
mlflow.runName	trial-65	7f39848a745a4f55b4b6f53656bbea09
mlflow.user	eduar	fca3189b071b4c8aae99a36fec28a55a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	fca3189b071b4c8aae99a36fec28a55a
mlflow.source.type	LOCAL	fca3189b071b4c8aae99a36fec28a55a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	fca3189b071b4c8aae99a36fec28a55a
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	fca3189b071b4c8aae99a36fec28a55a
mlflow.runName	trial-74	fca3189b071b4c8aae99a36fec28a55a
mlflow.user	eduar	59630d004d38484f8b30f453b17fd561
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	59630d004d38484f8b30f453b17fd561
mlflow.source.type	LOCAL	59630d004d38484f8b30f453b17fd561
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	59630d004d38484f8b30f453b17fd561
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	59630d004d38484f8b30f453b17fd561
mlflow.runName	trial-69	59630d004d38484f8b30f453b17fd561
mlflow.user	eduar	8c6c444e121e4c82ad5345c29fcd297d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8c6c444e121e4c82ad5345c29fcd297d
mlflow.source.type	LOCAL	8c6c444e121e4c82ad5345c29fcd297d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8c6c444e121e4c82ad5345c29fcd297d
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	8c6c444e121e4c82ad5345c29fcd297d
mlflow.runName	trial-79	8c6c444e121e4c82ad5345c29fcd297d
mlflow.user	eduar	7166345b17ac40e3a6384bc3e57a4e38
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7166345b17ac40e3a6384bc3e57a4e38
mlflow.source.type	LOCAL	7166345b17ac40e3a6384bc3e57a4e38
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7166345b17ac40e3a6384bc3e57a4e38
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	7166345b17ac40e3a6384bc3e57a4e38
mlflow.runName	trial-83	7166345b17ac40e3a6384bc3e57a4e38
mlflow.user	eduar	3a54e130da3a488e9cddd8f564b50636
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3a54e130da3a488e9cddd8f564b50636
mlflow.source.type	LOCAL	3a54e130da3a488e9cddd8f564b50636
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3a54e130da3a488e9cddd8f564b50636
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	3a54e130da3a488e9cddd8f564b50636
mlflow.runName	trial-86	3a54e130da3a488e9cddd8f564b50636
mlflow.user	eduar	7c8b46c7a5b748aa8f1d0b39f7af527e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7c8b46c7a5b748aa8f1d0b39f7af527e
mlflow.source.type	LOCAL	7c8b46c7a5b748aa8f1d0b39f7af527e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7c8b46c7a5b748aa8f1d0b39f7af527e
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	7c8b46c7a5b748aa8f1d0b39f7af527e
mlflow.runName	trial-75	7c8b46c7a5b748aa8f1d0b39f7af527e
mlflow.user	eduar	3543bc1d263645d99771e0034c716e7b
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3543bc1d263645d99771e0034c716e7b
mlflow.source.type	LOCAL	3543bc1d263645d99771e0034c716e7b
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3543bc1d263645d99771e0034c716e7b
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	3543bc1d263645d99771e0034c716e7b
mlflow.runName	trial-76	3543bc1d263645d99771e0034c716e7b
mlflow.user	eduar	c88117b6aafc456082337e849f1bf075
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c88117b6aafc456082337e849f1bf075
mlflow.source.type	LOCAL	c88117b6aafc456082337e849f1bf075
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c88117b6aafc456082337e849f1bf075
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c88117b6aafc456082337e849f1bf075
mlflow.runName	trial-77	c88117b6aafc456082337e849f1bf075
mlflow.user	eduar	143106f491a142fa98764b4036346fc5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	143106f491a142fa98764b4036346fc5
mlflow.source.type	LOCAL	143106f491a142fa98764b4036346fc5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	143106f491a142fa98764b4036346fc5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	143106f491a142fa98764b4036346fc5
mlflow.runName	trial-70	143106f491a142fa98764b4036346fc5
mlflow.user	eduar	c8478da13b1d44e09ff6954fe7f8ceb5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c8478da13b1d44e09ff6954fe7f8ceb5
mlflow.source.type	LOCAL	c8478da13b1d44e09ff6954fe7f8ceb5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c8478da13b1d44e09ff6954fe7f8ceb5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	c8478da13b1d44e09ff6954fe7f8ceb5
mlflow.runName	trial-74	c8478da13b1d44e09ff6954fe7f8ceb5
mlflow.user	eduar	7305560d783f4197a5a7e63dcb91495c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7305560d783f4197a5a7e63dcb91495c
mlflow.source.type	LOCAL	7305560d783f4197a5a7e63dcb91495c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7305560d783f4197a5a7e63dcb91495c
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	7305560d783f4197a5a7e63dcb91495c
mlflow.runName	trial-88	7305560d783f4197a5a7e63dcb91495c
mlflow.user	eduar	df12860a7b4a46e9abaef76ff774590e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	df12860a7b4a46e9abaef76ff774590e
mlflow.source.type	LOCAL	df12860a7b4a46e9abaef76ff774590e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	df12860a7b4a46e9abaef76ff774590e
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	df12860a7b4a46e9abaef76ff774590e
mlflow.runName	trial-95	df12860a7b4a46e9abaef76ff774590e
mlflow.user	eduar	aa2f79a2f19d42db9cb8620483e02b5e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	aa2f79a2f19d42db9cb8620483e02b5e
mlflow.source.type	LOCAL	aa2f79a2f19d42db9cb8620483e02b5e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	aa2f79a2f19d42db9cb8620483e02b5e
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	aa2f79a2f19d42db9cb8620483e02b5e
mlflow.runName	trial-78	aa2f79a2f19d42db9cb8620483e02b5e
mlflow.user	eduar	804bc8eb2efe4ead940fa0c158126ca0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	804bc8eb2efe4ead940fa0c158126ca0
mlflow.source.type	LOCAL	804bc8eb2efe4ead940fa0c158126ca0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	804bc8eb2efe4ead940fa0c158126ca0
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	804bc8eb2efe4ead940fa0c158126ca0
mlflow.runName	trial-79	804bc8eb2efe4ead940fa0c158126ca0
mlflow.user	eduar	329d6d6fd07d4659b5300ae5ad320063
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	329d6d6fd07d4659b5300ae5ad320063
mlflow.source.type	LOCAL	329d6d6fd07d4659b5300ae5ad320063
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	329d6d6fd07d4659b5300ae5ad320063
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	329d6d6fd07d4659b5300ae5ad320063
mlflow.runName	trial-80	329d6d6fd07d4659b5300ae5ad320063
mlflow.user	eduar	0260b00d3be4497b9ca6fbdcf0fb56f3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0260b00d3be4497b9ca6fbdcf0fb56f3
mlflow.source.type	LOCAL	0260b00d3be4497b9ca6fbdcf0fb56f3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0260b00d3be4497b9ca6fbdcf0fb56f3
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	0260b00d3be4497b9ca6fbdcf0fb56f3
mlflow.runName	trial-81	0260b00d3be4497b9ca6fbdcf0fb56f3
mlflow.user	eduar	e8d9a9ae1a314ef4822cb690114b565a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e8d9a9ae1a314ef4822cb690114b565a
mlflow.source.type	LOCAL	e8d9a9ae1a314ef4822cb690114b565a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e8d9a9ae1a314ef4822cb690114b565a
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	e8d9a9ae1a314ef4822cb690114b565a
mlflow.runName	trial-82	e8d9a9ae1a314ef4822cb690114b565a
mlflow.user	eduar	c174b51cb9ef4197a069b455c2ae15f6
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c174b51cb9ef4197a069b455c2ae15f6
mlflow.source.type	LOCAL	c174b51cb9ef4197a069b455c2ae15f6
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c174b51cb9ef4197a069b455c2ae15f6
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c174b51cb9ef4197a069b455c2ae15f6
mlflow.runName	trial-83	c174b51cb9ef4197a069b455c2ae15f6
mlflow.user	eduar	0561a4c2b698400f949c0e76eef5fbdc
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0561a4c2b698400f949c0e76eef5fbdc
mlflow.source.type	LOCAL	0561a4c2b698400f949c0e76eef5fbdc
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0561a4c2b698400f949c0e76eef5fbdc
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	0561a4c2b698400f949c0e76eef5fbdc
mlflow.runName	trial-84	0561a4c2b698400f949c0e76eef5fbdc
mlflow.user	eduar	581effbe4a2f4945aaadeb01b564b851
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	581effbe4a2f4945aaadeb01b564b851
mlflow.source.type	LOCAL	581effbe4a2f4945aaadeb01b564b851
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	581effbe4a2f4945aaadeb01b564b851
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	581effbe4a2f4945aaadeb01b564b851
mlflow.runName	trial-85	581effbe4a2f4945aaadeb01b564b851
mlflow.user	eduar	d90190edced44c048d8f32ec24d761bb
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d90190edced44c048d8f32ec24d761bb
mlflow.source.type	LOCAL	d90190edced44c048d8f32ec24d761bb
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d90190edced44c048d8f32ec24d761bb
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	d90190edced44c048d8f32ec24d761bb
mlflow.runName	trial-86	d90190edced44c048d8f32ec24d761bb
mlflow.user	eduar	3ac81d7485e549e392a19922b5afb56d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3ac81d7485e549e392a19922b5afb56d
mlflow.source.type	LOCAL	3ac81d7485e549e392a19922b5afb56d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3ac81d7485e549e392a19922b5afb56d
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	3ac81d7485e549e392a19922b5afb56d
mlflow.runName	trial-87	3ac81d7485e549e392a19922b5afb56d
mlflow.user	eduar	9310e0296fef46229d141a34118600f6
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9310e0296fef46229d141a34118600f6
mlflow.source.type	LOCAL	9310e0296fef46229d141a34118600f6
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9310e0296fef46229d141a34118600f6
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	9310e0296fef46229d141a34118600f6
mlflow.runName	trial-88	9310e0296fef46229d141a34118600f6
mlflow.user	eduar	8dd0782b26a647b0924ccd9a97b01735
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8dd0782b26a647b0924ccd9a97b01735
mlflow.source.type	LOCAL	8dd0782b26a647b0924ccd9a97b01735
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8dd0782b26a647b0924ccd9a97b01735
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	8dd0782b26a647b0924ccd9a97b01735
mlflow.runName	trial-89	8dd0782b26a647b0924ccd9a97b01735
mlflow.user	eduar	17cdd4ed361b4c6aa962d390cb1f5fc5
mlflow.user	eduar	8e5b753561c44b3195234ef62f8f47b2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	17cdd4ed361b4c6aa962d390cb1f5fc5
mlflow.source.type	LOCAL	17cdd4ed361b4c6aa962d390cb1f5fc5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	17cdd4ed361b4c6aa962d390cb1f5fc5
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	17cdd4ed361b4c6aa962d390cb1f5fc5
mlflow.runName	trial-90	17cdd4ed361b4c6aa962d390cb1f5fc5
mlflow.user	eduar	3401268c42cb4248abf5eb0c4fca768a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3401268c42cb4248abf5eb0c4fca768a
mlflow.source.type	LOCAL	3401268c42cb4248abf5eb0c4fca768a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3401268c42cb4248abf5eb0c4fca768a
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	3401268c42cb4248abf5eb0c4fca768a
mlflow.runName	trial-91	3401268c42cb4248abf5eb0c4fca768a
mlflow.user	eduar	701e73d0f1184acd9682089de7c9c496
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	701e73d0f1184acd9682089de7c9c496
mlflow.source.type	LOCAL	701e73d0f1184acd9682089de7c9c496
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	701e73d0f1184acd9682089de7c9c496
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	701e73d0f1184acd9682089de7c9c496
mlflow.runName	trial-92	701e73d0f1184acd9682089de7c9c496
mlflow.user	eduar	cf02466f55074fecb9cf4a06f6468695
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	cf02466f55074fecb9cf4a06f6468695
mlflow.source.type	LOCAL	cf02466f55074fecb9cf4a06f6468695
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	cf02466f55074fecb9cf4a06f6468695
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	cf02466f55074fecb9cf4a06f6468695
mlflow.runName	trial-94	cf02466f55074fecb9cf4a06f6468695
mlflow.user	eduar	cfd7a5c4650749a99227270f7490d366
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	cfd7a5c4650749a99227270f7490d366
mlflow.source.type	LOCAL	cfd7a5c4650749a99227270f7490d366
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	cfd7a5c4650749a99227270f7490d366
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	cfd7a5c4650749a99227270f7490d366
mlflow.runName	trial-95	cfd7a5c4650749a99227270f7490d366
mlflow.user	eduar	8f70bc6c911d4d3daac5817bcbceb1c8
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8f70bc6c911d4d3daac5817bcbceb1c8
mlflow.source.type	LOCAL	8f70bc6c911d4d3daac5817bcbceb1c8
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8f70bc6c911d4d3daac5817bcbceb1c8
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	8f70bc6c911d4d3daac5817bcbceb1c8
mlflow.runName	trial-96	8f70bc6c911d4d3daac5817bcbceb1c8
mlflow.user	eduar	212e3cc9c33a469097370a89878e6e0d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	212e3cc9c33a469097370a89878e6e0d
mlflow.source.type	LOCAL	212e3cc9c33a469097370a89878e6e0d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	212e3cc9c33a469097370a89878e6e0d
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	212e3cc9c33a469097370a89878e6e0d
mlflow.runName	trial-71	212e3cc9c33a469097370a89878e6e0d
mlflow.user	eduar	14f0de2bdc004a6ca97d19b2d9dad96b
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	14f0de2bdc004a6ca97d19b2d9dad96b
mlflow.source.type	LOCAL	14f0de2bdc004a6ca97d19b2d9dad96b
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	14f0de2bdc004a6ca97d19b2d9dad96b
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	14f0de2bdc004a6ca97d19b2d9dad96b
mlflow.runName	trial-80	14f0de2bdc004a6ca97d19b2d9dad96b
mlflow.user	eduar	531d154bc65c4e3c9e3e691c91d4e598
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	531d154bc65c4e3c9e3e691c91d4e598
mlflow.source.type	LOCAL	531d154bc65c4e3c9e3e691c91d4e598
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	531d154bc65c4e3c9e3e691c91d4e598
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	531d154bc65c4e3c9e3e691c91d4e598
mlflow.runName	trial-82	531d154bc65c4e3c9e3e691c91d4e598
mlflow.user	eduar	e04590dc86674c0985b160f47a15d939
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e04590dc86674c0985b160f47a15d939
mlflow.source.type	LOCAL	e04590dc86674c0985b160f47a15d939
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e04590dc86674c0985b160f47a15d939
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	e04590dc86674c0985b160f47a15d939
mlflow.runName	trial-84	e04590dc86674c0985b160f47a15d939
mlflow.user	eduar	a45d4a14e3cb4767b85a0dd503888266
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a45d4a14e3cb4767b85a0dd503888266
mlflow.source.type	LOCAL	a45d4a14e3cb4767b85a0dd503888266
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a45d4a14e3cb4767b85a0dd503888266
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	a45d4a14e3cb4767b85a0dd503888266
mlflow.runName	trial-96	a45d4a14e3cb4767b85a0dd503888266
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8e5b753561c44b3195234ef62f8f47b2
mlflow.source.type	LOCAL	8e5b753561c44b3195234ef62f8f47b2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8e5b753561c44b3195234ef62f8f47b2
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	8e5b753561c44b3195234ef62f8f47b2
mlflow.runName	trial-93	8e5b753561c44b3195234ef62f8f47b2
mlflow.user	eduar	491c6531e590476ba6d0e4c3f8ee4002
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	491c6531e590476ba6d0e4c3f8ee4002
mlflow.source.type	LOCAL	491c6531e590476ba6d0e4c3f8ee4002
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	491c6531e590476ba6d0e4c3f8ee4002
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	491c6531e590476ba6d0e4c3f8ee4002
mlflow.runName	trial-97	491c6531e590476ba6d0e4c3f8ee4002
mlflow.user	eduar	111954c77263486eb7b19f050d26b75a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	111954c77263486eb7b19f050d26b75a
mlflow.source.type	LOCAL	111954c77263486eb7b19f050d26b75a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	111954c77263486eb7b19f050d26b75a
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	111954c77263486eb7b19f050d26b75a
mlflow.runName	trial-98	111954c77263486eb7b19f050d26b75a
mlflow.user	eduar	9c1ced865d204984869839b7cd4f6859
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9c1ced865d204984869839b7cd4f6859
mlflow.source.type	LOCAL	9c1ced865d204984869839b7cd4f6859
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9c1ced865d204984869839b7cd4f6859
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	9c1ced865d204984869839b7cd4f6859
mlflow.runName	trial-99	9c1ced865d204984869839b7cd4f6859
mlflow.user	eduar	c2857623dd374caeb05d44680f352000
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c2857623dd374caeb05d44680f352000
mlflow.source.type	LOCAL	c2857623dd374caeb05d44680f352000
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c2857623dd374caeb05d44680f352000
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c2857623dd374caeb05d44680f352000
mlflow.runName	trial-100	c2857623dd374caeb05d44680f352000
mlflow.user	eduar	a6e212b95bfc4605a1be9024004fb49f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a6e212b95bfc4605a1be9024004fb49f
mlflow.source.type	LOCAL	a6e212b95bfc4605a1be9024004fb49f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a6e212b95bfc4605a1be9024004fb49f
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	a6e212b95bfc4605a1be9024004fb49f
mlflow.runName	trial-101	a6e212b95bfc4605a1be9024004fb49f
mlflow.user	eduar	3919fe95d06c45a48568942d0a5d55ac
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3919fe95d06c45a48568942d0a5d55ac
mlflow.source.type	LOCAL	3919fe95d06c45a48568942d0a5d55ac
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3919fe95d06c45a48568942d0a5d55ac
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	3919fe95d06c45a48568942d0a5d55ac
mlflow.runName	trial-102	3919fe95d06c45a48568942d0a5d55ac
mlflow.user	eduar	9e05181cd24c4328ad2c35ebdb23abc7
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9e05181cd24c4328ad2c35ebdb23abc7
mlflow.source.type	LOCAL	9e05181cd24c4328ad2c35ebdb23abc7
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9e05181cd24c4328ad2c35ebdb23abc7
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	9e05181cd24c4328ad2c35ebdb23abc7
mlflow.runName	trial-103	9e05181cd24c4328ad2c35ebdb23abc7
mlflow.user	eduar	99058e32615c47359503e260cbce6d91
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	99058e32615c47359503e260cbce6d91
mlflow.source.type	LOCAL	99058e32615c47359503e260cbce6d91
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	99058e32615c47359503e260cbce6d91
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	99058e32615c47359503e260cbce6d91
mlflow.runName	trial-104	99058e32615c47359503e260cbce6d91
mlflow.user	eduar	6d7c5305df6349cebc54d4fa9a31214a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	6d7c5305df6349cebc54d4fa9a31214a
mlflow.source.type	LOCAL	6d7c5305df6349cebc54d4fa9a31214a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	6d7c5305df6349cebc54d4fa9a31214a
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	6d7c5305df6349cebc54d4fa9a31214a
mlflow.runName	trial-105	6d7c5305df6349cebc54d4fa9a31214a
mlflow.user	eduar	08b5f55856b74797a4e16456167adfd5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	08b5f55856b74797a4e16456167adfd5
mlflow.source.type	LOCAL	08b5f55856b74797a4e16456167adfd5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	08b5f55856b74797a4e16456167adfd5
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	08b5f55856b74797a4e16456167adfd5
mlflow.runName	trial-106	08b5f55856b74797a4e16456167adfd5
mlflow.user	eduar	d936f59062f2489586c8c6aa48246a22
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d936f59062f2489586c8c6aa48246a22
mlflow.source.type	LOCAL	d936f59062f2489586c8c6aa48246a22
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d936f59062f2489586c8c6aa48246a22
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	d936f59062f2489586c8c6aa48246a22
mlflow.runName	trial-107	d936f59062f2489586c8c6aa48246a22
mlflow.user	eduar	49388c150ccb4b929ee16b2bb07bb27f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	49388c150ccb4b929ee16b2bb07bb27f
mlflow.source.type	LOCAL	49388c150ccb4b929ee16b2bb07bb27f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	49388c150ccb4b929ee16b2bb07bb27f
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	49388c150ccb4b929ee16b2bb07bb27f
mlflow.runName	trial-108	49388c150ccb4b929ee16b2bb07bb27f
mlflow.user	eduar	64b0900a1e964558863d196db339900c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	64b0900a1e964558863d196db339900c
mlflow.source.type	LOCAL	64b0900a1e964558863d196db339900c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	64b0900a1e964558863d196db339900c
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	64b0900a1e964558863d196db339900c
mlflow.runName	trial-113	64b0900a1e964558863d196db339900c
mlflow.user	eduar	5098e5701fc04d33a5d78ff3e0c2d8f2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5098e5701fc04d33a5d78ff3e0c2d8f2
mlflow.source.type	LOCAL	5098e5701fc04d33a5d78ff3e0c2d8f2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5098e5701fc04d33a5d78ff3e0c2d8f2
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	5098e5701fc04d33a5d78ff3e0c2d8f2
mlflow.runName	trial-72	5098e5701fc04d33a5d78ff3e0c2d8f2
mlflow.user	eduar	0b4fd1f6f7d84dfe891162a68110faa4
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0b4fd1f6f7d84dfe891162a68110faa4
mlflow.source.type	LOCAL	0b4fd1f6f7d84dfe891162a68110faa4
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0b4fd1f6f7d84dfe891162a68110faa4
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	0b4fd1f6f7d84dfe891162a68110faa4
mlflow.runName	trial-73	0b4fd1f6f7d84dfe891162a68110faa4
mlflow.user	eduar	27593188f9b74471b4e76392b99287d0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	27593188f9b74471b4e76392b99287d0
mlflow.source.type	LOCAL	27593188f9b74471b4e76392b99287d0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	27593188f9b74471b4e76392b99287d0
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	27593188f9b74471b4e76392b99287d0
mlflow.runName	trial-109	27593188f9b74471b4e76392b99287d0
mlflow.user	eduar	7d1d89bca5f64345807b2f8710248857
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7d1d89bca5f64345807b2f8710248857
mlflow.source.type	LOCAL	7d1d89bca5f64345807b2f8710248857
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7d1d89bca5f64345807b2f8710248857
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	7d1d89bca5f64345807b2f8710248857
mlflow.runName	trial-110	7d1d89bca5f64345807b2f8710248857
mlflow.user	eduar	0f815fdf0e0645fcbc9bd75f41904b44
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0f815fdf0e0645fcbc9bd75f41904b44
mlflow.source.type	LOCAL	0f815fdf0e0645fcbc9bd75f41904b44
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0f815fdf0e0645fcbc9bd75f41904b44
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	0f815fdf0e0645fcbc9bd75f41904b44
mlflow.runName	trial-111	0f815fdf0e0645fcbc9bd75f41904b44
mlflow.user	eduar	fd3500958da74eb280182de207c1c9f1
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	fd3500958da74eb280182de207c1c9f1
mlflow.source.type	LOCAL	fd3500958da74eb280182de207c1c9f1
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	fd3500958da74eb280182de207c1c9f1
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	fd3500958da74eb280182de207c1c9f1
mlflow.runName	trial-112	fd3500958da74eb280182de207c1c9f1
mlflow.user	eduar	dc2d72393aae497781f7a6cceff926d7
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	dc2d72393aae497781f7a6cceff926d7
mlflow.source.type	LOCAL	dc2d72393aae497781f7a6cceff926d7
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	dc2d72393aae497781f7a6cceff926d7
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	dc2d72393aae497781f7a6cceff926d7
mlflow.runName	trial-114	dc2d72393aae497781f7a6cceff926d7
mlflow.user	eduar	c04b03a1eb034e30ab0dbfd07f0a56bc
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c04b03a1eb034e30ab0dbfd07f0a56bc
mlflow.source.type	LOCAL	c04b03a1eb034e30ab0dbfd07f0a56bc
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c04b03a1eb034e30ab0dbfd07f0a56bc
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c04b03a1eb034e30ab0dbfd07f0a56bc
mlflow.runName	trial-116	c04b03a1eb034e30ab0dbfd07f0a56bc
mlflow.user	eduar	61939d5dc91f45f0b71ee70059923014
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	61939d5dc91f45f0b71ee70059923014
mlflow.source.type	LOCAL	61939d5dc91f45f0b71ee70059923014
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	61939d5dc91f45f0b71ee70059923014
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	61939d5dc91f45f0b71ee70059923014
mlflow.runName	trial-117	61939d5dc91f45f0b71ee70059923014
mlflow.user	eduar	2593c87053c24c5ab46a701293e5da1c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2593c87053c24c5ab46a701293e5da1c
mlflow.source.type	LOCAL	2593c87053c24c5ab46a701293e5da1c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2593c87053c24c5ab46a701293e5da1c
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2593c87053c24c5ab46a701293e5da1c
mlflow.runName	trial-75	2593c87053c24c5ab46a701293e5da1c
mlflow.user	eduar	7f16b61fe03848238ff296583f7d49f5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7f16b61fe03848238ff296583f7d49f5
mlflow.source.type	LOCAL	7f16b61fe03848238ff296583f7d49f5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7f16b61fe03848238ff296583f7d49f5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	7f16b61fe03848238ff296583f7d49f5
mlflow.runName	trial-81	7f16b61fe03848238ff296583f7d49f5
mlflow.user	eduar	08a4d70131f54e81bd0d47a5448e3d43
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	08a4d70131f54e81bd0d47a5448e3d43
mlflow.source.type	LOCAL	08a4d70131f54e81bd0d47a5448e3d43
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	08a4d70131f54e81bd0d47a5448e3d43
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	08a4d70131f54e81bd0d47a5448e3d43
mlflow.runName	trial-85	08a4d70131f54e81bd0d47a5448e3d43
mlflow.user	eduar	5219ab1ee77e4d0a9b2ea76665637741
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5219ab1ee77e4d0a9b2ea76665637741
mlflow.source.type	LOCAL	5219ab1ee77e4d0a9b2ea76665637741
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5219ab1ee77e4d0a9b2ea76665637741
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	5219ab1ee77e4d0a9b2ea76665637741
mlflow.runName	trial-92	5219ab1ee77e4d0a9b2ea76665637741
mlflow.user	eduar	82bdb95fb73945928fc4add300efc29e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	82bdb95fb73945928fc4add300efc29e
mlflow.source.type	LOCAL	82bdb95fb73945928fc4add300efc29e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	82bdb95fb73945928fc4add300efc29e
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	82bdb95fb73945928fc4add300efc29e
mlflow.runName	trial-115	82bdb95fb73945928fc4add300efc29e
mlflow.user	eduar	e62dd40594234fe2b1e7032791dd20a8
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e62dd40594234fe2b1e7032791dd20a8
mlflow.source.type	LOCAL	e62dd40594234fe2b1e7032791dd20a8
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e62dd40594234fe2b1e7032791dd20a8
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	e62dd40594234fe2b1e7032791dd20a8
mlflow.runName	trial-118	e62dd40594234fe2b1e7032791dd20a8
mlflow.user	eduar	fd9968abd7b9464aa499ac3910ae6d59
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	fd9968abd7b9464aa499ac3910ae6d59
mlflow.source.type	LOCAL	fd9968abd7b9464aa499ac3910ae6d59
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	fd9968abd7b9464aa499ac3910ae6d59
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	fd9968abd7b9464aa499ac3910ae6d59
mlflow.runName	trial-119	fd9968abd7b9464aa499ac3910ae6d59
mlflow.user	eduar	40baf7c768a8472dac8cadf8920e416c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	40baf7c768a8472dac8cadf8920e416c
mlflow.source.type	LOCAL	40baf7c768a8472dac8cadf8920e416c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	40baf7c768a8472dac8cadf8920e416c
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	40baf7c768a8472dac8cadf8920e416c
mlflow.runName	trial-120	40baf7c768a8472dac8cadf8920e416c
mlflow.user	eduar	4b6e2f4862564695a32ae677d3ebd136
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	4b6e2f4862564695a32ae677d3ebd136
mlflow.source.type	LOCAL	4b6e2f4862564695a32ae677d3ebd136
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	4b6e2f4862564695a32ae677d3ebd136
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	4b6e2f4862564695a32ae677d3ebd136
mlflow.runName	trial-121	4b6e2f4862564695a32ae677d3ebd136
mlflow.user	eduar	82eba4c14c7b4ac791e397f13b4544de
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	82eba4c14c7b4ac791e397f13b4544de
mlflow.source.type	LOCAL	82eba4c14c7b4ac791e397f13b4544de
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	82eba4c14c7b4ac791e397f13b4544de
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	82eba4c14c7b4ac791e397f13b4544de
mlflow.runName	trial-122	82eba4c14c7b4ac791e397f13b4544de
mlflow.user	eduar	86e01e0667ec427599d0c10de411791f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	86e01e0667ec427599d0c10de411791f
mlflow.source.type	LOCAL	86e01e0667ec427599d0c10de411791f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	86e01e0667ec427599d0c10de411791f
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	86e01e0667ec427599d0c10de411791f
mlflow.runName	trial-123	86e01e0667ec427599d0c10de411791f
mlflow.user	eduar	982fe4200d6b4f95a5e5e436b1885c0b
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	982fe4200d6b4f95a5e5e436b1885c0b
mlflow.source.type	LOCAL	982fe4200d6b4f95a5e5e436b1885c0b
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	982fe4200d6b4f95a5e5e436b1885c0b
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	982fe4200d6b4f95a5e5e436b1885c0b
mlflow.runName	trial-124	982fe4200d6b4f95a5e5e436b1885c0b
mlflow.user	eduar	ea474e0674fd492c81f549be6c166cd2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	ea474e0674fd492c81f549be6c166cd2
mlflow.source.type	LOCAL	ea474e0674fd492c81f549be6c166cd2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	ea474e0674fd492c81f549be6c166cd2
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	ea474e0674fd492c81f549be6c166cd2
mlflow.runName	trial-125	ea474e0674fd492c81f549be6c166cd2
mlflow.user	eduar	6e7d042ef55247409d9390031ff02a47
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	6e7d042ef55247409d9390031ff02a47
mlflow.source.type	LOCAL	6e7d042ef55247409d9390031ff02a47
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	6e7d042ef55247409d9390031ff02a47
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	6e7d042ef55247409d9390031ff02a47
mlflow.runName	trial-126	6e7d042ef55247409d9390031ff02a47
mlflow.user	eduar	caa44697e4d24e98b6d5f91363319ce0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	caa44697e4d24e98b6d5f91363319ce0
mlflow.source.type	LOCAL	caa44697e4d24e98b6d5f91363319ce0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	caa44697e4d24e98b6d5f91363319ce0
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	caa44697e4d24e98b6d5f91363319ce0
mlflow.runName	trial-127	caa44697e4d24e98b6d5f91363319ce0
mlflow.user	eduar	09141ce7bff34a53b91aedc1c71e0d1c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	09141ce7bff34a53b91aedc1c71e0d1c
mlflow.source.type	LOCAL	09141ce7bff34a53b91aedc1c71e0d1c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	09141ce7bff34a53b91aedc1c71e0d1c
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	09141ce7bff34a53b91aedc1c71e0d1c
mlflow.runName	trial-128	09141ce7bff34a53b91aedc1c71e0d1c
mlflow.user	eduar	c1dbce29b41c445ba8138ce9811b0068
mlflow.user	eduar	079ff97d445546cbb52ed19b2d617517
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c1dbce29b41c445ba8138ce9811b0068
mlflow.source.type	LOCAL	c1dbce29b41c445ba8138ce9811b0068
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c1dbce29b41c445ba8138ce9811b0068
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c1dbce29b41c445ba8138ce9811b0068
mlflow.runName	trial-129	c1dbce29b41c445ba8138ce9811b0068
mlflow.user	eduar	20e40ce2d6c44003bb759ab6e1351170
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	20e40ce2d6c44003bb759ab6e1351170
mlflow.source.type	LOCAL	20e40ce2d6c44003bb759ab6e1351170
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	20e40ce2d6c44003bb759ab6e1351170
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	20e40ce2d6c44003bb759ab6e1351170
mlflow.runName	trial-130	20e40ce2d6c44003bb759ab6e1351170
mlflow.user	eduar	8dd5e097c3e7404b8bb68ce4d54c81da
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8dd5e097c3e7404b8bb68ce4d54c81da
mlflow.source.type	LOCAL	8dd5e097c3e7404b8bb68ce4d54c81da
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8dd5e097c3e7404b8bb68ce4d54c81da
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	8dd5e097c3e7404b8bb68ce4d54c81da
mlflow.runName	trial-134	8dd5e097c3e7404b8bb68ce4d54c81da
mlflow.user	eduar	5dfe43d07bae4c3e8be8f52e18ee4e21
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5dfe43d07bae4c3e8be8f52e18ee4e21
mlflow.source.type	LOCAL	5dfe43d07bae4c3e8be8f52e18ee4e21
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5dfe43d07bae4c3e8be8f52e18ee4e21
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	5dfe43d07bae4c3e8be8f52e18ee4e21
mlflow.runName	trial-135	5dfe43d07bae4c3e8be8f52e18ee4e21
mlflow.user	eduar	0a433fa3378a4b90b664cc4fde90ed21
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0a433fa3378a4b90b664cc4fde90ed21
mlflow.source.type	LOCAL	0a433fa3378a4b90b664cc4fde90ed21
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0a433fa3378a4b90b664cc4fde90ed21
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	0a433fa3378a4b90b664cc4fde90ed21
mlflow.runName	trial-76	0a433fa3378a4b90b664cc4fde90ed21
mlflow.user	eduar	196f279c8b2a47a3ae0b5e4069634bfe
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	196f279c8b2a47a3ae0b5e4069634bfe
mlflow.source.type	LOCAL	196f279c8b2a47a3ae0b5e4069634bfe
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	196f279c8b2a47a3ae0b5e4069634bfe
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	196f279c8b2a47a3ae0b5e4069634bfe
mlflow.runName	trial-87	196f279c8b2a47a3ae0b5e4069634bfe
mlflow.user	eduar	0e6ba24868c9455f9324ff11fa6f37c0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0e6ba24868c9455f9324ff11fa6f37c0
mlflow.source.type	LOCAL	0e6ba24868c9455f9324ff11fa6f37c0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0e6ba24868c9455f9324ff11fa6f37c0
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	0e6ba24868c9455f9324ff11fa6f37c0
mlflow.runName	trial-90	0e6ba24868c9455f9324ff11fa6f37c0
mlflow.user	eduar	b7a96024f405468da0046f142f3fba28
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b7a96024f405468da0046f142f3fba28
mlflow.source.type	LOCAL	b7a96024f405468da0046f142f3fba28
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b7a96024f405468da0046f142f3fba28
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	b7a96024f405468da0046f142f3fba28
mlflow.runName	trial-93	b7a96024f405468da0046f142f3fba28
mlflow.user	eduar	cc82112ae9004ab48a54576c09abb51e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	cc82112ae9004ab48a54576c09abb51e
mlflow.source.type	LOCAL	cc82112ae9004ab48a54576c09abb51e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	cc82112ae9004ab48a54576c09abb51e
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	cc82112ae9004ab48a54576c09abb51e
mlflow.runName	trial-94	cc82112ae9004ab48a54576c09abb51e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	079ff97d445546cbb52ed19b2d617517
mlflow.source.type	LOCAL	079ff97d445546cbb52ed19b2d617517
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	079ff97d445546cbb52ed19b2d617517
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	079ff97d445546cbb52ed19b2d617517
mlflow.runName	trial-131	079ff97d445546cbb52ed19b2d617517
mlflow.user	eduar	bf5751b68e994a81998944e44b1b573d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	bf5751b68e994a81998944e44b1b573d
mlflow.source.type	LOCAL	bf5751b68e994a81998944e44b1b573d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	bf5751b68e994a81998944e44b1b573d
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	bf5751b68e994a81998944e44b1b573d
mlflow.runName	trial-137	bf5751b68e994a81998944e44b1b573d
mlflow.user	eduar	5731165fd9d341c093634c24885b4b80
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5731165fd9d341c093634c24885b4b80
mlflow.source.type	LOCAL	5731165fd9d341c093634c24885b4b80
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5731165fd9d341c093634c24885b4b80
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	5731165fd9d341c093634c24885b4b80
mlflow.runName	trial-77	5731165fd9d341c093634c24885b4b80
mlflow.user	eduar	91fb3e7556b448e794bc7f57497b4ac4
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	91fb3e7556b448e794bc7f57497b4ac4
mlflow.source.type	LOCAL	91fb3e7556b448e794bc7f57497b4ac4
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	91fb3e7556b448e794bc7f57497b4ac4
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	91fb3e7556b448e794bc7f57497b4ac4
mlflow.runName	trial-97	91fb3e7556b448e794bc7f57497b4ac4
mlflow.user	eduar	a8008dd2ea1b43f196f1024d66cd3866
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a8008dd2ea1b43f196f1024d66cd3866
mlflow.source.type	LOCAL	a8008dd2ea1b43f196f1024d66cd3866
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a8008dd2ea1b43f196f1024d66cd3866
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	a8008dd2ea1b43f196f1024d66cd3866
mlflow.runName	trial-132	a8008dd2ea1b43f196f1024d66cd3866
mlflow.user	eduar	ed12fbe584314822bdbf2b28e61fd9f4
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	ed12fbe584314822bdbf2b28e61fd9f4
mlflow.source.type	LOCAL	ed12fbe584314822bdbf2b28e61fd9f4
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	ed12fbe584314822bdbf2b28e61fd9f4
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	ed12fbe584314822bdbf2b28e61fd9f4
mlflow.runName	trial-133	ed12fbe584314822bdbf2b28e61fd9f4
mlflow.user	eduar	5e4c9e7de52d47a391919bb68173e02c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5e4c9e7de52d47a391919bb68173e02c
mlflow.source.type	LOCAL	5e4c9e7de52d47a391919bb68173e02c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5e4c9e7de52d47a391919bb68173e02c
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	5e4c9e7de52d47a391919bb68173e02c
mlflow.runName	trial-139	5e4c9e7de52d47a391919bb68173e02c
mlflow.user	eduar	6fd1e2f0387c42e6bc1b573547aa39c7
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	6fd1e2f0387c42e6bc1b573547aa39c7
mlflow.source.type	LOCAL	6fd1e2f0387c42e6bc1b573547aa39c7
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	6fd1e2f0387c42e6bc1b573547aa39c7
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	6fd1e2f0387c42e6bc1b573547aa39c7
mlflow.runName	trial-78	6fd1e2f0387c42e6bc1b573547aa39c7
mlflow.user	eduar	af4fa3186c554df8bd52d00efdd3b518
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	af4fa3186c554df8bd52d00efdd3b518
mlflow.source.type	LOCAL	af4fa3186c554df8bd52d00efdd3b518
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	af4fa3186c554df8bd52d00efdd3b518
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	af4fa3186c554df8bd52d00efdd3b518
mlflow.runName	trial-89	af4fa3186c554df8bd52d00efdd3b518
mlflow.user	eduar	e6f37d31a9df48adbf7ce400630985f2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e6f37d31a9df48adbf7ce400630985f2
mlflow.source.type	LOCAL	e6f37d31a9df48adbf7ce400630985f2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e6f37d31a9df48adbf7ce400630985f2
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	e6f37d31a9df48adbf7ce400630985f2
mlflow.runName	trial-91	e6f37d31a9df48adbf7ce400630985f2
mlflow.user	eduar	28adcc19e5354574966fd00385b49f1a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	28adcc19e5354574966fd00385b49f1a
mlflow.source.type	LOCAL	28adcc19e5354574966fd00385b49f1a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	28adcc19e5354574966fd00385b49f1a
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	28adcc19e5354574966fd00385b49f1a
mlflow.runName	trial-98	28adcc19e5354574966fd00385b49f1a
mlflow.user	eduar	fd79d84e5b9a463e8c5d9ad2eebe966f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	fd79d84e5b9a463e8c5d9ad2eebe966f
mlflow.source.type	LOCAL	fd79d84e5b9a463e8c5d9ad2eebe966f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	fd79d84e5b9a463e8c5d9ad2eebe966f
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	fd79d84e5b9a463e8c5d9ad2eebe966f
mlflow.runName	trial-99	fd79d84e5b9a463e8c5d9ad2eebe966f
mlflow.user	eduar	bd4a6462eb314b5cb3c57f9db508a4e4
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	bd4a6462eb314b5cb3c57f9db508a4e4
mlflow.source.type	LOCAL	bd4a6462eb314b5cb3c57f9db508a4e4
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	bd4a6462eb314b5cb3c57f9db508a4e4
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	bd4a6462eb314b5cb3c57f9db508a4e4
mlflow.runName	trial-100	bd4a6462eb314b5cb3c57f9db508a4e4
mlflow.user	eduar	373663ce084a43b8bfb50018919a65db
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	373663ce084a43b8bfb50018919a65db
mlflow.source.type	LOCAL	373663ce084a43b8bfb50018919a65db
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	373663ce084a43b8bfb50018919a65db
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	373663ce084a43b8bfb50018919a65db
mlflow.runName	trial-136	373663ce084a43b8bfb50018919a65db
mlflow.user	eduar	8c20356faa924d4fb9eba650a0792cc3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8c20356faa924d4fb9eba650a0792cc3
mlflow.source.type	LOCAL	8c20356faa924d4fb9eba650a0792cc3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8c20356faa924d4fb9eba650a0792cc3
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	8c20356faa924d4fb9eba650a0792cc3
mlflow.runName	trial-138	8c20356faa924d4fb9eba650a0792cc3
mlflow.user	eduar	729adea5b08d4ad4a4653e52efbafee9
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	729adea5b08d4ad4a4653e52efbafee9
mlflow.source.type	LOCAL	729adea5b08d4ad4a4653e52efbafee9
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	729adea5b08d4ad4a4653e52efbafee9
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	729adea5b08d4ad4a4653e52efbafee9
mlflow.runName	trial-141	729adea5b08d4ad4a4653e52efbafee9
mlflow.user	eduar	3405dcc6ebdd44609d0d260aa28f3122
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3405dcc6ebdd44609d0d260aa28f3122
mlflow.source.type	LOCAL	3405dcc6ebdd44609d0d260aa28f3122
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3405dcc6ebdd44609d0d260aa28f3122
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	3405dcc6ebdd44609d0d260aa28f3122
mlflow.runName	trial-101	3405dcc6ebdd44609d0d260aa28f3122
mlflow.user	eduar	117e0e60760d44ac9ef154cceb212171
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	117e0e60760d44ac9ef154cceb212171
mlflow.source.type	LOCAL	117e0e60760d44ac9ef154cceb212171
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	117e0e60760d44ac9ef154cceb212171
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	117e0e60760d44ac9ef154cceb212171
mlflow.runName	trial-109	117e0e60760d44ac9ef154cceb212171
mlflow.user	eduar	569e3af54f5549d389c2817c8ccf9823
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	569e3af54f5549d389c2817c8ccf9823
mlflow.source.type	LOCAL	569e3af54f5549d389c2817c8ccf9823
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	569e3af54f5549d389c2817c8ccf9823
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	569e3af54f5549d389c2817c8ccf9823
mlflow.runName	trial-121	569e3af54f5549d389c2817c8ccf9823
mlflow.user	eduar	f0d12270c17441cb82afdc0ff9f70809
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	f0d12270c17441cb82afdc0ff9f70809
mlflow.source.type	LOCAL	f0d12270c17441cb82afdc0ff9f70809
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	f0d12270c17441cb82afdc0ff9f70809
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	f0d12270c17441cb82afdc0ff9f70809
mlflow.runName	trial-122	f0d12270c17441cb82afdc0ff9f70809
mlflow.user	eduar	19c7ae8c940042a9bea5484d5c7a996f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	19c7ae8c940042a9bea5484d5c7a996f
mlflow.source.type	LOCAL	19c7ae8c940042a9bea5484d5c7a996f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	19c7ae8c940042a9bea5484d5c7a996f
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	19c7ae8c940042a9bea5484d5c7a996f
mlflow.runName	trial-132	19c7ae8c940042a9bea5484d5c7a996f
mlflow.user	eduar	81cc585288d144dbaed1346c79c254ca
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	81cc585288d144dbaed1346c79c254ca
mlflow.source.type	LOCAL	81cc585288d144dbaed1346c79c254ca
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	81cc585288d144dbaed1346c79c254ca
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	81cc585288d144dbaed1346c79c254ca
mlflow.runName	trial-140	81cc585288d144dbaed1346c79c254ca
mlflow.user	eduar	aea8d7c689ae4b289a07ea312f8cd967
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	aea8d7c689ae4b289a07ea312f8cd967
mlflow.source.type	LOCAL	aea8d7c689ae4b289a07ea312f8cd967
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	aea8d7c689ae4b289a07ea312f8cd967
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	aea8d7c689ae4b289a07ea312f8cd967
mlflow.runName	trial-142	aea8d7c689ae4b289a07ea312f8cd967
mlflow.user	eduar	c3c64461db474abfb41a7918f0836f40
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c3c64461db474abfb41a7918f0836f40
mlflow.source.type	LOCAL	c3c64461db474abfb41a7918f0836f40
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c3c64461db474abfb41a7918f0836f40
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	c3c64461db474abfb41a7918f0836f40
mlflow.runName	trial-143	c3c64461db474abfb41a7918f0836f40
mlflow.user	eduar	52134bc6efa44da38234f805e719543d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	52134bc6efa44da38234f805e719543d
mlflow.source.type	LOCAL	52134bc6efa44da38234f805e719543d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	52134bc6efa44da38234f805e719543d
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	52134bc6efa44da38234f805e719543d
mlflow.runName	trial-144	52134bc6efa44da38234f805e719543d
mlflow.user	eduar	7263fee2dbbf4c2c8d21f11ee7cfb4d5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7263fee2dbbf4c2c8d21f11ee7cfb4d5
mlflow.source.type	LOCAL	7263fee2dbbf4c2c8d21f11ee7cfb4d5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7263fee2dbbf4c2c8d21f11ee7cfb4d5
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	7263fee2dbbf4c2c8d21f11ee7cfb4d5
mlflow.runName	trial-145	7263fee2dbbf4c2c8d21f11ee7cfb4d5
mlflow.user	eduar	858e7d66bbc44d07b4318652fe66bf8a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	858e7d66bbc44d07b4318652fe66bf8a
mlflow.source.type	LOCAL	858e7d66bbc44d07b4318652fe66bf8a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	858e7d66bbc44d07b4318652fe66bf8a
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	858e7d66bbc44d07b4318652fe66bf8a
mlflow.runName	trial-146	858e7d66bbc44d07b4318652fe66bf8a
mlflow.user	eduar	b93a661f89624444924de260e56e2235
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b93a661f89624444924de260e56e2235
mlflow.source.type	LOCAL	b93a661f89624444924de260e56e2235
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b93a661f89624444924de260e56e2235
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	b93a661f89624444924de260e56e2235
mlflow.runName	trial-147	b93a661f89624444924de260e56e2235
mlflow.user	eduar	b3a13dff7789467091ec52640e9adc99
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b3a13dff7789467091ec52640e9adc99
mlflow.source.type	LOCAL	b3a13dff7789467091ec52640e9adc99
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b3a13dff7789467091ec52640e9adc99
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	b3a13dff7789467091ec52640e9adc99
mlflow.runName	trial-148	b3a13dff7789467091ec52640e9adc99
mlflow.user	eduar	aaa258948ae9488bb474a158d63f9148
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	aaa258948ae9488bb474a158d63f9148
mlflow.source.type	LOCAL	aaa258948ae9488bb474a158d63f9148
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	aaa258948ae9488bb474a158d63f9148
mlflow.parentRunId	5cfc620daab64d35912dd7df3c7d139d	aaa258948ae9488bb474a158d63f9148
mlflow.runName	trial-149	aaa258948ae9488bb474a158d63f9148
mlflow.user	eduar	f63cff703fe14c219fa8ae960e639722
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	f63cff703fe14c219fa8ae960e639722
mlflow.source.type	LOCAL	f63cff703fe14c219fa8ae960e639722
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	f63cff703fe14c219fa8ae960e639722
mlflow.runName	champion-model	f63cff703fe14c219fa8ae960e639722
stage	production	f63cff703fe14c219fa8ae960e639722
model_role	champion	f63cff703fe14c219fa8ae960e639722
mlflow.user	eduar	a1238f4eb0434cd690f334476cb2ad9c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a1238f4eb0434cd690f334476cb2ad9c
mlflow.source.type	LOCAL	a1238f4eb0434cd690f334476cb2ad9c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a1238f4eb0434cd690f334476cb2ad9c
mlflow.runName	champion-model	a1238f4eb0434cd690f334476cb2ad9c
stage	production	a1238f4eb0434cd690f334476cb2ad9c
model_role	champion	a1238f4eb0434cd690f334476cb2ad9c
mlflow.user	eduar	1858617a3b064a73a5af67ad947b5cdf
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	1858617a3b064a73a5af67ad947b5cdf
mlflow.source.type	LOCAL	1858617a3b064a73a5af67ad947b5cdf
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	1858617a3b064a73a5af67ad947b5cdf
mlflow.autologging	lightgbm	1858617a3b064a73a5af67ad947b5cdf
mlflow.runName	gifted-trout-680	1858617a3b064a73a5af67ad947b5cdf
mlflow.user	eduar	cceff74de09a44f48ae9e027c5f35536
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	cceff74de09a44f48ae9e027c5f35536
mlflow.source.type	LOCAL	cceff74de09a44f48ae9e027c5f35536
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	cceff74de09a44f48ae9e027c5f35536
mlflow.runName	optuna-search	cceff74de09a44f48ae9e027c5f35536
mlflow.user	eduar	2cb17c9ab3fb42f6a309da1001231d6f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2cb17c9ab3fb42f6a309da1001231d6f
mlflow.source.type	LOCAL	2cb17c9ab3fb42f6a309da1001231d6f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2cb17c9ab3fb42f6a309da1001231d6f
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2cb17c9ab3fb42f6a309da1001231d6f
mlflow.runName	trial-0	2cb17c9ab3fb42f6a309da1001231d6f
mlflow.user	eduar	ee5e81cfc9ad4fda8222a171057e4ffc
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	ee5e81cfc9ad4fda8222a171057e4ffc
mlflow.source.type	LOCAL	ee5e81cfc9ad4fda8222a171057e4ffc
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	ee5e81cfc9ad4fda8222a171057e4ffc
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	ee5e81cfc9ad4fda8222a171057e4ffc
mlflow.runName	trial-102	ee5e81cfc9ad4fda8222a171057e4ffc
mlflow.user	eduar	c599cc0f5ca645e989b7478887d03f28
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c599cc0f5ca645e989b7478887d03f28
mlflow.source.type	LOCAL	c599cc0f5ca645e989b7478887d03f28
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c599cc0f5ca645e989b7478887d03f28
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	c599cc0f5ca645e989b7478887d03f28
mlflow.runName	trial-104	c599cc0f5ca645e989b7478887d03f28
mlflow.user	eduar	2ad9ddee054f4a0fa0c5e251a177dd6a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2ad9ddee054f4a0fa0c5e251a177dd6a
mlflow.source.type	LOCAL	2ad9ddee054f4a0fa0c5e251a177dd6a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2ad9ddee054f4a0fa0c5e251a177dd6a
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2ad9ddee054f4a0fa0c5e251a177dd6a
mlflow.runName	trial-108	2ad9ddee054f4a0fa0c5e251a177dd6a
mlflow.user	eduar	62ca7fadf67347b29ca9598d327eebd2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	62ca7fadf67347b29ca9598d327eebd2
mlflow.source.type	LOCAL	62ca7fadf67347b29ca9598d327eebd2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	62ca7fadf67347b29ca9598d327eebd2
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	62ca7fadf67347b29ca9598d327eebd2
mlflow.runName	trial-110	62ca7fadf67347b29ca9598d327eebd2
mlflow.user	eduar	8d81437cc3714f6982ae885c3c81bacf
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	8d81437cc3714f6982ae885c3c81bacf
mlflow.source.type	LOCAL	8d81437cc3714f6982ae885c3c81bacf
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	8d81437cc3714f6982ae885c3c81bacf
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	8d81437cc3714f6982ae885c3c81bacf
mlflow.runName	trial-116	8d81437cc3714f6982ae885c3c81bacf
mlflow.user	eduar	2d0fdb5b0ebe4654b38066951cec3ae8
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2d0fdb5b0ebe4654b38066951cec3ae8
mlflow.source.type	LOCAL	2d0fdb5b0ebe4654b38066951cec3ae8
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2d0fdb5b0ebe4654b38066951cec3ae8
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2d0fdb5b0ebe4654b38066951cec3ae8
mlflow.runName	trial-126	2d0fdb5b0ebe4654b38066951cec3ae8
mlflow.user	eduar	343a984aca99424a9ea4fde70eae7fd6
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	343a984aca99424a9ea4fde70eae7fd6
mlflow.source.type	LOCAL	343a984aca99424a9ea4fde70eae7fd6
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	343a984aca99424a9ea4fde70eae7fd6
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	343a984aca99424a9ea4fde70eae7fd6
mlflow.runName	trial-1	343a984aca99424a9ea4fde70eae7fd6
mlflow.user	eduar	37b22dee0c674dc0ae4c25e6ee9d21d1
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	37b22dee0c674dc0ae4c25e6ee9d21d1
mlflow.source.type	LOCAL	37b22dee0c674dc0ae4c25e6ee9d21d1
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	37b22dee0c674dc0ae4c25e6ee9d21d1
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	37b22dee0c674dc0ae4c25e6ee9d21d1
mlflow.runName	trial-8	37b22dee0c674dc0ae4c25e6ee9d21d1
mlflow.user	eduar	cca09d0a7a824be1b885d47ad28e10a4
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	cca09d0a7a824be1b885d47ad28e10a4
mlflow.source.type	LOCAL	cca09d0a7a824be1b885d47ad28e10a4
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	cca09d0a7a824be1b885d47ad28e10a4
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	cca09d0a7a824be1b885d47ad28e10a4
mlflow.runName	trial-103	cca09d0a7a824be1b885d47ad28e10a4
mlflow.user	eduar	cd47568195194bd4b3b7f694f1a08f9a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	cd47568195194bd4b3b7f694f1a08f9a
mlflow.source.type	LOCAL	cd47568195194bd4b3b7f694f1a08f9a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	cd47568195194bd4b3b7f694f1a08f9a
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	cd47568195194bd4b3b7f694f1a08f9a
mlflow.runName	trial-113	cd47568195194bd4b3b7f694f1a08f9a
mlflow.user	eduar	30bde976c0b84a36b835f3d18848103c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	30bde976c0b84a36b835f3d18848103c
mlflow.source.type	LOCAL	30bde976c0b84a36b835f3d18848103c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	30bde976c0b84a36b835f3d18848103c
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	30bde976c0b84a36b835f3d18848103c
mlflow.runName	trial-114	30bde976c0b84a36b835f3d18848103c
mlflow.user	eduar	200e44c932ce4dad8671cd5da9b409d9
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	200e44c932ce4dad8671cd5da9b409d9
mlflow.source.type	LOCAL	200e44c932ce4dad8671cd5da9b409d9
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	200e44c932ce4dad8671cd5da9b409d9
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	200e44c932ce4dad8671cd5da9b409d9
mlflow.runName	trial-115	200e44c932ce4dad8671cd5da9b409d9
mlflow.user	eduar	d3f4b439155d4a1f8452de974a8fd530
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d3f4b439155d4a1f8452de974a8fd530
mlflow.source.type	LOCAL	d3f4b439155d4a1f8452de974a8fd530
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d3f4b439155d4a1f8452de974a8fd530
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	d3f4b439155d4a1f8452de974a8fd530
mlflow.runName	trial-125	d3f4b439155d4a1f8452de974a8fd530
mlflow.user	eduar	11b06d8ded174450aaa0563cd01e2137
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	11b06d8ded174450aaa0563cd01e2137
mlflow.source.type	LOCAL	11b06d8ded174450aaa0563cd01e2137
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	11b06d8ded174450aaa0563cd01e2137
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	11b06d8ded174450aaa0563cd01e2137
mlflow.runName	trial-129	11b06d8ded174450aaa0563cd01e2137
mlflow.user	eduar	c23e0bcb7b334d3aae37f42aa4aaa09d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c23e0bcb7b334d3aae37f42aa4aaa09d
mlflow.source.type	LOCAL	c23e0bcb7b334d3aae37f42aa4aaa09d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c23e0bcb7b334d3aae37f42aa4aaa09d
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	c23e0bcb7b334d3aae37f42aa4aaa09d
mlflow.runName	trial-135	c23e0bcb7b334d3aae37f42aa4aaa09d
mlflow.user	eduar	fe50acdbb80f44b3b833e6da5d8494d5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	fe50acdbb80f44b3b833e6da5d8494d5
mlflow.source.type	LOCAL	fe50acdbb80f44b3b833e6da5d8494d5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	fe50acdbb80f44b3b833e6da5d8494d5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	fe50acdbb80f44b3b833e6da5d8494d5
mlflow.runName	trial-2	fe50acdbb80f44b3b833e6da5d8494d5
mlflow.user	eduar	639bd817783446149d47dfcd0926f1a0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	639bd817783446149d47dfcd0926f1a0
mlflow.source.type	LOCAL	639bd817783446149d47dfcd0926f1a0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	639bd817783446149d47dfcd0926f1a0
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	639bd817783446149d47dfcd0926f1a0
mlflow.runName	trial-3	639bd817783446149d47dfcd0926f1a0
mlflow.user	eduar	3d117da059cf48f1b0389bf9323ce232
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3d117da059cf48f1b0389bf9323ce232
mlflow.source.type	LOCAL	3d117da059cf48f1b0389bf9323ce232
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3d117da059cf48f1b0389bf9323ce232
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	3d117da059cf48f1b0389bf9323ce232
mlflow.runName	trial-6	3d117da059cf48f1b0389bf9323ce232
mlflow.user	eduar	5b7ac14d710141e0ae9db4df5d76863d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5b7ac14d710141e0ae9db4df5d76863d
mlflow.source.type	LOCAL	5b7ac14d710141e0ae9db4df5d76863d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5b7ac14d710141e0ae9db4df5d76863d
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	5b7ac14d710141e0ae9db4df5d76863d
mlflow.runName	trial-9	5b7ac14d710141e0ae9db4df5d76863d
mlflow.user	eduar	e5c01080e79f4145ae6c1fbbeb6dab7f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e5c01080e79f4145ae6c1fbbeb6dab7f
mlflow.source.type	LOCAL	e5c01080e79f4145ae6c1fbbeb6dab7f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e5c01080e79f4145ae6c1fbbeb6dab7f
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	e5c01080e79f4145ae6c1fbbeb6dab7f
mlflow.runName	trial-10	e5c01080e79f4145ae6c1fbbeb6dab7f
mlflow.user	eduar	db19dbd296a547468d99e1eac5c48d91
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	db19dbd296a547468d99e1eac5c48d91
mlflow.source.type	LOCAL	db19dbd296a547468d99e1eac5c48d91
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	db19dbd296a547468d99e1eac5c48d91
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	db19dbd296a547468d99e1eac5c48d91
mlflow.runName	trial-11	db19dbd296a547468d99e1eac5c48d91
mlflow.user	eduar	de0278a9f23d4eea946bc673a797c3c2
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	de0278a9f23d4eea946bc673a797c3c2
mlflow.source.type	LOCAL	de0278a9f23d4eea946bc673a797c3c2
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	de0278a9f23d4eea946bc673a797c3c2
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	de0278a9f23d4eea946bc673a797c3c2
mlflow.runName	trial-105	de0278a9f23d4eea946bc673a797c3c2
mlflow.user	eduar	ba4d5a30aa02426d9e1536625f3ebe6a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	ba4d5a30aa02426d9e1536625f3ebe6a
mlflow.source.type	LOCAL	ba4d5a30aa02426d9e1536625f3ebe6a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	ba4d5a30aa02426d9e1536625f3ebe6a
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	ba4d5a30aa02426d9e1536625f3ebe6a
mlflow.runName	trial-111	ba4d5a30aa02426d9e1536625f3ebe6a
mlflow.user	eduar	98d0deba9dd641d281274cbf802081fb
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	98d0deba9dd641d281274cbf802081fb
mlflow.source.type	LOCAL	98d0deba9dd641d281274cbf802081fb
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	98d0deba9dd641d281274cbf802081fb
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	98d0deba9dd641d281274cbf802081fb
mlflow.runName	trial-112	98d0deba9dd641d281274cbf802081fb
mlflow.user	eduar	3e09014e17a84af3b1624fa0068fa0a7
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	3e09014e17a84af3b1624fa0068fa0a7
mlflow.source.type	LOCAL	3e09014e17a84af3b1624fa0068fa0a7
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	3e09014e17a84af3b1624fa0068fa0a7
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	3e09014e17a84af3b1624fa0068fa0a7
mlflow.runName	trial-117	3e09014e17a84af3b1624fa0068fa0a7
mlflow.user	eduar	b4689faec3f7445fbe0ba427b0859231
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b4689faec3f7445fbe0ba427b0859231
mlflow.source.type	LOCAL	b4689faec3f7445fbe0ba427b0859231
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b4689faec3f7445fbe0ba427b0859231
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	b4689faec3f7445fbe0ba427b0859231
mlflow.runName	trial-118	b4689faec3f7445fbe0ba427b0859231
mlflow.user	eduar	2dd58258a1c14b7e9fbbcf0a30084f7d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2dd58258a1c14b7e9fbbcf0a30084f7d
mlflow.source.type	LOCAL	2dd58258a1c14b7e9fbbcf0a30084f7d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2dd58258a1c14b7e9fbbcf0a30084f7d
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2dd58258a1c14b7e9fbbcf0a30084f7d
mlflow.runName	trial-4	2dd58258a1c14b7e9fbbcf0a30084f7d
mlflow.user	eduar	130f444dde0c42df9f6abc1bd79d9b77
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	130f444dde0c42df9f6abc1bd79d9b77
mlflow.source.type	LOCAL	130f444dde0c42df9f6abc1bd79d9b77
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	130f444dde0c42df9f6abc1bd79d9b77
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	130f444dde0c42df9f6abc1bd79d9b77
mlflow.runName	trial-106	130f444dde0c42df9f6abc1bd79d9b77
mlflow.user	eduar	aa9da8551d8a425785523304e9c547f3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	aa9da8551d8a425785523304e9c547f3
mlflow.source.type	LOCAL	aa9da8551d8a425785523304e9c547f3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	aa9da8551d8a425785523304e9c547f3
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	aa9da8551d8a425785523304e9c547f3
mlflow.runName	trial-119	aa9da8551d8a425785523304e9c547f3
mlflow.user	eduar	b6ad1bd3b5e24e56a38c6e514a836fbb
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b6ad1bd3b5e24e56a38c6e514a836fbb
mlflow.source.type	LOCAL	b6ad1bd3b5e24e56a38c6e514a836fbb
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b6ad1bd3b5e24e56a38c6e514a836fbb
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	b6ad1bd3b5e24e56a38c6e514a836fbb
mlflow.runName	trial-5	b6ad1bd3b5e24e56a38c6e514a836fbb
mlflow.user	eduar	e3ca2557a9f543f7952783569ae86534
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e3ca2557a9f543f7952783569ae86534
mlflow.source.type	LOCAL	e3ca2557a9f543f7952783569ae86534
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e3ca2557a9f543f7952783569ae86534
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	e3ca2557a9f543f7952783569ae86534
mlflow.runName	trial-107	e3ca2557a9f543f7952783569ae86534
mlflow.user	eduar	2e7a3710bd5e4ee2ad9d870e16e43be0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2e7a3710bd5e4ee2ad9d870e16e43be0
mlflow.source.type	LOCAL	2e7a3710bd5e4ee2ad9d870e16e43be0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2e7a3710bd5e4ee2ad9d870e16e43be0
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2e7a3710bd5e4ee2ad9d870e16e43be0
mlflow.runName	trial-124	2e7a3710bd5e4ee2ad9d870e16e43be0
mlflow.user	eduar	571b8fa9bdad427a9816b5b5144622ef
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	571b8fa9bdad427a9816b5b5144622ef
mlflow.source.type	LOCAL	571b8fa9bdad427a9816b5b5144622ef
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	571b8fa9bdad427a9816b5b5144622ef
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	571b8fa9bdad427a9816b5b5144622ef
mlflow.runName	trial-128	571b8fa9bdad427a9816b5b5144622ef
mlflow.user	eduar	fea20651e3e744068c1d02e03e73f652
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	fea20651e3e744068c1d02e03e73f652
mlflow.source.type	LOCAL	fea20651e3e744068c1d02e03e73f652
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	fea20651e3e744068c1d02e03e73f652
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	fea20651e3e744068c1d02e03e73f652
mlflow.runName	trial-130	fea20651e3e744068c1d02e03e73f652
mlflow.user	eduar	35ea2431d44b4d5197234e1257f742e7
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	35ea2431d44b4d5197234e1257f742e7
mlflow.source.type	LOCAL	35ea2431d44b4d5197234e1257f742e7
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	35ea2431d44b4d5197234e1257f742e7
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	35ea2431d44b4d5197234e1257f742e7
mlflow.runName	trial-131	35ea2431d44b4d5197234e1257f742e7
mlflow.user	eduar	87f145f9b3b4496f901df95d56e470b8
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	87f145f9b3b4496f901df95d56e470b8
mlflow.source.type	LOCAL	87f145f9b3b4496f901df95d56e470b8
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	87f145f9b3b4496f901df95d56e470b8
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	87f145f9b3b4496f901df95d56e470b8
mlflow.runName	trial-134	87f145f9b3b4496f901df95d56e470b8
mlflow.user	eduar	175caae5af7f4140b4ecae075484bb7b
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	175caae5af7f4140b4ecae075484bb7b
mlflow.source.type	LOCAL	175caae5af7f4140b4ecae075484bb7b
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	175caae5af7f4140b4ecae075484bb7b
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	175caae5af7f4140b4ecae075484bb7b
mlflow.runName	trial-7	175caae5af7f4140b4ecae075484bb7b
mlflow.user	eduar	5ca501b4ad684b6d8ca4c0d74bc38d7d
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5ca501b4ad684b6d8ca4c0d74bc38d7d
mlflow.source.type	LOCAL	5ca501b4ad684b6d8ca4c0d74bc38d7d
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5ca501b4ad684b6d8ca4c0d74bc38d7d
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	5ca501b4ad684b6d8ca4c0d74bc38d7d
mlflow.runName	trial-12	5ca501b4ad684b6d8ca4c0d74bc38d7d
mlflow.user	eduar	920842c57a5a49bb87e14ce762de0e6f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	920842c57a5a49bb87e14ce762de0e6f
mlflow.source.type	LOCAL	920842c57a5a49bb87e14ce762de0e6f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	920842c57a5a49bb87e14ce762de0e6f
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	920842c57a5a49bb87e14ce762de0e6f
mlflow.runName	trial-13	920842c57a5a49bb87e14ce762de0e6f
mlflow.user	eduar	12c0eb897e9e4e799fa7e402ede53e68
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	12c0eb897e9e4e799fa7e402ede53e68
mlflow.source.type	LOCAL	12c0eb897e9e4e799fa7e402ede53e68
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	12c0eb897e9e4e799fa7e402ede53e68
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	12c0eb897e9e4e799fa7e402ede53e68
mlflow.runName	trial-14	12c0eb897e9e4e799fa7e402ede53e68
mlflow.user	eduar	464465db08d54ca3890683e7f08018cd
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	464465db08d54ca3890683e7f08018cd
mlflow.source.type	LOCAL	464465db08d54ca3890683e7f08018cd
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	464465db08d54ca3890683e7f08018cd
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	464465db08d54ca3890683e7f08018cd
mlflow.runName	trial-15	464465db08d54ca3890683e7f08018cd
mlflow.user	eduar	2719cadee66a4cddb04bd6047c0bdea1
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2719cadee66a4cddb04bd6047c0bdea1
mlflow.source.type	LOCAL	2719cadee66a4cddb04bd6047c0bdea1
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2719cadee66a4cddb04bd6047c0bdea1
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2719cadee66a4cddb04bd6047c0bdea1
mlflow.runName	trial-16	2719cadee66a4cddb04bd6047c0bdea1
mlflow.user	eduar	7da83a5b702d4cd9a3b6288e6ec4a963
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7da83a5b702d4cd9a3b6288e6ec4a963
mlflow.source.type	LOCAL	7da83a5b702d4cd9a3b6288e6ec4a963
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7da83a5b702d4cd9a3b6288e6ec4a963
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	7da83a5b702d4cd9a3b6288e6ec4a963
mlflow.runName	trial-17	7da83a5b702d4cd9a3b6288e6ec4a963
mlflow.user	eduar	dab10324d6874b25b032b2e41b538db5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	dab10324d6874b25b032b2e41b538db5
mlflow.source.type	LOCAL	dab10324d6874b25b032b2e41b538db5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	dab10324d6874b25b032b2e41b538db5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	dab10324d6874b25b032b2e41b538db5
mlflow.runName	trial-18	dab10324d6874b25b032b2e41b538db5
mlflow.user	eduar	0fa292059a01459388a9848f32021680
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	0fa292059a01459388a9848f32021680
mlflow.source.type	LOCAL	0fa292059a01459388a9848f32021680
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	0fa292059a01459388a9848f32021680
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	0fa292059a01459388a9848f32021680
mlflow.runName	trial-19	0fa292059a01459388a9848f32021680
mlflow.user	eduar	a88dec410f58417cb1ad18c7cb2485f3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	a88dec410f58417cb1ad18c7cb2485f3
mlflow.source.type	LOCAL	a88dec410f58417cb1ad18c7cb2485f3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	a88dec410f58417cb1ad18c7cb2485f3
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	a88dec410f58417cb1ad18c7cb2485f3
mlflow.runName	trial-20	a88dec410f58417cb1ad18c7cb2485f3
mlflow.user	eduar	57a6a6513f3d4a139635fb009beabe0e
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	57a6a6513f3d4a139635fb009beabe0e
mlflow.source.type	LOCAL	57a6a6513f3d4a139635fb009beabe0e
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	57a6a6513f3d4a139635fb009beabe0e
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	57a6a6513f3d4a139635fb009beabe0e
mlflow.runName	trial-21	57a6a6513f3d4a139635fb009beabe0e
mlflow.user	eduar	bdb2446748cb45d9b995eaf2595da298
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	bdb2446748cb45d9b995eaf2595da298
mlflow.source.type	LOCAL	bdb2446748cb45d9b995eaf2595da298
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	bdb2446748cb45d9b995eaf2595da298
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	bdb2446748cb45d9b995eaf2595da298
mlflow.runName	trial-22	bdb2446748cb45d9b995eaf2595da298
mlflow.user	eduar	52254688abc64f459641607d3a8dfb6a
mlflow.user	eduar	7d976b24c40b49f396e96bc3fb05fd94
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	52254688abc64f459641607d3a8dfb6a
mlflow.source.type	LOCAL	52254688abc64f459641607d3a8dfb6a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	52254688abc64f459641607d3a8dfb6a
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	52254688abc64f459641607d3a8dfb6a
mlflow.runName	trial-23	52254688abc64f459641607d3a8dfb6a
mlflow.user	eduar	d8b6ad6854ce4c91948c621ba3b09130
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d8b6ad6854ce4c91948c621ba3b09130
mlflow.source.type	LOCAL	d8b6ad6854ce4c91948c621ba3b09130
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d8b6ad6854ce4c91948c621ba3b09130
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	d8b6ad6854ce4c91948c621ba3b09130
mlflow.runName	trial-34	d8b6ad6854ce4c91948c621ba3b09130
mlflow.user	eduar	f9ede5de86ea4f9b8ac1a181ddd36d72
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	f9ede5de86ea4f9b8ac1a181ddd36d72
mlflow.source.type	LOCAL	f9ede5de86ea4f9b8ac1a181ddd36d72
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	f9ede5de86ea4f9b8ac1a181ddd36d72
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	f9ede5de86ea4f9b8ac1a181ddd36d72
mlflow.runName	trial-120	f9ede5de86ea4f9b8ac1a181ddd36d72
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	7d976b24c40b49f396e96bc3fb05fd94
mlflow.source.type	LOCAL	7d976b24c40b49f396e96bc3fb05fd94
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	7d976b24c40b49f396e96bc3fb05fd94
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	7d976b24c40b49f396e96bc3fb05fd94
mlflow.runName	trial-24	7d976b24c40b49f396e96bc3fb05fd94
mlflow.user	eduar	c30e3c7d28f94109946cce7fcb30cba5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c30e3c7d28f94109946cce7fcb30cba5
mlflow.source.type	LOCAL	c30e3c7d28f94109946cce7fcb30cba5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c30e3c7d28f94109946cce7fcb30cba5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	c30e3c7d28f94109946cce7fcb30cba5
mlflow.runName	trial-25	c30e3c7d28f94109946cce7fcb30cba5
mlflow.user	eduar	2bc4f68109344e3d8099ec77369d61d3
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2bc4f68109344e3d8099ec77369d61d3
mlflow.source.type	LOCAL	2bc4f68109344e3d8099ec77369d61d3
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2bc4f68109344e3d8099ec77369d61d3
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2bc4f68109344e3d8099ec77369d61d3
mlflow.runName	trial-30	2bc4f68109344e3d8099ec77369d61d3
mlflow.user	eduar	621e30a66f4f4f2c9e8e5d2e3d26b6f9
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	621e30a66f4f4f2c9e8e5d2e3d26b6f9
mlflow.source.type	LOCAL	621e30a66f4f4f2c9e8e5d2e3d26b6f9
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	621e30a66f4f4f2c9e8e5d2e3d26b6f9
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	621e30a66f4f4f2c9e8e5d2e3d26b6f9
mlflow.runName	trial-35	621e30a66f4f4f2c9e8e5d2e3d26b6f9
mlflow.user	eduar	b49827a8551c45039120e727c2742f3c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b49827a8551c45039120e727c2742f3c
mlflow.source.type	LOCAL	b49827a8551c45039120e727c2742f3c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b49827a8551c45039120e727c2742f3c
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	b49827a8551c45039120e727c2742f3c
mlflow.runName	trial-36	b49827a8551c45039120e727c2742f3c
mlflow.user	eduar	52e3ecc8bd264c6bb75dd7e13c9c3713
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	52e3ecc8bd264c6bb75dd7e13c9c3713
mlflow.source.type	LOCAL	52e3ecc8bd264c6bb75dd7e13c9c3713
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	52e3ecc8bd264c6bb75dd7e13c9c3713
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	52e3ecc8bd264c6bb75dd7e13c9c3713
mlflow.runName	trial-123	52e3ecc8bd264c6bb75dd7e13c9c3713
mlflow.user	eduar	d6ab3fd3b7be407a86383f867d0d3987
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	d6ab3fd3b7be407a86383f867d0d3987
mlflow.source.type	LOCAL	d6ab3fd3b7be407a86383f867d0d3987
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	d6ab3fd3b7be407a86383f867d0d3987
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	d6ab3fd3b7be407a86383f867d0d3987
mlflow.runName	trial-127	d6ab3fd3b7be407a86383f867d0d3987
mlflow.user	eduar	c2a98b6d06ba4b14ac81cdaaacee8d9b
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	c2a98b6d06ba4b14ac81cdaaacee8d9b
mlflow.source.type	LOCAL	c2a98b6d06ba4b14ac81cdaaacee8d9b
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	c2a98b6d06ba4b14ac81cdaaacee8d9b
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	c2a98b6d06ba4b14ac81cdaaacee8d9b
mlflow.runName	trial-133	c2a98b6d06ba4b14ac81cdaaacee8d9b
mlflow.user	eduar	f4eb85ac7f484c7b9665388a9a0d3e8f
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	f4eb85ac7f484c7b9665388a9a0d3e8f
mlflow.source.type	LOCAL	f4eb85ac7f484c7b9665388a9a0d3e8f
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	f4eb85ac7f484c7b9665388a9a0d3e8f
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	f4eb85ac7f484c7b9665388a9a0d3e8f
mlflow.runName	trial-136	f4eb85ac7f484c7b9665388a9a0d3e8f
mlflow.user	eduar	1bb7906f11194fa6b7498584acfcaac0
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	1bb7906f11194fa6b7498584acfcaac0
mlflow.source.type	LOCAL	1bb7906f11194fa6b7498584acfcaac0
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	1bb7906f11194fa6b7498584acfcaac0
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	1bb7906f11194fa6b7498584acfcaac0
mlflow.runName	trial-26	1bb7906f11194fa6b7498584acfcaac0
mlflow.user	eduar	350e32e8aae5456fb766e828852e52f8
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	350e32e8aae5456fb766e828852e52f8
mlflow.source.type	LOCAL	350e32e8aae5456fb766e828852e52f8
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	350e32e8aae5456fb766e828852e52f8
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	350e32e8aae5456fb766e828852e52f8
mlflow.runName	trial-27	350e32e8aae5456fb766e828852e52f8
mlflow.user	eduar	993859e43a124bfbba2b2ebb47441c36
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	993859e43a124bfbba2b2ebb47441c36
mlflow.source.type	LOCAL	993859e43a124bfbba2b2ebb47441c36
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	993859e43a124bfbba2b2ebb47441c36
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	993859e43a124bfbba2b2ebb47441c36
mlflow.runName	trial-31	993859e43a124bfbba2b2ebb47441c36
mlflow.user	eduar	b7b0e8f2158c4888aa058c14df7a1439
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	b7b0e8f2158c4888aa058c14df7a1439
mlflow.source.type	LOCAL	b7b0e8f2158c4888aa058c14df7a1439
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	b7b0e8f2158c4888aa058c14df7a1439
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	b7b0e8f2158c4888aa058c14df7a1439
mlflow.runName	trial-33	b7b0e8f2158c4888aa058c14df7a1439
mlflow.user	eduar	e9f2cf11fabd4422a3404f41f7e12593
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	e9f2cf11fabd4422a3404f41f7e12593
mlflow.source.type	LOCAL	e9f2cf11fabd4422a3404f41f7e12593
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	e9f2cf11fabd4422a3404f41f7e12593
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	e9f2cf11fabd4422a3404f41f7e12593
mlflow.runName	trial-137	e9f2cf11fabd4422a3404f41f7e12593
estimator_name	Pipeline	033ebefb766e4bfa8282ab39cec5c865
estimator_class	sklearn.pipeline.Pipeline	033ebefb766e4bfa8282ab39cec5c865
mlflow.user	eduar	5aa083ca632a4a3ba6f7762d0c339e85
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	5aa083ca632a4a3ba6f7762d0c339e85
mlflow.source.type	LOCAL	5aa083ca632a4a3ba6f7762d0c339e85
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	5aa083ca632a4a3ba6f7762d0c339e85
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	5aa083ca632a4a3ba6f7762d0c339e85
mlflow.runName	trial-28	5aa083ca632a4a3ba6f7762d0c339e85
mlflow.user	eduar	dfdba455d2f94583a9a6c822f573f830
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	dfdba455d2f94583a9a6c822f573f830
mlflow.source.type	LOCAL	dfdba455d2f94583a9a6c822f573f830
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	dfdba455d2f94583a9a6c822f573f830
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	dfdba455d2f94583a9a6c822f573f830
mlflow.runName	trial-29	dfdba455d2f94583a9a6c822f573f830
mlflow.user	eduar	2715b04b5bad4a7ca933580943a2814a
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	2715b04b5bad4a7ca933580943a2814a
mlflow.source.type	LOCAL	2715b04b5bad4a7ca933580943a2814a
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	2715b04b5bad4a7ca933580943a2814a
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	2715b04b5bad4a7ca933580943a2814a
mlflow.runName	trial-32	2715b04b5bad4a7ca933580943a2814a
mlflow.user	eduar	faefe080fefc45eabc2137abcdf3ef0c
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	faefe080fefc45eabc2137abcdf3ef0c
mlflow.source.type	LOCAL	faefe080fefc45eabc2137abcdf3ef0c
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	faefe080fefc45eabc2137abcdf3ef0c
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	faefe080fefc45eabc2137abcdf3ef0c
mlflow.runName	trial-138	faefe080fefc45eabc2137abcdf3ef0c
mlflow.user	eduar	9e379079e72747be9cc278ce97ad8b11
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	9e379079e72747be9cc278ce97ad8b11
mlflow.source.type	LOCAL	9e379079e72747be9cc278ce97ad8b11
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	9e379079e72747be9cc278ce97ad8b11
mlflow.autologging	lightgbm	9e379079e72747be9cc278ce97ad8b11
mlflow.runName	blushing-stag-187	9e379079e72747be9cc278ce97ad8b11
mlflow.user	eduar	be0003b4c09f45a384716a36faaa3fde
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	be0003b4c09f45a384716a36faaa3fde
mlflow.source.type	LOCAL	be0003b4c09f45a384716a36faaa3fde
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	be0003b4c09f45a384716a36faaa3fde
mlflow.runName	champion-model	be0003b4c09f45a384716a36faaa3fde
mlflow.user	eduar	95bce22e5e554d8298e264b28c9e8fc5
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	95bce22e5e554d8298e264b28c9e8fc5
mlflow.source.type	LOCAL	95bce22e5e554d8298e264b28c9e8fc5
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	95bce22e5e554d8298e264b28c9e8fc5
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	95bce22e5e554d8298e264b28c9e8fc5
mlflow.runName	trial-37	95bce22e5e554d8298e264b28c9e8fc5
mlflow.user	eduar	bc449f79816a40b389ab2d1898b1b8f4
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	bc449f79816a40b389ab2d1898b1b8f4
mlflow.source.type	LOCAL	bc449f79816a40b389ab2d1898b1b8f4
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	bc449f79816a40b389ab2d1898b1b8f4
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	bc449f79816a40b389ab2d1898b1b8f4
mlflow.runName	trial-38	bc449f79816a40b389ab2d1898b1b8f4
mlflow.user	eduar	96479ef023f34b15a8033d9c5657d9dc
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	96479ef023f34b15a8033d9c5657d9dc
mlflow.source.type	LOCAL	96479ef023f34b15a8033d9c5657d9dc
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	96479ef023f34b15a8033d9c5657d9dc
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	96479ef023f34b15a8033d9c5657d9dc
mlflow.runName	trial-139	96479ef023f34b15a8033d9c5657d9dc
mlflow.user	eduar	1918bf94daa7417a9f9a9bbe2f473d24
mlflow.source.name	c:\\Users\\eduar\\anaconda3\\Lib\\site-packages\\ipykernel_launcher.py	1918bf94daa7417a9f9a9bbe2f473d24
mlflow.source.type	LOCAL	1918bf94daa7417a9f9a9bbe2f473d24
mlflow.source.git.commit	affc41fd242f49a992b2f2a32c0cd948ba63dfad	1918bf94daa7417a9f9a9bbe2f473d24
mlflow.parentRunId	cceff74de09a44f48ae9e027c5f35536	1918bf94daa7417a9f9a9bbe2f473d24
mlflow.runName	trial-144	1918bf94daa7417a9f9a9bbe2f473d24
model_role	champion	033ebefb766e4bfa8282ab39cec5c865
stage	production	be0003b4c09f45a384716a36faaa3fde
\.


--
-- Data for Name: trace_info; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.trace_info (request_id, experiment_id, timestamp_ms, execution_time_ms, status) FROM stdin;
\.


--
-- Data for Name: trace_request_metadata; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.trace_request_metadata (key, value, request_id) FROM stdin;
\.


--
-- Data for Name: trace_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.trace_tags (key, value, request_id) FROM stdin;
\.


--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mlflow
--

SELECT pg_catalog.setval('public.experiments_experiment_id_seq', 4, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: datasets dataset_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT dataset_pk PRIMARY KEY (experiment_id, name, digest);


--
-- Name: experiments experiment_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiment_pk PRIMARY KEY (experiment_id);


--
-- Name: experiment_tags experiment_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiment_tags
    ADD CONSTRAINT experiment_tag_pk PRIMARY KEY (key, experiment_id);


--
-- Name: experiments experiments_name_key; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_name_key UNIQUE (name);


--
-- Name: input_tags input_tags_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.input_tags
    ADD CONSTRAINT input_tags_pk PRIMARY KEY (input_uuid, name);


--
-- Name: inputs inputs_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.inputs
    ADD CONSTRAINT inputs_pk PRIMARY KEY (source_type, source_id, destination_type, destination_id);


--
-- Name: latest_metrics latest_metric_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.latest_metrics
    ADD CONSTRAINT latest_metric_pk PRIMARY KEY (key, run_uuid);


--
-- Name: metrics metric_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metric_pk PRIMARY KEY (key, "timestamp", step, run_uuid, value, is_nan);


--
-- Name: model_versions model_version_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_version_pk PRIMARY KEY (name, version);


--
-- Name: model_version_tags model_version_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.model_version_tags
    ADD CONSTRAINT model_version_tag_pk PRIMARY KEY (key, name, version);


--
-- Name: params param_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT param_pk PRIMARY KEY (key, run_uuid);


--
-- Name: registered_model_aliases registered_model_alias_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_pk PRIMARY KEY (name, alias);


--
-- Name: registered_models registered_model_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_models
    ADD CONSTRAINT registered_model_pk PRIMARY KEY (name);


--
-- Name: registered_model_tags registered_model_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tag_pk PRIMARY KEY (key, name);


--
-- Name: runs run_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT run_pk PRIMARY KEY (run_uuid);


--
-- Name: tags tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tag_pk PRIMARY KEY (key, run_uuid);


--
-- Name: trace_info trace_info_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_info
    ADD CONSTRAINT trace_info_pk PRIMARY KEY (request_id);


--
-- Name: trace_request_metadata trace_request_metadata_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_request_metadata
    ADD CONSTRAINT trace_request_metadata_pk PRIMARY KEY (key, request_id);


--
-- Name: trace_tags trace_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_tags
    ADD CONSTRAINT trace_tag_pk PRIMARY KEY (key, request_id);


--
-- Name: index_datasets_dataset_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_datasets_dataset_uuid ON public.datasets USING btree (dataset_uuid);


--
-- Name: index_datasets_experiment_id_dataset_source_type; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_datasets_experiment_id_dataset_source_type ON public.datasets USING btree (experiment_id, dataset_source_type);


--
-- Name: index_inputs_destination_type_destination_id_source_type; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_inputs_destination_type_destination_id_source_type ON public.inputs USING btree (destination_type, destination_id, source_type);


--
-- Name: index_inputs_input_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_inputs_input_uuid ON public.inputs USING btree (input_uuid);


--
-- Name: index_latest_metrics_run_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_latest_metrics_run_uuid ON public.latest_metrics USING btree (run_uuid);


--
-- Name: index_metrics_run_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_metrics_run_uuid ON public.metrics USING btree (run_uuid);


--
-- Name: index_params_run_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_params_run_uuid ON public.params USING btree (run_uuid);


--
-- Name: index_tags_run_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_tags_run_uuid ON public.tags USING btree (run_uuid);


--
-- Name: index_trace_info_experiment_id_timestamp_ms; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_trace_info_experiment_id_timestamp_ms ON public.trace_info USING btree (experiment_id, timestamp_ms);


--
-- Name: index_trace_request_metadata_request_id; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_trace_request_metadata_request_id ON public.trace_request_metadata USING btree (request_id);


--
-- Name: index_trace_tags_request_id; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_trace_tags_request_id ON public.trace_tags USING btree (request_id);


--
-- Name: experiment_tags experiment_tags_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiment_tags
    ADD CONSTRAINT experiment_tags_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: datasets fk_datasets_experiment_id_experiments; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT fk_datasets_experiment_id_experiments FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id) ON DELETE CASCADE;


--
-- Name: trace_info fk_trace_info_experiment_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_info
    ADD CONSTRAINT fk_trace_info_experiment_id FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: trace_request_metadata fk_trace_request_metadata_request_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_request_metadata
    ADD CONSTRAINT fk_trace_request_metadata_request_id FOREIGN KEY (request_id) REFERENCES public.trace_info(request_id) ON DELETE CASCADE;


--
-- Name: trace_tags fk_trace_tags_request_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_tags
    ADD CONSTRAINT fk_trace_tags_request_id FOREIGN KEY (request_id) REFERENCES public.trace_info(request_id) ON DELETE CASCADE;


--
-- Name: latest_metrics latest_metrics_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.latest_metrics
    ADD CONSTRAINT latest_metrics_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: metrics metrics_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: model_version_tags model_version_tags_name_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.model_version_tags
    ADD CONSTRAINT model_version_tags_name_version_fkey FOREIGN KEY (name, version) REFERENCES public.model_versions(name, version) ON UPDATE CASCADE;


--
-- Name: model_versions model_versions_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_versions_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;


--
-- Name: params params_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: registered_model_aliases registered_model_alias_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: registered_model_tags registered_model_tags_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tags_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;


--
-- Name: runs runs_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT runs_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: tags tags_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- PostgreSQL database dump complete
--

\unrestrict fEz4fpQW6sJWjrUZphYz9oiMSivYm2KyAk7b9vrsvACEz8JEsdbBFvhUZLdesna

