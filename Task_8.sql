-- TASK VIII: Database Relationship Analysis using JOINs
USE ecommerce;

-- 1. INNER JOIN: orders with matching customers
SELECT o.OrderID, o.OrderDate, c.CustomerID, c.CustomerName
FROM `Order` o
INNER JOIN Customer c ON c.CustomerID = o.CustomerID;

-- 2. LEFT JOIN: all customers, including customers without orders
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
FROM Customer c
LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
ORDER BY c.CustomerID;

-- 3. RIGHT JOIN: all products and any matching order details
SELECT p.ProductID, p.ProductName, od.OrderID, od.Quantity
FROM OrderDetails od
RIGHT JOIN Product p ON p.ProductID = od.ProductID
ORDER BY p.ProductID;

-- 4. Complete order details: customer, order, product, payment
SELECT c.CustomerName, o.OrderID, o.OrderDate,
       p.ProductName, od.Quantity, od.UnitPrice,
       (od.Quantity * od.UnitPrice) AS LineTotal,
       pay.PaymentID, pay.PaymentMethod, pay.PaymentStatus
FROM Customer c
JOIN `Order` o ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON od.OrderID = o.OrderID
JOIN Product p ON p.ProductID = od.ProductID
LEFT JOIN Payment pay ON pay.OrderID = o.OrderID
ORDER BY o.OrderDate DESC, o.OrderID;

-- 5. Customer purchase history
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate, o.TotalAmount
FROM Customer c
JOIN `Order` o ON o.CustomerID = c.CustomerID
ORDER BY c.CustomerID, o.OrderDate DESC;

-- 6. Multi-table report: order totals by customer
SELECT c.CustomerID, c.CustomerName,
       COUNT(DISTINCT o.OrderID) AS NumberOfOrders,
       COALESCE(SUM(o.TotalAmount), 0) AS TotalSpent
FROM Customer c
LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC;
