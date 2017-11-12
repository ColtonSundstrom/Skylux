import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)

class MotorDriver:

    def __init__(self, EN_pin, FW_pin, BW_pin):
        GPIO.setup(EN_pin, GPIO.OUT)
        GPIO.setup(FW_pin, GPIO.OUT)
        GPIO.setup(BW_pin, GPIO.OUT)

        self.duty = 0
        self.EN_pin = EN_pin
        GPIO.output(self.EN_pin, GPIO.LOW)
        
        self.FW_pin = FW_pin
        self.BW_pin = BW_pin
        
        self.set_duty_cycle(0)
	
    def set_duty_cycle(self, duty):
        if (duty > 0):
            GPIO.output(self.BW_pin, GPIO.LOW)
            GPIO.output(self.FW_pin, GPIO.HIGH)
        elif (duty < 0):
            GPIO.output(self.FW_pin, GPIO.LOW)
            GPIO.output(self.BW_pin, GPIO.HIGH)
        else:
            GPIO.output(self.BW_pin, GPIO.LOW)
            GPIO.output(self.FW_pin, GPIO.LOW)
            
        self.duty = duty
        print("MotorDriver | 'Set' Duty Cycle: {}".format(duty))

    def get_duty(self):
        return self.duty

    def enable_motor(self):
        GPIO.output(self.EN_pin, GPIO.HIGH)
        
    def disable_motor(self):
        GPIO.output(self.EN_pin, GPIO.LOW)





