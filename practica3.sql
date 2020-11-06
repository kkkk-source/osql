rem PRACTICA 3: PROCEDIMIENTOS ALMACENADOS
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
