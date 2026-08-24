"""Keep the monitoring model dimension aligned with MLflow aliases."""

from typing import Literal

import psycopg

ChallengerStatus = Literal["challenger", "rejected"]


def sync_model_lifecycle(
    database_url: str,
    model_name: str,
    champion_version: str,
    challenger_version: str | None = None,
    challenger_status: ChallengerStatus = "challenger",
) -> None:
    """Synchronize the model lifecycle stored for monitoring.

    MLflow remains the source of truth for aliases. This function only mirrors
    the resolved champion and the latest challenger decision in PostgreSQL so
    Power BI can display their operational status reliably.
    """

    with psycopg.connect(database_url) as connection, connection.cursor() as cursor:
        cursor.execute(
            """
            UPDATE monitoring.dim_model
            SET lifecycle_status = 'archived'
            WHERE model_name = %s
              AND model_version <> %s
              AND lifecycle_status = 'champion'
            """,
            (model_name, champion_version),
        )
        cursor.execute(
            """
            UPDATE monitoring.dim_model
            SET lifecycle_status = 'champion'
            WHERE model_name = %s AND model_version = %s
            """,
            (model_name, champion_version),
        )
        if cursor.rowcount != 1:
            raise ValueError(
                f"Model {model_name} version {champion_version} is not monitored."
            )

        if challenger_version and challenger_version != champion_version:
            cursor.execute(
                """
                UPDATE monitoring.dim_model
                SET lifecycle_status = %s
                WHERE model_name = %s AND model_version = %s
                """,
                (challenger_status, model_name, challenger_version),
            )
            if cursor.rowcount != 1:
                raise ValueError(
                    f"Model {model_name} version {challenger_version} is not monitored."
                )
