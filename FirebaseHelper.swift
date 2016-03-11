//
//  FirebaseHelper.swift
//  todo
//
//  Created by Quyen Castellanos on 3/11/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper {
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
    
    func readUserData (val: String) -> String {
        var retData = ""
        print("1. retData: \(retData)")
        // Create a reference to a Firebase location
        let myRootRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/users/" + val)
        
        myRootRef.observeEventType(.Value, withBlock: { snap in
            
            if !(snap.value is NSNull) {
                // retData = snap.value as! String
                retData += snap.value
                print("2. retData: \(retData)")
            }
        })
        
        print("3. retData: \(retData)")
        return retData
    }
        
}
