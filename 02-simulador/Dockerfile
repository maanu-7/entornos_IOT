# Imagen del sensor simulado
# Construcción:  docker build -t aula/simulador:1.0 .
# Cada instrucción que modifica el sistema de ficheros crea una capa;
# Docker reutiliza (caché) las capas cuyo contenido no ha cambiado.

# Imagen base: Python 3.13 sobre Debian en su versión "slim" (sin
# herramientas innecesarias), así la imagen final ocupa menos.
FROM python:3.13-slim

# Directorio de trabajo dentro del contenedor. Se crea si no existe y
# todas las instrucciones siguientes (COPY, RUN, CMD) parten de aquí.
WORKDIR /app

# 1. Primero las dependencias: cambian poco y así su capa se reutiliza
# Se copia solo requirements.txt para que la capa del pip install
# dependa únicamente de este fichero y no del código.
COPY requirements.txt .
# Instala paho-mqtt. --no-cache-dir evita guardar la caché de pip
# dentro de la imagen, que solo ocuparía espacio.
RUN pip install --no-cache-dir -r requirements.txt

# 2. Después el código: cambia a menudo
# Al editar simulador.py solo se reconstruye desde esta capa en adelante;
# las anteriores (incluida la instalación de dependencias) salen de caché.
COPY simulador.py .

# Valores por defecto, que se pueden cambiar al arrancar el contenedor
# con -e (por ejemplo: -e SENSOR_ID=sensor02 -e PERIODO=5).
#   MQTT_HOST: nombre del broker; en una red de Docker es el nombre del contenedor
#   SENSOR_ID: identificador del sensor y parte del topic demo/<id>/temperatura
#   PERIODO:   segundos entre mensajes
ENV MQTT_HOST=mosquitto \
    SENSOR_ID=sensor01 \
    PERIODO=2

# No ejecutar como root: el proceso corre con un usuario sin privilegios,
# así un fallo en la aplicación no da control total del contenedor.
USER nobody

# Proceso principal del contenedor. Formato exec (lista JSON): Python es el
# PID 1 y recibe directamente las señales de parada (docker stop).
CMD ["python", "simulador.py"]
