SELECT v.cod_origen, r.id_reserva, r.fecha_compra, r.tarifa, r.estado,
       SUM(CASE WHEN r.estado IN ('CONFIRMADA', 'VOLADA')
                THEN r.tarifa ELSE 0 END) OVER (
           PARTITION BY v.cod_origen
           ORDER BY r.fecha_compra, r.id_reserva
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS acumulado
FROM reserva r
JOIN vuelo v ON v.id_vuelo = r.id_vuelo
ORDER BY v.cod_origen, r.fecha_compra, r.id_reserva;
