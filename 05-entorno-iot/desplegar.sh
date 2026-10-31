#!/usr/bin/env bash
# Despliega el entorno IoT completo con un solo comando.
# Uso:  ./desplegar.sh
set -euo pipefail
cd "$(dirname "$0")"

# 1. Comprobaciones previas
command -v docker >/dev/null || { echo "ERROR: Docker no está instalado"; exit 1; }
docker info >/dev/null 2>&1  || { echo "ERROR: Docker no está en marcha (abre Docker Desktop)"; exit 1; }

# 2. Configuración: si no hay .env, se crea a partir del ejemplo y se para
if [ ! -f .env ]; then
  cp .env.example .env
  echo "He creado el fichero .env. Edítalo, cambia las claves y vuelve a ejecutar ./desplegar.sh"
  exit 1
fi
if grep -q "cambia-" .env; then
  echo "ERROR: en .env quedan valores de ejemplo sin cambiar (búscalos: grep cambia- .env)"
  exit 1
fi

# 3. Validar el compose antes de tocar nada
docker compose config --quiet

# 4. Descargar imágenes y arrancar, esperando a que todos los servicios estén sanos
docker compose pull --quiet
docker compose up -d --wait

# 5. Resumen
set -a; . ./.env; set +a
echo
docker compose ps --format 'table {{.Service}}\t{{.Status}}'
echo
echo "Entorno listo:"
echo "  Node-RED   http://localhost:${PUERTO_NODERED:-1880}"
echo "  InfluxDB   http://localhost:${PUERTO_INFLUXDB:-8086}"
echo "  Grafana    http://localhost:${PUERTO_GRAFANA:-3000}"
echo "  MQTT       localhost:${PUERTO_MQTT:-1883}"
