rem PRACTICA 4: FUNCIONES Y PAQUETES
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
    nit_empresa   INTEGER,valor_mensual NUMBER(6) NOT NULL,
    PRIMARY KEY (ced, nit_empresa)
);

CREATE TABLE gasto (cod_gasto     NUMBER(8) PRIMARY KEY,
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

rem Tests
rem
INSERT INTO cliente (ced, nom)                               VALUES (1, 'Brody');
INSERT INTO empleo (ced, nit_empresa, valor_mensual)         VALUES (1, 1, 58488);
INSERT INTO gasto (cod_gasto, ced, valor_mensual, des_gasto) VALUES (1, 1, 147644, 140000);

UPDATE cliente SET nom = 'brody'        WHERE ced = 1;
UPDATE empleo  SET valor_mensual = 1000 WHERE ced = 1;
UPDATE gasto   SET valor_mensual = 1000 WHERE ced = 1;

DELETE FROM gasto WHERE ced = 1;

SELECT TO_CHAR(fecha, 'YYYY-MM-DD HH24:MI:SS'), nombre FROM auditoria;

DROP TABLE gasto;
DROP TABLE empleo;
DROP TABLE cliente;
DROP TABLE auditoria;

