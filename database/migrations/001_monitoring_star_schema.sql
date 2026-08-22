-- PostgreSQL schema for credit-risk monitoring and Power BI.
-- Apply migrations with a controlled deployment step. Do not run this file
-- automatically from docker-entrypoint-initdb.d on an existing MLflow database.

CREATE SCHEMA IF NOT EXISTS monitoring;

-- One row per registered MLflow version, never one row per alias.
CREATE TABLE IF NOT EXISTS monitoring.dim_model (
    model_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    model_name TEXT NOT NULL,
    model_version TEXT NOT NULL,
    mlflow_run_id TEXT NOT NULL,
    model_uri TEXT NOT NULL,
    decision_threshold NUMERIC(12, 10),
    training_window_start DATE,
    training_window_end DATE,
    registered_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lifecycle_status TEXT NOT NULL DEFAULT 'registered'
        CHECK (lifecycle_status IN ('registered', 'champion', 'challenger', 'archived', 'rejected')),
    UNIQUE (model_name, model_version)
);

-- One row per monitored feature. Rules are stored separately because they may
-- change without changing the feature itself.
CREATE TABLE IF NOT EXISTS monitoring.dim_feature (
    feature_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    feature_name TEXT NOT NULL UNIQUE,
    data_type TEXT NOT NULL
        CHECK (data_type IN ('numeric', 'categorical', 'boolean', 'date', 'text')),
    source_layer TEXT NOT NULL
        CHECK (source_layer IN ('raw', 'engineered', 'selected')),
    is_selected_feature BOOLEAN NOT NULL DEFAULT FALSE,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- Portfolio segments are optional dimensions for Power BI slicing.
CREATE TABLE IF NOT EXISTS monitoring.dim_segment (
    segment_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    segment_type TEXT NOT NULL,
    segment_value TEXT NOT NULL,
    description TEXT,
    UNIQUE (segment_type, segment_value)
);

INSERT INTO monitoring.dim_segment (segment_type, segment_value, description)
VALUES ('portfolio', 'all', 'All scored applications')
ON CONFLICT (segment_type, segment_value) DO NOTHING;

-- A labelled reference population used as the baseline for drift comparison.
CREATE TABLE IF NOT EXISTS monitoring.dim_data_reference (
    reference_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    reference_name TEXT NOT NULL,
    source_uri TEXT,
    dataset_fingerprint TEXT NOT NULL,
    row_count BIGINT NOT NULL CHECK (row_count > 0),
    target_event_rate NUMERIC(12, 10),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (model_key, reference_name, dataset_fingerprint)
);

-- Configurable expectations. JSONB supports range, regex, allowed values,
-- cross-feature comparison, and directional expectation without schema changes.
CREATE TABLE IF NOT EXISTS monitoring.dim_validation_rule (
    rule_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rule_name TEXT NOT NULL UNIQUE,
    rule_type TEXT NOT NULL CHECK (
        rule_type IN (
            'range',
            'regex',
            'allowed_values',
            'feature_relationship',
            'directional_expectation'
        )
    ),
    feature_key BIGINT REFERENCES monitoring.dim_feature(feature_key),
    compared_feature_key BIGINT REFERENCES monitoring.dim_feature(feature_key),
    rule_config JSONB NOT NULL,
    severity TEXT NOT NULL DEFAULT 'warning'
        CHECK (severity IN ('info', 'warning', 'critical')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (
        rule_type <> 'feature_relationship'
        OR compared_feature_key IS NOT NULL
    )
);

-- One row per input file scored by a model version.
CREATE TABLE IF NOT EXISTS monitoring.fact_scoring_batch (
    scoring_batch_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    batch_id TEXT NOT NULL UNIQUE,
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    scoring_date DATE NOT NULL,
    source_uri TEXT NOT NULL,
    source_fingerprint TEXT,
    received_at TIMESTAMPTZ,
    scored_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    input_row_count BIGINT NOT NULL CHECK (input_row_count >= 0),
    scored_row_count BIGINT NOT NULL CHECK (scored_row_count >= 0),
    status TEXT NOT NULL CHECK (status IN ('started', 'completed', 'failed')),
    failure_reason TEXT,
    airflow_dag_run_id TEXT,
    UNIQUE (source_uri, source_fingerprint, model_key)
);

-- Record-level audit fact. selected_features stores the 67 contract inputs as
-- JSONB so a future model contract does not require adding or dropping columns.
-- application_key must be a hash or a non-identifying business key.
CREATE TABLE IF NOT EXISTS monitoring.fact_prediction (
    prediction_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    scoring_batch_key BIGINT NOT NULL
        REFERENCES monitoring.fact_scoring_batch(scoring_batch_key),
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    scoring_date DATE NOT NULL,
    application_key TEXT NOT NULL,
    probability_default NUMERIC(12, 10) NOT NULL
        CHECK (probability_default BETWEEN 0 AND 1),
    decision_threshold NUMERIC(12, 10) NOT NULL
        CHECK (decision_threshold BETWEEN 0 AND 1),
    default_prediction SMALLINT NOT NULL
        CHECK (default_prediction IN (0, 1)),
    credit_amount NUMERIC(18, 2),
    selected_features JSONB NOT NULL,
    observed_target SMALLINT CHECK (observed_target IN (0, 1)),
    target_observed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (scoring_batch_key, application_key)
);

-- Record-level training baseline. It keeps the labelled records and the exact
-- selected inputs used by a model version for traceability and recalculation.
CREATE TABLE IF NOT EXISTS monitoring.fact_training_observation (
    training_observation_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reference_key BIGINT NOT NULL
        REFERENCES monitoring.dim_data_reference(reference_key),
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    application_key TEXT NOT NULL,
    observed_target SMALLINT NOT NULL CHECK (observed_target IN (0, 1)),
    credit_amount NUMERIC(18, 2),
    selected_features JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (reference_key, application_key)
);

-- Baseline summary per feature. Numeric summaries and categorical distributions
-- are stored together; only applicable fields are populated for each feature.
CREATE TABLE IF NOT EXISTS monitoring.fact_training_feature_profile (
    training_feature_profile_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reference_key BIGINT NOT NULL
        REFERENCES monitoring.dim_data_reference(reference_key),
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    feature_key BIGINT NOT NULL REFERENCES monitoring.dim_feature(feature_key),
    segment_key BIGINT NOT NULL REFERENCES monitoring.dim_segment(segment_key),
    row_count BIGINT NOT NULL CHECK (row_count >= 0),
    missing_count BIGINT NOT NULL CHECK (missing_count >= 0),
    missing_rate NUMERIC(12, 10) NOT NULL CHECK (missing_rate BETWEEN 0 AND 1),
    distinct_count BIGINT,
    minimum_value NUMERIC,
    maximum_value NUMERIC,
    mean_value NUMERIC,
    median_value NUMERIC,
    standard_deviation NUMERIC,
    percentile_05 NUMERIC,
    percentile_25 NUMERIC,
    percentile_75 NUMERIC,
    percentile_95 NUMERIC,
    category_distribution JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (reference_key, feature_key, segment_key)
);

-- Current-batch feature profile and feature-drift result, at the same grain as
-- the training baseline: batch, model, feature, and optional segment.
CREATE TABLE IF NOT EXISTS monitoring.fact_feature_monitoring (
    feature_monitoring_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    scoring_batch_key BIGINT NOT NULL
        REFERENCES monitoring.fact_scoring_batch(scoring_batch_key),
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    reference_key BIGINT NOT NULL
        REFERENCES monitoring.dim_data_reference(reference_key),
    feature_key BIGINT NOT NULL REFERENCES monitoring.dim_feature(feature_key),
    segment_key BIGINT NOT NULL REFERENCES monitoring.dim_segment(segment_key),
    calculation_date DATE NOT NULL,
    row_count BIGINT NOT NULL CHECK (row_count >= 0),
    missing_count BIGINT NOT NULL CHECK (missing_count >= 0),
    missing_rate NUMERIC(12, 10) NOT NULL CHECK (missing_rate BETWEEN 0 AND 1),
    distinct_count BIGINT,
    minimum_value NUMERIC,
    maximum_value NUMERIC,
    mean_value NUMERIC,
    median_value NUMERIC,
    percentile_05 NUMERIC,
    percentile_25 NUMERIC,
    percentile_75 NUMERIC,
    percentile_95 NUMERIC,
    category_distribution JSONB,
    psi NUMERIC,
    ks_statistic NUMERIC,
    ks_p_value NUMERIC,
    unseen_category_rate NUMERIC(12, 10),
    missing_rate_delta NUMERIC,
    alert_status TEXT NOT NULL DEFAULT 'not_evaluated'
        CHECK (alert_status IN ('stable', 'warning', 'critical', 'not_evaluated')),
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (scoring_batch_key, reference_key, feature_key, segment_key)
);

-- Prediction drift is a batch-level fact because probabilities have one value
-- per application and are lower dimensional than the input feature space.
CREATE TABLE IF NOT EXISTS monitoring.fact_prediction_monitoring (
    prediction_monitoring_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    scoring_batch_key BIGINT NOT NULL
        REFERENCES monitoring.fact_scoring_batch(scoring_batch_key),
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    reference_key BIGINT NOT NULL
        REFERENCES monitoring.dim_data_reference(reference_key),
    segment_key BIGINT NOT NULL REFERENCES monitoring.dim_segment(segment_key),
    calculation_date DATE NOT NULL,
    row_count BIGINT NOT NULL CHECK (row_count >= 0),
    mean_probability NUMERIC,
    median_probability NUMERIC,
    percentile_05_probability NUMERIC,
    percentile_95_probability NUMERIC,
    threshold_crossing_rate NUMERIC(12, 10),
    score_psi NUMERIC,
    ks_statistic NUMERIC,
    ks_p_value NUMERIC,
    alert_status TEXT NOT NULL DEFAULT 'not_evaluated'
        CHECK (alert_status IN ('stable', 'warning', 'critical', 'not_evaluated')),
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (scoring_batch_key, reference_key, segment_key)
);

-- Result of range, regex, allowed-value, and cross-feature validation rules.
CREATE TABLE IF NOT EXISTS monitoring.fact_data_quality_result (
    data_quality_result_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    scoring_batch_key BIGINT NOT NULL
        REFERENCES monitoring.fact_scoring_batch(scoring_batch_key),
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    rule_key BIGINT NOT NULL REFERENCES monitoring.dim_validation_rule(rule_key),
    calculation_date DATE NOT NULL,
    evaluated_row_count BIGINT NOT NULL CHECK (evaluated_row_count >= 0),
    failed_row_count BIGINT NOT NULL CHECK (failed_row_count >= 0),
    pass_rate NUMERIC(12, 10) NOT NULL CHECK (pass_rate BETWEEN 0 AND 1),
    result_status TEXT NOT NULL CHECK (result_status IN ('passed', 'warning', 'failed')),
    result_details JSONB,
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (scoring_batch_key, rule_key)
);

-- Directional checks compare a feature with predicted default probability.
-- Example configuration: expected_direction=increasing for a business-approved
-- risk driver. No rule is seeded here because business approval is required.
CREATE TABLE IF NOT EXISTS monitoring.fact_directional_expectation_result (
    directional_result_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    scoring_batch_key BIGINT NOT NULL
        REFERENCES monitoring.fact_scoring_batch(scoring_batch_key),
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    rule_key BIGINT NOT NULL REFERENCES monitoring.dim_validation_rule(rule_key),
    feature_key BIGINT NOT NULL REFERENCES monitoring.dim_feature(feature_key),
    calculation_date DATE NOT NULL,
    expected_direction TEXT NOT NULL CHECK (expected_direction IN ('increasing', 'decreasing')),
    observed_spearman_correlation NUMERIC,
    is_direction_satisfied BOOLEAN NOT NULL,
    result_details JSONB,
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (scoring_batch_key, rule_key)
);

-- Performance is populated after true outcomes mature and are joined back to
-- fact_prediction. It must not be calculated from unlabelled scoring batches.
CREATE TABLE IF NOT EXISTS monitoring.fact_model_performance (
    model_performance_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    model_key BIGINT NOT NULL REFERENCES monitoring.dim_model(model_key),
    segment_key BIGINT NOT NULL REFERENCES monitoring.dim_segment(segment_key),
    reference_key BIGINT REFERENCES monitoring.dim_data_reference(reference_key),
    period_start_date DATE NOT NULL,
    period_end_date DATE NOT NULL,
    labeled_row_count BIGINT NOT NULL CHECK (labeled_row_count > 0),
    event_rate NUMERIC(12, 10),
    pr_auc NUMERIC,
    roc_auc NUMERIC,
    ks NUMERIC,
    precision_score NUMERIC,
    recall_score NUMERIC,
    f1_score NUMERIC,
    brier_score NUMERIC,
    captured_credit_amount NUMERIC(18, 2),
    missed_credit_amount NUMERIC(18, 2),
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (model_key, segment_key, period_start_date, period_end_date)
);

CREATE INDEX IF NOT EXISTS idx_fact_prediction_model_date
    ON monitoring.fact_prediction (model_key, scoring_date);

CREATE INDEX IF NOT EXISTS idx_fact_prediction_observed_target
    ON monitoring.fact_prediction (observed_target)
    WHERE observed_target IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_fact_feature_monitoring_batch
    ON monitoring.fact_feature_monitoring (scoring_batch_key, alert_status);

CREATE INDEX IF NOT EXISTS idx_fact_data_quality_result_batch
    ON monitoring.fact_data_quality_result (scoring_batch_key, result_status);
