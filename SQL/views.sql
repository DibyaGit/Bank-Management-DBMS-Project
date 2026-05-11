-- =======================================================================================
-- Project: P2 - Bank Management System
-- Script: views.sql
-- Purpose: Implements simple, join-based, and aggregate views. Also creates Indexes.
-- =======================================================================================

USE BankManagementDB;
GO

-- ==========================================
-- INDEX CREATION FOR PERFORMANCE OPTIMIZATION
-- ==========================================

-- 1. Clustered Index (Already created by Primary Keys, but let's demonstrate a Non-Clustered Index on frequently searched columns)
-- Create a non-clustered index on Customer Email to speed up logins/lookups.
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Customers_Email' AND object_id = OBJECT_ID('Customers'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customers_Email ON Customers(Email);
END
GO

-- 2. Non-Clustered Index on Transactions Date for faster reporting
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Transactions_Date' AND object_id = OBJECT_ID('Transactions'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Transactions_Date ON Transactions(TransactionDate);
END
GO

-- ==========================================
-- VIEW CREATION
-- ==========================================

-- 1. SIMPLE VIEW: Active Accounts
-- Abstracts the base table to only show accounts that are currently active.
IF OBJECT_ID('vw_ActiveAccounts', 'V') IS NOT NULL DROP VIEW vw_ActiveAccounts;
GO
CREATE VIEW vw_ActiveAccounts AS
SELECT 
    AccountID, 
    CustomerID, 
    AccountType, 
    Balance 
FROM 
    Accounts 
WHERE 
    Status = 'Active';
GO

-- 2. JOIN-BASED VIEW: Customer Account Details
-- Provides a clean overview of a customer and their account info without exposing sensitive data.
IF OBJECT_ID('vw_CustomerAccountDetails', 'V') IS NOT NULL DROP VIEW vw_CustomerAccountDetails;
GO
CREATE VIEW vw_CustomerAccountDetails AS
SELECT 
    c.CustomerID, 
    c.FirstName + ' ' + c.LastName AS FullName, 
    a.AccountID, 
    a.AccountType, 
    a.Status
FROM 
    Customers c
INNER JOIN 
    Accounts a ON c.CustomerID = a.CustomerID;
GO

-- 3. AGGREGATE VIEW: Branch/Bank Total Liquidity Summary
-- Shows the total amount of money held in the bank per account type.
IF OBJECT_ID('vw_BankLiquiditySummary', 'V') IS NOT NULL DROP VIEW vw_BankLiquiditySummary;
GO
CREATE VIEW vw_BankLiquiditySummary AS
SELECT 
    AccountType, 
    COUNT(AccountID) AS TotalAccounts, 
    SUM(Balance) AS TotalFunds
FROM 
    Accounts
GROUP BY 
    AccountType;
GO
