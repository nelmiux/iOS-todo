//
//  HistoryTableViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    // Class attributes
    private var data:([String],[String]) = ([],[])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData () {
        var keys = [String]()
        var vals = [String]()
        for date in history.keys {
            keys.append(date as String!)
            vals.append(history[date] as String!)
        }
        
        // let keys = ["March 28, 2016, 7:43 PM", "March 10, 2016, 9:30 AM"]
        // let vals = ["tutor: You tutored testNelma for 45 dots in CS 378: iOS Mobile Computing.", "requester: You spent 60 dots on tutoring in CS 312: Introduction to Java Programming from testTutor."]
        self.data.0 = keys
        self.data.1 = vals
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.0.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create the history cell and populate with data
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        // Populate with general data regardless of tutor vs requestor.
        // Below includes
        let parsedData = self.parseData(indexPath.row)
        let role = parsedData["role"]
        cell.dateLabel.text = parsedData["date"]
        cell.descriptionLabel.text = parsedData["event"]
        cell.dotsLabel.text = parsedData["numDots"]
        
        // Do any additional UI modifications accourding to tutor vs requestor.
        if role == "tutor" {
            cell.dotsBg.image = UIImage(named: "GainedDotsBg.png")
        } else if role == "requester" {
            cell.dotsBg.image = UIImage(named: "SpentDotsBg.png")
        } else if role == "" {
            // First history event of first login. Hide photo and dots UI
            cell.dotsLabel.hidden = true
            cell.dotsBg.hidden = true
            cell.userPhoto.hidden = true
        }
    
        return cell
    }
    
    func parseData (index:Int) -> Dictionary<String, String> {
        var result: Dictionary<String, String> = ["date" : "", "role" : "", "event" : "", "numDots": ""]
        
        let value = self.data.1[index]
        let indexOfColon = value.characters.indexOf(":")
        if indexOfColon < value.startIndex && indexOfColon != nil {
            let posOfColon = value.startIndex.distanceTo(indexOfColon!)
            let role = value.substringToIndex(value.startIndex.advancedBy(posOfColon))
            result["role"] = role
            
            let event = value.substringFromIndex(value.startIndex.advancedBy(posOfColon).advancedBy(2))
            result["event"] = event
            if role == "tutor" {
                
            } else if role == "requestor" {
                
            }
            
            let eventArr = event.characters.split{$0 == " "}.map(String.init)
            for item in eventArr {
                let components = item.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                let part = components.joinWithSeparator("")
                
                if let intVal = Int(part) {
                    result["numDots"] = result["role"] == "tutor" ? ("+\(part)") : ("-\(part)")
                    break
                }
            }
        } else {
            result["event"] = value
        }
        
        let dateArr = self.data.0[index].characters.split{$0 == ","}.map(String.init)
        result["date"] = (" \(dateArr[0]), \(dateArr[1])")
        return result
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.data.0.removeAtIndex(indexPath.row)
            self.data.1.removeAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    } */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
