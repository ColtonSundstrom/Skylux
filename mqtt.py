# MQTT handler for the skylux syystem

import paho.mqtt.client as mqtt
import time

SERVER = 'iot.eclipse.org'


def on_connect(client, userdata, flags, rc):
    print("Connected with result code: " + str(rc))
    client.subscribe("sensors/temp")

def on_message(client, userdata, msg):
    print("Topic: {}, MSG: {}".format(msg.topic, msg.payload))
    if b"ON" in msg.payload:
        print("Turn device on")
    elif b"OFF" in msg.payload:
        print("Turn device off")
    else:
        print("Unknown command")

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("localhost", 1883, 60)

client.loop_start()

time.sleep(2)

try:
    client.loop_forever()
except KeyboardInterrupt:
    client.disconnect()

