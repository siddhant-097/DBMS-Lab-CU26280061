CREATE DATABASE dbms_ps06;
USE dbms_ps06;

CREATE TABLE Department
(
 DeptID INT PRIMARY KEY,
 DeptName VARCHAR(50) NOT NULL,
 Location VARCHAR(50)
);
CREATE TABLE Student
(
 StudentID INT PRIMARY KEY,
 StudentName VARCHAR(50) NOT NULL,
 Age INT,
 Gender VARCHAR(10),
 Marks DECIMAL(5,2),
 DeptID INT,
 Email VARCHAR(100),
 FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);
CREATE TABLE Course
(
 CourseID INT PRIMARY KEY,
 CourseName VARCHAR(50) NOT NULL,
 Credits INT
);


INSERT INTO Department
VALUES
(101, 'Computer Science', 'Block A'),
(102, 'Pharmacy', 'Block B'),
(103, 'Commerce', 'Block C'),
(104, 'Mathematics', 'Block D');
INSERT INTO Student
VALUES
(1, 'Amit', 20, 'Male', 85.50, 101, 'amit@gmail.com'),
(2, 'Priya', 21, 'Female', 92.00, 102, 'priya@gmail.com'),
(3, 'Rahul', 19, 'Male', 76.50, 101, 'rahul@gmail.com'),
(4, 'Neha', 22, 'Female', 88.00, 103, 'neha@gmail.com'),
(5, 'Arjun', 20, 'Male', 69.50, 104, 'arjun@gmail.com'),
(6, 'Sneha', 21, 'Female', 95.00, 102, 'sneha@gmail.com'),
(7, 'Rohit', 23, 'Male', 72.00, 103, 'rohit@gmail.com'),
(8, 'Pooja', 20, 'Female', 81.00, 104, 'pooja@gmail.com');
INSERT INTO Course
VALUES
(201, 'Database Management System', 4),
(202, 'Python Programming', 4),
(203, 'Mathematics', 3),
(204, 'Computer Networks', 3),
(205, 'Data Structures', 4);

SELECT * FROM Department;
SELECT * FROM Student;
SELECT * FROM Course;

DELIMITER //
CREATE PROCEDURE procedure_name()
BEGIN
	-- SQL statements;
END //
DELIMITER ;
CALL procedure_name();

DELIMITER //
CREATE PROCEDURE GetStudentsByDepartment(IN dept INT)
BEGIN
 SELECT *
 FROM Student
 WHERE DeptID = dept;
END //
DELIMITER ;
CALL GetStudentsByDepartment(101);

DELIMITER //
CREATE PROCEDURE ShowStudentCount()
BEGIN
 DECLARE total_students INT;
 SELECT COUNT(*)
 INTO total_students
 FROM Student;
 SELECT total_students AS TotalStudents;
END //
DELIMITER ;
CALL ShowStudentCount();

DELIMITER //
CREATE PROCEDURE CheckMarks(IN sid INT)
BEGIN
 DECLARE student_marks DECIMAL(5,2);
 SELECT Marks
 INTO student_marks
 FROM Student
 WHERE StudentID = sid;
 IF student_marks >= 50 THEN
 SELECT 'Pass' AS Result;
 ELSE
 SELECT 'Fail' AS Result;
 END IF;
END //
DELIMITER ;
CALL CheckMarks(1);

DELIMITER //
CREATE PROCEDURE GradeStudent(IN sid INT)
BEGIN
 DECLARE student_marks DECIMAL(5,2);
 SELECT Marks
 INTO student_marks
 FROM Student
 WHERE StudentID = sid;
 CASE
 WHEN student_marks >= 90 THEN SELECT 'A' AS Grade;
 WHEN student_marks >= 75 THEN SELECT 'B' AS Grade;
 WHEN student_marks >= 60 THEN SELECT 'C' AS Grade;
 ELSE SELECT 'D' AS Grade;
 END CASE;
END //
DELIMITER ;
CALL GradeStudent(1);

DELIMITER //
CREATE FUNCTION AddNumbers(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
 RETURN a + b;
END //
DELIMITER ;
SELECT AddNumbers(10, 20);

DELIMITER //
CREATE FUNCTION GetGrade(marks DECIMAL(5,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
 IF marks >= 90 THEN
 RETURN 'A';
 ELSEIF marks >= 75 THEN
 RETURN 'B';
 ELSEIF marks >= 60 THEN
 RETURN 'C';
 ELSE
 RETURN 'D';
 END IF;
END //
DELIMITER ;
SELECT GetGrade(85);
SELECT StudentName, Marks, GetGrade(Marks) AS Grade
FROM Student;



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

CREATE PROCEDURE GetStudent(IN sid INT)
BEGIN
    SELECT *
    FROM Student
    WHERE StudentID = sid;
END //

DELIMITER ;

CALL GetStudent(3);

#Q5
DELIMITER //
CREATE PROCEDURE GetStudentsByDept(IN dept INT)
BEGIN
    SELECT *
    FROM Student
    WHERE DeptID = dept;
END //
DELIMITER ;

CALL GetStudentsByDept(102);

#Q6
DELIMITER //
CREATE PROCEDURE StudentsAboveMarks(IN minimum_marks DECIMAL(5,2))
BEGIN
    SELECT *
    FROM Student
    WHERE Marks > minimum_marks;
END //
DELIMITER ;

CALL StudentsAboveMarks(80);

#Q7
DELIMITER //
CREATE PROCEDURE TotalStudents()
BEGIN
    DECLARE total INT;
    SELECT COUNT(*)
    INTO total
    FROM Student;
    SELECT total AS Total_Students;
END //
DELIMITER ;

CALL TotalStudents();

#Q8
DELIMITER //
CREATE PROCEDURE CheckResult(IN sid INT)
BEGIN
    DECLARE student_marks DECIMAL(5,2);
    SELECT Marks
    INTO student_marks
    FROM Student
    WHERE StudentID = sid;

    IF student_marks >= 50 THEN
        SELECT 'Pass' AS Result;
    ELSE
        SELECT 'Fail' AS Result;
    END IF;
END //
DELIMITER ;

CALL CheckResult(1);

#Q9
DELIMITER //
CREATE FUNCTION AddTwoNumbers(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END //
DELIMITER ;

SELECT AddTwoNumbers(10, 20);

#Q10
DELIMITER //
CREATE FUNCTION FindSquare(num INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN num * num;
END //
DELIMITER ;

SELECT FindSquare(5);

#Q11
DELIMITER //
CREATE FUNCTION ResultStatus(marks DECIMAL(5,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF marks >= 50 THEN
        RETURN 'Pass';
    ELSE
        RETURN 'Fail';
    END IF;
END //
DELIMITER ;

SELECT ResultStatus(75);

#Q12
DELIMITER //
CREATE FUNCTION StudentGrade(marks DECIMAL(5,2))
RETURNS VARCHAR(5)
DETERMINISTIC
BEGIN
    IF marks >= 90 THEN
        RETURN 'A';
    ELSEIF marks >= 75 THEN
        RETURN 'B';
    ELSEIF marks >= 60 THEN
        RETURN 'C';
    ELSE
        RETURN 'D';
    END IF;
END //
DELIMITER ;

SELECT StudentGrade(85);

#Q13
DELIMITER //
CREATE FUNCTION AgeCategory(age INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF age >= 18 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Minor';
    END IF;
END //
DELIMITER ;

SELECT AgeCategory(20);

#Q14
DELIMITER //
CREATE FUNCTION CalculateBonus(marks DECIMAL(5,2))
RETURNS INT
DETERMINISTIC
BEGIN
    IF marks >= 90 THEN
        RETURN 1000;
    ELSEIF marks >= 75 THEN
        RETURN 500;
    ELSE
        RETURN 200;
    END IF;
END //
DELIMITER ;

SELECT CalculateBonus(85);


#Q15
SELECT 
    StudentName, 
    Marks, 
    StudentGrade(Marks) AS Grade 
FROM Student;