//
//  RegistrationViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, CourseSelectionProtocol {
    
    // Class attributes and programmatic UI
    private var addedCourses:[String] = [String]()
    private var selectedPhotoString = ""
    private var keyboardHeight:CGFloat = 0.0
    private var activeField: UITextField?
    private let imagePicker = UIImagePickerController()
    private var data = lowerDivisionCourses
    private var filterData = [String]()
    private var coursesListViewController: CoursesListView? = nil
    
    // UI Elements
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var registrationTableView: UITableView!
    @IBOutlet weak var addCourseTextField: UITextField!
    @IBOutlet weak var addCourseButton: UIButton!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardOnScreen:", name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardOffScreen:", name: UIKeyboardDidHideNotification, object: nil)
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
    
    // Course drop-down menu functionality
    @IBAction func beginAddingCourse(sender: UITextField) {
        self.activeField = sender
    }
    
    @IBAction func editAddCourseField(sender: UITextField) {
        onClickAddCourse(sender)
    }
    
    
    @IBAction func onClickAddCourse(sender: UITextField) {
        filterData = []
        if sender.text! == "" {
            filterData = data
        } else {
            for i in 0...data.count - 1 {
                if data[i].rangeOfString(sender.text!) != nil || data[i].lowercaseString.rangeOfString(sender.text!) != nil {
                    self.filterData.append(data[i])
                }
            }
        }
        
        // self.presentPopover(sourceController: self, sourceView: self.addCourseButton, sourceRect: CGRectMake(0, self.addCourseButton.bounds.height + 1, self.addCourseButton.bounds.width, 200))
        let buttonPos = self.addCourseButton.frame.origin
        print("addCourseButton is at \(buttonPos.x), \(buttonPos.y)")
        let buttonSize = self.addCourseButton.frame.size
        self.presentPopover(sourceController: self, sourceView: self.addCourseButton, sourceRect: CGRectMake(buttonPos.x, buttonPos.y, buttonSize.width, 200))
    }
    
    func presentPopover(sourceController sourceController:UIViewController, sourceView:UIView, sourceRect:CGRect) {
        // Create the view controller we want to display as the popup.
        
        if self.coursesListViewController != nil {
            self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
        }
        
        self.coursesListViewController = CoursesListView(title: "Courses List", preferredContentSize: CGSize(width: self.addCourseButton.bounds.width, height: 200))
        self.coursesListViewController!.mainController = self
        self.coursesListViewController!.courses = filterData
        
        // Cause the views to be created in this view controller. Gets them added to the view hierarchy.
        self.coursesListViewController?.view
        self.coursesListViewController!.tableView.layoutIfNeeded()
        
        // Set attributes for the popover controller.
        // Notice we're get an existing object from the view controller we want to popup!
        let popoverShowViewController = self.coursesListViewController!.popoverPresentationController
        popoverShowViewController?.permittedArrowDirections = UIPopoverArrowDirection()
        popoverShowViewController?.delegate = self
        popoverShowViewController?.sourceView = sourceView
        popoverShowViewController?.sourceRect = sourceRect
        
        // Show the popup.
        // Notice we are presenting form a view controller passed in. We need to present from a view controller
        // that has views that are already in the view hierarchy.
        sourceController.presentViewController(coursesListViewController!, animated: true, completion: nil)
    }
    
    /* func presentPopover(sourceController sourceController:UIViewController, sourceView:UIView, sourceRect:CGRect) {
        
        // Create the view controller we want to display as the popup.
        self.candidateListViewController = CandidateListViewController(title: "Candidates", preferredContentSize: CGSize(width: 350, height: 180))
        self.candidateListViewController?.setCellId(self.cellId)
        
        // Cause the views to be created in this view controller. Gets them added to the view hierarchy.
        self.candidateListViewController?.view
        self.candidateListViewController?.tableView.layoutIfNeeded()
        
        // Set attributes for the popover controller.
        // Notice we're get an existing object from the view controller we want to popup!
        let popoverMenuViewController = self.candidateListViewController!.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sourceView
        popoverMenuViewController?.sourceRect = sourceRect
        
        // Show the popup.
        // Notice we are presenting form a view controller passed in. We need to present from a view controller
        // that has views that are already in the view hierarchy.
        sourceController.presentViewController(self.candidateListViewController!, animated: true, completion: nil)
    } */
    
    func selectedCourse(course: String) {
        self.addCourseTextField.text = course
        if !addedCourses.contains(course) {
            addedCourses.append(course)
        }
    }
    
    func endFiltering(force: Bool) {
        self.view.endEditing(force)
    }
    
    // Keyboard Functionality
    func keyboardOnScreen(notification: NSNotification){
        let info: NSDictionary  = notification.userInfo!
        let kbSize = info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue.size
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height + 70.0, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize!.height
        //you may not need to scroll, see if the active field is already visible
        if activeField != nil {
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin) ) {
                let scrollPoint:CGPoint = CGPointMake(0.0, activeField!.frame.origin.y - kbSize!.height - 70.0)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    func keyboardOffScreen(notification: NSNotification){
        let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
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
            
            
            print("Added courses:")
            for course in addedCourses {
                print(course)
            }
            
            createUser(self, inputs: inputs, courses: addedCourses, segueIdentifier: identifier)
            return false
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}
