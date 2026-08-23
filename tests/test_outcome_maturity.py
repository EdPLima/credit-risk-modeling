import pandas as pd
import pytest

from monitoring.outcome_maturity import load_outcome_reference


def test_load_outcome_reference_accepts_a_valid_two_column_file(tmp_path):
    path = tmp_path / "targets.csv"
    pd.DataFrame({"SK_ID_CURR": [1, 2], "TARGET": [0, 1]}).to_csv(path, index=False)

    result = load_outcome_reference(path)

    assert result.to_dict("records") == [
        {"SK_ID_CURR": 1, "TARGET": 0},
        {"SK_ID_CURR": 2, "TARGET": 1},
    ]


def test_load_outcome_reference_rejects_duplicate_application_ids(tmp_path):
    path = tmp_path / "targets.csv"
    pd.DataFrame({"SK_ID_CURR": [1, 1], "TARGET": [0, 1]}).to_csv(path, index=False)

    with pytest.raises(ValueError, match="duplicate"):
        load_outcome_reference(path)
