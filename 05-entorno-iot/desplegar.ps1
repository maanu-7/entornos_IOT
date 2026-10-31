# Despliega el entorno IoT completo en Windows (PowerShell).
# Uso:  .\desplegar.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# 1. Comprobaciones previas
docker info *> $null
if ($LASTEXITCODE -ne 0) { Write-Host "ERROR: Docker no está en marcha (abre Docker Desktop)"; exit 1 }

# 2. Configuración: si no hay .env, se crea a partir del ejemplo y se para
if (-not (Test-Path .env)) {
    Copy-Item .env.example .env
    Write-Host "He creado el fichero .env. Edítalo, cambia las claves y vuelve a ejecutar .\desplegar.ps1"
    exit 1
}
if (Select-String -Path .env -Pattern "cambia-" -Quiet) {
    Write-Host "ERROR: en .env quedan valores de ejemplo sin cambiar"
    exit 1
}
$cfg = @{}
Get-Content .env | Where-Object { $_ -match '^\s*([A-Z_]+)=(.*)$' } | ForEach-Object { $cfg[$Matches[1]] = $Matches[2].Trim() }

# 3. (Reto D5) Avisar si algún puerto ya lo usa otro programa. Si el puerto es
#    nuestro porque el servicio ya está en marcha, no es un problema (redespliegue).
$enMarcha = @(docker compose ps --services --status running 2>$null)
$puertos = [ordered]@{ PUERTO_MQTT = @("mosquitto", 1883); PUERTO_NODERED = @("nodered", 1880)
                       PUERTO_INFLUXDB = @("influxdb", 8086); PUERTO_GRAFANA = @("grafana", 3000) }
$ocupados = foreach ($var in $puertos.Keys) {
    $servicio = $puertos[$var][0]
    $puerto = if ($cfg[$var]) { [int]$cfg[$var] } else { $puertos[$var][1] }
    $escucha = Get-NetTCPConnection -State Listen -LocalPort $puerto -ErrorAction SilentlyContinue
    if ($escucha -and $enMarcha -notcontains $servicio) {
        $proceso = (Get-Process -Id $escucha[0].OwningProcess -ErrorAction SilentlyContinue).ProcessName
        "  puerto $puerto ($var, para $servicio) ocupado por: $proceso"
    }
}
if ($ocupados) {
    Write-Host "ERROR: hay puertos ocupados. Libéralos o cámbialos en .env:"
    $ocupados | ForEach-Object { Write-Host $_ }
    exit 1
}

# 4. Validar el compose, descargar imágenes y arrancar esperando a que todo esté sano
docker compose config --quiet
docker compose pull --quiet
docker compose up -d --wait
if ($LASTEXITCODE -ne 0) { Write-Host "ERROR: algún servicio no ha arrancado bien (docker compose ps)"; exit 1 }

# 5. Resumen
Write-Host ""
docker compose ps --format "table {{.Service}}`t{{.Status}}"
Write-Host ""
Write-Host "Entorno listo:"
Write-Host "  Node-RED   http://localhost:$(if ($cfg.PUERTO_NODERED) { $cfg.PUERTO_NODERED } else { 1880 })"
Write-Host "  InfluxDB   http://localhost:$(if ($cfg.PUERTO_INFLUXDB) { $cfg.PUERTO_INFLUXDB } else { 8086 })"
Write-Host "  Grafana    http://localhost:$(if ($cfg.PUERTO_GRAFANA) { $cfg.PUERTO_GRAFANA } else { 3000 })"
Write-Host "  MQTT       localhost:$(if ($cfg.PUERTO_MQTT) { $cfg.PUERTO_MQTT } else { 1883 })"
