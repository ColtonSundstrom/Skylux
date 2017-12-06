//
//  User.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 12/5/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import Foundation

public class User: NSObject{
    var username: String
    var password: String
    var requestToken: String?
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        super.init()
    }
    
}
