CREATE DATABASE sql_lab;
USE sql_lab;

#Q2
CREATE TABLE Department (
 DeptID INT PRIMARY KEY,
 DeptName VARCHAR(50) NOT NULL
);
INSERT INTO Department VALUES
(10,'Computer Science'), (20,'Information Technology'),
(30,'Pharmacy'), (40,'Management');

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
INSERT INTO Student VALUES 
(101, 'Siddhant Chaudhary', 'siddhant@example.com', 23, 20, '2026-07-22');

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
INSERT INTO Enrollment VALUES
(1, 105, 'DBMS');

#Q7
ALTER TABLE student ADD CONSTRAINT fk_student_department FOREIGN KEY (DeptID) REFERENCES Department(DeptID);

#OR ALTER TABLE student ADD FOREIGN KEY (DeptID) REFERENCES Department(DeptID);
DESC STUDENT;

DESC DEPARTMENT;

#Q8
ALTER TABLE enrollment ADD CONSTRAINT fk_enrollment_student FOREIGN KEY (StudentID) REFERENCES Student(StudentID);

#Q9
INSERT INTO student VALUES
(106,'Riya Das','riya@example.com',21,99,'2026-08-01');

#Q10
INSERT INTO enrollment VALUES 
(5, 999, 'DBMS');

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
INSERT INTO student (StudentID, Email, Age, DeptID) VALUES
(106, 'aman@example', 20, 10, '2026-07-10' );

#Q15
ALTER TABLE student 
ADD CONSTRAINT uq_student_email UNIQUE(Email);

INSERT INTO Student VALUES 
(106,'Riya Das','amit@example.com',21,20,'2026-08-01');


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
ALTER TABLE student
ADD CONSTRAINT chk_student_age CHECK (age>18);
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
