"""Train a LightGBM challenger using the production feature contract."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Any

import pandas as pd
import yaml
from lightgbm import LGBMClassifier
from mlflow.pyfunc import PythonModel, PythonModelContext
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.metrics import average_precision_score
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OrdinalEncoder, StandardScaler

from models.credit_risk_model import CreditRiskModel

DEFAULT_MODEL_CONFIG_PATH = (
    Path(__file__).resolve().parents[2] / "config" / "model_config.yml"
)


class CreditRiskBatchModel(PythonModel):
    """Expose the same selected-feature input and output contract in MLflow."""

    def __init__(self, credit_risk_model: CreditRiskModel) -> None:
        """Adapt the domain model to the MLflow batch prediction contract."""

        self.credit_risk_model = credit_risk_model

    def predict(
        self,
        context: PythonModelContext,
        model_input: pd.DataFrame,
        params: dict[str, Any] | None = None,
    ) -> pd.DataFrame:
        """Return the probability and decision columns expected by batch scoring."""

        probability_default = self.credit_risk_model.predict_proba(model_input)
        default_prediction = self.credit_risk_model.classify_probabilities(
            probability_default
        )

        return pd.DataFrame(
            {
                "probability_default": probability_default.to_numpy(),
                "default_prediction": default_prediction.to_numpy(),
            },
            index=model_input.index,
        )


@dataclass(frozen=True)
class TrainedChallenger:
    """Artifacts needed to evaluate and register a candidate model."""

    batch_model: CreditRiskBatchModel
    credit_risk_model: CreditRiskModel
    validation_pr_auc: float
    threshold: float
    hyperparameters: dict[str, Any]


def _read_hyperparameters(config_path: str | Path | None = None,) -> dict[str, Any]:
    """Read the reviewed LightGBM parameters from the YAML configuration."""

    path = Path(config_path) if config_path else DEFAULT_MODEL_CONFIG_PATH
    with path.open("r", encoding="utf-8") as file:
        config = yaml.safe_load(file) or {}

    parameters = config.get("model", {}).get("hyperparameters")
    if not isinstance(parameters, dict):
        raise TypeError("model_config.yml must define model.hyperparameters.")

    return parameters.copy()


def _build_preprocessor(features: pd.DataFrame) -> ColumnTransformer:
    """Create the same numeric scaling and safe category encoding used in training."""

    categorical_columns = features.select_dtypes(
        include=["object", "category", "bool"]
    ).columns.tolist()
    numeric_columns = features.columns.difference(categorical_columns).tolist()

    transformers: list[tuple[str, Pipeline, list[str]]] = []
    if numeric_columns:
        transformers.append(
            (
                "numeric",
                Pipeline(
                    [
                        ("imputer", SimpleImputer(strategy="median")),
                        ("scaler", StandardScaler()),
                    ]
                ),
                numeric_columns,
            )
        )
    if categorical_columns:
        transformers.append(
            (
                "categorical",
                Pipeline(
                    [
                        ("imputer", SimpleImputer(strategy="most_frequent")),
                        (
                            "encoder",
                            OrdinalEncoder(
                                handle_unknown="use_encoded_value",
                                unknown_value=-1,
                            ),
                        )
                    ]
                ),
                categorical_columns,
            )
        )

    if not transformers:
        raise ValueError("The training dataset has no usable feature columns.")

    return ColumnTransformer(
        transformers=transformers,
        remainder="drop",
        verbose_feature_names_out=False,
    ).set_output(transform="pandas")


def train_challenger(
    X_train: pd.DataFrame,
    y_train: pd.Series,
    X_validation: pd.DataFrame,
    y_validation: pd.Series,
    config_path: str | Path | None = None,
) -> TrainedChallenger:
    """Fit a challenger and select its threshold without accessing test data."""

    parameters = _read_hyperparameters(config_path)
    parameters["scale_pos_weight"] = float((y_train == 0).sum() / (y_train == 1).sum())

    classifier = LGBMClassifier(**parameters)
    pipeline = Pipeline(
        [
            ("preprocessor", _build_preprocessor(X_train)),
            ("model", classifier),
        ]
    )
    credit_risk_model = CreditRiskModel(pipeline)
    credit_risk_model.train_model(X_train, y_train)

    validation_probability = credit_risk_model.predict_proba(X_validation)
    validation_pr_auc = float(
        average_precision_score(y_validation, validation_probability)
    )
    threshold = float(
        credit_risk_model.find_best_threshold(X_validation, y_validation)["threshold"]
    )

    return TrainedChallenger(
        batch_model=CreditRiskBatchModel(credit_risk_model),
        credit_risk_model=credit_risk_model,
        validation_pr_auc=validation_pr_auc,
        threshold=threshold,
        hyperparameters=parameters,
    )
