//
//  SignUpViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Class attributes
    private var registrationFields:[(String, String)] = [("First Name", "John"), ("Last Name", "Appleseed"), ("Email Address", "jappleseed@gmail.com"), ("Username", "username"), ("Password", "password"), ("Major", "Computer Science") , ("Graduation Year", "2016")]
    
    private var userData:[(String, String)] = [("First Name", ""), ("Last Name", ""),("Email Address", ""), ("Username", ""), ("Password", ""), ("Major", "") , ("Graduation Year", "")]
    
    var base64String: String = ""
    
    // UI Elements
    @IBOutlet weak var registrationTableView: UITableView!
    @IBOutlet weak var userThumbnail: UIImageView!
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
    
    // UI Handlers
    @IBAction func onClickUploadPhoto(sender: AnyObject) {
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
        cell.fieldLabel.text = field.0
        cell.inputField.placeholder = field.1
        
        userData[indexPath.row].1 = cell.inputField.text!
        
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
        base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
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

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "saveData" {
            var empty:Bool = false
            var i:Int = 0
            
            while i < userData.count {
                if userData[i].1 == "" {
                    empty = true
                    i = userData.count
                }
                ++i
            }
            
            if empty == true {
                
                let alertController = AlertController(title: "Error", message: "No Fields can be empty, please fill the form to continue", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                alertController.addAction(okAction)
                
                alertController.show()
                
                return false
            }
            
            var courses = []
            i = 0
            
            saveUserData(userData[3].1 + "/firstname/" + userData[0].1)
            saveUserData(userData[3].1 + "/lastname/" + userData[1].1)
            saveUserData(userData[3].1 + "/email/" + userData[2].1)
            saveUserData(userData[3].1 + "/pass/" + userData[4].1)
            saveUserData(userData[3].1 + "/mayor/" + userData[5].1)
            saveUserData(userData[3].1 + "/gradyear/" + userData[6].1)
            saveUserData(userData[3].1 + "/pic/" + base64String)
            while i < courses.count {
                saveUserData(userData[3].1 + "/courses/" + (courses[i] as! String))
                saveCoursesData((courses[i] as! String) + "/" + userData[3].1)
                ++i
            }
        }
        return true
    }
    
    private class AlertController: UIAlertController {
    
        private lazy var alertWindow: UIWindow = {
            let window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window.rootViewController = ClearViewController()
            window.backgroundColor = UIColor.clearColor()
            return window
        }()
    
        func show(animated flag: Bool = true, completion: (() -> Void)? = nil) {
            if let rootViewController = alertWindow.rootViewController {
                alertWindow.makeKeyAndVisible()
                rootViewController.presentViewController(self, animated: flag, completion: completion)
            }
        }
    
        deinit {
            alertWindow.hidden = true
        }
    }

    private class ClearViewController: UIViewController {
    
        private override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIApplication.sharedApplication().statusBarStyle
        }
    
        private override func prefersStatusBarHidden() -> Bool {
        return UIApplication.sharedApplication().statusBarHidden
        }
    }

}
