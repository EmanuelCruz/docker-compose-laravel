#!/bin/bash

# Función para mostrar un mensaje de error y salir del script
function mostrar_error {
    echo "Error: $1" >&2  # Imprimir mensaje de error en stderr
    exit 1               # Salir con código de error 1
}

# Array para almacenar los comandos exitosos
exitosos=()

# Array para almacenar los comandos fallidos
fallidos=()

# Función para agregar comandos exitosos al array
function agregar_exitoso {
    exitosos+=("$1")
}

# Función para agregar comandos fallidos al array
function agregar_fallido {
    fallidos+=("$1")
}

# Función para ejecutar un comando y manejar el resultado
function ejecutar_comando {
    local comando="$1"
    local mensaje_exito="$2"
    local mensaje_fallo="$3"

    if eval "$comando"; then
        agregar_exitoso "$mensaje_exito"
    else
        agregar_fallido "$mensaje_fallo"
    fi
}

# Ejecutar comandos
ejecutar_comando "docker compose down" "Detener y borrar contenedores Docker" "Detener y borrar contenedores Docker (docker compose down)"
# ejecutar_comando "rm -rf src/node_modules" "Eliminar node_modules" "Eliminar node_modules (rm -rf src/node_modules)"
# ejecutar_comando "rm -rf src/vendor" "Eliminar vendor" "Eliminar vendor (rm -rf src/vendor)"
# Borrar contenido de carpeta de persistencia de MySQL
ejecutar_comando "rm -rf data/mysql/*" "Eliminar datos de MySQL" "Eliminar datos de MySQL (rm -rf data/mysql/*)"

# Mostrar resumen de ejecución
echo ""
echo "----------------------------------------------------------------------------------"
echo "Resumen de ejecución exitosa:"
echo "----------------------------------------------------------------------------------"
for exitoso in "${exitosos[@]}"; do
    echo "✔️  $exitoso"
done
echo "----------------------------------------------------------------------------------"
echo ""

# Mostrar resumen de comandos fallidos si existen
if [ ${#fallidos[@]} -gt 0 ]; then
    echo "----------------------------------------------------------------------------------"
    echo "Resumen de ejecución fallida:"
    echo "----------------------------------------------------------------------------------"
    for fallido in "${fallidos[@]}"; do
        echo "❌  $fallido"
    done
    echo "----------------------------------------------------------------------------------"
    exit 1  # Salir con código de error 1 si hay comandos fallidos
else
    echo "Todos los comandos se ejecutaron exitosamente."
fi
echo ""
