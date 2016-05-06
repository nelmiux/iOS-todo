//
//  HomeViewController.swift
//  todo
//
//  Created by Nelma Perera on 3/11/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    var logInViewControler = LoginViewController()
    
    let requestButtonColor = UIColor(red: 235.0/255.0, green: 84.0/255.0, blue: 55.0/255.0, alpha: 0.8)
    
    @IBOutlet weak var tutorStudentSwitch: UISegmentedControl!
    
    @IBOutlet weak var tutorStudentSwiftLabel: UILabel!
    
    @IBOutlet weak var requestTutoringButton: UIButton!
    
    @IBOutlet weak var lookingTutorsNoticeView: UIView!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var logout: UIBarButtonItem!
    
    @IBOutlet weak var requesterContainerView: UIView!
    
    @IBOutlet weak var requesterSessionContainerView: UIView!
    
    @IBOutlet weak var tutorContainerView: UIView!
    
    @IBOutlet weak var tutorSessionContainerView: UIView!
    
    @IBOutlet weak var noButton: UIButton!
    
    var tutorWaitingViewController: TutorWaitingViewController? = nil
    
    var tutorSessionViewController: TutorTutoringSessionViewController? = nil
    
    var requesterStartSessionViewController: RequesterStartSessionViewController? = nil
    
    var requesterTutoringSessionViewController: RequesterTutoringSessionViewController? = nil
    
    var chartViewController: ChartViewController? = nil
    
    var presented: Bool = false
    
    override func viewDidLoad() {
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
        super.viewDidLoad()
        requestTutoringButton!.backgroundColor = requestButtonColor
        startHomeViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        noButton.hidden = true
        if settingsSwitch != -1 && settingsSwitch != self.tutorStudentSwitch.selectedSegmentIndex {
            self.tutorStudentSwitch.selectedSegmentIndex = settingsSwitch
            self.tutorStudentSwitch.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
        settingsSwitch = self.tutorStudentSwitch.selectedSegmentIndex
    }
    
    @IBAction func requestTutoringButton(sender: AnyObject) {
        dotsTotal = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tutorStudentSwitch(sender: AnyObject) {
        self.getTutorStudentSwitchAction()
        presented = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout" {
            logOutUser()
        }
        if let vc = segue.destinationViewController as? TutorWaitingViewController
            where segue.identifier == "tutorWaitingSegue" {
            self.tutorWaitingViewController = vc
        }
        if let vc = segue.destinationViewController as? TutorTutoringSessionViewController
            where segue.identifier == "tutorSessionSegue" {
            self.tutorSessionViewController = vc
        }
        if let vc = segue.destinationViewController as? RequesterStartSessionViewController
            where segue.identifier == "requesterSegue" {
            self.requesterStartSessionViewController = vc
            vc.mainViewController = self
        }
        if let vc = segue.destinationViewController as? RequesterTutoringSessionViewController
            where segue.identifier == "requesterSessionSegue" {
            self.requesterTutoringSessionViewController = vc
        }
        if let vc = segue.destinationViewController as? ChartViewController
            where segue.identifier == "chartSegue" {
            self.chartViewController = vc
        }
    }
    
    @IBAction func returnHomeViewControllerFromNot(segue:UIStoryboardSegue) {}
    
    @IBAction func returnHomeViewController(segue:UIStoryboardSegue) {
        let askedCourse = (segue.sourceViewController as! RequestHelpViewController).editedDropDown.text!
        self.lookingTutorsNoticeView.hidden = false
        self.blurEffect.hidden = false
        self.logout.enabled = false
        pairedListener(self, askedCourse: askedCourse)
    }
    
    @IBAction func startHomeViewControllerCancel(segue:UIStoryboardSegue) {
        cancelSession()
        startHomeViewController()
    }
    
    @IBAction func startHomeViewControllerFinish(segue:UIStoryboardSegue) {
        var dots = (user["dots"]! as! Int)
        dots = dots + dotsTotal
        user["dots"] = dots
        user["earned"] = (user["earned"] as! Int) + dotsTotal
        
        let dotsCategory = ["Earned", "Paid"]
        let dotsAmount = [(user["earned"] as? Int)!, (user["paid"] as? Int)!]
        chartViewController?.earnedAmount.text = String(user["earned"] as! Int)
        chartViewController?.setChart(dotsCategory, values: dotsAmount)
        finishSession(self)
        startHomeViewController()
        return
    }
    
    @IBAction func startHomeViewControllerFinishRequester(segue:UIStoryboardSegue) {
        startHomeViewController()
        return
    }
    
    func getTutorStudentSwitchAction() {
        settingsSwitch = self.tutorStudentSwitch.selectedSegmentIndex
        if tutorStudentSwitch.selectedSegmentIndex == 0 {
            requestTutoringButton!.enabled = false
            requestTutoringButton!.userInteractionEnabled = false
            requestTutoringButton!.backgroundColor = UIColor.lightGrayColor()
            requestListener(self)
            return
        }
        requestTutoringButton!.backgroundColor = requestButtonColor
        requestTutoringButton!.enabled = true
        requestTutoringButton!.userInteractionEnabled = true
        removeObservers(cUserRef!)
    }
    
    func startHomeViewController() {
        self.tutorStudentSwitch.hidden = false
        self.tutorStudentSwiftLabel.hidden = false
        self.logout.enabled = true
        self.requestTutoringButton!.hidden = false
        self.blurEffect.hidden = true
        self.requesterContainerView.hidden = true
        self.requesterSessionContainerView.hidden = true
        self.tutorContainerView.hidden = true
        self.tutorSessionContainerView.hidden = true
        return
    }
    
}

