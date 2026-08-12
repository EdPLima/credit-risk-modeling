"""
Credit risk model with training, prediction, and threshold optimization.
"""

import pandas as pd

from sklearn.metrics import precision_recall_curve


class CreditRiskModel:

    def __init__(self, model):
        self.model = model
        self.best_threshold = 0.5
        self.threshold_metrics = None

    # Train model
    def train_model(self, X_train, y_train):
        self.model.fit(X_train, y_train)
        return self.model

    # Predict probabilities for the positive class
    def predict_proba(self, X):
        return self.model.predict_proba(X)[:, 1]

    # Find the best threshold based on F1-score
    def find_best_threshold(self, X_val, y_val):

        y_prob_val = self.predict_proba(X_val)

        precision, recall, thresholds = precision_recall_curve(y_val, y_prob_val)

        f1_scores = (
            2 * precision[:-1] * recall[:-1]
            /
            (precision[:-1] + recall[:-1] + 1e-12)
        )

        threshold_metrics = pd.DataFrame({
            "threshold": thresholds,
            "precision": precision[:-1],
            "recall": recall[:-1],
            "f1_score": f1_scores,
        })

        threshold_metrics = (
            threshold_metrics
            .sort_values("f1_score", ascending=False)
            .reset_index(drop=True)
        )

        best_threshold = threshold_metrics.iloc[0]

        self.best_threshold = best_threshold["threshold"]
        self.threshold_metrics = threshold_metrics

        return best_threshold

    # Make predictions using the selected threshold
    def predict(self, X):

        y_prob = self.predict_proba(X)

        return (y_prob >= self.best_threshold).astype(int)