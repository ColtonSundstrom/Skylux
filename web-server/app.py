import os, time, socket
import motor_driver
import logger
from datetime import timedelta
from subprocess import check_output
from flask import Flask, render_template, request
app = Flask(__name__)

#globals
motorDriver = None
Logger = None

@app.route("/")
def main():
   global motorDriver
   global Logger 
   motorDriver = motor_driver.MotorDriver(25, 24, 23)
   Logger = logger.Logger("log.txt")
   return render_template('main.html')

# The function below is executed when someone requests a URL with the pin number and action in it:
@app.route("/<action>")
def action(action):
   global motorDriver
   global Logger
   #error = None
   #print request.args.get('error')
   if action == "on":
      # Read from the log file.
      status = Logger.readLog()
      print "Before:" + str(status)
      # Only open the skylight if we've traveled less than 10 seconds.
      # This will change based on the total travel time of operator.
      if (status < 20):
         motorDriver.enable_motor()
      	 motorDriver.set_duty_cycle(100)
         time.sleep(5)
         motorDriver.set_duty_cycle(0)
         # Add five seconds to log file.
         Logger.writeLog(str(status + 5))
      else:
         print "Cannot open any further."
         #error="open"
   if action == "off":
      # Read from the log file.
      status = Logger.readLog()
      print "Before:" + str(status)
      # Only close skylight if we have travel left to go.
      if (status >= 5):
         motorDriver.enable_motor()
         motorDriver.set_duty_cycle(-100)
         time.sleep(5)
         motorDriver.set_duty_cycle(0)
         # Subtract five seconds from log file.
         Logger.writeLog(str(status - 5))
      else:
         print "Cannot close any further."
         #error="close"
   #return render_template('main.html', error=error)
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
   mac_string = open('/sys/class/net/wlan0/address').read()
   
   # Get the IP address.
   ip_string = check_output(['hostname', '-I'])
   ip_string = ip_string.split(" ")
   ip_string = ip_string[0]

   return render_template('options.html', uptime_string=uptime_string, ssid_string=ssid_string, mac_string = mac_string, ip_string = ip_string)
   
@app.route("/about")
def about():
   return render_template('about.html')
   
@app.route("/reboot")
def reboot():
   print("Rebooting!")
   os.system("sudo reboot")

#Obtain Nest Info
@app.route("/addPin", methods=['POST'])
def addPin():
    print(request.form['authpin'])
    return render_template('nest.html')
   
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=80, threaded=True, debug=True)
