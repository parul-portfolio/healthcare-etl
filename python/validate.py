def run_quality_checks(df):
    checks = {
        "missing_patient_id": df['mrd_no_'].isna().sum(),
        "invalid_admission_dates": df['d_o_a'].isna().sum(),
        "negative_stays": (df['duration_of_stay'] <= 0).sum(),
        "duplicate_rows": df.duplicated().sum()
    }

    for check, value in checks.items():
        print(f"{check}: {value}")

    return checks
