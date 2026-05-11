-- =======================================================================================
-- Project: P2 - Bank Management System
-- Script: queries.sql
-- Purpose: Contains 10 complex queries utilizing joins, subqueries, and aggregations.
-- =======================================================================================

USE BankManagementDB;
GO

-- 1. INNER JOIN & AGGREGATION: Total balance per customer
-- This query shows the total funds each customer has across all their active accounts.
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(a.Balance) AS TotalBalance
FROM 
    Customers c
INNER JOIN 
    Accounts a ON c.CustomerID = a.CustomerID
WHERE 
    a.Status = 'Active'
GROUP BY 
    c.CustomerID, c.FirstName, c.LastName
ORDER BY 
    TotalBalance DESC;

-- 2. LEFT JOIN: All customers and their accounts (even if they have no active accounts)
-- Useful for identifying customers who have registered but haven't opened an account yet.
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    a.AccountID,
    a.AccountType,
    ISNULL(a.Balance, 0) AS Balance
FROM 
    Customers c
LEFT JOIN 
    Accounts a ON c.CustomerID = a.CustomerID;

-- 3. RIGHT JOIN: All transactions and the accounts they belong to
-- Ensures we see all transactions, even if the linked account was deleted (though FK CASCADE prevents this, it's good practice).
SELECT 
    a.AccountID,
    a.AccountType,
    t.TransactionID,
    t.TransactionType,
    t.Amount,
    t.TransactionDate
FROM 
    Accounts a
RIGHT JOIN 
    Transactions t ON a.AccountID = t.AccountID;

-- 4. FULL OUTER JOIN: Customers and Accounts overview
-- Shows a complete map of customers and accounts.
SELECT 
    c.FirstName,
    c.LastName,
    a.AccountID,
    a.Status
FROM 
    Customers c
FULL OUTER JOIN 
    Accounts a ON c.CustomerID = a.CustomerID;

-- 5. SUBQUERY (WHERE Clause): Find customers with above-average balances
-- Identifies high-net-worth customers whose account balance is greater than the bank's average.
SELECT 
    CustomerID,
    AccountID,
    Balance
FROM 
    Accounts
WHERE 
    Balance > (SELECT AVG(Balance) FROM Accounts WHERE Status = 'Active');

-- 6. GROUP BY & HAVING: Account types with more than $5,000 total balance
-- Helps the bank understand which account types hold the most liquidity.
SELECT 
    AccountType,
    SUM(Balance) AS TotalLiquidity,
    COUNT(AccountID) AS TotalAccounts
FROM 
    Accounts
GROUP BY 
    AccountType
HAVING 
    SUM(Balance) > 5000;

-- 7. SUBQUERY (FROM Clause): Derived table for Customer Transaction Counts
-- Counts how many transactions each customer has made.
SELECT 
    CustomerSummary.FirstName,
    CustomerSummary.LastName,
    CustomerSummary.TotalTransactions
FROM 
    (SELECT c.FirstName, c.LastName, COUNT(t.TransactionID) AS TotalTransactions
     FROM Customers c
     INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
     LEFT JOIN Transactions t ON a.AccountID = t.AccountID
     GROUP BY c.FirstName, c.LastName) AS CustomerSummary
WHERE 
    CustomerSummary.TotalTransactions > 0;

-- 8. INNER JOIN WITH MULTIPLE TABLES: Complete Transaction History
-- Shows exactly who made what transaction, pulling from Customers, Accounts, and Transactions.
SELECT 
    c.FirstName,
    c.LastName,
    a.AccountType,
    t.TransactionType,
    t.Amount,
    t.TransactionDate
FROM 
    Customers c
INNER JOIN 
    Accounts a ON c.CustomerID = a.CustomerID
INNER JOIN 
    Transactions t ON a.AccountID = t.AccountID
ORDER BY 
    t.TransactionDate DESC;

-- 9. AGGREGATION & SUBQUERY: Maximum single transaction per account
-- Finds the highest single transaction amount for each active account.
SELECT 
    a.AccountID,
    a.AccountType,
    (SELECT MAX(Amount) FROM Transactions t WHERE t.AccountID = a.AccountID) AS MaxTransactionAmount
FROM 
    Accounts a
WHERE 
    a.Status = 'Active';

-- 10. COMPLEX JOIN & HAVING: Customers with total deposits exceeding $2000
-- Identifies customers who are actively depositing large sums of money.
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(t.Amount) AS TotalDeposited
FROM 
    Customers c
INNER JOIN 
    Accounts a ON c.CustomerID = a.CustomerID
INNER JOIN 
    Transactions t ON a.AccountID = t.AccountID
WHERE 
    t.TransactionType = 'Deposit'
GROUP BY 
    c.CustomerID, c.FirstName, c.LastName
HAVING 
    SUM(t.Amount) > 2000;
GO
