# etl_main.py

from extract import extract_from_csv
from transform import transform_data
from load import load_to_sqlite

# Step 1: Extract
csv_file_path = r"C:\Users\Parul\Desktop\WorkType\HealthcareData_miniproject\ForGitHub\healthcare-etl\data\hospital_admissions.csv"
df_raw = extract_from_csv(csv_file_path)

# Step 2: Transform
df_clean = transform_data(df_raw)  # assumes you have a transform.py

# Step 3: Load
db_path = "database.db"
load_to_sqlite(df_clean, db_path, "admissions")

print("ETL pipeline finished successfully!")
