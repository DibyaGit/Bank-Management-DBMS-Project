# P2 Bank Management System

## Domain Description
This database management system models the core operations of a commercial banking institution. It is designed to manage customers, their various accounts (Savings and Current), and all associated financial transactions including deposits, withdrawals, and inter-account fund transfers. The system ensures rigorous data integrity, automates the recording of audit trails for sensitive operations, and implements strict transaction controls to prevent inconsistent financial states.

## Database Design Approach
The database was modeled using Entity-Relationship principles and rigorously normalized up to the Third Normal Form (3NF) and Boyce-Codd Normal Form (BCNF). 
The core entities are:
- **Customers**: Contains demographic and contact information.
- **Accounts**: Tied to a customer (1-M relationship), tracking balance and status.
- **Transactions**: Tied to an account (1-M relationship), tracking all monetary movements.
- **AuditLogs**: Automatically populated via system triggers to track data modifications.

This schema guarantees that there are no partial or transitive dependencies, effectively eliminating update, insertion, and deletion anomalies.

## Features Implemented
- **Data Definition & Integrity (DDL)**: Comprehensive table structures with Primary Keys, Foreign Keys, `NOT NULL`, `CHECK` (preventing negative balances), and `UNIQUE` constraints.
- **Data Manipulation (DML)**: robust dummy data population alongside sample `UPDATE` and `DELETE` operations.
- **Complex Querying**: Over 10 advanced queries leveraging `INNER`, `LEFT`, `RIGHT`, and `FULL OUTER` joins, subqueries, and aggregate functions (`GROUP BY`, `HAVING`) for advanced reporting.
- **Views & Indexes**: Simple, join-based, and aggregate views abstracting complex queries, optimized by clustered and non-clustered indexes.
- **Advanced Programmability**: 
  - **Scalar & Table-Valued Functions**: Encapsulating reusable business logic (e.g., calculating total customer balances, retrieving transaction history).
  - **Triggers**: `AFTER INSERT`, `UPDATE`, and `DELETE` triggers automating the population of the `AuditLogs` table for enhanced security.
- **Transaction Control Language (TCL)**: Secure fund transfer simulations using `BEGIN TRAN`, `COMMIT`, and `ROLLBACK` within a `TRY...CATCH` block to ensure ACID compliance.
- **Data Control Language (DCL)**: Simulated role-based access control using `GRANT` and `REVOKE` for Bank Tellers and Database Administrators.

## Execution Steps
To execute this project locally in SQL Server Management Studio (SSMS) or Azure Data Studio:

1. **Setup the Schema**:
   Open and execute `SQL/ddl_scripts.sql`. This will create the `BankManagementDB` database, all tables, and their constraints.
   
2. **Populate Data**:
   Open and execute `SQL/dml_scripts.sql` to insert dummy data and test basic DML operations.

3. **Deploy Views and Indexes**:
   Open and execute `SQL/views.sql` to compile the views and apply performance indexes.

4. **Deploy Advanced Logic**:
   Open and execute `SQL/functions.sql` and `SQL/triggers.sql` to instantiate the programmable objects into the database schema.

5. **Test Querying & Transactions**:
   - Run the complex reports found in `SQL/queries.sql`.
   - Run the fund transfer simulation found in `SQL/transaction_control.sql` to witness the TCL logic and audit triggers in action.
   - Run `SQL/access_control.sql` to test the DCL permission mechanics.

## Sample Queries and Outputs

**Query:** Total balance per customer across active accounts
```sql
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
```
**Sample Output:**
| CustomerID | FirstName | LastName | TotalBalance |
|------------|-----------|----------|--------------|
| 2          | Bob       | Johnson  | 15000.00     |
| 1          | Alice     | Smith    | 6200.50      |
| 3          | Charlie   | Williams | 3400.00      |
| 4          | Diana     | Brown    | 250.00       |

**Query:** Finding the maximum single transaction per account
```sql
SELECT 
    a.AccountID,
    a.AccountType,
    (SELECT MAX(Amount) FROM Transactions t WHERE t.AccountID = a.AccountID) AS MaxTransactionAmount
FROM 
    Accounts a
WHERE 
    a.Status = 'Active';
```
**Sample Output:**
| AccountID | AccountType | MaxTransactionAmount |
|-----------|-------------|----------------------|
| 1000      | Savings     | 2000.00              |
| 1001      | Current     | 500.00               |
| 1002      | Savings     | 5000.00              |
