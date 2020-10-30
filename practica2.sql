CREATE TABLE cliente (
    ced NUMBER(8) PRIMARY KEY,
    nom VARCHAR2(10) NOT NULL
);

CREATE TABLE empleo (
    ced           NUMBER(8) REFERENCES cliente,
    nit_empresa   INTEGER,
    valor_mensual NUMBER(6) NOT NULL,
    PRIMARY KEY (ced, nit_empresa)
);

CREATE TABLE gasto (
    cod_gasto     NUMBER(8) PRIMARY KEY,
    ced           NUMBER(8) REFERENCES cliente,
    valor_mensual NUMBER(6),
    des_gasto     VARCHAr2(10)
);

INSERT INTO cliente (ced, nom) VALUES (1, 'Brody');
INSERT INTO cliente (ced, nom) VALUES (2, 'Abdul');
INSERT INTO cliente (ced, nom) VALUES (3, 'Jasper');

INSERT INTO empleo (ced, nit_empresa, valor_mensual) VALUES (1, 1, 58488);
INSERT INTO empleo (ced, nit_empresa, valor_mensual) VALUES (1, 2, 89156);
INSERT INTO empleo (ced, nit_empresa, valor_mensual) VALUES (3, 3, 19332);

-- If the relationship between cliente and empleo doesn't exist, will be created.
-- If cliente already exists, the name will be changed for nombre.
-- If empleo already exists, valor mensual will be channged for salario.
CREATE OR REPLACE PROCEDURE multiplexer (
    nombre  cliente.nom%TYPE, 
    cedula  cliente.ced%TYPE,
    nit     empleo.nit_empresa%TYPE,
    salario empleo.valor_mensual%TYPE)
IS
    NO_CLIENT_FOUND EXCEPTION;
    NO_EMPLEO_FOUND EXCEPTION;
    any_row_found   NUMBER;
BEGIN
    SELECT COUNT(*) INTO any_row_found FROM cliente WHERE cliente.ced = cedula;
    IF any_row_found = 0 THEN
        RAISE NO_CLIENT_FOUND;
    END IF;
    UPDATE cliente SET nom = nombre WHERE cliente.ced = cedula;
    DBMS_OUTPUT.PUT_LINE('multiplexer: cliente name has changed');

    SELECT COUNT(*) INTO any_row_found FROM empleo WHERE empleo.nit_empresa = nit;
    IF any_row_found = 0 THEN
        RAISE NO_EMPLEO_FOUND;
    END IF;
    
    SELECT COUNT(*) INTO any_row_found FROM cliente INNER JOIN empleo 
        ON empleo.ced = cedula;
    IF any_row_found = 0 THEN
        INSERT INTO empleo (ced, nit_empresa, valor_mensual) 
            VALUES (cedula, nit, salario);
        DBMS_OUTPUT.PUT_LINE('multiplexer: relationship has been created');
    ELSE
        UPDATE empleo SET valor_mensual = salario WHERE empleo.ced = cedula 
            AND empleo.nit_empresa = nit;
        DBMS_OUTPUT.PUT_LINE('multiplexer: valor mensual has changed');
    END IF;
    
EXCEPTION
    WHEN NO_CLIENT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('multiplexer: could not find cliente tupla');
    WHEN NO_EMPLEO_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('multiplexer: could not find empleo tupla');
END;
/

CREATE OR REPLACE PROCEDURE who_earn_more (cedula OUT cliente.ced%TYPE)
IS
BEGIN
    SELECT ced INTO cedula FROM 
        (SELECT c.ced, SUM(valor_mensual) total FROM cliente c INNER JOIN empleo e
            ON c.ced = e.ced GROUP BY c.ced ORDER BY total DESC) WHERE ROWNUM = 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('who_earn_more: could not find cliente tuplas');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('who_earn_more: ' || SQLERRM);
END;
/

rem __main__
rem
DECLARE
    nombre  cliente.nom%type;
    cedula  cliente.ced%type;
    nit     empleo.nit_empresa%type;
    salario empleo.valor_mensual%type;
BEGIN
    nombre  := 'tilda';
    cedula  := 2;
    nit     := 2;
    salario := 5000;
    
    multiplexer(nombre, cedula, nit, salario);
    who_earn_more(cedula);
    
    DBMS_OUTPUT.PUT_LINE(cedula || ' earn more');  
END;
/

SELECT * FROM cliente INNER JOIN empleo ON cliente.ced = empleo.ced;
