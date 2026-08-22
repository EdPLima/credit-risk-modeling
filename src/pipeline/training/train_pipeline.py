"""Orchestrate retraining, test-set comparison, registration, and promotion."""

from __future__ import annotations

import os
from dataclasses import dataclass

import mlflow
import pandas as pd
from mlflow.models import infer_signature
from sklearn.model_selection import train_test_split

from config.mlflow import get_mlflow_settings
from deployment.model_promotion import apply_promotion_decision
from monitoring.training_reference import (
    ModelReference,
    anonymize_application_keys,
    fingerprint_dataframe,
    persist_training_reference,
)
from pipeline.inference.load_model import load_model
from pipeline.training.feature_engineering import prepare_training_data
from pipeline.training.model_evaluation import ModelComparison, compare_models
from pipeline.training.model_training import TrainedChallenger, train_challenger


@dataclass(frozen=True)
class RetrainingResult:
    """Summary returned by a complete retraining run."""

    comparison: ModelComparison
    challenger_version: str
    champion_version_before: str
    champion_version_after: str
    challenger_validation_pr_auc: float
    challenger_threshold: float
    training_reference_key: int | None
    challenger_mlflow_run_id: str
    promoted: bool


def _split_data(
    data: pd.DataFrame,
    target_column: str,
    validation_size: float,
    test_size: float,
    random_state: int,
) -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    """Create stratified train, validation, and untouched test partitions."""

    if not 0 < validation_size < 1 or not 0 < test_size < 1:
        raise ValueError("validation_size and test_size must be between 0 and 1.")
    if validation_size + test_size >= 1:
        raise ValueError("validation_size + test_size must be smaller than 1.")

    train_data, holdout_data = train_test_split(
        data,
        test_size=validation_size + test_size,
        stratify=data[target_column],
        random_state=random_state,
    )
    validation_share = validation_size / (validation_size + test_size)
    validation_data, test_data = train_test_split(
        holdout_data,
        test_size=1 - validation_share,
        stratify=holdout_data[target_column],
        random_state=random_state,
    )
    return train_data, validation_data, test_data


def _register_challenger(
    challenger: TrainedChallenger,
    input_example: pd.DataFrame,
    comparison: ModelComparison,
    champion_version_before: str,
    training_features: pd.DataFrame,
    training_target: pd.Series,
    training_application_keys: pd.Series,
    training_credit_amount: pd.Series | None,
    training_probability: pd.Series,
    promotion_allowed: bool,
    execution_mode: str,
) -> tuple[str, str, int | None, str]:
    """Register the challenger and move aliases only after the comparison."""

    settings = get_mlflow_settings()
    mlflow.set_tracking_uri(settings.tracking_uri)
    mlflow.set_experiment(settings.experiment_name)
    client = mlflow.MlflowClient(tracking_uri=settings.tracking_uri)

    output_example = challenger.batch_model.predict(None, input_example)
    signature = infer_signature(input_example, output_example)

    with mlflow.start_run(run_name="lightgbm-challenger-retraining"):
        mlflow.set_tags(
            {
                "stage": "retraining",
                "model_role": "challenger",
                "selection_metric": "PR_AUC",
                "promotion_decision": str(comparison.should_promote).lower(),
                "execution_mode": execution_mode,
            }
        )
        mlflow.log_params(
            {
                "threshold": challenger.threshold,
                **{
                    name: value
                    for name, value in challenger.hyperparameters.items()
                },
            }
        )
        mlflow.log_metrics(
            {
                "validation_pr_auc": challenger.validation_pr_auc,
                "test_champion_pr_auc": comparison.champion_pr_auc,
                "test_challenger_pr_auc": comparison.challenger_pr_auc,
                "test_pr_auc_gain": comparison.pr_auc_gain,
            }
        )
        mlflow.log_dict(
            {
                "champion_pr_auc": comparison.champion_pr_auc,
                "challenger_pr_auc": comparison.challenger_pr_auc,
                "pr_auc_gain": comparison.pr_auc_gain,
                "should_promote": comparison.should_promote,
            },
            "evaluation/champion_vs_challenger.json",
        )

        model_info = mlflow.pyfunc.log_model(
            name="credit-risk-batch-model",
            python_model=challenger.batch_model,
            signature=signature,
            input_example=input_example,
            registered_model_name=settings.registered_model_name,
            await_registration_for=300,
        )

    challenger_version = model_info.registered_model_version
    if challenger_version is None:
        raise RuntimeError("The challenger was logged but not registered in MLflow.")

    challenger_version = str(challenger_version)
    training_reference_key = _persist_training_reference_if_configured(
        challenger=challenger,
        settings=settings,
        challenger_version=challenger_version,
        mlflow_run_id=model_info.run_id,
        training_features=training_features,
        training_target=training_target,
        training_application_keys=training_application_keys,
        training_credit_amount=training_credit_amount,
        training_probability=training_probability,
    )

    champion_version_after = apply_promotion_decision(
        client=client,
        model_name=settings.registered_model_name,
        challenger_version=challenger_version,
        champion_version_before=champion_version_before,
        should_promote=comparison.should_promote,
        champion_alias=settings.champion_alias,
        promotion_allowed=promotion_allowed,
    )

    return (
        challenger_version,
        champion_version_after,
        training_reference_key,
        model_info.run_id,
    )


def _persist_training_reference_if_configured(
    challenger: TrainedChallenger,
    settings: object,
    challenger_version: str,
    mlflow_run_id: str,
    training_features: pd.DataFrame,
    training_target: pd.Series,
    training_application_keys: pd.Series,
    training_credit_amount: pd.Series | None,
    training_probability: pd.Series,
) -> int | None:
    """Persist the baseline only when the monitoring database is configured."""

    database_url = os.getenv("MONITORING_DATABASE_URL")
    if not database_url:
        return None

    salt = os.getenv("MONITORING_KEY_SALT")
    if not salt:
        raise RuntimeError(
            "MONITORING_KEY_SALT is required when MONITORING_DATABASE_URL is set."
        )

    application_keys = anonymize_application_keys(training_application_keys, salt)
    fingerprint_input = training_features.copy()
    fingerprint_input["TARGET"] = training_target

    return persist_training_reference(
        database_url=database_url,
        reference=ModelReference(
            model_name=settings.registered_model_name,
            model_version=challenger_version,
            mlflow_run_id=mlflow_run_id,
            model_uri=(
                f"models:/{settings.registered_model_name}/"
                f"{challenger_version}"
            ),
            threshold=challenger.threshold,
            dataset_fingerprint=fingerprint_dataframe(fingerprint_input),
        ),
        features=training_features,
        target=training_target,
        application_keys=application_keys,
        credit_amount=training_credit_amount,
        baseline_probability=training_probability,
    )


def run_retraining(
    data: pd.DataFrame,
    target_column: str = "TARGET",
    validation_size: float = 0.15,
    test_size: float = 0.15,
    random_state: int = 42,
    promotion_allowed: bool = True,
    execution_mode: str = "production",
) -> RetrainingResult:
    """Train a challenger and promote it only when its test PR-AUC is higher.

    Test data is not used to fit the model, tune hyperparameters, or choose the
    decision threshold. It is used once, for the champion-versus-challenger gate.
    """

    if target_column not in data.columns:
        raise ValueError(f"Retraining data must contain '{target_column}'.")

    train_data, validation_data, test_data = _split_data(
        data=data,
        target_column=target_column,
        validation_size=validation_size,
        test_size=test_size,
        random_state=random_state,
    )
    X_train, y_train = prepare_training_data(train_data, target_column)
    X_validation, y_validation = prepare_training_data(validation_data, target_column)
    X_test, y_test = prepare_training_data(test_data, target_column)

    challenger = train_challenger(
        X_train=X_train,
        y_train=y_train,
        X_validation=X_validation,
        y_validation=y_validation,
    )
    resolved_champion = load_model()
    comparison = compare_models(
        champion_model=resolved_champion.model,
        challenger_model=challenger.batch_model,
        X_test_raw=test_data.drop(columns=target_column),
        X_test_selected=X_test,
        y_test=y_test,
    )
    application_keys = train_data.get("SK_ID_CURR", train_data.index.to_series())
    credit_amount = train_data.get("AMT_CREDIT")
    training_probability = challenger.credit_risk_model.predict_proba(X_train)
    challenger_version, champion_version_after, training_reference_key, challenger_mlflow_run_id = (
        _register_challenger(
        challenger=challenger,
        input_example=X_train.head(5),
        comparison=comparison,
        champion_version_before=resolved_champion.model_version,
        training_features=X_train,
        training_target=y_train,
        training_application_keys=application_keys,
        training_credit_amount=credit_amount,
        training_probability=training_probability,
        promotion_allowed=promotion_allowed,
        execution_mode=execution_mode,
        )
    )

    return RetrainingResult(
        comparison=comparison,
        challenger_version=challenger_version,
        champion_version_before=resolved_champion.model_version,
        champion_version_after=champion_version_after,
        challenger_validation_pr_auc=challenger.validation_pr_auc,
        challenger_threshold=challenger.threshold,
        training_reference_key=training_reference_key,
        challenger_mlflow_run_id=challenger_mlflow_run_id,
        promoted=promotion_allowed and comparison.should_promote,
    )
