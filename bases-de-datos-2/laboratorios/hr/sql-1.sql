SELECT department_name, last_name, salary, puesto
  FROM (SELECT d.department_name, e.last_name, e.salary,
               DENSE_RANK() OVER (PARTITION BY e.department_id
                                  ORDER BY e.salary DESC) AS puesto
          FROM employees e
          JOIN departments d ON d.department_id = e.department_id)
 WHERE puesto <= 3
 ORDER BY department_name, puesto;
