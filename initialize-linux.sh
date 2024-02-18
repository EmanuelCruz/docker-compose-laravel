#!/bin/bash

# Verificar si el archivo .env existe y leer las variables UID y GID si está presente
# if [ -f .docker/.env ]; then
#   while IFS='=' read -r key value; do
#     if [[ $key == "USER_NAME" ]]; then
#       USER_NAME=$value
#     elif [[ $key == "GROUP_NAME" ]]; then
#       GROUP_NAME=$value
#     fi
#   done < .docker/.env
# fi

# USER_NAME=${USER_NAME}
# GROUP_NAME=${GROUP_NAME}

# Función para mostrar un mensaje de error y salir del script
function mostrar_error {
    echo "Error: $1" >&2  # Imprimir mensaje de error en stderr
    exit 1               # Salir con código de error 1
}

# Función para ejecutar un comando y manejar el resultado
function ejecutar_comando {
    local comando="$1"
    local mensaje_exitoso="$2"
    local mensaje_fallido="$3"

    if $comando; then
        agregar_exitoso "$mensaje_exitoso"
    else
        agregar_fallido "$mensaje_fallido"
    fi
}

# Función para agregar comandos exitosos al array
function agregar_exitoso {
    exitosos+=("$1")
}

# Función para agregar comandos fallidos al array
function agregar_fallido {
    fallidos+=("$1")
}

# Array para almacenar los comandos exitosos
exitosos=()

# Array para almacenar los comandos fallidos
fallidos=()

# Ejecutar comandos y verificar su código de salida
ejecutar_comando "docker compose up -d --build" "Construir contenedores Docker" "Construir contenedores Docker (docker compose up -d --build)"
# composer install
# ejecutar_comando "docker compose run --rm composer install" "Instalar dependencias de Composer" "Instalar dependencias de Composer (docker compose run --rm composer install)"
# ejecutar_comando "sudo chown -R $USER_NAME:$GROUP_NAME ./src/vendor" "Cambiar permisos de carpeta vendor" "Cambiar permisos de carpeta vendor (sudo chown -R $USER_NAME:$GROUP_NAME ./src/vendor)"
# npm install
# ejecutar_comando "docker compose run --rm npm install" "Instalar dependencias de NPM" "Instalar dependencias de NPM (docker compose run --rm npm install)"
# ejecutar_comando "sudo chown -R $USER_NAME:$GROUP_NAME ./src/node_modules" "Cambiar permisos de carpeta node_modules" "Cambiar permisos de carpeta node_modules (sudo chown -R $USER_NAME:$GROUP_NAME ./src/node_modules)"
# Artisan Migrate + Seed
# ejecutar_comando "docker compose run --rm artisan key:generate" "Generar clave de aplicación" "Generar clave de aplicación (docker compose run --rm artisan key:generate)"
# Artisan Migrate + Seed
# ejecutar_comando "docker compose run --rm artisan migrate --seed" "Ejecutar migraciones y seeds de base de datos" "Ejecutar migraciones y seeds de base de datos (docker compose run --rm artisan migrate)"
# Permisos de carpeta Storage
# ejecutar_comando "sudo chmod -R 775 ./src/storage" "Cambiar permisos de carpeta storage" "Cambiar permisos de carpeta storage (sudo chmod -R 775 ./src/storage)"
# Permisos script aliases
ejecutar_comando "sudo chmod +x aliases.sh" "Dar permisos de ejecución a aliases.sh" "Dar permisos de ejecución a aliases.sh (sudo chmod +x aliases.sh)"
# Permisos script rollback
ejecutar_comando "sudo chmod +x rollback-linux.sh" "Dar permisos de ejecución a rollback-linux.sh" "Dar permisos de ejecución a aliases.sh (sudo chmod +x rollback-linux.sh.sh)"


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
