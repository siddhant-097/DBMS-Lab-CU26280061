show databases;
create database dbms;
use dbms;

#Q1
CREATE TABLE departments (
	dept_id INT PRIMARY KEY, 
    dep_name VARCHAR(50)
);

#Q2
CREATE TABLE employees (
	emp_id INT PRIMARY KEY, 
    first_name VARCHAR(30), 
    salary DECIMAL(10,2) 
);

#Q3
CREATE TABLE projects (
	project_id INT PRIMARY KEY, 
    project_name VARCHAR (100), 
    start_date DATE
);

#Q4
CREATE TABLE audit_logs (
	log_id INT PRIMARY KEY, 
	action TEXT, 
    created_at TIMESTAMP
);

#Q5
CREATE TABLE products (
	product_id INT PRIMARY KEY, 
    product_name VARCHAR(50), 
    is_available BOOLEAN
);

#Q6
CREATE TABLE system_settings (
	setting_id SMALLINT PRIMARY KEY, 
    setting_key VARCHAR(50), 
    setting_value VARCHAR(100)
);

#Q7
ALTER table employees 
ADD email VARCHAR(100);

#Q8
ALTER table products 
DROP is_available;

#Q9
RENAME TABLE departments TO dept_units;

#Q10
TRUNCATE TABLE audit_logs;

#Q11
CREATE TABLE user_profiles (
	user_id INT PRIMARY KEY, 
    bio TEXT, 
    profile_pic BLOB
); 

#Q12
CREATE TABLE ticket_orders (
	ticket_id INT PRIMARY KEY, 
    priority_level ENUM('Low', 'Medium', 'High')
);

#Q13
DROP TABLE products;

#Q14
ALTER TABLE employees MODIFY email VARCHAR(150);

#Q15
CREATE TABLE sensor_data (
	read_id BIGINT PRIMARY KEY, 
    temperature FLOAT
);

#Q16
CREATE TABLE student_courses (
	student_id INT, 
    course_id INT
);

#Q16
ALTER TABLE student_courses 
ADD PRIMARY KEY (student_id, course_id);

#Q17
ALTER TABLE employees 
RENAME COLUMN first_name TO given_name;

#Q18
ALTER TABLE system_settings 
DROP PRIMARY KEY;

#Q19
CREATE TABLE clients (
	client_id INT PRIMARY KEY, 
	registration_time TIME
); 

#Q20
ALTER TABLE clients 
DROP PRIMARY KEY;
ALTER TABLE clients 
ADD PRIMARY KEY (client_id);

#Q21
CREATE TABLE order_items (
	order_id INT, 
    item_id INT,
    quantity INT,
    unit_price DECIMAL(8,2),
    PRIMARY KEY (order_id, item_id)
);

#Q22
CREATE TABLE event_schedules (
	event_id INT,
    venue_id INT,
    event_data DATE,
    duration_hours TINYINT,
    PRIMARY KEY (event_id, venue_id)
);

#Q23
ALTER TABLE employees
ADD COLUMN hire_date DATE,
ADD COLUMN is_active BOOLEAN;

#Q24
ALTER TABLE employees
DROP COLUMN email,
MODIFY salary DECIMAL(12,2);

#Q25
CREATE TABLE inventory (
	warehouse_id INT,
    sku VARCHAR(20)
);
ALTER TABLE inventory 
ADD PRIMARY KEY (warehouse_id, sku);

#Q26
ALTER TABLE user_profiles
MODIFY bio MEDIUMTEXT;

#Q27
ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(30) AFTER given_name;

#Q28
CREATE TABLE geolocations (
	location_id INT PRIMARY KEY,
    latitude DECIMAL(9,6),
    longitutde DECIMAL(9,6)
);

#Q29
CREATE TABLE user_accounts (
	user_id BIGINT Primary Key,
    account_type ENUM('Standard', 'Premium', 'Admin'),
    created_timestamp TIMESTAMP
);

#Q30
CREATE TABLE device_logs (
	log_id BIGINT PRIMARY KEY,
    ip_address VARCHAR(45),
    payload LONGBLOB
);

#Q31
ALTER TABLE order_items
DROP PRIMARY KEY,
ADD order_item_id INT FIRST,
ADD PRIMARY KEY (order_item_id);

#Q32
ALTER TABLE projects
CHANGE start_date project_year YEAR;

#Q33
CREATE TABLE document_store(
	doc_id INT PRIMARY KEY,
    doc_title VARCHAR(255),
    content LONGTEXT
);

#Q34
ALTER TABLE document_store
CHANGE content doc_body LONGTEXT;

#Q35
CREATE TABLE employees_archive LIKE employees;

#Q36
DROP TABLE IF EXISTS exployees_archive;

#Q37
CREATE TABLE financial_ledger (
	entry_id BIGINT PRIMARY KEY,
    debit DECIMAL(15,4),
    credit DECIMAL(15,4)
);

#Q38
ALTER TABLE financial_ledger
ADD transaction_date DATETIME FIRST; 

#Q39
CREATE TABLE measurements (
	sample_id INT PRIMARY KEY,
    value DOUBLE
);

#Q40
CREATE TABLE app_users (
	user_id INT PRIMARY KEY,
    status_code TINYINT
);

#Q41
CREATE TABLE transactions (
	xact_id BIGINT PRIMARY KEY,
	user_id INT,
	amount DECIMAL(10, 2),
	channel ENUM('Web', 'Mobile', 'ATM'),
	status VARCHAR(20),
	xact_time TIMESTAMP
); 

#42
CREATE TABLE system_events (
	event_id BIGINT,
	node_id SMALLINT,
	event_payload TEXT,
	logged_time TIMESTAMP,
	PRIMARY KEY (event_id, node_id)
); 

#Q43
ALTER TABLE clients 
DROP PRIMARY KEY, 
ADD region_code CHAR(3),
ADD PRIMARY KEY (client_id, region_code);

#Q44
CREATE TABLE raw_data (
	temp_val INT
);
ALTER TABLE raw_data
CHANGE temp_val converted_val DECIMAL (6,3),
ADD processed_at TIMESTAMP;

#Q45
CREATE TABLE student_enrollments (
	student_id INT,
    course_id INT,
    semester VARCHAR(10),
    enrollment_date DATE, 
    PRIMARY KEY (student_id, course_id, semester)
);

#Q46
ALTER TABLE student_enrollments
DROP PRIMARY KEY,
ADD enrollment_id BIGINT FIRST,
ADD PRIMARY KEY (enrollment_id);

#Q47
CREATE TABLE file_metadata (
	file_id INT PRIMARY KEY,
	file_path VARCHAR(500),
	file_size_bytes BIGINT,
	checksum CHAR(64)
); 

#Q48
ALTER TABLE file_metadata
MODIFY file_id BIGINT,
MODIFY file_path TEXT,
DROP COLUMN checksum;

#Q49
CREATE TABLE sensor_readings(
	sensor_id INT,
    recorded_at TIMESTAMP,
    reading FLOAT,
    PRIMARY KEY (sensor_id, recorded_at)
);
RENAME TABLE sensor_readings TO historical_sensor_readings;

#Q50
CREATE TABLE application_logs (
	log_id BIGINT PRIMARY KEY,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR'),
	message TEXT,
    execution_time DOUBLE,
    created_at DATETIME
);
ALTER TABLE application_logs
MODIFY level VARCHAR(10);

