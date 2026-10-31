# Copia de seguridad de los volúmenes del entorno en la carpeta copias\ (Windows, PowerShell).
# Uso:  .\copia.ps1
Set-Location $PSScriptRoot
$fecha = Get-Date -Format "yyyyMMdd-HHmm"
New-Item -ItemType Directory -Force copias | Out-Null

foreach ($volumen in "mosquitto-datos", "nodered-datos", "influxdb-datos", "influxdb-config", "grafana-datos") {
    # un contenedor de usar y tirar monta el volumen (solo lectura) y lo empaqueta
    docker run --rm `
        -v "entorno-iot_${volumen}:/origen:ro" `
        -v "${PWD}\copias:/destino" `
        alpine:3.22 tar czf "/destino/${volumen}-${fecha}.tar.gz" -C /origen .
    if ($LASTEXITCODE -ne 0) { Write-Host "ERROR al copiar $volumen"; exit 1 }
    Write-Host "ok  copias\${volumen}-${fecha}.tar.gz"
}
