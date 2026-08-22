"""Shared MLflow settings used by training and inference pipelines."""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml

DEFAULT_CONFIG_PATH = Path(__file__).with_name("mlflow_config.yml")


@dataclass(frozen=True)
class MLflowSettings:
    """Immutable MLflow values read from the project configuration."""

    tracking_uri: str
    experiment_name: str
    registered_model_name: str
    champion_alias: str


def get_mlflow_settings(
    config_path: str | Path | None = None,
) -> MLflowSettings:
    """Read MLflow settings once and allow an environment URI override."""

    path = Path(config_path) if config_path else DEFAULT_CONFIG_PATH
    if not path.is_file():
        raise FileNotFoundError(f"MLflow configuration file not found: {path}")

    with path.open("r", encoding="utf-8") as file:
        config: dict[str, Any] = yaml.safe_load(file) or {}

    mlflow_config = config.get("mlflow")
    if not isinstance(mlflow_config, dict):
        raise TypeError("The configuration must contain an 'mlflow' section.")

    required_keys = {
        "tracking_uri",
        "experiment_name",
        "registered_model_name",
        "alias",
    }
    missing_keys = required_keys.difference(mlflow_config)
    if missing_keys:
        missing = ", ".join(sorted(missing_keys))
        raise ValueError(f"Missing MLflow configuration keys: {missing}")

    return MLflowSettings(
        tracking_uri=os.getenv(
            "MLFLOW_TRACKING_URI",
            str(mlflow_config["tracking_uri"]),
        ),
        experiment_name=str(mlflow_config["experiment_name"]),
        registered_model_name=str(mlflow_config["registered_model_name"]),
        champion_alias=str(mlflow_config["alias"]),
    )
