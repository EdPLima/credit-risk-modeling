"""Resolve and load the production model registered in MLflow."""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import mlflow
import yaml

DEFAULT_CONFIG_PATH = (Path(__file__).resolve().parents[2] / "config" / "mlflow_config.yml")


@dataclass(frozen=True)
class ResolvedModel:
    """Model object and immutable metadata resolved from an MLflow alias."""

    model: Any
    model_name: str
    alias: str
    model_uri: str
    model_version: str
    run_id: str


def _read_mlflow_config(config_path: str | Path | None = None) -> dict[str, Any]:
    """Read and validate the MLflow section of the project configuration."""

    path = Path(config_path) if config_path else DEFAULT_CONFIG_PATH

    if not path.is_file():
        raise FileNotFoundError(f"MLflow configuration file not found: {path}")

    with path.open("r", encoding="utf-8") as file:
        config = yaml.safe_load(file) or {}

    mlflow_config = config.get("mlflow")
    if not isinstance(mlflow_config, dict):
        raise TypeError("The configuration must contain an 'mlflow' mapping.")

    required_keys = {"tracking_uri", "registered_model_name", "alias"}
    missing_keys = required_keys.difference(mlflow_config)
    if missing_keys:
        missing = ", ".join(sorted(missing_keys))
        raise ValueError(f"Missing MLflow configuration key(s): {missing}")

    return mlflow_config


def load_model(config_path: str | Path | None = None) -> ResolvedModel:
    """Load the configured MLflow alias and capture its resolved version.

    MLFLOW_TRACKING_URI takes precedence over the YAML value. This keeps the
    same code portable across local development, Docker, and Airflow.
    """

    config = _read_mlflow_config(config_path)

    tracking_uri = os.getenv("MLFLOW_TRACKING_URI", config["tracking_uri"])
    model_name = config["registered_model_name"]
    alias = config["alias"]
    model_uri = f"models:/{model_name}@{alias}"

    mlflow.set_tracking_uri(tracking_uri)
    client = mlflow.MlflowClient(tracking_uri=tracking_uri)

    try:
        model_version = client.get_model_version_by_alias(model_name, alias)
    except Exception as error:
        raise RuntimeError(
            f"Could not resolve alias '{alias}' for model '{model_name}'."
        ) from error

    try:
        model = mlflow.pyfunc.load_model(model_uri=model_uri)
    except Exception as error:
        raise RuntimeError(f"Could not load MLflow model from '{model_uri}'.") from error

    return ResolvedModel(
        model=model,
        model_name=model_name,
        alias=alias,
        model_uri=model_uri,
        model_version=str(model_version.version),
        run_id=model_version.run_id,
    )
