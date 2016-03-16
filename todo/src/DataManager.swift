//
//  AppSettings.swift
//  todo
//
//  Created by Quyen Castellanos on 3/7/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase
 
// Firebase Refs
let firebaseURL:String = "https://scorching-heat-4336.firebaseio.com"
let rootRef = getFirebase("")
let usersRef = getFirebase("users")
let appSettingsRef = getFirebase("applicationSettings")
    
let registrationFields:[(String, String)] = [("First Name", "John"), ("Last Name", "Appleseed"),  ("Email Address", "jappleseed@gmail.com"), ("Username", "abc123"), ("Password", "password"), ("Major", "Computer Science") , ("Graduation Year", "2016")]
// TODO: We will want this in the database
let lowerDivisionCourses:[String] = ["CS312: Introduction to Programming", "CS314: Data Structures", "CS314H: Data Structures Honors", "CS302: Computer Fluency", "CS105: Computer Programming", "CS311: Discrete Math for Computer Science", "CS311H: Discrete Math for Computer Science: Honors", "CS109: Topics in Computer Science", "CS313E: Elements of Software Design"]
let upperDivisionCourses:[String] = [String]()

let allCourses = Dictionary<String, String>()

var user = Dictionary<String, AnyObject>()

var courses = Dictionary<String, [String: String]>()

var notifications = Dictionary<String, [String: String]>()

var history = Dictionary<String, [String: String]>()

var usersPerCourse = Dictionary<String, String>()

var requester = Dictionary<String, String>()

func getFirebase(loc: String) -> Firebase! {
    let location = (loc == "" ? firebaseURL : firebaseURL + "/" + loc)
    return Firebase(url:location)
}

func alert (view: AnyObject, description: String, action: UIAlertAction) {
    let alertController = UIAlertController(title: nil, message: description, preferredStyle: UIAlertControllerStyle.Alert)
    let OKAction = action
    alertController.addAction(OKAction)
    view.presentViewController(alertController, animated: true, completion:nil)
}

func alertWithPic (view: AnyObject, description: String, action: UIAlertAction, pic: UIImage) {
    let alertController = UIAlertController(title: nil, message: description, preferredStyle: UIAlertControllerStyle.Alert)
    let OKAction = action
    
    let imageView = UIImageView(frame: CGRectMake((alertController.view.bounds.width)/3 - 30, 15, 60, 60))
    imageView.image = pic as UIImage
    
    imageView.layer.cornerRadius = imageView.frame.size.width / 2
    
    alertController.view.addSubview(imageView)
    alertController.addAction(OKAction)
    view.presentViewController(alertController, animated: true, completion:nil)
}


func createUser(view: AnyObject, inputs: [String: String], courses: [String], segueIdentifier: String) {
    rootRef.createUser(inputs["Email Address"], password: inputs["Password"], withValueCompletionBlock: {
        error, result in
        if error == nil {
            // Insert the user data
            let newUserRef = usersRef.childByAppendingPath(inputs["Username"])
            user = inputs
            user["dots"] = 100
            user["earned"] = 100
            user["payed"] = 0
            user["courses"] = courses
            user["requesterUsername"] = ""
            user["requesterPhoto"] = ""
            user["requesterCourse"] = ""
            user["requesterDescription"] = ""
            user["pairedUsername"] = ""
            user["pairedPhoto"] = ""
            user["tutorWaiting"] = false
            user["start"] = ""
            user["finish"] = ""
            newUserRef.setValue(user)
            print("Successfully created user account with username: \(inputs["Username"]!)")
            alert(view, description: "Congrats! You are ready to start using todo.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                result in
                view.performSegueWithIdentifier(segueIdentifier, sender: nil)
            })
            return
        }
        alert(view, description: "An error has occurred. There may be an existing account for the provided email address.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
    )
}

func loginUser(view: AnyObject, username: String, password:String, segueIdentifier: String) {
    let currUserRef = getFirebase("users/" + username)
    user = [:]
    currUserRef.observeEventType(.Value, withBlock: {
        snapshot in
            if let email = snapshot.value["Email Address"] as? String {
                print("email = \(email)")
    
                // Attempt to log the user in
                rootRef.authUser(email, password: password) {
                    error, authData in
                    if error != nil {
                        print("Unable to login.\nInvalid password.")
                        alert(view, description: "Unable to login. Invalid password.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        return
                    }
                    
                    user["firstName"] = (snapshot.value["First Name"] as? String)!
                    user["lastName"] = (snapshot.value["Last Name"] as? String)!
                    user["username"] = (snapshot.value["Username"] as? String)!
                    user["password"] = (snapshot.value["Password"] as? String)!
                    user["email"] = (snapshot.value["Email Address"] as? String)!
                    user["major"] = (snapshot.value["Major"] as? String)!
                    user["graduationYear"] = (snapshot.value["Graduation Year"] as? String)!
                    user["photoString"] = (snapshot.value["Photo String"] as? String)!
                    if let _ = snapshot.value["courses"] as? [String: String] {
                        user["courses"] = (snapshot.value["courses"] as? [String: String])!
                    }
                    user["dots"] = (snapshot.value["dots"] as? Int)!
                    user["earned"] = (snapshot.value["earned"] as? Int)!
                    user["payed"] = (snapshot.value["payed"] as? Int)!
                    if let _ = snapshot.value["lastLogin"] as? String {
                        user["lastLogin"] = (snapshot.value["lastLogin"] as? String)!
                    }
                    user["requesterUsername"] = ""
                    user["requesterPhoto"] = ""
                    user["requesterCourse"] = ""
                    user["requesterDescription"] = ""
                    user["pairedUsername"] = ""
                    user["pairedPhoto"] = ""
                    user["tutorWaiting"] = false
                    user["start"] = ""
                    user["finish"] = ""
                    
                    view.performSegueWithIdentifier(segueIdentifier, sender: nil)
                }
            } else {
                print("Unable to login. Invalid username.")
                alert(view, description: "Unable to login.\nInvalid username.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            }
    })
}

func sendRequest (view: AnyObject, askedCourse: String, description: String, segueIdentifier: String) {
    let coursesRef = getFirebase("courses/")
    coursesRef.observeEventType(.Value, withBlock: { snapshot in
        if let _ = snapshot.value[askedCourse] as? Dictionary<String, String> {
            usersPerCourse = snapshot.value[askedCourse] as! Dictionary<String, String>
            for key in usersPerCourse.keys {
                if key != user["username"] as! String {
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterPhoto": user["photoString"]!])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterCourse": askedCourse])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterDescription": description])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterUsername": user["username"]!])
                }
            }
            view.performSegueWithIdentifier(segueIdentifier, sender: nil)
            return
        }
        alert(view, description: "This course does not exist on our Database.\nPlease enter a valid UT course.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    })
}

func requestLisener(view: AnyObject) {
    let username = (user["username"] as! String)
    let picString = (user["photoString"] as! String)
    let currUserRef = getFirebase("users/" + username)
    currUserRef.observeEventType(.Value, withBlock: { snapshot in
        requester["Username"] = snapshot.value.objectForKey("requesterUsername") as? String
        if requester["Username"] != "" {
            requester["photoString"] = snapshot.value.objectForKey("requesterPhoto") as? String
            requester["course"] = snapshot.value.objectForKey("requesterCourse") as? String
            requester["description"] = snapshot.value.objectForKey("requesterDescription") as? String
            
            let imageData = NSData(base64EncodedString: requester["photoString"]!, options: NSDataBase64DecodingOptions(rawValue: 0))
            
            var decodedImage = UIImage(data: imageData!)
            
            if decodedImage == nil {
                decodedImage = defaultImage()
            }
            
            let requesterUserRef = getFirebase("users/" + requester["Username"]!)
        
            alertWithPic(view, description: "\n\n\n" + requester["Username"]! + " is requesting tutoring on:\n" + requester["course"]! + "\n" + requester["description"]!, action:
                UIAlertAction(title: "OK, I will Help", style: UIAlertActionStyle.Default) {result in
                    requesterUserRef.updateChildValues(["pairedUsername": username])
                    requesterUserRef.updateChildValues(["pairedPhoto": picString])
                    currUserRef.updateChildValues(["tutorWaiting": true])
                    
                    let mainViewController = view as! HomeViewController
                    
                    mainViewController.requestTutoringButton.hidden = true
                    mainViewController.requesterUsername.text = "Waiting for \(requester["Username"]!) to Start the Session"
                    mainViewController.requesterCourse.text = requester["course"]
                    mainViewController.requesterPhoto.image = decodedImage
                    //mainViewController.requesterPhoto.layer.cornerRadius = mainViewController.requesterPhoto.frame.size.width / 2
                    
                    mainViewController.tutorStudentSwitch.hidden = true
                    mainViewController.logout.enabled = false
                    mainViewController.tutorWaiting.hidden = false
                    
                }, pic: decodedImage!)
            return
        } else {
            if let _ = view.presentedViewController! {
                view.presentedViewController?!.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    })
    currUserRef.updateChildValues(["requesterUsername": ""])
    currUserRef.updateChildValues(["requesterPhoto": ""])
    currUserRef.updateChildValues(["requesterCourse": ""])
    currUserRef.updateChildValues(["requesterDescription": ""])
}

func pairedLisener(view: AnyObject, askedCourse: String) {
    let username = (user["username"] as! String)
    let currUserRef = getFirebase("users/" + username)
    currUserRef.observeEventType(.Value, withBlock: { snapshot in
        let pairedUsername = snapshot.value.objectForKey("pairedUsername") as? String
        if pairedUsername != "" {
            let pairedPhoto = snapshot.value.objectForKey("pairedPhoto") as? String
            
            let imageData = NSData(base64EncodedString: pairedPhoto!, options: NSDataBase64DecodingOptions(rawValue: 0))
            
            var decodedImage = UIImage(data: imageData!)
            
            if decodedImage == nil {
                decodedImage = defaultImage()
            }
            
            let imageView = UIImageView(frame: CGRectMake(50, 15, 60, 60))
            imageView.image = decodedImage! as UIImage
            
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
            
            for key in usersPerCourse.keys {
                if key != username && key != pairedUsername {
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterUsername": ""])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterPhoto": ""])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterCourse": ""])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterDescription": ""])
                }
            }
        }
    })
}

func logOutUser () {
    /*let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([ .Hour, .Minute, .Second], fromDate: date)
    print (components)
    user["lastLogin"] = components*/
    rootRef.unauth()
}

func defaultImage() -> UIImage {
    let size = CGSize(width: 60, height: 60)
    let rect = CGRectMake(0, 0, size.width, size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.whiteColor().setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}