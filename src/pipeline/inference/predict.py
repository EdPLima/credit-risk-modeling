"""Apply the registered model to the project's feature contract."""

from typing import Any

import pandas as pd

REQUIRED_OUTPUT_COLUMNS = {"probability_default", "default_prediction"}


def _coerce_to_registered_input_types(model: Any, data: pd.DataFrame) -> pd.DataFrame:
    """Align CSV-inferred types with the MLflow model signature when available."""

    metadata = getattr(model, "metadata", None)
    if metadata is None:
        return data

    signature = metadata.get_input_schema()
    if signature is None:
        return data

    typed_data = data.copy()
    for column in signature.inputs:
        if column.name not in typed_data:
            continue
        if str(column.type) == "DataType.double":
            typed_data[column.name] = pd.to_numeric(
                typed_data[column.name], errors="coerce"
            ).astype(float)
        elif str(column.type) == "DataType.string":
            typed_data[column.name] = typed_data[column.name].where(
                typed_data[column.name].notna(), None
            ).astype(object)

    return typed_data.loc[:, signature.input_names()]


def predict_model(model: Any, data: pd.DataFrame) -> pd.DataFrame:
    """Create model features and return the prediction contract as a DataFrame."""

    from features.feature_engineering import selection_features

    model_input = _coerce_to_registered_input_types(model, selection_features(data))
    predictions = model.predict(model_input)

    if not isinstance(predictions, pd.DataFrame):
        raise TypeError(
            "The registered model must return a pandas DataFrame with "
            "probability_default and default_prediction."
        )

    missing_columns = REQUIRED_OUTPUT_COLUMNS.difference(predictions.columns)
    if missing_columns:
        missing = ", ".join(sorted(missing_columns))
        raise ValueError(f"Model output is missing required column(s): {missing}")

    if len(predictions) != len(data):
        raise ValueError(
            "Model output row count differs from the input batch row count."
        )

    return predictions.loc[:, ["probability_default", "default_prediction"]].copy()
    return predictions
