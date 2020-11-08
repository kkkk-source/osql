rem PRACTICA 3: FUNCIONES Y PAQUETES
rem
rem  Cristian Camilo Serna Betancur
rem     Elver Andres Arroyave
rem 

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

INSERT INTO gasto (cod_gasto, ced, valor_mensual, des_gasto) VALUES (1, 1, 147644, 140000);
INSERT INTO gasto (cod_gasto, ced, valor_mensual, des_gasto) VALUES (2, 2, 0, 140000);
INSERT INTO gasto (cod_gasto, ced, valor_mensual, des_gasto) VALUES (3, 3, 19332, 100);


rem ******* 1 *******
rem

/* 
 * From our point of view it's no necessary to handle exceptional
 * situations wihin get_total_expenses and get_total_profit 
 * functions. They behave as expect with NULL parameters.
 */
CREATE OR REPLACE FUNCTION get_total_expenses (cliente_cc IN NUMBER)
RETURN NUMBER IS
    total NUMBER;
BEGIN
    total := 0;
    FOR gasto IN 
        (SELECT valor_mensual FROM cliente INNER JOIN gasto 
            ON cliente.ced = gasto.ced WHERE cliente.ced = cliente_cc)
    LOOP
        total := total + gasto.valor_mensual;
    END LOOP;
    RETURN total;
END;
/

CREATE OR REPLACE FUNCTION get_total_profit (cliente_cc IN NUMBER)
RETURN NUMBER IS
    total NUMBER;
BEGIN
    total := 0;
    FOR empleo IN
        (SELECT valor_mensual FROM cliente INNER JOIN empleo 
            ON cliente.ced = empleo.ced WHERE cliente.ced = cliente_cc)
    LOOP
        total := total + empleo.valor_mensual;
    END LOOP;
    RETURN total;
END;
/

CREATE OR REPLACE FUNCTION substract (ingresos IN NUMBER, gastos IN NUMBER)
RETURN NUMBER IS
    NEGATIVE_NUMBER_FOUND EXCEPTION;
    difference NUMBER;
BEGIN
    difference := ingresos - gastos;
    IF difference < 0 THEN
        RAISE NEGATIVE_NUMBER_FOUND;
    END IF;
    RETURN difference;
EXCEPTION
    WHEN NEGATIVE_NUMBER_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('substract: negative number has been found.');
    RETURN -1;
END;
/

CREATE OR REPLACE FUNCTION who_spends_less_money
RETURN NUMBER IS
    cc NUMBER := -1;
BEGIN
    SELECT ced INTO cc FROM
        (SELECT cliente.ced, substract(get_total_profit(cliente.ced), get_total_expenses(cliente.ced)) 
            AS neto FROM cliente ORDER BY neto DESC) WHERE ROWNUM = 1;
    RETURN cc;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('who_spends_less_money: could not find cliente/gasto tuplas relation.');
    RETURN cc;
END;
/

rem __main__
BEGIN
    DBMS_OUTPUT.PUT_LINE('who spends less money = ' || who_spends_less_money());
END;
/

rem ******* 2 *******
rem
                         
CREATE OR REPLACE FUNCTION who_has_more_jobs
RETURN NUMBER IS
    cc NUMBER;
BEGIN
    SELECT ced INTO cc FROM 
        (SELECT cliente.ced, COUNT(nit_empresa) AS jobs FROM cliente INNER JOIN empleo 
            ON cliente.ced = empleo.ced GROUP BY cliente.ced ORDER BY jobs DESC) WHERE ROWNUM = 1;
    RETURN cc;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('who_has_more_jobs: could not find cliente/empleo tuplas relation.');
    RETURN -1;
END;
/
    
rem __main__
BEGIN
    DBMS_OUTPUT.PUT_LINE('who has more jobs = ' || who_has_more_jobs());
END;
                         

rem ******* 3 *******
rem                        
rem If you call a PLSQL function in a SQL statement it must be schema-level
rem "create function" or in the package spec. Cannot be private. 
rem

CREATE OR REPLACE PACKAGE pkg IS
    FUNCTION who_spends_less_money RETURN NUMBER;
    FUNCTION who_has_more_jobs RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY pkg IS
    --- private
    FUNCTION get_total_expenses (cliente_cc IN NUMBER) RETURN NUMBER IS
        total NUMBER;
    BEGIN
        total := 0;
        FOR gasto IN 
            (SELECT valor_mensual FROM cliente INNER JOIN gasto 
                ON cliente.ced = gasto.ced WHERE cliente.ced = cliente_cc)
        LOOP
            total := total + gasto.valor_mensual;
        END LOOP;
        RETURN total;
    END;

    --- private
    FUNCTION get_total_profit (cliente_cc IN NUMBER) RETURN NUMBER IS
        total NUMBER;
    BEGIN
        total := 0;
        FOR empleo IN
            (SELECT valor_mensual FROM cliente INNER JOIN empleo 
                ON cliente.ced = empleo.ced WHERE cliente.ced = cliente_cc)
        LOOP
                total := total + empleo.valor_mensual;
        END LOOP;
        RETURN total;
    END;

    --- private
    FUNCTION substract (ingresos IN NUMBER, gastos IN NUMBER) RETURN NUMBER IS
        NEGATIVE_NUMBER_FOUND EXCEPTION;
        difference NUMBER;
    BEGIN
        difference := ingresos - gastos;
        IF difference < 0 THEN
            RAISE NEGATIVE_NUMBER_FOUND;
        END IF;
        RETURN difference;
    EXCEPTION
        WHEN NEGATIVE_NUMBER_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('substract: negative number has been found.');
        RETURN -1;
    END;

    --- public
    FUNCTION who_spends_less_money RETURN NUMBER IS
        NEGATIVE_NUMBER_FOUND EXCEPTION;

        cc     NUMBER := -1;
        actual NUMBER :=  0;
        bigger NUMBER :=  0;
    BEGIN
        FOR cliente in (SELECT ced FROM cliente)
        LOOP
            actual := substract(get_total_profit(cliente.ced), get_total_expenses(cliente.ced));
            IF bigger < actual THEN
                cc := cliente.ced;
                bigge := menor;
            END IF;
        END LOOP;

        IF bigger < 0 THEN
            RAISE NEGATIVE_NUMBER_FOUND;
        END IF;

        RETURN cc;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('who_spends_less_money: could not find cliente/gasto tuplas relation.');
        WHEN NEGATIVE_NUMBER_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('who_spends_less_money: negative number has been found.');
        RETURN -1;
    END;

    --- public
    FUNCTION who_has_more_jobs RETURN NUMBER IS
        cc NUMBER;
    BEGIN
        SELECT ced INTO cc FROM 
            (SELECT cliente.ced, COUNT(nit_empresa) AS jobs FROM cliente INNER JOIN empleo 
                ON cliente.ced = empleo.ced GROUP BY cliente.ced ORDER BY jobs DESC) WHERE ROWNUM = 1;
        RETURN cc;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('who_has_more_jobs: could not find cliente/empleo tuplas relation.');
        RETURN -1;
    END;
END;
/

rem _main_
BEGIN
    DBMS_OUTPUT.PUT_LINE('who spends less money = ' || pkg.who_spends_less_money());
    DBMS_OUTPUT.PUT_LINE('who has more jobs = ' || pkg.who_has_more_jobs());
END;
/
