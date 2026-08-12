import pandas as pd
import numpy as np

def process_data(file_path):
    df = pd.read_csv(file_path)
    return df