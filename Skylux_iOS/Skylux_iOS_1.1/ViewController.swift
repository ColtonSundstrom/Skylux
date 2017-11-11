//
//  ViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 11/9/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

//made global so other functions can access
var jsonResponse : [String:AnyObject]?

class ViewController: UIViewController {
    //TODO: Replace with Colton's API
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var cLeading: NSLayoutConstraint!
    @IBOutlet weak var cTrailing: NSLayoutConstraint!
    var isMenuVisible = false
    
    @IBAction func onOpenTapped(_ sender: Any) {
        let parameters = ["command": "open", "id": "skylux-ios"]
        
        guard let url = URL(string:"http://coltonsundstrom.net:5000/skylux/api/open/2") else {return}
        print("making request")
        var request = URLRequest(url: url) //TODO update cache policy
        request.httpMethod = "PUT" //lets url session know we're posting
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
    @IBAction func onCloseTapped(_ sender: Any) {
        let parameters = ["command": "open", "id": "skylux-ios"]
        
        guard let url = URL(string:"http://coltonsundstrom.net:5000/skylux/api/close/2") else {return}
        print("making request")
        var request = URLRequest(url: url) //TODO update cache policy
        request.httpMethod = "PUT" //lets url session know we're posting
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
        print("making session")
        let session = URLSession.shared
        session.dataTask(with: url) { (data, url_response, error) in
            if let response = url_response{
                print("response is: ")
                print(response)
                print("end response")
            }
            
            if let data = data{
                print(data)
                do{
                    print("json response is: ")
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "statusSegue"){
            let destVC = segue.destination as! StatusViewController
            destVC.jsonResponse = jsonResponse
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

