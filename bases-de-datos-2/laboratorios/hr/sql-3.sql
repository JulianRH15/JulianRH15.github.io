WITH base AS (
  SELECT e.last_name, e.job_id, e.department_id, e.salary,
         AVG(e.salary) OVER (PARTITION BY e.department_id) AS prom_depto,
         AVG(e.salary) OVER (PARTITION BY e.job_id)        AS prom_cargo
    FROM employees e
)
SELECT last_name, job_id, department_id, salary,
       ROUND(prom_depto, 2) AS prom_depto,
       ROUND(prom_cargo, 2) AS prom_cargo,
       ROUND((salary - prom_depto) / prom_depto * 100, 1) AS pct_sobre_depto
  FROM base
 WHERE salary > prom_depto
   AND salary > prom_cargo
 ORDER BY pct_sobre_depto DESC;
