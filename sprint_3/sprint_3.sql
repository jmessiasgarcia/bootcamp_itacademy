/*
-- EXERCISE 1 - LEVEL 1 - SPRINT 3
Your task is to design and create a table called "credit_card" that stores crucial details about credit cards. 
The new table must be able to uniquely identify each card and establish an appropriate relationship with the other two tables ("transaction" and "company"). After creating the table, you will need to insert the information from the document named "dades_introduir_credit". 
Remember to display the diagram and provide a brief description of it.
*/

SHOW TABLES;
DESCRIBE credit_card;

-- CREAR DATA_STRUCTURE

CREATE TABLE credit_card (
    id VARCHAR(36) PRIMARY KEY,           
    iban CHAR(34),
    pan VARCHAR(34),
    pin CHAR(4),
    cvv CHAR(3),
    expiring_date VARCHAR(10)              
);

-- CHECK DATA

SELECT * FROM credit_card;
SELECT * FROM transaction;
DESCRIBE credit_card;

-- ALTER FOREIGN KEY OF TRANSACTION, ADDING CREDIT_CARD_ID AS FOREIGN KEY.

ALTER TABLE transaction
ADD FOREIGN KEY(credit_card_id) REFERENCES credit_card(id);

-- ADD TEMPORARY COLUMN

ALTER TABLE credit_card 
ADD COLUMN expiring_date_tmp DATE;

-- CONVERT VARCHAR TO DATE USING THE FUNCTION STR_TO_DATE ON THE NEW COLUMN EXPIRING_DATE

UPDATE credit_card
SET expiring_date_tmp = STR_TO_DATE(expiring_date, '%m/%d/%y');

DESCRIBE credit_card;

-- DELETE OLD COLUMN AFTER CHANGE DATATYPE

ALTER TABLE credit_card DROP COLUMN expiring_date;

-- RENAME NEW COLUMN AND DATA TYPE TO OLD NAME

ALTER TABLE credit_card 
CHANGE COLUMN expiring_date_tmp expiring_date DATE;

-- CHECK DATA

DESCRIBE credit_card;
SELECT * FROM credit_card;

/*
EXERCISE 2 - LEVEL 1 - SPRINT 3
The Human Resources department has identified an error in the account number associated with the credit card with ID CcU-2938. 
The information that must be displayed for this record is: TR323456312213576817699999. Remember to show that the change was made.
*/

SELECT * 
FROM credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card SET iban = 'TR323456312213576817699999' WHERE id = 'CcU-2938';

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

/*
EXERCISE 3 - LEVEL 1 - SPRINT 3
In the 'transaction' table, insert a new user with the following information:
id: 108B1D1D-5B23-A76C-55EF-C568E49A99DD, credit_card_id: CcU-9999, company_id: b-9999, user_id: 9999, lat: 829.999, 
longitute: -117.999, amount: 111.11, declined: 0
*/

USE transactions;

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, TIMESTAMP,amount, declined) 
VALUES ('108B1D1D-5B23-A6C-55EF-C568E49A99DD', 'CcU-9999','b-9999', 9999, 829.999, -117.999, (CURRENT_TIMESTAMP), 111.11, 0);

INSERT INTO credit_card (id, iban, pin, cvv, expiring_date) VALUES ('CcU-9999', 'TR301950312213576817638661', '3257', '984', '2022-10-30');

INSERT INTO company (id, company_name, phone, email, country, website) VALUES ('b-9999', 'Mondego Incorporated', '06 84 33 15 97', 'mondego@hotmail.net', 'Rio de Janeiro', 'https://cnn.com/site');

SELECT *
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE user_id = 9999;

SELECT * 
FROM transaction
WHERE user_id = 9999;

/*
EXERCISE 4 - LEVEL 1 - SPRINT 3
Human Resources has requested that you remove the "pan" column from the credit_card table. Remember to show the change made.
*/

ALTER TABLE credit_card DROP pan;
SHOW COLUMNS FROM credit_card;

/*
EXERCISE 1 - LEVEL 2 - SPRINT 3
Delete from the transaction table the record with ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD from the database.
*/

SELECT * 
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

/*
EXERCISE 2 - LEVEL 2 - SPRINT 3
The marketing department wants access to specific information to perform effective analysis and strategies. 
It has been requested to create a view that provides key details about companies and their transactions. 
You will need to create a view called VistaMarketing that contains the following information: Company name, Contact phone number,
Country of residence, Average purchase made by each company, Display the created view, ordering the data from highest to lowest 
average purchase.
*/

-- TABLE REQUIRED BY MARKETINTG TEAM

SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount),2) AS avg_sales
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY  c.company_name, c.phone, c.country
ORDER BY avg_sales DESC;

-- REQUIRED CREATE VIEW

CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount),2) AS avg_sales
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY  c.company_name, c.phone, c.country
ORDER BY avg_sales DESC;

SELECT *
FROM transactions.vistamarketing;

-- CHECK REQUIRED VIEW

SELECT * 
FROM transactions.vistamarketing;

/*
EXERCISE 3 - LEVEL 2 - SPRINT 3
Filter the VistaMarketing view to show only the companies whose country of residence is 'Germany'
*/

SELECT *
FROM transactions.vistamarketing
WHERE country = 'Germany';

/*
EXERCISE 1 - LEVEL 3 - SPRINT 3
Next week you will have a new meeting with the marketing managers. A colleague from your team made modifications to the database but 
doesn’t remember how they did it. They ask you to help them document the commands executed to obtain the following diagram:
*/

-- CHECK QUERIES USED TO CREATE TABLES

SHOW CREATE TABLE transaction;
SHOW CREATE TABLE company;
SHOW CREATE TABLE credit_card;
SELECT * FROM user;

-- CHANGE DATATYPE OF FOREIGN KEY, COLUMN USER.ID

ALTER TABLE user
MODIFY COLUMN id INT;

-- CREATE USERS TABLE FOREIGN KEY 

ALTER TABLE transaction
ADD FOREIGN KEY(user_id) REFERENCES user(id);

-- CHANGE TABLE NAME

RENAME TABLE user TO data_user;

-- DELETE WEBSITE COLUMN FROM COMPANY TABLE

SELECT * FROM company;
ALTER TABLE company DROP website;
SHOW COLUMNS FROM company;

-- CHANGE DATATYPE OF TRANSACTION.ID TO VARCHAR(255)

ALTER TABLE transaction
MODIFY COLUMN id VARCHAR(255);

-- CHANGE DATATYPE OF TRANSACTION.CREDIT_CARD_ID TO VARCHAR(255)

ALTER TABLE transaction
MODIFY COLUMN credit_card_id VARCHAR(255);

-- CHANGE DATAYPE OF CREDIT_CARD.ID TO VARCHAR(20)

ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20);

-- CHANGE DATAYPE OF CREDIT_CARD.IBAN TO VARCHAR(50)

ALTER TABLE credit_card
MODIFY COLUMN iban VARCHAR(50);

-- CHANGE DATAYPE OF CREDIT_CARD.PIN TO VARCHAR(04)

ALTER TABLE credit_card
MODIFY COLUMN pin VARCHAR(04);

-- CHANGE DATAYPE OF CREDIT_CARD.CVV TO INT

ALTER TABLE credit_card
MODIFY COLUMN cvv INT;

-- CHANGE DATAYPE OF EXPIRING_DATE.CREDIT_CARD TO VARCHAR(20)

ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR(20);

-- ADD NEW COLUMN FECHA_ACTUAL DATE TO CREDIT_CARD TABLE

ALTER TABLE credit_card 
ADD COLUMN fecha_actual DATE;

UPDATE credit_card
SET fecha_actual = CURDATE();

SELECT * 
FROM credit_card
LIMIT 3;

DESCRIBE data_user;
DESCRIBE transactions;
DESCRIBE company;
DESCRIBE credit_card;

/*
EXERCISE 2 - LEVEL 3 - SPRINT 3
The company also asks you to create a view called 'InformeTecnico' that contains the following information:

Transaction ID
User's first name
User's last name
IBAN of the credit card used
Name of the company where the transaction was made

Make sure to include relevant information from the tables you know and use aliases to rename columns as needed.
Display the results of the view, ordering them in descending order based on the Transaction ID.

*/

-- VIEW REQUIRED

CREATE VIEW InformeTecnico AS 
SELECT t.id, du.name AS first_name, du.surname AS last_name, cc.iban, c.company_name
FROM transaction t 
JOIN company c ON t.company_id = c.id
JOIN data_user du ON t.user_id = du.id
JOIN credit_card cc ON t.credit_card_id = cc.id
ORDER BY t.id DESC;

SELECT *
FROM transactions.InformeTecnico;
