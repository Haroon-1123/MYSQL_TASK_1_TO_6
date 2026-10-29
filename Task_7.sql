-- TASK VII: Basic SQL Queries and Filtering
-- E-Commerce database. Adjust column names if your existing schema differs.

USE ecommerce;

-- 1. Display all products
SELECT * FROM Product;

-- 2. Find products above a selected price
SELECT ProductID, ProductName, Price, Category
FROM Product
WHERE Price > 1000
ORDER BY Price DESC;

-- 3. Find products from a chosen category
SELECT ProductID, ProductName, Price, Category
FROM Product
WHERE Category = 'Electronics';

-- 4. Search products by name
SELECT ProductID, ProductName, Price
FROM Product
WHERE ProductName LIKE '%phone%';

-- 5. Find products currently available (change Stock column name if needed)
SELECT ProductID, ProductName, Stock
FROM Product
WHERE Stock > 0;

-- 6. Show unique product categories
SELECT DISTINCT Category
FROM Product
ORDER BY Category;

-- 7. Display customers alphabetically
SELECT CustomerID, CustomerName, Email
FROM Customer
ORDER BY CustomerName ASC;

-- 8. Filter orders within a date range
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM `Order`
WHERE OrderDate BETWEEN '2026-01-01' AND '2026-12-31'
ORDER BY OrderDate DESC;
