//
//  CourseButtonView.swift
//  todo
//
//  Created by Quyen Castellanos on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class CourseButtonView: UIView {
    
    private var parentViewController:RegistrationViewController? = nil
    private var courseLabel: UILabel = UILabel()
    private var removeButton:UIButton = UIButton()
    private var course:String = ""
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    convenience init (frame:CGRect, course:String, parentViewController:RegistrationViewController) {
        self.init(frame: frame)
        self.frame = getFrame(frame)
        self.parentViewController = parentViewController
        
        // Parse the course string and get only the course number
        self.course = course
        let courseArr = course.characters.split{$0 == " "}.map(String.init)
        let courseNumber = courseArr[0].substringToIndex(courseArr[0].endIndex.predecessor())
        
        // Create the course label
        self.courseLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        self.courseLabel.layer.masksToBounds = true
        self.courseLabel.layer.cornerRadius = 5.0
        self.courseLabel.backgroundColor = UIColor.redColor()
        self.courseLabel.textColor = UIColor.whiteColor()
        self.courseLabel.text = " " + courseNumber
        
        // Create the remove button and attach to the course label
        self.removeButton = UIButton(frame: CGRect(x: self.courseLabel.frame.origin.x + self.courseLabel.frame.width - 25, y: self.courseLabel.frame.origin.y + 3, width: 25, height: 25))
        self.removeButton.setTitle("X", forState: UIControlState.Normal)
        self.courseLabel.addSubview(self.removeButton)
        
        // Finally, add the label to the view controller
        self.addSubview(self.courseLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getFrame (refFrame:CGRect) -> CGRect {
        var frame = CGRect()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let topRightPoint_nextToCase:CGPoint = CGPoint(x: refFrame.origin.x + refFrame.size.width + 10 + 100, y: refFrame.origin.y)
        let bottomLeftPoint_belowCase:CGPoint = CGPoint(x: 16 + 100, y: refFrame.origin.y + refFrame.height + 10 + 30)
        
        // Place view NEXT TO refFrame
        if  screenSize.contains(topRightPoint_nextToCase) {
           frame = CGRect(x: refFrame.origin.x + refFrame.size.width + 10, y: refFrame.origin.y, width: 100, height: 30)
        }
        // Place view BELOW refFrame, on next line and determine if parent view controller needs to be expanded
        else {
            if !screenSize.contains(bottomLeftPoint_belowCase) {
                self.parentViewController?.mainView.frame.size.height += 50
            }
            frame = CGRect(x: 16, y: refFrame.origin.y + refFrame.height + 10, width: 100, height: 30)
        }
        return frame
    }
    
    func show () {
        self.parentViewController?.mainView.addSubview(self)
        self.parentViewController?.updateRefFrame(self.frame)
    }
}
