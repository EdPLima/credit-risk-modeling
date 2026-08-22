"""Evaluate model performance only after production outcomes are available."""

from __future__ import annotations

from datetime import date

import pandas as pd
import psycopg
from sklearn.metrics import (
    average_precision_score,
    brier_score_loss,
    f1_score,
    precision_score,
    recall_score,
    roc_auc_score,
    roc_curve,
)


def calculate_performance_metrics(
    outcomes: pd.DataFrame,
    threshold: float,
) -> dict[str, float | int | None]:
    """Calculate supervised metrics from matured labels and stored scores.

    ``outcomes`` must contain ``observed_target`` and ``probability_default``.
    ``credit_amount`` is optional and is used only for the financial indicators.
    """

    required_columns = {"observed_target", "probability_default"}
    missing_columns = required_columns.difference(outcomes.columns)
    if missing_columns:
        raise ValueError(f"Outcomes are missing: {sorted(missing_columns)}")

    valid = outcomes.dropna(subset=["observed_target", "probability_default"]).copy()
    valid["observed_target"] = valid["observed_target"].astype(int)
    valid["probability_default"] = valid["probability_default"].astype(float)
    if valid["observed_target"].nunique() != 2:
        raise ValueError("Performance requires matured outcomes from both target classes.")

    predicted_default = (valid["probability_default"] >= threshold).astype(int)
    false_positive_rate, true_positive_rate, _ = roc_curve(
        valid["observed_target"], valid["probability_default"]
    )
    credit_amount = pd.to_numeric(
        valid.get("credit_amount", pd.Series(0.0, index=valid.index)), errors="coerce"
    ).fillna(0.0)
    captured = credit_amount[(valid["observed_target"] == 1) & (predicted_default == 1)].sum()
    missed = credit_amount[(valid["observed_target"] == 1) & (predicted_default == 0)].sum()

    return {
        "labeled_row_count": len(valid),
        "event_rate": float(valid["observed_target"].mean()),
        "pr_auc": float(average_precision_score(valid["observed_target"], valid["probability_default"])),
        "roc_auc": float(roc_auc_score(valid["observed_target"], valid["probability_default"])),
        "ks": float((true_positive_rate - false_positive_rate).max()),
        "precision_score": float(precision_score(valid["observed_target"], predicted_default, zero_division=0)),
        "recall_score": float(recall_score(valid["observed_target"], predicted_default, zero_division=0)),
        "f1_score": float(f1_score(valid["observed_target"], predicted_default, zero_division=0)),
        "brier_score": float(brier_score_loss(valid["observed_target"], valid["probability_default"])),
        "captured_credit_amount": float(captured),
        "missed_credit_amount": float(missed),
    }


def persist_matured_model_performance(
    database_url: str,
    model_name: str,
    model_version: str,
    period_start_date: date,
    period_end_date: date,
) -> dict[str, float | int | None]:
    """Persist one Power BI performance fact from labelled predictions.

    An upstream outcome-load job must first update ``fact_prediction.observed_target``
    and ``target_observed_at``. This function deliberately does not infer labels.
    """

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        cursor.execute(
            """
            SELECT model.model_key, model.decision_threshold, reference.reference_key,
                   segment.segment_key
            FROM monitoring.dim_model AS model
            JOIN monitoring.dim_segment AS segment
              ON segment.segment_type = 'portfolio' AND segment.segment_value = 'all'
            LEFT JOIN monitoring.dim_data_reference AS reference
              ON reference.model_key = model.model_key
            WHERE model.model_name = %s AND model.model_version = %s
            ORDER BY reference.created_at DESC NULLS LAST
            LIMIT 1
            """,
            (model_name, model_version),
        )
        metadata = cursor.fetchone()
        if metadata is None:
            raise RuntimeError(f"Model {model_name} version {model_version} is not monitored.")

        model_key, threshold, reference_key, segment_key = metadata
        cursor.execute(
            """
            SELECT observed_target, probability_default, credit_amount
            FROM monitoring.fact_prediction
            WHERE model_key = %s
              AND scoring_date BETWEEN %s AND %s
              AND observed_target IS NOT NULL
            """,
            (model_key, period_start_date, period_end_date),
        )
        outcomes = pd.DataFrame(
            cursor.fetchall(), columns=["observed_target", "probability_default", "credit_amount"]
        )
        metrics = calculate_performance_metrics(outcomes, float(threshold))
        cursor.execute(
            """
            INSERT INTO monitoring.fact_model_performance (
                model_key, segment_key, reference_key, period_start_date, period_end_date,
                labeled_row_count, event_rate, pr_auc, roc_auc, ks, precision_score,
                recall_score, f1_score, brier_score, captured_credit_amount,
                missed_credit_amount
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (model_key, segment_key, period_start_date, period_end_date) DO UPDATE
            SET reference_key = EXCLUDED.reference_key,
                labeled_row_count = EXCLUDED.labeled_row_count,
                event_rate = EXCLUDED.event_rate,
                pr_auc = EXCLUDED.pr_auc,
                roc_auc = EXCLUDED.roc_auc,
                ks = EXCLUDED.ks,
                precision_score = EXCLUDED.precision_score,
                recall_score = EXCLUDED.recall_score,
                f1_score = EXCLUDED.f1_score,
                brier_score = EXCLUDED.brier_score,
                captured_credit_amount = EXCLUDED.captured_credit_amount,
                missed_credit_amount = EXCLUDED.missed_credit_amount,
                calculated_at = CURRENT_TIMESTAMP
            """,
            (
                model_key, segment_key, reference_key, period_start_date, period_end_date,
                metrics["labeled_row_count"], metrics["event_rate"], metrics["pr_auc"],
                metrics["roc_auc"], metrics["ks"], metrics["precision_score"],
                metrics["recall_score"], metrics["f1_score"], metrics["brier_score"],
                metrics["captured_credit_amount"], metrics["missed_credit_amount"],
            ),
        )

    return metrics
