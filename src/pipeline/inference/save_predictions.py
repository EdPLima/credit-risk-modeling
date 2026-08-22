"""Persist scored batches without overwriting prior results."""

from pathlib import Path

import pandas as pd


def save_predictions(scored_data: pd.DataFrame, output_path: str | Path) -> str:
    """Save a scored batch as CSV or Parquet and return its path."""

    path = Path(output_path)

    if path.exists():
        raise FileExistsError(
            f"Output already exists and will not be overwritten: {path}"
        )

    path.parent.mkdir(parents=True, exist_ok=True)

    if path.suffix.lower() == ".csv":
        scored_data.to_csv(path, index=False)
    elif path.suffix.lower() == ".parquet":
        scored_data.to_parquet(path, index=False)
    else:
        raise ValueError(
            f"Unsupported output format '{path.suffix}'. Use CSV or Parquet."
        )

    return str(path)


def publish_predictions(
    staging_path: str | Path,
    output_path: str | Path,
) -> str:
    """Move a staged scored batch to its final location without overwriting."""

    staging = Path(staging_path)
    output = Path(output_path)

    if not staging.is_file():
        raise FileNotFoundError(f"Staged predictions not found: {staging}")

    if output.exists():
        raise FileExistsError(
            f"Final output already exists and will not be overwritten: {output}"
        )

    output.parent.mkdir(parents=True, exist_ok=True)
    staging.replace(output)

    return str(output)
