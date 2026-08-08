import pandas as pd
import nump as np

def process_data(file_path):
    df = pd.read_csv(file_path)
    return df