CREATE DATABASE Hospital_Cursor_Trigger_Lab;
USE Hospital_Cursor_Trigger_Lab;

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(50),
    Department VARCHAR(40),
    ConsultationFee DECIMAL(10,2),
    Status VARCHAR(20)
);

INSERT INTO Doctors VALUES
(201, 'Dr. Anil', 'Cardiology', 1200, 'Active'),
(202, 'Dr. Beena', 'Pediatrics', 900, 'Active'),
(203, 'Dr. Chirag', 'Neurology', 1500, 'Active'),
(204, 'Dr. Divya', 'Dermatology', 1000, 'Active'),
(205, 'Dr. Eshan', 'Cardiology', 1300, 'Active'),
(206, 'Dr. Farah', 'Pediatrics', 850, 'Active');

CREATE TABLE Doctor_Audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,
    ActionType VARCHAR(30),
    OldFee DECIMAL(10,2),
    NewFee DECIMAL(10,2),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Fee_Log (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,
    DoctorName VARCHAR(50),
    OldFee DECIMAL(10,2),
    NewFee DECIMAL(10,2),
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM Doctors;
SELECT * FROM Doctor_Audit;
SELECT * FROM Fee_Log;

#Q1
DELIMITER //

CREATE PROCEDURE ShowDoctorsCursor()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ID INT;
    DECLARE v_Name VARCHAR(50);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, DoctorName FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_ID, v_Name;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_ID AS DoctorID, v_Name AS DoctorName;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL ShowDoctorsCursor();

#Q2
DELIMITER //

CREATE PROCEDURE DoctorsAboveFee()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ID INT;
    DECLARE v_Name VARCHAR(50);
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, DoctorName, ConsultationFee
        FROM Doctors
        WHERE ConsultationFee > 1000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_ID, v_Name, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_ID AS DoctorID,
               v_Name AS DoctorName,
               v_Fee AS ConsultationFee;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL DoctorsAboveFee();

#Q3
DELIMITER //

CREATE PROCEDURE TotalConsultationFee(OUT p_Total DECIMAL(10,2))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_Fee DECIMAL(10,2);
    DECLARE v_Total DECIMAL(10,2) DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT ConsultationFee FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_Total = v_Total + v_Fee;
    END LOOP;

    CLOSE cur;

    SET p_Total = v_Total;
END //

DELIMITER ;

CALL TotalConsultationFee(@total);
SELECT @total AS TotalConsultationFee;

#Q4
DELIMITER //

CREATE PROCEDURE CountCardiologyDoctors(OUT p_Count INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ID INT;
    DECLARE v_Count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT DoctorID
        FROM Doctors
        WHERE Department = 'Cardiology';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_ID;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_Count = v_Count + 1;
    END LOOP;

    CLOSE cur;

    SET p_Count = v_Count;
END //

DELIMITER ;

CALL CountCardiologyDoctors(@cardiology_count);
SELECT @cardiology_count AS CardiologyDoctors;

#Q5
DELIMITER //

CREATE PROCEDURE AverageConsultationFee(OUT p_Average DECIMAL(10,2))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_Fee DECIMAL(10,2);
    DECLARE v_Total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_Count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT ConsultationFee FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_Total = v_Total + v_Fee;
        SET v_Count = v_Count + 1;
    END LOOP;

    CLOSE cur;

    IF v_Count = 0 THEN
        SET p_Average = NULL;
    ELSE
        SET p_Average = v_Total / v_Count;
    END IF;
END //

DELIMITER ;

CALL AverageConsultationFee(@average_fee);
SELECT @average_fee AS AverageConsultationFee;

#Q6
DELIMITER //

CREATE PROCEDURE IncreasePediatricsFees()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ID INT;
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, ConsultationFee
        FROM Doctors
        WHERE Department = 'Pediatrics';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_ID, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET ConsultationFee = v_Fee * 1.10
        WHERE DoctorID = v_ID;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL IncreasePediatricsFees();

SELECT DoctorID, DoctorName, ConsultationFee
FROM Doctors
WHERE Department = 'Pediatrics';

#Q7
DELIMITER //

CREATE PROCEDURE ReviewLowFeeDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ID INT;
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, ConsultationFee
        FROM Doctors
        WHERE ConsultationFee < 1000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_ID, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET Status = 'Review'
        WHERE DoctorID = v_ID;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL ReviewLowFeeDoctors();

SELECT * FROM Doctors
WHERE Status = 'Review';

#Q8
DELIMITER //

CREATE PROCEDURE DoctorReportCursor()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_Name VARCHAR(50);
    DECLARE v_Department VARCHAR(40);
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorName, Department, ConsultationFee
        FROM Doctors
        ORDER BY Department, DoctorName;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_Name, v_Department, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_Name AS DoctorName,
               v_Department AS Department,
               v_Fee AS ConsultationFee;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL DoctorReportCursor();

#Q9
DELIMITER //

CREATE PROCEDURE CountActiveDoctors(OUT p_Count INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ID INT;
    DECLARE v_Count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT DoctorID
        FROM Doctors
        WHERE Status = 'Active';

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_ID;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_Count = v_Count + 1;
    END LOOP;

    CLOSE cur;

    SET p_Count = v_Count;
END //

DELIMITER ;

CALL CountActiveDoctors(@active_count);
SELECT @active_count AS ActiveDoctors;

#Q10
DELIMITER //

CREATE PROCEDURE IncreaseHighFees()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ID INT;
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, ConsultationFee
        FROM Doctors
        WHERE ConsultationFee >= 1200;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_ID, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET ConsultationFee = v_Fee * 1.05
        WHERE DoctorID = v_ID;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL IncreaseHighFees();

SELECT * FROM Doctors;

#Q11
DELIMITER //

CREATE TRIGGER AfterDoctorInsert
AFTER INSERT ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit
        (DoctorID, ActionType, OldFee, NewFee)
    VALUES
        (NEW.DoctorID, 'INSERT', NULL, NEW.ConsultationFee);
END //

DELIMITER ;

INSERT INTO Doctors
VALUES (207, 'Dr. Gaurav', 'Orthopedics', 1100, 'Active');

SELECT * FROM Doctor_Audit
WHERE DoctorID = 207;

#Q12
DELIMITER //

CREATE TRIGGER AfterDoctorFeeUpdate
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Doctor_Audit
            (DoctorID, ActionType, OldFee, NewFee)
        VALUES
            (NEW.DoctorID, 'FEE_UPDATE',
             OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET ConsultationFee = 1250
WHERE DoctorID = 201;

SELECT * FROM Doctor_Audit
WHERE DoctorID = 201;

#Q13
DELIMITER //

CREATE TRIGGER BeforeDoctorInsertUppercase
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    SET NEW.DoctorName = UPPER(NEW.DoctorName);
END //

DELIMITER ;

INSERT INTO Doctors
VALUES (208, 'dr. harsh', 'ENT', 950, 'Active');

SELECT DoctorID, DoctorName
FROM Doctors
WHERE DoctorID = 208;

#Q14
DELIMITER //

CREATE TRIGGER BeforeDoctorInsertFeeCheck
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Consultation fee cannot be negative';
    END IF;
END //

DELIMITER ;

INSERT INTO Doctors
VALUES (209, 'Dr. Invalid', 'Cardiology', -500, 'Active');

#Q15
DELIMITER //

CREATE TRIGGER AfterDoctorDelete
AFTER DELETE ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit
        (DoctorID, ActionType, OldFee, NewFee)
    VALUES
        (OLD.DoctorID, 'DELETE', OLD.ConsultationFee, NULL);
END //

DELIMITER ;

DELETE FROM Doctors
WHERE DoctorID = 207;

SELECT * FROM Doctor_Audit
WHERE DoctorID = 207;

#Q16
DELIMITER //

CREATE TRIGGER AfterFeeUpdateLog
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Fee_Log
            (DoctorID, DoctorName, OldFee, NewFee)
        VALUES
            (NEW.DoctorID, NEW.DoctorName,
             OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET ConsultationFee = 1600
WHERE DoctorID = 203;

SELECT * FROM Fee_Log
WHERE DoctorID = 203;

#Q17
DELIMITER //

CREATE TRIGGER BeforeDoctorUpdateFeeCheck
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Updated consultation fee cannot be negative';
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET ConsultationFee = -100
WHERE DoctorID = 201;

#Q18
DELIMITER //

CREATE TRIGGER BeforeDoctorStatusUpdate
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF LOWER(NEW.Status) = 'active' THEN
        SET NEW.Status = 'Active';
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET Status = 'active'
WHERE DoctorID = 201;

SELECT DoctorID, DoctorName, Status
FROM Doctors
WHERE DoctorID = 201;

#Q19
DELIMITER //

CREATE TRIGGER AfterDoctorDepartmentUpdate
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF NOT (OLD.Department <=> NEW.Department) THEN
        INSERT INTO Doctor_Audit
            (DoctorID, ActionType, OldFee, NewFee)
        VALUES
            (NEW.DoctorID, 'DEPARTMENT_CHANGE', NULL, NULL);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET Status = 'active'
WHERE DoctorID = 201;

SELECT DoctorID, DoctorName, Status
FROM Doctors
WHERE DoctorID = 201;

#Q20
DELIMITER //

CREATE TRIGGER BeforeDoctorInsertPositiveFee
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Consultation fee must be greater than zero';
    END IF;
END //

DELIMITER ;

INSERT INTO Doctors
VALUES (210, 'Dr. Test', 'General Medicine', 0, 'Active');