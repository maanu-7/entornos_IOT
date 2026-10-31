# Entorno IoT del curso

Entorno completo para el módulo «Tecnologías IoT para la Industria 4.0»: un broker MQTT, Node-RED,
una base de datos de series temporales y Grafana, desplegados con Docker Compose.

## Arquitectura

| Servicio    | Imagen                     | Puerto | Datos (volumen)                     | Para qué sirve                 |
|-------------|----------------------------|--------|-------------------------------------|--------------------------------|
| `mosquitto` | `eclipse-mosquitto:2.0.22` | 1883   | `mosquitto-datos`                   | Broker MQTT: reparte mensajes  |
| `nodered`   | `nodered/node-red:5.0.8`   | 1880   | `nodered-datos`                     | Flujos: procesa y conecta      |
| `influxdb`  | `influxdb:2.9`             | 8086   | `influxdb-datos`, `influxdb-config` | Guarda el histórico de medidas |
| `grafana`   | `grafana/grafana:13.2.3`   | 3000   | `grafana-datos`                     | Paneles y alertas              |

Los servicios se comunican por la red interna usando su nombre: `mosquitto:1883`,
`http://influxdb:8086`. Grafana arranca con el data source de InfluxDB ya configurado
(`grafana/provisioning`).

## Requisitos

- Docker Desktop (Windows o macOS) o Docker Engine con el plugin Compose (Linux). Probado con
  Docker 28 y Compose 2.39.
- Puertos 1883, 1880, 8086 y 3000 libres (se pueden cambiar en `.env`).
- Unos 4 GB de disco para las imágenes.

## Puesta en marcha

1. Copia `.env.example` como `.env` y cambia las claves.
2. Ejecuta `./desplegar.sh` (Linux, macOS, Git Bash) o `.\desplegar.ps1` (PowerShell).
3. Abre http://localhost:1880 (Node-RED), http://localhost:8086 (InfluxDB) y
   http://localhost:3000 (Grafana).

El script comprueba que Docker funciona, valida la configuración, descarga las imágenes y espera
a que los cuatro servicios estén «healthy».

## Configuración

Todo lo que cambia de un equipo a otro está en `.env`:

| Variable                           | Qué es                                           |
|------------------------------------|--------------------------------------------------|
| `INFLUX_USUARIO`, `INFLUX_CLAVE`   | Administrador de InfluxDB (clave: 8 caracteres o más) |
| `INFLUX_TOKEN`                     | Token de la API de InfluxDB; lo usa Grafana      |
| `GRAFANA_USUARIO`, `GRAFANA_CLAVE` | Administrador de Grafana                         |
| `PUERTO_*`                         | Puerto de cada servicio en tu equipo             |
| `PREFIJO`                          | Prefijo del nombre de los contenedores (`iot`)   |

Las credenciales solo se aplican la primera vez que arranca cada servicio. El fichero `.env` no
se sube al repositorio (está en `.gitignore`).

## Operación

| Quiero…                            | Comando                                    |
|------------------------------------|--------------------------------------------|
| Ver el estado                      | `docker compose ps`                        |
| Ver el registro de un servicio     | `docker compose logs -f grafana`           |
| Reiniciar un servicio              | `docker compose restart nodered`           |
| Parar todo (conservando los datos) | `docker compose down`                      |
| Borrarlo todo, datos incluidos     | `docker compose down -v`                   |
| Hacer una copia de seguridad       | `./copia.sh`                               |
| Restaurar un volumen               | `./restaurar.sh grafana-datos copias/…tar.gz` |

## Actualizar un servicio

Cambia la etiqueta de la imagen en `compose.yaml`, haz antes una copia con `./copia.sh` y ejecuta
`./desplegar.sh`. Anota el cambio en el historial de abajo.

## Problemas frecuentes

| Síntoma                                  | Causa y solución                                              |
|------------------------------------------|---------------------------------------------------------------|
| `port is already allocated`              | El puerto está ocupado: cambia `PUERTO_…` en `.env`           |
| Un servicio se queda en `unhealthy`      | Mira su registro: `docker compose logs <servicio>`            |
| He cambiado la clave en `.env` y no vale | Solo se aplica en el primer arranque: `docker compose down -v` (borra los datos) |
| Grafana no ve InfluxDB                   | El token de `.env` no coincide con el de InfluxDB             |

## Estructura

```
05-entorno-iot/
├── compose.yaml            definición de los servicios
├── .env.example            plantilla de configuración (el .env real no se sube)
├── desplegar.sh / .ps1     despliegue automático
├── copia.sh, restaurar.sh  copias de seguridad de los volúmenes
├── mosquitto/              configuración del broker
└── grafana/provisioning/   data source que Grafana crea al arrancar
```

## Historial

| Fecha      | Cambio                         |
|------------|--------------------------------|
| 2026-10-12 | Primera versión del entorno    |
