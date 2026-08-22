import numpy as np
import pandas as pd

from features.feature_engineering import (
    MODEL_FEATURES,
    _safe_divide,
    selection_features,
)


def test_selection_features_preserves_the_model_contract_order():
    data = pd.DataFrame({feature: [index] for index, feature in enumerate(MODEL_FEATURES)})
    data["UNUSED_COLUMN"] = 99

    selected = selection_features(data)

    assert selected.columns.tolist() == MODEL_FEATURES
    assert "UNUSED_COLUMN" not in selected


def test_safe_divide_returns_nan_when_denominator_is_zero():
    result = _safe_divide(pd.Series([10.0]), pd.Series([0.0]))

    assert np.isnan(result.iloc[0])
