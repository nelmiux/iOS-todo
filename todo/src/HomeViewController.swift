//
//  HomeViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/11/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var timeCount = 0
    
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
    
    @IBOutlet weak var requesterStartSession: UIView!
    
    @IBOutlet weak var tutorPhoto: UIImageView!
    
    @IBOutlet weak var tutorUsername: UILabel!
    
    @IBOutlet weak var tutorCourse: UILabel!
    
    @IBOutlet weak var requesterTutoringSession: UIView!
    
    @IBOutlet weak var requesterTutoringSessionTutorPhoto: UIImageView!
    
    @IBOutlet weak var requesterTutoringSessionTutorUsername: UILabel!
    
    @IBOutlet weak var requesterTutotringSessionCourse: UILabel!
    
    @IBOutlet weak var requesterTutoringSessionTimeView: UIView!
    
    @IBOutlet weak var requesterTutoringSessionPayingView: UIView!
    
    @IBOutlet weak var requesterTutoringSessionCountingTime: UILabel!
    
    @IBOutlet weak var requesterTutoringSessionPaying: UILabel!
    
    @IBOutlet weak var tutorTutoringSession: UIView!
    
    @IBOutlet weak var tutorTutoringSessionPhoto: UIImageView!
    
    @IBOutlet weak var tutorTutoringSessionUsername: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionCourse: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionTimeView: UIView!
    
    @IBOutlet weak var tutorTutoringSessionEarningView: UIView!
    
    @IBOutlet weak var tutorTutoringSessionCountingTime: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionEarning: UILabel!
    
    @IBOutlet weak var finishSessionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tutorStudentSwitch.hidden = false
        self.logout.enabled = true
        self.requestTutoringButton!.backgroundColor = requestButtonColor
        self.lookingTutorsNoticeView.hidden = true
        self.blurEffect.hidden = true
        self.tutorWaiting.hidden = true
        self.requesterStartSession.hidden = true
        self.requesterTutoringSession.hidden = true
        self.tutorTutoringSession.hidden = true
    }
    
    @IBAction func requestTutoringButton(sender: AnyObject) {}
    
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
    
    func timeCounter() {
        ++timeCount
        let seconds = timeCount % 60
        let minutes = (timeCount / 60) % 60
        let hours = (timeCount / 3600)
        self.requesterTutoringSessionCountingTime.text = String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        self.tutorTutoringSessionCountingTime.text = String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    func dotsCounter() {
        let dotsCount = (timeCount + 59) / 60
        self.requesterTutoringSessionPaying.text = String(dotsCount)
        self.tutorTutoringSessionEarning.text = String(dotsCount)
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
    
    @IBAction func startSessionButton(sender: AnyObject) {
        startSession(self)
    }
    
    @IBAction func cancelSessionButton(sender: AnyObject) {
        cancelSession(self)
    }
    
    @IBAction func finishSessionButton(sender: AnyObject) {
        finishSession(self)
    }
}
