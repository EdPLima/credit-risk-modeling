"""Persist scored batches and calculate drift facts for Power BI."""

from __future__ import annotations

import hashlib
import json
from datetime import UTC, date, datetime
from typing import Any

import pandas as pd
import psycopg
from psycopg.types.json import Jsonb

from monitoring.drift import DEFAULT_THRESHOLDS, DriftThresholds, assess_feature_drift
from monitoring.training_reference import anonymize_application_keys

REFERENCE_SAMPLE_SIZE = 50_000


def _calculation_date() -> date:
    """Return a timezone-aware UTC business date for fact rows."""

    return datetime.now(UTC).date()


def _fingerprint_text(value: str) -> str:
    return hashlib.sha256(value.encode()).hexdigest()


def _reference_metadata(cursor: psycopg.Cursor[Any], model_name: str, model_version: str) -> tuple[int, int, float]:
    cursor.execute(
        """
        SELECT model.model_key, reference.reference_key, model.decision_threshold
        FROM monitoring.dim_model AS model
        JOIN monitoring.dim_data_reference AS reference
          ON reference.model_key = model.model_key
        WHERE model.model_name = %s AND model.model_version = %s
        ORDER BY reference.created_at DESC
        LIMIT 1
        """,
        (model_name, model_version),
    )
    row = cursor.fetchone()
    if row is None:
        raise RuntimeError(
            "No training monitoring reference exists for "
            f"{model_name} version {model_version}. Run controlled retraining first."
        )
    return int(row[0]), int(row[1]), float(row[2])


def _load_reference_sample(cursor: psycopg.Cursor[Any], reference_key: int) -> tuple[pd.DataFrame, pd.Series]:
    """Load a bounded, stable reference sample for effect-size calculations."""

    cursor.execute(
        """
        SELECT selected_features, baseline_probability_default
        FROM monitoring.fact_training_observation
        WHERE reference_key = %s
        ORDER BY training_observation_key
        LIMIT %s
        """,
        (reference_key, REFERENCE_SAMPLE_SIZE),
    )
    rows = cursor.fetchall()
    if not rows:
        raise RuntimeError("The training monitoring reference has no observations.")

    records = [row[0] if isinstance(row[0], dict) else json.loads(row[0]) for row in rows]
    scores = pd.Series([row[1] for row in rows], dtype="float64")
    return pd.DataFrame(records), scores


def _upsert_scoring_batch(
    cursor: psycopg.Cursor[Any],
    batch_id: str,
    model_key: int,
    source_uri: str,
    row_count: int,
    airflow_dag_run_id: str | None,
) -> int:
    cursor.execute(
        """
        INSERT INTO monitoring.fact_scoring_batch (
            batch_id, model_key, scoring_date, source_uri, source_fingerprint,
            received_at, input_row_count, scored_row_count, status, airflow_dag_run_id
        )
        VALUES (%s, %s, %s, %s, %s, CURRENT_TIMESTAMP, %s, %s, 'completed', %s)
        ON CONFLICT (batch_id) DO UPDATE
        SET scored_at = CURRENT_TIMESTAMP,
            input_row_count = EXCLUDED.input_row_count,
            scored_row_count = EXCLUDED.scored_row_count,
            status = 'completed',
            failure_reason = NULL
        RETURNING scoring_batch_key
        """,
        (
            batch_id,
            model_key,
            _calculation_date(),
            source_uri,
            # A file can legitimately be rescored in another controlled DAG run.
            # The batch id is therefore part of the idempotency fingerprint.
            _fingerprint_text(f"{batch_id}:{source_uri}"),
            row_count,
            row_count,
            airflow_dag_run_id,
        ),
    )
    return int(cursor.fetchone()[0])


def _persist_predictions(
    cursor: psycopg.Cursor[Any],
    scoring_batch_key: int,
    model_key: int,
    data: pd.DataFrame,
    selected_features: pd.DataFrame,
    predictions: pd.DataFrame,
    threshold: float,
    salt: str,
) -> None:
    application_ids = data.get("SK_ID_CURR", data.index.to_series())
    application_keys = anonymize_application_keys(application_ids, salt)
    credit_amount = data.get("AMT_CREDIT", pd.Series(index=data.index, dtype=float))

    rows = (
        (
            scoring_batch_key,
            model_key,
            _calculation_date(),
            application_key,
            float(probability),
            threshold,
            int(decision),
            None if pd.isna(amount) else float(amount),
            Jsonb(feature_record),
        )
        for application_key, probability, decision, amount, feature_record in zip(
            application_keys,
            predictions["probability_default"],
            predictions["default_prediction"],
            credit_amount,
            json.loads(selected_features.to_json(orient="records")),
            strict=True,
        )
    )
    cursor.executemany(
        """
        INSERT INTO monitoring.fact_prediction (
            scoring_batch_key, model_key, scoring_date, application_key,
            probability_default, decision_threshold, default_prediction,
            credit_amount, selected_features
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (scoring_batch_key, application_key) DO UPDATE
        SET probability_default = EXCLUDED.probability_default,
            decision_threshold = EXCLUDED.decision_threshold,
            default_prediction = EXCLUDED.default_prediction,
            credit_amount = EXCLUDED.credit_amount,
            selected_features = EXCLUDED.selected_features
        """,
        rows,
    )


def _feature_keys(cursor: psycopg.Cursor[Any]) -> dict[str, int]:
    cursor.execute("SELECT feature_name, feature_key FROM monitoring.dim_feature WHERE is_active = TRUE")
    return {str(name): int(key) for name, key in cursor.fetchall()}


def _persist_feature_monitoring(
    cursor: psycopg.Cursor[Any],
    scoring_batch_key: int,
    model_key: int,
    reference_key: int,
    reference_features: pd.DataFrame,
    current_features: pd.DataFrame,
    thresholds: DriftThresholds,
) -> dict[str, int]:
    cursor.execute(
        "SELECT segment_key FROM monitoring.dim_segment WHERE segment_type = 'portfolio' AND segment_value = 'all'"
    )
    segment_key = int(cursor.fetchone()[0])
    feature_keys = _feature_keys(cursor)
    status_counts = {"stable": 0, "warning": 0, "critical": 0}

    for feature_name in current_features.columns:
        if feature_name not in reference_features or feature_name not in feature_keys:
            continue

        current = current_features[feature_name]
        reference = reference_features[feature_name]
        if pd.api.types.is_numeric_dtype(current):
            reference = pd.to_numeric(reference, errors="coerce")

        result = assess_feature_drift(reference, current, thresholds)
        status_counts[str(result["alert_status"])] += 1
        cursor.execute(
            """
            INSERT INTO monitoring.fact_feature_monitoring (
                scoring_batch_key, model_key, reference_key, feature_key, segment_key,
                calculation_date, row_count, missing_count, missing_rate, distinct_count,
                minimum_value, maximum_value, mean_value, median_value, percentile_05,
                percentile_25, percentile_75, percentile_95, category_distribution, psi,
                ks_statistic, ks_p_value, unseen_category_rate, missing_rate_delta, alert_status
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (scoring_batch_key, reference_key, feature_key, segment_key) DO UPDATE
            SET row_count = EXCLUDED.row_count, missing_count = EXCLUDED.missing_count,
                missing_rate = EXCLUDED.missing_rate, distinct_count = EXCLUDED.distinct_count,
                minimum_value = EXCLUDED.minimum_value, maximum_value = EXCLUDED.maximum_value,
                mean_value = EXCLUDED.mean_value, median_value = EXCLUDED.median_value,
                percentile_05 = EXCLUDED.percentile_05, percentile_25 = EXCLUDED.percentile_25,
                percentile_75 = EXCLUDED.percentile_75, percentile_95 = EXCLUDED.percentile_95,
                category_distribution = EXCLUDED.category_distribution, psi = EXCLUDED.psi,
                ks_statistic = EXCLUDED.ks_statistic, ks_p_value = EXCLUDED.ks_p_value,
                unseen_category_rate = EXCLUDED.unseen_category_rate,
                missing_rate_delta = EXCLUDED.missing_rate_delta, alert_status = EXCLUDED.alert_status,
                calculated_at = CURRENT_TIMESTAMP
            """,
            (
                scoring_batch_key, model_key, reference_key, feature_keys[feature_name], segment_key,
                _calculation_date(), result["row_count"], result["missing_count"], result["missing_rate"],
                result["distinct_count"], result["minimum_value"], result["maximum_value"],
                result["mean_value"], result["median_value"], result["percentile_05"],
                result["percentile_25"], result["percentile_75"], result["percentile_95"],
                Jsonb(result["category_distribution"]) if result["category_distribution"] else None,
                result["psi"], result["ks_statistic"], result["ks_p_value"],
                result["unseen_category_rate"], result["missing_rate_delta"], result["alert_status"],
            ),
        )
    return status_counts


def _persist_prediction_monitoring(
    cursor: psycopg.Cursor[Any],
    scoring_batch_key: int,
    model_key: int,
    reference_key: int,
    reference_scores: pd.Series,
    current_scores: pd.Series,
    threshold: float,
    thresholds: DriftThresholds,
) -> str:
    cursor.execute(
        "SELECT segment_key FROM monitoring.dim_segment WHERE segment_type = 'portfolio' AND segment_value = 'all'"
    )
    segment_key = int(cursor.fetchone()[0])

    if reference_scores.notna().sum() == 0:
        result = {"psi": None, "ks_statistic": None, "ks_p_value": None, "alert_status": "not_evaluated"}
    else:
        result = assess_feature_drift(reference_scores, current_scores, thresholds)

    cursor.execute(
        """
        INSERT INTO monitoring.fact_prediction_monitoring (
            scoring_batch_key, model_key, reference_key, segment_key, calculation_date,
            row_count, mean_probability, median_probability, percentile_05_probability,
            percentile_95_probability, threshold_crossing_rate, score_psi, ks_statistic,
            ks_p_value, alert_status
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (scoring_batch_key, reference_key, segment_key) DO UPDATE
        SET row_count = EXCLUDED.row_count, mean_probability = EXCLUDED.mean_probability,
            median_probability = EXCLUDED.median_probability,
            percentile_05_probability = EXCLUDED.percentile_05_probability,
            percentile_95_probability = EXCLUDED.percentile_95_probability,
            threshold_crossing_rate = EXCLUDED.threshold_crossing_rate,
            score_psi = EXCLUDED.score_psi, ks_statistic = EXCLUDED.ks_statistic,
            ks_p_value = EXCLUDED.ks_p_value, alert_status = EXCLUDED.alert_status,
            calculated_at = CURRENT_TIMESTAMP
        """,
        (
            scoring_batch_key, model_key, reference_key, segment_key, _calculation_date(), len(current_scores),
            float(current_scores.mean()), float(current_scores.median()),
            float(current_scores.quantile(0.05)), float(current_scores.quantile(0.95)),
            float((current_scores >= threshold).mean()), result["psi"], result["ks_statistic"],
            result["ks_p_value"], result["alert_status"],
        ),
    )
    return str(result["alert_status"])


def _persist_data_quality(cursor: psycopg.Cursor[Any], scoring_batch_key: int, model_key: int, data: pd.DataFrame, predictions: pd.DataFrame) -> None:
    """Persist only universal, approved technical rules; add business rules through the dimension."""

    checks = [
        ("probability_default_in_range", "range", {"minimum": 0, "maximum": 1}, predictions["probability_default"].between(0, 1)),
    ]
    if "AMT_CREDIT" in data:
        checks.append(("AMT_CREDIT_positive", "range", {"minimum": 0.01}, data["AMT_CREDIT"].gt(0)))

    for rule_name, rule_type, config, passed in checks:
        cursor.execute(
            """
            INSERT INTO monitoring.dim_validation_rule (rule_name, rule_type, rule_config, severity)
            VALUES (%s, %s, %s, 'critical')
            ON CONFLICT (rule_name) DO UPDATE SET rule_config = EXCLUDED.rule_config
            RETURNING rule_key
            """,
            (rule_name, rule_type, Jsonb(config)),
        )
        rule_key = int(cursor.fetchone()[0])
        failed_count = int((~passed.fillna(False)).sum())
        row_count = len(passed)
        pass_rate = (row_count - failed_count) / row_count if row_count else 0.0
        cursor.execute(
            """
            INSERT INTO monitoring.fact_data_quality_result (
                scoring_batch_key, model_key, rule_key, calculation_date, evaluated_row_count,
                failed_row_count, pass_rate, result_status, result_details
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (scoring_batch_key, rule_key) DO UPDATE
            SET failed_row_count = EXCLUDED.failed_row_count, pass_rate = EXCLUDED.pass_rate,
                result_status = EXCLUDED.result_status, result_details = EXCLUDED.result_details,
                calculated_at = CURRENT_TIMESTAMP
            """,
            (
                scoring_batch_key, model_key, rule_key, _calculation_date(), row_count, failed_count,
                pass_rate, "passed" if failed_count == 0 else "failed",
                Jsonb({"rule": config}),
            ),
        )


def monitor_scored_batch(
    database_url: str,
    monitoring_key_salt: str,
    batch_id: str,
    source_uri: str,
    model_name: str,
    model_version: str,
    data: pd.DataFrame,
    selected_features: pd.DataFrame,
    predictions: pd.DataFrame,
    airflow_dag_run_id: str | None = None,
    thresholds: DriftThresholds = DEFAULT_THRESHOLDS,
) -> dict[str, object]:
    """Persist predictions, quality checks, feature drift, and prediction drift."""

    required = {"probability_default", "default_prediction"}
    missing = required.difference(predictions.columns)
    if missing:
        raise ValueError(f"Prediction output is missing: {sorted(missing)}")
    if len(data) != len(selected_features) or len(data) != len(predictions):
        raise ValueError("Data, selected features, and predictions must have the same row count.")

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        model_key, reference_key, threshold = _reference_metadata(cursor, model_name, model_version)
        reference_features, reference_scores = _load_reference_sample(cursor, reference_key)
        scoring_batch_key = _upsert_scoring_batch(
            cursor, batch_id, model_key, source_uri, len(data), airflow_dag_run_id
        )
        _persist_predictions(
            cursor, scoring_batch_key, model_key, data, selected_features, predictions,
            threshold, monitoring_key_salt
        )
        feature_alerts = _persist_feature_monitoring(
            cursor, scoring_batch_key, model_key, reference_key, reference_features,
            selected_features, thresholds
        )
        prediction_alert = _persist_prediction_monitoring(
            cursor, scoring_batch_key, model_key, reference_key, reference_scores,
            predictions["probability_default"], threshold, thresholds
        )
        _persist_data_quality(cursor, scoring_batch_key, model_key, data, predictions)

    return {
        "scoring_batch_key": scoring_batch_key,
        "reference_key": reference_key,
        "feature_alerts": feature_alerts,
        "prediction_alert": prediction_alert,
    }
