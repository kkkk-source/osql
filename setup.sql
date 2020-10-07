rem ***************************************************************************
rem Version 0.1
rem This script creates the SQL-model. 
rem ***************************************************************************
rem 

rem [!] The INT value has a stogare of 4 Bytes.
rem [!] The lengths were taken from the stackoverflow thread:
rem  +  List of standard lengths for database fields.
rem

CREATE TABLE customer (
    id         INT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    address    VARCHAR(95),
    telephone  VARCHAR(15),
    city       VARCHAR(15)
);

CREATE TABLE product (
    id           INT PRIMARY KEY,
    description  VARCHAR(280),
    price        DECIMAL(10, 2) NOT NULL
);

CREATE TABLE sale (
    id           INT PRIMARY KEY,
    amount       NUMBER(10) NOT NULL,
    customer_id  INT NOT NULL,
    product_id   INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (product_id)  REFERENCES product(id)
);

rem
rem References:
rem [stackoverflow.com/questions/20958/list-of-standard-lengths-for-database-fields]
rem [tutorialspoint.com/which-mysql-type-is-most-suitable-for-price-column]
rem
