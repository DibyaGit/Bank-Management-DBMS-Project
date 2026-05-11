-- =======================================================================================
-- Project: P2 - Bank Management System
-- Script: dml_scripts.sql
-- Purpose: Inserts robust dummy data into the database and includes sample UPDATE/DELETEs.
-- =======================================================================================

USE BankManagementDB;
GO

-- ==========================================
-- 1. Insert Dummy Customers
-- ==========================================
INSERT INTO Customers (FirstName, LastName, Email, Phone, AddressLine, City, State, ZipCode)
VALUES 
('Alice', 'Smith', 'alice.smith@example.com', '555-0101', '123 Maple St', 'Seattle', 'WA', '98101'),
('Bob', 'Johnson', 'bob.johnson@example.com', '555-0102', '456 Oak Dr', 'Portland', 'OR', '97204'),
('Charlie', 'Williams', 'charlie.w@example.com', '555-0103', '789 Pine Ln', 'San Francisco', 'CA', '94105'),
('Diana', 'Brown', 'diana.b@example.com', '555-0104', '321 Cedar Blvd', 'Austin', 'TX', '73301'),
('Evan', 'Davis', 'evan.davis@example.com', '555-0105', '654 Elm Way', 'Denver', 'CO', '80202');
GO

-- ==========================================
-- 2. Insert Dummy Accounts
-- ==========================================
-- Customer IDs: 1 (Alice), 2 (Bob), 3 (Charlie), 4 (Diana), 5 (Evan)
INSERT INTO Accounts (CustomerID, AccountType, Balance, Status)
VALUES 
(1, 'Savings', 5000.00, 'Active'),
(1, 'Current', 1200.50, 'Active'),
(2, 'Savings', 15000.00, 'Active'),
(3, 'Current', 3400.00, 'Active'),
(4, 'Savings', 250.00, 'Active'),
(5, 'Savings', 8000.00, 'Closed'); -- Evan has a closed account
GO

-- ==========================================
-- 3. Insert Dummy Transactions
-- ==========================================
-- Account IDs: 1000, 1001, 1002, 1003, 1004, 1005
INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate, ReferenceAccountID)
VALUES 
(1000, 'Deposit', 2000.00, DATEADD(DAY, -10, GETDATE()), NULL),
(1001, 'Withdrawal', 500.00, DATEADD(DAY, -8, GETDATE()), NULL),
(1002, 'Deposit', 5000.00, DATEADD(DAY, -5, GETDATE()), NULL),
(1000, 'Transfer', 1000.00, DATEADD(DAY, -2, GETDATE()), 1003),
(1003, 'Deposit', 1000.00, DATEADD(DAY, -2, GETDATE()), NULL); -- Representing the received transfer
GO

-- ==========================================
-- 4. Sample UPDATE Operation
-- ==========================================
-- Update a customer's phone number
UPDATE Customers 
SET Phone = '555-0199' 
WHERE CustomerID = 4;
GO

-- ==========================================
-- 5. Sample DELETE Operation
-- ==========================================
-- Delete a closed account (e.g., Evan's account which is ID 1005)
DELETE FROM Accounts 
WHERE AccountID = 1005 AND Status = 'Closed';
GO
