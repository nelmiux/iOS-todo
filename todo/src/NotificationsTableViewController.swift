//
//  NotificationsTableViewController.swift
//  todo
//
//  Created by mac on 3/1/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {
    
    private let standardNotifications:[String] = ["request", "acceptance", "cancelledSession", "created"]
    
    /* Prepare to follow the pattern of history
     Check out the loadData function, please let me know
     wheher this is the right way*/
    private var data:([String],[String],[String]) = ([],[],[])
    
    var lastRequestCell: RequestNotificationTableViewCell? = nil
    
    var notificationCopy:([String],[String],[String]){
        var notificationKeysCopy = [String]()
        var notificationTypesCopy = [String]()
        var notificationMessagesCopy = [String]()
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let sortedDict = notifications.sort { $0.0 > $1.0 }
        
        dispatch_sync(taskQueue) {
            for key in sortedDict{
                notificationKeysCopy.append(key.0)
            }
            
            for value in sortedDict{
                // Parse to extract type and message
                let rangeOfColon = value.1.rangeOfString(":")
                if rangeOfColon != nil {
                    // First separate the role and actual event description into two values.
                    let type = value.1.substringToIndex((rangeOfColon?.startIndex)!)
                    notificationTypesCopy.append(type)
                    let message = value.1.substringFromIndex((rangeOfColon?.startIndex.advancedBy(2))!)
                    notificationMessagesCopy.append(message)
                }
            }
            
        }
        
        return (notificationKeysCopy, notificationTypesCopy, notificationMessagesCopy)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 68.0
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        if (alertPicController != nil) {
            alertPicController = nil
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.loadData()
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData(){
        var notificationKeysCopy = [String]()
        var notificationTypesCopy = [String]()
        var notificationMessagesCopy = [String]()
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let sortedDict = notifications.sort { $0.0 > $1.0 }
        
        dispatch_sync(taskQueue) {
            for key in sortedDict{
                notificationKeysCopy.append(key.0)
            }
            
            for value in sortedDict{
                // Parse to extract type and message
                let rangeOfColon = value.1.rangeOfString(":")
                if rangeOfColon != nil {
                    // First separate the role and actual event description into two values.
                    let type = value.1.substringToIndex((rangeOfColon?.startIndex)!)
                    notificationTypesCopy.append(type)
                    let message = value.1.substringFromIndex((rangeOfColon?.startIndex.advancedBy(2))!)
                    notificationMessagesCopy.append(message)
                }
            }
        }
        self.data.0 = notificationKeysCopy
        self.data.1 = notificationTypesCopy
        self.data.2 = notificationMessagesCopy
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
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
            let requesterString = (message.characters.split{$0 == " "}.map(String.init))[0]
            getUserPhoto(requesterString, imageView: requestCell.userPic)
            requestCell.userPhotoButton.setUser(requesterString)
            requestCell.dateLabel.text = self.parseDate(date)
            let messageArr = message.characters.split{$0 == "\n"}.map(String.init)
            if messageArr.count == 3 {
                requestCell.messageLabel.text = messageArr[0]
                requestCell.descriptionLabel.text = messageArr[1]
                requestCell.locationLabel.text = messageArr[2]
            } else {
                requestCell.messageLabel.text = message
            }
            requestCell.acceptButton.enabled = false
            requestCell.acceptButton.hidden = true
            requestCell.rejectButton.enabled = false
            requestCell.rejectButton.hidden = true
            if notificationButtonsState == 1 && requestCell.messageLabel.text?.rangeOfString(requester["username"]!) != nil  {
                requestCell.acceptButton.enabled = true
                requestCell.acceptButton.hidden = false
                requestCell.rejectButton.enabled = true
                requestCell.rejectButton.hidden = false
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayUserProfile" {
            let destVC = segue.destinationViewController as! ProfileViewController
            let user = (sender as! UserPhotoButton).getUser()
            
            destVC.username = user
            destVC.isOwnProfile = false
        }
    }
    
    @IBAction func returnToNotificationsViewController(segue:UIStoryboardSegue) {
        if segue.identifier == "goToNotificationsSegue" {
            notificationButtonsState = 1
        }
    }
}

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}
