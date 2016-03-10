//
//  LoginViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // UI Elements
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    
    // Class variables
    let appSettings = AppSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayErrorAlertView (message:String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        var shouldPerform:Bool = true
        if identifier == "enterApplication" {
            let emailInput = emailInputField.text
            let passwordInput = passwordInputField.text
            
            // Check that input is included in both fields
            if emailInput!.characters.count < 1 || passwordInput!.characters.count < 1{
                self.displayErrorAlertView("Please enter an email address and password.")
                shouldPerform = false
            } else {
                self.appSettings.rootRef.authUser(emailInput, password: passwordInput) {
                    error, authData in
                    if error != nil {
                        self.displayErrorAlertView("Unable to login. Invalid email and/or password.")
                        shouldPerform = false
                    } else {
                        shouldPerform = true
                    }
                }
            }
        }
        return shouldPerform
    }

}
