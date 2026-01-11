import pandas as pd

def extract_from_csv(file_path: str) -> pd.DataFrame:
    """
    Extract healthcare admissions data from a CSV file.

    Args:
        file_path (str): Path to the CSV file.

    Returns:
        pd.DataFrame: Raw data as a pandas DataFrame.
    """
    try:
        # Read CSV
        df = pd.read_csv(file_path)

        # Basic sanity check: show shape and first few rows
        print(f"Data loaded from {file_path}, shape: {df.shape}")
        print(df.head())

        return df

    except FileNotFoundError:
        print(f"Error: File not found at {file_path}")
        raise
    except pd.errors.EmptyDataError:
        print(f"Error: File at {file_path} is empty")
        raise
    except Exception as e:
        print(f"Error reading CSV file at {file_path}: {e}")
        raise


if __name__ == "__main__":
    # Example usage
    csv_file_path = "data/healthcare_admissions.csv"  # adjust path if needed
    df_raw = extract_from_csv(csv_file_path)
