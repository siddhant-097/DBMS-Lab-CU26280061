CREATE DATABASE Hospital_Functions_Lab;
USE Hospital_Functions_Lab;

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    WeightKg DECIMAL(5,2),
    ConsultationFee DECIMAL(10,2)
);

CREATE TABLE Medicines (
    MedicineID INT PRIMARY KEY,
    MedicineName VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Stock INT
);

INSERT INTO Patients VALUES
(201, 'Asha', 24, 'F', 55.5, 600),
(202, 'Rohan', 35, 'M', 72.0, 800),
(203, 'Meera', 29, 'F', 61.5, 700),
(204, 'Vivek', 46, 'M', 85.0, 1000),
(205, 'Nitin', 17, 'M', 58.0, 500),
(206, 'Kavya', 52, 'F', 68.0, 900);

INSERT INTO Medicines VALUES
(301, 'Paracetamol', 25, 100),
(302, 'Amoxicillin', 80, 50),
(303, 'Cetirizine', 35, 75),
(304, 'Omeprazole', 60, 40),
(305, 'Azithromycin', 120, 25);

SELECT * FROM Patients;
SELECT * FROM Medicines;

#Q1
DELIMITER //

CREATE FUNCTION calculate_bmi(
    p_weight_kg DECIMAL(5,2),
    p_height_m DECIMAL(4,2)
)
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
    IF p_weight_kg IS NULL
       OR p_height_m IS NULL
       OR p_weight_kg <= 0
       OR p_height_m <= 0 THEN
        RETURN NULL;
    END IF;

    RETURN ROUND(p_weight_kg / (p_height_m * p_height_m), 2);
END //

DELIMITER ;

#Q2
DELIMITER //

CREATE FUNCTION age_category(p_age INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF p_age IS NULL OR p_age < 0 THEN
        RETURN NULL;
    ELSEIF p_age < 18 THEN
        RETURN 'Child';
    ELSEIF p_age < 60 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Senior';
    END IF;
END //

DELIMITER ;

-- Apply the function to every patient:
SELECT
    PatientID,
    PatientName,
    Age,
    age_category(Age) AS AgeCategory
FROM Patients;

#Q3
DELIMITER //

CREATE FUNCTION consultation_with_tax(
    p_fee DECIMAL(10,2),
    p_tax_percent DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    IF p_fee IS NULL OR p_tax_percent IS NULL
       OR p_fee < 0 OR p_tax_percent < 0 THEN
        RETURN NULL;
    END IF;

    RETURN ROUND(
        p_fee + (p_fee * p_tax_percent / 100),
        2
    );
END //

DELIMITER ;

SELECT
    PatientName,
    ConsultationFee AS OriginalFee,
    consultation_with_tax(ConsultationFee, 18) AS FeeWithTax
FROM Patients;

#Q4
DELIMITER //

CREATE FUNCTION medicine_stock_value(
    p_unit_price DECIMAL(10,2),
    p_stock INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    IF p_unit_price IS NULL OR p_stock IS NULL
       OR p_unit_price < 0 OR p_stock < 0 THEN
        RETURN NULL;
    END IF;

    RETURN p_unit_price * p_stock;
END //

DELIMITER ;


SELECT
    MedicineID,
    MedicineName,
    UnitPrice,
    Stock,
    medicine_stock_value(UnitPrice, Stock) AS StockValue
FROM Medicines;

#Q5
DELIMITER //

CREATE PROCEDURE patient_by_gender(IN p_gender VARCHAR(10))
BEGIN
    SELECT *
    FROM Patients
    WHERE Gender = p_gender;
END //

DELIMITER ;

CALL patient_by_gender('F');
CALL patient_by_gender('M');

#Q6
DELIMITER //

CREATE PROCEDURE patients_above_age(IN p_age INT)
BEGIN
    SELECT *
    FROM Patients
    WHERE Age > p_age;
END //

DELIMITER ;

CALL patients_above_age(25);
CALL patients_above_age(40);

#Q7
DELIMITER //

CREATE PROCEDURE update_medicine_stock(
    IN p_id INT,
    IN p_quantity INT
)
BEGIN
    IF p_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity increase cannot be negative';
    ELSE
        UPDATE Medicines
        SET Stock = Stock + p_quantity
        WHERE MedicineID = p_id;
    END IF;
END //

DELIMITER ;

CALL update_medicine_stock(301, 20);

SELECT *
FROM Medicines
WHERE MedicineID = 301;

#Q8
DELIMITER //

CREATE PROCEDURE medicine_count(OUT p_count INT)
BEGIN
    SELECT COUNT(*)
    INTO p_count
    FROM Medicines;
END //

DELIMITER ;

CALL medicine_count(@total_medicines);

SELECT @total_medicines AS TotalMedicines;

#Q9
ALTER TABLE Patients
ADD COLUMN HeightM DECIMAL(4,2);

UPDATE Patients SET HeightM = 1.65 WHERE PatientID = 201;
UPDATE Patients SET HeightM = 1.72 WHERE PatientID = 202;
UPDATE Patients SET HeightM = 1.60 WHERE PatientID = 203;
UPDATE Patients SET HeightM = 1.78 WHERE PatientID = 204;
UPDATE Patients SET HeightM = 1.70 WHERE PatientID = 205;
UPDATE Patients SET HeightM = 1.62 WHERE PatientID = 206;

DELIMITER //

CREATE PROCEDURE patient_report()
BEGIN
    SELECT
        PatientID,
        PatientName,
        Age,
        calculate_bmi(WeightKg, HeightM) AS BMI,
        age_category(Age) AS AgeCategory
    FROM Patients;
END //

DELIMITER ;

CALL patient_report();

#Q10
DELIMITER //

CREATE PROCEDURE medicine_report()
BEGIN
    SELECT
        MedicineID,
        MedicineName,
        UnitPrice,
        Stock,
        medicine_stock_value(UnitPrice, Stock) AS StockValue,
        CASE
            WHEN Stock <= 30 THEN 'Low Stock'
            WHEN Stock <= 60 THEN 'Medium Stock'
            ELSE 'High Stock'
        END AS StockStatus
    FROM Medicines;
END //

DELIMITER ;

CALL medicine_report();