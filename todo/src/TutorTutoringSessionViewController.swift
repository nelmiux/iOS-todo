//
//  TutorTutoringSessionViewController.swift
//  todo
//
//  Created by Nelma Perera on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class TutorTutoringSessionViewController: UIViewController {
    
    var timeCount = 0
    
    @IBOutlet weak var tutorTutoringSessionPhoto: UIImageView!
    
    @IBOutlet weak var tutorTutoringSessionUsername: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionCourse: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionCountingTime: UILabel!
    
    @IBOutlet weak var tutorTutoringSessionEarning: UILabel!
    
    var timer = NSTimer()
    
    var dots = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        timer.invalidate()
        dots.invalidate()
        timeCount = 0
        self.tutorTutoringSessionCountingTime.text = "00:00:00"
        self.tutorTutoringSessionEarning.text = "0"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.timeCounter), userInfo: nil, repeats: true)
        
        dots = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.dotsCounter), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func timeCounter() {
        timeCount += 1
        let seconds = timeCount % 60
        let minutes = (timeCount / 60) % 60
        let hours = (timeCount / 3600)
        self.tutorTutoringSessionCountingTime.text = String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
    
    func dotsCounter() {
        let dotsCount = (timeCount + 59) / 60
        self.tutorTutoringSessionEarning.text = String(dotsCount)
        dotsTotal = dotsCount
    }
}
