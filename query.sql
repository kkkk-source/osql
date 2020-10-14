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
    customer_id, 
    SUM(amount)
FROM 
    sale 
GROUP BY 
    customer_id;

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
        COUNT(product_id) IN (SELECT COUNT(id) FROM sale)
    );

rem
rem [END]
rem
