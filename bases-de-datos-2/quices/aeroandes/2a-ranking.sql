WITH ventas AS (
    SELECT TRUNC(r.fecha_compra, 'MM') AS mes,
           v.cod_origen || '-' || v.cod_destino AS ruta,
           SUM(r.tarifa) AS ingreso
    FROM reserva r
    JOIN vuelo v ON v.id_vuelo = r.id_vuelo
    WHERE r.fecha_compra >= DATE '2026-01-01'
      AND r.fecha_compra < DATE '2027-01-01'
      AND r.estado IN ('CONFIRMADA', 'VOLADA')
    GROUP BY TRUNC(r.fecha_compra, 'MM'), v.cod_origen, v.cod_destino
), puestos AS (
    SELECT mes, ruta, ingreso,
           ROW_NUMBER() OVER (
               PARTITION BY mes ORDER BY ingreso DESC, ruta ASC
           ) AS posicion
    FROM ventas
)
SELECT mes, ruta, ingreso, posicion
FROM puestos
WHERE posicion <= 3
ORDER BY mes, posicion;
