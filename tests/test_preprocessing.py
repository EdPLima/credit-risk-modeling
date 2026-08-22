import numpy as np
import pandas as pd

from pipeline.training.model_training import _build_preprocessor


def test_preprocessor_imputes_missing_values_and_keeps_columns():
    features = pd.DataFrame(
        {
            "income": [100.0, np.nan, 200.0],
            "contract_type": ["cash", None, "revolving"],
        }
    )

    transformed = _build_preprocessor(features).fit_transform(features)

    assert transformed.columns.tolist() == ["income", "contract_type"]
    assert not transformed.isna().any().any()
