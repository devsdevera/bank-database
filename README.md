# 🏦 SQL Database Design & Querying Project

## 📘 Project Overview

This project models a fictional relational database for a law enforcement scenario involving bank robberies. The database is designed to analyze robbers, their skills, robbery plans, and historic events using SQL. It emphasizes data integrity, relational modeling, and advanced query logic.

---

## 🧱 Database Schema Design

The schema includes **8 tables** and **2 ENUM types**:

| Table         | Description                                            |
|---------------|--------------------------------------------------------|
| `Banks`       | Bank branches with location, account count, security  |
| `Robberies`   | Historic robbery events                                |
| `Plans`       | Future robbery plans with robber count                 |
| `Robbers`     | Robber profiles with age and experience               |
| `Skills`      | Skill names for robbers                                |
| `HasSkills`   | Robber-to-skill mapping with preferences and grades    |
| `HasAccounts` | Links robbers to banks where they have accounts        |
| `Accomplices` | Links robbers to robberies they participated in        |

ENUM types:
- `SecurityLevel`: `'weak'`, `'good'`, `'very good'`, `'excellent'`
- `GradeLevel`: `'C'`, `'C+'`, `'B'`, `'B+'`, `'A'`, `'A+'`

Relational features:
- Composite and surrogate primary keys
- Foreign key constraints with ON DELETE/UPDATE rules
- Use of ENUM and CHECK for robust validation
- Normalized schema with join tables

---

## 💾 Data Loading

Data is loaded using `\copy` in PostgreSQL. Temporary tables are created to transform CSV-like files into normalized formats.

```sql
\copy Banks FROM banks_25.data
\copy Robberies FROM robberies_25.data
\copy Robbers(Nickname, Age, NoYears) FROM robbers_25.data
...
\copy TempHasSkills FROM hasskills_25.data
\copy TempHasAccounts FROM hasaccounts_25.data
\copy TempAccomplices FROM accomplices_25.data
```

Joins are used to resolve `RobberId` and `SkillId` where not directly present in the input data.

---

## ✅ Integrity Tests

The schema was validated against various edge cases:

- Violating `CHECK` constraints (e.g., age < experience)
- Inserting invalid `ENUM` values
- Attempting to delete referenced data
- Ensuring referential integrity via ON DELETE/UPDATE logic

Sample:
```sql
INSERT INTO Robbers(RobberId, Nickname, Age, NoYears) VALUES (333, 'Jail Mouse', 25, 35);
-- ERROR: NoYears > Age
```

---

## 🔍 Query Examples

The project includes 15+ queries across complexity levels:

### 🔹 Simple Queries
- Banks never robbed
- Robbers with >50% of life in prison
- Robbers aged 35+ and their skills
- Robbers earning over $50,000

### 🔸 Complex/Nested Queries
- Robbers in the most lucrative robbery
- Robbers with multiple skills and their top preference
- Banks with plans but no robberies
- Robbers who didn’t rob the banks they have accounts in

### 🔺 Analytical Queries
- Average robbery share per city
- Robbery count and average stolen amount by security level

---

## 📊 Sample Analytical Output

```sql
SELECT b.security, COUNT(*), AVG(Amount)
FROM Robberies AS r
JOIN Banks AS b ON b.BankName = r.BankName AND b.City = r.City
GROUP BY b.security;
```

**Output:**
```
 security   | count |   avg   
------------|-------|---------
 good       |     3 | 5225.00
 very good  |     6 | 3180.00
```

---

## 📁 Files Included

| File                  | Description                                |
|-----------------------|--------------------------------------------|
| `SWEN435_Project.pdf` | Full report with schema and queries        |
| `banks_25.data`       | Bank data                                  |
| `robberies_25.data`   | Robbery events                             |
| `plans_25.data`       | Planned robberies                          |
| `robbers_25.data`     | Robber profiles                            |
| `hasskills_25.data`   | Robber skill mappings                      |
| `hasaccounts_25.data` | Bank account ownership                     |
| `accomplices_25.data` | Robber participation in robberies          |
| `.sql` files          | Scripts for schema creation and querying   |

---

## 📌 Getting Started

1. Ensure PostgreSQL is installed and running.
2. Create the database:
   ```sql
   CREATE DATABASE RobbersGang_deveremma;
   ```
3. Run schema and data population SQL scripts.
4. Execute queries to explore the data and validate relationships.

---

## 👨‍🎓 Author

**Emmanuel De Vera**  
