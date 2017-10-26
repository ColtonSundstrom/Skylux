# -*- coding: utf-8 -*-
#
## @file skylux.py
#  This file contains the main scheduling logic and device handling
# for the Skylux project implementation. Control logic designed
# to utilize the MicroPython psuedo-RTOS library by JR Ridgley.
#
#
#  @author Colton Sundstrom

import pyb
import micropython

import cotask
import task_share

import logger
import skylux_mqtt
import fauxmo
import app
import motor_driver

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


def fauxmoControl(motorHandler):
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


if __name__ == "__main__":
    print("Skylux Project Main()")

    motorHandler = motor_handler()
    mqttClient = skylux_mqtt.initMQTT()

    ##implement way to listen to MQTT



