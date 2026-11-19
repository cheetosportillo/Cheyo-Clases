<?php
session_start();

if (!isset($_SESSION['autenticado']) || $_SESSION['autenticado'] = false) {
  header("Location: login.php");
  exit();
}


?>
<!doctype html>
<html lang="en">
<!--begin::Head-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sistema de Agua - POSEIDÓN</title>

<!--begin::Theme Init (prevents flash of incorrect theme on load, #6043)-->
<script src="../js/color-thema.js"></script>
<!--end::Theme Init-->

<!--begin::Accessibility Meta Tags-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />
<meta name="color-scheme" content="light dark" />
<meta name="theme-color" content="#007bff" media="(prefers-color-scheme: light)" />
<meta name="theme-color" content="#1a1a1a" media="(prefers-color-scheme: dark)" />
<!--end::Accessibility Meta Tags-->

<!--begin::Primary Meta Tags-->
<meta name="title" content="Sistema de Agua - POSEIDÓN" />
<meta name="description" content="Sistema Administrativo y Financiero de Agua" />
<meta name="keywords" content="bootstrap 5, poseidon, agua potable, Sistema Administrativo y Financiero de Agua" />
<!--end::Primary Meta Tags-->

<!--begin::Accessibility Features-->
<!-- Skip links will be dynamically added by accessibility.js -->
<meta name="supported-color-schemes" content="light dark" />
<link rel="preload" href="../css/adminlte.css" as="style" />
<!--end::Accessibility Features-->

<!--begin::Fonts-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fontsource/source-sans-3@5.3.0/index.css"
  integrity="sha256-5UwXtC6TaPHCAbVQ59waEAqOssHyhn/twyuLRRWszz0=" crossorigin="anonymous" media="print" onload="this.media = 'all'" />
<!--end::Fonts-->