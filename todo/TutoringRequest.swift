//
//  TutoringRequest.swift
//  todo
//
//  Created by Quyen Castellanos on 3/2/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class TutoringRequest {
    // Class attributes
    private var sender:String = ""
    private var courseName:String = ""
    private var location:String = ""
    private var description:String = ""
    
    init (sender:String, courseName:String, location:String, description:String) {
        self.sender = sender
        self.courseName = courseName
        self.location = location
        self.description = description
    }
    
    func getSender () -> String {
        return self.sender
    }
    
    func setSender (sender:String) {
        self.sender = sender
    }
    
    func getCourseName () -> String {
        return self.courseName
    }
    
    func setCourseName (courseName:String) {
        self.courseName = courseName
    }
    
    func getLocation () -> String {
        return self.location
    }
    
    func setLocation (location:String) {
        self.location = location
    }
    
    func getDescription () -> String {
        return self.description
    }
    
    func setDescription (description:String) {
        self.description = description
    }
}