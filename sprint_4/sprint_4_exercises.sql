USE EuroCommerce;
/*
Exercise 1 - Sprint 4 - Level 1
Create a subquery that shows all users with more than 80 transactions using at least 2 tables.
*/

SELECT 
    du.id,
    CONCAT(name, ' ', surname) AS full_name,
    (SELECT COUNT(*) 
     FROM transactions t 
     WHERE t.user_id = du.id) AS number_of_transactions -- SUBQUERY WITH THE NUMBER_OF_TRANSACTIONS
FROM data_users du
WHERE (SELECT COUNT(*) 
       FROM transactions t
       WHERE t.user_id = du.id) > 80 -- SUBQUERY TO FIND THE NUMBER OF THE TRANSACTION GREATER THAN 80
ORDER BY number_of_transactions;

SELECT 
    du.id,
    CONCAT(du.name, ' ', du.surname) AS full_name
FROM data_users du
WHERE (
    SELECT COUNT(*) 
    FROM transactions t
    WHERE t.user_id = du.id) > 80;


/*
Exercise 2 - Sprint 4 - Level 1
Show the average amount per IBAN of the credit cards for the company Donec Ltd, using at least 2 tables.
*/

SELECT 
    ROUND(AVG(t.amount),2) AS avg_sales,
    cc.iban,
    co.company_name
FROM transactions t
JOIN credit_cards cc on t.card_id = cc.id
JOIN companies co ON t.business_id = co.id
WHERE co.company_name = 'Donec Ltd'
GROUP BY cc.iban;

/*
Exercise 1 - Sprint 4 - Level 2
Create a new table that reflects the status of credit cards based on: if the last three transactions have been declined, 
then it is inactive; if at least one is not declined, then it is active. Based on this table, answer:
*/

CREATE TABLE card_status AS
SELECT
    card_id,
    CASE
        WHEN SUM(CASE WHEN number_of_row <= 3 AND declined THEN 1 ELSE 0 END) = 3 THEN 'inactive'
        ELSE 'active'
    END AS status_card
FROM (
	SELECT 
        card_id,
        declined,
        ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC, id DESC) AS number_of_row
    FROM transactions) t
GROUP BY card_id;

/*
How many cards are active?
*/
SELECT * FROM card_status;

SELECT COUNT(*) AS active_cards
FROM card_status
WHERE status_card = 'Active';

/*
Exercise 1 - Sprint 4 - Level 3
Create a table that allows us to join the data from the new products.csv file with the database, 
taking into account that transaction contains product_ids. Generate the following query:

We need to know the number of times each product has been sold.
*/

SELECT 
    p.id,
    p.product_name,
    COUNT(DISTINCT t.id) AS total_sales
FROM transaction_products tp
JOIN products p ON tp.product_id = p.id
JOIN transactions t ON tp.transaction_id = t.id
WHERE t.declined = 0
GROUP BY p.id, p.product_name
ORDER BY p.product_name;

/*
THE BRIDGE TABLE ALREADY ESTABLISHES THE RELATIONSHIP BETWEEN PRODUCTS AND TRANSACTIONS.
I JUST ADDED THE INFORMATION USING JOINS AND COUNT TO GET THE TOTAL SALES.
*/


