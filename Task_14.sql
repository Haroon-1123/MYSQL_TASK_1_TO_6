-- TASK XIV: Analytical Reports, Window Functions, and Feature Extraction
USE ecommerce;

-- 1. Rank customers by total spending
WITH CustomerTotals AS (
    SELECT c.CustomerID, c.CustomerName,
           COALESCE(SUM(o.TotalAmount), 0) AS TotalSpent
    FROM Customer c
    LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT CustomerID, CustomerName, TotalSpent,
       RANK() OVER (ORDER BY TotalSpent DESC) AS SpendingRank,
       ROW_NUMBER() OVER (ORDER BY TotalSpent DESC, CustomerID) AS RowNumber
FROM CustomerTotals;

-- 2. Rank products by units sold
WITH ProductSales AS (
    SELECT p.ProductID, p.ProductName,
           COALESCE(SUM(od.Quantity), 0) AS UnitsSold
    FROM Product p
    LEFT JOIN OrderDetails od ON od.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT ProductID, ProductName, UnitsSold,
       DENSE_RANK() OVER (ORDER BY UnitsSold DESC) AS SalesRank
FROM ProductSales;

-- 3. Monthly sales trend
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS SalesMonth,
       SUM(TotalAmount) AS MonthlySales,
       COUNT(*) AS OrderCount
FROM `Order`
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
ORDER BY SalesMonth;

-- 4. Simple customer segmentation based on total spending
WITH CustomerTotals AS (
    SELECT c.CustomerID, c.CustomerName,
           COALESCE(SUM(o.TotalAmount), 0) AS TotalSpent
    FROM Customer c
    LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT CustomerID, CustomerName, TotalSpent,
       CASE
         WHEN TotalSpent >= 50000 THEN 'High Value'
         WHEN TotalSpent >= 10000 THEN 'Medium Value'
         ELSE 'Low Value'
       END AS CustomerSegment
FROM CustomerTotals;

-- 5. Feature extraction dataset for analytics/AI
SELECT c.CustomerID,
       COUNT(o.OrderID) AS OrderFrequency,
       COALESCE(SUM(o.TotalAmount), 0) AS LifetimeSpend,
       COALESCE(AVG(o.TotalAmount), 0) AS AverageOrderValue,
       MAX(o.OrderDate) AS LastOrderDate
FROM Customer c
LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID;
