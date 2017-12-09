//
//  LoginViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var jsonResponse : [String:AnyObject]?

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var authToken: String?

    @IBAction func onLoginPress(_ sender: Any) {
        if let username = usernameField.text{
            if let password = passwordField.text{
                self.sendLogin()
                if let storedUserPassword = UserDefaults.standard.string(forKey: username){
                    print("login success!") //first check user exists app-side, then server
                    //self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                }
            }

        }
    }
    
    func sendLogin(){
        let parameters = ["username": usernameField.text,
                          "password": passwordField.text]
        guard let url = URL(string: "http://coltonsundstrom.net:5000/skylux/api/login") else {return}
        print("making request")
        var request = URLRequest(url: url) //TODO update cache policy
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
                print("***")
                let rawDataString = String(data: data, encoding: String.Encoding.utf8)
                print(rawDataString!)
                do{
                    print("json response is: ")
                    self.jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    if(self.jsonResponse != nil){
                        print(self.jsonResponse!)
                    }
                    else{
                        print("there's nothing here")
                    }
                    if(self.jsonResponse?["error"] != nil){ //not authenticated, must try again
                        DispatchQueue.main.async {
                            self.errorLabel.isHidden = false
                            self.errorLabel.isHighlighted = true
                        }
                    }
                    if(self.jsonResponse?["token"] != nil){ //authenticated, get token and save
                        DispatchQueue.main.async {
                            self.errorLabel.isHidden = false
                            self.errorLabel.isHighlighted = true
                            self.errorLabel.text = "Authentication Complete"
                            self.errorLabel.textColor = UIColor.green
                            self.authToken = self.jsonResponse?["token"] as! String
                            UserDefaults.standard.set(self.authToken, forKey: "auth_token")
                            superUser.requestToken = self.authToken
                            self.performSegue(withIdentifier: "authSegue", sender: self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //allows keyboard to close on tap
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //allows keyboard to close on enter
        if textField != nil{
            textField.resignFirstResponder()
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "authSegue"){
            let destVC = segue.destination as! ViewController
            destVC.authToken = self.authToken
        }
    }

}
