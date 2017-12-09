//
//  QRViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var session: AVCaptureSession?
    var videoPreview: AVCaptureVideoPreviewLayer?
    var qrView: UIView?
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: device!)
            session = AVCaptureSession()
            session?.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            session?.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            //present video
            videoPreview = AVCaptureVideoPreviewLayer(session: session!)
            videoPreview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreview?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreview!)
            
            
            //enable frame
            qrView = UIView()
            if let qrView = qrView{
                qrView.layer.borderColor = UIColor.green.cgColor
                qrView.layer.borderWidth = 2
                view.addSubview(qrView)
                view.bringSubview(toFront: qrView)
                view.bringSubview(toFront: messageLabel)
            }
            
            session?.startRunning()

        } catch{
            print("Error capturing QR Code: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreview?.transformedMetadataObject(for: metadataObj)
            qrView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil { //found QR
                messageLabel.text = metadataObj.stringValue
                superUser.mac = metadataObj.stringValue //assumes correct QR Code
                performSegue(withIdentifier: "qrSegue", sender: self)
                (session?.stopRunning())!
                return
            }
            
        }
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
