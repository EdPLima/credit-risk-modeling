"""Persist the labelled training baseline used for future drift monitoring."""

from __future__ import annotations

import hashlib
import itertools
import json
from collections.abc import Iterable
from dataclasses import dataclass

import pandas as pd
import psycopg
from psycopg.types.json import Jsonb

from monitoring.drift import profile_series


@dataclass(frozen=True)
class ModelReference:
    """Metadata that links a training baseline to one MLflow model version."""

    model_name: str
    model_version: str
    mlflow_run_id: str
    model_uri: str
    threshold: float
    dataset_fingerprint: str
    reference_name: str = "training"


def fingerprint_dataframe(data: pd.DataFrame) -> str:
    """Create a stable fingerprint without persisting the source file itself."""

    row_hashes = pd.util.hash_pandas_object(data, index=True).values.tobytes()
    return hashlib.sha256(row_hashes).hexdigest()


def anonymize_application_keys(
    application_keys: Iterable[object],
    salt: str,
) -> list[str]:
    """Create stable non-identifying keys for monitoring facts."""

    if not salt:
        raise ValueError("A non-empty monitoring key salt is required.")

    return [
        hashlib.sha256(f"{salt}:{application_key}".encode()).hexdigest()
        for application_key in application_keys
    ]


def _json_records(
    features: pd.DataFrame,
    chunk_size: int = 5_000,
) -> Iterable[dict[str, object]]:
    """Yield JSON-safe records in chunks to keep large training loads bounded."""

    for start in range(0, len(features), chunk_size):
        chunk = features.iloc[start : start + chunk_size]
        yield from json.loads(chunk.to_json(orient="records", date_format="iso"))


def _feature_type(values: pd.Series) -> str:
    """Map pandas data types to the monitoring dimension values."""

    if pd.api.types.is_bool_dtype(values):
        return "boolean"
    if pd.api.types.is_datetime64_any_dtype(values):
        return "date"
    if pd.api.types.is_numeric_dtype(values):
        return "numeric"
    if pd.api.types.is_string_dtype(values) or pd.api.types.is_categorical_dtype(values):
        return "categorical"
    return "text"


def persist_training_reference(
    database_url: str,
    reference: ModelReference,
    features: pd.DataFrame,
    target: pd.Series,
    application_keys: Iterable[str],
    credit_amount: pd.Series | None = None,
    baseline_probability: pd.Series | None = None,
) -> int:
    """Save labelled selected features and their baseline profiles in PostgreSQL.

    The function is idempotent for the same model version and dataset fingerprint.
    `application_keys` must already be anonymized before this function is called.
    """

    application_keys = list(application_keys)
    if len(features) != len(target) or len(features) != len(application_keys):
        raise ValueError("Features, target, and application keys must have the same length.")
    if credit_amount is not None and len(credit_amount) != len(features):
        raise ValueError("credit_amount must have the same length as features.")
    if baseline_probability is not None and len(baseline_probability) != len(features):
        raise ValueError("baseline_probability must have the same length as features.")

    credit_values: Iterable[object]
    if credit_amount is not None:
        credit_values = credit_amount
    else:
        credit_values = itertools.repeat(None)

    probability_values: Iterable[object]
    if baseline_probability is not None:
        probability_values = baseline_probability
    else:
        probability_values = itertools.repeat(None)

    with psycopg.connect(database_url) as connection:  # noqa: SIM117
        with connection.cursor() as cursor:
            cursor.execute(
                """
                INSERT INTO monitoring.dim_model (
                    model_name, model_version, mlflow_run_id, model_uri,
                    decision_threshold, lifecycle_status
                )
                VALUES (%s, %s, %s, %s, %s, 'registered')
                ON CONFLICT (model_name, model_version) DO UPDATE
                SET mlflow_run_id = EXCLUDED.mlflow_run_id,
                    model_uri = EXCLUDED.model_uri,
                    decision_threshold = EXCLUDED.decision_threshold
                RETURNING model_key
                """,
                (
                    reference.model_name,
                    reference.model_version,
                    reference.mlflow_run_id,
                    reference.model_uri,
                    reference.threshold,
                ),
            )
            model_key = int(cursor.fetchone()[0])

            cursor.execute(
                """
                INSERT INTO monitoring.dim_data_reference (
                    model_key, reference_name, dataset_fingerprint, row_count,
                    target_event_rate
                )
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (model_key, reference_name, dataset_fingerprint)
                DO UPDATE SET row_count = EXCLUDED.row_count
                RETURNING reference_key
                """,
                (
                    model_key,
                    reference.reference_name,
                    reference.dataset_fingerprint,
                    len(features),
                    float(target.mean()),
                ),
            )
            reference_key = int(cursor.fetchone()[0])

            cursor.execute(
                "SELECT COUNT(*) FROM monitoring.fact_training_observation WHERE reference_key = %s",
                (reference_key,),
            )
            has_observations = cursor.fetchone()[0] > 0

            feature_keys: dict[str, int] = {}
            for feature_name in features.columns:
                cursor.execute(
                    """
                    INSERT INTO monitoring.dim_feature (
                        feature_name, data_type, source_layer, is_selected_feature
                    )
                    VALUES (%s, %s, 'selected', TRUE)
                    ON CONFLICT (feature_name) DO UPDATE
                    SET data_type = EXCLUDED.data_type,
                        is_selected_feature = TRUE,
                        is_active = TRUE
                    RETURNING feature_key
                    """,
                    (feature_name, _feature_type(features[feature_name])),
                )
                feature_keys[feature_name] = int(cursor.fetchone()[0])

            if has_observations:
                if baseline_probability is not None:
                    cursor.executemany(
                        """
                        UPDATE monitoring.fact_training_observation
                        SET baseline_probability_default = %s
                        WHERE reference_key = %s AND application_key = %s
                        """,
                        (
                            (float(probability), reference_key, application_key)
                            for application_key, probability in zip(
                                application_keys, baseline_probability, strict=True
                            )
                        ),
                    )
                return reference_key

            observation_rows = (
                (
                    reference_key, model_key, application_key, int(observed_target),
                    None if pd.isna(amount) else float(amount),
                    None if pd.isna(probability) else float(probability), Jsonb(feature_record),
                )
                for application_key, observed_target, amount, probability, feature_record in zip(
                    application_keys,
                    target,
                    credit_values,
                    probability_values,
                    _json_records(features),
                    strict=True,
                )
            )
            cursor.executemany(
                """
                INSERT INTO monitoring.fact_training_observation (
                    reference_key, model_key, application_key, observed_target,
                    credit_amount, baseline_probability_default, selected_features
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s)
                """,
                observation_rows,
            )

            cursor.execute(
                "SELECT segment_key FROM monitoring.dim_segment WHERE segment_type = 'portfolio' AND segment_value = 'all'"
            )
            segment_key = int(cursor.fetchone()[0])

            for feature_name, feature_key in feature_keys.items():
                profile = profile_series(features[feature_name])
                cursor.execute(
                    """
                    INSERT INTO monitoring.fact_training_feature_profile (
                        reference_key, model_key, feature_key, segment_key,
                        row_count, missing_count, missing_rate, distinct_count,
                        minimum_value, maximum_value, mean_value, median_value,
                        standard_deviation, percentile_05, percentile_25,
                        percentile_75, percentile_95, category_distribution
                    )
                    VALUES (
                        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                        %s, %s, %s, %s, %s, %s
                    )
                    ON CONFLICT (reference_key, feature_key, segment_key) DO NOTHING
                    """,
                    (
                        reference_key,
                        model_key,
                        feature_key,
                        segment_key,
                        profile["row_count"],
                        profile["missing_count"],
                        profile["missing_rate"],
                        profile["distinct_count"],
                        profile["minimum_value"],
                        profile["maximum_value"],
                        profile["mean_value"],
                        profile["median_value"],
                        profile["standard_deviation"],
                        profile["percentile_05"],
                        profile["percentile_25"],
                        profile["percentile_75"],
                        profile["percentile_95"],
                        Jsonb(profile["category_distribution"])
                        if profile["category_distribution"] is not None
                        else None,
                    ),
                )

    return reference_key
