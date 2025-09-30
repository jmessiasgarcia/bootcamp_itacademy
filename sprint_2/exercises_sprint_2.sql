-- SPRINT_2 - LEVEL_1
-- EXERCISE 1
USE transactions;
SELECT * FROM company  LIMIT 10;
SELECT * FROM transaction;
DESCRIBE company;
DESCRIBE transaction;

-- SPRINT_2
-- EXERCISE 2
-- List of countries that are generating sales

SELECT c.country
FROM company c 
JOIN transaction t ON c.id = t.company_id
GROUP BY c.country;

-- From how many countries are sales being generated?

SELECT COUNT(DISTINCT country) AS number_of_countries
FROM transaction
JOIN company ON transaction.company_id = company.id;

-- Identify the company with the highest average sales.

SELECT company_name, ROUND(AVG(amount), 2) AS average_transaction
FROM transaction
JOIN company ON transaction.company_id = company.id
GROUP BY company_name
ORDER BY average_transaction DESC
LIMIT 1;

/*
SPRINT_2 - LEVEL_1 - EXERCISE 3
Using only subqueries (without using JOIN):
Show all transactions made by companies from Germany.
*/

SELECT *
FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = 'Germany'
);

/* 
Companies that have made transactions for an amount greater than the average of all transactions.
*/
SELECT c.company_name
FROM company c
WHERE c.id IN (
    SELECT t.company_id
    FROM transaction t
    WHERE t.amount > (
		SELECT AVG(amount) 
        FROM transaction t))
        ;
      
/* 
They will eliminate from the system companies that do not have registered transactions, provide a list of these companies.
*/

SELECT 
	c.id, 
    c.company_name
FROM company c 
WHERE c.id NOT IN (
	SELECT DISTINCT c.id
    FROM transaction t)
GROUP BY c.id, c.company_name;

/*
SPRINT_2 - LEVEL_2 - EXERCISE 1
Identify the five days on which the company generated the highest amount of revenue from sales.
Show the date of each transaction together with the total sales.
*/

SELECT 
	DATE_FORMAT(timestamp,'%m-%d-%Y') AS date, 
    FORMAT(SUM(amount),2) AS total_sales
FROM transaction
WHERE declined = 0
GROUP BY date
ORDER BY SUM(amount) DESC
LIMIT 5;

/*
SPRINT_2 - LEVEL_2 - EXERCISE 2
What is the average sales per country? Display the results ordered from the highest to the lowest average.
*/

SELECT country, ROUND(AVG(amount),2) AS avg_sales
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE declined = 0
GROUP BY country
ORDER BY avg_sales DESC;

/*
SPRINT_2 - LEVEL_2 - EXERCISE 3
In your company, a new project is being considered to launch some advertising campaigns to compete with the company 'Non Institute'.
For this purpose, you are asked for the list of all transactions carried out by companies located in the same country as this company.
Display the list applying JOIN and subqueries.
*/

SELECT *
FROM transaction t 
JOIN company c ON t.company_id = c.id
WHERE c.country IN (
	SELECT c.country
	FROM company c
	WHERE c.company_name = 'Non Institute')
AND c.company_name != 'Non Institute' 
AND t.declined = 0;

/*
Display the list applying only subqueries.
*/

SELECT *
FROM transaction t
WHERE t.company_id IN (
    SELECT c.id
    FROM company c
    WHERE c.country = (
        SELECT c.country
        FROM company C
        WHERE c.company_name = 'Non Institute')
AND c.company_name != 'Non Institute')
AND t.declined = 0;

/*
SPRINT_2 - LEVEL_3 - EXERCISE 1
Show the name, phone number, country, date, and amount of those companies that carried out transactions with a value between 350 
and 400 euros and on any of these dates: April 29, 2015, July 20, 2018, and March 13, 2024. Order the results from the highest 
to the lowest amount.
*/

SELECT 
	c.company_name, 
	c.phone, 
    c.country, 
    DATE_FORMAT(t.timestamp,'%d-%m-%Y') AS date,
    t.amount
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE 
	DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
    AND t.amount BETWEEN 350 AND 400
ORDER BY amount DESC; 

/* 
SPRINT_2 - LEVEL_3 - EXERCISE 2

We need to optimize the allocation of resources, and it will depend on the required operational capacity. Therefore, they are asking
for information about the number of transactions carried out by the companies. However, the human resources department is demanding 
and wants a list of the companies specifying whether they have more than 400 transactions or fewer.
*/

SELECT 
	DISTINCT COUNT(t.id) AS number_of_transactions, 
	c.company_name,
CASE 
	WHEN COUNT(t.id) < 400 THEN 'less than 400'
    WHEN COUNT(t.id) > 400 THEN 'more than 400'
END AS hr_requirement
FROM company c
JOIN transaction t ON t.company_id = c.id
GROUP BY c.company_name
ORDER BY number_of_transactions ASC;   
