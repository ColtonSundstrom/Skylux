//
//  history.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import Foundation
import MapKit

let global_historyobj = HistoryObj()

public class HistoryObj: NSObject, NSCoding{

    var historyArray = [(String, CLLocationCoordinate2D)]()
    var historyCmds = [String]()
    var historyCoords = [String]()
    
    //trying to implement UserDefaults and data saving.
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(historyArray, forKey: "historyArray")
        aCoder.encode(historyCmds, forKey: "historyCmds")
        aCoder.encode(historyCoords, forKey: "historyCoords")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        historyArray = aDecoder.decodeObject(forKey: "historyArray") as! [(String, CLLocationCoordinate2D)]
        historyCmds = aDecoder.decodeObject(forKey: "historyCmds") as! [String]
        historyCoords = aDecoder.decodeObject(forKey: "historyCoords") as! [String]
        
    }
    public override init() {
    }
    
    func append(name: String, coord: CLLocationCoordinate2D){
        let tuple = (name, coord)
        if(historyArray.count > 3){ //only hold 3 most recent commands
            historyArray.removeFirst()
            historyArray.append(tuple)
            historyCmds.removeFirst()
            historyCmds.append(name)
            historyCoords.removeFirst()
            historyCoords.append(String(describing: coord))
        }
        else{
            historyArray.append(tuple)
            historyCmds.append(name)
            historyCoords.append(String(describing:coord))
        }
    }
}
