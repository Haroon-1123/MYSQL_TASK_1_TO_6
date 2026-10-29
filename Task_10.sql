-- TASK X: Subqueries and Nested Queries
USE ecommerce;

-- 1. Products priced above the average product price
SELECT ProductID, ProductName, Price
FROM Product
WHERE Price > (SELECT AVG(Price) FROM Product)
ORDER BY Price DESC;

-- 2. Product(s) with the maximum price
SELECT ProductID, ProductName, Price
FROM Product
WHERE Price = (SELECT MAX(Price) FROM Product);

-- 3. Customers whose total spending is above the average customer spending
SELECT totals.CustomerID, totals.CustomerName, totals.TotalSpent
FROM (
    SELECT c.CustomerID, c.CustomerName,
           COALESCE(SUM(o.TotalAmount), 0) AS TotalSpent
    FROM Customer c
    LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
) AS totals
WHERE totals.TotalSpent > (
    SELECT AVG(customer_totals.TotalSpent)
    FROM (
        SELECT c2.CustomerID, COALESCE(SUM(o2.TotalAmount), 0) AS TotalSpent
        FROM Customer c2
        LEFT JOIN `Order` o2 ON o2.CustomerID = c2.CustomerID
        GROUP BY c2.CustomerID
    ) AS customer_totals
);

-- 4. Customers who have placed at least one order
SELECT CustomerID, CustomerName
FROM Customer c
WHERE EXISTS (
    SELECT 1 FROM `Order` o WHERE o.CustomerID = c.CustomerID
);

-- 5. Products that have never been ordered
SELECT p.ProductID, p.ProductName
FROM Product p
WHERE NOT EXISTS (
    SELECT 1 FROM OrderDetails od WHERE od.ProductID = p.ProductID
);

-- 6. Orders whose amount is greater than the average order amount
SELECT OrderID, CustomerID, TotalAmount
FROM `Order`
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM `Order`)
ORDER BY TotalAmount DESC;
