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
    
    @IBOutlet weak var requestTutoringButton: UIButton!
    
    @IBOutlet weak var lookingTutorsNoticeView: UIView!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var logout: UIBarButtonItem!
    
    @IBOutlet weak var requesterContainerView: UIView!
    
    @IBOutlet weak var tutorContainerView: UIView!
    
    @IBOutlet weak var tutorSessionContainerView: UIView!
    
    var tutorWaitingViewController: TutorWaitingViewController? = nil
    
    var tutorSessionViewController: TutorTutoringSessionViewController? = nil
    
    var requesterStartSessionViewController: RequesterStartSessionViewController? = nil
    
    var presented: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTutoringButton!.backgroundColor = requestButtonColor
        startHomeViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func requestTutoringButton(sender: AnyObject) {}
    
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
            self.addChildViewController(requesterStartSessionViewController!)
            vc.mainViewController = self
        }
    }
    
    @IBAction func returnHomeViewController(segue:UIStoryboardSegue) {
        let askedCourse = (segue.sourceViewController as! RequestHelpViewController).editedDropDown.text!
        self.lookingTutorsNoticeView.hidden = false
        self.blurEffect.hidden = false
        self.logout.enabled = false
        pairedListener(self, askedCourse: askedCourse)
    }
    
    @IBAction func startHomeViewControllerCancel(segue:UIStoryboardSegue) {
        startHomeViewController()
        cancelSession()
    }
    
    @IBAction func startHomeViewControllerFinish(segue:UIStoryboardSegue) {
        finishSession()
        return
    }
    
    func getTutorStudentSwitchAction() {
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
    }
    
    func startHomeViewController() {
        self.tutorStudentSwitch.hidden = false
        self.logout.enabled = true
        self.requestTutoringButton!.hidden = false
        self.blurEffect.hidden = true
        self.requesterContainerView.hidden = true
        self.tutorContainerView.hidden = true
        self.tutorSessionContainerView.hidden = true
        return
    }
    
}

