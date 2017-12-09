//
//  HelpTableViewController.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 11/11/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import UIKit

class HelpTableViewController: UITableViewController {

    var FAQ = [helpQuestion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create some questions
        FAQ.append(helpQuestion(question: "My command won't go through. Help?", answer: "This is caused by an authentication issue in the application. Log in and try again."))
        FAQ.append(helpQuestion(question: "What if the skylight won't go up or down all the way?", answer: "The log file must have been misaligned. Contact your network administrator and reset the log file."))
        FAQ.append(helpQuestion(question: "Does Skylux work offline?", answer: "Unfortunately, an internet connection is required to issue commands."))
        FAQ.append(helpQuestion(question: "Do I have to be connected to WiFi?", answer: "No! Skylux iOS works from any iOS device with an internet connection."))
        FAQ.append(helpQuestion(question: "Can hackers see my data?", answer: "No, data is encrypted when sent to the server, so hackers shouldn't be able to see any data."))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //  return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return FAQ.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? HelpTableViewCell

        // Configure the cell...
        let thisQuestion = FAQ[indexPath.row]
        cell?.questionLabel?.text = thisQuestion.question
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSelectedQuestion" {
            let destVC = segue.destination as? HelpDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.dataFromTableQuestion = FAQ[(selectedIndexPath?.row)!].question
             destVC?.dataFromTableAnswer = FAQ[(selectedIndexPath?.row)!].answer
        }
        
    }
    

}
