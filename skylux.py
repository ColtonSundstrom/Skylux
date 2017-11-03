# -*- coding: utf-8 -*-
#
## @file skylux.py
#  This file contains the main scheduling logic and device handling
# for the Skylux project implementation. Control logic designed
# to utilize the MicroPython psuedo-RTOS library by JR Ridgley.
#
#
#  @author Colton Sundstrom

import cotask
import time

from webserver import logger, fauxmo, motor_driver
import skylux_mqtt

MD_ENB_PIN = 25
MD_FWD_PIN = 24
MD_BWD_PIN = 23


# This is an example handler class. The fauxmo class expects handlers to be
# instances of objects that have on() and off() methods that return True
# on success and False otherwise.
#
# This example class takes two full URLs that should be requested when an on
# and off command are invoked respectively. It ignores any return data.
motorDriver = None
Logger = None
motorHandler = None

class motor_handler(object):
    def __init__(self):
        global motorDriver
        global Logger

        motorDriver = motor_driver.MotorDriver(MD_ENB_PIN, MD_FWD_PIN, MD_BWD_PIN)
        Logger = logger.Logger("log.txt")

    def on(self):
        status = Logger.readLog()

        if (status < 15):
            print("I'm on!")
            motorDriver.enable_motor()
            motorDriver.set_duty_cycle(100)
            time.sleep(5)
            motorDriver.set_duty_cycle(0)

            Logger.writeLog(str(status + 5))

            return 200
        else:
            print("Cannot open any further.")
            return 200


    def off(self):
        status = Logger.readLog()

        if (status >= 5):
            print("I'm off!")
            motorDriver.enable_motor()
            motorDriver.set_duty_cycle(-100)
            time.sleep(4.75)
            motorDriver.set_duty_cycle(0)

            Logger.writeLog(str(status - 5))

            return 200
        else:
            print("cannot close any further.")
            return 200


def fauxmoControl():
    global motorHandler
    skylux_faux = ['Skylight', motorHandler]

    p = fauxmo.poller()
    u = fauxmo.upnp_broadcast_responder()
    u.init_socket()

    p.add(u)

    switch = fauxmo.fauxmo(skylux_faux[0], u, p, None, None, action_handler = skylux_faux[1])

    print("Fauxmo control running...")

    while True:
        try:
            p.poll()
        except Exception as e:
            fauxmo.dbg(e)
            break
        yield()

    print("Fauxmo control failed due to exception.")


def mqttControl():
    client = skylux_mqtt.initMQTT()

    while True:
        client.loop_start()
        time.sleep(.1)
        client.loop_stop()
        yield()


if __name__ == "__main__":
    print("Skylux Project Main()")
    global motorHandler

    motorHandler = motor_handler()
    mqttClient = skylux_mqtt.initMQTT()

    ##implement way to listen to MQTT

    mqttTask = cotask.Task(mqttControl, name = 'MQTT_Listener', priority= 2,
                           period = 1000, profile = True, trace = False)
    fauxmoTask = cotask.Task (fauxmoControl, name = "Fauxmo", priority = 1,
                              period = 100, profile = True, trace = False)

    cotask.task_list.append(mqttTask)
    cotask.task_list.append(fauxmoTask)

    while True:
        cotask.task_list.pri_sched()


