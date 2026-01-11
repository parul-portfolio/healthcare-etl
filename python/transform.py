import pandas as pd
import numpy as np

def transform_data(df: pd.DataFrame) -> pd.DataFrame:
    # --- DATE HANDLING ---
    df = df.rename(columns=lambda x: x.strip().lower().replace(" ", "_").replace(".", "_"))
    df['d_o_a'] = pd.to_datetime(df['d_o_a'], errors='coerce')
    df['d_o_d'] = pd.to_datetime(df['d_o_d'], errors='coerce')

    # --- REMOVE DUPLICATES ---
    df = df.drop_duplicates(subset=['mrd_no_', 'd_o_a'])

    # --- NUMERIC CLEANING ---
    numeric_cols = [
        'age', 'duration_of_stay', 'duration_of_intensive_unit_stay',
        'hb', 'tlc', 'platelets', 'glucose', 'urea', 'creatinine', 'bnp'
    ]

    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors='coerce')

    # Remove invalid stays
    df.loc[df['duration_of_stay'] <= 0, 'duration_of_stay'] = np.nan

    # --- STANDARDIZE CATEGORICALS ---
    df['gender'] = (
        df['gender']
        .str.upper()
        .replace({'M': 'MALE', 'F': 'FEMALE'})
        .fillna('OTHER')
    )

    df['type_of_admission-emergency/opd'] = (
        df['type_of_admission-emergency/opd']
        .str.lower()
        .str.strip()
    )

    # --- BOOLEAN NORMALIZATION ---
    boolean_cols = [
        'dm', 'htn', 'cad', 'prior_cmp', 'ckd', 'hb', 'tlc', 'platelets',
       'glucose', 'urea', 'creatinine', 'bnp', 'raised_cardiac_enzymes', 'ef',
       'severe_anaemia', 'anaemia', 'stable_angina', 'acs', 'stemi',
       'atypical_chest_pain', 'heart_failure', 'hfref', 'hfnef', 'valvular',
       'chb', 'sss', 'aki', 'cva_infract', 'cva_bleed', 'af', 'vt', 'psvt',
       'congenital', 'uti', 'neuro_cardiogenic_syncope', 'orthostatic',
       'infective_endocarditis', 'dvt', 'cardiogenic_shock', 'shock',
       'pulmonary_embolism', 'chest_infection'
    ]

    for col in boolean_cols:
        df[col] = df[col].map({1: True, 0: False})

    return df
