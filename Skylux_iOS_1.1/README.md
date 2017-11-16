
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
