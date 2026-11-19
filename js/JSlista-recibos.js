///////////PROCESA AL TERMINAR DE CARGAR LA PAGINA
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
            { title: "ID", field: "idconsumo", visible: false },
            { title: "N° Medidor", field: "nmedidor" },
            { title: "Periodo", field: "periodo" },
            { title: "Cantón", field: "nombreCanton" },
            { title: "RUTA", field: "nombreRuta" },
            { title: "Fecha Lectura", field: "fecha_lectura" },
            { title: "Fecha Vencimiento", field: "fecha_vencimiento" },
            { title: "Lectura Act.", field: "lectura_actual", hozAlign: "center" },
            { title: "Lectura Ant.", field: "lectura_anterior", hozAlign: "center" },
            { title: "Consumo m3", field: "metros", hozAlign: "center" },
            { title: "Precio U. ($)", field: "precio_unitario", hozAlign: "center" },
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

        const respuesta = await fetch("DAORecibos.php", {
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
                    { field: "nombreRuta", type: "like", value: valor }
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
                text: "Debe seleccionar al menos un consumo."
            });
            return;
        }

        // Obtener solamente los ID de consumo
        const ids = seleccionados.map(item => item.idconsumo);

        const confirmar = await Swal.fire({
            title: "¿Generar recibos?",
            text: `Se generarán ${ids.length} recibos.`,
            icon: "question",
            showCancelButton: true,
            confirmButtonText: "Sí, generar",
            cancelButtonText: "Cancelar"
        });

        if (!confirmar.isConfirmed) return;
        try {
            Swal.fire({
                title: "Generando Número de Recibos...",
                text: "Espere",
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => Swal.showLoading()
            });

            // Obtener únicamente los campos necesarios
            const datosRecibos = seleccionados.map(item => ({
                idconsumo: item.idconsumo,
                metros: item.metros,
                monto: item.monto,
                precio_unitario: item.precio_unitario
            }));

            const datos = new FormData();

            datos.append("opcion", "generar");
            datos.append("recibos", JSON.stringify(datosRecibos));

            const respuesta = await fetch("DAORecibos.php", {
                method: "POST",
                body: datos
            });

            const resultado = await respuesta.json();
            //console.log(resultado);
            Swal.close();

            console.log(resultado);

            if (resultado.estado) {
                //todo salio bien
                Swal.fire({
                    position: "top-end",
                    icon: "success",
                    title: "Poseidón",
                    text: resultado.mensaje,
                    showConfirmButton: false,
                    timer: 2500
                }).then(() => {//cuando desaparece el mensaje se recarga la pagina
                    window.location.href = "lista-recibos.php";
                });

            } else {
                Swal.fire({
                    position: "top-end",
                    icon: "info",
                    title: "Poseidón",
                    text: resultado.mensaje,
                    showConfirmButton: false,
                    timer: 2000
                });
            }

        } catch (error) {
            console.error("Error:", error);
        }
    });

});