-- TASK XIII: Database Security, Roles, GRANT/REVOKE, and Indexes
USE ecommerce;

-- Create a role (MySQL 8+). Run with an administrator account.
CREATE ROLE IF NOT EXISTS 'ecommerce_readonly';

-- Grant read-only access to the main application tables.
GRANT SELECT ON ecommerce.Customer TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce.Product TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce.`Order` TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce.OrderDetails TO 'ecommerce_readonly';
GRANT SELECT ON ecommerce.Payment TO 'ecommerce_readonly';

-- Example user: replace the username and use a secure password locally.
-- CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'REPLACE_WITH_A_STRONG_PASSWORD';
-- GRANT 'ecommerce_readonly' TO 'report_user'@'localhost';
-- SET DEFAULT ROLE 'ecommerce_readonly' TO 'report_user'@'localhost';

-- Revoke a permission when access is no longer needed:
-- REVOKE SELECT ON ecommerce.Payment FROM 'ecommerce_readonly';

-- Indexes for commonly filtered/joined columns.
CREATE INDEX idx_order_customer_date ON `Order` (CustomerID, OrderDate);
CREATE INDEX idx_orderdetails_product ON OrderDetails (ProductID);
CREATE INDEX idx_payment_order ON Payment (OrderID);

-- Example query to evaluate with EXPLAIN
EXPLAIN
SELECT OrderID, OrderDate, TotalAmount
FROM `Order`
WHERE CustomerID = 1
ORDER BY OrderDate DESC;

-- Note: check existing indexes before creating duplicates.
