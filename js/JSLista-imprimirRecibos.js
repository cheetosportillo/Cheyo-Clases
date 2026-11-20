//////////PROCESA AL TERMINAR DE CARGAR LA PAGINA
document.addEventListener("DOMContentLoaded", async () => {
    const contenedor = document.getElementById("users-table");
    const filtro = document.getElementById("table-filter");
    const paginacion = document.getElementById("table-pagination");
    const btnGenerar = document.getElementById("btnGenerar");

    const contador = document.getElementById("total-registros");

    if (!contenedor) return;
    const tabla = new Tabulator(contenedor, {
        locale: "es-es",
        langs: {
            "es-es": {
                "pagination": {
                    "page_size": "Registros por página",
                    "first": "Primera",
                    "first_title": "Primera página",
                    "last": "Última",
                    "last_title": "Última página",
                    "prev": "Anterior",
                    "prev_title": "Página anterior",
                    "next": "Siguiente",
                    "next_title": "Página siguiente",
                    "all": "Todos",
                    "counter": {
                        "showing": "Mostrando",
                        "of": "de",
                        "rows": "registros",
                        "pages": "páginas"
                    }
                },
                "data": {
                    "loading": "Cargando...",
                    "error": "Error al cargar los datos"
                },
                "headerFilters": {
                    "default": "Filtrar columna..."
                }
            }
        },
        data: [],
        layout: "fitColumns",
        pagination: true,
        paginationElement: paginacion,
        paginationSize: 10,
        paginationSizeSelector: [10, 25, 50, 100],
        movableColumns: true,
        columns: [
            {
                title: "Seleccionar",
                formatter: "rowSelection",
                hozAlign: "center",
                headerSort: false,
                width: 60,
                cellClick: function (e, cell) {
                    cell.getRow().toggleSelect();
                },
                titleFormatter: function () {
                    return `<input type="checkbox" id="seleccionar-todos">`;
                }
            },
            { title: "ID", field: "idrecibos", visible: false },
            { title: "N° Recibo", field: "nrecibo" },
            { title: "N° Medidor", field: "nmedidor" },
            { title: "Periodo", field: "periodo" },
            { title: "Cantón", field: "nombreCanton" },
            { title: "RUTA", field: "nombreRuta" },
            { title: "Fecha Lectura", field: "fecha_lectura" },
            { title: "Fecha Vencimiento", field: "fecha_vencimiento" },
            { title: "Lectura Act.", field: "lectura_actual", hozAlign: "center" },
            { title: "Lectura Ant.", field: "lectura_anterior", hozAlign: "center" },
            { title: "Consumo m3", field: "metros", hozAlign: "center" },
            { title: "Monto ($)", field: "monto", hozAlign: "right" }
        ]
    });



    function actualizarContador() {
        const total = tabla.getDataCount("active");
        contador.textContent = `Total de Registros: ${total}`;
    }

    tabla.on("dataLoaded", actualizarContador);
    tabla.on("dataFiltered", actualizarContador);
    tabla.on("dataChanged", actualizarContador);
    tabla.on("dataFiltered", function (filters, filas) {
        contador.textContent = `Total de Registros: ${filas.length}`;
    });

    tabla.on("tableBuilt", function () {
        document.addEventListener("change", function (e) {
            if (e.target.id === "seleccionar-todos") {
                const filas = tabla.getRows("active");
                if (e.target.checked) {
                    filas.forEach(fila => fila.select());
                } else {
                    filas.forEach(fila => fila.deselect());
                }
            }
        });
    });

    try {

        Swal.fire({
            title: "Cargando...",
            text: "Espere",
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: () => Swal.showLoading()
        });

        const datos = new FormData();
        datos.append("opcion", "consultar");

        const respuesta = await fetch("DAOImprimirRecibos.php", {
            method: "POST",
            body: datos
        });

        if (!respuesta.ok) {
            throw new Error("Error HTTP: " + respuesta.status);
        }

        const registros = await respuesta.json();
        Swal.close();

        if (!Array.isArray(registros)) {
            throw new Error(registros.error || "Respuesta no válida");
        }

        await tabla.replaceData(registros);
        actualizarContador();

    } catch (error) {
        console.error("Error al cargar registros:", error);
        contenedor.textContent = "No se pudieron cargar los registros.";
    }

    if (filtro) {
        filtro.addEventListener("input", () => {

            // Limpiar registros seleccionados
            tabla.deselectRow();

            // Desmarcar seleccionar todos
            const seleccionarTodos = document.getElementById("seleccionar-todos");

            if (seleccionarTodos) {
                seleccionarTodos.checked = false;
            }

            const valor = filtro.value.trim();

            if (!valor) {
                tabla.clearFilter();
                return;
            }

            tabla.setFilter([
                [
                    { field: "nmedidor", type: "like", value: valor },
                    { field: "nmedidor", type: "like", value: valor },
                    { field: "fecha_lectura", type: "like", value: valor },
                    { field: "fecha_vencimiento", type: "like", value: valor },
                    { field: "nombreCanton", type: "like", value: valor },
                    { field: "nombreRuta", type: "like", value: valor },
                    { field: "nrecibo", type: "like", value: valor }
                ]
            ]);

        });
    }


    btnGenerar?.addEventListener("click", async () => {

        // Obtener registros seleccionados
        const seleccionados = tabla.getSelectedData();

        if (seleccionados.length === 0) {
            Swal.fire({
                icon: "warning",
                title: "Atención",
                text: "Debe seleccionar al menos un RECIBO."
            });
            return;
        }

        // Obtener solamente los ID de consumo
        const ids = seleccionados.map(item => item.idrecibos);

        const confirmar = await Swal.fire({
            title: "¿Generar recibos?",
            text: `Se imprimirán ${ids.length} recibos.`,
            icon: "question",
            showCancelButton: true,
            confirmButtonText: "Sí, generar",
            cancelButtonText: "Cancelar"
        });

        if (!confirmar.isConfirmed) return;
        try {
            Swal.fire({
                title: "Imprimiendo RECIBOS...",
                text: "Espere",
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => Swal.showLoading()
            });

            // Obtener únicamente los campos necesarios
            const datosRecibos = seleccionados.map(item => ({
                idrecibos: item.idrecibos,
                metros: item.metros,
                monto: item.monto
            }));

            const datos = new FormData();

            datos.append("opcion", "imprimir");
            datos.append("recibos", JSON.stringify(datosRecibos));

            const respuesta = await fetch("DAOImprimirRecibos.php", {
                method: "POST",
                body: datos
            });

            const resultado = await respuesta.json();
            //console.log(resultado);
            Swal.close();

            console.log(resultado);

            if (resultado.estado) {

                const recibos = resultado.recibos;
                const ventana = window.open("", "_blank");

                console.log(recibos);

                // Aquí generamos el documento de impresión
                imprimirRecibos(resultado.recibos, ventana);

            } else {

                Swal.fire({
                    icon: "error",
                    title: "Poseidón",
                    text: resultado.mensaje
                });
            }

        } catch (error) {
            console.error("Error:", error);
        }
    });

});

function imprimirRecibos(recibos, ventana) {

    if (!ventana) {
        Swal.fire("Atención", "Permita las ventanas emergentes para imprimir.", "warning");
        return;
    }

    let html = `
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Facturas POSEIDON</title>

    <style>
        @page {
            size: letter;
            margin: 8mm;
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 11px;
            margin: 0;
            color: #000;
        }

        .pagina {
            height: 255mm;
            display: flex;
            flex-direction: column;
            justify-content: space-around;
            page-break-after: always;
            break-after: page;
        }

        .pagina:last-child {
            page-break-after: auto;
            break-after: auto;
        }

        .factura {
            width: 100%;
            height: 120mm;
            overflow: hidden;
            padding: 5mm;
            box-sizing: border-box;
        }

        /* ENCABEZADO */

        .encabezado {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .empresa {
            width: 60%;
        }

        .empresa h1 {
            font-family: "Times New Roman", serif;
            font-size: 21px;
            margin: 0 0 8px 30px;
        }

        .direccion-empresa {
            font-size: 8px;
            margin: 0;
        }

        .cuenta {
            width: 40%;
            text-align: right;
            padding-right: 5px;
            padding-top: 25px;
        }

        .cuenta .titulo {
            font-size: 12px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .cuenta .numero {
            font-size: 20px;
            font-weight: bold;
        }

        /* LECTURAS */

        .lecturas {
            width: 220px;
            margin-left: auto;
            margin-top: 12px;
            margin-bottom: 5px;
        }

        .fila {
            display: flex;
            justify-content: space-between;
            line-height: 15px;
        }

        .valor {
            width: 65px;
            text-align: right;
            padding-right: 4px;
        }

        /* BARRAS */

        .barra {
            background-color: #595959;
            color: #fff;
            text-align: center;
            font-weight: bold;
            font-size: 11px;
            height: 18px;
            line-height: 18px;
            margin-bottom: 3px;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        /* DATOS DEL RECEPTOR */

        .informacion {
            margin-bottom: 12px;
        }

        .datos-receptor {
            display: grid;
            grid-template-columns: 58% 42%;
        }

        .datos-izquierda p,
        .datos-derecha p {
            margin: 0;
            line-height: 16px;
        }

        .nombre {
            display: flex;
            gap: 5px;
        }

        .nombre .etiqueta {
            min-width: 75px;
        }

        .direccion-receptor {
            display: grid;
            grid-template-columns: 75px 1fr;
            gap: 5px;
            margin-top: 17px;
        }

        /* DESCRIPCIÓN DEL COBRO */

        .tabla-cobro {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .tabla-cobro th {
            font-weight: normal;
            text-align: left;
            padding: 0 1px 2px;
            font-size: 11px;
        }

        .tabla-cobro td {
            padding: 0 1px;
            font-size: 11px;
            line-height: 16px;
        }

        .col-descripcion {
            width: 38%;
        }

        .col-cantidad {
            width: 10%;
            text-align: center !important;
        }

        .col-precio {
            width: 22%;
            text-align: center !important;
        }

        .col-total {
            width: 30%;
            text-align: right !important;
            padding-right: 4px !important;
        }

        /* TOTALES */

        .totales {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 35px;
        }

        .total-letras,
        .total-pagar {
            font-size: 11px;
        }

        .vencimiento {
            margin-top: 15px;
        }

        /* ORIGINAL Y COPIA */

        .tipo-factura {
            text-align: right;
            font-weight: bold;
            font-size: 10px;
            margin-bottom: 3px;
        }

        /* LÍNEA DE CORTE */

        .separador {
            border-top: 1px dashed #777;
            margin: 0;
        }

        @media print {
            body {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
        }
    </style>
</head>

<body>
`;

    recibos.forEach(recibo => {

        // Datos que pueden utilizarse en ambos ejemplares

        const hoy = new Date();

        const anio = hoy.getFullYear();
        const mes = String(hoy.getMonth() + 1).padStart(2, '0');
        const dia = String(hoy.getDate()).padStart(2, '0');

        const fechaFormateada = `${dia}/${mes}/${anio}`;


        const datos = {
            cuenta: recibo.nmedidor ?? "107000947",
            lecturaAnterior: recibo.lectura_anterior ?? 1360,
            lecturaActual: recibo.lectura_actual ?? 1370,
            consumo: recibo.metros ?? 10,
            desde: recibo.desde ?? restarDias(recibo.fecha_lectura, recibo.dias ?? 30),
            hasta: recibo.fecha_lectura ?? "22/10/2026",
            dias: recibo.dias ?? 30,
            mes: recibo.periodo ?? "10-2026",
            ruta: recibo.nombreRuta ?? "Ruta 1",
            emision: recibo.emision ?? fechaFormateada,
            canton: recibo.nombreCanton ?? "El Carmen",
            nombreSocio: recibo.nombreSocio ?? "Eliseo Eulises Romero Ayala",
            direccion: recibo.direccion ??
                "Final 1 calle oriente, san esteban catarina",
            precio: Number(recibo.monto ?? 0.21),
            precio_unitario: Number(recibo.precio_unitario ?? 0.21),
            vencimiento: recibo.fecha_vencimiento ?? "25/10/2026",
            nrecibo: recibo.nrecibo ?? "2026-00000"
        };

        const consumo = Number(datos.consumo);
        const total = Number(datos.precio);
        const unitario = Number(datos.precio_unitario);

        // Cuota fija (hasta 10 m3): el total no es consumo x precio unitario
        const esCuotaFija = Math.abs(consumo * unitario - total) > 0.005;
        const descripcion = esCuotaFija ? "CUOTA FIJA POR CONSUMO DE AGUA" : "COBRO POR M3 CONSUMIDO";
        const cantidad = esCuotaFija ? 1 : consumo;
        const precioLinea = esCuotaFija ? total : unitario;

        // Un mismo recibo se imprime dos veces: ORIGINAL y COPIA
        const ejemplar = (tipo) => `
        <div class="factura">
            <div class="tipo-factura">${tipo}</div>

            <div class="encabezado">
                <div class="empresa">
                    <div style="display:flex; align-items:flex-start; gap:60px;">
                        <h1>POSEIDON</h1>
                        <div style="text-align:center;">
                            <div style="font-size:20px; font-weight:bold; font-family:'Times New Roman', serif;">${esc(datos.nrecibo)}</div>
                            <div style="font-size:8px;">N° de Recibo</div>
                        </div>
                    </div>
                    <p class="direccion-empresa">Dirección: Final Av. El Carmen, San Esteban Catarina</p>
                </div>

                <div class="cuenta">
                    <div class="titulo">Numero de Cuenta</div>
                    <div class="numero">${esc(datos.cuenta)}</div>
                </div>
            </div>

            <div class="lecturas">
                <div class="fila"><span>Lectura Anterior:</span><span class="valor">${esc(datos.lecturaAnterior)}</span></div>
                <div class="fila"><span>Lectura Actual:</span><span class="valor">${esc(datos.lecturaActual)}</span></div>
                <div class="fila"><span>Consumo</span><span class="valor">${esc(consumo)}</span></div>
            </div>

            <div class="informacion">
                <div class="barra">INFORMACION DEL RECEPTOR</div>
                <div class="datos-receptor">
                    <div class="datos-izquierda">
                        <p>Facturado desde: ${esc(datos.desde)}</p>
                        <p>Facturado hasta: ${esc(datos.hasta)}</p>
                        <p>Dias Facturados: ${esc(datos.dias)}</p>
                        <p>Mes Facturado: ${esc(datos.mes)}</p>
                        <p>RUTA: ${esc(datos.ruta)}</p>
                        <p>Fecha de Emisión: ${esc(datos.emision)}</p>
                        <p>Canton: ${esc(datos.canton)}</p>
                    </div>
                    <div class="datos-derecha">
                        <p class="nombre"><span class="etiqueta">Nombre:</span><span>${esc(datos.nombreSocio)}</span></p>
                        <div class="direccion-receptor">
                            <span>Dirección:</span>
                            <span>${esc(datos.direccion)}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="barra">DESCRIPCION DEL COBRO</div>
            <table class="tabla-cobro">
                <thead>
                    <tr>
                        <th class="col-descripcion">Descripcion</th>
                        <th class="col-cantidad">Cant.</th>
                        <th class="col-precio">Precio Unitario</th>
                        <th class="col-total">Total:</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="col-descripcion">${descripcion}</td>
                        <td class="col-cantidad">${cantidad}</td>
                        <td class="col-precio">$${precioLinea.toFixed(2)}</td>
                        <td class="col-total">$${total.toFixed(2)}</td>
                    </tr>
                </tbody>
            </table>

            <div class="totales">
                <div class="total-letras">Total en letras: ${numeroALetras(total)}</div>
                <div class="total-pagar">Total a Pagar: $${total.toFixed(2)}</div>
            </div>

            <div class="vencimiento">
                <div>Fecha de Vencimiento: ${esc(datos.vencimiento)}</div>
                <div>Avisos: Aqui va el Aviso para el cliente</div>
            </div>
        </div>`;

        html += `
    <div class="pagina">
        ${ejemplar("ORIGINAL - CLIENTE")}
        <div class="separador"></div>
        ${ejemplar("COPIA INSTITUCION")}
    </div>`;
    });

    html += `
</body>
</html>`;

    ventana.document.open();
    ventana.document.write(html);
    ventana.document.close();

    // Se espera a que cargue el documento y se abre el cuadro de impresión
    ventana.onload = () => {
        ventana.focus();
        ventana.print();
    };
}

/////////////// UTILIDADES DEL RECIBO ///////////////

// Evita que un texto con < > & rompa el HTML del recibo
function esc(valor) {
    return String(valor ?? "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;");
}

// "05/09/2026" menos 30 dias -> "06/08/2026"
function restarDias(fecha, dias) {
    const partes = String(fecha ?? "").split("/");

    if (partes.length !== 3) return "";

    const f = new Date(Number(partes[2]), Number(partes[1]) - 1, Number(partes[0]));
    f.setDate(f.getDate() - Number(dias));

    const dd = String(f.getDate()).padStart(2, "0");
    const mm = String(f.getMonth() + 1).padStart(2, "0");

    return `${dd}/${mm}/${f.getFullYear()}`;
}

// 2.31 -> "DOS con 31/100"
function numeroALetras(valor) {
    const unidades = ["", "UN", "DOS", "TRES", "CUATRO", "CINCO", "SEIS", "SIETE", "OCHO", "NUEVE",
        "DIEZ", "ONCE", "DOCE", "TRECE", "CATORCE", "QUINCE", "DIECISEIS", "DIECISIETE",
        "DIECIOCHO", "DIECINUEVE", "VEINTE", "VEINTIUN", "VEINTIDOS", "VEINTITRES",
        "VEINTICUATRO", "VEINTICINCO", "VEINTISEIS", "VEINTISIETE", "VEINTIOCHO", "VEINTINUEVE"];
    const decenas = ["", "", "", "TREINTA", "CUARENTA", "CINCUENTA", "SESENTA", "SETENTA", "OCHENTA", "NOVENTA"];
    const centenas = ["", "CIENTO", "DOSCIENTOS", "TRESCIENTOS", "CUATROCIENTOS", "QUINIENTOS",
        "SEISCIENTOS", "SETECIENTOS", "OCHOCIENTOS", "NOVECIENTOS"];

    function menorMil(n) {
        if (n === 0) return "";
        if (n === 100) return "CIEN";

        const c = Math.floor(n / 100);
        const r = n % 100;
        let texto = centenas[c];

        if (r > 0) {
            if (r < 30) {
                texto += (texto ? " " : "") + unidades[r];
            } else {
                const d = Math.floor(r / 10);
                const u = r % 10;
                texto += (texto ? " " : "") + decenas[d] + (u > 0 ? " Y " + unidades[u] : "");
            }
        }

        return texto.trim();
    }

    const numero = Math.round(Number(valor) * 100) / 100;
    const enteros = Math.floor(numero);
    const centavos = String(Math.round((numero - enteros) * 100)).padStart(2, "0");

    let letras;

    if (enteros === 0) {
        letras = "CERO";
    } else if (enteros < 1000) {
        letras = menorMil(enteros);
    } else {
        const miles = Math.floor(enteros / 1000);
        const resto = enteros % 1000;
        const textoMiles = miles === 1 ? "MIL" : menorMil(miles) + " MIL";
        letras = textoMiles + (resto > 0 ? " " + menorMil(resto) : "");
    }

    // "UN" solo al final se dice "UNO" (21 -> VEINTIUNO)
    letras = letras.replace(/UN$/, "UNO");

    return `${letras} con ${centavos}/100`;
}
