CREATE OR REPLACE PACKAGE pkg_nomina AS
    FUNCTION total_departamento (p_department_id IN NUMBER) RETURN NUMBER;
    PROCEDURE reporte_departamentos;
END pkg_nomina;
/

CREATE OR REPLACE PACKAGE BODY pkg_nomina AS

    FUNCTION total_departamento (p_department_id IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(salary), 0) INTO v_total
          FROM employees
         WHERE department_id = p_department_id;
        RETURN v_total;
    END total_departamento;

    PROCEDURE reporte_departamentos IS
        TYPE t_deptos IS TABLE OF departments%ROWTYPE;
        v_deptos t_deptos;
        i PLS_INTEGER;
    BEGIN
        SELECT * BULK COLLECT INTO v_deptos
          FROM departments
         ORDER BY department_name;

        i := v_deptos.FIRST;
        WHILE i IS NOT NULL LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(v_deptos(i).department_name, 25) ||
                TO_CHAR(total_departamento(v_deptos(i).department_id), '999G999D99'));
            i := v_deptos.NEXT(i);
        END LOOP;
    END reporte_departamentos;

END pkg_nomina;
/

SET SERVEROUTPUT ON
EXEC pkg_nomina.reporte_departamentos;
