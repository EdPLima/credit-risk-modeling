-- Score reference required to measure prediction drift against the training baseline.
ALTER TABLE monitoring.fact_training_observation
    ADD COLUMN IF NOT EXISTS baseline_probability_default NUMERIC(12, 10)
    CHECK (
        baseline_probability_default IS NULL
        OR baseline_probability_default BETWEEN 0 AND 1
    );

CREATE INDEX IF NOT EXISTS idx_training_observation_reference_score
    ON monitoring.fact_training_observation (reference_key, baseline_probability_default)
    WHERE baseline_probability_default IS NOT NULL;
