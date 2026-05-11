-- =======================================================================================
-- Project: P2 - Bank Management System
-- Script: functions.sql
-- Purpose: Implements advanced scalar and table-valued functions for business logic.
-- =======================================================================================

USE BankManagementDB;
GO

-- ==========================================
-- 1. SCALAR FUNCTION: Calculate Total Balance
-- ==========================================
/*
  TECHNICAL LIFECYCLE:
  1. Declaration: We define the function name `fn_GetTotalCustomerBalance` and declare its input parameter `@CustomerID` (INT). We also declare the return type `RETURNS DECIMAL(18,2)`.
  2. Definition: The logic inside the `BEGIN...END` block defines what the function does. We declare an internal variable `@TotalBalance` to hold the summed value.
  3. Instantiation: Once this CREATE FUNCTION block is executed, SQL Server compiles the execution plan and saves the object `fn_GetTotalCustomerBalance` into the database schema.
  4. Invocation: The function is called in standard queries, e.g., `SELECT dbo.fn_GetTotalCustomerBalance(1) AS TotalFunds;`
*/

IF OBJECT_ID('dbo.fn_GetTotalCustomerBalance', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_GetTotalCustomerBalance;
GO
CREATE FUNCTION dbo.fn_GetTotalCustomerBalance(@CustomerID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TotalBalance DECIMAL(18,2);
    
    -- Calculate the sum of all active accounts for the specific customer
    SELECT @TotalBalance = SUM(Balance)
    FROM Accounts
    WHERE CustomerID = @CustomerID AND Status = 'Active';
    
    -- Handle cases where a customer has no accounts (return 0 instead of NULL)
    RETURN ISNULL(@TotalBalance, 0);
END
GO


-- ==========================================
-- 2. TABLE-VALUED FUNCTION (TVF): Get Account Transaction History
-- ==========================================
/*
  TECHNICAL LIFECYCLE:
  1. Declaration: We define the function name `fn_GetAccountTransactions` and its input parameter `@AccountID` (INT). We specify `RETURNS TABLE` indicating an inline TVF.
  2. Definition: Unlike a scalar function, an inline TVF does not use a `BEGIN...END` block. The definition is simply the `RETURN` statement followed by a single `SELECT` query.
  3. Instantiation: Executing this script saves the inline TVF into the database. SQL Server treats it essentially as a parameterized view.
  4. Invocation: It is queried just like a standard table using the `FROM` clause: 
     `SELECT * FROM dbo.fn_GetAccountTransactions(1000);`
*/

IF OBJECT_ID('dbo.fn_GetAccountTransactions', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_GetAccountTransactions;
GO
CREATE FUNCTION dbo.fn_GetAccountTransactions(@AccountID INT)
RETURNS TABLE
AS
RETURN
(
    -- Retrieve all transactions linked to the provided AccountID
    SELECT 
        TransactionID,
        TransactionType,
        Amount,
        TransactionDate,
        ReferenceAccountID
    FROM 
        Transactions
    WHERE 
        AccountID = @AccountID
);
GO
