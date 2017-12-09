//
//  StatusViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit
import MapKit

class StatusViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var jsonResponse : [String:AnyObject]?
    var status: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlString = "http://coltonsundstrom.net:5000/skylux/api/status/2" //TODO: mutable url
        guard let url = URL(string:urlString) else {return}
        print("making request")
        var request = URLRequest(url: url)
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
                    if(self.jsonResponse?["error"] != nil){
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                    if(self.jsonResponse?["Skylight Status"] != nil){
                        DispatchQueue.main.async {
                            let status = self.jsonResponse?["Skylight Status"]
                            //self.performSegue(withIdentifier: "authSegue", sender: self)
                            print("status IS: \(status! as! Int)")
                            let intstatus = status! as! Int
                            
                            if intstatus > 0{
                                self.bodyLabel.text = "Open (\(intstatus))"
                            }
                            else{
                                self.bodyLabel.text = "Closed"
                            }
                            
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
        print(status)
        titleLabel.text = "Skylight Status"
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
