//
//  HelpDetailViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 11/11/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

class HelpDetailViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var dataFromTableQuestion: String?
    var dataFromTableAnswer: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = dataFromTableQuestion!
        answerLabel.text = dataFromTableAnswer!
        // Do any additional setup after loading the view.
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
