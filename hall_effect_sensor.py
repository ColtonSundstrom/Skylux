import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)

class HE_Sensor():

    def __init__(self, sensor_pin):
        """
        Creates a Hall Effect Sensor (HE_Sensor) class object. 
        The constructor takes the pin which will be monitored. Care should be taken not to overwrite a pin 
        used by another system on the board, as no checks will be made to verify availability. 
        :param sensor_pin: GPIO pin on the RPi to be used. 
        """
        self.pin = sensor_pin
        self.count = 0

        GPIO.setup(self.pin, GPIO.IN)
        GPIO.add_event_detect(self.pin, GPIO.FALLING, callback=hallback)

    def hallback(self):
        self.count += 1