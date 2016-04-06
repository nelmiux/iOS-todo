//
//  HistoryTableViewCell.swift
//  todo
//
//  Created by Quyen Castellanos on 3/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    // UI Components
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var dotsLabel: UILabel!
    @IBOutlet weak var dotsBg: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userPhotoButton: UserPhotoButton!
    
    // Class variables
    private var user:String? = nil
    var parentViewController:UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getUser () -> String {
        if self.user != nil {
            return self.user!
        } else {
            return ""
        }
    }
    
    func setUser (user:String?) {
        self.user = user
        self.userPhotoButton.setUser(user!)
    }
    
    
}
