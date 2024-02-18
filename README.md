# Documentación

Instrucciones para levantar el entorno de desarrollo con docker

Para ejecutar los comandos `docker` o `docker compose` hay que pararse en la carpeta `.docker`

## Paso para levantar app

1. Crear lo `.env` de laravel y de `.docker`

    ```bash
    cp .env.example .env
    cp ./.docker/.env.example ./.docker/.env
    ```

2. Obtener los `UID` y `GID` y agregarlo en el `./.docker/.env`

    ```bash
    ls -n
    ```

3. Hacer lo mismo para `USER_NAME` y `GROUP_NAME` en el `./.docker/.env`

    ```bash
    ls -al
    ```

4. Generara carpeta `.docker/mysql/data/`
    
    En Linux (o WSL):
    ```bash
    mkdir .docker/mysql/data/
    ```

    En Windows:
    ```bash
    mkdir .docker\mysql\data\
    ```

5. Agregar host en el archivo `driver/etc/host`

    En Linux:
    ```bash
    127.0.0.1   first-livewire.local.com
    ```

    En windows (o WSL):

    Utilizar la misma IP que hay en el archivo de host para host.docker.internal y gateway.docker.internal

    ```bash
    x.x.x.x   first-livewire.local.com
    ```

6. Instalación de contenedores, librerías y migración (ubicarse en .docker)

    En Linux (o WSL):
    ```bash
    ./initialize-linux.sh
    ```

    En Windows:
    ```bash
    sh initialize.sh
    ```
    > Recomendación para Windows: Aumentar los recursos que utiliza docker, en caso de que instalación las librerías de composer se detenga, por mucho tiempo, y no finalize.

7. Ejecución de Vite

    - Cambiar el script npm `vite.config.json`:

        Aca vamos poner el nombre que le pusimos a nuestro host

        ```json
        export default defineConfig({
            ...
            server: {
                hmr: {
                    host: 'first-livewire.local.com',
                }
            },
            ...
        })
        ```

    - Ejecutar `npm run dev`

        ```bash
        docker compose --env-file .docker/.env run --rm --service-ports npm run dev
        ```

8. (OPCIONAL) Hacer el build de los assets

    ```bash
    docker compose --env-file .docker/.env run --rm --service-ports npm run build
    ```

    > En caso de ser necesario cambiar el usuario y el grupo de los archivos creados en `../public/build/`.
    >
    > Comando: `sudo chown -R usuario:grupo ../public/build/`

## Conectarse a la DB desde un administrador de base de datos

```bash
host: first-livewire.local.com
port: 3007
user: root
password: root
database: laraveldb
```

## Posibles problemas y soluciones

1. En caso de que no se tenga permisos para ejecutar el script, y te muestre un mensaje similar a este `si el archivo no tiene permiso de ejecución permission denied: ./initialize.sh` debe darle permisos de ejecución:

    ```bash
    chmod +x initialize.sh
    ```
    
    >Hacer lo mismo con los demás archivos .sh si es necesario

2. Ejecutar el siguiente comando (ubicado en .docker), en caso de querer hacer un rollback de los contenedores, borrar las carpetas node_modules, vendor y volumen de mysql

    En Linux (o WSL):
    ```bash
    ./rollback-linux.sh
    ```

    En Windows:
    ```bash
    sh rollback.sh
    ```

3. En caso de modificar las variables de entorno ejecutar los siguientes comandos

    ```bash
    docker compose --env-file .docker/.env down -v
    docker compose --env-file .docker/.env up -d --build
    ```

4. En caso de que necesites entrar a uno de los contenedores (servicios)

    ```bash
    # contenedor Nginx
    docker compose --env-file .docker/.env exec nginx sh
    # contenedor php
    docker compose --env-file .docker/.env exec php sh
    # contenedor mysql
    docker compose --env-file .docker/.env exec mysql sh
    # contenedor redis
    docker compose --env-file .docker/.env exec redis sh
    ```

5. Si necesitas revisar el contenedor de mysql, para ver usuario y tablas

    ```bash
    docker compose exec mysql sh

    # Entrar a mysql como usuario root
    mysql -u laravel -p
    pw:root

    # Ver la tabla de usuarios
    SELECT user, host FROM mysql.user;
    ```

6. Para saber que valores tengo en seleccionar para mis UID y GID, pararse sobre el proyecto laravel

    ```bash
    ls -n
    ```

7. En caso de que la instalación de las librerías npm de error, intentar borrar la cache de npm

    ```bash
    docker compose --env-file .docker/.env run --rm npm cache clean --force
    ```
