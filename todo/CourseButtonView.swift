//
//  CourseButtonView.swift
//  todo
//
//  Created by Quyen Castellanos on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class CourseButtonView: UIView {
    
    private var parentView:UIView? = nil
    private var courseLabel: UILabel = UILabel()
    private var removeButton:UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    convenience init (frame:CGRect, course:String, parentView:UIView) {
        self.init(frame: frame)
        self.parentView = parentView
        
        self.courseLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        self.courseLabel.backgroundColor = UIColor.redColor()
        self.courseLabel.text = course
        
        self.removeButton = UIButton(frame: CGRect(x: self.courseLabel.frame.origin.x + self.courseLabel.frame.width - 25, y: self.courseLabel.frame.origin.y, width: 25, height: 25))
        self.removeButton.setTitle("X", forState: UIControlState.Normal)
        
        self.addSubview(self.courseLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show () {
        self.parentView?.addSubview(self)
    }
}
