CREATE TABLE IF NOT EXISTS Patients (
    patient_id INTEGER PRIMARY KEY,
    patient_name VARCHAR(200) NOT NULL,
    patient_surname VARCHAR(200) NOT NULL,
    sex CHAR(1) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(200),
    date_birth DATE
);

CREATE TABLE IF NOT EXISTS Samples (
    sample_id INTEGER PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    date_collection DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE IF NOT EXISTS Lab_assistants (
    lab_assistant_id INTEGER PRIMARY KEY,
    lab_assistant_name VARCHAR(200) NOT NULL,
    lab_assistant_surname VARCHAR(200) NOT NULL,
    phone_number VARCHAR(20),
    vacation_status BOOLEAN
);

CREATE TABLE IF NOT EXISTS Experiments (
    experiment_id INTEGER PRIMARY KEY,
    lab_assistant_id INTEGER NOT NULL,
    sample_id INTEGER NOT NULL,
    date DATE NOT NULL,
    type_analysis_url INTEGER,
    type_analysis_bh INTEGER,
    FOREIGN KEY (lab_assistant_id) REFERENCES Lab_assistants(lab_assistant_id),
    FOREIGN KEY (sample_id) REFERENCES Samples(sample_id)
);

CREATE TABLE IF NOT EXISTS Results_urine (
    res_urine_id INTEGER PRIMARY KEY,
    experiment_id INTEGER NOT NULL,
    patient_id INTEGER NOT NULL,
    ph FLOAT,
    leucocytes_level FLOAT,
    glucose_level FLOAT,
    creatinine_level FLOAT,
    valid_from DATE,
    valid_to DATE,
    FOREIGN KEY (experiment_id) REFERENCES Experiments(experiment_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE IF NOT EXISTS Results_blood (
    res_blood_id INTEGER PRIMARY KEY,
    experiment_id INTEGER NOT NULL,
    patient_id INTEGER NOT NULL,
    hemoglobin_level FLOAT,
    erythrocytes_level FLOAT,
    leucocytes_level FLOAT,
    valid_from DATE,
    valid_to DATE,
    FOREIGN KEY (experiment_id) REFERENCES Experiments(experiment_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE IF NOT EXISTS Equipment (
    equipment_id INTEGER PRIMARY KEY,
    type VARCHAR(200) NOT NULL,
    model VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS Equipment_usage (
    experiment_id INTEGER,
    equipment_id INTEGER,
    date DATE NOT NULL,
    PRIMARY KEY (experiment_id, equipment_id),
    FOREIGN KEY (experiment_id) REFERENCES Experiments(experiment_id),
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id)
);

INSERT INTO Patients (patient_id, patient_name, patient_surname, sex, phone_number, email, date_birth)
VALUES
(1, 'Иван', 'Иванов', 'M', '1234567890', 'ivan@example.com', '1980-01-01'),
(2, 'Мария', 'Петрова', 'F', '0987654321', 'maria@example.com', '1990-02-02'),
(3, 'Алексей', 'Сидоров', 'M', '1111111111', 'alex@example.com', '1975-03-03'),
(4, 'Ольга', 'Иванова', 'F', '2222222222', 'olga@example.com', '1985-04-04'),
(5, 'Дмитрий', 'Козлов', 'M', '3333333333', 'dmitry@example.com', '1995-05-05'),
(6, 'Елена', 'Смирнова', 'F', '4444444444', 'elena@example.com', '1988-06-06'),
(7, 'Сергей', 'Попов', 'M', '5555555555', 'sergey@example.com', '1970-07-07'),
(8, 'Анна', 'Васильева', 'F', '6666666666', 'anna@example.com', '1992-08-08'),
(9, 'Павел', 'Федоров', 'M', '7777777777', 'pavel@example.com', '1983-09-09'),
(10, 'Татьяна', 'Морозова', 'F', '8888888888', 'tatyana@example.com', '1998-10-10'),
(11, 'Николай', 'Новиков', 'M', '9999999999', 'nikolay@example.com', '1978-11-11'),
(12, 'Юлия', 'Кузнецова', 'F', '1010101010', 'yulia@example.com', '1987-12-12'),
(13, 'Андрей', 'Белов', 'M', '1212121212', 'andrey@example.com', '1991-01-13'),
(14, 'Виктория', 'Медведева', 'F', '1313131313', 'victoria@example.com', '1984-02-14'),
(15, 'Артем', 'Соколов', 'M', '1414141414', 'artem@example.com', '1993-03-15');

INSERT INTO Samples (sample_id, patient_id, date_collection)
VALUES
(1, 1, '2025-01-01'),
(2, 2, '2025-01-02'),
(3, 3, '2025-01-03'),
(4, 4, '2025-01-04'),
(5, 5, '2025-01-05'),
(6, 6, '2025-01-06'),
(7, 7, '2025-01-07'),
(8, 8, '2025-01-08'),
(9, 9, '2025-01-09'),
(10, 10, '2025-01-10'),
(11, 11, '2025-01-11'),
(12, 12, '2025-01-12'),
(13, 13, '2025-01-13'),
(14, 14, '2025-01-14'),
(15, 15, '2025-01-15');

INSERT INTO Lab_assistants (lab_assistant_id, lab_assistant_name, lab_assistant_surname, phone_number, vacation_status)
VALUES
(1, 'Алексей', 'Сидоров', '1111111111', FALSE),
(2, 'Ольга', 'Иванова', '2222222222', TRUE),
(3, 'Дмитрий', 'Петров', '3333333333', FALSE),
(4, 'Екатерина', 'Смирнова', '4444444444', FALSE),
(5, 'Игорь', 'Козлов', '5555555555', TRUE),
(6, 'Анастасия', 'Морозова', '6666666666', FALSE),
(7, 'Сергей', 'Васильев', '7777777777', FALSE),
(8, 'Марина', 'Федорова', '8888888888', TRUE),
(9, 'Александр', 'Новиков', '9999999999', FALSE),
(10, 'Татьяна', 'Белова', '1010101010', FALSE),
(11, 'Иван', 'Кузнецов', '1212121212', TRUE),
(12, 'Юлия', 'Попова', '1313131313', FALSE),
(13, 'Артем', 'Медведев', '1414141414', FALSE),
(14, 'Виктория', 'Соколова', '1515151515', TRUE),
(15, 'Павел', 'Иванов', '1616161616', FALSE);

INSERT INTO Experiments (experiment_id, lab_assistant_id, sample_id, date, type_analysis_url, type_analysis_bh)
VALUES
(1, 1, 1, '2025-01-01', 1, NULL),
(2, 2, 2, '2025-01-02', NULL, 1),
(3, 3, 3, '2025-01-03', 2, NULL),
(4, 4, 4, '2025-01-04', NULL, 2),
(5, 5, 5, '2025-01-05', 1, NULL),
(6, 6, 6, '2025-01-06', NULL, 1),
(7, 7, 7, '2025-01-07', 2, NULL),
(8, 8, 8, '2025-01-08', NULL, 2),
(9, 9, 9, '2025-01-09', 1, NULL),
(10, 10, 10, '2025-01-10', NULL, 1),
(11, 11, 11, '2025-01-11', 2, NULL),
(12, 12, 12, '2025-01-12', NULL, 2),
(13, 13, 13, '2025-01-13', 1, NULL),
(14, 14, 14, '2025-01-14', NULL, 1),
(15, 15, 15, '2025-01-15', 2, NULL);

INSERT INTO Equipment (equipment_id, type, model)
VALUES
(1, 'Микроскоп', 'Model X'),
(2, 'Центрифуга', 'Model Y'),
(3, 'Анализатор крови', 'Model Z'),
(4, 'Анализатор мочи', 'Model A'),
(5, 'Инкубатор', 'Model B'),
(6, 'Хроматограф', 'Model C'),
(7, 'Спектрометр', 'Model D'),
(8, 'Автоклав', 'Model E'),
(9, 'Микротом', 'Model F'),
(10, 'Термостат', 'Model G'),
(11, 'Фотометр', 'Model H'),
(12, 'Пипетка', 'Model I'),
(13, 'Центрифуга', 'Model J'),
(14, 'Микроскоп', 'Model K'),
(15, 'Анализатор', 'Model L');

INSERT INTO Equipment_usage (experiment_id, equipment_id, date)
VALUES
(1, 1, '2025-01-01'),
(1, 2, '2025-01-01'),
(2, 1, '2025-01-02'),
(2, 3, '2025-01-02'),
(3, 4, '2025-01-03'),
(3, 5, '2025-01-03'),
(4, 6, '2025-01-04'),
(4, 7, '2025-01-04'),
(5, 8, '2025-01-05'),
(5, 9, '2025-01-05'),
(6, 10, '2025-01-06'),
(6, 11, '2025-01-06'),
(7, 12, '2025-01-07'),
(7, 13, '2025-01-07'),
(8, 14, '2025-01-08'),
(8, 15, '2025-01-08'),
(9, 1, '2025-01-09'),
(9, 3, '2025-01-09'),
(10, 5, '2025-01-10'),
(10, 7, '2025-01-10'),
(11, 9, '2025-01-11'),
(11, 11, '2025-01-11'),
(12, 13, '2025-01-12'),
(12, 15, '2025-01-12'),
(13, 2, '2025-01-13'),
(13, 4, '2025-01-13'),
(14, 6, '2025-01-14'),
(14, 8, '2025-01-14'),
(15, 10, '2025-01-15'),
(15, 12, '2025-01-15'),
(1, 3, '2025-01-01'),
(2, 4, '2025-01-02');


INSERT INTO Results_urine (res_urine_id, experiment_id, patient_id, ph, leucocytes_level, glucose_level, creatinine_level, valid_from, valid_to)
VALUES
(1, 1, 1, 6.5, 10.2, NULL, NULL, '2025-01-01', '2025-01-15'),
(2, 1, 1, 6.7, 9.8, NULL, NULL, '2025-01-16', '2025-01-31'),
(3, 1, 1, 6.6, 10.0, NULL, NULL, '2025-02-01', NULL),
(4, 3, 3, NULL, NULL, 4.5, 0.9, '2025-01-03', '2025-01-20'),
(5, 3, 3, NULL, NULL, 4.6, 0.91, '2025-01-21', NULL),
(6, 5, 5, 6.8, 9.0, NULL, NULL, '2025-01-05', NULL),
(7, 7, 7, NULL, NULL, 4.8, 0.85, '2025-01-07', '2025-01-22'),
(8, 7, 7, NULL, NULL, 4.9, 0.86, '2025-01-23', '2025-02-12'),
(9, 7, 7, NULL, NULL, 4.7, 0.84, '2025-02-13', NULL),
(10, 9, 9, 6.9, 10.0, NULL, NULL, '2025-01-09', '2025-01-25'),
(11, 9, 9, 6.8, 9.9, NULL, NULL, '2025-01-26', NULL),
(12, 11, 11, NULL, NULL, 4.9, 0.8, '2025-01-11', NULL),
(13, 13, 13, 6.7, 9.5, NULL, NULL, '2025-01-13', '2025-01-30'),
(14, 13, 13, 6.6, 9.6, NULL, NULL, '2025-01-31', '2025-02-20'),
(15, 13, 13, 6.8, 9.4, NULL, NULL, '2025-02-21', NULL),
(16, 1, 1, 6.4, 10.1, NULL, NULL, '2025-01-01', '2025-01-15'),
(17, 1, 1, 6.3, 10.3, NULL, NULL, '2025-01-16', '2025-01-31'),
(18, 1, 1, 6.2, 10.4, NULL, NULL, '2025-02-01', NULL),
(19, 3, 3, NULL, NULL, 4.7, 0.92, '2025-01-03', '2025-01-20'),
(20, 3, 3, NULL, NULL, 4.8, 0.93, '2025-01-21', NULL),
(21, 5, 5, 6.9, 9.1, NULL, NULL, '2025-01-05', NULL),
(22, 7, 7, NULL, NULL, 4.9, 0.87, '2025-01-07', '2025-01-22'),
(23, 7, 7, NULL, NULL, 5.0, 0.88, '2025-01-23', '2025-02-12'),
(24, 7, 7, NULL, NULL, 5.1, 0.89, '2025-02-13', NULL),
(25, 9, 9, 7.0, 10.1, NULL, NULL, '2025-01-09', '2025-01-25'),
(26, 9, 9, 7.1, 10.2, NULL, NULL, '2025-01-26', NULL),
(27, 11, 11, NULL, NULL, 5.0, 0.81, '2025-01-11', NULL),
(28, 13, 13, 6.9, 9.7, NULL, NULL, '2025-01-13', '2025-01-30'),
(29, 13, 13, 7.0, 9.8, NULL, NULL, '2025-01-31', '2025-02-20'),
(30, 13, 13, 7.1, 9.9, NULL, NULL, '2025-02-21', NULL);

INSERT INTO Results_blood (res_blood_id, experiment_id, patient_id, hemoglobin_level, erythrocytes_level, leucocytes_level, valid_from, valid_to)
VALUES
(1, 2, 2, 14.5, 4.5, NULL, '2025-01-02', '2025-01-15'),
(2, 2, 2, 14.6, 4.6, NULL, '2025-01-16', '2025-01-31'),
(3, 2, 2, 14.7, 4.7, NULL, '2025-02-01', NULL),
(4, 4, 4, NULL, NULL, 5.8, '2025-01-04', '2025-01-20'),
(5, 4, 4, NULL, NULL, 5.9, '2025-01-21', NULL),
(6, 6, 6, 14.8, 4.6, NULL, '2025-01-06', NULL),
(7, 8, 8, NULL, NULL, 5.9, '2025-01-08', '2025-01-22'),
(8, 8, 8, NULL, NULL, 6.0, '2025-01-23', '2025-02-12'),
(9, 8, 8, NULL, NULL, 5.8, '2025-02-13', NULL),
(10, 10, 10, 14.7, 4.9, NULL, '2025-01-10', '2025-01-25'),
(11, 10, 10, 14.8, 5.0, NULL, '2025-01-26', NULL),
(12, 12, 12, NULL, NULL, 5.7, '2025-01-12', NULL),
(13, 14, 14, 14.9, 4.7, NULL, '2025-01-14', '2025-01-30'),
(14, 14, 14, 15.0, 4.8, NULL, '2025-01-31', '2025-02-20'),
(15, 14, 14, 14.8, 4.9, NULL, '2025-02-21', NULL),
(16, 2, 2, 14.4, 4.4, NULL, '2025-01-02', '2025-01-15'),
(17, 2, 2, 14.3, 4.3, NULL, '2025-01-16', '2025-01-31'),
(18, 2, 2, 14.2, 4.2, NULL, '2025-02-01', NULL),
(19, 4, 4, NULL, NULL, 5.7, '2025-01-04', '2025-01-20'),
(20, 4, 4, NULL, NULL, 5.6, '2025-01-21', NULL),
(21, 6, 6, 14.9, 4.7, NULL, '2025-01-06', NULL),
(22, 8, 8, NULL, NULL, 5.8, '2025-01-08', '2025-01-22'),
(23, 8, 8, NULL, NULL, 5.9, '2025-01-23', '2025-02-12'),
(24, 8, 8, NULL, NULL, 6.0, '2025-02-13', NULL),
(25, 10, 10, 14.9, 5.1, NULL, '2025-01-10', '2025-01-25'),
(26, 10, 10, 15.0, 5.2, NULL, '2025-01-26', NULL),
(27, 12, 12, NULL, NULL, 5.8, '2025-01-12', NULL),
(28, 14, 14, 15.1, 4.8, NULL, '2025-01-14', '2025-01-30'),
(29, 14, 14, 15.2, 4.9, NULL, '2025-01-31', '2025-02-20'),
(30, 14, 14, 15.3, 5.0, NULL, '2025-02-21', NULL);
