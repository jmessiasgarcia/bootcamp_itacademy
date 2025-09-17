# Common SQL Errors and Solutions

## 1. Syntax Errors

* **Error**: `ERROR: syntax error at or near ...`
* **Cause**: Missing keywords, wrong order, or incorrect punctuation.
* **Solution**:

  * Double-check SQL syntax (`SELECT ... FROM ... WHERE ...`).
  * Ensure keywords are spelled correctly.
  * Verify use of `;` at the end of statements (depending on SQL engine).

---

## 2. Missing or Wrong Table/Column

* **Error**: `ERROR: relation "table_name" does not exist`
* **Error**: `ERROR: column "column_name" does not exist`
* **Cause**: Typo in table/column name, or object doesn’t exist.
* **Solution**:

  * Use `\dt` (Postgres) or `SHOW TABLES;` (MySQL) to confirm table names.
  * Check schema or case-sensitivity (`"ColumnName"` vs `columnname`).

---

## 3. Ambiguous Column Names

* **Error**: `ERROR: column reference "id" is ambiguous`
* **Cause**: Same column name exists in multiple joined tables.
* **Solution**:

  * Prefix with table alias (`t1.id`, `t2.id`).
  * Rename columns with `AS` for clarity.

---

## 4. Incorrect Data Type

* **Error**: `ERROR: invalid input syntax for type integer`
* **Cause**: Inserting wrong data type (e.g., string into integer).
* **Solution**:

  * Validate input before inserting.
  * Use proper casting (`CAST(column AS INTEGER)`).

---

## 5. Primary Key / Unique Constraint Violation

* **Error**: `ERROR: duplicate key value violates unique constraint ...`
* **Cause**: Inserting a duplicate value in a `PRIMARY KEY` or `UNIQUE` column.
* **Solution**:

  * Use `INSERT ... ON CONFLICT ...` (Postgres) or `INSERT IGNORE` / `REPLACE` (MySQL).
  * Check for duplicates before inserting.

---

## 6. Foreign Key Constraint Violation

* **Error**: `ERROR: insert or update on table ... violates foreign key constraint`
* **Cause**: Trying to insert/update a value that doesn’t exist in the referenced table.
* **Solution**:

  * Insert the parent row first.
  * Ensure data exists in the referenced table.
  * Use `ON DELETE CASCADE` / `ON UPDATE CASCADE` if appropriate.

---

## 7. NULL Constraint Violation

* **Error**: `ERROR: null value in column ... violates not-null constraint`
* **Cause**: Inserting `NULL` where not allowed.
* **Solution**:

  * Provide a default value.
  * Alter table with `DEFAULT` constraint.

---

## 8. Grouping & Aggregation Errors

* **Error**: `ERROR: column "x" must appear in the GROUP BY clause ...`
* **Cause**: Selecting non-aggregated column without grouping.
* **Solution**:

  * Add column to `GROUP BY`.
  * Or use aggregate functions (`MIN()`, `MAX()`, `COUNT()`).

---

## 9. Division by Zero

* **Error**: `ERROR: division by zero`
* **Cause**: Attempting `value / 0`.
* **Solution**:

  * Use `NULLIF(column, 0)` to avoid.
  * Example: `value / NULLIF(denominator, 0)`.

---

## 10. Deadlocks & Locks

* **Error**: `ERROR: deadlock detected`
* **Cause**: Two or more transactions waiting on each other.
* **Solution**:

  * Keep transactions short.
  * Lock rows/tables consistently.
  * Retry failed transactions.

---

## 11. Permissions & Access Errors

* **Error**: `ERROR: permission denied for table ...`
* **Cause**: User lacks privileges.
* **Solution**:

  * Grant required privileges:

    ```sql
    GRANT SELECT, INSERT ON table_name TO user_name;
    ```
  * Ensure correct role/user is being used.

---

## 12. Connection Errors

* **Error**: `ERROR: could not connect to server`
* **Cause**: Database server not running, wrong host/port, firewall issues.
* **Solution**:

  * Verify database service is up.
  * Check host, port, username, password.
  * Ensure network/firewall allows connection.

---

## 13. Timeout Errors

* **Error**: `ERROR: canceling statement due to statement timeout`
* **Cause**: Query too slow, bad indexing, large data scans.
* **Solution**:

  * Optimize query (use `EXPLAIN`).
  * Add indexes where needed.
  * Increase timeout if necessary.

---

## 14. Incorrect Joins

* **Error**: Query returns too many rows or no rows.
* **Cause**: Wrong join type (`INNER`, `LEFT`, `CROSS`).
* **Solution**:

  * Review join condition (`ON` clause).
  * Start with small subsets to validate logic.

---

## 15. Case Sensitivity (Postgres)

* **Error**: `"ColumnName"` vs `columnname`.
* **Cause**: Postgres treats unquoted identifiers as lowercase.
* **Solution**:

  * Use lowercase consistently.
  * Or always quote column names.

---

⚡ Pro Tip: Use **`EXPLAIN`** to debug queries, and always test on a safe environment before production changes.
