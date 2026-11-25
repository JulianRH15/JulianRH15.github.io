CREATE TABLE auditoria_salarios (
    id_auditoria     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id      NUMBER(6)    NOT NULL,
    salario_anterior NUMBER(8,2),
    salario_nuevo    NUMBER(8,2),
    usuario          VARCHAR2(128) DEFAULT USER,
    fecha            DATE          DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER trg_auditar_salario
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
WHEN (NEW.salary <> OLD.salary)
BEGIN
    IF :NEW.salary > :OLD.salary * 1.5 THEN
        RAISE_APPLICATION_ERROR(-20020,
            'Un aumento no puede pasar del 50% del salario actual.');
    END IF;

    INSERT INTO auditoria_salarios (employee_id, salario_anterior, salario_nuevo)
    VALUES (:OLD.employee_id, :OLD.salary, :NEW.salary);
END;
/

-- Prueba: el primero se audita, el segundo se rechaza
UPDATE employees SET salary = salary * 1.10 WHERE employee_id = 107;
UPDATE employees SET salary = salary * 2    WHERE employee_id = 107;
SELECT * FROM auditoria_salarios;
