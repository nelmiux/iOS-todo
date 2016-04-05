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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
