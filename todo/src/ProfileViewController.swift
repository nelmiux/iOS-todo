//
//  ProfileViewController.swift
//  todo
//
//  Created by mac on 3/1/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // UI Attributes
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var graduationLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var numDotsLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var coursesLabel: UILabel!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    // Class variables
    private var courseList:[String] = ["CH 301: Principles of Chemistry I", "CS 378: iOS Mobile Computing", "CS 312: Introduction to Java Programming", "CS 331: Algorithms and Complexity", "AET 306: Digital Imaging and Visualization"]
    private var name:String = ""
    private var major:String = ""
    private var graduation:String = ""
    var isOwnProfile:Bool = true
    private var isEditing:Bool = false
    
    @IBOutlet weak var CoursesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CoursesTableView.delegate = self
        self.CoursesTableView.dataSource = self
        self.CoursesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
        
        self.hideEditing()
        self.displayUserData(true)
        self.adjustButtonFunctionality()
    }
    
    func hideEditing () {
        self.saveBarButton.enabled = false
        self.saveBarButton.title = ""
        self.nameTextField.hidden = true
    }
    
    func showEditingFields () {
        // Display save button in top nav bar
        self.saveBarButton.enabled = true
        self.saveBarButton.title = "Save"
        
        // Display text fields with current data as placeholder
        self.nameTextField.hidden = false
        self.nameTextField.placeholder = self.name
    }
    
    func displayUserData (needToRetrieveData:Bool) {
        // Get data from Firebase if necessary
        if needToRetrieveData {
            self.displayUserPhoto()
            self.name = ("\(user["firstName"] as! String!) \(user["lastName"] as! String!)")
            self.major = user["major"] as! String!
            self.graduation = user["graduationYear"] as! String!
        }
        
        self.nameLabel.text = self.name
        let fullNameArr = self.name.characters.split{$0 == " "}.map(String.init)
        let firstName = fullNameArr[0]
        self.coursesLabel.text = ("Courses \(firstName) can  tutor for:")
        self.majorLabel.text = self.major
        self.graduationLabel.text = ("Class of \(self.graduation)")
        self.numDotsLabel.text = String(user["dots"]!) as String!
        // Still need to display correct activity image
    }
    
    func adjustButtonFunctionality () {
        if isOwnProfile {
            // If own profile, don't allow emails to self.
            self.emailButton.enabled = false
        } else {
            // If not own profile, don't allow profile editing
            self.editProfileButton.hidden = true
        }
    }
    
    func displayUserPhoto () {
        let base64String:String = user["photoString"] as! String!
        var decodedImage = UIImage(named: "DefaultProfilePhoto.png")
        
        // If user has selected image other than default image, decode the image
        if base64String.characters.count > 0 {
            let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            decodedImage = UIImage(data: decodedData!)!
        }
        
        self.photo.layer.cornerRadius = self.photo.frame.size.width / 2
        self.photo.clipsToBounds = true
        self.photo.image = decodedImage!
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
    }
    
    @IBAction func onClickEditProfile(sender: AnyObject) {
        self.isEditing = true
        self.showEditingFields()
    }
    
    @IBAction func onClickSave(sender: AnyObject) {
        // self.getEditedInput()
        self.hideEditing()
        self.displayUserData(false)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
