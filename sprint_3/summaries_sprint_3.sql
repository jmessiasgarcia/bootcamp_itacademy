-- SUMMARIES SPRINT_3

CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)
);

-- HOW TO CREATE A NEW TABLE WITH FOREIGN KEYS

CREATE TABLE orders (
    order_id int NOT NULL,
    order_number int NOT NULL,
    customer_id smallint UNSIGNED NOT NULL,
    PRIMARY KEY (order_id) );

-- HOW TO ADD FOREIGN KEY TO A EXISTING TABLE

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer_id
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

-- DROP FOREIGN KEY

ALTER TABLE orders
DROP FOREIGN KEY fk_orders_customer_id;

-- DISABLE FOREIGN KEY

SET FOREIGN_KEY_CHECKS = 0;


/*
To allow naming of a FOREIGN KEY constraint, and for defining a FOREIGN KEY constraint on multiple columns, 
use the following SQL syntax:
*/


CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID)
    REFERENCES Persons(PersonID)
);

/*
To create a FOREIGN KEY constraint on the "PersonID" column when the "Orders" table is already created, use the following SQL:
*/

ALTER TABLE Orders
ADD FOREIGN KEY (PersonID) REFERENCES Persons(PersonID);


/*
To allow naming of a FOREIGN KEY constraint, and for defining a FOREIGN KEY constraint on multiple columns, 
use the following SQL syntax:
*/

ALTER TABLE Orders
ADD CONSTRAINT FK_PersonOrder
FOREIGN KEY (PersonID) REFERENCES Persons(PersonID);

/*
To drop a FOREIGN KEY constraint, use the following SQL:
*/

ALTER TABLE Orders
DROP FOREIGN KEY FK_PersonOrder;

SHOW TABLES;
SHOW COLUMNS FROM company;
SHOW CREATE TABLE company;
SHOW CREATE TABLE transaction;

CREATE TABLE `transaction` (
  `id` varchar(255) NOT NULL,
  `credit_card_id` varchar(15) DEFAULT NULL,
  `company_id` varchar(20) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `declined` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `company` (
  `id` varchar(15) NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- RENAME TABLE
RENAME TABLE original_name TO new_name;

-- MODIFICATE TABLE, NEW COLUMN
ALTER TABLE nombre_tabla ADD nombre_campo INT NOT NULL;

-- CHANGE NAME AND TYPE OF DATA
ALTER TABLE table_name CHANGE original_name_column newname_column SMALLINT NOT NULL;

-- DELETE COLUMN
ALTER TABLE table_name DROP column name;

-- CHANGE TYPE OF DATA
ALTER TABLE table_name
MODIFY COLUMN column_name datatype;

-- TYPES OF VIEW
/*
Types of Views
Simple View: A view based on only a single table, which doesn't contain GROUP BY clause and any functions.
Complex View: A view based on multiple tables, which contain GROUP BY clause and functions.
Inline View: A view based on a subquery in FROM Clause, that subquery creates a temporary table and simplifies the complex query.
Materialized View: A view that stores the definition as well as data. It creates replicas of data by storing it physically.
*/
