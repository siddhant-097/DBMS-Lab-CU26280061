CREATE DATABASE Retail_Functions_Practice;
USE Retail_Functions_Practice;

CREATE TABLE Products(
 ProductID INT PRIMARY KEY,
 ProductName VARCHAR(50),
 Category VARCHAR(30),
 Price DECIMAL(10,2),
 Stock INT
);
INSERT INTO Products VALUES
(101,'Laptop','Electronics',55000,10),
(102,'Mouse','Accessories',1200,50),
(103,'Keyboard','Accessories',1800,35),
(104,'Monitor','Electronics',15000,15),
(105,'Printer','Office',12000,8),
(106,'Webcam','Electronics',3500,20); 


#Q1
DELIMITER //
CREATE FUNCTION get_product_price(p_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
 DECLARE p_price DECIMAL(10,2);
 SELECT Price INTO p_price
 FROM Products
 WHERE ProductID = p_id;
 RETURN p_price;
END //
DELIMITER ;
SELECT get_product_price(101);

#Q2
DELIMITER //
CREATE FUNCTION discounted_price(
 p_price DECIMAL(10,2),
 p_discount DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
 RETURN p_price - (p_price * p_discount / 100);
END //
DELIMITER ;
SELECT discounted_price(55000,10); 

#Q3
SELECT ProductName,
 Price,
 discounted_price(Price,15) AS DiscountedPrice
FROM Products;

#Q4
DELIMITER //
CREATE FUNCTION stock_status(p_stock INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
 IF p_stock > 0 THEN
 RETURN 'In Stock';
 ELSE
 RETURN 'Out of Stock';
 END IF;
END //
DELIMITER ;
SELECT ProductName, Stock, stock_status(Stock) AS Status
FROM Products;

#Q5
DELIMITER //
CREATE PROCEDURE products_by_category(IN p_category VARCHAR(30))
BEGIN
 SELECT ProductID, ProductName, Price, Stock
 FROM Products
 WHERE Category = p_category;
END //
DELIMITER ;
CALL products_by_category('Electronics');

#Q6
DELIMITER //
CREATE PROCEDURE products_above_price(IN p_min_price DECIMAL(10,2))
BEGIN
 SELECT ProductID, ProductName, Category, Price
 FROM Products
 WHERE Price > p_min_price
 ORDER BY Price DESC;
END //
DELIMITER ;
CALL products_above_price(10000);

#Q7
DELIMITER //
CREATE PROCEDURE increase_price(
 IN p_id INT,
 IN p_percent DECIMAL(5,2)
)
BEGIN
 UPDATE Products
 SET Price = Price + (Price * p_percent / 100)
 WHERE ProductID = p_id;
END //
DELIMITER ;
CALL increase_price(102,10);
SELECT * FROM Products
WHERE ProductID = 102;

#Q8
DELIMITER //
CREATE PROCEDURE category_product_count(
 IN p_category VARCHAR(30),
 OUT p_count INT
)
BEGIN
 SELECT COUNT(*) INTO p_count
 FROM Products
 WHERE Category = p_category;
END //
DELIMITER ;
CALL category_product_count('Electronics',@total);
SELECT @total AS TotalProducts;

#Q9
DELIMITER //
CREATE FUNCTION stock_value(
 p_price DECIMAL(10,2),
 p_stock INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
 RETURN p_price * p_stock;
END //
DELIMITER ;
SELECT ProductName, Price, Stock,
 stock_value(Price,Stock) AS StockValue
FROM Products;


#Q10
DELIMITER //
CREATE PROCEDURE product_report()
BEGIN
 SELECT ProductID, ProductName, Category, Price, Stock,
 stock_value(Price,Stock) AS StockValue,
 stock_status(Stock) AS StockStatus
 FROM Products
 ORDER BY ProductID;
END //
DELIMITER ;
CALL product_report();
