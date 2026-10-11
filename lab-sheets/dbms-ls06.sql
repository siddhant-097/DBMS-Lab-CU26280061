CREATE DATABASE dbms_ls06;
USE dbms_ls06;

CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Marks DECIMAL(5,2),
    DeptID INT,
    Email VARCHAR(100),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50) NOT NULL,
    Credits INT
);

INSERT INTO Department VALUES
(101, 'Computer Science', 'Block A'),
(102, 'Pharmacy', 'Block B'),
(103, 'Commerce', 'Block C'),
(104, 'Mathematics', 'Block D');

INSERT INTO Student VALUES
(1, 'Amit', 20, 'Male', 85.50, 101, 'amit@gmail.com'),
(2, 'Priya', 21, 'Female', 92.00, 102, 'priya@gmail.com'),
(3, 'Rahul', 19, 'Male', 76.50, 101, 'rahul@gmail.com'),
(4, 'Neha', 22, 'Female', 88.00, 103, 'neha@gmail.com'),
(5, 'Arjun', 20, 'Male', 69.50, 104, 'arjun@gmail.com'),
(6, 'Sneha', 21, 'Female', 95.00, 102, 'sneha@gmail.com'),
(7, 'Rohit', 23, 'Male', 72.00, 103, 'rohit@gmail.com'),
(8, 'Pooja', 20, 'Female', 81.00, 104, 'pooja@gmail.com');

INSERT INTO Course VALUES
(201, 'Database Management System', 4),
(202, 'Python Programming', 4),
(203, 'Mathematics', 3),
(204, 'Computer Networks', 3),
(205, 'Data Structures', 4);

#Q1
DELIMITER //

CREATE PROCEDURE ShowStudents()
BEGIN
    SELECT * FROM Student;
END //

DELIMITER ;

CALL ShowStudents();

#Q2
DELIMITER //

CREATE PROCEDURE ShowDepartments()
BEGIN
    SELECT * FROM Department;
END //

DELIMITER ;

CALL ShowDepartments();

#Q3
DELIMITER //

CREATE PROCEDURE ShowCourses()
BEGIN
    SELECT * FROM Course;
END //

DELIMITER ;

CALL ShowCourses();

#Q4
DELIMITER //

CREATE PROCEDURE GetStudent(IN p_StudentID INT)
BEGIN
    SELECT *
    FROM Student
    WHERE StudentID = p_StudentID;
END //

DELIMITER ;

CALL GetStudent(3);

#Q5
DELIMITER //

CREATE PROCEDURE GetStudentsByDept(IN p_DeptID INT)
BEGIN
    SELECT *
    FROM Student
    WHERE DeptID = p_DeptID;
END //

DELIMITER ;

CALL GetStudentsByDept(102);

#Q6
DELIMITER //

CREATE PROCEDURE StudentsAboveMarks(IN p_Marks DECIMAL(5,2))
BEGIN
    SELECT *
    FROM Student
    WHERE Marks > p_Marks;
END //

DELIMITER ;

CALL StudentsAboveMarks(80);

#Q7
DELIMITER //

CREATE PROCEDURE TotalStudents()
BEGIN
    SELECT COUNT(*) AS TotalStudents
    FROM Student;
END //

DELIMITER ;

CALL TotalStudents();

#Q8
DELIMITER //

CREATE PROCEDURE CheckResult(IN p_StudentID INT)
BEGIN
    DECLARE v_Marks DECIMAL(5,2);

    SELECT Marks INTO v_Marks
    FROM Student
    WHERE StudentID = p_StudentID;

    IF v_Marks >= 50 THEN
        SELECT 'Pass' AS Result;
    ELSE
        SELECT 'Fail' AS Result;
    END IF;
END //

DELIMITER ;

CALL CheckResult(3);

#Q9
DELIMITER //

CREATE PROCEDURE GetStudentsByGender(IN p_Gender VARCHAR(10))
BEGIN
    SELECT *
    FROM Student
    WHERE Gender = p_Gender;
END //

DELIMITER ;

CALL GetStudentsByGender('Female');

#Q10
DELIMITER //

CREATE PROCEDURE StudentsBetweenMarks(
    IN p_MinMarks DECIMAL(5,2),
    IN p_MaxMarks DECIMAL(5,2)
)
BEGIN
    SELECT *
    FROM Student
    WHERE Marks BETWEEN p_MinMarks AND p_MaxMarks;
END //

DELIMITER ;

CALL StudentsBetweenMarks(70, 90);

#Q11
DELIMITER //

CREATE FUNCTION AddTwoNumbers(
    a INT,
    b INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END //

DELIMITER ;

SELECT AddTwoNumbers(10, 20) AS Sum;

#Q12
DELIMITER //

CREATE FUNCTION FindSquare(n INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN n * n;
END //

DELIMITER ;

SELECT FindSquare(5) AS Square;

#Q13
DELIMITER //

CREATE FUNCTION ResultStatus(p_Marks DECIMAL(5,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF p_Marks >= 50 THEN
        RETURN 'Pass';
    ELSE
        RETURN 'Fail';
    END IF;
END //

DELIMITER ;

SELECT ResultStatus(76.50) AS Result;
SELECT ResultStatus(40) AS Result;

#Q14
DELIMITER //

CREATE FUNCTION StudentGrade(p_Marks DECIMAL(5,2))
RETURNS CHAR(1)
DETERMINISTIC
BEGIN
    CASE
        WHEN p_Marks >= 90 THEN RETURN 'A';
        WHEN p_Marks >= 75 THEN RETURN 'B';
        WHEN p_Marks >= 60 THEN RETURN 'C';
        ELSE RETURN 'D';
    END CASE;
END //

DELIMITER ;

SELECT StudentGrade(92) AS Grade;

#Q15
DELIMITER //

CREATE FUNCTION AgeCategory(p_Age INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF p_Age >= 18 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Minor';
    END IF;
END //

DELIMITER ;

SELECT AgeCategory(20) AS Category;

#Q16
DELIMITER //

CREATE FUNCTION CalculateBonus(p_Marks DECIMAL(5,2))
RETURNS INT
DETERMINISTIC
BEGIN
    IF p_Marks >= 90 THEN
        RETURN 1000;
    ELSEIF p_Marks >= 75 THEN
        RETURN 500;
    ELSE
        RETURN 200;
    END IF;
END //

DELIMITER ;

SELECT CalculateBonus(92) AS Bonus;

#Q17
DELIMITER //

CREATE FUNCTION HigherNumber(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    IF a >= b THEN
        RETURN a;
    ELSE
        RETURN b;
    END IF;
END //

DELIMITER ;

SELECT HigherNumber(25, 40) AS HigherValue;

#Q18
DELIMITER //

CREATE FUNCTION DoubleMarks(p_Marks DECIMAL(5,2))
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
    RETURN p_Marks * 2;
END //

DELIMITER ;

SELECT DoubleMarks(45.50) AS DoubleValue;

#Q19
DELIMITER //

CREATE FUNCTION AgeAfterFiveYears(p_Age INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN p_Age + 5;
END //

DELIMITER ;

SELECT AgeAfterFiveYears(20) AS FutureAge;

#Q20
SELECT
    StudentName,
    Marks,
    StudentGrade(Marks) AS Grade
FROM Student;