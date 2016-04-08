//
//  RegistrationTableViewController.swift
//  todo
//
//  Created by Nelma Perera on 4/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CourseSelectionProtocol {
    
    // Class attributes and programmatic UI
    private var addedCourses:[String] = [String]()
    private var selectedPhotoString = ""
    private var keyboardHeight:CGFloat = 0.0
    private var activeField: UITextField?
    private let imagePicker = UIImagePickerController()
    private var data = lowerDivisionCourses
    private var filterData = [String]()
    private var coursesListViewController: CoursesListView? = nil
    private var referenceFrame:CGRect? = nil
    
    // UI Elements
    
    @IBOutlet weak var userThumbnail: UIImageView!
    
    @IBOutlet weak var searchCoursesLabel: UILabel!
    
    @IBOutlet weak var addCourseTextField: UITextField!
    
    @IBOutlet weak var addCourseButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    //Cell fields

    @IBOutlet weak var fNameText: UITextField!
    
    @IBOutlet weak var lNameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var majorText: UITextField!
    
    @IBOutlet weak var gYearText: UITextField!
    
    @IBOutlet weak var fNameError: UILabel!
    
    @IBOutlet weak var lNameError: UILabel!
    
    @IBOutlet weak var emailError: UILabel!
    
    @IBOutlet weak var usernameError: UILabel!
    
    @IBOutlet weak var passwordError: UILabel!
    
    @IBOutlet weak var majorError: UILabel!
    
    @IBOutlet weak var gYearError: UILabel!
    
    @IBOutlet weak var lastCell: UITableViewCell!
    
    @IBOutlet weak var coursesCollectionView: UICollectionView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var coursesCollectionViewWidth: CGFloat!
    var coursesCollectionViewHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenSize = UIScreen.mainScreen().bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        self.coursesCollectionView.backgroundColor = .clearColor()
        self.tableView.addSubview(coursesCollectionView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        
        self.fNameText.delegate = self
        self.lNameText.delegate = self
        self.emailText.delegate = self
        self.usernameText.delegate = self
        self.passwordText.delegate = self
        self.majorText.delegate = self
        self.gYearText.delegate = self
        self.imagePicker.delegate = self
        self.addCourseTextField.delegate = self

        setErrorMessages()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout = self.coursesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.coursesCollectionViewWidth = layout.collectionViewContentSize().width
        self.coursesCollectionViewHeight = layout.collectionViewContentSize().height
        layout.itemSize = CGSize(width: coursesCollectionViewWidth/2.3, height: screenWidth/12)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        coursesCollectionView!.dataSource = self
        coursesCollectionView!.delegate = self
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
    
    func setErrorMessages () {
        self.fNameError.hidden = true
    
        self.lNameError.hidden = true
    
        self.emailError.hidden = true
    
        self.usernameError.hidden = true
    
        self.passwordError.hidden = true
    
        self.majorError.hidden = true
    
        self.gYearError.hidden = true
    }
    
    @IBAction func onClickChangePhoto(sender: AnyObject) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
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
        filterData = []
        allCoursesRef.observeEventType(.Value, withBlock: { snapshot in
            allCourses = snapshot.value as! Dictionary<String, String>
            }, withCancelBlock: { error in
                print(error.description)
        })

        if sender.text == nil || sender.text! == "" {
            self.data = self.toStringArrayFrom(allCourses)
            self.filterData = self.data
        } else {
            for i in 0...self.data.count - 1 {
                if self.data[i].rangeOfString(sender.text!) != nil || self.data[i].lowercaseString.rangeOfString(sender.text!) != nil {
                    self.filterData.append(self.data[i])
                }
            }
        }
        self.presentPopover(sourceController: self, sourceView: self.addCourseButton, sourceRect: CGRectMake(0, 0, self.addCourseButton.bounds.width, 200))
    }
    
    func toStringArrayFrom(dict:Dictionary<String,String>) -> [String]{
        
        var result:[String] = []
        for key in dict{
            result.append(key.0 + ": " + key.1)
        }
        return result
    }

    func presentPopover(sourceController sourceController:UIViewController, sourceView:UIView, sourceRect:CGRect) {
        // Create the view controller we want to display as the popup.
        
        if self.coursesListViewController != nil {
            self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
        }
        
        self.coursesListViewController = CoursesListView(title: "Courses List", preferredContentSize: CGSize(width: self.addCourseButton.bounds.width, height: 300))
        self.coursesListViewController!.mainController = self
        self.coursesListViewController!.courses = filterData
        
        // Cause the views to be created in this view controller. Gets them added to the view hierarchy.
        self.coursesListViewController?.view
        self.coursesListViewController!.tableView.layoutIfNeeded()
        
        // Set attributes for the popover controller.
        // Notice we're get an existing object from the view controller we want to popup!
        let popoverShowViewController = self.coursesListViewController!.popoverPresentationController
        popoverShowViewController?.permittedArrowDirections = .Down
        popoverShowViewController?.delegate = self
        popoverShowViewController?.sourceView = sourceView
        popoverShowViewController?.sourceRect = sourceRect
        popoverShowViewController?.adaptivePresentationStyle()
        
        // Show the popup.
        // Notice we are presenting form a view controller passed in. We need to present from a view controller
        // that has views that are already in the view hierarchy.
        sourceController.presentViewController(coursesListViewController!, animated: true, completion: nil)
    }
    
    func selectedCourse(course: String) {
        self.addCourseTextField.text = course
    }
    
    func endFiltering(force: Bool) {
        self.view.endEditing(force)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Indicate we want the same presentation behavior on both iPhone and iPad.
        return UIModalPresentationStyle.None
    }

    
    //Courses addition and deletion
    @IBAction func onClickAdd(sender: AnyObject) {
        var course = self.addCourseTextField.text as String!
        course = course.componentsSeparatedByString(":")[0]
        
        // If no course has been inputted, do nothing
        if course.characters.count == 0 {
            return
        }
        
        // Ensure that a course is not added twice
        if !addedCourses.contains(course) {
            addedCourses.append(course)
            let index = addedCourses.count - 1
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            self.coursesCollectionView.insertItemsAtIndexPaths([indexPath])
            self.coursesCollectionView.layoutIfNeeded()
            /*if addedCourses.count % 4 == 0 && addedCourses.count != 1 {
                
               let layout = self.coursesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                
                self.coursesCollectionView.frame.size = CGSize(width: coursesCollectionViewWidth/2.3, height: layout.itemSize.height + layout.itemSize.height * 2)
                self.lastCell.frame.size.height = self.lastCell.frame.size.height + layout.itemSize.height * 2
                var bounds = self.tableView.bounds
                bounds.size.height = tableView.contentSize.height + layout.itemSize.height * 3
                
                //self.tableView.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
                
                tableView.bounds = bounds
            }*/

        }
        
        self.addCourseTextField.text = ""
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //scrollView.contentOffset.y = scrollView.contentOffset.y + 100
        //scrollView.contentInset.top
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addedCourses.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) ->UICollectionViewCell {
        let cell = coursesCollectionView.dequeueReusableCellWithReuseIdentifier("userCourses", forIndexPath: indexPath) as! CourseCollectionViewCell
        
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        
        cell.backgroundColor = color
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6
        
        cell.courseLabel!.text = addedCourses[indexPath.row]
        
        cell.courseRemoveButton?.layer.setValue(indexPath.row, forKey: "index")
        
        cell.courseRemoveButton?.addTarget(self, action: #selector(RegistrationTableViewController.removeCourse(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    
        return cell
    }
    
    func removeCourse(sender:UIButton) {
        let i: Int = (sender.layer.valueForKey("index")) as! Int
        addedCourses.removeAtIndex(i)
        coursesCollectionView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        hideKeyboard()
        // Check that the user tapped the "Done" button
        if identifier == "registerUser" {
            // TODO: Validate user's input for each field
            // Retrieve all of the strings
            
            setErrorMessages()
            
            if !validateCells() {
                return false
            }
            
            var inputs:[String: String] = [
                "First Name": self.fNameText.text!,
                "Last Name": self.lNameText.text!,
                "Email Address": self.emailText.text!,
                "Username": self.usernameText.text!,
                "Password": self.usernameText.text!,
                "Major": self.majorText.text!,
                "Graduation Year": self.majorText.text!]
            
            
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
    
    func validateCells () -> Bool {
        if self.fNameText.text == "" {
            self.fNameError.hidden = false
            return false
        }
        
        if self.lNameText.text == "" {
            self.lNameError.hidden = false
            return false
        }
        
        if self.emailText.text == "" {
            self.emailError.hidden = false
            return false
        }
        
        if self.usernameText.text == "" {
            self.usernameError.hidden = false
            return false
        }
        
        if self.passwordText.text == "" {
            self.passwordError.hidden = false
            return false
        }
        
        if self.majorText.text == "" {
            self.majorError.hidden = false
            return false
        }
        
        if self.gYearText.text == "" {
            self.gYearError.hidden = false
            return false
        }
        return true
    }
        
    // Keyboard Functionality
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
}
