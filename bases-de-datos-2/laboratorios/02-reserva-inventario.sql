-- Oracle. Bloque autocontenido con inventario de prueba en memoria.
SET SERVEROUTPUT ON
DECLARE
    stock PLS_INTEGER := 10;
    PROCEDURE reservar(unidades IN PLS_INTEGER) IS
    BEGIN
        IF unidades IS NULL OR unidades <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Cantidad invalida');
        ELSIF unidades > stock THEN
            RAISE_APPLICATION_ERROR(-20002, 'Stock insuficiente');
        END IF;
        stock := stock - unidades;
    END;

    PROCEDURE probar(unidades PLS_INTEGER, codigo_esperado NUMBER, saldo_esperado NUMBER) IS
        codigo NUMBER := 0;
    BEGIN
        BEGIN
            reservar(unidades);
        EXCEPTION
            WHEN OTHERS THEN codigo := SQLCODE;
        END;
        IF codigo <> codigo_esperado OR stock <> saldo_esperado THEN
            RAISE_APPLICATION_ERROR(-20003, 'Resultado inesperado');
        END IF;
        DBMS_OUTPUT.PUT_LINE('Pedido=' || NVL(TO_CHAR(unidades), 'NULL')
            || ' codigo=' || codigo || ' stock=' || stock);
    END;
BEGIN
    probar(4, 0, 6);
    probar(7, -20002, 6);
    probar(0, -20001, 6);
    probar(NULL, -20001, 6);
    probar(6, 0, 0);
END;
/
