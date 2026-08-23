import pandas as pd
import pytest

from data.generate_data_batch import generate_data_batch


def _partitions():
    features = pd.DataFrame(
        {
            "SK_ID_CURR": range(1, 21),
            "AMT_CREDIT": [1000.0] * 20,
            "CONTRACT_TYPE": ["cash", "revolving"] * 10,
        }
    )
    target = pd.Series([0, 1] * 10, name="TARGET")
    return (
        features.iloc[:10], target.iloc[:10],
        features.iloc[10:15], target.iloc[10:15],
        features.iloc[15:], target.iloc[15:],
    )


def test_generate_data_batch_separates_features_from_targets(tmp_path):
    batch = generate_data_batch(
        *_partitions(),
        batch_id="batch_01",
        sample_fraction=0.5,
        input_directory=tmp_path / "input",
        reference_directory=tmp_path / "reference",
        random_state=42,
    )

    scoring_input = pd.read_csv(batch.input_path)
    target_reference = pd.read_csv(batch.target_reference_path)

    assert batch.row_count == 10
    assert "TARGET" not in scoring_input
    assert target_reference.columns.tolist() == ["SK_ID_CURR", "TARGET"]
    assert target_reference["TARGET"].mean() == pytest.approx(0.5)
    assert scoring_input["SK_ID_CURR"].tolist() == target_reference["SK_ID_CURR"].tolist()


def test_generate_data_batch_does_not_overwrite_existing_files(tmp_path):
    arguments = (*_partitions(),)
    generate_data_batch(
        *arguments,
        batch_id="batch_01",
        sample_fraction=0.5,
        input_directory=tmp_path / "input",
        reference_directory=tmp_path / "reference",
    )

    with pytest.raises(FileExistsError):
        generate_data_batch(
            *arguments,
            batch_id="batch_01",
            sample_fraction=0.5,
            input_directory=tmp_path / "input",
            reference_directory=tmp_path / "reference",
        )


def test_generate_data_batch_creates_a_simulation_key_when_the_id_is_absent(tmp_path):
    partitions = list(_partitions())
    partitions[0] = partitions[0].drop(columns="SK_ID_CURR")
    partitions[2] = partitions[2].drop(columns="SK_ID_CURR")
    partitions[4] = partitions[4].drop(columns="SK_ID_CURR")

    batch = generate_data_batch(
        *partitions,
        batch_id="batch_without_source_id",
        sample_fraction=0.5,
        input_directory=tmp_path / "input",
        reference_directory=tmp_path / "reference",
    )

    scoring_input = pd.read_csv(batch.input_path)
    assert scoring_input["SK_ID_CURR"].is_unique
