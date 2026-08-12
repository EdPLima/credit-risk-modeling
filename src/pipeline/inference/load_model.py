import mlflow
import yaml


def load_model(config_path: str = "mlflow_config.yml"):
    """
    Load the production model registered in MLflow.
    Parameters
    ----------
    config_path : str
        Path to the MLflow configuration YAML file.
    Returns
    -------
    model
        Loaded MLflow model.
    """

    with open(config_path, "r") as file:
        config = yaml.safe_load(file)

    mlflow_config = config["mlflow"]
    mlflow.set_tracking_uri(mlflow_config["tracking_uri"])

    model_name = mlflow_config["registered_model_name"]
    alias = mlflow_config["alias"]
    model_uri = f"models:/{model_name}@{alias}"

    return mlflow.pyfunc.load_model(model_uri=model_uri)
