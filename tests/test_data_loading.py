import pytest

from data.load_data import (
    InsufficientMaturedOutcomesError,
    _matured_retraining_dataframe,
)


def test_matured_retraining_dataframe_rebuilds_target_and_features():
    data = _matured_retraining_dataframe(
        [({"AMT_CREDIT": 100.0, "ORGANIZATION_TYPE": "Business"}, 1)]
    )

    assert data.to_dict("records") == [
        {"AMT_CREDIT": 100.0, "ORGANIZATION_TYPE": "Business", "TARGET": 1}
    ]


def test_insufficient_matured_outcomes_is_a_specific_error():
    assert issubclass(InsufficientMaturedOutcomesError, ValueError)

    with pytest.raises(InsufficientMaturedOutcomesError):
        raise InsufficientMaturedOutcomesError("Need more labels")
