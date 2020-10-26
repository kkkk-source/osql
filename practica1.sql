rem PRACTICA 1: CURSORES Y EXCEPCIONES
rem
rem  Cristian Camilo Serna Betancur
rem     Elver Andres Arroyave
rem 


rem
rem ** 1 ***********************
rem 
DECLARE
    productor VARCHAR2(450);
    producto  VARCHAR2(450);
    venta     VARCHAR2(450);
BEGIN
    productor := 'CREATE TABLE productor ('                               ||
                    'id         INT PRIMARY KEY,'                         ||
                    'nombre     VARCHAR(50) NOT NULL,'                    ||
                    'direccion  VARCHAR(95)'                              ||
                ')';
    producto  := 'CREATE TABLE producto ('                                ||
                    'id            INT PRIMARY KEY,'                      ||
                    'nombre        VARCHAR(50) NOT NULL,'                 ||
                    'descripcion   VARCHAR(280),'                         ||
                    'productor_id  INT NOT NULL,'                         ||
                    'cantidad      NUMBER(10) NOT NULL,'                  ||
                    'precio        DECIMAL(10, 2) NOT NULL,'              ||
                    'FOREIGN KEY (productor_id) REFERENCES productor(id)' ||
                ')';
    venta     := 'CREATE TABLE venta  ('                                  ||
                    'id           INT PRIMARY KEY,'                       ||
                    'producto_id  INT NOT NULL,'                          ||
                    'fecha        DATE,'                                  ||
                    'cantidad     NUMBER(10) NOT NULL,'                   ||
                    'FOREIGN KEY (producto_id) REFERENCES producto(id)'   ||
                ')';

    EXECUTE IMMEDIATE productor;
    EXECUTE IMMEDIATE producto;
    EXECUTE IMMEDIATE venta;
END;
/

rem 
rem ** 2 ***********************
rem 
BEGIN
    INSERT INTO productor (id, nombre, direccion) VALUES (1, 'Brody', 'Ap #538-1194 Molestie Rd.');
    INSERT INTO productor (id, nombre, direccion) VALUES (2, 'Abdul', '8749 Dictum St.');
    INSERT INTO productor (id, nombre, direccion) VALUES (3, 'Jasper', 'Ap #208-2865 Blandit Rd.');

    INSERT INTO producto (id, nombre, descripcion, productor_id, cantidad, precio)
        VALUES (1, 'elementum', 'non massa non ante bibendum ullamcorper.', 1, 68, 58488);
    INSERT INTO producto (id, nombre, descripcion, productor_id, cantidad, precio)
        VALUES (2, 'ante', 'nisi a odio semper cursus. Integer mollis.', 1, 70, 89156);
    INSERT INTO producto (id, nombre, descripcion, productor_id, cantidad, precio)
        VALUES (3, 'metus', 'non, sollicitudin a, malesuada id, erat.', 2, 59, 19332);
    INSERT INTO producto (id, nombre, descripcion, productor_id, cantidad, precio)
        VALUES (4, 'ac', 'eget nisi dictum augue malesuada malesuada.', 2, 40, '50769');
    INSERT INTO producto (id, nombre, descripcion, productor_id, cantidad, precio)
        VALUES (5, 'sit', 'Suspendisse eleifend. Cras sed leo.', 3, 27, 64884);
    INSERT INTO producto (id, nombre, descripcion, productor_id, cantidad, precio)
        VALUES (6, 'amet', 'dolor, nonummy ac, feugiat non, lobortis quis, pede.', 3, 40, 44442);

    INSERT INTO venta (id, producto_id, fecha, cantidad) VALUES (1, 1, TO_DATE('12/09/2020', 'DD/MM/YYYY'), 9);
    INSERT INTO venta (id, producto_id, fecha, cantidad) VALUES (2, 2, TO_DATE('14/08/2020', 'DD/MM/YYYY'), 8);
    INSERT INTO venta (id, producto_id, fecha, cantidad) VALUES (3, 3, TO_DATE('13/12/2019', 'DD/MM/YYYY'), 10);
    INSERT INTO venta (id, producto_id, fecha, cantidad) VALUES (4, 4, TO_DATE('15/12/2019', 'DD/MM/YYYY'), 5);
END;
/

rem 
rem ** 3 ***********************
rem 
DECLARE
    CURSOR products IS
    SELECT productor.nombre, COUNT(producto.nombre)
    FROM productor INNER JOIN producto ON productor.id = productor_id
    GROUP BY productor.nombre;

    amount producto.cantidad%TYPE;
    owner productor.nombre%TYPE;
BEGIN
    OPEN products;
    LOOP
        FETCH products INTO owner, amount;
        EXIT WHEN products%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('productor: ' || owner || ' cantidad producida: ' || amount );
    END LOOP;
    CLOSE products;
END;
/

rem 
rem ** 4 ***********************
rem 
DECLARE
    CURSOR products IS
    SELECT nombre FROM producto ORDER BY id;

    name producto.nombre%TYPE;
BEGIN
    OPEN products;
    LOOP
        FETCH products INTO name;
        EXIT WHEN products%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(name);
    END LOOP;
    CLOSE products;
END;
/

rem 
rem ** 5 ***********************
rem 
DECLARE
    CURSOR products IS
    SELECT productor.nombre AS owner, COUNT(producto.nombre) AS amount
    FROM productor INNER JOIN producto ON productor.id = productor_id
    GROUP BY productor.nombre;
BEGIN
    FOR product IN products LOOP
        DBMS_OUTPUT.PUT_LINE('productor: ' || product.owner || ' cantidad producida: ' || product.amount );
    END LOOP;
END;
/

rem 
rem ** 6 ***********************
rem 
BEGIN
    FOR products IN
        (SELECT nombre FROM producto ORDER BY id)
    LOOP
        DBMS_OUTPUT.PUT_LINE(products.nombre);
    END LOOP;
END;
/

rem 
rem ** 7 ***********************
rem 
DECLARE
    total NUMBER;
    CURSOR productores IS
    SELECT id, nombre FROM productor;
BEGIN
    FOR productor IN productores LOOP
        DBMS_OUTPUT.PUT_LINE('productor: ' || productor.nombre);

        total := 0;
        FOR producto IN
            (SELECT nombre, precio FROM producto WHERE productor.id = productor_id)
        LOOP
            DBMS_OUTPUT.PUT_LINE(total + 1 || '] producto: ' || producto.nombre || ' - precio: ' || producto.precio );
            total := total + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('total: ' || total);
        DBMS_OUTPUT.PUT_LINE('--------------------');
    END LOOP;
END;
/

rem 
rem ** 8 ***********************
rem 
DECLARE
    incr NUMBER;
    CURSOR productos IS SELECT * FROM producto
    FOR UPDATE;
BEGIN
    FOR product IN productos LOOP
        IF product.cantidad < 10 THEN
            incr := product.precio * 0.05;
            UPDATE producto SET precio = precio + incr
                WHERE CURRENT OF productos;
        END IF;
    END LOOP;
END;
/

rem 
rem ** 9 ***********************
rem
rem 
rem * 5 *
rem 
DECLARE
    CURSOR products IS
    SELECT productor.nombre AS owner, COUNT(producto.nombre) AS amount
    FROM productor INNER JOIN producto ON productor.id = productor_id
    GROUP BY productor.nombre;
BEGIN
    FOR product IN products LOOP
        DBMS_OUTPUT.PUT_LINE('productor: ' || product.owner || ' cantidad producida: ' || product.amount );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('data not found: ' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: ' || SQLERRM);
END;
/

rem 
rem * 6 *
rem 
BEGIN
    FOR products IN
        (SELECT nombre FROM producto ORDER BY id)
    LOOP
        DBMS_OUTPUT.PUT_LINE(products.nombre);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('data not found: ' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: ' || SQLERRM);
END;
/
rem 
rem * 7 *
BEGIN
    FOR products IN
        (SELECT nombre FROM producto ORDER BY id)
    LOOP
        DBMS_OUTPUT.PUT_LINE(products.nombre);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('data not found: ' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: ' || SQLERRM);
END;
/
rem 
rem * 8 *
DECLARE
    incr NUMBER;
    TOO_HIGH EXCEPTION;
    CURSOR productos IS SELECT * FROM producto
    FOR UPDATE;
BEGIN
    FOR product IN productos LOOP
        IF product.cantidad < 10 THEN
            incr := product.precio * 0.05;
            IF product.precio + incr > 1000000 THEN
                RAISE TOO_HIGH;
            END IF;
            UPDATE producto SET precio = precio + incr
                WHERE CURRENT OF productos;
        END IF;
    END LOOP;
EXCEPTION
    WHEN TOO_HIGH THEN
        DBMS_OUTPUT.PUT_LINE('El precio ahora es excesivamente alto.');
END;
/
