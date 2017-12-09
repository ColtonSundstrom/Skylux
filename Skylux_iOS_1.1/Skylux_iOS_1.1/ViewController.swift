//
//  ViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//
//  Uses Speech recognition kit instead of AR camera kit as mentioned in Milestone 2

import UIKit
import Speech
import MapKit

class ViewController: UIViewController, SFSpeechRecognizerDelegate, CLLocationManagerDelegate {
    var authToken : String?
    var jsonResponse : [String:AnyObject]?
    var skylightStatus: Int?
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var micButton: UIButton!
    
    @IBOutlet weak var stopRecButton: UIButton!
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var cLeading: NSLayoutConstraint!
    @IBOutlet weak var cTrailing: NSLayoutConstraint!
    var isMenuVisible = false
    var deviceNumber = 2
    let speechRecognizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    let audioEngine = AVAudioEngine()
    var task: SFSpeechRecognitionTask?
    let request = SFSpeechAudioBufferRecognitionRequest()
    
    @IBAction func onMicrophoneTapped(_ sender: Any) {
        do{
            try self.speechEngine()
            micButton.isEnabled = false
            stopRecButton.isHidden = false
            stopRecButton.isEnabled = true
        } catch{
            print("Tap the button only once")
        }
    }
    
    @IBAction func stopRecordingTapped(_ sender: Any) {
        audioEngine.stop()
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        // Indicate that the audio source is finished and no more audio will be appended
        micButton.isEnabled = true
        stopRecButton.isHidden = true
    }
    
    func busyLock(){
        print("locked!")
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        myActivityIndicator.color = UIColor.gray
        myActivityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.myActivityIndicator.stopAnimating()
        }
    }
    
    func busyUnlock(){
        print("unlocked!")
        myActivityIndicator.stopAnimating()
        //myActivityView.stopAnimating()
    }
    
    
    func speechEngine() throws{
        var resultString = ""
        let node = audioEngine.inputNode
        let format = node.outputFormat(forBus: 0)
        node.removeTap(onBus: 0) //prevent multiple busses from being installed
        node.installTap(onBus: 0, bufferSize: 1024, format: format) {buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch{
            print("Error: ")
            print(error)
            return
        }
        
        guard let tempListener = SFSpeechRecognizer() else{
            return print("mic not supported")//not supported
        }
        if !tempListener.isAvailable {
            return print("mic not available")
        }
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { (res, err) in
            if let res = res{
                let whatTheySaid = res.bestTranscription.formattedString
                print(whatTheySaid)
                resultString.append(whatTheySaid)
                if whatTheySaid.contains("open"){
                    self.stopRecordingTapped(AnyClass.self)
                    self.onOpenTapped(AnyClass.self)
                    print("open")
                }
                else if whatTheySaid.contains("close")
                {
                    self.stopRecordingTapped(AnyClass.self)
                    self.onCloseTapped(AnyClass.self)
                }
                else if whatTheySaid.contains("history")
                {
                    self.stopRecordingTapped(AnyClass.self)
                    self.performSegue(withIdentifier: "historySegue", sender: self)
                }
                else if whatTheySaid.contains("schedule")
                {
                    self.stopRecordingTapped(AnyClass.self)
                    self.performSegue(withIdentifier: "optionsSegue", sender: self)
                }
                else if whatTheySaid.contains("help")
                {
                    self.stopRecordingTapped(AnyClass.self)
                    self.performSegue(withIdentifier: "helpSegue", sender: self)
                }
                
                
            } else if let err = err{
                print("@@@@@@")
                print(err)
            }
        })
    }
    
    @IBAction func onOpenTapped(_ sender: Any) {
        print("open!")
        busyLock()
        let parameters = ["command": "ON",
                          "token": self.authToken!]
        var urlString = "http://coltonsundstrom.net:5000/skylux/api/device"
        //urlString.append(String(describing: deviceNumber))
        print("*****")
        print(urlString)
        guard let url = URL(string:urlString) else {return}
        print("making request")
        var request = URLRequest(url: url) //TODO update cache policy
        request.httpMethod = "POST" //lets url session know we're posting
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = body
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{ print(response)}
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    print("Location is \(self.locationManager?.location?.coordinate)")
                    global_historyobj.append(name: "Open", coord: (self.locationManager?.location?.coordinate)!)
                    let coord = self.locationManager?.location?.coordinate
                    UserDefaults.standard.set("Open", forKey: "lastCommand")
                    UserDefaults.standard.set(String(describing: coord!.latitude), forKey: "lastCommandLat")
                    UserDefaults.standard.set(String(describing: coord!.longitude), forKey: "lastCommandLon")

                }catch{
                    print("there was an error")
                    print(error)
                }
            }
            self.busyUnlock()

            }.resume()
        
    }
    
    @IBAction func onCloseTapped(_ sender: Any) {
        busyLock()
        let parameters = ["command": "OFF",
                          "token": self.authToken!]
        var urlString = "http://coltonsundstrom.net:5000/skylux/api/device"
        //urlString.append(String(describing: deviceNumber))
        print("*****")
        print(urlString)
        guard let url = URL(string:urlString) else {return}
        print("making request")
        var request = URLRequest(url: url) //TODO update cache policy
        request.httpMethod = "POST" //lets url session know we're posting
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = body
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{ print(response)}
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    print("Location is \(self.locationManager?.location?.coordinate)")
                    
                    global_historyobj.append(name: "Close", coord: (self.locationManager?.location?.coordinate)!)
                    let coord = self.locationManager?.location?.coordinate
                    let lat = String(describing: coord!.latitude)
                    let lon = String(describing: coord!.longitude)
                    UserDefaults.standard.set("Close", forKey: "lastCommand")
                    UserDefaults.standard.set(lat, forKey: "lastCommandLat")
                    UserDefaults.standard.set(lon, forKey: "lastCommandLon")
                }catch{
                    print(error)
                }
            }

            }.resume()
        
        
    }
    
    @IBAction func onMenuTapped(_ sender: Any) {
        if !isMenuVisible{
            cLeading.constant = 150
            cTrailing.constant = -150
            isMenuVisible = true
            menuButton.setTitle("Close", for: .normal)
            
        }
        else{
            menuButton.setTitle("Menu", for: .normal)
            cLeading.constant = 0
            cTrailing.constant = 0
            isMenuVisible = false
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("Menu slide complete")
        }
        
    }
    
    override func viewDidLoad() {
        print("starting location manager")
        let retrievedAuth = UserDefaults.standard.object(forKey: "auth_token")
        self.authToken = retrievedAuth as? String
        if retrievedAuth == nil{
            performSegue(withIdentifier: "loginSegue", sender: Any?.self)
        };
        self.locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("WE'RE IN")
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
        
        print("Location is \(locationManager?.location?.coordinate)")
        print("end location manager")
        
        //DispatchQueue.global(qos: .userInitiated).async {
        //    // Download file or perform expensive task
        //    self.busyLock()
        //    self.apiClient.get()
        //    self.busyUnlock()
        //    DispatchQueue.main.async {
        //        // Update the UI
        //    }
       // }
        super.viewDidLoad()
        print("END LOAD")

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "statusSegue"){
            
            //let destVC = segue.destination as! StatusViewController
            //destVC.status = skylightStatus
            //print("DESTVC STATUS IS \(destVC.status)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

