# Bases de Datos 2

| Evidencia | Código | Cómo reproducirla |
| --- | --- | --- |
| SQL avanzado. Acumulados con salarios empatados | [Consulta completa](laboratorios/01-acumulados.sql) | Ejecutar como script en Oracle. La consulta incorpora sus tres filas de prueba. |
| PL/SQL. Reserva de inventario | [Bloque y cinco pruebas](laboratorios/02-reserva-inventario.sql) | Ejecutar como script con salida de servidor habilitada. El bloque crea el inventario en memoria. |
| Taller grupal de ferretería, punto 4.1 | [Función de precio y tres llamadas](talleres/ferreteria/4-1-precio-producto.sql) | Usar el esquema del taller con la tabla `PRODUCTO` y el código `HM-0001` a 45 000. La comprobación automática crea una tabla mínima en una base temporal. |
| Laboratorios sobre el esquema HR | [Cinco scripts de SQL y cuatro de PL/SQL](laboratorios/hr/) | Abrir el archivo elegido en una copia del esquema HR de Oracle. Algunos procedimientos y triggers modifican salarios. |

En Oracle SQL Developer, **F5** ejecuta el archivo completo y muestra los resultados en la pestaña de salida. Los tres primeros ejercicios también se ejecutan en una base Oracle temporal de GitHub Actions. El paso «Ejecutar las prácticas y comprobar la salida» muestra las filas, los saldos y los códigos devueltos. [Ver ejecuciones](https://github.com/JulianRH15/JulianRH15.github.io/actions/workflows/laboratorios-oracle.yml).
