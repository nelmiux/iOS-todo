//
//  ProfileViewController.swift
//  todo
//
//  Created by mac on 3/1/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI Attributes
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var numDotsLabel: UILabel!

    // Class variables
    private var courseList:[String] = ["CH 301: Principles of Chemistry I", "CS 378: iOS Mobile Computing", "CS 312: Introduction to Java Programming", "CS 331: Algorithms and Complexity", "AET 306: Digital Imaging and Visualization"]
    var isOwnProfile:Bool = false
    
    @IBOutlet weak var CoursesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CoursesTableView.delegate = self
        self.CoursesTableView.dataSource = self
        self.CoursesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.CoursesTableView.dequeueReusableCellWithIdentifier("courseCell", forIndexPath: indexPath)
        cell.textLabel!.text = courseList[indexPath.row]
        return cell
    }
    
    @IBAction func onClickEmail(sender: AnyObject) {
        // Open email app with user's email in "to" field
        // Deactive if isOwnProfile is true
    }
    
    @IBAction func onClickEditProfile(sender: AnyObject) {
        // Hide if isOwnProfile is false
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
