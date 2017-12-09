//
//  OptionsViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var datePick: UIDatePicker!
    
    @IBAction func buttonPress(_ sender: Any) {
        if superUser.requestToken == nil{
            print("error: not authorized")
            return
        }
        let timeInfo = datePick.date.timeIntervalSinceReferenceDate
        print(timeInfo.description)
        let parameters = ["time": String(describing: timeInfo),
                          "command": "ON",
                          "token": superUser.requestToken!]
        let urlString = "http://coltonsundstrom.net:5000/skylux/api/schedule"
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
    override func viewDidLoad() {
        super.viewDidLoad()
        datePick.datePickerMode = .time
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