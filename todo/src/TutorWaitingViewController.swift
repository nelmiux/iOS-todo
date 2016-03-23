//
//  TutorWaitingViewController.swift
//  todo
//
//  Created by Nelma Perera on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class TutorWaitingViewController: UIViewController {
    
    @IBOutlet weak var requesterPhoto: UIImageView!
    
    @IBOutlet weak var requesterUsername: UILabel!
    
    @IBOutlet weak var requesterCourse: UILabel!
    
    var mainViewControler: HomeViewController? = nil
    
    var _requester_: Dictionary<String, String> {
        var requesterCopy = [String: String]()
        dispatch_sync(concurrentDataAccessQueue) {
            requesterCopy = requester
        }
        return requesterCopy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if _requester_["photoString"] != nil {
            let decodedImage = decodeImage(_requester_["photoString"]!)
            self.requesterPhoto.image = decodedImage
            self.requesterUsername.text = "Waiting for " + _requester_["username"]! + " to Start the Session"
            self.requesterCourse.text = _requester_["course"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
}
