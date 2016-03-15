//
//  RegistrationViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Class attributes
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        
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
    
    // TableView Functionality
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrationFields.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:RegistrationTableViewCell = self.registrationTableView.dequeueReusableCellWithIdentifier("registrationCell", forIndexPath: indexPath) as! RegistrationTableViewCell
        let field = registrationFields[indexPath.row]
        cell.inputField.delegate = self
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        hideKeyboard()
        // Check that the user tapped the "Done" button
        if identifier == "registerUser" {
            // TODO: Validate user's input for each field
            // Retrieve all of the strings
            var inputs:[String: String] = [String: String]()
            for cell in self.registrationTableView.visibleCells {
                let currentCell = (cell as! RegistrationTableViewCell)
                currentCell.errorLabel.text = "Invalid \(currentCell.fieldLabel.text!.lowercaseString as String!)"
                currentCell.errorLabel.hidden = true
                if currentCell.inputField.text! == "" {
                    currentCell.errorLabel.hidden = false
                    return false
                }
                inputs[currentCell.fieldLabel.text!] = currentCell.inputField.text!
            }
            
            // If the input is VALID, create user and persist to Firebase
            inputs["Photo String"] = self.selectedPhotoString
            
            createUser(self, inputs: inputs, courses: addedCourses, segueIdentifier: identifier)
            return false
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewCoursesToAdd" {
            if self.upperLowerButton.titleLabel?.text as String! == "Upper" {
                (segue.destinationViewController as! AddCoursesTableViewController).setCourses(upperDivisionCourses)
                segue.destinationViewController.navigationItem.title = "CS: Upper"
                (segue.destinationViewController as! AddCoursesTableViewController).registrationViewController = self
            } else if self.upperLowerButton.titleLabel?.text as String! == "Lower" {
                (segue.destinationViewController as! AddCoursesTableViewController).setCourses(lowerDivisionCourses)
                segue.destinationViewController.navigationItem.title = "CS: Lower"
                (segue.destinationViewController as! AddCoursesTableViewController).registrationViewController = self
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
}
