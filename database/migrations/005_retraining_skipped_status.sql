ALTER TABLE monitoring.fact_retraining_run
    DROP CONSTRAINT IF EXISTS fact_retraining_run_status_check;

ALTER TABLE monitoring.fact_retraining_run
    ADD CONSTRAINT fact_retraining_run_status_check
    CHECK (status IN ('running', 'succeeded', 'failed', 'skipped'));
