# Normalization Report: P2 Bank Management System

## Overview
This document outlines the database normalization process for the Bank Management System, ensuring the database is designed up to the Third Normal Form (3NF) / Boyce-Codd Normal Form (BCNF). Normalization minimizes data redundancy and eliminates insertion, update, and deletion anomalies.

---

## 1. Unnormalized Form (UNF)
In the Unnormalized Form, data may contain repeating groups or multi-valued attributes. A simple view of customer transactions could look like this:

**Table: BankData_UNF**
- `CustomerID`, `CustomerName`, `Email`, `Phone`, `Address`
- `AccountID`, `AccountType`, `Balance`
- `TransactionID`, `TransactionType`, `Amount`, `TransactionDate`

*Anomalies in UNF:*
- **Update Anomaly:** Updating a customer's address requires changing multiple rows if they have multiple accounts/transactions.
- **Insertion Anomaly:** Cannot add a customer without an account.
- **Deletion Anomaly:** Deleting a transaction might delete the only record of an account or customer.

---

## 2. First Normal Form (1NF)
**Rule:** Eliminate repeating groups. Every column must hold atomic (indivisible) values, and each record must have a unique identifier (Primary Key).

**Resolution:**
We separate the compound attributes (like Address into City, State, Zip) and ensure no arrays or comma-separated values exist. 

**Tables in 1NF:**
- **Customers:** `CustomerID` (PK), `FirstName`, `LastName`, `Email`, `Phone`, `AddressLine`, `City`, `State`, `ZipCode`
- **Accounts:** `AccountID` (PK), `CustomerID`, `AccountType`, `Balance`, `Status`, `OpenedDate`
- **Transactions:** `TransactionID` (PK), `AccountID`, `TransactionType`, `Amount`, `TransactionDate`, `ReferenceAccountID`
- **AuditLogs:** `LogID` (PK), `ActionType`, `TableName`, `RecordID`, `OldBalance`, `NewBalance`, `ActionDate`

---

## 3. Second Normal Form (2NF)
**Rule:** Must be in 1NF and have no partial dependencies. All non-key attributes must be fully functionally dependent on the entire Primary Key.

**Resolution:**
Since all of our proposed tables use single-column surrogate primary keys (`CustomerID`, `AccountID`, `TransactionID`, `LogID`), partial dependencies (which only occur with composite primary keys) are inherently impossible.
Therefore, our 1NF tables are automatically in 2NF.

---

## 4. Third Normal Form (3NF) & BCNF
**Rule:** Must be in 2NF and have no transitive dependencies. Non-key attributes must not depend on other non-key attributes. (BCNF further requires that every determinant must be a candidate key).

**Resolution:**
Let's examine our tables for transitive dependencies:
- **Customers:** `FirstName`, `LastName`, `Email`, `Phone`, etc., only depend directly on `CustomerID`. (City/State could technically depend on ZipCode, but in standard practice for basic addresses, this is considered acceptable or resolved via a separate ZipCode lookup table. For this project's scope, the current structure is standard 3NF).
- **Accounts:** `AccountType`, `Balance`, `Status`, `OpenedDate` depend strictly on `AccountID`. 
- **Transactions:** `TransactionType`, `Amount`, `TransactionDate`, `ReferenceAccountID` depend strictly on `TransactionID`.
- **AuditLogs:** All audit details depend purely on `LogID`.

**Final 3NF/BCNF Schema:**
1. **Customers** 
   - `CustomerID` (Primary Key)
   - `FirstName`, `LastName`, `Email`, `Phone`, `AddressLine`, `City`, `State`, `ZipCode`
2. **Accounts**
   - `AccountID` (Primary Key)
   - `CustomerID` (Foreign Key referencing `Customers`)
   - `AccountType`, `Balance`, `Status`, `OpenedDate`
3. **Transactions**
   - `TransactionID` (Primary Key)
   - `AccountID` (Foreign Key referencing `Accounts`)
   - `TransactionType`, `Amount`, `TransactionDate`, `ReferenceAccountID`
4. **AuditLogs**
   - `LogID` (Primary Key)
   - `ActionType`, `TableName`, `RecordID`, `OldBalance`, `NewBalance`, `ActionDate`

## Conclusion
The resulting database design enforces strict 1-to-Many relationships:
- One Customer can have Multiple Accounts (1-M).
- One Account can have Multiple Transactions (1-M).
This schema successfully satisfies 3NF/BCNF requirements, guaranteeing optimal data integrity and efficient querying.
