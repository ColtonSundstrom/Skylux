//
//  Customer.swift
//  TableModelStarter
//
//  Created by Randy Scovil on 2/26/15.
//  Copyright (c) 2015 Randy Scovil. All rights reserved.
//

import Foundation
import MapKit

// NSObject superclass required
class HistoryNib : NSObject, NSCoding {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("savedHistory")
    
    
    var command : String
    var latitude : Double
    var longitude : Double
    
    init (command: String, coord: CLLocationCoordinate2D) {
        self.command = command
        self.latitude = coord.latitude
        self.longitude = coord.longitude
    }
    
    required init?(coder aDecoder: NSCoder) {
        command = aDecoder.decodeObject(forKey: "command") as! String
        latitude = aDecoder.decodeObject(forKey: "latitude") as! Double
        longitude = aDecoder.decodeObject(forKey: "longitude") as! Double
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(command, forKey: "command")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
    }
    
    override var description : String {
        get {
            return "Command: \(command)  Latitude: \(latitude)  Longitude: \(longitude)"
        }
    }
}

