import pandas as pd

from monitoring.drift import assess_feature_drift


def test_missingness_change_generates_a_warning():
    reference = pd.Series([1.0] * 100)
    current = pd.Series([1.0] * 95 + [None] * 5)

    result = assess_feature_drift(reference, current)

    assert result["missing_rate_delta"] == 0.05
    assert result["alert_status"] == "warning"
