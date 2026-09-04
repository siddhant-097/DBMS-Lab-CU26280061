show databases;

create database dbms_ps02;

use dbms_ps02;

#Reference Tables
# TABLE 1
CREATE TABLE employees(
	emp_id INT PRIMARY KEY,
    first_name VARCHAR(10),
    last_name VARCHAR (10),
    dept_id TINYINT,
    salary FLOAT,
    hire_date DATE,
    is_active BOOL
);
INSERT INTO employees(emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
VALUES 
	(101, 'Alice','Smith', 10, 75000.0, '2021-03-15', TRUE),
    (102, 'Bob', 'Johnson', 20, 52000.0, '2022-06-01', TRUE),
    (103, 'Charlie', 'Brown', 10, 82000.0, '2019-11-20', TRUE),
    (104, 'Diana', 'Prince', 30, 48000.0, '2023-01-10', FALSE),
    (105, 'Evan', 'Wright', 20, 61000.0, '2020-08-05', TRUE)
;

# TABLE 2
CREATE TABLE departments(
	dept_id TINYINT PRIMARY KEY,
    dept_name VARCHAR(20),
    location VARCHAR(20),
    budget FLOAT
);
INSERT INTO departments(dept_id, dept_name, location, budget)
VALUES
	(10, 'Engineering', 'Building A', 500000.0),
    (20, 'Marketing', 'Building B', 200000.0),
    (30, 'Human Resources', 'Building A', 150000.0),
    (40, 'Finance', 'Building C', 350000.0),
    (50, 'Research', 'Building D', 600000.0)
;

# TABLE 3
CREATE TABLE orders(
	order_id SMALLINT PRIMARY KEY,
    customer_name VARCHAR(25),
    order_date DATE,
    total_amount FLOAT, 
    status ENUM('Pending', 'Completed', 'Cancelled', 'Shipped')
);
INSERT INTO orders(order_id, customer_name, order_date, total_amount, status)
VALUES
	(5001, 'TechCorp LLP', '2024-01-15', 1250.5, 'Completed'),
    (5002, 'Global Media', '2024-01-18', 450.0, 'Pending'),
    (5003, 'Alpha Retail', '2024-01-20', 3100.0, 'Completed'),
    (5004, 'Beta Systems', '2024-01-22', 150.25, 'Cancelled'),
    (5005, 'Gamma Inc', '2024-01-25', 890.0, 'Shipped')
;



#Q1
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
VALUES (106, 'Fiona', 'Gallagher', 10, 65000.00, '2024-02-01', TRUE);

#Q2
INSERT INTO departments (dept_id, dept_name, location, budget)
VALUES (60, 'Quality Assurance', 'Building B', 250000.00);

#Q3
INSERT INTO orders (order_id, customer_name, order_date, total_amount, status)
VALUES (5006, 'Delta Retail', '2024-01-28', 2100.00, 'Pending');

#Q4
SELECT * FROM employees;

#Q5
SELECT first_name, last_name, salary FROM employees;

#Q6
SELECT * FROM employees
WHERE  dept_id = 10;

#Q7
SELECT * FROM orders
WHERE status = 'Completed';

#Q8
UPDATE employees
SET salary = 55000.00
WHERE emp_id = 102;

#Q9
UPDATE orders
SET status = 'Shipped'
WHERE order_id = 5002;

#Q10
UPDATE departments
SET budget = budget + 20000.00
WHERE dept_id = 20;

#Q11
DELETE FROM orders
WHERE order_id = 5004;

#Q12
DELETE FROM employees
WHERE emp_id = 104;

#Q13
SELECT * FROM employees
WHERE salary > 60000.00;

#Q14
SELECT * FROM orders
WHERE order_date BETWEEN '2024-01-15' AND '2024-01-20';

#Q15
SELECT * FROM departments
WHERE location IN ('Building A', 'Building B');

#Q16
SELECT * FROM employees
WHERE last_name LIKE 'S%';

#Q17
SELECT * FROM employees
ORDER BY salary DESC;

#Q18
SELECT * FROM departments
ORDER BY dept_name ASC;

#Q19
SELECT COUNT(*) AS total_employees FROM employees;

#Q20
SELECT AVG(total_amount) AS average_order_value FROM orders;

#Q21
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
VALUES
 (104, 'George', 'Clark', 30, 50000.00, '2024-02-05', TRUE),
 (107, 'Hannah', 'Abbott', 10, 71000.00, '2024-02-10', TRUE)
;

#Q22 not working due to safe mode (dept_id not key column)
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 10;

#alternative
UPDATE employees
SET salary = salary * 1.10
WHERE emp_id IN (101, 103, 106, 107);

#23 -> same problem -> disable safe mode
UPDATE employees
SET is_active = FALSE
WHERE hire_date < '2021-01-01';

#Q24
SELECT * FROM employees
WHERE is_active = TRUE AND salary > 60000.00;

#Q25
SELECT * FROM orders
WHERE status = 'Cancelled' OR total_amount > 2000.00;

#Q26
SELECT * FROM employees
WHERE dept_id NOT IN (10, 30);

#Q27
SELECT * FROM employees
WHERE LOWER(first_name) LIKE '%a%';

#Q28
SELECT dept_id, SUM(salary) AS total_department_salary 
FROM employees
GROUP BY dept_id;

#Q29
SELECT dept_id, COUNT(emp_id) AS employee_count
FROM employees
GROUP BY dept_id;

#Q30
SELECT dept_id, SUM(salary) AS total_salary
FROM employees
GROUP BY dept_id
HAVING SUM(salary) > 100000.00;

#Q31
SELECT status, MAX(total_amount) AS max_amount, MIN(total_amount) AS min_amount
FROM orders
GROUP BY status;

#Q32
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

#Q33
SELECT * FROM employees
WHERE dept_id IN (
 SELECT dept_id FROM departments WHERE location = 'Building A'
);

#34
DELETE FROM orders
WHERE customer_name IN (
 SELECT customer_name FROM orders WHERE status = 'Cancelled'
);

#Q35
SELECT * FROM employees
WHERE last_name IS NULL;

#36
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;

#Q37
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 3;

#Q38
SELECT * FROM employees
ORDER BY dept_id ASC, salary DESC;

#Q39
DELETE FROM departments
WHERE budget < 200000.00;

#Q40
UPDATE orders
SET status = 'Cancelled'
WHERE total_amount < 200.00;

#41
UPDATE employees
SET salary = salary * 1.15
WHERE dept_id = (
 SELECT dept_id FROM departments ORDER BY budget DESC LIMIT 1
);

#42
SELECT dept_id, AVG(salary) AS dept_avg
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

#43
SELECT * FROM employees
WHERE dept_id IN (
 SELECT dept_id FROM departments WHERE budget > 300000.00
);

#44
SELECT DISTINCT salary FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

#Q45
UPDATE employees
SET salary = CASE
 WHEN salary < 60000.00 THEN salary * 1.10
 ELSE salary * 1.05
END;

#Q46
DELETE FROM employees e
WHERE is_active = FALSE
AND salary < (
 SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id
);

#Q47
SELECT d.dept_name,
 (SELECT COUNT(*) FROM employees e WHERE e.dept_id = d.dept_id) AS total_emp
FROM departments d;

#Q48
SELECT customer_name, COUNT(order_id) AS total_orders, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_name
HAVING COUNT(order_id) > 1 OR SUM(total_amount) > 1000.00;

#Q49
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
SELECT emp_id + 500, first_name, last_name, 50, salary, CURRENT_DATE, is_active
FROM employees
WHERE dept_id = 10;

#Q50
UPDATE orders
SET status = CASE
 WHEN total_amount > 1000.00 THEN 'Completed'
 WHEN total_amount BETWEEN 500.00 AND 1000.00 THEN 'Shipped'
 ELSE 'Pending'
END;
