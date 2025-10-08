
CREATE DATABASE EuroCommerce;
USE EuroCommerce;

-- TABLES CREATION

CREATE TABLE products (
    id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price VARCHAR(10),
    colour VARCHAR(20),
    weight DECIMAL(10,2),
    warehouse_id VARCHAR(10)

);

CREATE TABLE credit_cards (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(10),
    iban VARCHAR(50),
    pan VARCHAR(50),
    pin VARCHAR(10),
    track_1 VARCHAR(50),
	track_2 VARCHAR(50),
    expiring_date VARCHAR(30)
);

CREATE TABLE companies (
	id VARCHAR(50) PRIMARY KEY NOT NULL,
    company_name VARCHAR(40),
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    country VARCHAR(40),
    website VARCHAR(100)
);

CREATE TABLE european_users (
	id VARCHAR(50) PRIMARY KEY NOT NULL,
    name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR (100),
	email VARCHAR (100) UNIQUE,
	birth_date VARCHAR (100),
	country VARCHAR (40),
	city VARCHAR (40),
	postal_code VARCHAR (20),
	address VARCHAR (150)
);

CREATE TABLE american_users (
	id VARCHAR(50) PRIMARY KEY NOT NULL,
    name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR (100),
	email VARCHAR (100) UNIQUE,
	birth_date VARCHAR (100),
	country VARCHAR (40),
	city VARCHAR (40),
	postal_code VARCHAR (20),
	address VARCHAR (150)
);

CREATE TABLE transactions (
    id VARCHAR(100) PRIMARY KEY NOT NULL,
    card_id VARCHAR(50),
    business_id VARCHAR(50),
    timestamp DATETIME,
    amount DECIMAL(10,2),
    declined BOOLEAN,
    product_ids VARCHAR(100),
    user_id VARCHAR(50),
    lat FLOAT,
    longitude FLOAT,
    CONSTRAINT fk_credit_card_id
        FOREIGN KEY (card_id) REFERENCES credit_cards(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_business_id
        FOREIGN KEY (business_id) REFERENCES companies(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_european_users
        FOREIGN KEY (user_id) REFERENCES european_users(id)
        ON DELETE CASCADE
);

-- CHECKING COLUMNS

SHOW COLUMNS FROM european_users;
SHOW COLUMNS FROM american_users;
SHOW COLUMNS FROM transactions;
SHOW COLUMNS FROM companies;
SHOW COLUMNS FROM credit_cards;
SHOW COLUMNS FROM products;

-- LOADING DATA
-- TABLE PRODUCTS

LOAD DATA LOCAL INFILE '/Users/josemessiasferreira/Documents/sprint_4_data/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- TABLE CREDIT_CARDS

LOAD DATA LOCAL INFILE '/Users/josemessiasferreira/Documents/sprint_4_data/credit_cards.csv'
INTO TABLE credit_cards 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- TABLE COMPANIES

LOAD DATA LOCAL INFILE '/Users/josemessiasferreira/Documents/sprint_4_data/companies.csv'
INTO TABLE companies 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;


-- TABLE EUROPEAN_USERS

LOAD DATA LOCAL INFILE '/Users/josemessiasferreira/Documents/sprint_4_data/european_users.csv'
INTO TABLE european_users 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- ADD COLUMN WITH CONTINENT NAME

ALTER TABLE european_users
ADD COLUMN continent VARCHAR(55) NOT NULL DEFAULT 'Europe';


-- TABLE AMERICAN_USERS

LOAD DATA LOCAL INFILE '/Users/josemessiasferreira/Documents/sprint_4_data/american_users.csv'
INTO TABLE american_users 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- ADD COLUMN WITH THE CONTINENT NAME

ALTER TABLE american_users
ADD COLUMN continent VARCHAR(55) NOT NULL DEFAULT 'America';

-- BRIDGE TABLE CREATION 

CREATE TABLE transaction_products (
    transaction_id VARCHAR(100),
    product_id VARCHAR(10),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE
);

-- SWITCH TEMPORARY OFF FOREIGN KEY TO AVOID ERROR 1452: PARENT TABLES ARE MISSING FOR THE FOREIGN KEYS IN TRANSACTIONS

SET FOREIGN_KEY_CHECKS = 0; 

-- LOAD DATA TRANSACTIONS TABLE
LOAD DATA LOCAL INFILE '/Users/josemessiasferreira/Documents/sprint_4_data/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, card_id, business_id, timestamp, amount, declined, product_ids, user_id, lat, longitude);

-- ON FOREIGN KEYS

SET FOREIGN_KEY_CHECKS = 1;

-- UNINION ALL EUROPEAN_USERS AND AMERICAN_USERS TABLES

CREATE TABLE data_users AS
SELECT * FROM european_users
UNION ALL
SELECT * FROM american_users;

-- ADD A PRIMARY KEY TO THE NEW TABLE DATA_USERS

ALTER TABLE data_users
ADD PRIMARY KEY (id);

-- ADD A FOREIGN KEY IN THE TABLE TRANSACTIONS

ALTER TABLE transactions
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id) REFERENCES data_users(id);

-- CHEKING NEW TABLE 

SELECT * FROM data_users;

-- DELETE OLD TABLES BUT TO AVOID FK ERRORS, SWTICH TO OFF

SET FOREIGN_KEY_CHECKS = 0;

-- DELETE TABLES

DROP TABLE american_users;
DROP TABLE european_users;

-- SWITCH TO ON FK

SET FOREIGN_KEY_CHECKS = 1;

-- CHECK NEW TABLE

SELECT * FROM data_users;

-- ADD THE FOREIGN KEYS TO THE BRIDGE TABLE
-- ON A BRIDGE TABLE WE ALWAYS HAVE JUST FOREIGN KEYS BECAUSE IS A MANY TO MANY RELATION

ALTER TABLE transaction_products
ADD CONSTRAINT fk_tp_transactions
FOREIGN KEY (transaction_id) REFERENCES transactions(id)
ON DELETE CASCADE;

ALTER TABLE transaction_products
ADD CONSTRAINT fk_tp_products
FOREIGN KEY (product_id) REFERENCES products(id)
ON DELETE CASCADE;

-- CHANGE THE DATATYPE OF THE FIELD PRODUCT_IDS TO JSON USING THE CONCAT FUNCTION

UPDATE transactions
SET product_ids = CONCAT('[', REPLACE(product_ids, ' ', ''), ']');

/*
USING JSON (JAVA SCRIPT OBJECT NOTATION) TO EXTRACT THE VALUES IN THE COLUMNS PRODUCTS_IDS
AND PAST THEM TO THE BRIDGE TABLE transaction_products.
*/

INSERT INTO transaction_products (transaction_id, product_id)
SELECT 
    t.id AS transaction_id,
    j.product_id
FROM transactions t
JOIN JSON_TABLE(
    t.product_ids,
    '$[*]' COLUMNS (
        product_id INT PATH '$'
    )
) AS j;

-- CHECK TRANSACTION_PRODUCTS TABLE

SELECT * FROM transaction_products;

-- TABLE PRODUCTS TRANSFORMATIONS

DESCRIBE products;
SELECT * 
FROM products;

-- FIELD PRICE TO DECIMAL (10,2)

UPDATE products
SET price = REPLACE(price, '$', '');

ALTER TABLE products
MODIFY price DECIMAL(10,2);

-- FIRST LETTER UPPER OF PRODUCT NAME 

UPDATE products
SET product_name = CONCAT(
    UPPER(LEFT(product_name, 1)),
    LOWER(SUBSTRING(product_name, 2))
);

SELECT * FROM products;

-- TABLE DATA_USERS TRANSFORMATIONS

SELECT * FROM data_users;
DESCRIBE data_users;

-- CHANGE DATYPE FROM BIRTH_DATE FIELD TO DATE

UPDATE data_users
SET birth_date = STR_TO_DATE(birth_date, '%b %d, %Y');

ALTER TABLE data_users
MODIFY birth_date DATE;

SELECT * FROM data_users;
