CREATE DATABASE CollegeDB;
USE CollegeDB; 

CREATE TABLE Student (
 Student_ID INT PRIMARY KEY,
 Student_Name VARCHAR(50) NOT NULL,
 Email VARCHAR(100) UNIQUE,
 Phone VARCHAR(15) NOT NULL,
 Branch VARCHAR(50)
);

CREATE TABLE Course (
 Course_ID INT PRIMARY KEY,
 Course_Name VARCHAR(100) UNIQUE NOT NULL,
 Department VARCHAR(50) NOT NULL,
 Credits INT NOT NULL
);

CREATE TABLE Enrollment (
 Enrollment_ID INT PRIMARY KEY,
 Student_ID INT,
 Course_ID INT,
 Semester INT,
 Marks INT,
 CONSTRAINT fk_enrollment_student
 FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID),
 CONSTRAINT fk_enrollment_course
 FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
); 

INSERT INTO Student (Student_ID, Student_Name, Email, Phone, Branch) VALUES
(101, 'Aman', 'aman@gmail.com', '9876543210', 'CSE'),
(102, 'Neha', NULL, '9876543211', 'Pharmacy'),
(103, 'Ravi', '', '9876543212', 'CSE');

INSERT INTO Course (Course_ID, Course_Name, Department, Credits) VALUES
(201, 'DBMS', 'CSE', 4),
(202, 'Python', 'CSE', 3),
(203, 'Pharmacology', 'Pharmacy', 4);

INSERT INTO Enrollment
(Enrollment_ID, Student_ID, Course_ID, Semester, Marks) VALUES 
(1, 101, 201, 2, 85),
(2, 102, 202, NULL, 78),
(3, 103, 203, 2, NULL); 

SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Enrollment;

#Q1
SELECT * FROM Student s INNER JOIN Enrollment e ON s.Student_ID=e.Student_ID; 

#Q2
SELECT * FROM Student s LEFT JOIN Enrollment e ON s.Student_ID=e.Student_ID; 

#Q3
SELECT * FROM Student s RIGHT JOIN Enrollment e ON s.Student_ID=e.Student_ID; 

#Q4
SELECT s.Student_ID,s.Student_Name,e.Enrollment_ID,e.Student_ID AS E_Student_ID FROM Student s
LEFT JOIN Enrollment e ON s.Student_ID=e.Student_ID 
UNION 
SELECT s.Student_ID,s.Student_Name,e.Enrollment_ID,e.Student_ID AS E_Student_ID FROM Student s RIGHT
JOIN Enrollment e ON s.Student_ID=e.Student_ID; 

#Q5
SELECT * FROM Student s CROSS JOIN Enrollment e; 

#Q6
SELECT s1.Student_Name AS Student1,s2.Student_Name AS Student2 FROM Student s1 JOIN Student
s2 ON s1.Student_ID<s2.Student_ID; 

#Q7
SELECT * FROM Enrollment e JOIN Course c ON e.Course_ID=c.Course_ID; 

#Q8
SELECT * FROM Enrollment e LEFT JOIN Course c ON e.Course_ID=c.Course_ID;

#Q9
SELECT * FROM Enrollment e RIGHT JOIN Course c ON e.Course_ID=c.Course_ID; 


#Q10
SELECT c.Course_ID,c.Course_Name,e.Enrollment_ID,e.Student_ID FROM Course c LEFT JOIN
Enrollment e ON c.Course_ID=e.Course_ID UNION 
SELECT c.Course_ID,c.Course_Name,e.Enrollment_ID,e.Student_ID FROM Course c RIGHT JOIN Enrollment e
ON c.Course_ID=e.Course_ID;

#Q11
SELECT * FROM Student s CROSS JOIN Course c; 

