import pandas as pd

from monitoring.drift import assess_feature_drift, categorical_psi, numeric_psi


def test_numeric_psi_is_zero_for_equal_distributions():
    reference = pd.Series([1, 2, 3, 4, 5] * 100)

    assert numeric_psi(reference, reference.copy()) < 1e-10


def test_feature_drift_marks_large_numeric_shift_as_critical():
    reference = pd.Series(range(1, 1_001), dtype=float)
    current = pd.Series(range(10_000, 11_000), dtype=float)

    result = assess_feature_drift(reference, current)

    assert result["psi"] is not None
    assert result["alert_status"] == "critical"


def test_categorical_drift_reports_unseen_values():
    reference = pd.Series(["cash", "cash", "revolving"])
    current = pd.Series(["cash", "new_contract", "new_contract"])

    _, unseen_rate = categorical_psi(reference, current)

    assert unseen_rate == 2 / 3
