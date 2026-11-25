CREATE OR REPLACE PROCEDURE aumentar_salario_depto (
    p_department_id IN  employees.department_id%TYPE,
    p_porcentaje    IN  NUMBER,
    p_actualizados  OUT NUMBER
) IS
    e_porcentaje_invalido EXCEPTION;
    v_nuevo employees.salary%TYPE;
BEGIN
    IF p_porcentaje <= 0 OR p_porcentaje > 30 THEN
        RAISE e_porcentaje_invalido;
    END IF;

    p_actualizados := 0;

    FOR r IN (SELECT e.employee_id, e.salary, j.max_salary
                FROM employees e
                JOIN jobs j ON j.job_id = e.job_id
               WHERE e.department_id = p_department_id
                 FOR UPDATE OF e.salary) LOOP
        v_nuevo := LEAST(ROUND(r.salary * (1 + p_porcentaje / 100), 2), r.max_salary);
        IF v_nuevo > r.salary THEN
            UPDATE employees SET salary = v_nuevo WHERE employee_id = r.employee_id;
            p_actualizados := p_actualizados + 1;
        END IF;
    END LOOP;

    IF p_actualizados = 0 THEN
        RAISE_APPLICATION_ERROR(-20010,
            'Ningún empleado del departamento ' || p_department_id || ' recibió aumento.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN e_porcentaje_invalido THEN
        RAISE_APPLICATION_ERROR(-20011, 'El porcentaje debe estar entre 0 y 30.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Prueba
SET SERVEROUTPUT ON
DECLARE
    v_total NUMBER;
BEGIN
    aumentar_salario_depto(60, 10, v_total);
    DBMS_OUTPUT.PUT_LINE('Empleados actualizados: ' || v_total);
END;
/
