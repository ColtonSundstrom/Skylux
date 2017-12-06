//
//  LoginViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 11/28/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func onLoginPress(_ sender: Any) {
        if let username = usernameField.text{
            if let password = passwordField.text{
                //let storedEmail = UserDefaults.standard.string(forKey: username)
                //let storedPassword = UserDefaults.standard.string(forKey: "userPass")
                if let storedUserPassword = UserDefaults.standard.string(forKey: username){
                    print("login success!")
                    self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                }
            }

        }
        
        //print("Username is: \(usernameField.text) Password is: \(passwordField.text)")
        //let loginString = NSString(format: "%@:%@", (usernameField.text)!, (passwordField.text)!)
        //let loginData : Data = loginString.data(using: String.Encoding.utf8.rawValue)!
        //let base64login = loginData.base64EncodedString()
        
        //let url = URL(string: <#T##String#>)
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
