//
//  User.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import Foundation

let superUser = User(username: "DEFAULT_USER", password: "DEFAULT_PASS")

public class User: NSObject{
    var username: String
    var password: String
    var requestToken: String?
    var mac: String?
    var dev_id: String?
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        super.init()
    }
    
    func cleanMac(){
        if !(mac?.isEmpty)!{
            mac = mac!.replacingOccurrences(of: ":", with: "")
        }
    }
    
}
