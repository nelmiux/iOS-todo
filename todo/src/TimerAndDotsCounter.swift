//
//  TimerAndDotsCounter.swift
//  todo
//
//  Created by Nelma Perera on 4/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class TimerAndDotsCounter {
    
    var timer = NSTimer()
    
    var dots = NSTimer()
    
    var viewControler: AnyObject? = nil
    
    init (viewControler: AnyObject) {
        self.viewControler = viewControler
        self.timer.invalidate()
        self.dots.invalidate()
        timeCount = 0
    }
    
    func startCounter () {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.timeCounter), userInfo: nil, repeats: true)
        
        dots = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.dotsCounter), userInfo: nil, repeats: true)
    }
    
    @objc func timeCounter() {
        timeCount += 1
        let seconds = timeCount % 60
        let minutes = (timeCount / 60) % 60
        let hours = (timeCount / 3600)
        if let vc = viewControler as? TutorTutoringSessionViewController {
            vc.tutorTutoringSessionCountingTime.text = String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        }
        if let vc = viewControler as? RequesterTutoringSessionViewController {
            vc.requesterTutoringSessionCountingTime.text = String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        }
    }
    
    @objc func dotsCounter() {
        let dotsCount = (timeCount + 59) / 60
        if let vc = viewControler as? TutorTutoringSessionViewController {
            vc.tutorTutoringSessionEarning.text = String(dotsCount)
        }
        if let vc = viewControler as? RequesterTutoringSessionViewController {
            vc.requesterTutoringSessionPaying.text = String(dotsCount)
        }
        dotsTotal = dotsCount
    }
}


