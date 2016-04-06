//
//  UserPhotoButton.swift
//  todo
//
//  Created by Quyen Castellanos on 4/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class UserPhotoButton: UIButton {

    private var user:String = ""
    
    func getUser() -> String {
        return self.user
    }
    
    func setUser(user:String) {
        self.user = user
    }

}
