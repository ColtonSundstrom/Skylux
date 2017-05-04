import os, time, socket
import motor_driver
from datetime import timedelta
from subprocess import check_output
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
   
@app.route("/options")
def options():
   # Get the uptime.
   with open('/proc/uptime', 'r') as f:
      uptime_seconds = float(f.readline().split()[0])
      uptime_string = str(timedelta(seconds = uptime_seconds))
      uptime_string = uptime_string.split(".")
      uptime_string = uptime_string[0]
   
   # Get the SSID.
   ssid_string = check_output("iwgetid")
   ssid_string = ssid_string.split('"')
   ssid_string = ssid_string[1] 
   
   # Get the MAC address.
   mac_string = open('/sys/class/net/eth0/address').read()
   
   # Get the IP address.
   ip_string = check_output(['hostname', '-I'])

   return render_template('options.html', uptime_string=uptime_string, ssid_string=ssid_string, mac_string = mac_string, ip_string = ip_string)
   
@app.route("/about")
def about():
   return render_template('about.html')
   
@app.route("/reboot")
def reboot():
   print("Rebooting!")
   os.system("sudo reboot")
   
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=80, threaded=True, debug=True)