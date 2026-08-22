"""Prepare the labelled training dataset for the model contract."""

from __future__ import annotations

import pandas as pd

from features.feature_engineering import selection_features


def prepare_training_data(
    data: pd.DataFrame,
    target_column: str = "TARGET",
) -> tuple[pd.DataFrame, pd.Series]:
    """Separate the target and create the 67 selected model features.

    The target is removed before feature engineering. This prevents it from
    becoming an accidental model input during a retraining run.
    """

    if target_column not in data.columns:
        raise ValueError(
            f"Retraining data must contain the target column '{target_column}'."
        )

    target = data[target_column].copy()
    unique_values = set(target.dropna().unique())
    if not unique_values.issubset({0, 1}) or len(unique_values) != 2:
        raise ValueError(
            f"'{target_column}' must contain both binary classes 0 and 1."
        )

    features = selection_features(data.drop(columns=target_column))
    return features, target
