"""Manual retraining DAG with a PR-AUC promotion gate."""

from __future__ import annotations

import os
from datetime import UTC, datetime

from airflow.decorators import dag, task
from airflow.exceptions import AirflowSkipException
from airflow.operators.python import get_current_context

from data.load_data import (
    InsufficientMaturedOutcomesError,
    load_matured_retraining_data,
    load_training_reference_data,
)
from monitoring.retraining_log import finish_retraining_run, start_retraining_run
from pipeline.inference.load_model import load_model
from pipeline.training.train_pipeline import run_retraining


@dag(
    dag_id="credit_risk_retraining",
    description="Train a challenger and promote it only when test PR-AUC improves.",
    schedule=None,
    start_date=datetime(2026, 1, 1, tzinfo=UTC),
    catchup=False,
    tags=["credit-risk", "retraining"],
)
def credit_risk_retraining():
    """Build a manual DAG from production observations with matured outcomes."""

    @task(task_id="load_data")
    def validate_training_data() -> dict[str, int | str]:
        """Validate the labelled production source without transferring data in XCom."""

        context = get_current_context()
        run_conf = context["dag_run"].conf or {}
        target_column = run_conf.get("target_column", "TARGET")
        min_rows = int(run_conf.get("min_rows", 5_000))
        min_events = int(run_conf.get("min_events", 100))
        execution_mode = str(run_conf.get("mode", "production")).lower()
        database_url = os.getenv("MONITORING_DATABASE_URL")

        if not database_url:
            raise RuntimeError("MONITORING_DATABASE_URL is required for retraining.")
        if execution_mode not in {"production", "simulation"}:
            raise ValueError("mode must be 'production' or 'simulation'.")

        return {
            "target_column": str(target_column),
            "min_rows": min_rows,
            "min_events": min_events,
            "execution_mode": execution_mode,
        }

    @task(task_id="train_evaluate_and_promote")
    def retrain_and_compare(dataset: dict[str, int | str]) -> dict[str, str | float | bool]:
        """Run training, the untouched-test comparison, and the MLflow gate."""

        context = get_current_context()
        dag_run_id = str(context["run_id"])
        database_url = os.environ["MONITORING_DATABASE_URL"]
        execution_mode = str(dataset["execution_mode"])
        source_name = "monitoring.fact_prediction (matured outcomes)"

        start_retraining_run(
            database_url=database_url,
            airflow_dag_run_id=dag_run_id,
            source_name=source_name,
            execution_mode=execution_mode,
        )
        try:
            if execution_mode == "simulation":
                champion = load_model()
                source_name = "monitoring.fact_training_observation (simulation only)"
                data = load_training_reference_data(
                    database_url=database_url,
                    model_name=champion.model_name,
                    model_version=champion.model_version,
                )
            else:
                data = load_matured_retraining_data(
                    database_url=database_url,
                    min_rows=int(dataset["min_rows"]),
                    min_events=int(dataset["min_events"]),
                )
            start_retraining_run(
                database_url=database_url,
                airflow_dag_run_id=dag_run_id,
                source_name=source_name,
                execution_mode=execution_mode,
                input_row_count=len(data),
                input_event_count=int(data["TARGET"].sum()),
            )
            result = run_retraining(
                data=data,
                target_column=str(dataset["target_column"]),
                promotion_allowed=execution_mode == "production",
                execution_mode=execution_mode,
            )
        except InsufficientMaturedOutcomesError as error:
            finish_retraining_run(
                database_url=database_url,
                airflow_dag_run_id=dag_run_id,
                status="skipped",
                error_message=str(error),
            )
            raise AirflowSkipException(str(error)) from error
        except Exception as error:
            finish_retraining_run(
                database_url=database_url,
                airflow_dag_run_id=dag_run_id,
                status="failed",
                error_message=str(error),
            )
            raise

        finish_retraining_run(
            database_url=database_url,
            airflow_dag_run_id=dag_run_id,
            status="succeeded",
            champion_version_before=result.champion_version_before,
            champion_version_after=result.champion_version_after,
            challenger_version=result.challenger_version,
            challenger_mlflow_run_id=result.challenger_mlflow_run_id,
            champion_pr_auc=result.comparison.champion_pr_auc,
            challenger_pr_auc=result.comparison.challenger_pr_auc,
            pr_auc_gain=result.comparison.pr_auc_gain,
            promoted=result.promoted,
        )

        return {
            "challenger_version": result.challenger_version,
            "champion_version_before": result.champion_version_before,
            "champion_version_after": result.champion_version_after,
            "champion_pr_auc": result.comparison.champion_pr_auc,
            "challenger_pr_auc": result.comparison.challenger_pr_auc,
            "pr_auc_gain": result.comparison.pr_auc_gain,
            "promoted": result.promoted,
            "execution_mode": execution_mode,
            "mlflow_run_id": result.challenger_mlflow_run_id,
        }

    dataset = validate_training_data()
    retrain_and_compare(dataset)


credit_risk_retraining()
