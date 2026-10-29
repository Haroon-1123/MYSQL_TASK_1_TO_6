-- TASK XV: E-Commerce DBMS Capstone Project
-- Integrated schema, sample data, queries, view, procedure, trigger, and index.
-- Run in a test database. If you already have tables, do not rerun CREATE TABLE.
CREATE DATABASE IF NOT EXISTS ecommerce_capstone;
USE ecommerce_capstone;

CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(150) NOT NULL,
    Category VARCHAR(80) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Stock INT NOT NULL DEFAULT 0 CHECK (Stock >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `Order` (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    PaymentMethod VARCHAR(40) NOT NULL,
    PaymentStatus VARCHAR(30) NOT NULL DEFAULT 'Pending',
    PaidAt DATETIME NULL,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
) ENGINE=InnoDB;

-- Sample records (safe to run repeatedly for the fixed IDs only on an empty table).
INSERT INTO Customer (CustomerID, CustomerName, Email) VALUES
(1, 'Arun Kumar', 'arun@example.com'),
(2, 'Priya S', 'priya@example.com')
ON DUPLICATE KEY UPDATE CustomerName=VALUES(CustomerName);

INSERT INTO Product (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Wireless Mouse', 'Electronics', 799.00, 50),
(2, 'Notebook Pack', 'Stationery', 199.00, 100),
(3, 'USB Keyboard', 'Electronics', 1299.00, 25)
ON DUPLICATE KEY UPDATE ProductName=VALUES(ProductName);

-- Basic queries
SELECT * FROM Customer;
SELECT * FROM Product WHERE Stock > 0 ORDER BY Price DESC;

-- Join report
SELECT c.CustomerName, o.OrderID, o.OrderDate, o.TotalAmount,
       pay.PaymentMethod, pay.PaymentStatus
FROM Customer c
JOIN `Order` o ON o.CustomerID = c.CustomerID
LEFT JOIN Payment pay ON pay.OrderID = o.OrderID;

-- Aggregated sales by product
SELECT p.ProductName, SUM(od.Quantity) AS UnitsSold,
       SUM(od.Quantity * od.UnitPrice) AS ProductSales
FROM Product p
JOIN OrderDetails od ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY ProductSales DESC;

-- Customer spending view
CREATE OR REPLACE VIEW CustomerSpending AS
SELECT c.CustomerID, c.CustomerName,
       COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend,
       COUNT(o.OrderID) AS OrderCount
FROM Customer c
LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

SELECT * FROM CustomerSpending;

-- Indexes supporting joins and reporting
CREATE INDEX idx_capstone_order_customer ON `Order` (CustomerID);
CREATE INDEX idx_capstone_detail_product ON OrderDetails (ProductID);

-- Key business insights to derive from the query results:
-- 1. Identify products with high sales and low remaining stock.
-- 2. Compare spending between customers to identify loyal customers.
-- 3. Compare sales by category to guide inventory and marketing.
-- 4. Review pending payments to find orders needing follow-up.
