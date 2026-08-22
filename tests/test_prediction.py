import pandas as pd
import pytest

from features.feature_engineering import MODEL_FEATURES
from pipeline.inference.predict import _coerce_to_registered_input_types, predict_model
from pipeline.inference.save_predictions import save_predictions


class ValidModel:
    def predict(self, data: pd.DataFrame) -> pd.DataFrame:
        return pd.DataFrame(
            {"probability_default": [0.2] * len(data), "default_prediction": [0] * len(data)}
        )


class InvalidModel:
    def predict(self, data: pd.DataFrame) -> pd.DataFrame:
        return pd.DataFrame({"score": [0.2] * len(data)})


class FakeColumn:
    def __init__(self, name: str, type_name: str) -> None:
        self.name = name
        self.type = type_name


class FakeSchema:
    def __init__(self) -> None:
        self.inputs = [
            FakeColumn("numeric", "DataType.double"),
            FakeColumn("category", "DataType.string"),
        ]

    def input_names(self) -> list[str]:
        return ["numeric", "category"]


class FakeMetadata:
    def get_input_schema(self) -> FakeSchema:
        return FakeSchema()


class SignedModel:
    metadata = FakeMetadata()


def _contract_input() -> pd.DataFrame:
    return pd.DataFrame({feature: [0] for feature in MODEL_FEATURES})


def test_predict_model_returns_only_the_shared_output_contract():
    result = predict_model(ValidModel(), _contract_input())

    assert result.columns.tolist() == ["probability_default", "default_prediction"]


def test_predict_model_rejects_an_invalid_model_output():
    with pytest.raises(ValueError, match="missing required"):
        predict_model(InvalidModel(), _contract_input())


def test_signature_coercion_converts_csv_integer_columns_to_double():
    data = pd.DataFrame({"numeric": [1], "category": ["cash"]})

    typed_data = _coerce_to_registered_input_types(SignedModel(), data)

    assert str(typed_data["numeric"].dtype) == "float64"
    assert typed_data.columns.tolist() == ["numeric", "category"]


def test_save_predictions_does_not_overwrite_a_published_batch(tmp_path):
    output_path = tmp_path / "scored_batch.csv"

    saved_path = save_predictions(pd.DataFrame({"score": [0.2]}), output_path)

    assert saved_path == str(output_path)
    with pytest.raises(FileExistsError, match="will not be overwritten"):
        save_predictions(pd.DataFrame({"score": [0.3]}), output_path)
