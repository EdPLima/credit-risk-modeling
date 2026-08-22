"""Core credit risk model behaviour shared by training and inference."""

from __future__ import annotations

from typing import Any

import pandas as pd
from sklearn.metrics import precision_recall_curve


class CreditRiskModel:
    """Keep model fitting, probabilities, and threshold logic in one place."""

    def __init__(self, model: Any) -> None:
        """Store a fitted-or-unfitted estimator, usually a sklearn Pipeline."""

        self.model = model
        self.best_threshold = 0.5
        self.threshold_metrics: pd.DataFrame | None = None

    def train_model(self, features: pd.DataFrame, target: pd.Series) -> Any:
        """Fit the underlying estimator using training data only."""

        self.model.fit(features, target)
        return self.model

    def predict_proba(self, features: pd.DataFrame) -> pd.Series:
        """Return default probabilities for the positive class."""

        probabilities = self.model.predict_proba(features)[:, 1]
        return pd.Series(
            probabilities,
            index=features.index,
            name="probability_default",
        )

    def find_best_threshold(
        self,
        validation_features: pd.DataFrame,
        validation_target: pd.Series,
    ) -> pd.Series:
        """Select the F1 threshold on validation data, never on test data."""

        probabilities = self.predict_proba(validation_features)
        precision, recall, thresholds = precision_recall_curve(
            validation_target,
            probabilities,
        )

        if len(thresholds) == 0:
            raise ValueError("Validation data must contain both target classes.")

        f1_scores = 2 * precision[:-1] * recall[:-1] / (precision[:-1] + recall[:-1] + 1e-12)
        threshold_metrics = pd.DataFrame(
            {
                "threshold": thresholds,
                "precision": precision[:-1],
                "recall": recall[:-1],
                "f1_score": f1_scores,
            }
        ).sort_values("f1_score", ascending=False, ignore_index=True)

        best_threshold = threshold_metrics.iloc[0]
        self.best_threshold = float(best_threshold["threshold"])
        self.threshold_metrics = threshold_metrics
        return best_threshold

    def classify_probabilities(self, probabilities: pd.Series) -> pd.Series:
        """Apply the validation-selected operating threshold to probabilities."""

        return (probabilities >= self.best_threshold).astype(int).rename("default_prediction")

    def predict(self, features: pd.DataFrame) -> pd.Series:
        """Return decisions using the threshold selected during validation."""

        return self.classify_probabilities(self.predict_proba(features))
