<?php
session_start();

// Antes decía "= false" (asignación): eso borraba la sesión en cada visita.
if (!isset($_SESSION['autenticado']) || $_SESSION['autenticado'] !== true) {
    header("Location: login.php");
    exit();
}

header("Location: forms/index.php");
exit();
