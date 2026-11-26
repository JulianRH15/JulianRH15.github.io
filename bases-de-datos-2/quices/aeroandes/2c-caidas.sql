WITH ventas AS (
    SELECT v.cod_origen || '-' || v.cod_destino AS ruta,
           TRUNC(r.fecha_compra, 'MM') AS mes, SUM(r.tarifa) AS ingreso
    FROM reserva r
    JOIN vuelo v ON v.id_vuelo = r.id_vuelo
    WHERE r.fecha_compra >= DATE '2025-12-01'
      AND r.fecha_compra < DATE '2027-01-01'
      AND r.estado IN ('CONFIRMADA', 'VOLADA')
    GROUP BY v.cod_origen, v.cod_destino, TRUNC(r.fecha_compra, 'MM')
), meses AS (
    SELECT ADD_MONTHS(DATE '2025-12-01', LEVEL - 1) AS mes
    FROM dual CONNECT BY LEVEL <= 13
), serie AS (
    SELECT rutas.ruta, m.mes, NVL(v.ingreso, 0) AS ingreso
    FROM (SELECT DISTINCT ruta FROM ventas) rutas
    CROSS JOIN meses m
    LEFT JOIN ventas v ON v.ruta = rutas.ruta AND v.mes = m.mes
), comparacion AS (
    SELECT ruta, mes, ingreso,
           LAG(ingreso) OVER (PARTITION BY ruta ORDER BY mes) AS anterior
    FROM serie
)
SELECT ruta, mes, ingreso, anterior AS ingreso_anterior,
       ROUND(100 * (ingreso - anterior) / NULLIF(anterior, 0), 2) AS variacion_pct
FROM comparacion
WHERE mes >= DATE '2026-01-01'
  AND anterior > 0
  AND ingreso < anterior * 0.70
ORDER BY ruta, mes;
