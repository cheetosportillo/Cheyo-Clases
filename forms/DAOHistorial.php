<?php

$idmedidor = $_POST['idmedidor'] ?? '';
$opcion = $_POST['opcion'] ?? '';

if ($opcion == "consultar") {
    require_once "../Config/Conexion.php";
    // COALESCE devuelve el primer valor que no sea NULL (valor1, valor2, valor3)
    try {
        $sql = "SELECT
                    m.nmedidor,
                    CONCAT(c.mes, '-', c.anio) AS periodo,
                    c.fecha_lectura,
                    c.fecha_vencimiento,
                    c.lectura_actual,
                    c.lectura_anterior,
                    (c.lectura_actual - c.lectura_anterior) AS metros,
                    COALESCE(
                        (
                            -- 1) tarifa cuyo rango (desde-hasta) contiene los metros consumidos
                            SELECT
                                CASE
                                    WHEN t.tipo_cobro = 'FIJO' THEN t.precio
                                    WHEN t.tipo_cobro = 'POR_METRO' THEN
                                        (c.lectura_actual - c.lectura_anterior)
                                        * t.precio
                                END
                            FROM tarifa AS t
                            WHERE (c.lectura_actual - c.lectura_anterior)
                                BETWEEN t.desde AND t.hasta
                            ORDER BY t.desde DESC
                            LIMIT 1
                        ),
                        (
                            -- 2) si el consumo supera todos los rangos, se usa la ultima tarifa
                            SELECT
                                CASE
                                    WHEN t.tipo_cobro = 'FIJO' THEN t.precio
                                    WHEN t.tipo_cobro = 'POR_METRO' THEN
                                        (c.lectura_actual - c.lectura_anterior)
                                        * t.precio
                                END
                            FROM tarifa AS t
                            ORDER BY t.hasta DESC
                            LIMIT 1
                        )
                    ) AS monto,
                    c.estado
                FROM medidor AS m
                LEFT JOIN consumo AS c
                    ON c.idmedidor = m.idmedidor
                WHERE m.idmedidor = ?";

        $stmt = $conexion->prepare($sql);
        $stmt->bind_param("i", $idmedidor);
        $stmt->execute();

        $resultado = $stmt->get_result();

        $registros = [];
        $correlativo = 1;

        while ($fila = $resultado->fetch_assoc()) {
            // El LEFT JOIN devuelve una fila vacia si el medidor aun no tiene lecturas
            if ($fila['periodo'] === null) {
                continue;
            }

            $registros[] = [
                'numero_medidor'    => $fila['nmedidor'],
                'periodo'           => $fila['periodo'],
                'fecha_lectura'     => $fila['fecha_lectura'],
                'fecha_vencimiento' => $fila['fecha_vencimiento'],
                'lectura_actual'    => $fila['lectura_actual'],
                'lectura_anterior'  => $fila['lectura_anterior'],
                'metros'            => $fila['metros'],
                'estado'            => $fila['estado'],
                'monto'             => "$" . number_format((float)$fila['monto'], 2, ".", ","),
                'correlativo'       => $correlativo++
            ];
        }

        echo json_encode(
            $registros,
            JSON_UNESCAPED_UNICODE
        );

        $resultado->free();
        $stmt->close();
    } catch (Throwable $e) {

        echo json_encode([
            "mensaje" => "No se pudieron obtener los registros"
        ], JSON_UNESCAPED_UNICODE);
    }
}

/////////////// NUMERO DEL MEDIDOR (para el titulo de la pagina)
if ($opcion == "consultarMedidor") {
    require_once "../Config/Conexion.php";

    try {
        $stmt = $conexion->prepare("SELECT nmedidor FROM medidor WHERE idmedidor = ?");
        $stmt->bind_param("i", $idmedidor);
        $stmt->execute();

        $resultado = $stmt->get_result();
        $fila = $resultado->fetch_assoc();

        echo json_encode([
            "estado" => $fila !== null,
            "numero_medidor" => $fila['nmedidor'] ?? ""
        ], JSON_UNESCAPED_UNICODE);

        $stmt->close();
    } catch (Throwable $e) {
        echo json_encode([
            "estado" => false,
            "mensaje" => "No se pudo obtener el medidor"
        ], JSON_UNESCAPED_UNICODE);
    }
}
