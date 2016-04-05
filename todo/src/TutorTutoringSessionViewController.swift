//
//  TutorTutoringSessionViewController.swift
//  todo
//
//  Created by Nelma Perera on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class TutorTutoringSessionViewController: UIViewController {
    
    @IBOutlet weak var tutorTutoringSessionPhoto: UIImageView!
    
    @IBOutlet weak var tutorTutoringSessionUsername: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionCourse: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionCountingTime: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionEarning: UILabel!
    
    var timer = NSTimer()
    
    var dots = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tutorTutoringSessionCountingTime.text = "00:00:00"
        self.tutorTutoringSessionEarning.text = "0"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
