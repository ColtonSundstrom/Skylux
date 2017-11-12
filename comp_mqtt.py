import paho.mqtt.client as mqtt

SERVER = 'coltonsundstrom.net'
PORT = 1883
KEEPALIVE = 60

subscriptions = ['SKYLUX/newDevs']

def on_connect(client, userdata, flags, rc):
    print("Connected to server with result code: " + str(rc))
    for sub in subscriptions:
        client.subcribe(sub)
        print("added subscription: {}".format(sub))


def on_message(client, userdata ,msg):
    print("Topic: {}, MSG: {}".format(msg.topic, msg.payload))

#other comment
def initSubMQTT():
    client = mqtt.Client()
    client.on_message = on_message
    client.on_connect = on_connect

    client.connect(SERVER, PORT, 60)


def quickPubMQTT(topic, payload):
    client = mqtt.Client()
    client.connect(SERVER, PORT, 60)
    ret = client.publish(topic, payload=payload, qos=0, retain=0)

    client.disconnect()

    return ret
