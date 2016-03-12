//
//  ValidData.swift
//  todo
//
//  Created by Nelma Perera on 3/12/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase

func validData (val: String) -> String {
    var retData = ""
    // Create a reference to a Firebase location
    let myRootRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/users/" + val)
    
    myRootRef.observeEventType(.Value, withBlock: { snap in
        
        if !(snap.value is NSNull) {
            retData = snap.value as! String
        }
    })
    
    return retData
}
