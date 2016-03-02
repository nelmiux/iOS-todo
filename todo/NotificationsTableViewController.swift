//
//  NotificationsTableViewController.swift
//  todo
//
//  Created by mac on 3/1/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {
    
    private var notifications:[Notification] = [Notification]()
    private var isDataLoaded:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!isDataLoaded) {
            self.loadData()
        }
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
        notifications.append(Notification(message: "There are 5 new tutoring opportunities that match your qualifications.", date: "1/15/16", type: "tutor poll"))
        isDataLoaded = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        let currNotification = notifications[indexPath.row]
        if (currNotification.getType() == "single request"){
            return 80
        } else {
            return 65
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currNotification:Notification = notifications[indexPath.row]
        let notificationType = currNotification.getType()
        
        if (notificationType == "single request") {
            let cell = tableView.dequeueReusableCellWithIdentifier("requestNotification", forIndexPath: indexPath) as! RequestNotificationTableViewCell
            cell.messageLabel.text = currNotification.getMessage()
            cell.dateLabel.text = currNotification.getDate()
            return cell
        } else if (notificationType == "tutor poll") {
            let cell = tableView.dequeueReusableCellWithIdentifier("pollingNotification", forIndexPath: indexPath) as! StandardNotificationTableViewCell
            cell.messageLabel.text = currNotification.getMessage()
            cell.dateLabel.text = currNotification.getDate()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("standardNotification", forIndexPath: indexPath) as! StandardNotificationTableViewCell
            cell.messageLabel.text = currNotification.getMessage()
            cell.dateLabel.text = currNotification.getDate()
            return cell
        }
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
