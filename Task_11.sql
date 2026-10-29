-- TASK XI: Views, Stored Procedures, Functions, and Triggers
-- Run in MySQL 8+. Ensure ecommerce tables/columns match your schema.
USE ecommerce;

CREATE OR REPLACE VIEW CustomerOrderSummary AS
SELECT c.CustomerID, c.CustomerName,
       COUNT(o.OrderID) AS OrderCount,
       COALESCE(SUM(o.TotalAmount), 0) AS TotalSpent
FROM Customer c
LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

SELECT * FROM CustomerOrderSummary;

DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN p_CustomerID INT)
BEGIN
    SELECT o.OrderID, o.OrderDate, o.TotalAmount
    FROM `Order` o
    WHERE o.CustomerID = p_CustomerID
    ORDER BY o.OrderDate DESC;
END //

CREATE FUNCTION CalculateLineTotal(p_Quantity INT, p_UnitPrice DECIMAL(10,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN p_Quantity * p_UnitPrice;
END //
DELIMITER ;

-- Example calls:
CALL GetCustomerOrders(1);
SELECT CalculateLineTotal(2, 499.50) AS LineTotal;

-- Optional trigger example (only create if OrderDetails does not already
-- have a trigger doing the same job). This example validates positive quantity.
DELIMITER //
CREATE TRIGGER ValidateOrderDetailQuantity
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    IF NEW.Quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;
END //
DELIMITER ;
