#!/usr/bin/env bash
# Copia de seguridad de los volúmenes del entorno en la carpeta copias/
# Uso:  ./copia.sh
set -euo pipefail
cd "$(dirname "$0")"
fecha=$(date +%Y%m%d-%H%M)
mkdir -p copias

for volumen in mosquitto-datos nodered-datos influxdb-datos influxdb-config grafana-datos; do
  # un contenedor de usar y tirar monta el volumen (solo lectura) y lo empaqueta
  docker run --rm \
    -v "entorno-iot_${volumen}:/origen:ro" \
    -v "$PWD/copias:/destino" \
    alpine:3.22 tar czf "/destino/${volumen}-${fecha}.tar.gz" -C /origen .
  echo "ok  copias/${volumen}-${fecha}.tar.gz"
done
