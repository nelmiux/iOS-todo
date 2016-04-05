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
    private var refFrame:CGRect = CGRect()
    private var courseLabel: UILabel = UILabel()
    private var removeButton:UIButton = UIButton()
    private var isFirst:Bool = false
    private var course:String = ""
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    convenience init (frame:CGRect, course:String, parentViewController:RegistrationViewController, isFirst:Bool) {
        self.init(frame: frame)
        self.parentViewController = parentViewController
        self.frame = getFrame(frame)
        self.isFirst = isFirst
        self.refFrame = frame
        
        // Parse the course string and get only the course number
        self.course = course
        let courseArr = course.characters.split{$0 == " "}.map(String.init)
        let courseNumber = courseArr[0].substringToIndex(courseArr[0].endIndex.predecessor())
        
        // Create the course label
        self.courseLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        self.courseLabel.layer.masksToBounds = true
        self.courseLabel.layer.cornerRadius = 5.0
        self.courseLabel.backgroundColor = self.getColor()
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
        if refFrame.origin.x == 0 && refFrame.origin.y == 0 {
            return refFrame
        }
        
        var frame = CGRect()
        let parentFrame = self.parentViewController?.courseButtonsView.bounds
        let topRightPoint_nextToCase:CGPoint = CGPoint(x: refFrame.origin.x + refFrame.size.width + 10 + 100, y: refFrame.origin.y)
        let bottomLeftPoint_belowCase:CGPoint = CGPoint(x: 100, y: refFrame.origin.y + refFrame.height + 10 + 30)
        
        // Place view NEXT TO refFrame
        if  parentFrame!.contains(topRightPoint_nextToCase) {
           frame = CGRect(x: refFrame.origin.x + refFrame.size.width + 10, y: refFrame.origin.y, width: 100, height: 30)
        }
        // Place view BELOW refFrame, on next line and determine if parent view controller needs to be expanded
        else {
            if !parentFrame!.contains(bottomLeftPoint_belowCase) {
                self.parentViewController?.courseButtonsView.frame.size.height += 50
            }
            frame = CGRect(x: 0, y: refFrame.origin.y + refFrame.height + 10, width: 100, height: 30)
        }
        return frame
    }
    
    func getColor () -> UIColor {
        let idx = arc4random_uniform(UInt32(burntOranges.count))
        return burntOranges[Int(idx)]
    }
    
    func show () {
        self.parentViewController?.courseButtonsView.addSubview(self)
        self.bringSubviewToFront((self.parentViewController?.courseButtonsView)!)
        
        if self.isFirst {
            self.parentViewController?.updateRefFrame(CGRect(x: self.frame.origin.x + self.frame.size.width + 10, y: self.frame.origin.y, width: 100, height: 30))
        } else {
            self.parentViewController?.updateRefFrame(self.frame)
        }
    }
}
