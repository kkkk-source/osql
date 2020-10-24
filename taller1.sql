
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


rem ***************************************************************************
rem Version 0.1
rem This script seeds the tables of the SQL-model with dummy/fake information. 
rem ***************************************************************************
rem 

INSERT INTO customer (id, name, address, telephone, city) VALUES (1,'Jolene','P.O. Box 404, 3307 Erat, Road','16170104 6698','Bressoux');
INSERT INTO customer (id, name, address, telephone, city) VALUES (2,'Moana','P.O. Box 809, 8907 Rutrum St.','16670924 2066','Kearney');
INSERT INTO customer (id, name, address, telephone, city) VALUES (3,'Darrel','Ap #562-5085 Arcu. St.','16180613 2534','Medellin');
INSERT INTO customer (id, name, address, telephone, city) VALUES (4,'Jakeem','5592 Non, Av.','16570627 3017','Bogota');
INSERT INTO customer (id, name, address, telephone, city) VALUES (5,'Jael','233-8513 Ut Ave','16620925 9479','Rockville');
INSERT INTO customer (id, name, address, telephone, city) VALUES (6,'Reece','5498 Morbi Rd.','16290927 0700','Tunja');
INSERT INTO customer (id, name, address, telephone, city) VALUES (7,'Melvin','1004 Scelerisque Street','16151106 2885','Hattiesburg');
INSERT INTO customer (id, name, address, telephone, city) VALUES (8,'Francis','P.O. Box 454, 4702 Ligula. Avenue','16950301 0010','Chicago');
INSERT INTO customer (id, name, address, telephone, city) VALUES (9,'Nigel','886-9868 Curae; St.','16541020 1114','Cali');
INSERT INTO customer (id, name, address, telephone, city) VALUES (10,'Oprah','Ap #256-4830 Tristique Road','16210530 9864','Eckville');

INSERT INTO product (id, description, price) VALUES (1,'Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas',9.17);
INSERT INTO product (id, description, price) VALUES (2,'Phasellus vitae mauris sit amet lorem semper auctor. Mauris vel',73.98);
INSERT INTO product (id, description, price) VALUES (3,'laoreet posuere, enim nisl elementum purus, accumsan interdum libero dui',62.29);
INSERT INTO product (id, description, price) VALUES (4,'facilisis vitae, orci. Phasellus dapibus quam quis diam. Pellentesque habitant',87.66);
INSERT INTO product (id, description, price) VALUES (5,'Etiam bibendum fermentum metus. Aenean sed pede nec ante blandit',2.95);
INSERT INTO product (id, description, price) VALUES (6,'sit amet massa. Quisque porttitor eros nec tellus. Nunc lectus',97.04);
INSERT INTO product (id, description, price) VALUES (7,'inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In',95.20);
INSERT INTO product (id, description, price) VALUES (8,'Donec porttitor tellus non magna. Nam ligula elit, pretium et,',39.28);
INSERT INTO product (id, description, price) VALUES (9,'euismod mauris eu elit. Nulla facilisi. Sed neque. Sed eget',84.72);
INSERT INTO product (id, description, price) VALUES (10,'odio. Nam interdum enim non nisi. Aenean eget metus. In',93.59);
INSERT INTO product (id, description, price) VALUES (11,'enim. Mauris quis turpis vitae purus gravida sagittis. Duis gravida.',1500.00);
INSERT INTO product (id, description, price) VALUES (12,'Proin velit. Sed malesuada augue ut lacus. Nulla tincidunt, neque',55.00);
INSERT INTO product (id, description, price) VALUES (13,'diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat.',56.95);
INSERT INTO product (id, description, price) VALUES (14,'facilisis, magna tellus faucibus leo, in lobortis tellus justo sit',31.44);
INSERT INTO product (id, description, price) VALUES (15,'eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula.',48.86);
INSERT INTO product (id, description, price) VALUES (16,'in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla',76.86);
INSERT INTO product (id, description, price) VALUES (17,'lacinia at, iaculis quis, pede. Praesent eu dui. Cum sociis',30.29);
INSERT INTO product (id, description, price) VALUES (18,'nec tempus scelerisque, lorem ipsum sodales purus, in molestie tortor',5.29);
INSERT INTO product (id, description, price) VALUES (19,'In lorem. Donec elementum, lorem ut aliquam iaculis, lacus pede',88.19);
INSERT INTO product (id, description, price) VALUES (20,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet,',8.55);

INSERT INTO sale (id, amount, customer_id, product_id) VALUES (1,481,10,5);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (2,10,2,2);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (3,87,6,7);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (4,32,6,10);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (5,403,8,16);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (6,62,5,14);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (7,327,10,19);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (8,71,8,2);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (9,497,9,7);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (10,201,7,14);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (11,22,6,9);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (12,139,2,3);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (13,217,2,11);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (14,244,2,5);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (15,401,4,5);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (16,289,7,15);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (17,339,2,5);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (18,281,9,18);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (19,491,7,14);
INSERT INTO sale (id, amount, customer_id, product_id) VALUES (20,10,6,13);

rem
rem References:
rem This dummy information was taken from [https://www.generatedata.com]
rem


rem [1]------------------------------------------------------------------------
rem
SELECT 
    id 
FROM 
    customer 
WHERE 
    city = 'Cali';

rem
rem [2]------------------------------------------------------------------------
rem
SELECT 
    id, 
    description 
FROM 
    product 
WHERE 
    price < 1500;

rem
rem [3]------------------------------------------------------------------------
rem
SELECT 
    c.id, 
    c.name, 
    s.amount, 
    p.description
FROM 
    product p INNER JOIN sale s ON p.id = s.product_id 
    INNER JOIN customer c ON s.customer_id = c.id 
WHERE 
    s.amount > 10;

rem
rem [4]------------------------------------------------------------------------
rem
SELECT 
    c.id, 
    c.name 
FROM 
    customer c 
WHERE 
    c.id NOT IN (SELECT s.customer_id FROM sale s);

rem
rem [5]------------------------------------------------------------------------
rem
SELECT 
    customer_id, 
    name 
FROM (
    SELECT 
        customer_id, 
        c.name, 
        COUNT(product_id)
    FROM 
        sale s INNER JOIN customer c 
        ON s.customer_id = c.id 
    GROUP BY 
        customer_id, 
        c.name 
    HAVING 
        COUNT(product_id) IN (SELECT COUNT(id) FROM product)
);

rem
rem [6]------------------------------------------------------------------------
rem
SELECT
    c.id,
    c.name,
    SUM(amount)
FROM
    sale s inner join customer c on s.customer_id = c.id
GROUP BY
    c.id,
    c.name;

rem
rem [7]------------------------------------------------------------------------
rem
SELECT 
    id 
FROM 
    product 
WHERE 
    id NOT IN (
        SELECT 
            product_id 
        FROM 
            customer c INNER JOIN sale s ON c.id = s.customer_id
        WHERE c.city = 'Tunja'
    );

rem
rem [8]------------------------------------------------------------------------
rem
SELECT 
    id 
FROM 
    product 
WHERE 
    id IN (
        SELECT 
            product_id 
        FROM 
            customer c INNER JOIN sale s ON c.id = s.customer_id 
            INNER JOIN product p ON p.id = s.product_id 
        WHERE c.city = 'Medellin'
    ) 
    AND 
    id IN (
        SELECT 
            product_id 
        FROM 
            customer c INNER JOIN sale s ON c.id = s.customer_id 
            INNER JOIN product p ON p.id = s.product_id 
        WHERE c.city = 'Bogota'
    );

rem
rem [9]------------------------------------------------------------------------
rem
SELECT 
    city 
FROM (
    SELECT 
        city, 
        COUNT(product_id) 
    FROM 
        customer c INNER JOIN sale s ON c.id = s.customer_id 
        INNER JOIN product p ON p.id = s.product_id
    GROUP BY 
        city 
    HAVING 
        COUNT(product_id) IN (SELECT COUNT(id) FROM product)
    );

rem
rem [END]
rem
