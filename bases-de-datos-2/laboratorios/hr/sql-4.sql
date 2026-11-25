SELECT CASE WHEN GROUPING(r.region_name) = 1 THEN 'TOTAL GENERAL'
            ELSE r.region_name END AS region,
       CASE WHEN GROUPING(c.country_name) = 1 AND GROUPING(r.region_name) = 0
            THEN 'Subtotal de la región'
            ELSE c.country_name END AS pais,
       COUNT(e.employee_id) AS empleados,
       SUM(e.salary) AS nomina
  FROM employees e
  JOIN departments d ON d.department_id = e.department_id
  JOIN locations l   ON l.location_id = d.location_id
  JOIN countries c   ON c.country_id = l.country_id
  JOIN regions r     ON r.region_id = c.region_id
 GROUP BY ROLLUP (r.region_name, c.country_name)
 ORDER BY r.region_name, c.country_name;
