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
    
    // Class variables
    private var user:String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUser (user:String?) {
        self.user = user
    }
}
