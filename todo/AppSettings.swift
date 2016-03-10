//
//  AppSettings.swift
//  todo
//
//  Created by Quyen Castellanos on 3/7/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase

class AppSettings {
 
    // Firebase Refs
    let firebaseURL:String = "https://scorching-heat-4336.firebaseio.com"
    let rootRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com")
    let usersRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/users")
    let appSettingsRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/applicationSettings")
    
    let registrationFields:[(String, String)] = [("First Name", "John"), ("Last Name", "Appleseed"), ("UT EID", "abc123"), ("Email Address", "jappleseed@gmail.com"), ("Password", "password"), ("Major", "Computer Science") , ("Graduation Year", "2016")]
    // TODO: We will want this in the database
    let lowerDivisionCourses:[String] = ["CS 312: Introduction to Programming", "CS 314: Data Structures", "CS 314H: Data Structures Honors", "CS 302: Computer Fluency", "CS 105: Computer Programming", "CS 311: Discrete Math for Computer Science", "CS 311H: Discrete Math for Computer Science: Honors", "CS 109: Topics in Computer Science", "CS 313E: Elements of Software Design"]
    let upperDivisionCourses:[String] = [String]()
}