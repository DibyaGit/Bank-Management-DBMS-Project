-- =======================================================================================
-- Project: P2 - Bank Management System
-- Script: transaction_control.sql
-- Purpose: Demonstrates a secure fund transfer using TCL (COMMIT and ROLLBACK).
-- =======================================================================================

USE BankManagementDB;
GO

/*
  TRANSACTION HANDLING DOMAIN USE CASE:
  A customer wants to transfer $500 from Account 1000 to Account 1002.
  This requires two updates (deduct from 1000, add to 1002) and two inserts (log the withdrawal, log the deposit).
  If any of these operations fail (e.g., due to insufficient balance triggering the CHECK constraint), 
  the entire block must ROLLBACK to prevent money from disappearing or duplicating.
*/

-- Declare variables for the transfer
DECLARE @SourceAccount INT = 1000;
DECLARE @TargetAccount INT = 1002;
DECLARE @TransferAmount DECIMAL(18,2) = 500.00;

BEGIN TRY
    -- 1. Begin the Transaction
    BEGIN TRANSACTION;
    
    PRINT 'Transaction Started.';

    -- 2. Deduct from Source Account
    -- The CHECK(Balance >= 0) constraint will throw an error if this causes an overdraft.
    UPDATE Accounts
    SET Balance = Balance - @TransferAmount
    WHERE AccountID = @SourceAccount;
    
    PRINT 'Deducted from Source Account.';

    -- 3. Add to Target Account
    UPDATE Accounts
    SET Balance = Balance + @TransferAmount
    WHERE AccountID = @TargetAccount;

    PRINT 'Added to Target Account.';

    -- 4. Record the Transfer in Transactions Table
    INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate, ReferenceAccountID)
    VALUES 
    (@SourceAccount, 'Transfer', @TransferAmount, GETDATE(), @TargetAccount),
    (@TargetAccount, 'Transfer', @TransferAmount, GETDATE(), @SourceAccount);

    PRINT 'Recorded in Transactions table.';

    -- 5. Commit the Transaction if everything succeeded
    COMMIT TRANSACTION;
    PRINT 'Transaction COMMITTED Successfully. Fund transfer complete.';

END TRY
BEGIN CATCH
    -- 6. Rollback the Transaction if an error occurred
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Error occurred! Transaction ROLLBACK executed.';
    END

    -- Output the error details for debugging
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
    PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);
END CATCH;
GO
