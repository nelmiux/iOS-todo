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
    
    var _requester_: Dictionary<String, String> {
        var requesterCopy = [String: String]()
        dispatch_sync(concurrentDataAccessQueue) {
            requesterCopy = requester
        }
        return requesterCopy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if _requester_["photoString"] != nil {
            let decodedImage = decodeImage(_requester_["photoString"]!)
            self.tutorTutoringSessionPhoto.image = decodedImage
            self.tutorTutoringSessionUsername.text = "Waiting for " + _requester_["username"]! + " to Start the Session"
            self.tutorTutoringSessionCourse.text = _requester_["course"]
        }
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func finishSessionButton(sender: AnyObject) {
        self.view.hidden = true
        finishSession()
    }
    
    func timeCounter() {
        timeCount += 1
        let seconds = timeCount % 60
        let minutes = (timeCount / 60) % 60
        let hours = (timeCount / 3600)
        self.tutorTutoringSessionCountingTime.text = String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    func dotsCounter() {
        let dotsCount = (timeCount + 59) / 60
        self.tutorTutoringSessionEarning.text = String(dotsCount)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
