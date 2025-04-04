-- Лаборанты и количество проведенных ими анализов 
-- (отсортированы по количеству проведенных опытов)
SELECT la.lab_assistant_id, la.lab_assistant_name, la.lab_assistant_surname,
       COUNT(e.experiment_id) AS experiments_count
FROM Lab_assistants la
LEFT JOIN Experiments e ON la.lab_assistant_id = e.lab_assistant_id
GROUP BY la.lab_assistant_id
HAVING COUNT(e.experiment_id) > 0
ORDER BY experiments_count DESC;

--Пациенты с аномальными уровнями лейкоцитов в моче
SELECT p.patient_id, p.patient_name, p.patient_surname, ru.leucocytes_level
FROM Patients p
JOIN Results_urine ru ON p.patient_id = ru.patient_id
WHERE ru.leucocytes_level > (
    SELECT AVG(leucocytes_level) 
	FROM Results_urine 
    WHERE leucocytes_level IS NOT NULL
)
AND ru.valid_to IS NULL
ORDER BY ru.leucocytes_level DESC;

-- Какое оборудование используется чаще всего? (топ 3)
SELECT e.equipment_id, e.type, e.model, 
       COUNT(eu.experiment_id) AS usage_count
FROM Equipment e
JOIN Equipment_usage eu ON e.equipment_id = eu.equipment_id
GROUP BY e.equipment_id
ORDER BY usage_count DESC
LIMIT 3;

-- Оборудование, не использовавшееся в феврале 2025
SELECT e.equipment_id, e.type, e.model
FROM Equipment e
WHERE NOT EXISTS (
    SELECT 1 FROM Equipment_usage eu
    WHERE eu.equipment_id = e.equipment_id
    AND eu.date BETWEEN '2025-02-01' AND '2025-02-28'
)
ORDER BY e.type;

-- пациенты, у которых упал уровень эритроцитов
-- по сравнению с прошлым анализом (капец сложный запрос)
WITH BloodResultsWithPrevious AS (
    SELECT 
        p.patient_id,
        p.patient_name,
        p.patient_surname,
        rb.erythrocytes_level,
        rb.valid_from,
        LAG(rb.erythrocytes_level) OVER (PARTITION BY p.patient_id ORDER BY rb.valid_from) AS prev_erythrocytes_level,
        LAG(rb.valid_from) OVER (PARTITION BY p.patient_id ORDER BY rb.valid_from) AS prev_valid_from,
        ROW_NUMBER() OVER (PARTITION BY p.patient_id ORDER BY rb.valid_from DESC) AS rn
    FROM 
        Patients p
    JOIN 
        Results_blood rb ON p.patient_id = rb.patient_id
    WHERE 
        rb.erythrocytes_level IS NOT NULL
)
SELECT 
    patient_id,
    patient_name,
    patient_surname,
    prev_erythrocytes_level AS previous_level,
    erythrocytes_level AS current_level,
    prev_valid_from AS previous_date,
    valid_from AS current_date,
    (prev_erythrocytes_level - erythrocytes_level) AS level_drop
FROM 
    BloodResultsWithPrevious
WHERE 
    erythrocytes_level < prev_erythrocytes_level
    AND rn = 1 
ORDER BY 
    level_drop DESC, patient_surname, patient_name;

-- лаборанты-рекордсмены по количеству анализов крови/мочи
WITH 
BloodAnalysts AS (
    SELECT 
        la.lab_assistant_id,
        la.lab_assistant_name,
        la.lab_assistant_surname,
        COUNT(DISTINCT e.experiment_id) AS blood_tests_count
    FROM 
        Lab_assistants la
    JOIN 
        Experiments e ON la.lab_assistant_id = e.lab_assistant_id
    JOIN 
        Results_blood rb ON e.experiment_id = rb.experiment_id
    GROUP BY 
        la.lab_assistant_id, la.lab_assistant_name, la.lab_assistant_surname
    ORDER BY 
        blood_tests_count DESC
    LIMIT 1
),
UrineAnalysts AS (
    SELECT 
        la.lab_assistant_id,
        la.lab_assistant_name,
        la.lab_assistant_surname,
        COUNT(DISTINCT e.experiment_id) AS urine_tests_count
    FROM 
        Lab_assistants la
    JOIN 
        Experiments e ON la.lab_assistant_id = e.lab_assistant_id
    JOIN 
        Results_urine ru ON e.experiment_id = ru.experiment_id
    GROUP BY 
        la.lab_assistant_id, la.lab_assistant_name, la.lab_assistant_surname
    ORDER BY 
        urine_tests_count DESC
    LIMIT 1
)
SELECT 
    'blood' AS analysis_type,
    lab_assistant_id,
    lab_assistant_name,
    lab_assistant_surname,
    blood_tests_count AS tests_count
FROM 
    BloodAnalysts
UNION ALL
SELECT 
    'urine' AS analysis_type,
    lab_assistant_id,
    lab_assistant_name,
    lab_assistant_surname,
    urine_tests_count AS tests_count
FROM 
    UrineAnalysts;


-- средние анализы за месяц
SELECT 
    EXTRACT(YEAR FROM rb.valid_from) AS year,
    EXTRACT(MONTH FROM rb.valid_from) AS month,
    AVG(rb.hemoglobin_level) AS avg_hemoglobin,
    AVG(rb.erythrocytes_level) AS avg_erythrocytes,
    AVG(ru.ph) AS avg_ph,
    AVG(ru.leucocytes_level) AS avg_urine_leucocytes,
    COUNT(DISTINCT rb.patient_id) AS patients_count
FROM 
    Results_blood rb
FULL JOIN 
    Results_urine ru ON rb.patient_id = ru.patient_id 
    AND DATE_TRUNC('month', rb.valid_from) = DATE_TRUNC('month', ru.valid_from)
WHERE 
    rb.valid_from IS NOT NULL OR ru.valid_from IS NOT NULL
GROUP BY 
    EXTRACT(YEAR FROM rb.valid_from), EXTRACT(MONTH FROM rb.valid_from)
ORDER BY 
    year, month;

-- лаборанты, которые не выполняли анализы мочи
SELECT 
    la.lab_assistant_id,
    la.lab_assistant_name,
    la.lab_assistant_surname
FROM 
    Lab_assistants la
LEFT JOIN 
    Experiments e ON la.lab_assistant_id = e.lab_assistant_id AND e.type_analysis_url IS NOT NULL
WHERE 
    e.experiment_id IS NULL;

-- пациенты с самыми стабильными анализами мочи
SELECT 
    p.patient_id,
    p.patient_name || ' ' || p.patient_surname AS patient_name,
    STDDEV(ru.ph) AS ph_stddev
FROM 
    Patients p
JOIN 
    Results_urine ru ON p.patient_id = ru.patient_id
GROUP BY 
    p.patient_id, patient_name
HAVING 
    COUNT(ru.ph) > 1
ORDER BY 
    ph_stddev ASC
LIMIT 5;


-- динамика изменения уровня лейкоцитов у пациентов
SELECT 
    p.patient_id,
    p.patient_name,
    p.patient_surname,
    rb.valid_from,
    rb.leucocytes_level,
    LAG(rb.leucocytes_level) OVER (PARTITION BY p.patient_id ORDER BY rb.valid_from) AS prev_level,
    rb.leucocytes_level - LAG(rb.leucocytes_level) OVER (PARTITION BY p.patient_id ORDER BY rb.valid_from) AS level_change
FROM 
    Patients p
JOIN 
    Results_blood rb ON p.patient_id = rb.patient_id
WHERE 
    rb.leucocytes_level IS NOT NULL
ORDER BY 
    p.patient_id, rb.valid_from;
