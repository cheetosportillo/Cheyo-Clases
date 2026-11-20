const cerrarSesion = document.getElementById("cerrarSesion");
const sumaMensual = document.getElementById("sumaMensual");
const pendientesPago = document.getElementById("pendientesPago");
const numeroSocio = document.getElementById("numeroSocio");

cerrarSesion?.addEventListener("click", function (e) {
    e.preventDefault();

    Swal.fire({
        title: '¿Cerrar sesión?',
        text: '¿Estás seguro que deseas salir del sistema?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Sí, cerrar sesión',
        cancelButtonText: 'Cancelar'
    }).then((result) => {

        if (result.isConfirmed) {
            window.location.href = 'Salir.php';
        }

    });
});

document.addEventListener("DOMContentLoaded", async () => {

    try {
        const datos = new FormData();
        datos.append("opcion", "consulta");

        Swal.fire({
            title: "Consultando...",
            text: "Espere",
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: () => Swal.showLoading()
        });

        const respuesta = await fetch("DAOIndex.php", {
            method: "POST",
            body: datos
        });

        if (!respuesta.ok) {
            console.error(respuesta.status);
            throw new Error("Error HTTP: " + respuesta.status);
        }

        const resultado = await respuesta.json();

        // Cerrar el mensaje de espera
        Swal.close();

        if (resultado.estado) {
            sumaMensual.innerHTML="$"+resultado.sumaMensual;
            pendientesPago.innerHTML=resultado.pendientesPago;
            numeroSocio.innerHTML=resultado.numeroSocio;
        }

    } catch (error) {
        Swal.close();
    }
});