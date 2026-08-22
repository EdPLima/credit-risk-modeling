"""Backfill score references for a monitoring baseline created before score drift."""

from __future__ import annotations

import os
from collections.abc import Iterator

import mlflow
import pandas as pd
import psycopg

CHUNK_SIZE = 20_000


def _chunks(values: list[tuple[int, dict[str, object]]]) -> Iterator[list[tuple[int, dict[str, object]]]]:
    for start in range(0, len(values), CHUNK_SIZE):
        yield values[start : start + CHUNK_SIZE]


def _apply_registered_input_types(model: mlflow.pyfunc.PyFuncModel, values: pd.DataFrame) -> pd.DataFrame:
    """Restore JSON values to the MLflow signature types before scoring."""

    signature = model.metadata.get_input_schema()
    typed_values = values.copy()
    for column in signature.inputs:
        if column.name not in typed_values:
            continue
        if str(column.type) == "DataType.double":
            typed_values[column.name] = pd.to_numeric(typed_values[column.name], errors="coerce").astype(float)
        elif str(column.type) == "DataType.string":
            typed_values[column.name] = typed_values[column.name].where(
                typed_values[column.name].notna(), None
            ).astype(object)
    return typed_values.loc[:, signature.input_names()]


def backfill_score_baseline(database_url: str, tracking_uri: str) -> int:
    """Score persisted training features with their exact registered model version."""

    mlflow.set_tracking_uri(tracking_uri)
    updated_rows = 0

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        cursor.execute(
            """
            SELECT observation.training_observation_key, observation.selected_features,
                   model.model_name, model.model_version
            FROM monitoring.fact_training_observation AS observation
            JOIN monitoring.dim_data_reference AS reference
              ON reference.reference_key = observation.reference_key
            JOIN monitoring.dim_model AS model
              ON model.model_key = reference.model_key
            WHERE observation.baseline_probability_default IS NULL
            ORDER BY model.model_name, model.model_version, observation.training_observation_key
            """
        )
        pending = cursor.fetchall()

        grouped: dict[tuple[str, str], list[tuple[int, dict[str, object]]]] = {}
        for observation_key, features, model_name, model_version in pending:
            record = features if isinstance(features, dict) else dict(features)
            grouped.setdefault((str(model_name), str(model_version)), []).append(
                (int(observation_key), record)
            )

        for (model_name, model_version), rows in grouped.items():
            model = mlflow.pyfunc.load_model(f"models:/{model_name}/{model_version}")
            for chunk in _chunks(rows):
                observation_keys, feature_records = zip(*chunk, strict=True)
                model_input = _apply_registered_input_types(model, pd.DataFrame(feature_records))
                output = model.predict(model_input)
                if "probability_default" not in output:
                    raise ValueError("Registered model output lacks probability_default.")

                cursor.execute(
                    """
                    UPDATE monitoring.fact_training_observation AS observation
                    SET baseline_probability_default = updates.probability
                    FROM unnest(%s::NUMERIC[], %s::BIGINT[]) AS updates(probability, observation_key)
                    WHERE observation.training_observation_key = updates.observation_key
                      AND observation.baseline_probability_default IS NULL
                    """,
                    (output["probability_default"].astype(float).tolist(), list(observation_keys)),
                )
                updated_rows += len(chunk)
                connection.commit()
                print(f"Backfilled {updated_rows} row(s) for {model_name} v{model_version}.")

    return updated_rows


if __name__ == "__main__":
    database_url = os.environ["MONITORING_DATABASE_URL"]
    tracking_uri = os.environ.get("MLFLOW_TRACKING_URI", "http://mlflow:5000")
    count = backfill_score_baseline(database_url, tracking_uri)
    print(f"Baseline score backfill completed: {count} row(s) updated.")
