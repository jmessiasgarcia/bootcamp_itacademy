## Different types of JOINs in MySQL

MySQL supports several JOIN types. Each type determines how tables are related in a query:

INNER JOIN returns rows with matching values across all specified tables.
LEFT OUTER JOIN includes all rows from the left table and only matching rows from the right table. Non-matching rows from the right table are filled with NULLs.
RIGHT OUTER JOIN returns all rows from the right table and only the rows from the left table that meet the JOIN condition. Non-matching rows from the left table are filled with NULLs.
CROSS JOIN combines every row from one table with each row from another, resulting in a table with all possible row combinations.
SELF JOIN allows comparisons within the same table or the extraction of hierarchical data. Table aliases are used here to avoid repeating the same table name.
