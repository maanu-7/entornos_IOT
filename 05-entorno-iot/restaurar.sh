#!/usr/bin/env bash
# Restaura un volumen a partir de una copia hecha con copia.sh
# Uso:  ./restaurar.sh grafana-datos copias/grafana-datos-20261012-1907.tar.gz
set -euo pipefail
cd "$(dirname "$0")"
volumen="$1"; fichero="$2"

docker compose down                       # los contenedores no pueden estar usando el volumen
docker run --rm \
  -v "entorno-iot_${volumen}:/destino" \
  -v "$PWD/$(dirname "$fichero"):/origen:ro" \
  alpine:3.22 sh -c "rm -rf /destino/* && tar xzf /origen/$(basename "$fichero") -C /destino"
echo "ok  ${volumen} restaurado. Arranca de nuevo con ./desplegar.sh"
