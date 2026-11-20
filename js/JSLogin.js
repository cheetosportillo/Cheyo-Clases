function validarCampo(campo) {
    const vacio = campo.value.trim() === "";
    campo.classList.toggle("is-invalid", vacio);
    campo.classList.toggle("is-valid", !vacio);

    return !vacio;
}

const formulario = document.getElementById("formulario");
const btnEntrar = document.getElementById("btnEntrar");
const loginUsuario = document.getElementById("loginUsuario");
const loginClave = document.getElementById("loginClave");

const campos = [loginUsuario, loginClave];

if (formulario) {
    ///////////////////VALIDACION DE CAMPOS VACIOS

    campos.forEach(function (campo) {
        campo.addEventListener("blur", function () {
            validarCampo(campo);
        });
    });

    ///////////////////BOTON GUARDAR ////////////////
    btnEntrar.addEventListener("click", async function () {
        const usuarioValido = validarCampo(loginUsuario);
        const claveValido = validarCampo(loginClave);

        if (usuarioValido && claveValido) {
            try {
                const datos = new FormData(formulario);
                datos.append("opcion", "consultar");

                btnEntrar.disabled = true;
                btnEntrar.textContent = "Procesando...";

                // Enviar datos
                // await hace que JavaScript ESPERE
                const respuesta = await fetch("DAOLogin.php", {
                    method: "POST",
                    body: datos
                });

                // Verificar respuesta HTTP
                if (!respuesta.ok) {
                    throw new Error("Error HTTP: " + respuesta.status);
                }

                // Esperar a que DAO termine
                const resultado = await respuesta.json();
                if (resultado.estado) {
                    //todo salio bien
                    Swal.fire({
                        position: "top-end",
                        icon: "success",
                        title: "Poseidón",
                        text: "Bienvenido " + resultado.datos.nombreEmpleado,
                        showConfirmButton: false,
                        timer: 1500
                    }).then(() => {//cuando desaparece el mensaje se recarga la pagina
                        window.location.href = "index.php";
                    });

                } else {
                    Swal.fire({
                        position: "top-end",
                        icon: "info",
                        title: "Poseidón",
                        text: resultado.mensaje,
                        showConfirmButton: false,
                        timer: 1500
                    });
                }
            } catch (error) {
                console.error(error);
                Swal.fire({
                    position: "top-end",
                    icon: "error",
                    title: "Poseidón",
                    text: "No se pudo iniciar sesión, intente de nuevo",
                    showConfirmButton: false,
                    timer: 1500
                });
            } finally {
                btnEntrar.disabled = false;
                btnEntrar.textContent = "Entrar";
            }
        }
    });

    // Enter en cualquiera de los dos campos equivale a presionar "Entrar"
    campos.forEach(function (campo) {
        campo.addEventListener("keydown", function (e) {
            if (e.key === "Enter") {
                e.preventDefault();
                btnEntrar.click();
            }
        });
    });
}
