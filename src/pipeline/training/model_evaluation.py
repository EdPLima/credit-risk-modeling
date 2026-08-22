"""Evaluate the champion and challenger on the same untouched test set."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import pandas as pd
from sklearn.metrics import average_precision_score

from pipeline.inference.predict import predict_model
from pipeline.training.model_training import CreditRiskBatchModel


@dataclass(frozen=True)
class ModelComparison:
    """Test-set PR-AUC values and the resulting promotion decision."""

    champion_pr_auc: float
    challenger_pr_auc: float
    pr_auc_gain: float
    should_promote: bool


def _probability_from_output(predictions: pd.DataFrame) -> pd.Series:
    """Read the probability column from the shared prediction contract."""

    column = "probability_default"
    if column not in predictions.columns:
        raise ValueError(f"Model output must contain '{column}'.")
    return predictions[column]


def compare_models(
    champion_model: Any,
    challenger_model: CreditRiskBatchModel,
    X_test_raw: pd.DataFrame,
    X_test_selected: pd.DataFrame,
    y_test: pd.Series,
) -> ModelComparison:

    """Compare both models once on the same labelled test partition.

    The champion receives raw data through the inference module. The challenger
    receives the selected features because this is its registered input contract.
    """

    champion_output = predict_model(champion_model, X_test_raw)
    challenger_output = challenger_model.predict(None, X_test_selected)

    champion_pr_auc = float(average_precision_score(y_test, _probability_from_output(champion_output)))
    challenger_pr_auc = float(average_precision_score(y_test, _probability_from_output(challenger_output)))
    pr_auc_gain = challenger_pr_auc - champion_pr_auc

    return ModelComparison(
        champion_pr_auc=champion_pr_auc,
        challenger_pr_auc=challenger_pr_auc,
        pr_auc_gain=pr_auc_gain,
        should_promote=challenger_pr_auc > champion_pr_auc,
    )
