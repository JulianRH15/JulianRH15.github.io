-- Taller grupal de inventario, punto 4.1. Requiere el esquema de la ferretería.
SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION FN_PRECIO_PRODUCTO (
    p_codigo IN VARCHAR2
) RETURN NUMBER IS
    v_precio PRODUCTO.precio_unitario%TYPE;
BEGIN
    SELECT precio_unitario
    INTO   v_precio
    FROM   PRODUCTO
    WHERE  codigo = p_codigo;

    RETURN v_precio;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('FN_PRECIO_PRODUCTO: no existe un producto con codigo ' ||
                             NVL(p_codigo, 'NULL'));
        RETURN -1;
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('FN_PRECIO_PRODUCTO: hay mas de un producto con codigo ' ||
                             p_codigo);
        RETURN -2;
END FN_PRECIO_PRODUCTO;
/
-- Pruebas:
BEGIN
    DBMS_OUTPUT.PUT_LINE('HM-0001 -> ' || FN_PRECIO_PRODUCTO('HM-0001'));   -- 45000
    DBMS_OUTPUT.PUT_LINE('XX-9999 -> ' || FN_PRECIO_PRODUCTO('XX-9999'));   -- -1
    DBMS_OUTPUT.PUT_LINE('hm-0001 -> ' || FN_PRECIO_PRODUCTO('hm-0001'));   -- -1 (distingue mayusculas)
END;
/
