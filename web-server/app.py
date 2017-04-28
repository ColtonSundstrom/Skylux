import time
import motor_driver
from flask import Flask, render_template, request
app = Flask(__name__)

#globals
motorDriver = None

@app.route("/")
def main():
   global motorDriver
   
   motorDriver = motor_driver.MotorDriver(25, 24, 23)

   return render_template('main.html')

# The function below is executed when someone requests a URL with the pin number and action in it:
@app.route("/<action>")
def action(action):
   global motorDriver

   if action == "on":
      motorDriver.enable_motor()
      motorDriver.set_duty_cycle(100)
      time.sleep(5)
      motorDriver.set_duty_cycle(0)

   if action == "off":
      motorDriver.enable_motor()
      motorDriver.set_duty_cycle(-100)
      time.sleep(5)
      motorDriver.set_duty_cycle(0)

   return render_template('main.html')
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=80, debug=True)
