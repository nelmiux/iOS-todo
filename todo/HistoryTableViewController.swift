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
    private var userPhotos = Dictionary<String, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData () {
        var keys = [String]()
        var vals = [String]()
        for date in history.keys {
            if (history[date] as String!).rangeOfString("created") == nil {
                keys.append(date as String!)
                vals.append(history[date] as String!)
            }
        }
        
        self.data.0 = keys
        self.data.1 = vals
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create the history cell and populate with data
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryTableViewCell
        cell.parentViewController = self
        
        // Populate with general data regardless of tutor vs requestor.
        let parsedData = self.parseData(indexPath.row)
        let role = parsedData["role"]!
        let involvedUser = parsedData["involvedUser"] as String!
        cell.setUser(involvedUser)
        cell.dateLabel.text = parsedData["date"]
        cell.descriptionLabel.text = parsedData["event"]
        cell.dotsLabel.text = parsedData["numDots"]
        /* if involvedUser.characters.count > 0 {
            if userPhotos.keys.contains(involvedUser) {
                cell.userPhoto.image = userPhotos[involvedUser]
                print("\(involvedUser) was found in list")
            } else {
                dispatch_group_enter(downloadGroup)
                getUserPhoto(involvedUser, imageView: cell.userPhoto)
                dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER)
                userPhotos[involvedUser] = cell.userPhoto.image
                dispatch_group_leave(downloadGroup)
                print("\(involvedUser) was added to list")
            }
        } */
        
        getUserPhoto(involvedUser, imageView: cell.userPhoto)
        
        // Do any additional UI modifications accourding to tutor vs requestor.
        if role == "tutor" {
            cell.dotsBg.image = UIImage(named: "GainedDotsBg.png")
        } else if role == "requester" {
            cell.dotsBg.image = UIImage(named: "SpentDotsBg.png")
        }
        
        return cell
    }
    
    func parseData (index:Int) -> Dictionary<String, String> {
        var result: Dictionary<String, String> = ["date" : "", "role" : "", "event" : "", "numDots": "", "involvedUser": ""]
        
        let value = self.data.1[index]
        
        let rangeOfColon = value.rangeOfString(":")
        if rangeOfColon != nil {
            // First separate the role and actual event description into two values.
            let role = value.substringToIndex((rangeOfColon?.startIndex)!)
            result["role"] = role
            let event = value.substringFromIndex((rangeOfColon?.startIndex.advancedBy(2))!)
            result["event"] = event
            
            // Retrieve the other user involved (ie., the tutor or the requestor).
            let eventArr = value.characters.split{$0 == " "}.map(String.init)
            if role == "tutor" {
                result["involvedUser"] = eventArr[3]
            } else if role == "requester" {
                let tutor = eventArr[eventArr.count - 1]
                let name = tutor.substringToIndex(tutor.endIndex.predecessor().advancedBy(1))
                result["involvedUser"] = name
            }
            
            for item in eventArr {
                let components = item.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                let part = components.joinWithSeparator("")
                
                if Int(part) != nil {
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
    
    @IBAction func returnToHistoryViewController(segue:UIStoryboardSegue) {}
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayUserProfile" {
            let destVC = segue.destinationViewController as! ProfileViewController
            let user = (sender as! UserPhotoButton).getUser()
            
            destVC.username = user
            destVC.isOwnProfile = false
        }
    }

}
