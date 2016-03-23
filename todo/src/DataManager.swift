//
//  AppSettings.swift
//  todo
//
//  Created by Quyen Castellanos on 3/7/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase

var mainViewController:HomeViewController? = nil
 
// Firebase Refs
let firebaseURL:String = "https://scorching-heat-4336.firebaseio.com"
let rootRef = getFirebase("")
let usersRef = getFirebase("users")
let allCoursesRef = getFirebase("allCourses")
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

var paired = Dictionary<String, String>()

func getFirebase(loc: String) -> Firebase! {
    let location = (loc == "" ? firebaseURL : firebaseURL + "/" + loc)
    return Firebase(url:location)
}

func loadAllCourses () {
    if allCourses.isEmpty {
        
    }
}

func alert (view: AnyObject, description: String, action: UIAlertAction?) {
    let alertController = UIAlertController(title: nil, message: description, preferredStyle: UIAlertControllerStyle.Alert)
    let OKAction = action
    alertController.addAction(OKAction!)
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
            user["requesterLocation"] = ""
            user["pairedUsername"] = ""
            user["pairedPhoto"] = ""
            user["start"] = ""
            user["finish"] = ""
            user["lastLogin"] = ""
            user["location"] = ""
            user["cancel"] = ""
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
                    user["requesterLocation"] = ""
                    user["pairedUsername"] = ""
                    user["pairedPhoto"] = ""
                    user["start"] = ""
                    user["finish"] = ""
                    user["location"] = ""
                    user["cancel"] = ""
                    
                    view.performSegueWithIdentifier(segueIdentifier, sender: nil)
                }
            } else {
                print("Unable to login. Invalid username.")
                alert(view, description: "Unable to login.\nInvalid username.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            }
    })
}

func sendRequest (view: AnyObject, askedCourse: String, location:String,  description: String, segueIdentifier: String) {
    let coursesRef = getFirebase("courses/")
    let askedCourse = askedCourse.componentsSeparatedByString(":")[0]
    coursesRef.observeEventType(.Value, withBlock: { snapshot in
        if let _ = snapshot.value[askedCourse] as? Dictionary<String, String> {
            usersPerCourse = snapshot.value[askedCourse] as! Dictionary<String, String>
            for key in usersPerCourse.keys {
                if key != user["username"] as! String {
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterPhoto": user["photoString"]!])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterCourse": askedCourse])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterDescription": description])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterLocation": location])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterUsername": user["username"]!])
                }
            }
            view.performSegueWithIdentifier(segueIdentifier, sender: nil)
            let notificationUserRef = getFirebase("notifications/" + (user["username"]! as! String))
            let notice = "You asked for help on " + askedCourse
            notificationUserRef.setValue([getDateTime(): notice])
            return
        }
        alert(view, description: "This course does not exist on our Database.\nPlease enter a valid UT course.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    })
}

func requestListener(view: AnyObject) {
    mainViewController = view as? HomeViewController
    let username = (user["username"] as! String)
    let picString = (user["photoString"] as! String)
    let currUserRef = getFirebase("users/" + username)
    currUserRef.observeEventType(.Value, withBlock: { snapshot in
        requester["username"] = snapshot.value.objectForKey("requesterUsername") as? String
        if requester["username"] != "" && snapshot.value.objectForKey("start") as? String == "" {
            requester["photoString"] = snapshot.value.objectForKey("requesterPhoto") as? String
            requester["course"] = snapshot.value.objectForKey("requesterCourse") as? String
            requester["description"] = snapshot.value.objectForKey("requesterDescription") as? String
            requester["location"] = snapshot.value.objectForKey("requesterLocation") as? String
            
            let decodedImage = decodeImage(requester["photoString"]!)
            
            let requesterUserRef = getFirebase("users/" + requester["username"]!)
            var notificationUserRef = getFirebase("notifications/" + requester["username"]!)
            var notice = requester["username"]! + " is requesting tutoring on:\n" + requester["course"]! + "\n" + requester["description"]! + "\nLocation: " + requester["location"]!
            
            notificationUserRef.setValue([getDateTime(): notice])
            alertWithPic(view, description: "\n\n\n" + notice, action:
                UIAlertAction(title: "OK, I will Help", style: UIAlertActionStyle.Default) {result in
                    requesterUserRef.updateChildValues(["pairedUsername": username])
                    requesterUserRef.updateChildValues(["pairedPhoto": picString])
                    
                    mainViewController!.requestTutoringButton.hidden = true
                    mainViewController!.requesterUsername.text = "Waiting for " + requester["username"]! + " to Start the Session"
                    mainViewController!.requesterCourse.text = requester["course"]
                    mainViewController!.requesterPhoto.image = decodedImage
                        //mainViewController.requesterPhoto.layer.cornerRadius = mainViewController.requesterPhoto.frame.size.width / 2
                    
                    mainViewController!.tutorStudentSwitch.hidden = true
                    mainViewController!.logout.enabled = false
                    mainViewController!.tutorWaiting.hidden = false
                    
                    notificationUserRef = getFirebase("notifications/" + username)
                    notice = "You accepted to help " + requester["username"]! + " on " + requester["course"]!
                    
                    notificationUserRef.setValue([getDateTime(): notice])
                    
                }, pic: decodedImage)
            
            requesterUserRef.observeEventType(.Value, withBlock: { snapshot in
                requester["start"] = snapshot.value.objectForKey("start") as? String
                if requester["start"] != "" {
                    mainViewController!.tutorWaiting.hidden = true
                    mainViewController!.tutorTutoringSession.hidden = false
                
                    mainViewController!.tutorTutoringSessionPhoto.image = decodedImage
                
                    mainViewController!.tutorTutoringSessionUsername.text = "Tutoring Session with " + requester["username"]!
                
                    mainViewController!.tutorTutoringSessionCourse.text = requester["course"]!
                
                    var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: mainViewController!, selector: Selector("timeCounter"), userInfo: nil, repeats: true)
                
                    var dots = NSTimer.scheduledTimerWithTimeInterval(1.0, target: mainViewController!, selector: Selector("dotsCounter"), userInfo: nil, repeats: true)
                } else {
                    mainViewController!.tutorTutoringSession.hidden = true
                }
                requester["cancel"] = snapshot.value.objectForKey("cancel") as? String
                if requester["cancel"] != "" {
                    let pairedUserRef = getFirebase("users/" + requester["username"]!)
                    pairedUserRef.updateChildValues(["cancel": ""])
                    pairedUserRef.updateChildValues(["start": ""])
                    
                    let username = (user["username"] as! String)
                    let currUserRef = getFirebase("users/" + username)
                    currUserRef.updateChildValues(["requesterPhoto": ""])
                    currUserRef.updateChildValues(["requesterCourse": ""])
                    currUserRef.updateChildValues(["requesterDescription": ""])
                    currUserRef.updateChildValues(["requesterLocation": ""])
                    currUserRef.updateChildValues(["requesterUsername": ""])
                    requester["photoString"] = ""
                    requester["course"] = ""
                    requester["description"] = ""
                    requester["location"] = ""
                    requester["username"] = ""
                    requester["start"] = ""
                    
                    mainViewController = view as? HomeViewController
                    mainViewController!.tutorTutoringSession.hidden = true
                    mainViewController!.requestTutoringButton.hidden = false
                    mainViewController!.tutorStudentSwitch.hidden = false
                    mainViewController!.logout.enabled = true
                }
            })
            return
        } else {
            if let _ = view.presentedViewController! {
                view.presentedViewController?!.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    })
    currUserRef.updateChildValues(["requesterPhoto": ""])
    currUserRef.updateChildValues(["requesterCourse": ""])
    currUserRef.updateChildValues(["requesterDescription": ""])
    currUserRef.updateChildValues(["requesterLocation": ""])
    currUserRef.updateChildValues(["requesterUsername": ""])
}

func pairedListener(view: AnyObject, askedCourse: String) {
    mainViewController = view as? HomeViewController
    let username = (user["username"] as! String)
    let currUserRef = getFirebase("users/" + username)
    let askedCourse = askedCourse.componentsSeparatedByString(":")[0]
    currUserRef.observeEventType(.Value, withBlock: { snapshot in
        paired["username"] = snapshot.value.objectForKey("pairedUsername") as? String
        if paired["username"] != "" && (snapshot.value.objectForKey("start") as? String) == "" {
            paired["photoString"] = snapshot.value.objectForKey("pairedPhoto") as? String
            paired["course"] = askedCourse
            
            let decodedImage = decodeImage(paired["photoString"]!)
            
            for key in usersPerCourse.keys {
                if key != username {
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterPhoto": ""])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterCourse": ""])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterDescription": ""])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterLocation": ""])
                    usersRef.childByAppendingPath(key).updateChildValues(["requesterUsername": ""])
                }
            }
            
            mainViewController!.lookingTutorsNoticeView.hidden = true
            mainViewController!.blurEffect.hidden = true
            
            mainViewController!.requestTutoringButton.hidden = true
            mainViewController!.tutorUsername.text = paired["username"]! + " is coming to help you on:"
            
            let notificationUserRef = getFirebase("notifications/" + username)
            let notice = paired["username"]! + " is coming to help you on: " + askedCourse
            
            notificationUserRef.setValue([getDateTime(): notice])
            
            mainViewController!.tutorCourse.text = askedCourse
            mainViewController!.tutorPhoto.image = decodedImage
            //mainViewController.requesterPhoto.layer.cornerRadius = mainViewController.requesterPhoto.frame.size.width / 2
            
            mainViewController!.tutorStudentSwitch.hidden = true
            mainViewController!.logout.enabled = false
            mainViewController!.requesterStartSession.hidden = false
            
        } else {
            mainViewController!.requesterStartSession.hidden = true
            if (snapshot.value.objectForKey("start") as? String) == "" {
                mainViewController!.requestTutoringButton.hidden = false
                mainViewController!.tutorStudentSwitch.hidden = false
                mainViewController!.logout.enabled = true
            }
        }
    })
}

func startSession (view: AnyObject) {
    let currUserRef = getFirebase("users/" + (user["username"]! as! String))
    currUserRef.updateChildValues(["start": "yes"])
    user["start"] = "yes"
    
    mainViewController = view as? HomeViewController
    
    mainViewController!.lookingTutorsNoticeView.hidden = true
    mainViewController!.blurEffect.hidden = true
    mainViewController!.requestTutoringButton.hidden = true
    mainViewController!.requesterStartSession.hidden = true
    mainViewController!.tutorStudentSwitch.hidden = true
    mainViewController!.logout.enabled = false
    mainViewController!.requesterTutoringSession.hidden = false
    
    let decodedImage = decodeImage(paired["photoString"]!)
    
    mainViewController!.requesterTutoringSessionTutorPhoto.image = decodedImage
    
    mainViewController!.requesterTutoringSessionTutorUsername.text = "Tutoring Session with " + paired["username"]!
    
    mainViewController!.requesterTutotringSessionCourse.text = paired["course"]!
    
    var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: mainViewController!, selector: Selector("timeCounter"), userInfo: nil, repeats: true)
    
    var dots = NSTimer.scheduledTimerWithTimeInterval(1.0, target: mainViewController!, selector: Selector("dotsCounter"), userInfo: nil, repeats: true)
    
    currUserRef.observeEventType(.Value, withBlock: { snapshot in
        user["finish"] = snapshot.value.objectForKey("finish") as? String
        if (user["finish"] as? String) != "" {
            currUserRef.updateChildValues(["pairedPhoto": ""])
            currUserRef.updateChildValues(["pairedCourse": ""])
            currUserRef.updateChildValues(["finish": ""])
            currUserRef.updateChildValues(["start": ""])
            currUserRef.updateChildValues(["pairedUsername": ""])
            paired["photoString"] = ""
            paired["username"] = ""
            paired["course"] = ""
            
            mainViewController = view as? HomeViewController
            mainViewController!.requesterTutoringSession.hidden = true
            mainViewController!.lookingTutorsNoticeView.hidden = true
            mainViewController!.blurEffect.hidden = true
            mainViewController!.requestTutoringButton.hidden = false
            mainViewController!.tutorStudentSwitch.hidden = false
            mainViewController!.logout.enabled = true
            mainViewController!.requesterTutoringSession.hidden = true
            mainViewController!.requesterStartSession.hidden = true
        }
    })
}

func cancelSession(view: AnyObject) {
    let username = (user["username"] as! String)
    let currUserRef = getFirebase("users/" + username)
    currUserRef.updateChildValues(["pairedPhoto": ""])
    currUserRef.updateChildValues(["pairedCourse": ""])
    currUserRef.updateChildValues(["cancel": "yes"])
    currUserRef.updateChildValues(["pairedUsername": ""])
    paired["photoString"] = ""
    paired["username"] = ""
    paired["course"] = ""
    
    mainViewController = view as? HomeViewController
    mainViewController!.lookingTutorsNoticeView.hidden = true
    mainViewController!.blurEffect.hidden = true
    mainViewController!.requestTutoringButton.hidden = false
    mainViewController!.requesterStartSession.hidden = true
    mainViewController!.tutorStudentSwitch.hidden = false
    mainViewController!.logout.enabled = true
    mainViewController!.requesterTutoringSession.hidden = true
}

func finishSession(view: AnyObject) {
    let pairedUserRef = getFirebase("users/" + requester["username"]!)
    pairedUserRef.updateChildValues(["pairedPhoto": ""])
    pairedUserRef.updateChildValues(["pairedCourse": ""])
    pairedUserRef.updateChildValues(["pairedUsername": ""])
    pairedUserRef.updateChildValues(["finish": "yes"])
    pairedUserRef.updateChildValues(["start": ""])
    paired["photoString"] = ""
    paired["username"] = ""
    paired["course"] = ""
    
    let username = (user["username"] as! String)
    let currUserRef = getFirebase("users/" + username)
    currUserRef.updateChildValues(["requesterPhoto": ""])
    currUserRef.updateChildValues(["requesterCourse": ""])
    currUserRef.updateChildValues(["requesterDescription": ""])
    currUserRef.updateChildValues(["requesterLocation": ""])
    currUserRef.updateChildValues(["requesterUsername": ""])
    requester["photoString"] = ""
    requester["course"] = ""
    requester["description"] = ""
    requester["location"] = ""
    requester["username"] = ""
    requester["start"] = ""
    
    mainViewController = view as? HomeViewController
    mainViewController!.tutorTutoringSession.hidden = true
    mainViewController!.requestTutoringButton.hidden = false
    mainViewController!.tutorStudentSwitch.hidden = false
    mainViewController!.logout.enabled = true
}

func logOutUser () {
    user["lastLogin"] = getDateTime()
    rootRef.unauth()
}

func getDateTime() -> String {
    let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    return timestamp
}

func decodeImage(stringPhoto: String) -> UIImage {
    let imageData = NSData(base64EncodedString: stringPhoto, options: NSDataBase64DecodingOptions(rawValue: 0))
    
    var decodedImage = UIImage(data: imageData!)
    
    if decodedImage == nil {
        decodedImage = defaultImage()
    }
    return decodedImage!
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