<?php
session_start();

if (!isset($_SESSION['autenticado']) || $_SESSION['autenticado'] !== true) {
  header("Location: ../login.php");
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

<!--begin::Third Party Plugin(OverlayScrollbars)-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.16.0/styles/overlayscrollbars.min.css"
  crossorigin="anonymous" />
<!--end::Third Party Plugin(OverlayScrollbars)-->

<!--begin::Third Party Plugin(Bootstrap Icons)-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css"
  crossorigin="anonymous" />
<!--end::Third Party Plugin(Bootstrap Icons)-->

<!--begin::Required Plugin(AdminLTE)-->
<link rel="stylesheet" href="../css/adminlte.css" />
<!--end::Required Plugin(AdminLTE)-->

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<!--end::Head-->

<!--begin::Body-->

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
  <div class="app-wrapper">
    <!--begin::Header-->
    <?php
    include "../menu-cabecera.php";
    include "../menu-lateral.php";
    ?>
    <!--end::Sidebar-->
    <main class="app-main">
      <div class="app-content-header">
        <div class="container-fluid">
          <div class="row">
            <div class="col-sm-6">
              <h3 class="mb-0">Panel Principal</h3>
            </div>
          </div>
        </div>
      </div>
      <div class="app-content">
        <div class="container-fluid">
          <div class="row">
            <div class="col-12 col-md-4">
              <div class="info-box">
                <span class="info-box-icon text-bg-success shadow-sm">
                  <i class="bi bi-currency-dollar"></i>
                </span>
                <div class="info-box-content">
                  <span class="info-box-text">Pagos recibidos este mes</span>
                  <span class="info-box-number" id="sumaMensual">$0.00</span>
                </div>
              </div>
            </div>
            <div class="col-12 col-md-4">
              <div class="info-box">
                <span class="info-box-icon text-bg-warning shadow-sm">
                  <i class="bi bi-receipt"></i>
                </span>
                <div class="info-box-content">
                  <span class="info-box-text">Recibos pendientes de pago</span>
                  <span class="info-box-number" id="pendientesPago">0</span>
                </div>
              </div>
            </div>
            <div class="col-12 col-md-4">
              <div class="info-box">
                <span class="info-box-icon text-bg-primary shadow-sm">
                  <i class="bi bi-people-fill"></i>
                </span>
                <div class="info-box-content">
                  <span class="info-box-text">Socios registrados</span>
                  <span class="info-box-number" id="numeroSocio">0</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
    <!--begin::Footer-->
    <?php
    include "../pie.php";
    ?>
    <!--end::Footer-->
  </div>

  <!--begin::Third Party Plugin(OverlayScrollbars)-->
  <script src="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.16.0/browser/overlayscrollbars.browser.es6.min.js"
    crossorigin="anonymous"></script>
  <!--end::Third Party Plugin(OverlayScrollbars)-->
  <!--begin::Required Plugin(popperjs for Bootstrap 5)-->
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" crossorigin="anonymous">
  </script>
  <!--end::Required Plugin(popperjs for Bootstrap 5)-->
  <!--begin::Required Plugin(Bootstrap 5)-->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js" crossorigin="anonymous">
  </script>
  <!--end::Required Plugin(Bootstrap 5)-->
  <!--begin::Required Plugin(AdminLTE)-->
  <script src="../js/adminlte.js"></script>
  <!--end::Required Plugin(AdminLTE)-->
  <!--begin::OverlayScrollbars Configure-->
  <script src="../js/para-el-menu.js"></script>
  <!--end::OverlayScrollbars Configure-->
  <script src="../js/JSIndex.js?v=<?php echo filemtime('../js/JSIndex.js'); ?>"></script>
</body>

</html>
