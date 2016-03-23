//
//  RequesterStartSessionViewController.swift
//  todo
//
//  Created by Nelma Perera on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class RequesterStartSessionViewController: UIViewController {
    
    @IBOutlet weak var tutorPhoto: UIImageView!
    
    @IBOutlet weak var tutorUsername: UILabel!
    
    @IBOutlet weak var tutorCourse: UILabel!
    
    var _paired_: Dictionary<String, String> {
        var pairedCopy = [String: String]()
        dispatch_sync(concurrentDataAccessQueue) {
            pairedCopy = paired
        }
        return pairedCopy
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if paired["photoString"] != nil {
            let decodedImage = decodeImage(_paired_["photoString"]!)
            self.tutorPhoto.image = decodedImage
            self.tutorUsername.text = _paired_["username"]! + " is coming to help you on:"
            self.tutorCourse.text = _paired_["course"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startSessionButton(sender: AnyObject) {
        startSession(self)
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
