<?php
session_start();

$loginUsuario = trim($_POST['loginUsuario'] ?? '');
$loginClave = $_POST['loginClave'] ?? '';

$opcion = $_POST['opcion'] ?? '';

if ($opcion == "consultar") {
    require_once "../Config/Conexion.php";

    try {
        if ($loginUsuario === '' || $loginClave === '') {
            throw new Exception("Ingrese usuario y contraseña");
        }

        // En la tabla usuario, "usuario" y "clave" se guardan con password_hash
        // (ver DAOnivelAcceso.php), por eso no se pueden buscar con un WHERE:
        // se recorren los usuarios y se comparan con password_verify.
        $sql = "SELECT u.idempleado, u.rol, u.usuario, u.clave,
                       CONCAT(e.nombre, ' ', e.apellido) AS nombreEmpleado
                FROM usuario AS u
                INNER JOIN empleado AS e
                    ON e.idempleado = u.idempleado";

        $stmt = $conexion->prepare($sql);
        $stmt->execute();

        $resultado = $stmt->get_result();

        $encontrado = null;

        while ($fila = $resultado->fetch_assoc()) {
            if (
                password_verify($loginUsuario, $fila['usuario']) &&
                password_verify($loginClave, $fila['clave'])
            ) {
                $encontrado = $fila;
                break;
            }
        }

        $resultado->free();
        $stmt->close();
        $conexion->close();

        if ($encontrado === null) {
            echo json_encode([
                "estado" => false,
                "mensaje" => "Usuario o contraseña incorrectos"
            ], JSON_UNESCAPED_UNICODE);
            exit;
        }

        // Datos de sesión que usan las demás páginas
        session_regenerate_id(true);
        $_SESSION['autenticado'] = true;
        $_SESSION['idempleado'] = (int)$encontrado['idempleado']; // pago.php (cajero)
        $_SESSION['rol'] = $encontrado['rol'];                    // menu-cabecera.php (tieneRol)
        $_SESSION['nombreEmpleado'] = $encontrado['nombreEmpleado'];

        echo json_encode([
            "estado" => true,
            "datos" => [
                "nombreEmpleado" => $encontrado['nombreEmpleado'],
                "rol" => $encontrado['rol']
            ]
        ], JSON_UNESCAPED_UNICODE);
    } catch (Throwable $e) {
        echo json_encode([
            "estado" => false,
            "mensaje" => "No se pudo iniciar sesión: " . $e->getMessage()
        ], JSON_UNESCAPED_UNICODE);
    }
}
