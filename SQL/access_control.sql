-- =======================================================================================
-- Project: P2 - Bank Management System
-- Script: access_control.sql
-- Purpose: Simulates role-based access control using DCL commands (GRANT and REVOKE).
-- =======================================================================================

USE BankManagementDB;
GO

-- ==========================================
-- 1. Create Roles
-- ==========================================
-- Bank Tellers only need to view data and process simple updates.
-- Database Admins have full structural control.
IF DATABASE_PRINCIPAL_ID('BankTellerRole') IS NULL
BEGIN
    CREATE ROLE BankTellerRole;
END

IF DATABASE_PRINCIPAL_ID('DBAdminRole') IS NULL
BEGIN
    CREATE ROLE DBAdminRole;
END
GO

-- ==========================================
-- 2. GRANT Permissions
-- ==========================================
-- The Teller can view Customers and Accounts, and Insert Transactions
GRANT SELECT ON Customers TO BankTellerRole;
GRANT SELECT ON Accounts TO BankTellerRole;
GRANT INSERT ON Transactions TO BankTellerRole;

-- The Admin gets full control over all tables
GRANT CONTROL ON Customers TO DBAdminRole;
GRANT CONTROL ON Accounts TO DBAdminRole;
GRANT CONTROL ON Transactions TO DBAdminRole;
GRANT CONTROL ON AuditLogs TO DBAdminRole;
GO

-- ==========================================
-- 3. REVOKE / DENY Permissions
-- ==========================================
-- Explicitly prevent Bank Tellers from deleting anything, even if granted by another role
DENY DELETE ON Customers TO BankTellerRole;
DENY DELETE ON Accounts TO BankTellerRole;
DENY DELETE ON Transactions TO BankTellerRole;

-- Revoke a previously granted permission (if we decided Tellers shouldn't see Audit Logs)
-- Let's pretend they were given access accidentally.
GRANT SELECT ON AuditLogs TO BankTellerRole;
REVOKE SELECT ON AuditLogs TO BankTellerRole;
GO

PRINT 'Access control roles and permissions configured successfully.';
GO
