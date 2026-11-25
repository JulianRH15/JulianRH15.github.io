SELECT anio, contratados,
       SUM(contratados) OVER (ORDER BY anio) AS acumulado,
       contratados - LAG(contratados) OVER (ORDER BY anio) AS variacion
  FROM (SELECT EXTRACT(YEAR FROM hire_date) AS anio, COUNT(*) AS contratados
          FROM employees
         GROUP BY EXTRACT(YEAR FROM hire_date))
 ORDER BY anio;
