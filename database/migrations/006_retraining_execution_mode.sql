ALTER TABLE monitoring.fact_retraining_run
    ADD COLUMN IF NOT EXISTS execution_mode TEXT NOT NULL DEFAULT 'production'
    CHECK (execution_mode IN ('production', 'simulation'));

DROP VIEW IF EXISTS monitoring.vw_retraining_run;

CREATE VIEW monitoring.vw_retraining_run AS
SELECT
    retraining_run_key, airflow_dag_run_id, source_name, execution_mode,
    started_at, completed_at, status, input_row_count, input_event_count,
    champion_version_before, champion_version_after, challenger_version,
    challenger_mlflow_run_id, champion_pr_auc, challenger_pr_auc,
    pr_auc_gain, promoted, error_message
FROM monitoring.fact_retraining_run;
