//
//  Notification.swift
//  todo
//
//  Created by mac on 3/1/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class Notification {
    
    // Class attributes
    private var message:String = ""
    private var date:String = ""
    private var type:String = ""
    
    init (message:String, date:String, type:String = "normal") {
        self.message = message
        self.date = date
        self.type = type
    }
    
    func getMessage () -> String {
        return self.message
    }
    
    func setMessage (message:String) {
        self.message = message
    }
    
    func getDate () -> String {
        return self.date
    }
    
    func setDate (date:String) {
        self.date = date
    }
    
    func getType () -> String {
        return self.type
    }
    
    func setType (type:String) {
        self.type = type
    }
}

