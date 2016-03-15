//
//  HomeViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/11/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tutorStudentSwitch: UISegmentedControl!
    
    @IBOutlet weak var requestTutoringButton: UIButton!
    
    let requestButtonColor = UIColor(red: 235.0/255.0, green: 84.0/255.0, blue: 55.0/255.0, alpha: 0.8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTutoringButton!.backgroundColor = requestButtonColor
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
            user["role"] = "tutor"
            return
        }
        requestTutoringButton!.backgroundColor = requestButtonColor
        requestTutoringButton!.enabled = true
        requestTutoringButton!.userInteractionEnabled = true
        user["role"] = "student"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout" {
            logOutUser()
        }
    }
}
