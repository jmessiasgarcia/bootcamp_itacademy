/*
Basic Analysis
1.Top 3 countries with the highest number of transactions.
Show the country and the total number of transactions.
*/

SELECT c.country, COUNT(DISTINCT t.id) AS number_of_transactions
FROM company c 
JOIN transaction t ON c.id = t.company_id
GROUP BY c.country
ORDER BY number_of_transactions DESC
LIMIT 3;

/*
2.Total sales amount per company.
Order the result from highest to lowest.
*/

SELECT FORMAT(SUM(t.amount), 2) AS total_sales, c.country
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.country
ORDER BY SUM(t.amount) DESC;

/*
3.Companies without a registered phone number (assuming there is a `phone` column).
*/

SELECT c.phone, c.company_name
FROM company c
WHERE c.phone IS NULL;

/*  
4.Average sales per company. Order the result to see which companies have the highest average.
*/

SELECT FORMAT(AVG(t.amount),2) AS avg_sales, c.company_name
FROM transaction t
JOIN company c ON t.company_id = c.id
GROUP BY c.company_name
ORDER BY AVG(t.amount) DESC;

/*  
5. Companies per country.
*/

SELECT 
    country,
    COUNT(*) AS num_companies
FROM company
GROUP BY country
ORDER BY num_companies DESC;

/* Subconsultas
SELECT: subconsulta devuelve valor por fila.
FROM: subconsulta actúa como tabla temporal.
WHERE/HAVING: subconsulta filtra filas basadas en algún cálculo.

6.Companies with transactions greater than the average of their own country.
*/

SELECT 
    c.company_name,
    c.country,
    COUNT(t.id) AS number_of_transactions
FROM transaction t
JOIN company c ON t.company_id = c.id
GROUP BY c.company_name, c.country
HAVING COUNT(t.id) > (
    SELECT AVG(sub_trans_count)
    FROM (
        SELECT COUNT(t2.id) AS sub_trans_count
        FROM transaction t2
        JOIN company c2 ON t2.company_id = c2.id
        WHERE c2.country = c.country
        GROUP BY c2.company_name
    ) AS country_avg
)
ORDER BY c.country, number_of_transactions DESC;

/*
7. Companies that generated less revenue than the overall average revenue of all companies.**
*/

SELECT 
    c.company_name, c.country,
    SUM(t.amount) AS total_revenue
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.company_name,c.country
HAVING SUM(t.amount) < (
    SELECT AVG(company_total)
    FROM (
        SELECT SUM(t2.amount) AS company_total
        FROM transaction t2
        JOIN company c2 ON t2.company_id = c2.id
        GROUP BY c2.company_name
    ) AS avg_per_company
)
ORDER BY c.country, total_revenue ASC;

/*
8. Transactions made on the same date as the highest-value transaction.
*/

SELECT *
FROM transaction 
WHERE DATE_FORMAT(timestamp,'%m-%d-%Y') = (
    SELECT DATE_FORMAT(timestamp,'%m-%d-%Y')
    FROM transaction 
    ORDER BY amount
    LIMIT 1
);

/*
09. Month with the highest revenue across the entire database.
*/

SELECT EXTRACT(MONTH FROM t.timestamp), SUM(t.amount)
FROM transaction t
WHERE EXTRACT(MONTH FROM t.timestamp) = (
	SELECT SUM(t.amount)
    FROM transaction t);
    
/*
10.*Average and total sales per year and per country.
*/

SELECT YEAR(t.timestamp) AS year, ROUND(AVG(t.amount),2) AS avg_sales, c.country
FROM transaction t
JOIN company c ON t.company_id = c.id
GROUP BY c.country, YEAR(t.timestamp)
ORDER BY country, year;

SELECT c.country, YEAR(t.timestamp) AS year, ROUND(SUM(t.amount),2) AS avg_sales
FROM transaction t
JOIN company c ON t.company_id = c.id
GROUP BY c.country, YEAR(t.timestamp)
ORDER BY country, year;

/*
11.List all company names in alphabetical order.
*/

SELECT c.company_name
FROM company c
ORDER BY c.company_name;

/*
12.Show all transactions with an amount greater than 100.
*/

SELECT *
FROM transaction
WHERE amount > 100 AND declined = 0;

/*
13.Count how many companies exist per country.
*/

SELECT 
	DISTINCT COUNT(c.company_name) AS number_of_companies, c.country
FROM company c
GROUP BY 2
ORDER BY number_of_companies;

/*
14.Show the most recent transaction for each company.
*/
SELECT
    t.id,
    c.company_name,
    t.timestamp AS last_date
FROM transaction t
JOIN company c ON t.company_id = c.id
JOIN (
    SELECT
        company_id,
        MAX(timestamp) AS max_date
    FROM transaction
    GROUP BY company_id
) last_tx ON t.company_id = last_tx.company_id AND t.timestamp = last_tx.max_date;

/*
15.Show the total number of transactions made by each company.
*/

SELECT COUNT(t.id) AS number_of_transactions, c.company_name
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.company_name
ORDER BY number_of_transactions;

/*
16.Show the average transaction amount per country and order from highest to lowest.
*/

SELECT 
	ROUND(AVG(t.amount),2) AS avg_sales,
    c.country
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.country
ORDER BY avg_sales DESC;


