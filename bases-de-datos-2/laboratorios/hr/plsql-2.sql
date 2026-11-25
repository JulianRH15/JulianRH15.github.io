CREATE OR REPLACE FUNCTION anios_antiguedad (
    p_employee_id IN employees.employee_id%TYPE
) RETURN NUMBER IS
    v_fecha employees.hire_date%TYPE;
BEGIN
    SELECT hire_date INTO v_fecha
      FROM employees
     WHERE employee_id = p_employee_id;

    RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha) / 12);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

SELECT last_name, hire_date, anios_antiguedad(employee_id) AS antiguedad
  FROM employees
 WHERE anios_antiguedad(employee_id) >= 20
 ORDER BY antiguedad DESC;
