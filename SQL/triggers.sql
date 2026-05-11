-- =======================================================================================
-- Project: P2 - Bank Management System
-- Script: triggers.sql
-- Purpose: Implements AFTER triggers for comprehensive transaction audit logging.
-- =======================================================================================

USE BankManagementDB;
GO

/*
  TECHNICAL LIFECYCLE (Applies to all triggers below):
  1. Declaration: We define the trigger using `CREATE TRIGGER [Name]` and specify the target table `ON [TableName]`. We dictate the timing and event, e.g., `AFTER INSERT`.
  2. Definition: The internal logic determines how the trigger behaves. SQL Server provides two virtual, in-memory tables exclusively available inside triggers:
     - `INSERTED`: Holds copies of the new rows being inserted or updated.
     - `DELETED`: Holds copies of the old rows being deleted or updated.
     The definition maps values from these virtual tables into our `AuditLogs` table.
  3. Instantiation: Executing this script binds the trigger to the target table in the database schema. It sits dormant until the target event occurs.
  4. Invocation: The trigger fires automatically and implicitly. When an application or query runs an `INSERT/UPDATE/DELETE` on the target table, the Database Engine detects it, completes the base operation, and immediately executes the trigger logic synchronously.
*/

-- ==========================================
-- 1. AFTER INSERT TRIGGER: Log New Transactions
-- ==========================================
IF OBJECT_ID('dbo.trg_AfterTransactionInsert', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_AfterTransactionInsert;
GO
CREATE TRIGGER trg_AfterTransactionInsert
ON Transactions
AFTER INSERT
AS
BEGIN
    -- Suppress row counts to improve performance
    SET NOCOUNT ON;

    -- Insert into the audit log by reading from the virtual 'inserted' table
    INSERT INTO AuditLogs (ActionType, TableName, RecordID, OldBalance, NewBalance, ActionDate)
    SELECT 
        'INSERT',
        'Transactions',
        i.TransactionID,
        NULL,      -- Old balance is irrelevant for a raw transaction log
        i.Amount,  -- Capturing the transaction amount
        GETDATE()
    FROM inserted i;
END
GO

-- ==========================================
-- 2. AFTER UPDATE TRIGGER: Log Account Balance Changes
-- ==========================================
IF OBJECT_ID('dbo.trg_AfterAccountUpdate', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_AfterAccountUpdate;
GO
CREATE TRIGGER trg_AfterAccountUpdate
ON Accounts
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Only log if the balance actually changed to prevent noise from status updates
    IF UPDATE(Balance)
    BEGIN
        INSERT INTO AuditLogs (ActionType, TableName, RecordID, OldBalance, NewBalance, ActionDate)
        SELECT 
            'UPDATE',
            'Accounts',
            i.AccountID,
            d.Balance, -- Value before the update (from DELETED)
            i.Balance, -- Value after the update (from INSERTED)
            GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.AccountID = d.AccountID
        WHERE i.Balance <> d.Balance;
    END
END
GO

-- ==========================================
-- 3. AFTER DELETE TRIGGER: Log Account Closures/Deletions
-- ==========================================
IF OBJECT_ID('dbo.trg_AfterAccountDelete', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_AfterAccountDelete;
GO
CREATE TRIGGER trg_AfterAccountDelete
ON Accounts
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into the audit log by reading from the virtual 'deleted' table
    INSERT INTO AuditLogs (ActionType, TableName, RecordID, OldBalance, NewBalance, ActionDate)
    SELECT 
        'DELETE',
        'Accounts',
        d.AccountID,
        d.Balance,
        NULL, -- New balance doesn't exist anymore
        GETDATE()
    FROM deleted d;
END
GO
