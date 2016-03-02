//
//  NotificationsTableViewController.swift
//  todo
//
//  Created by mac on 3/1/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {
    
    var notifications:[Notification] = [Notification]()
    
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
        
        notifications.append(Notification(message: "Lucy Adams has requested you to tutor her in CS 378.", date: "2/29/16", type: "single request"))
        notifications.append(Notification(message: "Congrats! You earned 50 dots for tutoring John Smith.", date: "2/13/16"))
        notifications.append(Notification(message: "You've spent 50 dots on tutoring from Bob Wilson.", date: "2/2/16"))
        notifications.append(Notification(message: "There are 5 new tutoring opportunities that match your qualifications.", date: "1/15/16", type: "request list"))
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! NotificationTableViewCell
        let currNotification:Notification = notifications[indexPath.row]
        let notificationType = currNotification.getType()
        var cell = tableView.dequeueReusableCellWithIdentifier("standardNotification", forIndexPath: indexPath) as! RequestNotificationTableViewCell
        
        if (notificationType == "single request") {
            cell = tableView.dequeueReusableCellWithIdentifier("standardNotification", forIndexPath: indexPath) as! RequestNotificationTableViewCell
            cell.messageLabel.text = currNotification.getMessage()
            cell.dateLabel.text = currNotification.getDate()
            return cell
        } else if (notificationType == "request list") {
            cell = tableView.dequeueReusableCellWithIdentifier("standardNotification", forIndexPath: indexPath) as! RequestNotificationTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! RequestNotificationTableViewCell
        }
        return cell
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
