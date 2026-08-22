"""Pure calculations used by batch monitoring and Power BI facts."""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np
import pandas as pd
from scipy.stats import ks_2samp

EPSILON = 1e-6
MISSING_CATEGORY = "__MISSING__"


@dataclass(frozen=True)
class DriftThresholds:
    """Effect-size thresholds used to classify monitoring alerts."""

    psi_warning: float = 0.10
    psi_critical: float = 0.25
    ks_warning: float = 0.10
    ks_critical: float = 0.20
    missing_rate_delta_warning: float = 0.03
    missing_rate_delta_critical: float = 0.10
    unseen_category_warning: float = 0.01
    unseen_category_critical: float = 0.05


DEFAULT_THRESHOLDS = DriftThresholds()


def profile_series(values: pd.Series) -> dict[str, object]:
    """Return stable feature statistics for a reference or scored batch."""

    row_count = len(values)
    missing_count = int(values.isna().sum())
    profile: dict[str, object] = {
        "row_count": row_count,
        "missing_count": missing_count,
        "missing_rate": missing_count / row_count if row_count else 0.0,
        "distinct_count": int(values.nunique(dropna=True)),
        "minimum_value": None,
        "maximum_value": None,
        "mean_value": None,
        "median_value": None,
        "standard_deviation": None,
        "percentile_05": None,
        "percentile_25": None,
        "percentile_75": None,
        "percentile_95": None,
        "category_distribution": None,
    }

    if pd.api.types.is_numeric_dtype(values):
        numeric_values = values.dropna()
        if not numeric_values.empty:
            profile.update(
                {
                    "minimum_value": float(numeric_values.min()),
                    "maximum_value": float(numeric_values.max()),
                    "mean_value": float(numeric_values.mean()),
                    "median_value": float(numeric_values.median()),
                    "standard_deviation": float(numeric_values.std(ddof=0)),
                    "percentile_05": float(numeric_values.quantile(0.05)),
                    "percentile_25": float(numeric_values.quantile(0.25)),
                    "percentile_75": float(numeric_values.quantile(0.75)),
                    "percentile_95": float(numeric_values.quantile(0.95)),
                }
            )
    else:
        profile["category_distribution"] = category_distribution(values)

    return profile


def category_distribution(values: pd.Series, top_categories: int = 50) -> dict[str, float]:
    """Return category shares while grouping a long tail into ``__other__``."""

    normalized = values.fillna(MISSING_CATEGORY).astype(str)
    shares = normalized.value_counts(normalize=True)
    top_shares = shares.head(top_categories)
    result = {category: float(share) for category, share in top_shares.items()}
    remaining_share = float(shares.iloc[top_categories:].sum())
    if remaining_share:
        result["__other__"] = remaining_share
    return result


def population_stability_index(reference_share: np.ndarray, current_share: np.ndarray) -> float:
    """Calculate PSI after both populations were assigned to the same bins."""

    reference = np.clip(np.asarray(reference_share, dtype=float), EPSILON, None)
    current = np.clip(np.asarray(current_share, dtype=float), EPSILON, None)
    return float(np.sum((current - reference) * np.log(current / reference)))


def numeric_psi(reference: pd.Series, current: pd.Series, bins: int = 10) -> float | None:
    """Calculate PSI using quantile bins learned only from the reference data."""

    reference_values = pd.to_numeric(reference, errors="coerce").dropna().to_numpy()
    current_values = pd.to_numeric(current, errors="coerce").dropna().to_numpy()
    if len(reference_values) < 2 or len(current_values) == 0:
        return None

    edges = np.unique(np.quantile(reference_values, np.linspace(0, 1, bins + 1)))
    if len(edges) < 2:
        return 0.0

    edges[0] = -np.inf
    edges[-1] = np.inf
    reference_counts, _ = np.histogram(reference_values, bins=edges)
    current_counts, _ = np.histogram(current_values, bins=edges)
    return population_stability_index(reference_counts / len(reference_values), current_counts / len(current_values))


def categorical_psi(reference: pd.Series, current: pd.Series) -> tuple[float | None, float]:
    """Calculate categorical PSI and the share of unseen current categories."""

    reference_values = reference.fillna(MISSING_CATEGORY).astype(str)
    current_values = current.fillna(MISSING_CATEGORY).astype(str)
    if reference_values.empty or current_values.empty:
        return None, 0.0

    reference_categories = set(reference_values.unique())
    unseen_rate = float((~current_values.isin(reference_categories)).mean())
    categories = sorted(reference_categories.union(set(current_values.unique())))
    reference_share = reference_values.value_counts(normalize=True).reindex(categories, fill_value=0)
    current_share = current_values.value_counts(normalize=True).reindex(categories, fill_value=0)
    return population_stability_index(reference_share.to_numpy(), current_share.to_numpy()), unseen_rate


def _alert_status(
    psi: float | None,
    ks_statistic: float | None,
    missing_rate_delta: float,
    unseen_category_rate: float | None,
    thresholds: DriftThresholds,
) -> str:
    """Classify drift by practical effect size, not only statistical significance."""

    critical = (
        (psi is not None and psi >= thresholds.psi_critical)
        or (ks_statistic is not None and ks_statistic >= thresholds.ks_critical)
        or abs(missing_rate_delta) >= thresholds.missing_rate_delta_critical
        or (
            unseen_category_rate is not None
            and unseen_category_rate >= thresholds.unseen_category_critical
        )
    )
    if critical:
        return "critical"

    warning = (
        (psi is not None and psi >= thresholds.psi_warning)
        or (ks_statistic is not None and ks_statistic >= thresholds.ks_warning)
        or abs(missing_rate_delta) >= thresholds.missing_rate_delta_warning
        or (
            unseen_category_rate is not None
            and unseen_category_rate >= thresholds.unseen_category_warning
        )
    )
    return "warning" if warning else "stable"


def assess_feature_drift(
    reference: pd.Series,
    current: pd.Series,
    thresholds: DriftThresholds = DEFAULT_THRESHOLDS,
) -> dict[str, object]:
    """Profile one feature and compare it with the labelled training reference."""

    profile = profile_series(current)
    missing_rate_delta = float(profile["missing_rate"]) - float(reference.isna().mean())
    is_numeric = pd.api.types.is_numeric_dtype(reference) and pd.api.types.is_numeric_dtype(current)

    if is_numeric:
        psi = numeric_psi(reference, current)
        reference_values = reference.dropna()
        current_values = current.dropna()
        if reference_values.empty or current_values.empty:
            ks_statistic, ks_p_value = None, None
        else:
            result = ks_2samp(reference_values, current_values)
            ks_statistic, ks_p_value = float(result.statistic), float(result.pvalue)
        unseen_category_rate = None
    else:
        psi, unseen_category_rate = categorical_psi(reference, current)
        ks_statistic, ks_p_value = None, None

    return {
        **profile,
        "psi": psi,
        "ks_statistic": ks_statistic,
        "ks_p_value": ks_p_value,
        "unseen_category_rate": unseen_category_rate,
        "missing_rate_delta": missing_rate_delta,
        "alert_status": _alert_status(
            psi,
            ks_statistic,
            missing_rate_delta,
            unseen_category_rate,
            thresholds,
        ),
    }
