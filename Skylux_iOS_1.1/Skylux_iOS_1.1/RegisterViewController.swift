//
//  RegisterViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit
import MapKit

class RegisterViewController: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate{
    var jsonResponse : [String:AnyObject]?
    var dev_id: Int?
    var locationManager: CLLocationManager?
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var confirmUsernameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //globals
    private var confirmedUsername: String?
    private var confirmedPassword: String?
    
    @IBAction func onRegTapped(_ sender: Any) {
        
        activityIndicator.startAnimating()
        let userText = usernameField.text
        let confirmUserText = confirmUsernameField.text
        let passText = passField.text
        let confirmPassText = confirmPassField.text
        if userText != confirmUserText{
            errorLabelSet(label: "Error: Usernames don't match")
            activityIndicator.stopAnimating()
        }
        else if passText != confirmPassText {
            errorLabelSet(label: "Error: Passwords don't match")
            activityIndicator.stopAnimating()
        }
        else if (passText?.isEmpty)! || (userText?.isEmpty)! || (confirmPassText?.isEmpty)! || (confirmUserText?.isEmpty)!{
            errorLabelSet(label: "Error: All fields must be filled")
            activityIndicator.stopAnimating()
        }
        else{
            errorLabel.isHidden = true
            //save user info
            let newUser = User(username: userText!, password: passText!)
            confirmedUsername = userText!
            confirmedPassword = passText!
            //UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newUser), forKey: userText!)
            //UserDefaults.standard.set(newUser, forKey: userText!)
            //getUserToken(user: newUser)
            UserDefaults.standard.setValue(passText, forKey: userText!)
            UserDefaults.standard.synchronize()
            activityIndicator.stopAnimating()
            self.sendRegister()
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }
    }
    

    @IBAction func onSetupTapped(_ sender: UIButton) {
        //registerButton.isEnabled = true
        //registerButton.backgroundColor = UIColor.green
    }
    
    func errorLabelSet(label: String) {
        errorLabel.isHidden = false
        errorLabel.text = label
        errorLabel.isHighlighted = true
    }
    
    func sendRegister(){
        print("register!")
        if(confirmedPassword == nil || confirmedUsername == nil){
            print("invalid paramaters")
            return
        }
        superUser.cleanMac()
        let parameters = ["username": confirmedUsername!,
                          "password": confirmedPassword!,
                          "mac" : superUser.mac!]
        print("parameters are: \(parameters)")
        var urlString = "http://coltonsundstrom.net:5000/skylux/api/register"
        guard let url = URL(string:urlString) else {return}
        print("making request")
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //lets url session know we're posting
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = body
        let session = URLSession.shared
        session.dataTask(with: request) { (data, url_response, error) in
            if let response = url_response{
                print("response is: ")
                print(response)
                print("end response")
            }
            
            if let data = data{
                print(data)
                //print("***")
                //let rawDataString = String(data: data, encoding: String.Encoding.utf8)
                //print(rawDataString!)
                do{
                    print("json response is: ")
                    self.jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    if(self.jsonResponse != nil){
                        print(self.jsonResponse!)
                    }
                    else{
                        print("there's nothing here")
                    }
                    if(self.jsonResponse?["error"] != nil){
                        DispatchQueue.main.async {
                            self.errorLabel.isHidden = false
                            self.errorLabel.isHighlighted = true
                        }
                    }
                    if(self.jsonResponse?["device id"] != nil){
                        DispatchQueue.main.async {
                            self.errorLabel.isHidden = false
                            self.errorLabel.isHighlighted = true
                            self.errorLabel.text = "Authentication Complete"
                            self.errorLabel.textColor = UIColor.green
                            self.dev_id = self.jsonResponse?["device id"] as! Int
                            //self.performSegue(withIdentifier: "authSegue", sender: self)
                            //print("DEV ID IS: \(self.dev_id)")
                        }
                    }
                    //print(jsonData)
                    print("end json")
                } catch{
                    print("error is")
                    print(error)
                    print("end error")
                }
            }
        
        }.resume()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != nil{
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        // Do any additional setup after loading the view.
        self.usernameField.delegate = self
        self.confirmUsernameField.delegate = self
        self.passField.delegate = self
        self.confirmPassField.delegate = self
        if(superUser.mac != nil){
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.green
        }
        
        if let retrievedUser = UserDefaults.standard.object(forKey: "username_reg"){
            usernameField.text = retrievedUser as? String
        }
        if let retrievedPass = UserDefaults.standard.object(forKey: "pass_reg"){
            passField.text = retrievedPass as? String
        }
        if let retrievedUserConf = UserDefaults.standard.object(forKey: "usernameconf_reg"){
            confirmUsernameField.text = retrievedUserConf as? String
        }
        if let retrievedPassConf = UserDefaults.standard.object(forKey: "passconf_reg"){
            confirmPassField.text = retrievedPassConf as? String
        }
        
        self.locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        UserDefaults.standard.set(usernameField.text, forKey: "username_reg")
        UserDefaults.standard.set(passField.text,forKey: "pass_reg")
        UserDefaults.standard.set(confirmUsernameField.text, forKey: "usernameconf_reg")
        UserDefaults.standard.set(passField.text, forKey: "passconf_reg")
        let deviceCoord = self.locationManager?.location?.coordinate
        let deviceLat = String(describing: deviceCoord!.latitude)
        let deviceLon = String(describing: deviceCoord!.longitude)
        UserDefaults.standard.set(deviceLat, forKey: "deviceLat")
        UserDefaults.standard.set(deviceLon, forKey: "deviceLon")
    }
    

}
