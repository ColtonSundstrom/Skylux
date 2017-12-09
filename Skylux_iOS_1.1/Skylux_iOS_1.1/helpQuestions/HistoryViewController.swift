//
//  HistoryViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit
import MapKit

class HistoryViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lastCmdLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    var retCmd : String?
    var retLon : Double?
    var retLat : Double?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        if let retrievedCommand = UserDefaults.standard.object(forKey: "lastCommand"){
            print(String(describing: retrievedCommand))
            retCmd = String(describing: retrievedCommand)
        }
        if let retrievedLat = UserDefaults.standard.object(forKey: "lastCommandLat"){
            print(String(describing: retrievedLat))
            retLat = Double(String(describing: retrievedLat))
        }
        else{
            print("no lat")
        }
        if let retrievedLon = UserDefaults.standard.object(forKey: "lastCommandLon"){
            print(String(describing: retrievedLon))
            retLon = Double(String(describing: retrievedLon))
        }
        else{
            print("no lon")
        }
        if let retrievedDevLon = UserDefaults.standard.object(forKey: "deviceLon"){
            print("DEV LON")
            print(String(describing: retrievedDevLon))
        }
        else{
            print("no lon")
        }
        if let retrievedDevLat = UserDefaults.standard.object(forKey: "deviceLat"){
            print("DEV LAT")
            print(String(describing: retrievedDevLat))
        }
        else{
            print("no lon")
        }
        
        let cmdCoord = CLLocationCoordinate2D(latitude: retLat!, longitude: retLon!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = cmdCoord
        mapView.addAnnotation(annotation)
        lastCmdLabel.text = retCmd
        //rounding
        retLat = (retLat! * 1000) / 1000
        retLon = (retLon! * 1000) / 1000
        locationLabel.text = "Coordinates: {\(retLat!) , \(retLon!)}"
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation.subtitle! != nil) {
            let pinView = MKPinAnnotationView()
            pinView.pinTintColor = .red
            pinView.canShowCallout = true
            pinView.sizeToFit()
            
            return pinView
        }
        
        return nil
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
