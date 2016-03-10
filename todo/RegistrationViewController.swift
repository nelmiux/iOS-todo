//
//  RegistrationViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Class attributes
    private var appSettings = AppSettings()
    private var addedCourses:[String] = [String]()
    private var selectedPhotoString = ""
    
    // UI Elements
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var departmentButton: UIButton!
    @IBOutlet weak var upperLowerButton: UIButton!
    @IBOutlet weak var seeCoursesButton: UIButton!
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var registrationTableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate UI element data components
        self.registrationTableView.delegate = self
        self.registrationTableView.dataSource = self
        self.imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCourses (newCourses:[String]) {
        for course in newCourses {
            self.addedCourses.append(course)
        }
    }
    
    // UI Handlers
    @IBAction func onClickChangePhoto(sender: AnyObject) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onClickDivision(sender: AnyObject) {
        let popOverController = OptionsPopoverViewController()
        popOverController.setParentButton(self.upperLowerButton)
        popOverController.presentPopover(sourceController: self, sourceView: self.upperLowerButton, sourceRect: self.upperLowerButton.bounds)
    }
    
    @IBAction func onClickSignUp(sender: AnyObject) {
        // TODO: Validate users 
        // Retrieve all of the strings
        var inputs:[String] = [String]()
        for cell in self.registrationTableView.visibleCells {
            inputs.append((cell as! RegistrationTableViewCell).inputField.text!)
        }
        var newUser = [self.appSettings.registrationFields[0].0: inputs[0],
                        self.appSettings.registrationFields[1].0: inputs[1],
                        self.appSettings.registrationFields[3].0: inputs[3],
                        self.appSettings.registrationFields[4].0: inputs[4],
                        self.appSettings.registrationFields[5].0: inputs[5],
                        self.appSettings.registrationFields[6].0: inputs[6],
                        "photoString": selectedPhotoString,
                        "Courses": self.addedCourses]
        
        // Create the user
        let newUserRef = self.appSettings.usersRef.childByAppendingPath(inputs[2])
        newUserRef.setValue(newUser)
    }
    
    
    // TableView Functionality
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appSettings.registrationFields.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:RegistrationTableViewCell = self.registrationTableView.dequeueReusableCellWithIdentifier("registrationCell", forIndexPath: indexPath) as! RegistrationTableViewCell
        let field = self.appSettings.registrationFields[indexPath.row]
        cell.fieldLabel.text = field.0
        cell.inputField.placeholder = field.1
        
        // Handle special cases
        if field.0 == "Email Address" {
            cell.inputField.keyboardType = UIKeyboardType.EmailAddress
        }
        if field.0 == "Password" {
            cell.inputField.secureTextEntry = true
        }
        return cell
    }
    
    // ImagePicker Functionality
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // Encode the selected image
        let thumbnail = self.resizeImage(image, sizeChange: CGSize(width: 200, height: 200))
        let imageData = UIImageJPEGRepresentation(thumbnail, 1.0)
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        self.selectedPhotoString = base64String

        // Update the UI to display selected photo
        self.userThumbnail.image = thumbnail
        self.userThumbnail.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeImage (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewCoursesToAdd" {
            if self.upperLowerButton.titleLabel?.text as String! == "Upper" {
                (segue.destinationViewController as! AddCoursesTableViewController).setCourses(self.appSettings.upperDivisionCourses)
                segue.destinationViewController.navigationItem.title = "CS: Upper"
                (segue.destinationViewController as! AddCoursesTableViewController).registrationViewController = self
            } else if self.upperLowerButton.titleLabel?.text as String! == "Lower" {
                (segue.destinationViewController as! AddCoursesTableViewController).setCourses(self.appSettings.lowerDivisionCourses)
                segue.destinationViewController.navigationItem.title = "CS: Lower"
                (segue.destinationViewController as! AddCoursesTableViewController).registrationViewController = self
            }
        }
    }
    
}
