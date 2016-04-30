//
//  SettingTableViewController.swift
//  todo
//
//  Created by Kiu Lam on 4/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var lbl_email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_email.text = user["email"] as? String

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if let cell = cell?.reuseIdentifier{
            switch cell{
                
            case "password":
                print("in password cell")
                promptChangeInfo("password")
                break;
                
            case "email":
                print("in email cell")
                promptChangeInfo("email")
                break;
                
            case "reset_Notification":
                print("In reset notification")
                promptClearInfo("notification")
                break;
                
            case "reset_History":
                print("In reset history")
                promptClearInfo("history")
                break;
                
            default:
                print("neither")
                break;
            }
        }else{
            print("s\"nil\"l")
        }
        
        
    }
    
    private func promptClearInfo(info:String){
        let warningMessage:String = "Once you clicked OK, your \(info) information will be remove permanently"
        let alert = UIAlertController(title: "WARNING", message:warningMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            switch info{
            case "history":
                clearHistory()
                self.displayMessage(info)
                
                break;
            case "notification":
                clearNotification()
                self.displayMessage(info)
                break;
            default:
                print("neither")
            }
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: {
        })
        
    }

    private func promptChangeInfo(info:String){
        var old: UITextField!
        var new: UITextField!
        
        var passwordEmail: UITextField!
        
        func oldTextField(textField: UITextField!)
        {
            textField.placeholder = "old"
            textField.secureTextEntry = true

            old = textField
        }
        func newTextField(textField: UITextField!)
        {
            textField.placeholder = "new"
            textField.secureTextEntry = true

            new = textField
        }
        func passwordEmailTextField(textField: UITextField!)
        {
            textField.placeholder = "password"
            textField.secureTextEntry = true

            passwordEmail = textField
        }
        
        let alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(oldTextField)
        alert.addTextFieldWithConfigurationHandler(newTextField)
        if(info == "email"){
            alert.addTextFieldWithConfigurationHandler(passwordEmailTextField)
        }
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            switch info{
            case "password":
                modifyPassword(self, oldPassword: old.text!,  newPassword: new.text!, userEmail: (user["email"] as? String)!)
                self.displayMessage("Password")
                break;
            case "email":
                modifyEmail(self, originalEmail: old.text!, modifiedEmail: new.text!, password: passwordEmail.text!)
                self.lbl_email.text = new.text!
                self.displayMessage("Email")
                break;
            default:
                print("neither")
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    
    private func displayMessage(info:String){
        let alert = UIAlertController(title: info, message: "Success", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
