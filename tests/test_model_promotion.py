from deployment.model_promotion import apply_promotion_decision


class FakeRegistryClient:
    def __init__(self) -> None:
        self.aliases: list[tuple[str, str, str]] = []
        self.tags: list[tuple[str, str, str, str]] = []

    def set_registered_model_alias(self, name: str, alias: str, version: str) -> None:
        self.aliases.append((name, alias, version))

    def set_model_version_tag(self, name: str, version: str, key: str, value: str) -> None:
        self.tags.append((name, version, key, value))


def test_promotes_challenger_and_archives_previous_champion():
    client = FakeRegistryClient()

    champion_version = apply_promotion_decision(client, "credit-risk", "5", "4", True)

    assert champion_version == "5"
    assert ("credit-risk", "champion", "5") in client.aliases
    assert ("credit-risk", "4", "lifecycle_status", "archived") in client.tags


def test_rejected_challenger_keeps_the_current_champion():
    client = FakeRegistryClient()

    champion_version = apply_promotion_decision(client, "credit-risk", "5", "4", False)

    assert champion_version == "4"
    assert ("credit-risk", "champion", "5") not in client.aliases
    assert ("credit-risk", "5", "promotion_decision", "rejected") in client.tags


def test_simulation_never_changes_the_champion_alias():
    client = FakeRegistryClient()

    champion_version = apply_promotion_decision(
        client, "credit-risk", "5", "4", True, promotion_allowed=False
    )

    assert champion_version == "4"
    assert ("credit-risk", "champion", "5") not in client.aliases
    assert ("credit-risk", "5", "promotion_decision", "simulation_blocked") in client.tags
