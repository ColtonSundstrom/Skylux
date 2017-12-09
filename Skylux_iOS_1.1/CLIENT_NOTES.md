master schedule *11-14-17*
-cloud drop
-getting schedule info from cloud drop contoller (master)
- scheduling only in one place (master)
-app mirroring what is in device
- be able to have commands that app can send via server
- vice versa: LAN direct commands when not on network
- controller doesnt know time/date data
-pings server to determine time
-in smart device
-if powered, you can use system clock and occasionally check
- ping every once in a while
-scheduling in phone itself (not robust)
-move to operator for full independent build
-get feedback that server recieved POST/GET RTT Feedback~
- use QR code for setup to obtain device ID information
-voice command makes more sense from control setup


11-28-17

coltonsundstrom
server support
transition for next quarter

setup?

server in middle
sevrer is static always known location
POST server side
TLS auth (token based)
authenticate then get status
username and password in plaintext
then get token for future authentication
schedule
proc a task when get POST for scheduling
send MQTT comnmands
point to point stretch goal

QR code / Setup
GPS tag when setup
QR code has ID number
Pin on map

user feedback
watchdog timer
timeout?
status update

12-5-17
two tables
devices ->statuses
users   -> register (POST) -> macaddress password user
-> login    (POST) -> user password

QR Code -> not randomly made up
MQTT -> sends topic (Devices)
anyone posts server listens
processes it by putting it into database
take mac address for physical device
embed macadress into qr code
address already exists

new flow

app launch -> register w/ camera -> login

next group -> encrypt login
public/private key
get key -> GET server sends public key 
