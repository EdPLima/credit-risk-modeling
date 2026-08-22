"""Load batch data from a supported local file format."""

from pathlib import Path
from typing import Any

import pandas as pd
import psycopg


class InsufficientMaturedOutcomesError(ValueError):
    """Raised when production labels are not yet sufficient for retraining."""


def load_data(file_path: str | Path) -> pd.DataFrame:
    """Load a CSV or Parquet batch and reject empty inputs."""

    path = Path(file_path)

    if not path.is_file():
        raise FileNotFoundError(f"Input batch file not found: {path}")

    if path.suffix.lower() == ".csv":
        data = pd.read_csv(path)
    elif path.suffix.lower() == ".parquet":
        data = pd.read_parquet(path)
    else:
        raise ValueError(
            f"Unsupported input format '{path.suffix}'. Use CSV or Parquet."
        )

    if data.empty:
        raise ValueError(f"Input batch is empty: {path}")

    return data


def _matured_retraining_dataframe(
    rows: list[tuple[dict[str, Any], int]],
) -> pd.DataFrame:
    """Build the labelled model contract from database records."""

    records = [features for features, _ in rows]
    data = pd.DataFrame(records)
    data["TARGET"] = [target for _, target in rows]
    return data


def load_matured_retraining_data(
    database_url: str,
    min_rows: int = 5_000,
    min_events: int = 100,
) -> pd.DataFrame:
    """Load new labelled production observations for a controlled retraining.

    The training baseline is intentionally excluded: it was already seen by the
    current champion. Only predictions whose real outcome has matured are valid
    evidence for a challenger-versus-champion comparison.
    """

    if min_rows < 2 or min_events < 1:
        raise ValueError("min_rows must be at least 2 and min_events must be positive.")

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        cursor.execute(
            """
            SELECT selected_features, observed_target
            FROM monitoring.fact_prediction
            WHERE observed_target IS NOT NULL
            ORDER BY target_observed_at, prediction_key
            """
        )
        rows = cursor.fetchall()

    data = _matured_retraining_dataframe(rows)
    event_count = int(data["TARGET"].sum()) if not data.empty else 0
    if len(data) < min_rows or event_count < min_events:
        raise InsufficientMaturedOutcomesError(
            "Not enough matured production outcomes for retraining: "
            f"rows={len(data)} (minimum={min_rows}), "
            f"events={event_count} (minimum={min_events})."
        )
    if data["TARGET"].nunique() != 2:
        raise ValueError("Matured production outcomes must contain both target classes.")

    return data


def load_training_reference_data(
    database_url: str,
    model_name: str,
    model_version: str,
) -> pd.DataFrame:
    """Load a champion baseline only for a non-promoting pipeline simulation."""

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        cursor.execute(
            """
            SELECT observation.selected_features, observation.observed_target
            FROM monitoring.fact_training_observation AS observation
            JOIN monitoring.dim_data_reference AS reference
              ON reference.reference_key = observation.reference_key
            JOIN monitoring.dim_model AS model
              ON model.model_key = reference.model_key
            WHERE model.model_name = %s AND model.model_version = %s
            ORDER BY observation.training_observation_key
            """,
            (model_name, model_version),
        )
        rows = cursor.fetchall()

    if not rows:
        raise ValueError(
            f"No training baseline exists for {model_name} version {model_version}."
        )
    return _matured_retraining_dataframe(rows)
