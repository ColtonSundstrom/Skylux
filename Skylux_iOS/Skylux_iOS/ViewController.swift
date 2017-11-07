//
//  ViewController.swift
//  Skylux_iOS
//
//  Created by James Green on 11/6/17.
//  Copyright © 2017 James Green. All rights reserved.
//  Moscapsule: The MIT License (MIT)
//  Mosquitto: EPL/EDL license
//

import UIKit
import Foundation
import Moscapsule

let serverName = "coltonsundstrom.net"
let clientID = "Skylux_iOS"
let serverPort = 1883
let keepAlive = 60

let mqttConfig = MQTTConfig(clientId: String(describing: arc4random_uniform(1000000)), host: serverName, port: Int32(serverPort), keepAlive: Int32(keepAlive))
let mqttClient = MQTT.newConnection(mqttConfig)
class ViewController: UIViewController {
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var portLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBOutlet var connectButton: UIView!
    
    @IBAction func connectButtonClicked(_ sender: Any) {
        print("Am I connected to Colton's server?")
        print(mqttClient.isConnected)
        serverLabel.text = mqttConfig.host
        portLabel.text = String(describing: mqttConfig.port)
        statusLabel.text = String(describing: mqttClient.isConnected)
    }
    @IBAction func disconnectButtonClicked(_ sender: Any) {
        mqttClient.disconnect()
    }
    @IBAction func reconnectButtonClicked(_ sender: Any) {
        mqttClient.reconnect()
    }
    @IBAction func sendMessageButton(_ sender: Any) {
        mqttClient.publish(string: "Hello World", topic: "publish/topic", qos: 2, retain: false)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //set up mqtt configuration

        
        mqttConfig.onConnectCallback = { returnCode in
            NSLog("Return Code is \(returnCode.description)")
        }
        
        mqttConfig.onMessageCallback = { mqttMessage in
            NSLog("MQTT Message received: payload=\(String(describing: mqttMessage.payloadString))")
        }
        

        // publish and subscribe
        mqttClient.publish(string: "Hello World", topic: "publish/topic", qos: 2, retain: false)
        mqttClient.subscribe("subscribe/topic", qos: 2)
        
        // disconnect


    }

    func generateUserID()->String{
        return String(describing: arc4random_uniform(1000000))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

