<div align="center">

<img src="https://images.unsplash.com/photo-1601597111158-2fceff292cdc?auto=format&fit=crop&w=1200&h=300&q=80" alt="Enterprise Banking Banner" style="border-radius: 10px; margin-bottom: 20px;">

# 🏦 Enterprise Bank Management System

[![SQL Server](https://img.shields.io/badge/Microsoft_SQL_Server-CC292B?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](#)
[![T-SQL](https://img.shields.io/badge/T--SQL-005C84?style=for-the-badge&logo=microsoft&logoColor=white)](#)
[![Normalization](https://img.shields.io/badge/Database_Design-3NF%20%2F%20BCNF-2EA44F?style=for-the-badge)](#)
[![ACID](https://img.shields.io/badge/Architecture-ACID_Compliant-F2C811?style=for-the-badge)](#)
[![Wipro](https://img.shields.io/badge/Training-Wipro_NGA-0000FF?style=for-the-badge)](#)

<img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=600&size=24&pause=1000&color=2EA44F&center=true&vCenter=true&width=600&lines=Robust+Relational+Architecture;Advanced+T-SQL+Programmability;ACID-Compliant+Transactions;Automated+Audit+Logging" alt="Typing SVG" />

**A production-grade relational database architecture engineered to simulate and secure the core financial operations of a commercial banking institution.**

<br />
</div>

---

## 📊 Executive Summary & Project Context

The **Enterprise Bank Management System** is built from the ground up using **Microsoft SQL Server**. It securely manages customer portfolios, distinct financial accounts, and multidirectional monetary transactions. The overarching design prioritizes **Data Integrity**, **ACID-compliant fund transfers**, and **Automated Audit Logging** to meet stringent enterprise-level reporting and security standards.

This project was developed as part of a comprehensive Capstone Project to demonstrate mastery of advanced database management, programmatic SQL logic, and secure architectural design.

---

## 🏗️ Core Business Workflows

The database is designed to seamlessly handle the fundamental workflows of a modern bank. The flowchart below illustrates the data lifecycle from customer creation to transaction auditing.

```mermaid
graph TD
    A[🧑 Customer] -->|Opens| B(💳 Account)
    B -->|Initiates| C{💰 Transaction}
    C -->|Deposit / Withdraw| D[Update Local Balance]
    C -->|Fund Transfer| E[Update Source & Target]
    D -.->|Triggers Event| F[(🛡️ Audit Log)]
    E -.->|Triggers Event| F
    
    style A fill:#e1f5fe,stroke:#0288d1,stroke-width:2px
    style B fill:#e8f5e9,stroke:#388e3c,stroke-width:2px
    style C fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    style F fill:#ffebee,stroke:#d32f2f,stroke-width:2px
```

---

## 🗄️ Database Architecture & Normalization

The database schema was meticulously modeled using precise Entity-Relationship principles. To guarantee zero update, insertion, or deletion anomalies, the architecture is rigorously normalized up to **Third Normal Form (3NF)** and **Boyce-Codd Normal Form (BCNF)**. 

### 📌 Normalization Strategy
- **1NF:** Elimination of repeating groups. All fields contain atomic values (e.g., separating Address into `City`, `State`, `ZipCode`).
- **2NF:** Elimination of partial dependencies. All non-key attributes strictly depend on the entire primary key.
- **3NF/BCNF:** Elimination of transitive dependencies. No non-key attribute depends on another non-key attribute, ensuring complete data isolation.

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
| 📈 **Analytical Views** | `INNER`, `LEFT`, `RIGHT`, `FULL OUTER` Joins | Over 10 advanced aggregate reports abstracted into Views. |

---

## 🚀 Performance Optimization Strategy

To ensure the database can scale and execute queries rapidly even under heavy transaction loads, the following optimizations were implemented:
1. **Clustered Indexes:** Automatically applied to all Primary Keys (`CustomerID`, `AccountID`, etc.) to physically sort the data on disk for lightning-fast retrieval.
2. **Non-Clustered Indexes:** Strategically deployed on heavily searched columns (such as `Email` on the Customers table and `TransactionDate` on the Transactions table) to drastically reduce query scanning times.
3. **Data Abstraction:** Complex, multi-join queries are wrapped in **SQL Views** (`vw_ActiveAccounts`, `vw_CustomerAccountDetails`), reducing repetitive compilation overhead and protecting raw table schemas from end-users.

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

## 📊 Sample Intelligence & Reporting

The database is equipped with advanced `GROUP BY` and `HAVING` queries to extract intelligence. Below is an example of the generated output for the **Bank Liquidity Summary**:

| AccountType | TotalLiquidity | TotalAccounts |
| :--- | :--- | :--- |
| **Savings** | `$20,250.00` | 3 |
| **Current** | `$4,600.50` | 2 |

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

## 💻 Deployment & Execution Guide

To deploy this database cluster locally using **SQL Server Management Studio (SSMS)** or **Azure Data Studio**, execute the modular scripts in sequential order:

1. **Initialize Engine:** Execute `SQL/ddl_scripts.sql` to construct the `BankManagementDB` schema and constraints.
2. **Seed Data:** Run `SQL/dml_scripts.sql` to populate foundational dummy data.
3. **Compile Architecture:** Deploy `SQL/views.sql`, `SQL/functions.sql`, and `SQL/triggers.sql` to establish the programmable layer.
4. **Run Simulations:**
   - Execute `SQL/transaction_control.sql` to witness atomic fund transfers in action.
   - Probe the `AuditLogs` table to verify trigger execution.
   - Run `SQL/queries.sql` to extract high-level analytical reports.

---

## 👨‍💻 Developer & Acknowledgements

<div align="center">
  <img src="https://img.shields.io/badge/Developer-Dibyajyoti_Chakravarti-005C84?style=for-the-badge&logo=github" alt="Developer Name">
</div>

<br>

This enterprise project was architected and developed by **Dibyajyoti Chakravarti** as part of the intensive **Wipro NGA Training Program**. It stands as a comprehensive capstone deliverable, demonstrating rigorous adherence to software engineering best practices, advanced T-SQL programmability, and secure relational database design. 

**Special Thanks** to the Wipro NGA training faculty for the guidance, foundational knowledge, and the challenge to build a production-grade database system.

<br>

<div align="center">
  <i>"Data is the new oil. Structured data is refined fuel."</i>
</div>
