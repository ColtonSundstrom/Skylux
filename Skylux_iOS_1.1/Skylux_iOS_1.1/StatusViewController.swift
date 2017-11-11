//
//  StatusViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 11/10/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    
    var jsonResponse : [String:AnyObject]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // let skylightStatus = (jsonResponse!["Skylight Status"] as? [[String: Any]])!
        print(jsonResponse!)
        //for (key,value) in jsonResponse! {
        //    if value is [String:AnyObject] {
        //        print("\(key) is a Dictionary")
        //    }
        //    else if value is [AnyObject] {
        //        print("\(key) is an Array")
        //    }
        //    else {
        //        print(type(of: value))
        //    }
        //}
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
