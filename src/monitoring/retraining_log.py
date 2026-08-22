"""Persist auditable retraining attempts for PostgreSQL and Power BI."""

from __future__ import annotations

from datetime import UTC, datetime

import psycopg


def start_retraining_run(
    database_url: str,
    airflow_dag_run_id: str,
    source_name: str,
    execution_mode: str,
    input_row_count: int | None = None,
    input_event_count: int | None = None,
) -> int:
    """Create or reset one retraining audit record for the current DAG run."""

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        cursor.execute(
            """
            INSERT INTO monitoring.fact_retraining_run (
                airflow_dag_run_id, source_name, execution_mode, started_at, status,
                input_row_count, input_event_count
            )
            VALUES (%s, %s, %s, %s, 'running', %s, %s)
            ON CONFLICT (airflow_dag_run_id) DO UPDATE
            SET started_at = EXCLUDED.started_at,
                completed_at = NULL,
                status = 'running',
                execution_mode = EXCLUDED.execution_mode,
                input_row_count = EXCLUDED.input_row_count,
                input_event_count = EXCLUDED.input_event_count,
                error_message = NULL
            RETURNING retraining_run_key
            """,
            (
                airflow_dag_run_id,
                source_name,
                execution_mode,
                datetime.now(UTC),
                input_row_count,
                input_event_count,
            ),
        )
        return int(cursor.fetchone()[0])


def finish_retraining_run(
    database_url: str,
    airflow_dag_run_id: str,
    status: str,
    champion_version_before: str | None = None,
    champion_version_after: str | None = None,
    challenger_version: str | None = None,
    challenger_mlflow_run_id: str | None = None,
    champion_pr_auc: float | None = None,
    challenger_pr_auc: float | None = None,
    pr_auc_gain: float | None = None,
    promoted: bool | None = None,
    error_message: str | None = None,
) -> None:
    """Mark a retraining run as succeeded or failed with its decision evidence."""

    if status not in {"succeeded", "failed", "skipped"}:
        raise ValueError("status must be 'succeeded', 'failed', or 'skipped'.")

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        cursor.execute(
            """
            UPDATE monitoring.fact_retraining_run
            SET completed_at = %s,
                status = %s,
                champion_version_before = %s,
                champion_version_after = %s,
                challenger_version = %s,
                challenger_mlflow_run_id = %s,
                champion_pr_auc = %s,
                challenger_pr_auc = %s,
                pr_auc_gain = %s,
                promoted = %s,
                error_message = %s
            WHERE airflow_dag_run_id = %s
            """,
            (
                datetime.now(UTC),
                status,
                champion_version_before,
                champion_version_after,
                challenger_version,
                challenger_mlflow_run_id,
                champion_pr_auc,
                challenger_pr_auc,
                pr_auc_gain,
                promoted,
                error_message,
                airflow_dag_run_id,
            ),
        )
