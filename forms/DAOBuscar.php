<?php

$opcion = $_POST['opcion'] ?? '';

/////////////// RECIBOS PENDIENTES DE PAGO (para la pantalla Buscar)
if ($opcion == "consultar") {
    require_once "../Config/Conexion.php";

    try {
        $sql = "SELECT re.idrecibos,
                       re.nrecibo,
                       me.nmedidor,
                       so.dui,
                       CONCAT(so.nombre, ' ', so.apellido) AS nombre,
                       CONCAT(co.mes, '-', co.anio) AS periodo,
                       (co.lectura_actual - co.lectura_anterior) AS metros,
                       re.monto
                FROM recibos AS re
                INNER JOIN consumo AS co
                    ON re.idconsumo = co.idconsumo
                INNER JOIN medidor AS me
                    ON me.idmedidor = co.idmedidor
                INNER JOIN contrato AS con
                    ON con.idcontrato = me.idcontrato
                INNER JOIN socio AS so
                    ON so.idsocio = con.idsocio
                WHERE re.estado = 'PENDIENTE'
                ORDER BY re.nrecibo";

        $stmt = $conexion->prepare($sql);
        $stmt->execute();

        $resultado = $stmt->get_result();

        $registros = [];

        while ($fila = $resultado->fetch_assoc()) {
            $registros[] = [
                'idrecibos' => $fila['idrecibos'],
                'nrecibo'   => $fila['nrecibo'],
                'nmedidor'  => $fila['nmedidor'],
                'dui'       => $fila['dui'],
                'nombre'    => $fila['nombre'],
                'periodo'   => $fila['periodo'],
                'metros'    => $fila['metros'],
                'monto'     => "$" . number_format((float)$fila['monto'], 2, ".", ",")
            ];
        }

        echo json_encode($registros, JSON_UNESCAPED_UNICODE);

        $resultado->free();
        $stmt->close();
        $conexion->close();
    } catch (Throwable $e) {
        echo json_encode([
            "mensaje" => "No se pudieron obtener los registros"
        ], JSON_UNESCAPED_UNICODE);
    }
}
