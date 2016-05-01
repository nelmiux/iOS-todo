//
//  NotificationsTableViewController.swift
//  todo
//
//  Created by mac on 3/1/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {
    
    private let standardNotifications:[String] = ["request", "acceptance", "cancelledSession"]
    
    var notificationCopy:([String],[String],[String]){
        var notificationKeysCopy = [String]()
        var notificationTypesCopy = [String]()
        var notificationMessagesCopy = [String]()
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        dispatch_sync(taskQueue) {
            for key in notifications.keys{
                notificationKeysCopy.append(key)
            }
            for value in notifications.values{
                // Parse to extract type and message
                let rangeOfColon = value.rangeOfString(":")
                if rangeOfColon != nil {
                    // First separate the role and actual event description into two values.
                    let type = value.substringToIndex((rangeOfColon?.startIndex)!)
                    notificationTypesCopy.append(type)
                    let message = value.substringFromIndex((rangeOfColon?.startIndex.advancedBy(2))!)
                    notificationMessagesCopy.append(message)
                }
            }
            
            
        }
        return (notificationKeysCopy, notificationTypesCopy, notificationMessagesCopy)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 68.0
        print("--------------")
        print(notifications)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    /* override func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        // Programatically set the height of the cell
    } */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("standardCell", forIndexPath: indexPath)
        
        let current_notification:(String,String,String) = (notificationCopy.0[indexPath.row],notificationCopy.1[indexPath.row],notificationCopy.2[indexPath.row])
        
        let date = current_notification.0
        let type = current_notification.1
        let message = current_notification.2
        
        if standardNotifications.contains(type) {
            let standardCell = tableView.dequeueReusableCellWithIdentifier("standardCell", forIndexPath: indexPath) as! StandardNotificationTableViewCell
            standardCell.dateLabel.text = self.parseDate(date)
            standardCell.messageLabel.text = message
            return standardCell
        } else if type == "singleRequest" {
            let requestCell = tableView.dequeueReusableCellWithIdentifier("requestCell", forIndexPath: indexPath) as! RequestNotificationTableViewCell
            let requester = (message.characters.split{$0 == " "}.map(String.init))[0]
            getUserPhoto(requester, imageView: requestCell.userPic)
            requestCell.dateLabel.text = self.parseDate(date)
            let messageArr = message.characters.split{$0 == "\n"}.map(String.init)
            if messageArr.count == 3 {
                requestCell.messageLabel.text = messageArr[0]
                requestCell.descriptionLabel.text = messageArr[1]
                requestCell.locationLabel.text = messageArr[2]
            } else {
                requestCell.messageLabel.text = message
            }
            return requestCell
        } else if type == "balanceUpdate" {
            let balanceUpdateCell = tableView.dequeueReusableCellWithIdentifier("balanceUpdateCell", forIndexPath: indexPath) as! BalanceUpdateTableViewCell
            balanceUpdateCell.dateLabel.text = self.parseDate(date)
            balanceUpdateCell.messageLabel.text = message
            let numDots = self.getNumDots(message)
            if numDots > 0 {
                balanceUpdateCell.dotsLabel.text = "+" + String(numDots)
                balanceUpdateCell.dotsImage.image = UIImage(named: "GainedDotsBg.png")
            } else {
                balanceUpdateCell.dotsLabel.text = String(numDots)
                balanceUpdateCell.dotsImage.image = UIImage(named: "SpentDotsBg.png")
            }
            return balanceUpdateCell
        }
        
        return cell
    }
    
    func parseDate (date:String) -> String {
        let dateArr = date.characters.split{$0 == ","}.map(String.init)
        return ("\(dateArr[0]), \(dateArr[1])")
    }
    
    func getNumDots (message:String) -> Int {
        let messageArr = message.characters.split{$0 == " "}.map(String.init)
        var result = 0
        
        for item in messageArr {
            let components = item.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            let part = components.joinWithSeparator("")
            
            if let intVal = Int(part) {
                result = message.containsString("paid") ? intVal * -1 : intVal
                break
            }
        }
        return result
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
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
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
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
extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}
