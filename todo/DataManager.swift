//
//  AppSettings.swift
//  todo
//
//  Created by Quyen Castellanos on 3/7/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase
 
// Firebase Refs
let firebaseURL:String = "https://scorching-heat-4336.firebaseio.com"
let rootRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com")
let usersRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/users")
let appSettingsRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/applicationSettings")
    
let registrationFields:[(String, String)] = [("First Name", "John"), ("Last Name", "Appleseed"),  ("Email Address", "jappleseed@gmail.com"), ("Username", "abc123"), ("Password", "password"), ("Major", "Computer Science") , ("Graduation Year", "2016")]
// TODO: We will want this in the database
let lowerDivisionCourses:[String] = ["CS 312: Introduction to Programming", "CS 314: Data Structures", "CS 314H: Data Structures Honors", "CS 302: Computer Fluency", "CS 105: Computer Programming", "CS 311: Discrete Math for Computer Science", "CS 311H: Discrete Math for Computer Science: Honors", "CS 109: Topics in Computer Science", "CS 313E: Elements of Software Design"]
let upperDivisionCourses:[String] = [String]()


func createUser(view: AnyObject, inputs: [String: String]) {
    rootRef.createUser(inputs["Email Address"], password: inputs["Password"], withValueCompletionBlock: {
        error, result in
        if error == nil {
            // Insert the user data
            let newUserRef = usersRef.childByAppendingPath(inputs["Username"])
            newUserRef.setValue(inputs)
            print("Successfully created user account with username: \(inputs["Username"]!)")
            alert(view, description: "Congrats! You are ready to start using todo.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                result in
                view.performSegueWithIdentifier("registerUser", sender: nil)
                }
            )
            return
        }
        alert(view, description: "An error has occurred. There may be an existing account for the provided email address.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
    )
}

func alert (view: AnyObject, description: String, action: UIAlertAction) {
    let alertController = UIAlertController(title: nil, message: description, preferredStyle: UIAlertControllerStyle.Alert)
    let OKAction = action
    alertController.addAction(OKAction)
    view.presentViewController(alertController, animated: true, completion:nil)
}
