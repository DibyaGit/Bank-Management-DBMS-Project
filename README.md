<div align="center">

# 🏦 Enterprise Bank Management System

[![SQL Server](https://img.shields.io/badge/Microsoft_SQL_Server-CC292B?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](#)
[![T-SQL](https://img.shields.io/badge/T--SQL-005C84?style=for-the-badge&logo=microsoft&logoColor=white)](#)
[![Normalization](https://img.shields.io/badge/Database_Design-3NF%20%2F%20BCNF-2EA44F?style=for-the-badge)](#)
[![ACID](https://img.shields.io/badge/Architecture-ACID_Compliant-F2C811?style=for-the-badge)](#)

<img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=600&size=24&pause=1000&color=2EA44F&center=true&vCenter=true&width=600&lines=Robust+Relational+Architecture;Advanced+T-SQL+Programmability;ACID-Compliant+Transactions;Automated+Audit+Logging" alt="Typing SVG" />

**A production-grade relational database architecture engineered to simulate and secure the core financial operations of a commercial banking institution.**

<br />
</div>

---

## 📊 Executive Summary

The **Enterprise Bank Management System** is built from the ground up using **Microsoft SQL Server**. It securely manages customer portfolios, distinct financial accounts, and multidirectional monetary transactions. The overarching design prioritizes **Data Integrity**, **ACID-compliant fund transfers**, and **Automated Audit Logging** to meet stringent enterprise-level reporting and security standards.

---

## 🗄️ Database Architecture & Normalization

The database schema was meticulously modeled using precise Entity-Relationship principles. To guarantee zero update, insertion, or deletion anomalies, the architecture is rigorously normalized up to **Third Normal Form (3NF)** and **Boyce-Codd Normal Form (BCNF)**. 

<div align="center">
  <img src="ERD/er_diagram.png" alt="Database Schema Diagram" width="800" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
  <p><em>Figure 1: Core 1-to-Many relationships dictating the secure flow of data.</em></p>
</div>

---

## ⚙️ Enterprise Technical Modules

This system leverages advanced SQL features to transition from a simple data store into a programmable, intelligent financial ledger.

| Module | Implementation | Purpose |
| :---: | :--- | :--- |
| 🛡️ **DDL & Integrity** | `PRIMARY KEY`, `FOREIGN KEY` (Cascade), `UNIQUE`, `CHECK` | Enforces absolute business rules at the schema level (e.g., preventing negative account balances). |
| ⚡ **Programmability** | `SCALAR` & `TABLE-VALUED FUNCTIONS` | Encapsulates reusable, high-performance business logic such as dynamic liquidity calculation. |
| 🔄 **Automation** | `AFTER INSERT / UPDATE / DELETE` Triggers | Binds to critical tables to automatically record state changes, driving the immutable `AuditLogs` table. |
| 💳 **TCL (Transactions)** | `BEGIN TRAN`, `COMMIT`, `ROLLBACK` via `TRY...CATCH` | Secures fund transfers. Guarantees operations are fully atomic, preventing partial financial updates. |
| 🔐 **DCL (Security)** | `GRANT`, `DENY`, `REVOKE` DCL Commands | Simulates enterprise Role-Based Access Control (RBAC) across `BankTellerRole` and `DBAdminRole`. |
| 📈 **Analytical Views** | `INNER`, `LEFT`, `RIGHT`, `FULL OUTER` Joins | Over 10 advanced aggregate reports abstracted into Views, accelerated by Clustered & Non-Clustered Indexes. |

---

## 🔍 Deep Dive: Advanced Logic Implementation

<details>
<summary><b>1. Automated Security Audit Triggers (Click to Expand)</b></summary>
<br>
The database utilizes active Triggers to maintain a pristine audit trail. If an account balance is updated, the trigger intercepts the virtual `INSERTED` and `DELETED` tables to silently write the delta to the Audit Log.

```sql
CREATE TRIGGER trg_AfterAccountUpdate ON Accounts AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Balance)
    BEGIN
        INSERT INTO AuditLogs (ActionType, TableName, RecordID, OldBalance, NewBalance, ActionDate)
        SELECT 'UPDATE', 'Accounts', i.AccountID, d.Balance, i.Balance, GETDATE()
        FROM inserted i INNER JOIN deleted d ON i.AccountID = d.AccountID
        WHERE i.Balance <> d.Balance;
    END
END
```
</details>

<details>
<summary><b>2. ACID-Compliant Fund Transfers (Click to Expand)</b></summary>
<br>
Financial transfers must be atomic. By wrapping the logic in a TCL block, the system ensures that if the destination account receives the deposit, but the source account fails the `CHECK (Balance >= 0)` deduction constraint, the entire transaction is instantaneously rolled back.

```sql
BEGIN TRY
    BEGIN TRANSACTION;
    
    UPDATE Accounts SET Balance = Balance - @Amount WHERE AccountID = @Source;
    UPDATE Accounts SET Balance = Balance + @Amount WHERE AccountID = @Target;
    
    INSERT INTO Transactions ... -- Log operations
    
    COMMIT TRANSACTION; -- Atomic success
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION; -- Immediate fallback
END CATCH;
```
</details>

---

## 📂 Repository Blueprint

```text
Bank-Management-DBMS-Project/
├── 📄 README.md                        # Enterprise project documentation (You are here)
├── 📁 Documentation/
│   └── 📄 normalization_report.pdf     # Extensive 1NF to 3NF/BCNF normalization proof
├── 📁 ERD/
│   └── 🖼️ er_diagram.png               # Rendered graphical Database Schema
├── 📁 Output/
│   └── 📊 sample_results.csv           # Exported raw intelligence from complex queries
└── 📁 SQL/
    ├── 1️⃣ ddl_scripts.sql              # Schema creation and referential integrity constraints
    ├── 2️⃣ dml_scripts.sql              # Dummy data population and sample DML mutations
    ├── 3️⃣ views.sql                    # Abstracted analytical views and index tuning
    ├── 4️⃣ functions.sql                # Reusable scalar and TVF programmatic objects
    ├── 5️⃣ triggers.sql                 # Invisible audit logging automation
    ├── 6️⃣ queries.sql                  # Suite of 10+ advanced multi-join reporting queries
    ├── 7️⃣ transaction_control.sql      # ACID-compliant fund transfer simulation logic
    └── 8️⃣ access_control.sql           # RBAC security simulation via DCL
```

---

## 🚀 Deployment & Execution Guide

To deploy this database cluster locally using **SQL Server Management Studio (SSMS)** or **Azure Data Studio**, execute the modular scripts in sequential order:

1. **Initialize Engine:** Execute `SQL/ddl_scripts.sql` to construct the `BankManagementDB` schema and constraints.
2. **Seed Data:** Run `SQL/dml_scripts.sql` to populate foundational dummy data.
3. **Compile Architecture:** Deploy `SQL/views.sql`, `SQL/functions.sql`, and `SQL/triggers.sql` to establish the programmable layer.
4. **Run Simulations:**
   - Execute `SQL/transaction_control.sql` to witness atomic fund transfers in action.
   - Probe the `AuditLogs` table to verify trigger execution.
   - Run `SQL/queries.sql` to extract high-level analytical reports.

---
<div align="center">
  <i>Developed to exceed enterprise database architecture standards.</i>
</div>
