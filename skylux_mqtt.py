# MQTT handler for the skylux syystem

import paho.mqtt.client as mqtt

SERVER = 'coltonsundstrom.net'
PORT = 1883
KEEPALIVE = 60

#comment
def on_connect(client, userdata, flags, rc):
    print("Connected with result code: " + str(rc))
    client.subscribe("SKYLUX/command")

def on_message(client, userdata, msg):
    print("Topic: {}, MSG: {}".format(msg.topic, msg.payload))
    if b"ON" in msg.payload:
        print("Turn device on")
    elif b"OFF" in msg.payload:
        print("Turn device off")
    else:
        print("Unknown command")

def initMQTT():
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_message = on_message

    client.connect(SERVER, PORT, KEEPALIVE)

    return client