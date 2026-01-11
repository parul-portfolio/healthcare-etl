import sqlite3
import pandas as pd

def load_to_sqlite(df: pd.DataFrame, db_path: str, table_name: str, if_exists: str = "replace"):
    """
    Load a pandas DataFrame into a SQLite database table.

    Args:
        df (pd.DataFrame): The DataFrame to load.
        db_path (str): Path to the SQLite database file.
        table_name (str): Name of the table to create/replace.
        if_exists (str, optional): What to do if the table exists. Options: 'fail', 'replace', 'append'.
                                   Default is 'replace'.
    """
    try:
        # Connect to SQLite database
        conn = sqlite3.connect(db_path)

        # Load DataFrame into SQLite
        df.to_sql(table_name, conn, if_exists=if_exists, index=False)
        print(f"Loaded {df.shape[0]} rows into table '{table_name}' in database '{db_path}'.")

    except Exception as e:
        print(f"Error loading data into SQLite: {e}")
        raise

    finally:
        conn.close()
