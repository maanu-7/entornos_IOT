# Tecnologías IoT para la Industria 4.0 · Bloque 0: contenedores con Docker

Prácticas D2 a D5 de **Manu Martín** (2.º DAM).

| Práctica | Carpeta | Informe |
|----------|---------|---------|
| D2 · Tu primera imagen | `02-simulador` | `Informe_Practica_2.docx` |
| D3 · Un entorno con Compose | `03-compose` (usa también `01-web`) | `Practica_D3_Manu_Martin.docx` / `Practica_D3.pdf` |
| D4 · Conteneriza tu microservicio | `04-springboot` | `Practica_D4_Manu_Martin.docx` / `Practica_D4.pdf` |
| D5 · Despliega el entorno del curso | `05-entorno-iot` | `Practica_D5_Manu_Martin.docx` / `Practica_D5.pdf` |

Las capturas de pantalla de cada práctica están en `capturas/`.

## Cómo probarlo

Requisito: Docker Desktop. En cada carpeta, copia `.env.example` como `.env` y cambia los valores
de ejemplo antes de arrancar. Los ficheros `.env` reales no están en el repositorio.

```powershell
cd 03-compose;     docker compose up -d --build     # D3
cd 04-springboot;  docker compose up -d --build --wait   # D4
cd 05-entorno-iot; .\desplegar.ps1                  # D5
```
