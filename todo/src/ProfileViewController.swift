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
    @IBOutlet weak var editProfileButton: UIButton!
    
    // Class variables
    private var courseList:[String] = ["CH 301: Principles of Chemistry I", "CS 378: iOS Mobile Computing", "CS 312: Introduction to Java Programming", "CS 331: Algorithms and Complexity", "AET 306: Digital Imaging and Visualization"]
    var isOwnProfile:Bool = false
    
    @IBOutlet weak var CoursesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CoursesTableView.delegate = self
        self.CoursesTableView.dataSource = self
        self.CoursesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
        
        self.displayUserData()
    }
    
    func displayUserData () {
        self.photo.image = self.getUserPhoto()
        self.nameLabel.text = ("\(user["firstName"] as! String!) \(user["lastName"] as! String!)")
        self.infoLabel.text = ("\(user["major"] as! String!), \(user["graduationYear"] as! String!)")
        self.numDotsLabel.text = String(user["dots"]) as String!
        // Still need to display correct activity image
    }
    
    func getUserPhoto () -> UIImage {
        let base64String:String = user["photoString"] as! String!
        var decodedImage = UIImage(named: "DefaultProfilePhoto.png")
        
        // If user has selected image other than default image, decode the image
        if base64String.characters.count > 0 {
            let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            decodedImage = UIImage(data: decodedData!)!
        }
        
        return decodedImage!
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
        
        if isOwnProfile {
            self.emailButton.enabled = false
        }
    }
    
    @IBAction func onClickEditProfile(sender: AnyObject) {
        if !isOwnProfile {
            self.editProfileButton.hidden = true
        }
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
