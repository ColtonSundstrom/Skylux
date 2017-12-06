//
//  StatusViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 11/10/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit
import MapKit

class StatusViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var jsonResponse : [String:AnyObject]?
    var jsonGetResponse: (Bool, AnyObject)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(jsonGetResponse?.1)
        if let responseArray = jsonGetResponse?.1{
            print(responseArray)
        }
        
        // Do any additional setup after loading the view.
       // let skylightStatus = (jsonResponse!["Skylight Status"] as? [[String: Any]])!
        

        //let skylightStatus = jsonResponse?.popFirst()
        //let title = skylightStatus?.key
        //var body  = (skylightStatus?.value as! [Any])
        //print(body)
        
        //titleLabel.text = title
        //let statusReport = body.popLast()! as! Int
        //print(statusReport)
        //if(statusReport > 0){
        //    bodyLabel.text = "Open"
       // }
       // else{
       //     bodyLabel.text = "Close"
       // }
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
