"""Create labelled reference batches that simulate production scoring input."""

from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass
from pathlib import Path

import pandas as pd
from sklearn.model_selection import train_test_split


@dataclass(frozen=True)
class GeneratedBatch:
    """Locations and row count for one simulated scoring batch."""

    batch_id: str
    sample_fraction: float
    row_count: int
    input_path: Path
    target_reference_path: Path


def _as_target_series(target: pd.Series | pd.DataFrame, target_column: str) -> pd.Series:
    """Normalize a Series or one-column DataFrame into a named target Series."""

    if isinstance(target, pd.DataFrame):
        if target_column not in target or len(target.columns) != 1:
            raise ValueError(f"Target DataFrame must contain only '{target_column}'.")
        target = target[target_column]

    if target.name != target_column:
        target = target.rename(target_column)
    if target.isna().any() or not set(target.unique()).issubset({0, 1}):
        raise ValueError(f"'{target_column}' must contain only binary, non-null values.")
    return target.reset_index(drop=True)


def generate_data_batch(
    X_train: pd.DataFrame,
    y_train: pd.Series | pd.DataFrame,
    X_validation: pd.DataFrame,
    y_validation: pd.Series | pd.DataFrame,
    X_test: pd.DataFrame,
    y_test: pd.Series | pd.DataFrame,
    *,
    batch_id: str,
    sample_fraction: float,
    input_directory: str | Path = "data/batch_input",
    reference_directory: str | Path = "data/batch_reference",
    target_column: str = "TARGET",
    application_id_column: str = "SK_ID_CURR",
    random_state: int = 42,
) -> GeneratedBatch:
    """Create one stratified scoring batch and a separate target reference file.

    The input file deliberately excludes ``TARGET`` because a real scoring batch
    does not contain the future outcome. The reference file retains only the
    application identifier and target so a later outcome-maturation job can
    calculate supervised performance metrics without leaking labels into scoring.
    """

    if not 0 < sample_fraction <= 1:
        raise ValueError("sample_fraction must be greater than 0 and at most 1.")
    if not batch_id.strip():
        raise ValueError("batch_id must not be empty.")

    partitions = (
        (X_train, _as_target_series(y_train, target_column)),
        (X_validation, _as_target_series(y_validation, target_column)),
        (X_test, _as_target_series(y_test, target_column)),
    )
    for features, target in partitions:
        if len(features) != len(target):
            raise ValueError("Each feature partition must have the same number of target rows.")
        if target_column in features:
            raise ValueError(f"Feature data must not contain '{target_column}'.")

    features = pd.concat([partition[0].reset_index(drop=True) for partition in partitions], ignore_index=True)
    target = pd.concat([partition[1] for partition in partitions], ignore_index=True)
    if application_id_column not in features:
        # The intermediate training partitions intentionally exclude SK_ID_CURR.
        # A simulation-only key preserves the target-to-prediction link and is
        # removed by selection_features before the model receives its contract.
        features[application_id_column] = pd.RangeIndex(start=1, stop=len(features) + 1)

    sampled_features, _, sampled_target, _ = train_test_split(
        features,
        target,
        train_size=sample_fraction,
        stratify=target,
        random_state=random_state,
    )
    sampled_features = sampled_features.reset_index(drop=True)
    sampled_target = sampled_target.reset_index(drop=True)

    input_path = Path(input_directory) / f"{batch_id}.csv"
    target_reference_path = Path(reference_directory) / f"{batch_id}_targets.csv"
    if input_path.exists() or target_reference_path.exists():
        raise FileExistsError(f"Batch '{batch_id}' already exists and will not be overwritten.")

    input_path.parent.mkdir(parents=True, exist_ok=True)
    target_reference_path.parent.mkdir(parents=True, exist_ok=True)
    sampled_features.to_csv(input_path, index=False)
    pd.DataFrame(
        {
            application_id_column: sampled_features[application_id_column],
            target_column: sampled_target,
        }
    ).to_csv(target_reference_path, index=False)

    return GeneratedBatch(
        batch_id=batch_id,
        sample_fraction=sample_fraction,
        row_count=len(sampled_features),
        input_path=input_path,
        target_reference_path=target_reference_path,
    )


def generate_batch_series(
    X_train: pd.DataFrame,
    y_train: pd.Series | pd.DataFrame,
    X_validation: pd.DataFrame,
    y_validation: pd.Series | pd.DataFrame,
    X_test: pd.DataFrame,
    y_test: pd.Series | pd.DataFrame,
    *,
    sample_fractions: Sequence[float],
    batch_prefix: str = "simulated_scoring_batch",
    random_state: int = 42,
) -> list[GeneratedBatch]:
    """Create several independent, reproducible batches with unique identifiers."""

    return [
        generate_data_batch(
            X_train,
            y_train,
            X_validation,
            y_validation,
            X_test,
            y_test,
            batch_id=f"{batch_prefix}_{position:02d}_{int(fraction * 100)}pct",
            sample_fraction=fraction,
            random_state=random_state + position,
        )
        for position, fraction in enumerate(sample_fractions, start=1)
    ]
