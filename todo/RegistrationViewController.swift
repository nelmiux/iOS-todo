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
    private var registrationFields:[(String, String)] = [("First Name", "John"), ("Last Name", "Appleseed"), ("UT EID", "abc123"), ("Email Address", "jappleseed@gmail.com"), ("Password", "password"), ("Major", "Computer Science") , ("Graduation Year", "2016")]
    
    private var upperDivisionCourses:[String] = [String]()
    private var lowerDivisionCourses:[String] = ["312 Introduction to Programming", "314 Data Structures", "314H Data Structures Honors", "302 Computer Fluency", "105 Computer Programming", "311 Discrete Math for Computer Science", "311H Discrete Math for Computer Science: Honors", "109 Topics in Computer Science", "313E Elements of Software Design"]
    
    private var addedCourses:[String] = [String]()
    
    private var coursesAreLoaded:Bool = false
    
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
        
        // Load course data
        if !coursesAreLoaded {
            self.loadCourses()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCourses () {
        var count = 0
        if let aStreamReader_upper = StreamReader(path: "/CS_Upper.txt") {
            defer {
                aStreamReader_upper.close()
            }
            while let line = aStreamReader_upper.nextLine() {
                print(line)
                /* upperDivisionCourses.append(line)
                print(lowerDivisionCourses[count])
                count++ */
            }
        }
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
        // Retrieve all of the strings
        var inputs:[String] = [String]()
        for cell in self.registrationTableView.visibleCells {
            inputs.append((cell as! RegistrationTableViewCell).inputField.text!)
        }
        var newUser = [inputs[0]: inputs[0], inputs[1]: inputs[1]]
        
        // Create the user
        let usersRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com/users")
        let newUserRef = usersRef.childByAppendingPath("user1")
        newUserRef.setValue(newUser)
    }
    
    
    // TableView Functionality
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrationFields.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:RegistrationTableViewCell = self.registrationTableView.dequeueReusableCellWithIdentifier("registrationCell", forIndexPath: indexPath) as! RegistrationTableViewCell
        let field = registrationFields[indexPath.row]
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
        // Send to firebase
        let thumbnail = self.resizeImage(image, sizeChange: CGSize(width: 200, height: 200))
        
        // Encode image
        let imageData = UIImageJPEGRepresentation(thumbnail, 1.0)
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        // Send to string to database
        /* let myRootRef = Firebase(url:"https://scorching-heat-4336.firebaseio.com")
        let imagesRef = myRootRef.childByAppendingPath("photoStrings")
        imagesRef.setValue(base64String)
        
        // Read image string from database
        imagesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let imageString = snapshot.value {
        let decodedData = NSData(base64EncodedString: snapshot.value as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        self.userThumbnail.image = decodedImage
        self.userThumbnail.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
        } else {
        // Put default image
        print("snapshot is null")
        }
        }) */
        
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
                (segue.destinationViewController as! AddCoursesTableViewController).setCourses(self.upperDivisionCourses)
                segue.destinationViewController.navigationItem.title = "CS: Upper"
                (segue.destinationViewController as! AddCoursesTableViewController).registrationViewController = self
            } else if self.upperLowerButton.titleLabel?.text as String! == "Lower" {
                (segue.destinationViewController as! AddCoursesTableViewController).setCourses(self.lowerDivisionCourses)
                segue.destinationViewController.navigationItem.title = "CS: Lower"
                (segue.destinationViewController as! AddCoursesTableViewController).registrationViewController = self
            }
        }
    }
    
}
