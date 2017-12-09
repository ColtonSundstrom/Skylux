
Microphone Icon by Aya Sofya from Noun Project


App Features:

PROFESSOR SCOVIL READ HERE:

SETUP PROCESS:

    1) Ensure you have Paho-MQTT installed. This can be done by running
            pip install Paho-MQTT
    2) Start up DummyDevice.py. This allows you to see the open/close commands being sent via the server.
    3) Register with all required information. The MAC for the test device is 11:22:33:44:55:66. This is embedded in SKYLUX_MAC.png for the QR code reading.
    4) Log in with your provided information from step 4.
    5) Issue commands and see them being received by the test device in DummyDevice.py
    
THINGS TO NOTE:
    1) Scheduling isn't currently implemented server-side. You will get error code 500 if you submit a schedule, but the server does store the information.
    2) If the commands aren't working, then you must re login. Simply open menu->login.
    3) Location services and camera access are required to run this application. Ensure you have the proper permissions enabled.
    4) To ensure everything is properly laid out, run simulation on a device iPhone 6s or later.

QR CODE READER

The QR code reader is used under the register skylight screen. It is assumed that the QR code will contain a MAC address with 6 tuples separated by colons. This information is then sent to the server upon registration.


LOGIN/REGISTRATION

The logn/registration process isnt anything too revolutionary. When registering, the user sends a username and password to the server via an API POST to Colton Sundstrom's (my CPE 350/450 Partner) MQTT server. This is relatively similar to the firebase/Google auth process, in that the username password combo is saved on the server along with the associated MAC for the machine they are registered to.

Logging in involves sending the user name and password, and if correct, the server will reply with an authentication token. This alows for more secure communication and allows for sending commands to the server without having to provide too much information. Whenever a command is made, an auth token is sent with it so the server knows exactly who sent what.

MICROPHONE SPEECH ENGINE

Tapping the microphone button begins the Skylux listening process. It listens for commands then performs segues based on those commands. Commands must be prefaced with the word "Skylight". I.e. "Skylight open", "Skylight help", etc.. The microphone can open all pages in the application and issue commands.


MILESTONE 3

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



        
    
