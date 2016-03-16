//
//  HomeViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/11/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let requestButtonColor = UIColor(red: 235.0/255.0, green: 84.0/255.0, blue: 55.0/255.0, alpha: 0.8)
    
    @IBOutlet weak var tutorStudentSwitch: UISegmentedControl!
    
    @IBOutlet weak var requestTutoringButton: UIButton!
    
    @IBOutlet weak var lookingTutorsNoticeView: UIView!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var logout: UIBarButtonItem!
    
    @IBOutlet weak var tutorWaiting: UIView!
    
    @IBOutlet weak var requesterPhoto: UIImageView!
    
    @IBOutlet weak var requesterUsername: UILabel!
    
    @IBOutlet weak var requesterCourse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestTutoringButton!.backgroundColor = requestButtonColor
        self.lookingTutorsNoticeView.hidden = true
        self.blurEffect.hidden = true
        self.tutorWaiting.hidden = true
    }
    
    @IBAction func requestTutoringButton(sender: AnyObject) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tutorStudentSwitch(sender: AnyObject) {
        if tutorStudentSwitch.selectedSegmentIndex == 0 {
            requestTutoringButton!.enabled = false
            requestTutoringButton!.userInteractionEnabled = false
            requestTutoringButton!.backgroundColor = UIColor.lightGrayColor()
            requestLisener(self)
            return
        }
        requestTutoringButton!.backgroundColor = requestButtonColor
        requestTutoringButton!.enabled = true
        requestTutoringButton!.userInteractionEnabled = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout" {
            logOutUser()
        }
    }
    
    @IBAction func returnHomeViewController(segue:UIStoryboardSegue) {
        let askedCourse = (segue.sourceViewController as! RequestHelpViewController).editedDropDown.text!
        self.lookingTutorsNoticeView.hidden = false
        self.blurEffect.hidden = false
        self.logout.enabled = false
        pairedLisener(self, askedCourse: askedCourse)
    }
}
