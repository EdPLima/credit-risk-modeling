import pandas as pd

from pipeline.training.model_training import CreditRiskBatchModel


class FakeCreditRiskModel:
    def predict_proba(self, features: pd.DataFrame) -> pd.Series:
        return pd.Series([0.7] * len(features), index=features.index)

    def classify_probabilities(self, probabilities: pd.Series) -> pd.Series:
        return (probabilities >= 0.5).astype(int)


def test_batch_model_returns_the_registered_prediction_contract():
    result = CreditRiskBatchModel(FakeCreditRiskModel()).predict(None, pd.DataFrame({"x": [1, 2]}))

    assert result.to_dict("list") == {
        "probability_default": [0.7, 0.7],
        "default_prediction": [1, 1],
    }
