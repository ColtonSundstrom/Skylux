import paho.mqtt.client as mqtt
import time

SERVER = 'coltonsundstrom.net'
PORT = 1883
KEEPALIVE = 60

DEV_ID = 2

status = 0

subscription = "SKYLUX/{}/command".format(DEV_ID)
publish = "SKYLUX/{}/status".format(DEV_ID)

#globals
motorDriver = None
Logger = None

#comment
def on_connect(client, userdata, flags, rc):
    print("Connected with result code: " + str(rc))
    client.subscribe(subscription)


def on_message(client, userdata, msg):
    print("Topic: {}, MSG: {}".format(msg.topic, msg.payload))
    global status
    print("Status: " + str(status))

    if b"ON" in msg.payload:
        if status < 15:
            # Add five seconds to log file.
            print("Turn device on")
            status += 5
            time.sleep(5)
            quickPubStatusMQTT(status)
        else:
            print("Device Limit already reached")

    elif b"OFF" in msg.payload:
        if status >= 5:
            print("Close Device")
            # Subtract five seconds from log file.
            status -= 5
            time.sleep(5)
            quickPubStatusMQTT(status)
        else:
            print("Cannot close any further.")

    else:
        print("Unknown command")


def initMQTT():
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_message = on_message

    client.connect(SERVER, PORT, KEEPALIVE)

    return client


def quickPubStatusMQTT(payload):
    client = mqtt.Client()
    client.connect(SERVER, PORT, 60)
    ret = client.publish(publish, payload=payload, qos=0, retain=0)

    client.disconnect()

    return ret

def main():
    client = initMQTT()

    client.loop_forever()

main()