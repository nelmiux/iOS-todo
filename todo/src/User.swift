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
    private var username: String = ""
    private var password: String = ""
    private var email:String = ""
    private var major:String = ""
    private var graduationYear:String = ""
    private var photoString:String = ""
    private var courses:[String] = [String]()
    private var role:String = ""
    private var dots:Int = -1
    private var earned:Int = -1
    private var payed:Int = -1
    private var lastLogin:String = ""
    private var tutoringStatus:Bool = false
    
    
    init () {
        
    }
    
    // Constructor
    init (firstName:String, lastName:String, username: String, password:String, email: String, major: String, graduationYear: String, photoString: String, courses: [String], dots: Int, earned: Int, payed: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.password = password
        self.email = email
        self.major = major
        self.graduationYear = graduationYear
        self.photoString = firstName
        self.courses = courses
        self.dots = dots
        self.earned = earned
        self.payed = payed

    }
    
    // Getters and setters for each attribute
    func getFirstName () -> String {
        return self.firstName
    }
    
    func setFirstName (firstName:String) {
        self.firstName = firstName
    }
    
    func getLastName () -> String {
        return self.lastName
    };
    
    func setLastName (lastName:String) {
        self.lastName = lastName
    }
    
    func getUsername () -> String {
        return self.username
    }
    
    func setUsername (username:String) {
        self.username = username
    }
    
    func getPassword () -> String {
        return self.password
    }
    
    func setPassword (password:String) {
        self.password = password
    }
    
    func getEmail () -> String {
        return self.email
    }
    
    func setEmail (email:String) {
        self.email = email
    }
    
    func getMajor () -> String {
        return self.major
    }
    
    func setMajor  (major:String) {
        self.major = major
    }
    
    func getGraduationYear () -> String {
        return self.graduationYear
    }
    
    func setGraduationYear (graduationYear:String) {
        self.graduationYear = graduationYear
    }
    
    func getPhoto () -> String {
        return self.photoString
    }
    
    func setPhoto (photoString:String) {
        self.photoString = photoString
    }
    
    func getCourses () -> [String] {
        return self.courses
    }
    
    func addCourses(courses:String) {
        self.courses.append(courses)
    }
    
    func getRole () -> String {
        return self.role
    }
    
    func setRole (role:String) {
        self.role = role
    }
    
    func getDots () -> Int {
        return self.dots
    }
    
    func addDots (newDots:Int) {
        self.dots += newDots
    }
    
    func substractDots (newDots:Int) {
        self.dots -= newDots
    }
    
    func getLastLogin () -> String {
        return self.lastLogin
    }
    
    func setLastLogin (lastLogin:String) {
        self.lastLogin = lastLogin
    }
    
    func getTutoringStatus () -> Bool {
        return self.tutoringStatus
    }
    
    func setTutoringStatus (tutoringStatus:Bool) {
        self.tutoringStatus = tutoringStatus
    }
    
}