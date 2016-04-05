//
//  RequesterTutoringSessionViewController.swift
//  todo
//
//  Created by Nelma Perera on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class RequesterTutoringSessionViewController: UIViewController {
    
    @IBOutlet weak var requesterTutoringSessionTutorPhoto: UIImageView!
    
    @IBOutlet weak var requesterTutoringSessionTutorUsername: UILabel!
    
    @IBOutlet weak var requesterTutotringSessionCourse: UILabel!
    
    @IBOutlet weak var requesterTutoringSessionCountingTime: UILabel!
    
    @IBOutlet weak var requesterTutoringSessionPaying: UILabel!
    
     var mainViewController: HomeViewController? = nil
    
    var timer = NSTimer()
    
    var dots = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.view.frame = CGRectMake(0, 0, 414, 175)
        timer.invalidate()
        dots.invalidate()
        timeCount = 0
        self.requesterTutoringSessionCountingTime.text = "00:00:00"
        self.requesterTutoringSessionPaying.text = "0"
        
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
        self.requesterTutoringSessionCountingTime.text = String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    func dotsCounter() {
        let dotsCount = (timeCount + 59) / 60
        self.requesterTutoringSessionPaying.text = String(dotsCount)
        dotsTotal = dotsCount
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? HomeViewController {
            self.mainViewController = vc
        }
    }
}
