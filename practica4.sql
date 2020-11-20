rem PRACTICA 4: TRIGGERS
rem
rem  Cristian Camilo Serna Betancur
rem     Elver Andres Arroyave
rem 

rem ******* 1 *******
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

CREATE TABLE auditoria (
    fecha  DATE NOT NULL,
    nombre VARCHAR(7) NOT NULL
);

rem DRY
rem
CREATE OR REPLACE PROCEDURE update_auditoria (table_name auditoria.nombre%TYPE)
IS
BEGIN
    INSERT INTO auditoria (fecha, nombre) VALUES (SYSDATE, table_name);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('update_auditoria: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER empleo_insert_update_delete AFTER 
INSERT OR UPDATE OR DELETE ON empleo
BEGIN
    update_auditoria('empleo');
END;
/

CREATE OR REPLACE TRIGGER cliente_insert_update_delete AFTER 
INSERT OR UPDATE OR DELETE ON cliente
BEGIN
    update_auditoria('cliente');
END;
/

CREATE OR REPLACE TRIGGER gasto_insert_update_delete AFTER 
INSERT OR UPDATE OR DELETE ON gasto
BEGIN
    update_auditoria('gasto');
END;
/

rem ******* 2 *******
rem
rem xempleo is a duplicated of the empleo table. It does 
rem INSERT, UPDATE or DELETE when empleo also does it. 
CREATE TABLE xempleo (
    ced           NUMBER(8),
    nit_empresa   INTEGER,
    valor_mensual NUMBER(6) NOT NULL,
    PRIMARY KEY (ced, nit_empresa)
);

CREATE OR REPLACE TRIGGER insert_xempleo AFTER INSERT ON empleo FOR EACH ROW
BEGIN
    INSERT INTO xempleo (ced, nit_empresa, valor_mensual)
        VALUES (:NEW.ced, :NEW.nit_empresa, :NEW.valor_mensual);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('insert_xempleo: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER update_xempleo after UPDATE ON empleo FOR EACH ROW
BEGIN
    UPDATE xempleo 
    SET ced = :NEW.ced,nit_empresa = :NEW.nit_empresa, valor_mensual = :NEW.valor_mensual 
        WHERE ced = :OLD.ced AND nit_empresa = :OLD.nit_empresa;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('update_xempleo: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER delete_xempleo AFTER DELETE ON empleo FOR EACH ROW
BEGIN
    DELETE FROM xempleo WHERE ced = :OLD.ced OR nit_empresa = :OLD.nit_empresa;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('delet_xempleo: ' || SQLERRM);
END;
/

rem xgasto is a duplicated of the gasto table. It does 
rem INSERT, UPDATE or DELETE when gasto also does it. 
CREATE TABLE xgasto (
    cod_gasto     NUMBER(8) PRIMARY KEY,
    ced           NUMBER(8),
    valor_mensual NUMBER(6)
);

CREATE OR REPLACE TRIGGER insert_xgasto AFTER INSERT ON gasto FOR EACH ROW
BEGIN
    INSERT INTO xgasto (cod_gasto, ced, valor_mensual)
        VALUES (:NEW.cod_gasto, :NEW.ced, :NEW.valor_mensual);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('insert_xgasto: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER update_xgasto AFTER UPDATE ON gasto FOR EACH ROW
BEGIN
    UPDATE xgasto SET cod_gasto = :NEW.cod_gasto,ced = :NEW.ced, valor_mensual = :NEW.valor_mensual 
        WHERE cod_gasto = :OLD.cod_gasto;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('update_xgasto: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER delete_xgasto AFTER DELETE ON gasto FOR EACH ROW
BEGIN
    DELETE FROM xgasto WHERE cod_gasto = :OLD.cod_gasto;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('delete_xgasto: ' || SQLERRM);
END;
/

rem Business rules
rem
rem DRY
rem
CREATE OR REPLACE PROCEDURE get_total_income_and_expenses (
    expenses OUT NUMBER, 
    income   OUT NUMBER)
IS
BEGIN
    SELECT SUM(valor_mensual) INTO expenses FROM xgasto;
    SELECT SUM(valor_mensual) INTO income   FROM xempleo;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('get_total_income_and_expenses: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER insert_rule BEFORE INSERT ON gasto FOR EACH ROW
DECLARE
    expenses NUMBER;
    income   NUMBER;
BEGIN
    get_total_income_and_expenses(expenses, income);
    IF (expenses + :NEW.valor_mensual) > income THEN
        RAISE_APPLICATION_ERROR(-20501, 'rule: no customer can have more expenses than income.');
        -- Ningún cliente puede tener más gastos que ingresos
    END IF;
END;
/

CREATE OR REPLACE TRIGGER update_rule BEFORE UPDATE OF valor_mensual ON gasto FOR EACH ROW
DECLARE
    expenses NUMBER;
    income   NUMBER;
BEGIN
    get_total_income_and_expenses(expenses, income);
    IF (expenses - :OLD.valor_mensual + :NEW.valor_mensual) > income THEN
        RAISE_APPLICATION_ERROR(-20501, 'rule: no customer can have more expenses than income.');
        -- Ningún cliente puede tener más gastos que ingresos
    END IF;
END;
/

CREATE OR REPLACE TRIGGER delete_rule BEFORE DELETE ON empleo FOR EACH ROW
DECLARE
    expenses NUMBER;
    income   NUMBER;
BEGIN
    get_total_income_and_expenses(expenses, income);
    IF expenses > (income - :OLD.valor_mensual) THEN
        RAISE_APPLICATION_ERROR(-20501, 'rule: no customer can have more expenses than income.');
        -- Ningún cliente puede tener más gastos que ingresos
    END IF;
END;
/

rem Tests
rem
INSERT INTO cliente (ced, nom)                               VALUES (1, 'Brody');
INSERT INTO empleo (ced, nit_empresa, valor_mensual)         VALUES (1, 1, 600);
INSERT INTO gasto (cod_gasto, ced, valor_mensual, des_gasto) VALUES (1, 1, 500, 140000);

UPDATE cliente SET nom = 'brody'         WHERE ced = 1;
UPDATE empleo  SET valor_mensual = 0     WHERE nit_empresa = 1;
UPDATE gasto   SET valor_mensual = 10000 WHERE cod_gasto   = 1;

INSERT INTO gasto (cod_gasto, ced, valor_mensual, des_gasto) VALUES (1, 2, 20000, 140000);

DELETE FROM empleo WHERE ced       = 1;
DELETE FROM gasto  WHERE cod_gasto = 1;

SELECT TO_CHAR(fecha, 'YYYY-MM-DD HH24:MI:SS'), nombre FROM auditoria;

DROP TABLE gasto;
DROP TABLE xgasto;
DROP TABLE empleo;
DROP TABLE xempleo;
DROP TABLE cliente;
DROP TABLE auditoria;
