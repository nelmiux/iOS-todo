//
//  User.swift
//  todo
//
//  Created by Quyen Castellanos on 3/4/16.
//  Copyright © 2016 Quyen Castellanos. All rights reserved.
//

import Foundation

class User {
    
    // Class attributes
    private var firstName:String = ""
    private var lastName:String = ""
    private var userId: String = ""
    private var email:String = ""
    private var password:String = ""        // This may be unnecessary to hold onto
    private var major:String = ""
    private var graduationYear:Int = -1
    private var photoURL:String = ""        // This may change to a file data type
    private var qualifiedCourses:[String] = [String]()
    private var role:String = ""
    private var numDots:Int = -1
    private var lastLogin:String = ""
    private var tutoringStatus:Bool = false
    
    // Constructor
    init (firstName:String, lastName:String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    // Getters and setters for each attribute
    func getFirstName () -> String {
        return self.firstName
    }; func setFirstName (firstName:String) {
        self.firstName = firstName
    }
    
    func getLastName () -> String {
        return self.lastName
    }; func setLastName (lastName:String) {
        self.lastName = lastName
    }
    
    func getUserId () -> String {
        return self.userId
    }; func setUserId (userId:String) {
        self.userId = userId
    }
    
    func getEmail () -> String {
        return self.email
    }; func setEmail (email:String) {
        self.email = email
    }
    
    func getPassword () -> String {
        return self.password
    }; func setPassword (password:String) {
        self.password = password
    }
    
    func getMajor () -> String {
        return self.major
    }; func setMajor  (major:String) {
        self.major = major
    }
    
    func getGraduationYear () -> Int {
        return self.graduationYear
    }; func setGraduationYear (graduationYear:Int) {
        self.graduationYear = graduationYear
    }
    
    func getPhoto () -> String {
        return self.photoURL
    }; func setPhoto (photoURL:String) {
        self.photoURL = photoURL
    }
    
    func getQualifiedCourses () -> [String] {
        return self.qualifiedCourses
    }; func addQualifiedCourse (course:String) {
        self.qualifiedCourses.append(course)
    }
    
    func getRole () -> String {
        return self.role
    }; func setRole (role:String) {
        self.role = role
    }
    
    func getNumDots () -> Int {
        return self.numDots
    }; func addDots (newDots:Int) {
        self.numDots += newDots
    }
    
    func getLastLogin () -> String {
        return self.lastLogin
    }; func setLastLogin (lastLogin:String) {
        self.lastLogin = lastLogin
    }
    
    func getTutoringStatus () -> Bool {
        return self.tutoringStatus
    }; func setTutoringStatus (tutoringStatus:Bool) {
        self.tutoringStatus = tutoringStatus
    }
    
}