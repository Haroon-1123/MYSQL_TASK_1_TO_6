-- TASK IX: Aggregate Functions and Business Reports
USE ecommerce;

-- 1. Number of products
SELECT COUNT(*) AS TotalProducts FROM Product;

-- 2. Product price statistics
SELECT MIN(Price) AS LowestPrice, MAX(Price) AS HighestPrice,
       AVG(Price) AS AveragePrice
FROM Product;

-- 3. Total sales and average order value
SELECT SUM(TotalAmount) AS TotalSales,
       AVG(TotalAmount) AS AverageOrderValue,
       COUNT(*) AS TotalOrders
FROM `Order`;

-- 4. Top customers by total spending
SELECT c.CustomerID, c.CustomerName,
       SUM(o.TotalAmount) AS TotalSpent
FROM Customer c
JOIN `Order` o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC
LIMIT 10;

-- 5. Best-selling products by quantity
SELECT p.ProductID, p.ProductName,
       SUM(od.Quantity) AS UnitsSold
FROM Product p
JOIN OrderDetails od ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC
LIMIT 10;

-- 6. Sales by category
SELECT p.Category, SUM(od.Quantity * od.UnitPrice) AS CategorySales
FROM Product p
JOIN OrderDetails od ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY CategorySales DESC;

-- 7. Orders grouped by status (adjust table/column if your schema differs)
SELECT PaymentStatus, COUNT(*) AS PaymentCount
FROM Payment
GROUP BY PaymentStatus;
