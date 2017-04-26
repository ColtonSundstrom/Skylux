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

        frequency = 2500 #Hz
        self.FW_pwm = GPIO.PWM(FW_pin, frequency)
        self.FW_pwm.start(0)
	self.BW_pwm = GPIO.PWM(BW_pin, frequency)
        self.BW_pwm.start(0)
	self.set_duty_cycle(0)
	
    def set_duty_cycle(self, duty):
        if (duty > 0):
            if (duty > 100):
                duty = 100
            self.BW_pwm.ChangeDutyCycle(0)
            self.FW_pwm.ChangeDutyCycle(duty)
        else:
            if (duty < -100):
                duty = -100
            self.FW_pwm.ChangeDutyCycle(0)
            self.BW_pwm.ChangeDutyCycle(duty * -1)
        self.duty = duty
        print("MotorDriver | Set Duty Cycle: {}".format(duty))

    def get_duty(self):
        return self.duty

    def enable_motor(self):
        GPIO.output(self.EN_pin, GPIO.HIGH)
    def disable_motor(self):
        GPIO.output(self.EN_pin, GPIO.LOW)





