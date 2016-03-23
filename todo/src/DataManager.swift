//
//  AppSettings.swift
//  todo
//
//  Created by Quyen Castellanos on 3/7/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase

let concurrentDataAccessQueue = dispatch_queue_create("com.CS378.todo.dataAccessQueue", DISPATCH_QUEUE_CONCURRENT)
 
// Firebase Refs
let firebaseURL:String = "https://scorching-heat-4336.firebaseio.com"
let rootRef = getFirebase("")
let usersRef = getFirebase("users")
let appSettingsRef = getFirebase("applicationSettings")
let allCoursesRef = getFirebase("allCourses")
let coursesRef = getFirebase("courses")

let registrationFields:[(String, String)] = [("First Name", "John"), ("Last Name", "Appleseed"),  ("Email Address", "jappleseed@gmail.com"), ("Username", "abc123"), ("Password", "password"), ("Major", "Computer Science") , ("Graduation Year", "2016")]
// TODO: We will want this in the database
let lowerDivisionCourses:[String] = ["CS312: Introduction to Programming", "CS314: Data Structures", "CS314H: Data Structures Honors", "CS302: Computer Fluency", "CS105: Computer Programming", "CS311: Discrete Math for Computer Science", "CS311H: Discrete Math for Computer Science: Honors", "CS109: Topics in Computer Science", "CS313E: Elements of Software Design"]

let upperDivisionCourses:[String] = [String]()

var allCourses = Dictionary<String, String>()

var user = Dictionary<String, AnyObject>()

var courses = Dictionary<String, String>()

var notifications = Dictionary<String, String>()

var history = Dictionary<String, String>()

var usersPerCourse = Dictionary<String, String>()

var requester = Dictionary<String, String>()

var paired = Dictionary<String, String>()

let sema: dispatch_semaphore_t = dispatch_semaphore_create(0)

func getFirebase(loc: String) -> Firebase! {
    let location = (loc == "" ? firebaseURL : firebaseURL + "/" + loc)
    return Firebase(url:location)
}

func loadAllCourses () {
    if allCourses.isEmpty {
        allCoursesRef.observeEventType(.Value, withBlock: { snapshot in
            allCourses = snapshot.value as! Dictionary<String, String>
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
}

func updateCourses (courses:[String]) {
    let username = user["Username"] as! String!
    for course in courses {
        let courseArr = course.characters.split{$0 == ":"}.map(String.init)
        let courseNumber = courseArr[0]
        let item = [username: username]
        let currCourseRef = getFirebase("courses/\(courseNumber)")
        let userCourseRef = currCourseRef.childByAppendingPath(username)
        userCourseRef.setValue(username)
    }
}

func alert (view: AnyObject, description: String, action: UIAlertAction?) {
    let alertController = UIAlertController(title: nil, message: description, preferredStyle: UIAlertControllerStyle.Alert)
    let OKAction = action
    alertController.addAction(OKAction!)
    view.presentViewController(alertController, animated: true, completion:nil)
}

func alertWithPic (view: AnyObject, description: String, action: UIAlertAction, pic: UIImage) {
    let alertController = AlertController(title: nil, message: description, preferredStyle: UIAlertControllerStyle.Alert)
    
    let OKAction = action
    
    let imageView = UIImageView(frame: CGRectMake((alertController.view.bounds.width)/3 - 30, 15, 60, 60))
    imageView.image = pic as UIImage
    
    imageView.layer.cornerRadius = imageView.frame.size.width / 2
    
    alertController.view.addSubview(imageView)
    alertController.addAction(OKAction)
    alertController.show()
}

func removeObservers(handle: Firebase) {
    handle.removeAllObservers()
}

func createUser(view: AnyObject, inputs: [String: String], courses: [String], segueIdentifier: String) {
    dispatch_barrier_async(concurrentDataAccessQueue) {
        rootRef.createUser(inputs["Email Address"], password: inputs["Password"], withValueCompletionBlock: {
            error, result in
            if error == nil {
                // Insert the user data
                let newUserRef = usersRef.childByAppendingPath(inputs["Username"])
                user = inputs
                user["dots"] = 100
                user["earned"] = 100
                user["paid"] = 0
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
                updateCourses(courses)
                print("Successfully created user account with username: \(inputs["Username"]!)")
                alert(view, description: "Congrats! You are ready to start using todo.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    result in
                    view.performSegueWithIdentifier(segueIdentifier, sender: nil)
                    })
                return
            }
            alert(view, description: "An error has occurred. There may be an existing account for the provided email address.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            })
    }
}

func loginUser(view: AnyObject, username: String, password:String, segueIdentifier: String) {
    dispatch_barrier_sync(concurrentDataAccessQueue) {
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
                        user["paid"] = (snapshot.value["paid"] as? Int)!
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
                        removeObservers(currUserRef)
                        dispatch_semaphore_signal(sema)
                    }
                } else {
                    print("Unable to login. Invalid username.")
                    alert(view, description: "Unable to login.\nInvalid username.", action: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                }
        })
    }
}

func sendRequest (view: AnyObject, askedCourse: String, location:String,  description: String, segueIdentifier: String) {
    dispatch_barrier_async(concurrentDataAccessQueue) {
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
}

func requestListener(view: AnyObject) {
    dispatch_barrier_sync(concurrentDataAccessQueue) {
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
        let mainViewController = view as? HomeViewController
        let username = (user["username"] as! String)
        let picString = (user["photoString"] as! String)
        let currUserRef = getFirebase("users/" + username)
        let group: dispatch_group_t = dispatch_group_create();
        let sema1: dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        currUserRef.observeEventType(.ChildChanged, withBlock: { snapshot in
            let k = snapshot.key as String
            let v = snapshot.value as! String
            if k.rangeOfString("requester") != nil && v != "" {
                dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                    currUserRef.observeEventType(.Value, withBlock: { snapshot in
                        requester["username"] = snapshot.value.objectForKey("requesterUsername") as? String
                        requester["photoString"] = snapshot.value.objectForKey("requesterPhoto") as? String
                        requester["course"] = snapshot.value.objectForKey("requesterCourse") as? String
                        requester["description"] = snapshot.value.objectForKey("requesterDescription") as? String
                        requester["location"] = snapshot.value.objectForKey("requesterLocation") as? String
                        dispatch_semaphore_signal(sema1)
                    })
                })
                
                dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
                    dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER)
                    let decodedImage = decodeImage(requester["photoString"]!)
            
                    let requesterUserRef = getFirebase("users/" + requester["username"]!)
                    var notificationUserRef = getFirebase("notifications/" + requester["username"]!)
                    var notice = requester["username"]! + " is requesting tutoring on:\n" + requester["course"]! + "\n" + requester["description"]! + "\nLocation: " + requester["location"]!
            
                    let date = getDateTime()
                    notificationUserRef.setValue([date: notice])
                    notifications[date] = notice
                    alertWithPic(view, description: "\n\n\n" + notice, action:
                    UIAlertAction(title: "OK, I will Help", style: UIAlertActionStyle.Default) {result in
                        requesterUserRef.updateChildValues(["pairedUsername": username])
                        requesterUserRef.updateChildValues(["pairedPhoto": picString])
                        
                        notificationUserRef = getFirebase("notifications/" + username)
                        notice = "You accepted to help " + requester["username"]! + " on " + requester["course"]!
                    
                        let date = getDateTime()
                        notificationUserRef.setValue([date: notice])
                        notifications[date] = notice
                        
                        mainViewController?.tutorContainerView.hidden = false
                        mainViewController?.requestTutoringButton.hidden = true
                        mainViewController!.tutorStudentSwitch.hidden = true
                        mainViewController!.logout.enabled = false
                    
                    }, pic: decodedImage)
            
                    requesterUserRef.observeEventType(.ChildChanged, withBlock: { snapshot in
                        let k_ = snapshot.key as String
                        if k_.rangeOfString("start") != nil {
                            requesterUserRef.observeEventType(.Value, withBlock: { snapshot in
                                requester["start"] = snapshot.value.objectForKey("start") as? String
                                mainViewController?.tutorContainerView.hidden = true
                                mainViewController?.tutorSessionContainerView.hidden = false
                                return
                            })
                        }
                        if k_.rangeOfString("cancel") != nil {
                            requesterUserRef.observeEventType(.Value, withBlock: { snapshot in
                                requester["cancel"] = snapshot.value.objectForKey("cancel") as? String
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
                                
                                mainViewController!.startHomeViewController()
                            })
                        }
                    })
                return
                })
            } else {
                if let _ = mainViewController!.presentedViewController {
                    view.presentedViewController?!.dismissViewControllerAnimated(false, completion: nil)
                }
            }
        })
    }
}

func pairedListener(view: AnyObject, askedCourse: String) {
    dispatch_barrier_sync(concurrentDataAccessQueue) {
        let mainViewController = view as? HomeViewController
        let username = (user["username"] as! String)
        let currUserRef = getFirebase("users/" + username)
        let askedCourse = askedCourse.componentsSeparatedByString(":")[0]
        currUserRef.observeEventType(.Value, withBlock: { snapshot in
            paired["username"] = snapshot.value.objectForKey("pairedUsername") as? String
            if paired["username"] != "" && (snapshot.value.objectForKey("start") as? String) == "" {
                paired["photoString"] = snapshot.value.objectForKey("pairedPhoto") as? String
                paired["course"] = askedCourse
            
                for key in usersPerCourse.keys {
                    if key != username {
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterPhoto": ""])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterCourse": ""])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterDescription": ""])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterLocation": ""])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterUsername": ""])
                    }
                }
                
                mainViewController!.blurEffect.hidden = true
                
                mainViewController?.requestTutoringButton.hidden = true
                
                mainViewController!.requesterContainerView.hidden = false
            
                let notificationUserRef = getFirebase("notifications/" + username)
                let notice = paired["username"]! + " is coming to help you on: " + askedCourse
            
                notificationUserRef.setValue([getDateTime(): notice])
            
                mainViewController!.tutorStudentSwitch.hidden = true
                mainViewController!.logout.enabled = false
            
            }
        })
    }
}

func startSession (view: AnyObject) {
    dispatch_barrier_sync(concurrentDataAccessQueue) {
        let currUserRef = getFirebase("users/" + (user["username"]! as! String))
        let pairedUserRef = getFirebase("users/" + (paired["username"]! ))
        currUserRef.updateChildValues(["start": "yes"])
        user["start"] = "yes"
    
        pairedUserRef.observeEventType(.Value, withBlock: { snapshot in
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
            
            }
        })
    }
}

func cancelSession() {
    dispatch_barrier_sync(concurrentDataAccessQueue) {
        let username = (user["username"] as! String)
        let currUserRef = getFirebase("users/" + username)
        currUserRef.updateChildValues(["pairedPhoto": ""])
        currUserRef.updateChildValues(["pairedCourse": ""])
        currUserRef.updateChildValues(["cancel": "yes"])
        currUserRef.updateChildValues(["pairedUsername": ""])
        paired["photoString"] = ""
        paired["username"] = ""
        paired["course"] = ""
    }
}

func finishSession() {
    dispatch_barrier_sync(concurrentDataAccessQueue) {
        let username = (user["username"] as! String)
        let currUserRef = getFirebase("users/" + username)
        currUserRef.updateChildValues(["finish": "yes"])
        currUserRef.updateChildValues(["start": ""])
    
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
    }
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
    
    if stringPhoto == "" {
        return defaultImage()
    }
    
    let imageData = NSData(base64EncodedString: stringPhoto, options: NSDataBase64DecodingOptions(rawValue: 0))
    
    let decodedImage = UIImage(data: imageData!)
    
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
