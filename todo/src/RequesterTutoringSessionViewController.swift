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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requesterTutoringSessionCountingTime.text = "00:00:00"
        self.requesterTutoringSessionPaying.text = "0"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.view.frame = CGRectMake(0, 0, 414, 175)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? HomeViewController {
            self.mainViewController = vc
        }
    }
}
