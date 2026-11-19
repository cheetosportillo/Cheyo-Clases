<?php
session_start();

// Eliminar todas las variables de sesión
$_SESSION = [];

// Destruir la sesión
session_destroy();

// Redireccionar
header("Location: ../login.php");
exit();