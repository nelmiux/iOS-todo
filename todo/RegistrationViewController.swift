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
        // TODO: Validate user's input for each field
        // Retrieve all of the strings
        var inputs:[String: String] = [String: String]()
        var invalidInput = false
        for cell in self.registrationTableView.visibleCells {
            let field:String = (cell as! RegistrationTableViewCell).fieldLabel.text!
            let input:String = (cell as! RegistrationTableViewCell).inputField.text!
            if input == "" {
                (cell as! RegistrationTableViewCell).errorLabel.text = "Invalid \(field.lowercaseString as String!)"
                invalidInput = true
            } else {
                inputs[field] = input
            }
        }
        
        // If the input is VALID, create user and persist to Firebase
        if !invalidInput {
            inputs["Photo String"] = self.selectedPhotoString
            
            self.appSettings.rootRef.createUser(inputs["Email Address"], password: inputs["Password"],
                withValueCompletionBlock: { error, result in
                    if error != nil {
                        
                        // Alert the user that an error occurred upon registration
                        let alertController = UIAlertController(title: nil, message: "An error has occurred. There may be an existing account for the provided email address.", preferredStyle: UIAlertControllerStyle.Alert)
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                    } else {
                        let uid = result["uid"] as? String
                        
                        // Insert the user data
                        let newUserRef = self.appSettings.usersRef.childByAppendingPath(uid)
                        newUserRef.setValue(inputs)
                        print("Successfully created user account with uid: \(uid)")
                        
                        // Alert the user that they have succesfully registered
                        let alertController = UIAlertController(title: nil, message: "Congrats! You are ready to start using todo.", preferredStyle: UIAlertControllerStyle.Alert)
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion:nil)
                    }
            })
        }
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
