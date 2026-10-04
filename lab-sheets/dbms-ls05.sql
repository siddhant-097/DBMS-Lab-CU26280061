CREATE DATABASE CollegeJoinDB;
USE CollegeJoinDB;

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT,
    Salary DECIMAL(10,2),
    City VARCHAR(50)
);

CREATE TABLE SalaryGrades (
    Grade CHAR(2) PRIMARY KEY,
    MinSalary DECIMAL(10,2),
    MaxSalary DECIMAL(10,2)
);

INSERT INTO Departments VALUES
(10, 'Computer Science', 'Block A'),
(20, 'Pharmacy', 'Block B'),
(30, 'Management', 'Block C'),
(40, 'Civil Engineering', 'Block D');

INSERT INTO Employees VALUES
(101, 'Aarav', 10, 65000, 'Delhi'),
(102, 'Priya', 20, 72000, 'Mumbai'),
(103, 'Rahul', 10, 48000, 'Delhi'),
(104, 'Sneha', 30, 91000, 'Pune'),
(105, 'Vikram', 20, 55000, 'Jaipur'),
(106, 'Neha', 50, 80000, 'Bengaluru'),
(107, 'Kabir', 30, 43000, 'Pune');

INSERT INTO SalaryGrades VALUES
('G1', 0, 49999),
('G2', 50000, 69999),
('G3', 70000, 89999),
('G4', 90000, 120000);

#Q1
SELECT e.EmpName, d.DeptName, d.Location
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID;

#Q2
SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID;

#Q3
SELECT e.EmpName, d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
WHERE d.DeptName = 'Pharmacy';

#Q4
SELECT e.EmpName, d.DeptName, e.Salary
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
WHERE e.Salary > 60000;

#Q5
SELECT e.EmpName, d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID;

#Q6
SELECT e.EmpName, e.City, d.DeptName, d.Location
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID;

#Q7
SELECT e.EmpName, d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
WHERE d.DeptName = 'Computer Science';

#Q8
SELECT e.EmpName, e.Salary, s.Grade, s.MinSalary
FROM Employees e
JOIN SalaryGrades s
ON e.Salary > s.MinSalary;

#Q9
SELECT e.EmpName, e.Salary, s.Grade
FROM Employees e
JOIN SalaryGrades s
ON e.Salary >= s.MinSalary
AND e.Salary <= s.MaxSalary;

#Q10
SELECT e.EmpName, e.Salary, s.Grade, s.MaxSalary
FROM Employees e
JOIN SalaryGrades s
ON e.Salary < s.MaxSalary;

#Q11
SELECT e.EmpName, e.Salary, s.Grade, s.MinSalary
FROM Employees e
JOIN SalaryGrades s
ON e.Salary >= s.MinSalary;

#Q12
SELECT EmpName, DeptID, DeptName
FROM Employees
NATURAL JOIN Departments;

#Q13
SELECT EmpName, DeptName, Location
FROM Employees
NATURAL JOIN Departments
WHERE Location = 'Block B';

#Q14
SELECT EmpName, DeptName, Salary
FROM Employees
NATURAL JOIN Departments
WHERE Salary >= 70000;

#Q15
SELECT e.EmpName, d.DeptName, e.Salary
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
ORDER BY e.Salary DESC;

#Q16
SELECT DISTINCT d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID;

#Q17
SELECT d.DeptName, COUNT(e.EmpID) AS EmployeeCount
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
GROUP BY d.DeptID, d.DeptName;

#Q18
SELECT d.DeptName, AVG(e.Salary) AS AverageSalary
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
GROUP BY d.DeptID, d.DeptName;

#Q19
SELECT d.DeptName, AVG(e.Salary) AS AverageSalary
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
GROUP BY d.DeptID, d.DeptName
HAVING AVG(e.Salary) > 60000;

#Q20
SELECT e.EmpName, d.DeptName, e.Salary
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
WHERE e.Salary = (
    SELECT MAX(e2.Salary)
    FROM Employees e2
    INNER JOIN Departments d2
    ON e2.DeptID = d2.DeptID
);

#Q21
SELECT e.EmpName, d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
WHERE d.DeptName IN ('Computer Science', 'Pharmacy');

#Q22
SELECT e.EmpName, e.City, e.Salary, d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
WHERE e.City IN ('Delhi', 'Pune')
AND e.Salary >= 50000;

#Q23
SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID;

#Q24
SELECT DeptName, COUNT(EmpID) AS EmployeeCount
FROM Employees
NATURAL JOIN Departments
GROUP BY DeptID, DeptName;

#Q25
SELECT d.DeptName, SUM(e.Salary) AS TotalSalary
FROM Employees e
INNER JOIN Departments d
ON e.DeptID = d.DeptID
GROUP BY d.DeptID, d.DeptName
HAVING SUM(e.Salary) > 100000;