//
//  ViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 11/9/17.
//  Copyright © 2017 James Green. All rights reserved.
//
//  Uses Speech recognition kit instead of AR camera kit as mentioned in Milestone 2

import UIKit
import Speech

//made global so other functions can access
var jsonResponse : [String:AnyObject]?

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var micButton: UIButton!
    
    @IBOutlet weak var stopRecButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
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
            print("don't crash when you double tap the button")
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
    
    
    func speechEngine() throws{
        let node = audioEngine.inputNode
        let format = node.outputFormat(forBus: 0)
        node.removeTap(onBus: 0)
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
        do{
        try task = speechRecognizer?.recognitionTask(with: request, resultHandler: { (res, err) in
            if let res = res{
                let whatTheySaid = res.bestTranscription.formattedString
                print(whatTheySaid)
            } else if let err = err{
                print("@@@@@@")
                print(err)
            }
        })
        } catch {
            audioEngine.stop()
        }
    }
    @IBAction func onOpenTapped(_ sender: Any) {
        let parameters = ["command": "ON"]
        var urlString = "http://coltonsundstrom.net:5000/skylux/api/device/"
        urlString.append(String(describing: deviceNumber))
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
                }catch{
                    print("there was an error")
                    print(error)
                }
            }
            }.resume()
    }
    @IBAction func onCloseTapped(_ sender: Any) {
        let parameters = ["command": "OFF"]
        var urlString = "http://coltonsundstrom.net:5000/skylux/api/device/"
        urlString.append(String(describing: deviceNumber))
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
            menuButton.title = "Close Menu"
            
        }
        else{
            menuButton.title = "Menu"
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
    
    @IBAction func onGetTapped(_ sender: Any) {

    }
    
    @IBAction func onPostTapped(_ sender: Any) {
        
        let parameters = ["username": "@greenjames", "tweet": "hello world"]
        
        guard let url = URL(string:"https://jsonplaceholder.typicode.com/posts/1") else {return}
        var request = URLRequest(url: url) //TODO update cache policy
        request.httpMethod = "PUT" //lets url session know we're posting
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{ print(response)}
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch{
                    print(error)
                }
            }
        }.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "http://coltonsundstrom.net:5000/skylux/api/status/2") else {return}
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request = URLRequest(url: url)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            
            if let data = receivedData {
                print("***")
                // uncomment to print raw response
                                let rawDataString = String(data: data, encoding: String.Encoding.utf8)
                                print(rawDataString!)
                
                var jsonResponse : [String:AnyObject]?
                
                do {
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                }
                catch {
                    print("Caught exception")
                }
                
                // print dictionary after serialization
                //print(jsonResponse!)
                
                // check high-level keys for collections
                
                //print("\nDrill down of JSON structure:")
                //self.jsonDrillDown(json: jsonResponse!, indent: "")
            }
        }
        
        task.resume()
        //print("making session")
        //let session = URLSession.shared
        //session.dataTask(with: url) { (data, url_response, error) in
        //    if let response = url_response{
        //        print("response is: ")
        //        print(response)
        //        print("end response")
        //    }
        //
        //    if let data = data{
        //        print(data)
        //        do{
        //            print("json response is: ")
        //            jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
        //            print(jsonResponse)
        //            print("end json")
        //            print("Is the response empty now???")
        //        } catch{
        //            print("error is")
         //           print(error)
         //           print("end error")
         //       }
         //   }
         //   }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "statusSegue"){
            print("Is the response empty now???")
            print(jsonResponse?.isEmpty as Any)
            print("now gonna send it to the status screen")
            let destVC = segue.destination as! StatusViewController
            destVC.jsonResponse = jsonResponse
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

