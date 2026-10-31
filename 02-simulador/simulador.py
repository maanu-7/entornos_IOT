"""Sensor simulado: publica una temperatura y una humedad por MQTT cada pocos segundos.

Toda la configuración llega por variables de entorno, así la misma imagen
sirve para cualquier broker y para tantos sensores como haga falta.
"""
import json
import os
import random
import time

import paho.mqtt.client as mqtt

BROKER = os.environ.get("MQTT_HOST", "mosquitto")
PUERTO = int(os.environ.get("MQTT_PORT", "1883"))
SENSOR = os.environ.get("SENSOR_ID", "sensor01")
PERIODO = float(os.environ.get("PERIODO", "2"))

cliente = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id=SENSOR)
cliente.connect(BROKER, PUERTO)          # si el broker no responde, el programa termina con error
cliente.loop_start()
print(f"{SENSOR}: conectado al broker {BROKER}:{PUERTO} (v1.2)", flush=True)

temperatura = 21.0
humedad = 50.0                           # % de humedad relativa
while True:
    temperatura += random.uniform(-0.3, 0.3)
    mensaje = json.dumps({"id": SENSOR, "temperatura": round(temperatura, 1)})
    cliente.publish(f"demo/{SENSOR}/temperatura", mensaje)
    print(mensaje, flush=True)

    # Segunda medida en su propio topic; se mantiene entre 0 y 100 %
    humedad = min(100.0, max(0.0, humedad + random.uniform(-1.0, 1.0)))
    mensaje = json.dumps({"id": SENSOR, "humedad": round(humedad, 1)})
    cliente.publish(f"demo/{SENSOR}/humedad", mensaje)
    print(mensaje, flush=True)

    time.sleep(PERIODO)
