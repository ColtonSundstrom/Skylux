//
//  RegisterViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 12/4/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var confirmUsernameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
            //UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newUser), forKey: userText!)
            //UserDefaults.standard.set(newUser, forKey: userText!)
            getUserToken(user: newUser)
            UserDefaults.standard.setValue(passText, forKey: userText!)
            UserDefaults.standard.synchronize()
            activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }
    }
    
    func errorLabelSet(label: String) {
        errorLabel.isHidden = false
        errorLabel.text = label
        errorLabel.isHighlighted = true
    }
    
    func getUserToken(user: User){
        let loginString = ["username" : user.username,
        "password" : user.password] as [String: String]
        print(loginString)
        print("logging in...")
        //make a request
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginString, options: .prettyPrinted)
        } catch let error {
            print("Error on line 74")
            print(error.localizedDescription)
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error on token auth: \(String(describing: error))")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                // check status code returned by the http server
                print("status code = \(httpResponse.statusCode)")
                // process result
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    if let parseJson = json {
                        let userID = parseJson["userId"] as? String
                        print("user ID is: \(userID)")
                    }
                } catch{
                    print("Error line 95")
                    print(error)
                }

            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
