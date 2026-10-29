-- TASK XII: Transactions, COMMIT, ROLLBACK, and ACID
USE ecommerce;

-- Transaction example: add an order and its detail atomically.
-- Replace IDs and amounts with valid records from your database.
START TRANSACTION;

-- Example only: confirm the customer and product IDs exist first.
INSERT INTO `Order` (CustomerID, OrderDate, TotalAmount)
VALUES (1, CURRENT_DATE(), 500.00);

SET @new_order_id = LAST_INSERT_ID();

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES (@new_order_id, 1, 1, 500.00);

-- If all statements succeed and values are correct:
COMMIT;

-- ROLLBACK demonstration: this transaction is intentionally cancelled.
START TRANSACTION;
UPDATE Product
SET Stock = Stock - 1
WHERE ProductID = 1 AND Stock > 0;

-- Use ROLLBACK to undo the test update:
ROLLBACK;

-- Check the order and product records after testing
SELECT * FROM `Order` WHERE OrderID = @new_order_id;
SELECT ProductID, Stock FROM Product WHERE ProductID = 1;

-- ACID:
-- Atomicity: all transaction steps succeed together or are rolled back.
-- Consistency: constraints and business rules remain valid.
-- Isolation: concurrent transactions do not interfere incorrectly.
-- Durability: committed changes persist.
-- NOTE: use InnoDB tables; test on sample data before production use.
