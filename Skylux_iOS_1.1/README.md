
Microphone Icon by Aya Sofya from Noun Project

MAJOR DEVELOPMENT UPDATE:

In milestone 2, I suggested that I would use the iPhone camera in order to utilize the OPEN/CLOSE commands.
However, considering the scope of my project, the operator was considered to be "out of sight, out of mind".
My client and I wanted to ensure the ease of use for the client when using the Skylux system, and we couldn't come up with a use for the camera that seemed intuitive.
Keeping these thoughts in mind, I pivoted on the initial design I set out in previous milestones and am now developing using the Speech kit that was introduced in iOS 10.


API's and TECHNOLOGIES

As of now, I am able to create POST/GET requests made to coltonsundstrom.net, which is the backend API that my capstone partner has been working on.
Currently, the data produced will show up in the console, with minimal on-screen feedback.
The GET requests can be seen upon startup, which indicates the status of the Skylight.
The POST requests can be seen when the user taps OPEN/CLOSE, which will be met with a successful status code and a post result.


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
        
    
