//
//  SaveData.swift
//  todo
//
//  Created by Nelma Perera on 3/9/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase

//private var appSettings = AppSettings()

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

func saveUserData (value: String) {
    // Create a reference to a Firebase location
    let myRootRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/users")
    // Write data to Firebase
    myRootRef.setValue(value)
}

func saveCoursesData (value: String) {
    // Create a reference to a Firebase location
    let myRootRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/courses")
    // Write data to Firebase
    myRootRef.setValue(value)
}
