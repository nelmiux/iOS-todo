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
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "enterApplication" {
            // Check that input is included in both fields
            if emailInputField.text?.characters.count < 1 {
                var errorMsg = "Please enter an email address"
                errorMsg += passwordInputField.text?.characters.count < 1 ? " and password." : "."
                self.displayErrorAlertView(errorMsg)
                return false
            }
            
            self.appSettings.rootRef.authUser("jenny@example.com", password: "correcthorsebatterystaple") {
                error, authData in
                if error != nil {
                    // an error occured while attempting login
                } else {
                    // user is logged in, check authData for data
                }
            }
        }
        return true
    }

}
