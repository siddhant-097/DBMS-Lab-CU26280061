CREATE DATABASE Cursor_Trigger_Practice;
USE Cursor_Trigger_Practice;

CREATE TABLE Employees(
 EmployeeID INT PRIMARY KEY,
 EmployeeName VARCHAR(50),
 Department VARCHAR(30),
 Salary DECIMAL(10,2),
 Status VARCHAR(20)
);
INSERT INTO Employees VALUES
(101,'Amit','IT',45000,'Active'),
(102,'Neha','HR',38000,'Active'),
(103,'Ravi','IT',52000,'Active'),
(104,'Pooja','Sales',41000,'Active'),
(105,'Karan','HR',36000,'Active'),
(106,'Meena','Sales',47000,'Active');
CREATE TABLE Employee_Audit(
 AuditID INT AUTO_INCREMENT PRIMARY KEY,
 EmployeeID INT,
 ActionType VARCHAR(20),
 OldSalary DECIMAL(10,2),
 NewSalary DECIMAL(10,2),
 ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Salary_Log(
 LogID INT AUTO_INCREMENT PRIMARY KEY,
 EmployeeID INT,
 EmployeeName VARCHAR(50),
 OldSalary DECIMAL(10,2),
 NewSalary DECIMAL(10,2),
 ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

#Q1
DELIMITER //
CREATE PROCEDURE show_employees()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_id INT;
 DECLARE v_name VARCHAR(50);
 DECLARE cur CURSOR FOR
 SELECT EmployeeID, EmployeeName FROM Employees;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_id, v_name;
 IF done THEN
 LEAVE read_loop;
 END IF;
 SELECT v_id AS EmployeeID, v_name AS EmployeeName;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
CALL show_employees();

#Q2
DELIMITER //
CREATE PROCEDURE employees_salary_above_40000()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_name VARCHAR(50);
 DECLARE v_salary DECIMAL(10,2);
 DECLARE cur CURSOR FOR
 SELECT EmployeeName, Salary FROM Employees
 WHERE Salary > 40000;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_name, v_salary;
 IF done THEN LEAVE read_loop; END IF;
 SELECT v_name AS EmployeeName, v_salary AS Salary;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
CALL employees_salary_above_40000();

#Q3
DELIMITER //
CREATE PROCEDURE total_salary(OUT p_total DECIMAL(12,2))
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_salary DECIMAL(10,2);
 DECLARE cur CURSOR FOR SELECT Salary FROM Employees;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 SET p_total = 0;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_salary;
 IF done THEN LEAVE read_loop; END IF;
 SET p_total = p_total + v_salary;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
CALL total_salary(@total);
SELECT @total AS TotalSalary;

#Q4
DELIMITER //

CREATE PROCEDURE count_it_employees(OUT p_count INT)
BEGIN
    -- 1. Declare variables first
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    
    -- 2. Declare cursors second
    DECLARE cur CURSOR FOR
        SELECT EmployeeID FROM Employees WHERE Department = 'IT';
        
    -- 3. Declare handlers last
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Procedure logic
    SET p_count = 0;
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_id;
        IF done THEN 
            LEAVE read_loop; 
        END IF;
        SET p_count = p_count + 1;
    END LOOP;
    
    CLOSE cur;
END //

DELIMITER ;

-- Call and view the result
CALL count_it_employees(@it_count);
SELECT @it_count AS IT_Employees;

#Q5
DELIMITER //
CREATE PROCEDURE average_salary(OUT p_average DECIMAL(12,2))
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_salary DECIMAL(10,2);
 DECLARE v_total DECIMAL(12,2) DEFAULT 0;
 DECLARE v_count INT DEFAULT 0;
 DECLARE cur CURSOR FOR SELECT Salary FROM Employees;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_salary;
 IF done THEN LEAVE read_loop; END IF;
 SET v_total = v_total + v_salary;
 SET v_count = v_count + 1;
 END LOOP;
 CLOSE cur;
 IF v_count > 0 THEN
 SET p_average = v_total / v_count;
 ELSE
 SET p_average = 0;
 END IF;
END //
DELIMITER ;
CALL average_salary(@avg_salary);
SELECT @avg_salary AS AverageSalary;


#Q6
DELIMITER //
CREATE PROCEDURE increase_sales_salary()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_id INT;
 DECLARE cur CURSOR FOR
 SELECT EmployeeID FROM Employees WHERE Department = 'Sales';
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_id;
 IF done THEN LEAVE read_loop; END IF;
 UPDATE Employees
 SET Salary = Salary * 1.10
 WHERE EmployeeID = v_id;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
CALL increase_sales_salary();
SELECT * FROM Employees;

#Q7
DELIMITER //
CREATE PROCEDURE mark_low_salary_review()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_id INT;
 DECLARE cur CURSOR FOR
 SELECT EmployeeID FROM Employees WHERE Salary < 40000;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_id;
 IF done THEN LEAVE read_loop; END IF;
 UPDATE Employees
 SET Status = 'Review'
 WHERE EmployeeID = v_id;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
CALL mark_low_salary_review();
SELECT * FROM Employees;

#Q8
DELIMITER //
CREATE PROCEDURE employee_report()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_name VARCHAR(50);
 DECLARE v_dept VARCHAR(30);
 DECLARE v_salary DECIMAL(10,2);
 DECLARE cur CURSOR FOR
 SELECT EmployeeName, Department, Salary
 FROM Employees
 ORDER BY Department, EmployeeName;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_name, v_dept, v_salary;
 IF done THEN LEAVE read_loop; END IF;
 SELECT v_name AS EmployeeName,
 v_dept AS Department,
 v_salary AS Salary;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
CALL employee_report();

#Q9
DELIMITER //
CREATE PROCEDURE count_active(OUT p_count INT)
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_id INT;
 DECLARE cur CURSOR FOR
 SELECT EmployeeID FROM Employees WHERE Status = 'Active';
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  SET p_count = 0;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_id;
 IF done THEN LEAVE read_loop; END IF;
 SET p_count = p_count + 1;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
CALL count_active(@active_count);
SELECT @active_count AS ActiveEmployees;

#Q10
DELIMITER //
CREATE PROCEDURE give_bonus()
BEGIN
 DECLARE done INT DEFAULT FALSE;
 DECLARE v_id INT;
 DECLARE cur CURSOR FOR
 SELECT EmployeeID FROM Employees WHERE Salary >= 45000;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 OPEN cur;
 read_loop: LOOP
 FETCH cur INTO v_id;
 IF done THEN LEAVE read_loop; END IF;
 UPDATE Employees
 SET Salary = Salary * 1.05
 WHERE EmployeeID = v_id;
 END LOOP;
 CLOSE cur;
END //
DELIMITER ;
CALL give_bonus();
SELECT * FROM Employees;

#Q11
DELIMITER //
CREATE TRIGGER trg_employee_after_insert
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
 INSERT INTO Employee_Audit(EmployeeID, ActionType, NewSalary)
 VALUES(NEW.EmployeeID, 'INSERT', NEW.Salary);
END //
DELIMITER ;
INSERT INTO Employees VALUES(107,'Sonia','IT',48000,'Active');
SELECT * FROM Employee_Audit;


#Q12
DELIMITER //
CREATE TRIGGER trg_salary_after_update
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
 IF OLD.Salary <> NEW.Salary THEN
 INSERT INTO Employee_Audit(EmployeeID, ActionType,
OldSalary, NewSalary)
 VALUES(NEW.EmployeeID, 'UPDATE', OLD.Salary, NEW.Salary);
 END IF;
END //
DELIMITER ;
UPDATE Employees
SET Salary = Salary + 2000
WHERE EmployeeID = 101;
SELECT * FROM Employee_Audit;

#Q13
DELIMITER //
CREATE TRIGGER trg_employee_before_insert
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
 SET NEW.EmployeeName = UPPER(NEW.EmployeeName);
END //
DELIMITER ;
INSERT INTO Employees VALUES(108,'rahul','HR',39000,'Active');
SELECT * FROM Employees WHERE EmployeeID = 108;

#Q14
DELIMITER //
CREATE TRIGGER trg_salary_before_insert
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
 IF NEW.Salary < 0 THEN
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Salary cannot be negative';
 END IF;
END //
DELIMITER ;

-- Test:
INSERT INTO Employees VALUES(109,'Test','IT',-5000,'Active');

#Q15
DELIMITER //
CREATE TRIGGER trg_employee_after_delete
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
 INSERT INTO Employee_Audit(EmployeeID, ActionType, OldSalary)
 VALUES(OLD.EmployeeID, 'DELETE', OLD.Salary);
END //
DELIMITER ;
DELETE FROM Employees WHERE EmployeeID = 108;
SELECT * FROM Employee_Audit

#Q16
DELIMITER //
CREATE TRIGGER trg_salary_log
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
 IF OLD.Salary <> NEW.Salary THEN
 INSERT INTO Salary_Log(EmployeeID, EmployeeName, OldSalary,
NewSalary)
 VALUES(NEW.EmployeeID, NEW.EmployeeName, OLD.Salary,
NEW.Salary);
 END IF;
END //
DELIMITER ;
UPDATE Employees
SET Salary = Salary + 1000
WHERE EmployeeID = 102;
SELECT * FROM Salary_Log;

#Q17
DELIMITER //
CREATE TRIGGER trg_salary_before_update
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
 IF NEW.Salary < 0 THEN
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Updated salary cannot be negative';
 END IF;
END //
DELIMITER ;
-- Test:
UPDATE Employees SET Salary = -100 WHERE EmployeeID = 103;

#Q18
DELIMITER //
CREATE TRIGGER trg_employee_insert_audit
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
 INSERT INTO Employee_Audit(EmployeeID, ActionType, NewSalary)
 VALUES(NEW.EmployeeID, 'NEW_EMPLOYEE', NEW.Salary);
END //
DELIMITER ; 

#Q19
DELIMITER //
CREATE TRIGGER trg_status_before_update
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
 IF LOWER(NEW.Status) = 'active' THEN
 SET NEW.Status = 'Active';
 END IF;
END //
DELIMITER ;
UPDATE Employees
SET Status = 'active'
WHERE EmployeeID = 101;
SELECT EmployeeID, Status
FROM Employees
WHERE EmployeeID = 101;

#Q20
DELIMITER //
CREATE TRIGGER trg_department_after_update
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
 IF OLD.Department <> NEW.Department THEN
 INSERT INTO Employee_Audit(EmployeeID, ActionType,
OldSalary, NewSalary)
 VALUES(NEW.EmployeeID, 'DEPARTMENT_CHANGE', OLD.Salary,
NEW.Salary);
 END IF;
END //
DELIMITER ;
UPDATE Employees
SET Department = 'Finance'
WHERE EmployeeID = 104;
SELECT * FROM Employee_Audit;