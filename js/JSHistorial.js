document.addEventListener("DOMContentLoaded", async () => {
    const contenedor = document.getElementById("users-table");
    const filtro = document.getElementById("table-filter");
    const paginacion = document.getElementById("table-pagination");
    const contador = document.getElementById("total-registros");
    const btnImprimir = document.getElementById("print-table");
    const numeroMedidor = document.getElementById("numero-medidor");

    if (!contenedor) return;

    // El id del medidor llega por la URL: historial.php?id=4
    const parametros = new URLSearchParams(window.location.search);
    const idmedidor = parametros.get("id");

    const tabla = new Tabulator(contenedor, {
        locale: "es-es",
        langs: {
            "es-es": {
                pagination: {
                    page_size: "Registros por página",
                    first: "Primera",
                    first_title: "Primera página",
                    last: "Última",
                    last_title: "Última página",
                    prev: "Anterior",
                    prev_title: "Página anterior",
                    next: "Siguiente",
                    next_title: "Página siguiente",
                    all: "Todos",
                    counter: {
                        showing: "Mostrando",
                        of: "de",
                        rows: "registros",
                        pages: "páginas"
                    }
                },
                data: {
                    loading: "Cargando...",
                    error: "Error al cargar los datos"
                },
                headerFilters: {
                    default: "Filtrar columna..."
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
            { title: "Corr.", field: "correlativo", visible: true },
            { title: "Periodo", field: "periodo", hozAlign: "center" },
            { title: "F. Lectura", field: "fecha_lectura", hozAlign: "center" },
            { title: "F. Vencimiento", field: "fecha_vencimiento", hozAlign: "center" },
            { title: "Lectura Actual", field: "lectura_actual", hozAlign: "center" },
            { title: "Lectura Ant.", field: "lectura_anterior", hozAlign: "center" },
            { title: "Consumo m3", field: "metros", hozAlign: "center" },
            { title: "Monto ($)", field: "monto", hozAlign: "right" },
            {
                title: "Estado", field: "estado", hozAlign: "center", headerSort: false,
                formatter: function (cell) {
                    const pagado = cell.getValue();

                    if (pagado === "PAGADO") {
                        return `<span style="color: green; font-size: 20px;" title="PAGADO">
                                    <i class="bi bi-check-circle-fill"></i>
                                </span>`;
                    } else if (pagado === "PENDIENTE") {
                        return `<span style="color: red; font-size: 20px;" title="PENDIENTE">
                                    <i class="bi bi-x-circle-fill"></i>
                                </span>`;
                    }

                    return pagado ?? "";
                }
            }
        ]
    });

    const actualizarContador = () => {
        contador.textContent = `Total de Registros: ${tabla.getDataCount("active")}`;
    };

    tabla.on("dataLoaded", actualizarContador);
    tabla.on("dataFiltered", actualizarContador);
    tabla.on("dataChanged", actualizarContador);

    async function llamarDAO(datos) {
        const respuesta = await fetch("DAOHistorial.php", { method: "POST", body: datos });
        if (!respuesta.ok) {
            throw new Error("Error HTTP: " + respuesta.status);
        }
        return await respuesta.json();
    }

    if (!idmedidor) {
        contenedor.textContent = "No se indicó el medidor.";
        return;
    }

    try {
        Swal.fire({
            title: "Cargando...",
            text: "Espere",
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: () => Swal.showLoading()
        });

        // Numero del medidor para el titulo
        const datosMedidor = new FormData();
        datosMedidor.append("opcion", "consultarMedidor");
        datosMedidor.append("idmedidor", idmedidor);
        const medidor = await llamarDAO(datosMedidor);
        numeroMedidor.textContent = medidor.numero_medidor ?? "";

        // Historial de lecturas
        const datos = new FormData();
        datos.append("opcion", "consultar");
        datos.append("idmedidor", idmedidor);
        const registros = await llamarDAO(datos);

        if (!Array.isArray(registros)) {
            throw new Error(registros.mensaje || "Respuesta no válida");
        }

        await tabla.replaceData(registros);
        actualizarContador();
    } catch (error) {
        console.error("Error al cargar el historial:", error);
        contenedor.textContent = "No se pudo cargar el historial de lecturas.";
        await Swal.fire("No se pudo cargar el historial", error.message, "error");
    } finally {
        Swal.close();
    }

    filtro?.addEventListener("input", () => {
        const valor = filtro.value.trim();
        if (!valor) {
            tabla.clearFilter();
            return;
        }

        tabla.setFilter([
            [
                { field: "periodo", type: "like", value: valor },
                { field: "fecha_lectura", type: "like", value: valor },
                { field: "fecha_vencimiento", type: "like", value: valor },
                { field: "lectura_actual", type: "like", value: valor },
                { field: "lectura_anterior", type: "like", value: valor },
                { field: "metros", type: "like", value: valor },
                { field: "monto", type: "like", value: valor },
                { field: "estado", type: "like", value: valor }
            ]
        ]);
    });

    btnImprimir?.addEventListener("click", () => window.print());
});
