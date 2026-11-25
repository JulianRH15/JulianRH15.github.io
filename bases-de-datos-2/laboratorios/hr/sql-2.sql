SELECT LPAD(' ', 2 * (LEVEL - 1)) || first_name || ' ' || last_name AS empleado,
       LEVEL AS nivel,
       SYS_CONNECT_BY_PATH(last_name, ' > ') AS ruta
  FROM employees
 START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
 ORDER SIBLINGS BY last_name;
