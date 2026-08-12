from inference import predict
import pandas as pd

def predict_model(modelo, data):
    """
    Predicts the output using the provided model and input data.

    Parameters:
    model: The trained model to use for prediction.
    data: The input data for which predictions are to be made.

    Returns:
    predictions: The predicted outputs from the model.
    """
    predictions = modelo.predict(data)
    complete_predictions = pd.DataFrame(data)
    complete_predictions['predictions'] = predictions
    return predictions
