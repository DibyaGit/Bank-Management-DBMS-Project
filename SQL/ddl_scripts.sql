-- =======================================================================================
-- Project: P2 - Bank Management System
-- Script: ddl_scripts.sql
-- Purpose: Creates the database, tables, and applies PK, FK, CHECK, and UNIQUE constraints.
-- =======================================================================================

-- Create Database if it does not exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'BankManagementDB')
BEGIN
    CREATE DATABASE BankManagementDB;
END
GO

USE BankManagementDB;
GO

-- ==========================================
-- 1. Customers Table
-- ==========================================
-- Represents the bank's clients.
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    AddressLine VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10)
);
GO

-- ==========================================
-- 2. Accounts Table
-- ==========================================
-- Represents the savings/current accounts linked to a customer.
IF OBJECT_ID('dbo.Accounts', 'U') IS NOT NULL DROP TABLE dbo.Accounts;
CREATE TABLE Accounts (
    AccountID INT IDENTITY(1000,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountType VARCHAR(20) NOT NULL CHECK (AccountType IN ('Savings', 'Current')),
    Balance DECIMAL(18,2) NOT NULL CHECK (Balance >= 0),
    Status VARCHAR(15) NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active', 'Closed', 'Suspended')),
    OpenedDate DATETIME DEFAULT GETDATE(),
    
    -- Foreign Key Constraint Linking Account to Customer
    CONSTRAINT FK_Accounts_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);
GO

-- ==========================================
-- 3. Transactions Table
-- ==========================================
-- Records deposits, withdrawals, and transfers for accounts.
IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL DROP TABLE dbo.Transactions;
CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(20) NOT NULL CHECK (TransactionType IN ('Deposit', 'Withdrawal', 'Transfer')),
    Amount DECIMAL(18,2) NOT NULL CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT GETDATE(),
    ReferenceAccountID INT NULL, -- Used for target account in Transfers
    
    -- Foreign Key Constraint Linking Transaction to Account
    CONSTRAINT FK_Transactions_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);
GO

-- ==========================================
-- 4. AuditLogs Table
-- ==========================================
-- Captures automated logs triggered by balance updates or operations.
IF OBJECT_ID('dbo.AuditLogs', 'U') IS NOT NULL DROP TABLE dbo.AuditLogs;
CREATE TABLE AuditLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ActionType VARCHAR(20) NOT NULL CHECK (ActionType IN ('INSERT', 'UPDATE', 'DELETE')),
    TableName VARCHAR(50) NOT NULL,
    RecordID INT NOT NULL,
    OldBalance DECIMAL(18,2) NULL,
    NewBalance DECIMAL(18,2) NULL,
    ActionDate DATETIME DEFAULT GETDATE()
);
GO
