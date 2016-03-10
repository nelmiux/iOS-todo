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
 
    let firebaseURL:String = "https://scorching-heat-4336.firebaseio.com"
    let registrationFields:[(String, String)] = [("First Name", "John"), ("Last Name", "Appleseed"), ("UT EID", "abc123"), ("Email Address", "jappleseed@gmail.com"), ("Password", "password"), ("Major", "Computer Science") , ("Graduation Year", "2016")]
    // TODO: We will want this in the database
    let lowerDivisionCourses:[String] = ["312 Introduction to Programming", "314 Data Structures", "314H Data Structures Honors", "302 Computer Fluency", "105 Computer Programming", "311 Discrete Math for Computer Science", "311H Discrete Math for Computer Science: Honors", "109 Topics in Computer Science", "313E Elements of Software Design"]
    let usersRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/users")
}