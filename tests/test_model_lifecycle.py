"""Unit tests for the monitoring lifecycle synchronization contract."""

from __future__ import annotations

from contextlib import contextmanager
from typing import Self

import monitoring.model_lifecycle as lifecycle


class FakeCursor:
    """Minimal cursor that records lifecycle updates without a database."""

    def __init__(self) -> None:
        self.calls: list[tuple[str, tuple[object, ...]]] = []
        self.rowcount = 1

    def execute(self, query: str, parameters: tuple[object, ...]) -> None:
        self.calls.append((query, parameters))


class FakeConnection:
    """Minimal context-managed connection used by the unit test."""

    def __init__(self, cursor: FakeCursor) -> None:
        self._cursor = cursor

    def __enter__(self) -> Self:
        return self

    def __exit__(self, *_: object) -> None:
        return None

    @contextmanager
    def cursor(self):
        yield self._cursor


def test_sync_model_lifecycle_marks_champion_and_challenger(monkeypatch) -> None:
    cursor = FakeCursor()
    monkeypatch.setattr(
        lifecycle.psycopg,
        "connect",
        lambda _: FakeConnection(cursor),
    )

    lifecycle.sync_model_lifecycle(
        database_url="postgresql://monitoring",
        model_name="credit-risk-model",
        champion_version="1",
        challenger_version="2",
    )

    assert len(cursor.calls) == 3
    assert cursor.calls[1][1] == ("credit-risk-model", "1")
    assert cursor.calls[2][1] == ("challenger", "credit-risk-model", "2")
