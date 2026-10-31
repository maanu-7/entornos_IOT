# Restaura un volumen a partir de una copia hecha con copia.ps1 (Windows, PowerShell).
# Uso:  .\restaurar.ps1 grafana-datos copias\grafana-datos-20261012-1907.tar.gz
param([Parameter(Mandatory)] [string]$volumen, [Parameter(Mandatory)] [string]$fichero)
Set-Location $PSScriptRoot
if (-not (Test-Path $fichero)) { Write-Host "ERROR: no existe $fichero"; exit 1 }
$carpeta = (Resolve-Path (Split-Path $fichero)).Path
$nombre = Split-Path $fichero -Leaf

docker compose down                       # los contenedores no pueden estar usando el volumen
docker volume create "entorno-iot_${volumen}" | Out-Null   # por si se había borrado
docker run --rm `
    -v "entorno-iot_${volumen}:/destino" `
    -v "${carpeta}:/origen:ro" `
    alpine:3.22 sh -c "rm -rf /destino/* && tar xzf /origen/$nombre -C /destino"
if ($LASTEXITCODE -ne 0) { Write-Host "ERROR al restaurar $volumen"; exit 1 }
Write-Host "ok  $volumen restaurado. Arranca de nuevo con .\desplegar.ps1"
