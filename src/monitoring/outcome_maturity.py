"""Load matured outcomes into the prediction audit table."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

import pandas as pd
import psycopg

from monitoring.training_reference import anonymize_application_keys


@dataclass(frozen=True)
class OutcomeMaturitySummary:
    """Result of attaching one batch's observed outcomes to its predictions."""

    batch_id: str
    scoring_batch_key: int
    matched_row_count: int


def load_outcome_reference(
    target_reference_path: str | Path,
    application_id_column: str = "SK_ID_CURR",
    target_column: str = "TARGET",
) -> pd.DataFrame:
    """Read and validate a two-column outcome reference file."""

    reference = pd.read_csv(target_reference_path)
    expected_columns = {application_id_column, target_column}
    if set(reference.columns) != expected_columns:
        raise ValueError(f"Outcome reference must contain exactly {sorted(expected_columns)}.")
    if reference.empty or reference[application_id_column].isna().any():
        raise ValueError("Outcome reference must contain non-null application identifiers.")
    if reference[application_id_column].duplicated().any():
        raise ValueError("Outcome reference contains duplicate application identifiers.")
    if reference[target_column].isna().any() or not set(reference[target_column].unique()).issubset({0, 1}):
        raise ValueError(f"'{target_column}' must contain only binary, non-null values.")
    return reference


def mature_batch_outcomes(
    database_url: str,
    monitoring_key_salt: str,
    batch_id: str,
    target_reference_path: str | Path,
) -> OutcomeMaturitySummary:
    """Attach observed targets to exactly one scored batch.

    The reference is linked by the same salted application-key hash used when
    predictions were persisted. A mismatch rolls back the transaction instead
    of leaving a partially labelled batch in the monitoring database.
    """

    reference = load_outcome_reference(target_reference_path)
    application_keys = anonymize_application_keys(reference["SK_ID_CURR"], monitoring_key_salt)
    updates = [
        (int(target), application_key)
        for target, application_key in zip(reference["TARGET"], application_keys, strict=True)
    ]

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        cursor.execute(
            "SELECT scoring_batch_key FROM monitoring.fact_scoring_batch WHERE batch_id = %s",
            (batch_id,),
        )
        row = cursor.fetchone()
        if row is None:
            raise ValueError(f"Scoring batch '{batch_id}' was not found.")
        scoring_batch_key = int(row[0])

        cursor.executemany(
            """
            UPDATE monitoring.fact_prediction
            SET observed_target = %s,
                target_observed_at = COALESCE(target_observed_at, CURRENT_TIMESTAMP)
            WHERE scoring_batch_key = %s
              AND application_key = %s
              AND (observed_target IS NULL OR observed_target = %s)
            """,
            [
                (target, scoring_batch_key, application_key, target)
                for target, application_key in updates
            ],
        )
        cursor.execute(
            """
            SELECT COUNT(*)
            FROM monitoring.fact_prediction
            WHERE scoring_batch_key = %s AND observed_target IS NOT NULL
            """,
            (scoring_batch_key,),
        )
        matched_row_count = int(cursor.fetchone()[0])
        if matched_row_count != len(reference):
            raise ValueError(
                f"Outcome reference matched {matched_row_count} of {len(reference)} predictions "
                f"for batch '{batch_id}'."
            )

    return OutcomeMaturitySummary(
        batch_id=batch_id,
        scoring_batch_key=scoring_batch_key,
        matched_row_count=matched_row_count,
    )
