//
//  SkylightViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

class SkylightViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var manualEntryButton: UIButton!
    @IBOutlet weak var manualView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deviceAddress: UITextField!
    @IBAction func onRegTapped(_ sender: Any) {
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        superUser.mac = deviceAddress.text
        self.performSegue(withIdentifier: "manualSegue", sender: self)
    }
    @IBAction func onManualTapped(_ sender: Any) {
        if(manualView.isHidden){
            manualView.isHidden = false
            manualEntryButton.setTitle("Cancel", for: .normal)
        }
        else{
            manualView.isHidden = true
            manualEntryButton.setTitle("Enter Manually", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != nil{
            textField.resignFirstResponder()
            return false
        }
        return true
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
