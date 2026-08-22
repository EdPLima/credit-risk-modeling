"""Controlled MLflow alias promotion for a registered challenger."""

from __future__ import annotations

from typing import Protocol


class ModelRegistryClient(Protocol):
    """Subset of MLflow client operations required by this module."""

    def set_registered_model_alias(self, name: str, alias: str, version: str) -> None: ...

    def set_model_version_tag(self, name: str, version: str, key: str, value: str) -> None: ...


def apply_promotion_decision(
    client: ModelRegistryClient,
    model_name: str,
    challenger_version: str,
    champion_version_before: str,
    should_promote: bool,
    champion_alias: str = "champion",
    promotion_allowed: bool = True,
) -> str:
    """Record a review decision and promote only an approved challenger.

    The challenger alias is always updated for traceability. The champion alias
    changes only when the comparison gate has approved the new version.
    """

    client.set_registered_model_alias(model_name, "challenger", challenger_version)
    client.set_model_version_tag(
        model_name, challenger_version, "validation_status", "passed"
    )
    if not promotion_allowed:
        client.set_model_version_tag(
            model_name, challenger_version, "promotion_decision", "simulation_blocked"
        )
        return champion_version_before

    client.set_model_version_tag(
        model_name, challenger_version, "promotion_decision", "promoted" if should_promote else "rejected"
    )

    if not should_promote:
        return champion_version_before

    client.set_registered_model_alias(model_name, champion_alias, challenger_version)
    client.set_model_version_tag(
        model_name, champion_version_before, "lifecycle_status", "archived"
    )
    return challenger_version
