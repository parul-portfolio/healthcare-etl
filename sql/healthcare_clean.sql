-- ===========================================
-- HEALTHCARE ADMISSIONS: FULL SQL ELT PIPELINE
-- ===========================================

-- STEP 0: DROP CLEAN TABLE IF EXISTS
DROP TABLE IF EXISTS admissions_clean;

-- STEP 1: CREATE CLEAN TABLE
CREATE TABLE admissions_clean AS
SELECT
    "SNO" AS sno,
    "MRD No." AS mrd_no,

    -- Robust DOA conversion
    printf('%04d-', 
        CASE 
            WHEN length(substr("D.O.A", -4)) = 4 THEN CAST(substr("D.O.A", -4) AS INTEGER)
            ELSE 2000 + CAST(substr("D.O.A", -2) AS INTEGER)
        END
    ) ||
    printf('%02d-', CAST(substr("D.O.A", 1, instr("D.O.A", '/')-1) AS INTEGER)) ||
    printf('%02d', CAST(substr("D.O.A", instr("D.O.A", '/')+1, instr(substr("D.O.A", instr("D.O.A", '/')+1), '/')-1) AS INTEGER)) AS doa,

    -- Robust DOD conversion
    printf('%04d-', 
        CASE 
            WHEN length(substr("D.O.D", -4)) = 4 THEN CAST(substr("D.O.D", -4) AS INTEGER)
            ELSE 2000 + CAST(substr("D.O.D", -2) AS INTEGER)
        END
    ) ||
    printf('%02d-', CAST(substr("D.O.D", 1, instr("D.O.D", '/')-1) AS INTEGER)) ||
    printf('%02d', CAST(substr("D.O.D", instr("D.O.D", '/')+1, instr(substr("D.O.D", instr("D.O.D", '/')+1), '/')-1) AS INTEGER)) AS dod,

    "AGE" AS age,
    "GENDER" AS gender,
    "RURAL" AS rural,
    "TYPE OF ADMISSION-EMERGENCY/OPD" AS type_of_admission,
    "month year" AS month_year,
    "DURATION OF STAY" AS duration_of_stay,
    "duration of intensive unit stay" AS duration_of_intensive_unit_stay,
    "OUTCOME" AS outcome,
    "SMOKING" AS smoking,
    "ALCOHOL" AS alcohol,

    IFNULL("DM",0) AS dm,
    IFNULL("HTN",0) AS htn,
    IFNULL("CAD",0) AS cad,
    IFNULL("PRIOR CMP",0) AS prior_cmp,
    IFNULL("CKD",0) AS ckd,
    IFNULL("HB",0) AS hb,
    IFNULL("TLC",0) AS tlc,
    IFNULL("PLATELETS",0) AS platelets,
    IFNULL("GLUCOSE",0) AS glucose,
    IFNULL("UREA",0) AS urea,
    IFNULL("CREATININE",0) AS creatinine,
    IFNULL("BNP",0) AS bnp,
    IFNULL("RAISED CARDIAC ENZYMES",0) AS raised_cardiac_enzymes,
    IFNULL("EF",0) AS ef,
    IFNULL("SEVERE ANAEMIA",0) AS severe_anaemia,
    IFNULL("ANAEMIA",0) AS anaemia,
    IFNULL("STABLE ANGINA",0) AS stable_angina,
    IFNULL("ACS",0) AS acs,
    IFNULL("STEMI",0) AS stemi,
    IFNULL("ATYPICAL CHEST PAIN",0) AS atypical_chest_pain,
    IFNULL("HEART FAILURE",0) AS heart_failure,
    IFNULL("HFREF",0) AS hfref,
    IFNULL("HFNEF",0) AS hfnef,
    IFNULL("VALVULAR",0) AS valvular,
    IFNULL("CHB",0) AS chb,
    IFNULL("SSS",0) AS sss,
    IFNULL("AKI",0) AS aki,
    IFNULL("CVA INFRACT",0) AS cva_infract,
    IFNULL("CVA BLEED",0) AS cva_bleed,
    IFNULL("AF",0) AS af,
    IFNULL("VT",0) AS vt,
    IFNULL("PSVT",0) AS psvt,
    IFNULL("CONGENITAL",0) AS congenital,
    IFNULL("UTI",0) AS uti,
    IFNULL("NEURO CARDIOGENIC SYNCOPE",0) AS neuro_cardiogenic_syncope,
    IFNULL("ORTHOSTATIC",0) AS orthostatic,
    IFNULL("INFECTIVE ENDOCARDITIS",0) AS infective_endocarditis,
    IFNULL("DVT",0) AS dvt,
    IFNULL("CARDIOGENIC SHOCK",0) AS cardiogenic_shock,
    IFNULL("SHOCK",0) AS shock,
    IFNULL("PULMONARY EMBOLISM",0) AS pulmonary_embolism,
    IFNULL("CHEST INFECTION",0) AS chest_infection
FROM admissions_raw;

-- Optional: inspect first 5 rows of clean table
SELECT * FROM admissions_clean LIMIT 5;

-- STEP 2: FILL MISSING DURATION OF STAY WITH MEDIAN
-- Example: calculate median using ORDER BY + OFFSET
WITH ordered AS (
    SELECT duration_of_stay
    FROM admissions_clean
    WHERE duration_of_stay IS NOT NULL
    ORDER BY duration_of_stay
)
SELECT duration_of_stay
FROM ordered
LIMIT 1 OFFSET (SELECT COUNT(*)/2 FROM ordered);

-- Suppose median is 5, update missing values
UPDATE admissions_clean
SET duration_of_stay = 5
WHERE duration_of_stay IS NULL;

-- STEP 3: EXAMPLE ANALYSIS QUERIES

-- Total admissions
SELECT COUNT(*) AS total_admissions
FROM admissions_clean;

-- Average length of stay by rural/urban
SELECT rural, AVG(duration_of_stay) AS avg_los
FROM admissions_clean
GROUP BY rural;

-- Number of diabetic patients
SELECT COUNT(*) AS diabetic_patients
FROM admissions_clean
WHERE dm = 1;

-- Comorbidity prevalence summary (example top 5)
SELECT
    SUM(dm) AS dm_count,
    SUM(htn) AS htn_count,
    SUM(cad) AS cad_count,
    SUM(prior_cmp) AS prior_cmp_count,
    SUM(ckd) AS ckd_count
FROM admissions_clean;
