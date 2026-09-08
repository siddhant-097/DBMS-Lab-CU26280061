CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;

CREATE TABLE departments (
 dept_id INT PRIMARY KEY,
 dept_name VARCHAR(50) NOT NULL,
 location VARCHAR(50),
 budget DECIMAL(12,2)
) ENGINE=InnoDB;

CREATE TABLE employees (
 emp_id INT PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 dept_id INT,
 salary DECIMAL(10,2),
 hire_date DATE,
 is_active BOOLEAN,
 FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;

CREATE TABLE orders (
 order_id INT PRIMARY KEY,
 customer_name VARCHAR(100),
 order_date DATE,
 total_amount DECIMAL(10,2),
 status VARCHAR(20)
) ENGINE=InnoDB; 


INSERT INTO departments (dept_id, dept_name, location, budget) VALUES
(10, 'Engineering', 'Building A', 500000.00),
(20, 'Marketing', 'Building B', 200000.00),
(30, 'Human Resources', 'Building A', 150000.00),
(40, 'Finance', 'Building C', 350000.00),
(50, 'Research', 'Building D', 600000.00);

INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, is_active) VALUES
(101, 'Alice', 'Smith', 10, 75000.00, '2021-03-15', TRUE),
(102, 'Bob', 'Johnson', 20, 52000.00, '2022-06-01', TRUE),
(103, 'Charlie', 'Brown', 10, 82000.00, '2019-11-20', TRUE),
(104, 'Diana', 'Prince', 30, 48000.00, '2023-01-10', FALSE),
(105, 'Evan', 'Wright', 20, 61000.00, '2020-08-05', TRUE);

INSERT INTO orders (order_id, customer_name, order_date, total_amount, status) VALUES
(5001, 'TechCorp LLC', '2024-01-15', 1250.50, 'Completed'),
(5002, 'Global Media', '2024-01-18', 450.00, 'Pending'),
(5003, 'Alpha Retail', '2024-01-20', 3100.00, 'Completed'),
(5004, 'Beta Systems', '2024-01-22', 150.25, 'Cancelled'),
(5005, 'Gamma Inc', '2024-01-25', 890.00, 'Shipped');

CREATE USER IF NOT EXISTS 'john'@'localhost' IDENTIFIED BY 'JohnPass2026!';
CREATE USER IF NOT EXISTS 'alice'@'localhost' IDENTIFIED BY 'AlicePass2026!';
CREATE USER IF NOT EXISTS 'intern_user'@'localhost' IDENTIFIED BY 'InternPass2026!';
CREATE USER IF NOT EXISTS 'temp_user'@'localhost' IDENTIFIED BY 'TempPass2026!';
CREATE USER IF NOT EXISTS 'guest_user'@'localhost' IDENTIFIED BY 'GuestPass2026!';
CREATE USER IF NOT EXISTS 'sec_user'@'localhost' IDENTIFIED BY 'SecPass2026!';
CREATE USER IF NOT EXISTS 'admin_user'@'%' IDENTIFIED BY 'AdminPass2026!'; 


CREATE USER IF NOT EXISTS 'auditor'@'localhost' IDENTIFIED BY 'AuditPass2026!';
GRANT SELECT ON company_db.* TO 'auditor'@'localhost'; 

CREATE USER IF NOT EXISTS 'analyst'@'localhost' IDENTIFIED BY 'AnalystPass2026!';
GRANT SELECT ON company_db.* TO 'analyst'@'localhost'; 

CREATE USER IF NOT EXISTS 'manager'@'localhost' IDENTIFIED BY 'MgrPass2026!';
GRANT SELECT, INSERT, UPDATE ON company_db.orders TO 'manager'@'localhost';

CREATE USER IF NOT EXISTS 'dev_user'@'localhost' IDENTIFIED BY 'DevPass2026!';
GRANT SELECT, INSERT, UPDATE ON company_db.* TO 'dev_user'@'localhost';

CREATE USER IF NOT EXISTS 'hr_assistant'@'localhost' IDENTIFIED BY 'HrPass2026!';
GRANT SELECT, UPDATE ON company_db.employees TO 'hr_assistant'@'localhost';

CREATE USER IF NOT EXISTS 'finance_user'@'localhost' IDENTIFIED BY 'FinPass2026!';
GRANT SELECT, UPDATE ON company_db.departments TO 'finance_user'@'localhost'; 

CREATE USER IF NOT EXISTS 'team_lead'@'localhost' IDENTIFIED BY 'LeadPass2026!';
GRANT SELECT, INSERT ON company_db.* TO 'team_lead'@'localhost' WITH GRANT OPTION; 

FLUSH PRIVILEGES;

#Q1
GRANT SELECT ON company_db.* TO 'john'@'localhost';
FLUSH PRIVILEGES; 

#Q2
GRANT SELECT, INSERT ON company_db.employees TO 'alice'@'localhost';
FLUSH PRIVILEGES; 

#Q3

REVOKE INSERT ON company_db.employees FROM 'alice'@'localhost';
FLUSH PRIVILEGES;

#Q4

START TRANSACTION;
-- or simply: BEGIN; 

#Q5
COMMIT; 

#Q6
ROLLBACK; 

#Q7
SAVEPOINT sp_before_update; 

#Q8
GRANT ALL PRIVILEGES ON *.* TO 'admin_user'@'%';
FLUSH PRIVILEGES; 

#Q9
FLUSH PRIVILEGES; 


#Q10
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'intern_user'@'localhost';
FLUSH PRIVILEGES;

#Q11
START TRANSACTION;
INSERT INTO company_db.departments (dept_id, dept_name, location, budget)
VALUES (60, 'Quality Assurance', 'Building E', 180000.00);
COMMIT;

#Q12
START TRANSACTION;
DELETE FROM company_db.employees WHERE emp_id = 105;
ROLLBACK; 

#Q13
START TRANSACTION;
SAVEPOINT sp_step1;
RELEASE SAVEPOINT sp_step1;
COMMIT;

#Q14
GRANT DELETE ON company_db.orders TO 'manager'@'localhost';
FLUSH PRIVILEGES;

#Q15
GRANT DELETE ON company_db.orders TO 'manager'@'localhost';
FLUSH PRIVILEGES; 

#Q16
SET autocommit = 0; 

#Q17
SET autocommit = 1; 

#Q18
DELIMITER //

CREATE PROCEDURE company_db.sp_bonus()
BEGIN
    -- Placeholder logic for bonus calculation
    SELECT * FROM employees;
END //

DELIMITER ;

GRANT EXECUTE ON PROCEDURE company_db.sp_bonus TO 'finance_user'@'localhost';
FLUSH PRIVILEGES; 

#Q19
SHOW GRANTS FOR 'hr_assistant'@'localhost'; 

#20
START TRANSACTION;
SAVEPOINT sp_start;
UPDATE company_db.employees SET salary = 90000.00 WHERE emp_id = 101;
ROLLBACK TO SAVEPOINT sp_start;
COMMIT; 


#Q21
GRANT DELETE ON company_db.orders TO 'dev_user'@'localhost';
FLUSH PRIVILEGES; 

#Q22
START TRANSACTION;
UPDATE company_db.employees SET salary = 80000.00 WHERE emp_id = 101;
SAVEPOINT sp_first;
UPDATE company_db.employees SET salary = 95000.00 WHERE emp_id = 102;
ROLLBACK TO SAVEPOINT sp_first;
COMMIT; 

#Q23
REVOKE UPDATE ON company_db.employees FROM 'hr_assistant'@'localhost';
FLUSH PRIVILEGES;


#Q24
SET TRANSACTION READ ONLY;
START TRANSACTION;
SELECT * FROM company_db.employees;
SELECT * FROM company_db.orders;
COMMIT; 

#Q25
START TRANSACTION;
UPDATE company_db.employees SET salary = 85000.00 WHERE emp_id = 101;
ALTER TABLE company_db.employees ADD COLUMN middle_name VARCHAR(30);
ROLLBACK; 

#Q26
START TRANSACTION;
UPDATE company_db.departments SET budget = budget - 10000.00 WHERE dept_id = 10;
UPDATE company_db.departments SET budget = budget + 10000.00 WHERE dept_id = 20;
COMMIT;

#Q27
SHOW GRANTS FOR 'team_lead'@'localhost'; 

#Q28
REVOKE GRANT OPTION ON company_db.* FROM 'team_lead'@'localhost';
FLUSH PRIVILEGES; 

#Q29
START TRANSACTION;
UPDATE company_db.orders SET status = 'Shipped' WHERE order_id = 5002;
-- ValidaƟon check detects total_amount (450.00) < 500.00
ROLLBACK; 

#Q30
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

#Q31
CREATE ROLE 'reporter_role';
GRANT SELECT ON company_db.* TO 'reporter_role';
GRANT 'reporter_role' TO 'analyst'@'localhost';
SET DEFAULT ROLE 'reporter_role' TO 'analyst'@'localhost';
FLUSH PRIVILEGES; 

#Q32
START TRANSACTION;
INSERT INTO company_db.orders VALUES (5006, 'Delta Corp', '2024-02-01', 1500.00, 'Pending');
SAVEPOINT sp_batch1;
INSERT INTO company_db.orders VALUES (5007, 'Echo Inc', '2024-02-02', 2200.00, 'Pending');
ROLLBACK TO SAVEPOINT sp_batch1;
COMMIT; 

#Q33
ALTER USER 'temp_user'@'localhost' ACCOUNT LOCK;

#Q34
ALTER USER 'temp_user'@'localhost' ACCOUNT UNLOCK; 

#Q35
ALTER USER 'sec_user'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;

#Q36
-- Remove any lingering test departments from previous runs
DELETE FROM company_db.departments WHERE dept_id IN (60, 70, 80);

START TRANSACTION;
INSERT INTO company_db.departments VALUES (61, 'QA', 'Building B', 200000.00);
SAVEPOINT sp1;
INSERT INTO company_db.departments VALUES (70, 'Legal', 'Building C', 150000.00);
SAVEPOINT sp2;
INSERT INTO company_db.departments VALUES (80, 'PR', 'Building D', 100000.00);
SAVEPOINT sp3;
ROLLBACK TO SAVEPOINT sp2;
COMMIT; 

#Q37
GRANT SELECT (first_name, last_name) ON company_db.employees TO 'guest_user'@'localhost';
FLUSH PRIVILEGES;

#Q38
-- 1. Revoke the broad table-level UPDATE privilege
REVOKE UPDATE ON company_db.employees FROM 'hr_assistant'@'localhost';

-- 2. Re-grant UPDATE only on the permitted columns
GRANT UPDATE (first_name, last_name, dept_id, hire_date, is_active) 
ON company_db.employees TO 'hr_assistant'@'localhost';

FLUSH PRIVILEGES;

#Q39
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;

#Q40
CREATE USER 'ops_user'@'localhost' IDENTIFIED BY 'OpsPass2026!';
GRANT ALL PRIVILEGES ON company_db.orders TO 'ops_user'@'localhost';
REVOKE DELETE ON company_db.orders FROM 'ops_user'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'ops_user'@'localhost';

#Q41
START TRANSACTION;
UPDATE company_db.employees SET salary = salary * 1.15 WHERE dept_id = 10;
SAVEPOINT sp_salary_done;
UPDATE company_db.departments SET budget = budget + 50000.00 WHERE dept_id = 10;
-- Budget check: 500,000 + 50,000 = 550,000 > 520,000 (Limit Exceeded!)
ROLLBACK TO SAVEPOINT sp_salary_done;
COMMIT; 

#Q42
START TRANSACTION;
SELECT * FROM company_db.employees WHERE emp_id = 101 FOR UPDATE;
-- Exclusive row lock acquired. Concurrent writes on emp_id 101 block!
UPDATE company_db.employees SET salary = 88000.00 WHERE emp_id = 101;
COMMIT; 

#Q43
START TRANSACTION;
SELECT * FROM company_db.departments WHERE dept_id = 10 FOR SHARE;
-- Shared read lock acquired. Concurrent reads allowed; updates blocked!
COMMIT; 

#Q44
ALTER USER 'auditor'@'localhost'
 WITH MAX_QUERIES_PER_HOUR 100
 MAX_CONNECTIONS_PER_HOUR 20
 MAX_USER_CONNECTIONS 2;
FLUSH PRIVILEGES; 

#Q45
START TRANSACTION;
SAVEPOINT sp_cancel_start;
UPDATE company_db.orders SET status = 'Cancelled' WHERE order_id = 5002;
UPDATE company_db.departments SET budget = budget + 450.00 WHERE dept_id = 20;
COMMIT; 

#Q46
CREATE ROLE 'read_role', 'write_role', 'admin_role';
GRANT SELECT ON company_db.* TO 'read_role';
GRANT INSERT, UPDATE, DELETE ON company_db.* TO 'write_role';
GRANT 'read_role', 'write_role' TO 'admin_role';
CREATE USER 'super_dev'@'localhost' IDENTIFIED BY 'SuperPass2026!';
GRANT 'admin_role' TO 'super_dev'@'localhost';
SET DEFAULT ROLE ALL TO 'super_dev'@'localhost';
FLUSH PRIVILEGES; 

#Q47
/* Session 1 */ START TRANSACTION; UPDATE employees SET salary=80000 WHERE
emp_id=101;
/* Session 2 */ START TRANSACTION; UPDATE employees SET salary=55000 WHERE
emp_id=102;
/* Session 1 */ UPDATE employees SET salary=56000 WHERE emp_id=102; -- Waits...
/* Session 2 */ UPDATE employees SET salary=81000 WHERE emp_id=101; -- DEADLOCK DETECTED! 

#Q48
CREATE USER 'cloud_user'@'%' IDENTIFIED BY 'CloudSecure2026!' REQUIRE SSL;
GRANT SELECT, INSERT ON company_db.* TO 'cloud_user'@'%';
FLUSH PRIVILEGES; 

#Q49
START TRANSACTION;
INSERT INTO company_db.orders VALUES (5008, 'Corp A', '2024-02-05', 1200.00, 'Pending');
SAVEPOINT sp_5008;
INSERT INTO company_db.orders VALUES (5009, 'Corp B', '2024-02-05', 3400.00, 'Pending');
SAVEPOINT sp_5009; 

#Q50
-- 1. Provision Account
CREATE USER 'test_maint'@'localhost' IDENTIFIED BY 'MaintPass2026!';
GRANT SELECT, INSERT, UPDATE ON company_db.* TO 'test_maint'@'localhost';
FLUSH PRIVILEGES;

-- 2. Test Transaction
START TRANSACTION;
UPDATE company_db.employees SET is_active = FALSE WHERE emp_id = 104;
ROLLBACK;

-- 3. Audit, Revoke & Lock
SHOW GRANTS FOR 'test_maint'@'localhost';
-- REVOKE ALL PRIVILEGES ON company_db. FROM 'test_maint'@'localhost';
REVOKE SELECT, INSERT, UPDATE ON company_db.* FROM 'test_maint'@'localhost';
ALTER USER 'test_maint'@'localhost' ACCOUNT LOCK;
FLUSH PRIVILEGES; 


