"""Manual batch scoring DAG for the MLflow champion model."""

from __future__ import annotations

import os
import re
from datetime import UTC, date, datetime
from pathlib import Path

import pandas as pd
from airflow.decorators import dag, task
from airflow.operators.python import get_current_context

from pipeline.inference.load_model import load_model
from pipeline.inference.predict import predict_model
from pipeline.inference.save_predictions import publish_predictions, save_predictions


@dag(
    dag_id="credit_risk_batch_inference",
    description="Score one batch with models:/credit-risk-model@champion.",
    schedule=None,
    start_date=datetime(2026, 1, 1, tzinfo=UTC),
    catchup=False,
    tags=["credit-risk", "batch-inference"],
)

def credit_risk_batch_inference():
    """Build a manual DAG until the production input source is defined."""

    @task(task_id="load_data")
    def load_batch() -> dict[str, str | int]:
        """Check that the input exists and return a small batch reference."""

        context = get_current_context()
        run_conf = context["dag_run"].conf or {}

        input_path = run_conf.get("input_path")
        output_path = run_conf.get("output_path")
        scoring_date = run_conf.get("scoring_date")

        if not input_path or not output_path:
            raise ValueError(
                "Provide 'input_path' and 'output_path' in the DAG run config."
            )

        input_file = Path(input_path)
        if not input_file.is_file():
            raise FileNotFoundError(f"Input batch file not found: {input_file}")

        if input_file.suffix.lower() not in {".csv", ".parquet"}:
            raise ValueError("Input batch must be a CSV or Parquet file.")

        if scoring_date is not None:
            try:
                date.fromisoformat(str(scoring_date))
            except ValueError as error:
                raise ValueError("'scoring_date' must use the YYYY-MM-DD format.") from error

        return {
            "batch_id": context["run_id"],
            "input_path": str(input_file),
            "output_path": str(Path(output_path)),
            "scoring_date": str(scoring_date) if scoring_date else None,
        }

    @task(task_id="predict")
    def score_batch(batch: dict[str, str | int]) -> dict[str, object]:
        """Load champion, score the batch, and save a temporary result file."""

        from data.load_data import load_data
        from features.feature_engineering import selection_features
        from monitoring.batch_monitoring import monitor_scored_batch
        from monitoring.model_lifecycle import sync_model_lifecycle

        data = load_data(str(batch["input_path"]))
        resolved_model = load_model()
        predictions = predict_model(resolved_model.model, data)
        selected_features = selection_features(data)
        scored_data = pd.concat([data.reset_index(drop=True), predictions.reset_index(drop=True)],axis=1,)

        database_url = os.getenv("MONITORING_DATABASE_URL")
        monitoring_summary = None
        if database_url:
            # Mirror the MLflow @champion alias before exposing monitoring data.
            sync_model_lifecycle(
                database_url=database_url,
                model_name=resolved_model.model_name,
                champion_version=resolved_model.model_version,
            )
            monitoring_summary = monitor_scored_batch(
                database_url=database_url,
                monitoring_key_salt=os.environ["MONITORING_KEY_SALT"],
                batch_id=str(batch["batch_id"]),
                source_uri=str(batch["input_path"]),
                model_name=resolved_model.model_name,
                model_version=resolved_model.model_version,
                data=data,
                selected_features=selected_features,
                predictions=predictions,
                airflow_dag_run_id=str(batch["batch_id"]),
                scoring_date=(
                    date.fromisoformat(str(batch["scoring_date"]))
                    if batch["scoring_date"]
                    else None
                ),
            )

        output_path = Path(str(batch["output_path"]))
        safe_batch_id = re.sub(r"[^A-Za-z0-9_.-]+", "_", str(batch["batch_id"]))
        staging_path = output_path.parent / ".staging" / (f"{safe_batch_id}{output_path.suffix}")

        save_predictions(scored_data, staging_path)

        return {
            **batch,
            "staging_path": str(staging_path),
            "model_name": resolved_model.model_name,
            "model_alias": resolved_model.alias,
            "model_version": resolved_model.model_version,
            "run_id": resolved_model.run_id,
            "monitoring_summary": monitoring_summary,
        }

    @task(task_id="save_predictions")
    def save_scored_batch(scoring: dict[str, str | int]) -> None:
        """Publish the scored batch only after the prediction task succeeds."""

        publish_predictions(
            staging_path=str(scoring["staging_path"]),
            output_path=str(scoring["output_path"]),
        )

    batch = load_batch()
    scoring = score_batch(batch)
    save_scored_batch(scoring)


credit_risk_batch_inference()
