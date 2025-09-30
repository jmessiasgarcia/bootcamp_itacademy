
CREATE DATABASE Eurocommerce;

USE EuroCommerce;

-- TABLES CREATION, DATATYPES AND PRIMARY KEYS
DROP TABLE products;
CREATE TABLE products (
    id VARCHAR (50) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price VARCHAR(50),
    colour VARCHAR(20),
    weight DECIMAL(10,2),
    warehouse_id VARCHAR (10)

);

CREATE TABLE credit_cards (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(10),
    iban VARCHAR(255),
    pan VARCHAR(50),
    pin VARCHAR(10),
    track_1 VARCHAR(255),
	track_2 VARCHAR(255),
    expiring_date VARCHAR(50)
);

CREATE TABLE companies (
	id VARCHAR(50) PRIMARY KEY NOT NULL,
    company_name VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(255) UNIQUE,
    country VARCHAR(255),
    website VARCHAR(255)
);


CREATE TABLE european_users (
	id VARCHAR(50) PRIMARY KEY NOT NULL,
    name VARCHAR(255),
	surname VARCHAR(255),
	phone VARCHAR (100),
	email VARCHAR (255) UNIQUE,
	birth_date VARCHAR (100),
	country VARCHAR (255),
	city VARCHAR (255),
	postal_code VARCHAR (100),
	address VARCHAR (255)
);


CREATE TABLE transactions (
    id VARCHAR(255) PRIMARY KEY NOT NULL,
	card_id VARCHAR(50),
    businnes_id VARCHAR(50),
	timestamp VARCHAR(255),
	amount DECIMAL(10, 2),
	declined TINYINT,
	product_ids VARCHAR(50),
	user_id VARCHAR(50),
	lat FLOAT,
	longitute FLOAT,
    CONSTRAINT fk_credit_card_id
        FOREIGN KEY (card_id) REFERENCES credit_cards(id)
        ON DELETE CASCADE, -- IF A ROW IN THAT TABLE IS DELETE THE ROW WILL ALSO BE DELETED IN THE CHILD TABLES
    CONSTRAINT fk_businnes_id
        FOREIGN KEY (businnes_id) REFERENCES companies(id)
		ON DELETE CASCADE,
    CONSTRAINT fk_products_id
        FOREIGN KEY (product_ids) REFERENCES products(id)
		ON DELETE CASCADE,
    CONSTRAINT fk_european_users
        FOREIGN KEY (user_id) REFERENCES european_users(id)
        ON DELETE CASCADE

);

SHOW TABLES FROM EuroCommerce;

-- TABLE PRODUCTS
LOAD DATA LOCAL
INFILE '/Users/josemessiasferreira/Documents/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

SELECT * FROM products;

-- TABLE CREDIT_CARDS
LOAD DATA LOCAL
INFILE '/Users/josemessiasferreira/Documents/credit_cards.csv'
INTO TABLE credit_cards 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

SELECT * FROM credit_cards;


-- TABLE COMPANIES
LOAD DATA LOCAL
INFILE '/Users/josemessiasferreira/Documents/companies.csv'
INTO TABLE companies 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

SELECT * FROM companies;

-- TABLE EUROPEAN_USERS
LOAD DATA LOCAL
INFILE '/Users/josemessiasferreira/Documents/european_users.csv'
INTO TABLE european_users 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

SELECT * FROM european_users;

-- TABLE TRANSACTIONS
LOAD DATA LOCAL
INFILE '/Users/josemessiasferreira/Downloads/transactions.csv'
INTO TABLE transactions 
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM transactions;

DROP TABLE transactions;

SHOW WARNINGS;
/*
Exercise 1
Create a subquery that shows all users with more than 80 transactions using at least 2 tables.
*/

/*
Exercise 2
Show the average amount per IBAN of the credit cards in the company Donec Ltd, using at least 2 tables.
*/

/*
Level 2
Create a new table that reflects the status of credit cards based on whether the last three transactions were declined, and generate the following query:

Exercise 1
How many cards are active?
*/

/*
Level 3
Create a table with which we can join the data from the new file products.csv with the created database, taking into account that from transactions you have product_ids. Generate the following query:

Exercise 1
We need to know the number of times each product has been sold.

*/
