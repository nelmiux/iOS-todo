//
//  BalanceUpdateTableViewCell.swift
//  todo
//
//  Created by Quyen Castellanos on 4/27/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class BalanceUpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var dotsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
