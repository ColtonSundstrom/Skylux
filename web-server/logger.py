#!/usr/bin/python
# This file covers reading and writing from the Skylux log file. The log file contains
# a single integer that represents the number of seconds that the operator has travelled
# from a completely closed position.
import os


class Logger:
    def __init__(self, logFile):
        self.logFile = os.path.join(os.path.dirname(__file__), logFile)

    # Used to reset log file to closed position (0).
    def resetLog(self):
        with open(self.logFile, 'w') as log:
            log.write("0")

    # Read from the log file.
    def readLog(self):
        with open(self.logFile, 'r') as log:
            status = int(log.read())
        return status

    # Overwrite whatever is in the log file.
    def writeLog(self, newStatus):
        with open(self.logFile, 'w') as log:
            log.write(newStatus)
