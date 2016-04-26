//
//  NotificationsTableViewController.swift
//  todo
//
//  Created by mac on 3/1/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {

    private var isDataLoaded:Bool = false
    
    var notificationCopy:([String],[String],[String]){
        var notificationKeysCopy = [String]()
        var notificationTypesCopy = [String]()
        var notificationValuesCopy = [String]()
        var message = ""
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        dispatch_sync(concurrentDataAccessQueue) {
            for key in notifications.keys{
                notificationKeysCopy.append(key)
            }
            for value in notifications.values{
                if (value.lowercaseString.rangeOfString("request") != nil){
                    notificationTypesCopy.append("request")
                }else if (value.lowercaseString.rangeOfString("balance") != nil){
                    notificationTypesCopy.append("balance")
                }else if (value.lowercaseString.rangeOfString("session") != nil){
                    notificationTypesCopy.append("session")
                }else{
                    notificationTypesCopy.append("general")
                }
                
                var valueArr = value.componentsSeparatedByString(":")
                
                if valueArr.count > 1 {
                    if  valueArr.count > 2 {
                        let joinWord = valueArr[2]
                        message = valueArr[1] + joinWord
                    } else {
                        message = valueArr[1]
                    }
                } else {
                    
                    message = value.insert(" ", ind: 0)
                }
                notificationValuesCopy.append(message)
            }
            
            
        }
        return (notificationKeysCopy,notificationValuesCopy,notificationTypesCopy)
    }
    
//    var notificationsKeys: [String]{
//        var notificationsKeysCopy = [String]()
//        
//        dispatch_sync(concurrentDataAccessQueue) {
//            for key in notifications.keys {
//                notificationsKeysCopy.append(key)
//            }
//        }
//        return notificationsKeysCopy
//    }
//    
//    var notificationsValues: [String]{
//        var notificationsValuesCopy = [String]()
//        
//        dispatch_sync(concurrentDataAccessQueue) {
//            for value in notifications.values{
//                notificationsValuesCopy.append(value)
//            }
//        }
//        return notificationsValuesCopy
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 68.0
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
        /*  For now, just  throw everything out there, as a standard notification  */
        let current_notification:(String,String,String) = (notificationCopy.0[indexPath.row],notificationCopy.1[indexPath.row],notificationCopy.2[indexPath.row])
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellId", forIndexPath: indexPath) as! StandardNotificationTableViewCell
        
        let dateArr = (current_notification.0).characters.split{$0 == ","}.map(String.init)
        cell.dateLabel.text = (" \(dateArr[0]), \(dateArr[1])")
        cell.messageLabel.text = current_notification.1
        
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
extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}
