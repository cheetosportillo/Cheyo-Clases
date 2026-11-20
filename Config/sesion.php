<?php
// Se incluye al INICIO de cada página protegida (antes de cualquier HTML):
//   <?php require_once "../Config/sesion.php"; ?>
// Inicia la sesión y manda al login si el usuario no está autenticado.
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (!isset($_SESSION['autenticado']) || $_SESSION['autenticado'] !== true) {
    header("Location: ../login.php");
    exit();
}
