//
//  SaveData.swift
//  todo
//
//  Created by Nelma Perera on 3/9/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase

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
