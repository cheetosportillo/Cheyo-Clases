<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="color-scheme" content="light dark" />
  <title>Sistema de Agua - POSEIDÓN</title>
  <script src="../js/color-thema.js"></script>
  <link rel="preload" href="../css/adminlte.css" as="style" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fontsource/source-sans-3@5.3.0/index.css" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.16.0/styles/overlayscrollbars.min.css" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css" crossorigin="anonymous" />
  <link rel="stylesheet" href="../css/adminlte.css" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tabulator-tables@6.6.1/dist/css/tabulator_bootstrap5.min.css" crossorigin="anonymous" />
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <style>
    .numero-medidor {
      display: inline-block;
      font-size: 24px;
      font-weight: bold;
      color: #0d6efd;
      background-color: #e7f1ff;
      padding: 8px 16px;
      border: 2px solid #0d6efd;
      border-radius: 8px;
      margin: 5px 0;
    }
  </style>
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
  <div class="app-wrapper">
    <?php
    include "../menu-cabecera.php";
    include "../menu-lateral.php";
    ?>
    <main class="app-main">
      <div class="app-content-header">
        <div class="container-fluid">
          <div class="row"></div>
        </div>
      </div>
      <div class="app-content">
        <div class="container-fluid">
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Historial de Lecturas - Medidor: <span class="numero-medidor" id="numero-medidor"></span></h3>
              <div class="card-tools">
                <div class="input-group input-group-sm" style="width: 16rem">
                  <span class="input-group-text">
                    <i class="bi bi-search" aria-hidden="true"></i>
                  </span>
                  <input id="table-filter" type="search" class="form-control" placeholder="Filtrar por..." aria-label="Filtrar por..." />
                </div>
              </div>
            </div>
            <div class="card-body">
              <div class="d-flex gap-2 mb-3">
                <button id="print-table" type="button" class="btn btn-sm btn-outline-secondary">
                  <i class="bi bi-printer me-1" aria-hidden="true"></i>
                  Imprimir
                </button>
              </div>
              <div id="users-table" aria-label="Historial de lecturas"></div>
              <div class="mt-2 text-end">
                <strong id="total-registros">Total de Registros: 0</strong>
              </div>
              <div id="table-pagination" class="d-flex flex-wrap gap-2 justify-content-end mt-2"></div>
            </div>
          </div>
        </div>
      </div>
    </main>
    <?php include "../pie.php"; ?>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/overlayscrollbars@2.16.0/browser/overlayscrollbars.browser.es6.min.js" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js" crossorigin="anonymous"></script>
  <script src="../js/adminlte.js"></script>
  <script src="../js/para-el-menu.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/tabulator-tables@6.6.1/dist/js/tabulator.min.js" crossorigin="anonymous"></script>
  <script src="../js/JSHistorial.js?v=<?php echo filemtime('../js/JSHistorial.js'); ?>"></script>
</body>
</html>
