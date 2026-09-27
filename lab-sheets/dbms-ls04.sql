CREATE DATABASE dbms_ls04;
USE dbms_ls04;

#Q1
# Department: DeptID. It uniquely identifies each department and cannot be NULL because it is a primary key. 

#Q2
CREATE TABLE Department (
 DeptID INT PRIMARY KEY,
 DeptName VARCHAR(50) NOT NULL
);
INSERT INTO Department VALUES
(10,'Computer Science'),
(20,'Information Technology'),
(30,'Pharmacy'), 
(40,'Management');

#Q3
CREATE TABLE Student (
 StudentID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL,
 Email VARCHAR(100),
 Age INT,
 DeptID INT,
 JoiningDate DATE
);
INSERT INTO Student VALUES
(101,'Amit Sharma','amit@example.com',20,10,'2026-07-01'),
(102,'Priya Singh','priya@example.com',21,20,'2026-07-03'),
(103,'Rahul Verma','rahul@example.com',22,30,'2026-07-05'),
(104,'Neha Gupta','neha@example.com',20,10,'2026-07-08'),
(105,'Arjun Mehta','arjun@example.com',23,40,'2026-07-10');

#Q4
INSERT INTO Student VALUES (101,'Karan Shah','karan@example.com',21,20,'2026-08-01');

#Q5
CREATE TABLE Enrollment (
 EnrollmentID INT PRIMARY KEY,
 StudentID INT,
 CourseName VARCHAR(100)
);
INSERT INTO Enrollment VALUES
(1,101,'DBMS'), 
(2,102,'Operating Systems'),
(3,103,'Pharmacology'), 
(4,104,'Python');

#Q6
INSERT INTO Enrollment VALUES (1,105,'Data Mining');

#Q7
ALTER TABLE Student 
ADD CONSTRAINT fk_student_department FOREIGN KEY (DeptID) 
REFERENCES Department(DeptID);

#Q8
ALTER TABLE Enrollment 
ADD CONSTRAINT fk_enrollment_student FOREIGN KEY (StudentID) 
REFERENCES Student(StudentID);

#Q9
INSERT INTO Student VALUES (106,'Riya Das','riya@example.com',21,99,'2026-08-01');

#Q10
INSERT INTO Enrollment VALUES (5,999,'DBMS');

#Q11
SELECT s.StudentID, s.Name, d.DeptName FROM Student s INNER JOIN Department d ON s.DeptID = d.DeptID;

#Q12
SELECT e.EnrollmentID, s.Name, e.CourseName FROM Enrollment e INNER JOIN Student s ON e.StudentID = s.StudentID;

#Q13
CREATE TABLE Department2 (
 DeptID INT PRIMARY KEY,
 DeptName VARCHAR(50) NOT NULL
);
INSERT INTO Department2 VALUES (50,NULL);

#Q14
INSERT INTO Student (StudentID, Email, Age, DeptID) VALUES
(106,'riya@example.com',21,20);

#Q15
ALTER TABLE Student
ADD CONSTRAINT uq_student_email UNIQUE (Email);
INSERT INTO Student
VALUES (106,'Riya Das','amit@example.com',21,20,'2026-08-01');

#Q16
CREATE TABLE Library (
 BookID INT UNIQUE,
 Title VARCHAR(150) NOT NULL
);
INSERT INTO Library VALUES
(1,'Database Systems'),
(2,'Operating Systems'),
(3,'Computer Networks'),
(4,'Python Programming'),
(5,'Data Mining');

#Q17
ALTER TABLE Student
ADD CONSTRAINT chk_student_age CHECK (Age > 18);
INSERT INTO Student
VALUES (106,'Riya Das','riya@example.com',17,20,'2026-08-01');

#Q18
CREATE TABLE Course (
 CourseID INT PRIMARY KEY,
 CourseName VARCHAR(100),
 Credits INT CHECK (Credits BETWEEN 1 AND 6)
);
INSERT INTO Course VALUES (1,'DBMS',8);

#Q19
ALTER TABLE Student
ADD COLUMN JoiningDate2 DATE DEFAULT (CURRENT_DATE);
INSERT INTO Student (StudentID,Name,Email,Age,DeptID)
VALUES (106,'Riya Das','riya@example.com',21,20);

SELECT * FROM Student;

#Q20
CREATE TABLE Faculty (
 FacultyID INT PRIMARY KEY,
 FacultyName VARCHAR(100) NOT NULL,
 Designation VARCHAR(50) DEFAULT 'Lecturer'
);
INSERT INTO Faculty (FacultyID, FacultyName)
VALUES (1,'Dr. Meera Sharma');

SELECT * FROM Faculty;

#Q21
CREATE TABLE employees (
 emp_id INT PRIMARY KEY,
 name VARCHAR(80),
 department VARCHAR(50),
 salary DECIMAL(10,2),
 hire_date DATE
);

#Q22
INSERT INTO employees VALUES (101,'John Smith','IT',55000,'2024-01-15');

#Q23
INSERT INTO employees VALUES
(102,'Sarah Johnson','HR',48000,'2024-02-10'),
(103,'Mike Davis','Finance',52000,'2024-01-20'),
(104,'Lisa Wilson','Marketing',45000,'2024-03-01');

#Q24
INSERT INTO employees (emp_id,name,department) VALUES (107,'David Clark','Sales');

#Q25
SELECT * FROM employees;

#Q26
SELECT * FROM employees;

#Q27
SELECT name, salary FROM employees;

#Q28
SELECT * FROM employees WHERE department = 'IT';

#Q29
SELECT * FROM employees WHERE salary > 50000;

#Q30
SELECT * FROM employees WHERE hire_date BETWEEN '2024-01-01' AND '2024-01-31';

#Q31
SELECT DISTINCT department FROM employees;

#Q32
SELECT COUNT(*) AS total_employees FROM employees;

#Q33
SELECT MAX(salary) AS maximum_salary, MIN(salary) AS minimum_salary, AVG(salary) AS
average_salary FROM employees;

#Q34
UPDATE employees SET salary = 58000 WHERE name = 'John Smith';

#Q35
UPDATE employees SET salary = salary * 1.05 WHERE department = 'HR';

#Q36
UPDATE employees SET salary = 47000, hire_date = '2024-03-05' WHERE name = 'Lisa
Wilson';

#Q37
UPDATE employees SET department = 'Operations' WHERE salary < 50000;

#Q38
UPDATE employees SET salary = salary + 2000 WHERE department = 'Finance';

#Q39
UPDATE employees SET department = 'Senior Staff' WHERE hire_date < '2024-02-01';

#Q40
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

INSERT INTO products (product_id, product_name, category, price, stock_quantity) VALUES
(1, 'Laptop', 'Electronics', 999.99, 5),
(2, 'Mouse', 'Electronics', 25.50, 0),
(3, 'Desk Chair', 'Furniture', 150.00, 3),
(4, 'Monitor', 'Electronics', 1200.00, 2),
(5, 'Keyboard', 'Electronics', 75.00, 0),
(6, 'Coffee Mug', 'Office', 12.99, 10),
(7, 'Notebook', 'Office', 5.99, 8),
(8, 'Smartphone', 'Electronics', 1500.00, 1);

DELETE FROM products WHERE stock_quantity = 0;

#Q41
DELETE FROM products WHERE category = 'Electronics' AND price > 1000;

#Q42
DELETE FROM products WHERE product_name = 'Desk Chair';

#Q43
DELETE FROM products WHERE price < 100;

#Q44
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    course VARCHAR(50) NOT NULL,
    marks INT NOT NULL,
    city VARCHAR(50) NOT NULL
);

INSERT INTO students (student_id, student_name, course, marks, city) VALUES
(1, 'Alice Brown', 'Computer Science', 85, 'Mumbai'),
(2, 'Bob Wilson', 'Mathematics', 92, 'Delhi'),
(3, 'Carol Davis', 'Computer Science', 78, 'Mumbai'),
(4, 'David Miller', 'Physics', 88, 'Chennai'),
(5, 'Eva Garcia', 'Mathematics', 95, 'Delhi'),
(6, 'Frank Johnson', 'Computer Science', 82, 'Bangalore'),
(7, 'Grace Lee', 'Physics', 90, 'Mumbai'),
(8, 'Henry Smith', 'Mathematics', 76, 'Chennai'),
(9, 'Ivy Chen', 'Computer Science', 89, 'Delhi'),
(10, 'Jack Taylor', 'Physics', 84, 'Bangalore');

SELECT * FROM students ORDER BY marks DESC;

#Q45
SELECT * FROM students ORDER BY marks DESC LIMIT 5;

#Q46
SELECT * FROM students WHERE course = 'Computer Science' ORDER BY student_name
ASC;

#Q47
SELECT * FROM students ORDER BY marks ASC LIMIT 3;

#Q48
SELECT * FROM students WHERE marks BETWEEN 80 AND 90;

#Q49
SELECT * FROM students WHERE student_name LIKE 'A%';

#Q50
SELECT * FROM students WHERE city IN ('Mumbai','Delhi');

#Q51
CREATE TABLE Books (
 book_id INT PRIMARY KEY,
 title VARCHAR(255) NOT NULL,
 author VARCHAR(255),
 isbn VARCHAR(13) UNIQUE,
 genre VARCHAR(50)
);

#Q52
CREATE TABLE Members (
 member_id INT PRIMARY KEY,
 name VARCHAR(255) NOT NULL,
 email VARCHAR(255) UNIQUE,
 phone_number VARCHAR(20)
);

#Q53
CREATE TABLE Loans (
 loan_id INT PRIMARY KEY,
 book_id INT,
 member_id INT,
 loan_date DATE,
 return_date DATE NULL,
 FOREIGN KEY (book_id) REFERENCES Books(book_id),
 FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


#Q54
INSERT INTO Books VALUES
(1,'Database System Concepts','Korth','9780073523323','Database'),
(2,'Operating System Concepts','Silberschatz','9781119456339','OS'),
(3,'Python Crash Course','Eric Matthes','9781718502703','Programming');

INSERT INTO Members VALUES
(101,'Amit Sharma','amit.lib@example.com','9876500001'),
(102,'Priya Singh','priya.lib@example.com','9876500002'),
(103,'Rahul Verma','rahul.lib@example.com','9876500003');

INSERT INTO Loans VALUES
(1,1,101,'2026-09-01',NULL),
(2,2,102,'2026-09-02','2026-09-06'),
(3,3,103,'2026-09-04',NULL);

#Q55
SELECT l.loan_id, b.title, m.name, l.loan_date, l.return_date
FROM Loans l
INNER JOIN Books b ON l.book_id = b.book_id
INNER JOIN Members m ON l.member_id = m.member_id;




