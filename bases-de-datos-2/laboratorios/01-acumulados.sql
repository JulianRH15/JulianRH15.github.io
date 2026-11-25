-- Oracle. Datos de práctica autocontenidos, sin tablas persistentes.
WITH empleados (id, salario) AS (
    SELECT 101, 17000 FROM dual UNION ALL
    SELECT 102, 17000 FROM dual UNION ALL
    SELECT 100, 24000 FROM dual
)
SELECT id, salario,
       SUM(salario) OVER (
           ORDER BY salario, id ROWS UNBOUNDED PRECEDING
       ) AS por_fila,
       SUM(salario) OVER (
           ORDER BY salario RANGE UNBOUNDED PRECEDING
       ) AS por_salario
FROM empleados
ORDER BY salario, id;
