import pandas as pd

from monitoring.model_performance import calculate_performance_metrics


def test_calculate_performance_metrics_includes_financial_indicators():
    outcomes = pd.DataFrame(
        {
            "observed_target": [1, 0, 1, 0],
            "probability_default": [0.9, 0.8, 0.2, 0.1],
            "credit_amount": [100.0, 300.0, 50.0, 80.0],
        }
    )

    metrics = calculate_performance_metrics(outcomes, threshold=0.5)

    assert metrics["labeled_row_count"] == 4
    assert metrics["captured_credit_amount"] == 100.0
    assert metrics["missed_credit_amount"] == 50.0
    assert metrics["pr_auc"] is not None
