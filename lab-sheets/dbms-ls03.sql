#Q1
GRANT SELECT
ON company_db.*
TO 'john'@'localhost';

#Q2
GRANT SELECT, INSERT
ON company_db.employees
TO 'alice'@'localhost';

#Q3
REVOKE INSERT
ON company_db.employees
FROM 'alice'@'localhost';

#Q4
START TRANSACTION;

#Q5
COMMIT;

#Q6
ROLLBACK;

#Q7
SAVEPOINT sp_before_update;

#Q8
GRANT ALL PRIVILEGES
ON *.*
TO 'admin_user'@'%';

#Q9
FLUSH PRIVILEGES;

#Q10
REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'intern_user'@'localhost';

#Q11
GRANT DELETE
ON company_db.orders
TO 'dev_user'@'localhost';

#Q12
START TRANSACTION;

UPDATE company_db.employees
SET salary = 80000.00
WHERE emp_id = 101;

SAVEPOINT sp_first;

UPDATE company_db.employees
SET salary = 95000.00
WHERE emp_id = 102;

ROLLBACK TO SAVEPOINT sp_first;

COMMIT;

#Q13
REVOKE UPDATE
ON company_db.employees
FROM 'hr_assistant'@'localhost';

#Q14
SET TRANSACTION READ ONLY;
START TRANSACTION;

SELECT *
FROM company_db.employees;

#Q15
START TRANSACTION;

UPDATE company_db.employees
SET salary = 85000.00
WHERE emp_id = 101;

ALTER TABLE company_db.employees
ADD COLUMN temp_column INT;

ROLLBACK;

#Q16
START TRANSACTION;

UPDATE company_db.departments
SET budget = budget - 10000.00
WHERE dept_id = 10;

UPDATE company_db.departments
SET budget = budget + 10000.00
WHERE dept_id = 20;

COMMIT;

#Q17
SHOW GRANTS
FOR 'team_lead'@'localhost';

#Q18
REVOKE GRANT OPTION
FROM 'team_lead'@'localhost';

#Q19
START TRANSACTION;

UPDATE company_db.orders
SET status = 'Shipped'
WHERE order_id = 5002;

SELECT total_amount
FROM company_db.orders
WHERE order_id = 5002;

#Q20
CREATE ROLE 'reporter_role';

GRANT SELECT
ON company_db.*
TO 'reporter_role';

GRANT 'reporter_role'
TO 'analyst'@'localhost';

#Q21
START TRANSACTION;

UPDATE company_db.employees
SET salary = salary * 1.15
WHERE dept_id = 10;

SAVEPOINT sp_salary_done;

UPDATE company_db.departments
SET budget = budget + 50000.00
WHERE dept_id = 10;

-- Check whether the budget exceeds 520000-- 
SELECT budget
FROM company_db.departments
WHERE dept_id = 10;

#Q22
START TRANSACTION;

SELECT *
FROM company_db.employees
WHERE emp_id = 101
FOR UPDATE;

UPDATE company_db.employees
SET salary = 88000.00
WHERE emp_id = 101;

COMMIT;

#Q23
START TRANSACTION;

SELECT *
FROM company_db.departments
WHERE dept_id = 10
FOR SHARE;

SELECT *
FROM company_db.departments
WHERE dept_id = 10;

COMMIT;

#Q24
ALTER USER 'auditor'@'localhost'
WITH MAX_QUERIES_PER_HOUR 100
     MAX_USER_CONNECTIONS 2;
     
#Q25
START TRANSACTION;

UPDATE company_db.orders
SET status = 'Cancelled'
WHERE order_id = 5002
  AND status <> 'Cancelled';

UPDATE company_db.departments
SET budget = budget + 450.00
WHERE dept_id = 20;

COMMIT;

#Q26
CREATE ROLE 'read_role';
CREATE ROLE 'write_role';
CREATE ROLE 'admin_role';

GRANT SELECT
ON company_db.*
TO 'read_role';

GRANT INSERT, UPDATE
ON company_db.*
TO 'write_role';

GRANT 'read_role', 'write_role'
TO 'admin_role';

CREATE USER 'super_dev'@'localhost'
IDENTIFIED BY 'SuperDevPass2026!';

GRANT 'admin_role'
TO 'super_dev'@'localhost';

SET DEFAULT ROLE 'admin_role'
TO 'super_dev'@'localhost';

#Q27

-- Session 1 – dev_user-- 
START TRANSACTION;

SELECT *
FROM company_db.employees
WHERE emp_id = 101
FOR UPDATE;

UPDATE company_db.employees
SET salary = salary + 1000
WHERE emp_id = 102;

START TRANSACTION;

-- Session 2 – hr_assistant-- 
SELECT *
FROM company_db.employees
WHERE emp_id = 102
FOR UPDATE;

UPDATE company_db.employees
SET salary = salary + 1000
WHERE emp_id = 101;

#Q28
CREATE USER 'cloud_user'@'%'
IDENTIFIED BY 'CloudPass2026!'
REQUIRE SSL;

GRANT SELECT, INSERT
ON company_db.*
TO 'cloud_user'@'%';

#Q29
START TRANSACTION;

INSERT INTO company_db.orders
(order_id, customer_name, order_date, total_amount, status)
VALUES
(5008, 'Customer A', '2024-02-01', 700.00, 'Pending');

SAVEPOINT sp_5008;

INSERT INTO company_db.orders
(order_id, customer_name, order_date, total_amount, status)
VALUES
(5009, 'Customer B', '2024-02-02', 900.00, 'Pending');

SAVEPOINT sp_5009;

-- If order 5009 fails business rules:
ROLLBACK TO SAVEPOINT sp_5008;

COMMIT;

#Q30
CREATE USER 'test_maint'@'localhost'
IDENTIFIED BY 'TestMaintPass2026!';

GRANT SELECT, INSERT, UPDATE
ON company_db.*
TO 'test_maint'@'localhost';

START TRANSACTION;

UPDATE company_db.employees
SET is_active = TRUE
WHERE emp_id = 104;

ROLLBACK;

SHOW GRANTS
FOR 'test_maint'@'localhost';

REVOKE SELECT, INSERT, UPDATE
ON company_db.*
FROM 'test_maint'@'localhost';

ALTER USER 'test_maint'@'localhost'
ACCOUNT LOCK;



