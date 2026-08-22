-- Curated reporting views. Power BI can import these views without having to
-- reproduce the model, batch, feature, segment, and reference joins.

CREATE OR REPLACE VIEW monitoring.vw_feature_monitoring AS
SELECT
    batch.batch_id,
    batch.scoring_date,
    batch.source_uri,
    model.model_name,
    model.model_version,
    feature.feature_name,
    segment.segment_type,
    segment.segment_value,
    monitoring.row_count,
    monitoring.missing_rate,
    monitoring.minimum_value,
    monitoring.maximum_value,
    monitoring.mean_value,
    monitoring.median_value,
    monitoring.percentile_05,
    monitoring.percentile_95,
    monitoring.psi,
    monitoring.ks_statistic,
    monitoring.ks_p_value,
    monitoring.unseen_category_rate,
    monitoring.missing_rate_delta,
    monitoring.alert_status,
    monitoring.calculated_at
FROM monitoring.fact_feature_monitoring AS monitoring
JOIN monitoring.fact_scoring_batch AS batch
  ON batch.scoring_batch_key = monitoring.scoring_batch_key
JOIN monitoring.dim_model AS model
  ON model.model_key = monitoring.model_key
JOIN monitoring.dim_feature AS feature
  ON feature.feature_key = monitoring.feature_key
JOIN monitoring.dim_segment AS segment
  ON segment.segment_key = monitoring.segment_key;

CREATE OR REPLACE VIEW monitoring.vw_prediction_monitoring AS
SELECT
    batch.batch_id,
    batch.scoring_date,
    batch.source_uri,
    model.model_name,
    model.model_version,
    monitoring.row_count,
    monitoring.mean_probability,
    monitoring.median_probability,
    monitoring.percentile_05_probability,
    monitoring.percentile_95_probability,
    monitoring.threshold_crossing_rate,
    monitoring.score_psi,
    monitoring.ks_statistic,
    monitoring.ks_p_value,
    monitoring.alert_status,
    monitoring.calculated_at
FROM monitoring.fact_prediction_monitoring AS monitoring
JOIN monitoring.fact_scoring_batch AS batch
  ON batch.scoring_batch_key = monitoring.scoring_batch_key
JOIN monitoring.dim_model AS model
  ON model.model_key = monitoring.model_key;

CREATE OR REPLACE VIEW monitoring.vw_data_quality AS
SELECT
    batch.batch_id,
    batch.scoring_date,
    batch.source_uri,
    model.model_name,
    model.model_version,
    rule.rule_name,
    rule.rule_type,
    rule.severity,
    quality.evaluated_row_count,
    quality.failed_row_count,
    quality.pass_rate,
    quality.result_status,
    quality.calculated_at
FROM monitoring.fact_data_quality_result AS quality
JOIN monitoring.fact_scoring_batch AS batch
  ON batch.scoring_batch_key = quality.scoring_batch_key
JOIN monitoring.dim_model AS model
  ON model.model_key = quality.model_key
JOIN monitoring.dim_validation_rule AS rule
  ON rule.rule_key = quality.rule_key;

CREATE OR REPLACE VIEW monitoring.vw_model_performance AS
SELECT
    model.model_name,
    model.model_version,
    performance.period_start_date,
    performance.period_end_date,
    performance.labeled_row_count,
    performance.event_rate,
    performance.pr_auc,
    performance.roc_auc,
    performance.ks,
    performance.precision_score,
    performance.recall_score,
    performance.f1_score,
    performance.brier_score,
    performance.captured_credit_amount,
    performance.missed_credit_amount,
    performance.calculated_at
FROM monitoring.fact_model_performance AS performance
JOIN monitoring.dim_model AS model
  ON model.model_key = performance.model_key;
