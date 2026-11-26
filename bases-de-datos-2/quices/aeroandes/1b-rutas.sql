WITH vuelos_periodo AS (
    SELECT id_vuelo, cod_origen, cod_destino
    FROM vuelo
    WHERE fecha_salida >= DATE '2026-01-01'
), venta_por_vuelo AS (
    SELECT r.id_vuelo, SUM(r.tarifa) AS ingreso
    FROM reserva r
    JOIN vuelos_periodo v ON v.id_vuelo = r.id_vuelo
    WHERE r.estado IN ('CONFIRMADA', 'VOLADA')
      AND NOT EXISTS (
          SELECT 1 FROM pasajero p
          WHERE p.id_pasajero_referido = r.id_pasajero
      )
    GROUP BY r.id_vuelo
), vuelos_con_incidencia AS (
    SELECT DISTINCT i.id_vuelo
    FROM incidencia i
    JOIN vuelos_periodo v ON v.id_vuelo = i.id_vuelo
)
SELECT v.cod_origen || '-' || v.cod_destino AS ruta,
       SUM(NVL(s.ingreso, 0)) AS ingreso,
       COUNT(i.id_vuelo) AS vuelos_con_incidencia
FROM vuelos_periodo v
LEFT JOIN venta_por_vuelo s ON s.id_vuelo = v.id_vuelo
LEFT JOIN vuelos_con_incidencia i ON i.id_vuelo = v.id_vuelo
GROUP BY v.cod_origen, v.cod_destino
ORDER BY ingreso DESC, ruta
FETCH FIRST 5 ROWS ONLY;
