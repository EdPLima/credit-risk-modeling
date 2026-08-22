CREATE TABLE IF NOT EXISTS monitoring.fact_retraining_run (
    retraining_run_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    airflow_dag_run_id TEXT NOT NULL UNIQUE,
    source_name TEXT NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    status TEXT NOT NULL CHECK (status IN ('running', 'succeeded', 'failed')),
    input_row_count BIGINT,
    input_event_count BIGINT,
    champion_version_before TEXT,
    champion_version_after TEXT,
    challenger_version TEXT,
    challenger_mlflow_run_id TEXT,
    champion_pr_auc NUMERIC,
    challenger_pr_auc NUMERIC,
    pr_auc_gain NUMERIC,
    promoted BOOLEAN,
    error_message TEXT
);

CREATE INDEX IF NOT EXISTS idx_fact_retraining_run_status_started
    ON monitoring.fact_retraining_run (status, started_at DESC);

CREATE OR REPLACE VIEW monitoring.vw_retraining_run AS
SELECT
    retraining_run_key,
    airflow_dag_run_id,
    source_name,
    started_at,
    completed_at,
    status,
    input_row_count,
    input_event_count,
    champion_version_before,
    champion_version_after,
    challenger_version,
    challenger_mlflow_run_id,
    champion_pr_auc,
    challenger_pr_auc,
    pr_auc_gain,
    promoted,
    error_message
FROM monitoring.fact_retraining_run;
