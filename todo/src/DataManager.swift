
import Foundation
import Firebase

let taskQueue = dispatch_queue_create("com.CS378.todo.dataAccessQueue", DISPATCH_QUEUE_CONCURRENT)

let sema = dispatch_semaphore_create(0)

let sema1 = dispatch_semaphore_create(0)

// Firebase Refs
let firebaseURL:String = "https://scorching-heat-4336.firebaseio.com"
let rootRef = getFirebase("")
let usersRef = getFirebase("users")
let appSettingsRef = getFirebase("applicationSettings")
let allCoursesRef = getFirebase("allCourses")
let coursesRef = getFirebase("courses")

var tempUserPhoto = UIImage(named:"DefaultProfilePhoto.png")

let registrationFields:[(String, String)] = [("First Name", "John"), ("Last Name", "Appleseed"),  ("Email Address", "jappleseed@gmail.com"), ("Username", "abc123"), ("Password", "password"), ("Major", "Computer Science") , ("Graduation Year", "2016")]

let upperDivisionCourses:[String] = [String]()

var courseDic = Dictionary<String, String>()

var allCourses = Dictionary<String, String>()

var user = Dictionary<String, AnyObject>()

var courses = Dictionary<String, String>()

var notifications = Dictionary<String, String>()

var history = Dictionary<String, String>()

var usersPerCourse = Dictionary<String, String>()

var requester = Dictionary<String, String>()

var paired = Dictionary<String, String>()

var alertPicController: AlertController?

var currCourse = ""

var passed = false

var timeCount = 0

var dotsTotal = 1

var settingsSwitch = -1

var notificationButtonsState = -1

var possiblePairedUsers = 0

var time_: TimerAndDotsCounter?

let burntOranges:[UIColor] = [UIColor.init(red: 186/255, green: 74/255, blue: 0, alpha: 1.0), UIColor.init(red: 214/255, green: 137/255, blue: 16/255, alpha: 1.0), UIColor.init(red: 175/255, green: 96/255, blue: 26/255, alpha: 1.0), UIColor.init(red: 185/255, green: 119/255, blue: 14/255, alpha: 1.0), UIColor.init(red: 110/255, green: 44/255, blue: 0, alpha: 1.0), UIColor.init(red: 120/255, green: 66/255, blue: 18/255, alpha: 1.0)]

func getFirebase(loc: String) -> Firebase! {
    let location = (loc == "" ? firebaseURL : firebaseURL + "/" + loc)
    return Firebase(url:location)
}

func loadAllCourses () {
    dispatch_barrier_async(taskQueue) {
        if allCourses.isEmpty {
            allCoursesRef.observeEventType(.Value, withBlock: { snapshot in
                allCourses = snapshot.value as! Dictionary<String, String>
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
    }
}

func updateCourses (courses:[String]) {
    let username = user["Username"] as! String!
    for course in courses {
        let courseArr = course.characters.split{$0 == ":"}.map(String.init)
        let courseNumber = courseArr[0]
        //let item = [username: username]
        let currCourseRef = getFirebase("courses/\(courseNumber)")
        let userCourseRef = currCourseRef.childByAppendingPath(username)
        userCourseRef.setValue(username)
    }
}

func alert (view: AnyObject, description: String, okAction: UIAlertAction?) {
    let alertController = UIAlertController(title: nil, message: description, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(okAction!)
    view.presentViewController(alertController, animated: true, completion:nil)
}

func alertWithPic (view: AnyObject, description: String, okAction: UIAlertAction, cancelAction: UIAlertAction, otherAction: UIAlertAction, pic: UIImage) {
    alertPicController = AlertController(title: nil, message: description, preferredStyle: UIAlertControllerStyle.Alert)
    
    let imageView = UIImageView(frame: CGRectMake((alertPicController!.view.bounds.width)/3 - 30, 15, 60, 60))
    imageView.image = pic as UIImage
    
    imageView.layer.cornerRadius = imageView.frame.size.width / 2
    
    alertPicController!.view.addSubview(imageView)
    alertPicController!.addAction(okAction)
    alertPicController!.addAction(otherAction)
    alertPicController!.addAction(cancelAction)
    
    if !passed {
        alertPicController!.show()
        passed = true
    }
}

/*  Remove all history record in Firebase  */
func clearHistory(){
    let historyUserRef = getFirebase("history/" + (user["username"]! as! String))
    historyUserRef.removeValue()
    history.removeAll()
}

/*  Remove all notification record in Firebase  */
func clearNotification(){
    let notificationUserRef = getFirebase("notifications/" + (user["username"]! as! String))
    notificationUserRef.removeValue()
    notifications.removeAll()
}

func removeObservers(handle: Firebase) {
    handle.removeAllObservers()
}

func createUser(view: AnyObject, inputs: [String: String], courses: [String], segueIdentifier: String) {
    dispatch_barrier_async(taskQueue) {
        let currUserRef = getFirebase("users/" + inputs["Username"]!)
        currUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value["Email Address"] as? String != nil {
                alert(view, description: "An error has occurred. There may be an existing account for the provided username.", okAction: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            } else {
                rootRef.createUser(inputs["Email Address"], password: inputs["Password"], withValueCompletionBlock: {
                    error, result in
                    if error == nil {
                        // Insert the user data
                        let newUserRef = usersRef.childByAppendingPath(inputs["Username"])
                        user = inputs
                        user["dots"] = 100
                        user["earned"] = 100
                        user["paid"] = 0
                        
                        if courses.count > 0 {
                            for i in 0...courses.count - 1 {
                                courseDic[courses[i].componentsSeparatedByString(":")[0]] = courses[i].componentsSeparatedByString(":")[1]
                            }
                        } else {
                            courseDic["dummy"] = ""
                        }
                        
                        user["courses"] = courseDic
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
                        user["possiblePairedUsers"] = 0
                        newUserRef.setValue(user)
                        let notice = "created: You have joined todo!"
                        let date = getDateTime()
                        notifications[date] = notice
                        getFirebase("notifications/").updateChildValues([inputs["Username"]!: [date: notice]])
                        getFirebase("history/").updateChildValues([inputs["Username"]!: [date: notice]])
                        updateCourses(courses)
                        print("Successfully created user account with username: \(inputs["Username"]!)")
                        alert(view, description: "Congrats! You are ready to start using todo.", okAction: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                            result in
                            view.performSegueWithIdentifier(segueIdentifier, sender: nil)
                            })
                        removeObservers(currUserRef)
                        return
                    }
                    
                    alert(view, description: "An error has occurred. There may be an existing account for the provided email address.", okAction: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                })
            }
        })
    }
}

func modifyEmail(view: AnyObject, originalEmail: String, modifiedEmail: String, password:String){
    rootRef.changeEmailForUser(originalEmail, password: password, toNewEmail: modifiedEmail, withCompletionBlock: { error in
        if error != nil {
            print("There is a problem when changed email")
            print(error)
            // There was an error processing the request
        } else {
            user["email"] = modifiedEmail
            let username = (user["username"] as! String)
            let currUserRef = getFirebase("users/" + username)
            currUserRef.updateChildValues(["Email Address": modifiedEmail])
            print("Email changed successfully")
            
            /** TODO: Display Alert View **/
            /** TODO: Also change email field in the userRef **/
        }
    })
}

func modifyPassword(view: AnyObject, oldPassword:String, newPassword:String, userEmail: String){
    rootRef.changePasswordForUser(userEmail, fromOld: oldPassword, toNew: newPassword, withCompletionBlock: { error in
        if error != nil {
            print("There is a problem when changed password")
            print(error)
            // There was an error processing the request
        } else {
            user["password"] = newPassword
            let username = (user["username"] as! String)
            let currUserRef = getFirebase("users/" + username)
            currUserRef.updateChildValues(["Password": newPassword])
            print("Password changed successfully")
            
            /** TODO: Display Alert View **/
            /** TODO: Also change password field in the userRef **/
        }
    })
}

func loginUser(view: AnyObject, username: String, password:String, segueIdentifier: String) {
    dispatch_barrier_async(taskQueue) {
        let currUserRef = getFirebase("users/" + username)
        user = [:]

        currUserRef.observeEventType(.Value, withBlock: { snapshot in
            if let email = snapshot.value["Email Address"] as? String {
                print("email = \(email)")
                
                // Attempt to log the user in
                rootRef.authUser(email, password: password) {
                    error, authData in
                    if error != nil {
                        print("Unable to login.\nInvalid password.")
                        alert(view, description: "Unable to login. Invalid password.", okAction: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
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
                    print("dots are: " + String((user["dots"]! as! Int)))
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
                    user["possiblePairedUsers"] = 0

                    requester["username"] = ""
                    requester["photoString"] = ""
                    requester["course"] = ""
                    requester["description"] = ""
                    requester["location"] = ""
                    
                    let notificationUserRef = getFirebase("notifications/" + (user["username"]! as! String))
                    notificationUserRef.observeEventType(.Value, withBlock: { snap in
                        if !(snap.value is NSNull) {
                            notifications = snap.value as! Dictionary
                        }
                        removeObservers(notificationUserRef)
                    })
                    
                    let historyUserRef = getFirebase("history/" + (user["username"]! as! String))
                    historyUserRef.observeEventType(.Value, withBlock: { snap in
                        if !(snap.value is NSNull) {
                            history = snap.value as! Dictionary
                        }
                        removeObservers(historyUserRef)
                    })
                    
                    currUserRef.updateChildValues(["pairedCourse": ""])
                    currUserRef.updateChildValues(["pairedPhoto": ""])
                    currUserRef.updateChildValues(["pairedUsername": ""])
                    currUserRef.updateChildValues(["requesterCourse": ""])
                    currUserRef.updateChildValues(["requesterDescription": ""])
                    currUserRef.updateChildValues(["requesterLocation": ""])
                    currUserRef.updateChildValues(["requesterPhoto": ""])
                    currUserRef.updateChildValues(["requesterUsername": ""])
                    currUserRef.updateChildValues(["start": ""])
                    currUserRef.updateChildValues(["cancel": ""])
                    currUserRef.updateChildValues(["finish": ""])
                    currUserRef.updateChildValues(["location": ""])
                    currUserRef.updateChildValues(["possiblePairedUsers": 0])
                    
                    view.performSegueWithIdentifier(segueIdentifier, sender: nil)
                    
                    removeObservers(currUserRef)
                    dispatch_semaphore_signal(sema)
                }
            } else {
                print("Unable to login. Invalid username.")
                alert(view, description: "Unable to login.\nInvalid username.", okAction: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            }
        })
    }
}

func sendRequest (view: AnyObject, askedCourse: String, location:String,  description: String, segueIdentifier: String) {
    let dots = (user["dots"]! as! Int)
    if dotsTotal > dots {
        alert(view, description: "You do not have enough dots to make the request", okAction: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        view.performSegueWithIdentifier(segueIdentifier, sender: nil)
        return
    }
    dispatch_barrier_async(taskQueue) {
        let coursesRef = getFirebase("courses/")
        let askedCourse = askedCourse.componentsSeparatedByString(":")[0]
        let username = (user["username"] as! String)
        let currUserRef = getFirebase("users/" + username)
        possiblePairedUsers = 0
        currCourse = askedCourse
        coursesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let _ = snapshot.value[askedCourse] as? Dictionary<String, String> {
                usersPerCourse = snapshot.value[askedCourse] as! Dictionary<String, String>
                for key in usersPerCourse.keys {
                    if key != user["username"] as! String {
                        possiblePairedUsers = possiblePairedUsers + 1
                        currUserRef.updateChildValues(["possiblePairedUsers": possiblePairedUsers])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterPhoto": user["photoString"]!])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterCourse": askedCourse])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterDescription": description])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterLocation": location])
                        usersRef.childByAppendingPath(key).updateChildValues(["requesterUsername": user["username"]!])
                    }
                }
                
                view.performSegueWithIdentifier(segueIdentifier, sender: nil)
                
                let notificationUserRef = getFirebase("notifications/" + (user["username"]! as! String))
                let notice = "request: You requested tutoring help in " + askedCourse + "."
                let date = getDateTime()
                notificationUserRef.updateChildValues([date: notice])
                notifications[date] = notice
                return
            }
            alert(view, description: "Tere is not existing tutor for this course.\nPlease enter other UT course.", okAction: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        })
    }
}

var reqUserRef: Firebase?
var notUserRef: Firebase?
var cUserRef: Firebase?
var mViewControler: HomeViewController?
var decImage: UIImage?

func tutorAccept () {
    reqUserRef!.updateChildValues(["pairedUsername": (user["username"] as! String)])
    reqUserRef!.updateChildValues(["pairedPhoto": (user["photoString"] as! String)])
    
    if requester["username"] != nil {
        let notice = "acceptance: You accepted " + requester["username"]! + "’s tutoring request for " + requester["course"]! + "."
        let date = getDateTime()
        notUserRef!.updateChildValues([date: notice])
        notifications[date] = notice
    
        mViewControler?.tutorContainerView.hidden = false
        mViewControler?.requestTutoringButton.hidden = true
        mViewControler!.tutorStudentSwitch.hidden = true
        mViewControler!.tutorStudentSwiftLabel.hidden = true
        mViewControler!.logout.enabled = false
    
        mViewControler?.tutorWaitingViewController!.requesterUsername.text = "Waiting for " + requester["username"]! + " to Start the Session"
    
        mViewControler?.tutorWaitingViewController!.requesterCourse.text = requester["course"]!
    
        mViewControler?.tutorWaitingViewController!.requesterPhoto.image = decImage
    
        mViewControler?.tutorSessionViewController!.tutorTutoringSessionUsername.text = "Tutoring Session with " + requester["username"]!
    
        mViewControler?.tutorSessionViewController!.tutorTutoringSessionCourse.text = requester["course"]!
    
        mViewControler?.tutorSessionViewController!.tutorTutoringSessionPhoto.image = decImage
    }
}

func tutorReject () {
    reqUserRef!.observeSingleEventOfType(.Value, withBlock: { snapshot in
        possiblePairedUsers = (snapshot.value["possiblePairedUsers"] as! Int)
        possiblePairedUsers = possiblePairedUsers - 1
        reqUserRef!.updateChildValues(["possiblePairedUsers": possiblePairedUsers])
    })
    
    cUserRef!.updateChildValues(["requesterPhoto": ""])
    cUserRef!.updateChildValues(["requesterCourse": ""])
    cUserRef!.updateChildValues(["requesterDescription": ""])
    cUserRef!.updateChildValues(["requesterLocation": ""])
    cUserRef!.updateChildValues(["requesterUsername": ""])
    cUserRef!.updateChildValues(["cancel": "yes"])
    requester["photoString"] = ""
    requester["course"] = ""
    requester["description"] = ""
    requester["location"] = ""
    requester["username"] = ""
    requester["start"] = ""
    removeObservers(rootRef)
    mViewControler!.tutorStudentSwitch.hidden = false
    mViewControler!.tutorStudentSwiftLabel.hidden = false
    mViewControler!.logout.enabled = true
    mViewControler!.requestTutoringButton!.hidden = false
    mViewControler!.blurEffect.hidden = true
    mViewControler!.requesterContainerView.hidden = true
    mViewControler!.tutorContainerView.hidden = true
    mViewControler!.tutorSessionContainerView.hidden = true
    
    removeObservers(cUserRef!)
}


func requestListener(view: AnyObject) {
    dotsTotal = 0
    dispatch_barrier_sync(taskQueue) {
        mViewControler = view as? HomeViewController
        let username = (user["username"] as! String)
        cUserRef = getFirebase("users/" + username)
        
        cUserRef!.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value["requesterUsername"] as! String != "" {
                if requester["username"] == "" {
                    requester["username"] = (snapshot.value["requesterUsername"] as! String)
                }
                if requester["course"] == "" {
                    requester["course"] = (snapshot.value["requesterCourse"] as! String)
                    currCourse = requester["course"]!
                }
                if requester["photoString"] == "" {
                    requester["photoString"] = (snapshot.value["requesterPhoto"] as! String)
                }
                if requester["description"] == "" {
                    requester["description"] = (snapshot.value["requesterDescription"] as! String)
                }
                if requester["location"] == "" {
                    requester["location"] = (snapshot.value["requesterLocation"] as! String)
                }
                reqUserRef = getFirebase("users/" + requester["username"]!)
                dispatch_async(dispatch_get_main_queue(), {
                    decImage = decodePhoto(snapshot.value["requesterPhoto"] as! String)
                    notUserRef = getFirebase("notifications/" + username)
                    var notice = "singleRequest: " + ((snapshot.value["requesterUsername"] as! String) + " has requested tutoring in " + (snapshot.value["requesterCourse"] as! String) + "\n" + (snapshot.value["requesterDescription"] as! String) + "\nLocation: " + (snapshot.value["requesterLocation"] as! String))
                    let date = getDateTime()
                    notUserRef!.updateChildValues([date: notice])
                    notifications[date] = notice
                    notice = notice.componentsSeparatedByString(":")[1]
                    alertWithPic(view, description: "\n\n\n" + notice, okAction:
                        UIAlertAction(title: "OK, I will help", style: UIAlertActionStyle.Default) { result in
                            tutorAccept()
                        },
                        cancelAction: UIAlertAction(title: "Reject", style: UIAlertActionStyle.Destructive) { result in
                            tutorReject()
                        },
                        otherAction: UIAlertAction(title: "View in Notifications", style: UIAlertActionStyle.Default) { result in
                            mViewControler?.performSegueWithIdentifier("goToNotificationsSegue", sender: mViewControler)
                        },
                        pic: decImage!)
                })
                
                let startRequesterUserRef = getFirebase("users/" + (snapshot.value["requesterUsername"] as! String) + "/" + "start")
                startRequesterUserRef.observeEventType(.Value, withBlock: { snap in
                    if let v_ = snap.value as? String {
                        if v_ == "yes"{
                            
                            time_ = TimerAndDotsCounter(viewControler: mViewControler!.tutorSessionViewController!)

                            if !timer.valid {
                                time_!.startCounter()
                            }
                            
                            requester["start"] = "yes"
                            mViewControler!.tutorContainerView.hidden = true
                            mViewControler!.tutorSessionContainerView.hidden = false
                            timeCount = 0
                            passed = false
                            removeObservers(startRequesterUserRef)
                            removeObservers(cUserRef!)
                        }
                    }
                })
                
                let cancelRequesterUserRef = getFirebase("users/" + (snapshot.value["requesterUsername"] as! String) + "/" + "cancel")
                cancelRequesterUserRef.observeEventType(.Value, withBlock: { snap in
                    if let v_ = snap.value as? String {
                        if v_ == "yes" {
                            requester["cancel"] = ""
                            
                            let notificationUserRef = getFirebase("notifications/" + (user["username"]! as! String))
                            let notice = "cancelledSession: " + requester["username"]! + " cancelled a tutoring session."
                            let date = getDateTime()
                            notificationUserRef.updateChildValues([date: notice])
                            notifications[date] = notice
                            
                            cUserRef!.updateChildValues(["requesterPhoto": ""])
                            cUserRef!.updateChildValues(["requesterCourse": ""])
                            cUserRef!.updateChildValues(["requesterDescription": ""])
                            cUserRef!.updateChildValues(["requesterLocation": ""])
                            cUserRef!.updateChildValues(["requesterUsername": ""])
                            reqUserRef!.updateChildValues(["cancel": ""])
                            requester["photoString"] = ""
                            requester["course"] = ""
                            requester["description"] = ""
                            requester["location"] = ""
                            requester["username"] = ""
                            requester["start"] = ""
                            removeObservers(rootRef)
                            mViewControler!.tutorStudentSwitch.hidden = false
                            mViewControler!.logout.enabled = true
                            mViewControler!.requestTutoringButton!.hidden = false
                            mViewControler!.blurEffect.hidden = true
                            mViewControler!.requesterContainerView.hidden = true
                            mViewControler!.tutorContainerView.hidden = true
                            mViewControler!.tutorSessionContainerView.hidden = true
                            passed = false
                            
                            removeObservers(cUserRef!)
                        }
                    }
                })
            } else {
                if  (snapshot.value["requesterUsername"] as! String) == "" {
                    if let _ = mViewControler?.presentedViewController {
                        if (alertPicController != nil) {
                            alertPicController!.dismissViewControllerAnimated(false, completion: nil)
                        }
                    }
                }
            }
        })
    }
}

func pairedListener(view: AnyObject, askedCourse: String) {
    dispatch_barrier_async(taskQueue) {
        let mainViewController = view as? HomeViewController
        let username = (user["username"] as! String)
        let currUserRef = getFirebase("users/" + username)
        let askedCourse = askedCourse.componentsSeparatedByString(":")[0]
        currUserRef.observeEventType(.Value, withBlock: { snapshot in
            paired["username"] = (snapshot.value.objectForKey("pairedUsername") as? String)
            if paired["username"] != "" && (snapshot.value.objectForKey("start") as? String) == "" {
                currUserRef!.updateChildValues(["possiblePairedUsers": 0])
                
                paired["photoString"] = (snapshot.value["pairedPhoto"] as! String)
                decImage = decodePhoto(snapshot.value["pairedPhoto"] as! String)

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
                
                mainViewController!.requestTutoringButton.hidden = true
                
                mainViewController!.requesterContainerView.hidden = false
                
                mainViewController!.requesterStartSessionViewController?.tutorUsername.text = paired["username"]! + " is coming to help you on:"
                
                mainViewController!.requesterStartSessionViewController?.tutorCourse.text = paired["course"]
                
                mainViewController!.requesterStartSessionViewController?.tutorPhoto.image = decImage
                
                mainViewController!.requesterTutoringSessionViewController?.requesterTutoringSessionTutorPhoto.image = decImage
                
                mainViewController!.tutorStudentSwitch.hidden = true
                
                mainViewController!.tutorStudentSwiftLabel.hidden = true
                
                mainViewController!.logout.enabled = false
                
                //removeObservers(currUserRef)
            }
            for key in usersPerCourse.keys {
                if key != username {
                    let cancelRequesterUserRef = getFirebase("users/" + key + "/" + "cancel")
                    cancelRequesterUserRef.observeSingleEventOfType(.Value, withBlock: { snap in
                        if let v_ = snap.value as? String {
                            if v_ == "yes" {
                                possiblePairedUsers = (snapshot.value["possiblePairedUsers"] as! Int)
                                if possiblePairedUsers < 1 {
                                    
                                    mainViewController!.blurEffect.hidden = true
                                    
                                    mainViewController!.startHomeViewController()
                                    
                                    alert(view, description: "All Tutors, for your requester subject, are busy right now, please try again later.", okAction: UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    
                                    removeObservers(currUserRef)
                                }
                            }
                        }
                    })
                }
            }
        })
    }
}

func startSession (mainView: AnyObject, view: AnyObject) {
    var dots = (user["dots"]! as! Int)
    let currUserRef = getFirebase("users/" + (user["username"]! as! String))
    removeObservers(currUserRef)
    let mainViewController = mainView as! HomeViewController
    mainViewController.requesterContainerView.hidden = true
    mainViewController.requesterSessionContainerView.hidden = false
    mainViewController.requesterTutoringSessionViewController!.requesterTutoringSessionTutorUsername.text = "Tutoring Session with " + paired["username"]!
    mainViewController.requesterTutoringSessionViewController!.requesterTutotringSessionCourse.text = paired["course"]
    mainViewController.requesterTutoringSessionViewController!.requesterTutoringSessionTutorPhoto.image = decodePhoto(paired["photoString"]!)
    mainViewController.requesterSessionContainerView.hidden = false
    let pairedUserRef = getFirebase("users/" + (paired["username"]! ))
    dispatch_barrier_async(taskQueue) {
        currUserRef.updateChildValues(["start": "yes"])
        user["start"] = "yes"
        pairedUserRef.observeEventType(.Value, withBlock: { snapshot in
            if (snapshot.value.objectForKey("finish") as? String) != "" || dotsTotal > dots {
                dots = dots - dotsTotal
                user["dots"] = dots
                user["paid"] = (user["paid"] as! Int) + dotsTotal
                
                let dotsCategory = ["Earned", "Paid"]
                let dotsAmount = [(user["earned"] as? Int)!, (user["paid"] as? Int)!]
                mainViewController.chartViewController?.paidAmount.text = String(user["paid"] as! Int)
                mainViewController.chartViewController?.setChart(dotsCategory, values: dotsAmount)
                
                let notificationUserRef = getFirebase("notifications/" + (user["username"]! as! String))
                let notice = "balanceUpdate: You paid " + (mainViewController.requesterTutoringSessionViewController?.requesterTutoringSessionPaying.text)! + " dots for a recent tutoring session. Your new total is: " + String(dots)
                let date = getDateTime()
                notificationUserRef.updateChildValues([date: notice])
                notifications[date] = notice
                
                let historyUserRef = getFirebase("history/" + (user["username"]! as! String))
                var noticeH = "requester: You spent " + (mainViewController.requesterTutoringSessionViewController?.requesterTutoringSessionPaying.text)! + " dots on tutoring in "
                noticeH = noticeH + paired["course"]! + " from " + paired["username"]!
                
                let dateH = getDateTime()
                historyUserRef.updateChildValues([dateH: noticeH])
                history[dateH] = noticeH
                
                currUserRef.updateChildValues(["pairedPhoto": ""])
                currUserRef.updateChildValues(["pairedCourse": ""])
                currUserRef.updateChildValues(["finish": ""])
                currUserRef.updateChildValues(["start": ""])
                currUserRef.updateChildValues(["pairedUsername": ""])
                currUserRef.updateChildValues(["dots": dots])
                currUserRef.updateChildValues(["paid": (user["paid"] as! Int)])
                pairedUserRef.updateChildValues(["finish": ""])
                paired["photoString"] = ""
                paired["username"] = ""
                paired["course"] = ""
                mainViewController.requesterTutoringSessionViewController!.performSegueWithIdentifier("returnToHomeRequesterSegue", sender: nil)
                mainViewController.requesterSessionContainerView.hidden = true
                
                removeObservers(pairedUserRef)
            }
        })
    }
}

func cancelSession() {
    dispatch_barrier_async(taskQueue) {
        let username = (user["username"] as! String)
        let currUserRef = getFirebase("users/" + username)
        currUserRef.updateChildValues(["pairedPhoto": ""])
        currUserRef.updateChildValues(["pairedCourse": ""])
        currUserRef.updateChildValues(["cancel": "yes"])
        currUserRef.updateChildValues(["pairedUsername": ""])
        paired["photoString"] = ""
        paired["username"] = ""
        paired["course"] = ""
        
        let notificationUserRef = getFirebase("notifications/" + (user["username"]! as! String))
        let notice = "cancelledSession: You cancelled a tutoring session."
        let date = getDateTime()
        notificationUserRef.updateChildValues([date: notice])
        notifications[date] = notice
    }
}

func finishSession(view: HomeViewController) {
    dispatch_barrier_async(taskQueue) {
        
        let notificationUserRef = getFirebase("notifications/" + (user["username"]! as! String))
        let notice = "balanceUpdate: You earned " + view.tutorSessionViewController!.tutorTutoringSessionEarning.text! + " dots for a recent tutoring session. Your new total is: " + String(dots)
        let date = getDateTime()
        notificationUserRef.updateChildValues([date: notice])
        notifications[date] = notice
        
        let username = (user["username"]! as! String)
        
        let historyUserRef = getFirebase("history/" + (user["username"]! as! String))
        var noticeH = "tutor: You tutored " + requester["username"]!
        noticeH = noticeH + " for " + view.tutorSessionViewController!.tutorTutoringSessionEarning.text! + " dots in " + currCourse + "."
        historyUserRef.updateChildValues([date: noticeH])
        history[date] = noticeH
        
        let currUserRef = getFirebase("users/" + username)
        currUserRef.updateChildValues(["dots": (user["dots"] as! Int)])
        currUserRef.updateChildValues(["earned": (user["earned"] as! Int)])
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
    let date = getDateTime()
    user["lastLogin"] = date
    let username = (user["username"] as! String)
    let currUserRef = getFirebase("users/" + username)
    currUserRef.updateChildValues(["lastLogin": date])
    settingsSwitch = 1
    
    user["firstName"] = ""
    user["lastName"] = ""
    user["username"] = ""
    user["password"] = ""
    user["email"] = ""
    user["major"] = ""
    user["graduationYear"] = ""
    user["photoString"] = ""
    user["courses"] = []
    user["dots"] = 0
    user["earned"] = 0
    user["paid"] = 0
    user["lastLogin"] = ""
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
    
    requester["username"] = ""
    requester["photoString"] = ""
    requester["course"] = ""
    requester["description"] = ""
    requester["location"] = ""
    
    paired["photoString"] = ""
    paired["username"] = ""
    paired["course"] = ""
    
    notifications.removeAll()
    history.removeAll()

    rootRef.unauth()
    
}

func getDateTime() -> String {
    let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    return timestamp
}


func getUserPhoto(username:String, imageView:UIImageView? = nil) {
    let userRef = getFirebase("users/" + username)
    userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if !(snapshot.value is NSNull) {
            //print("snapshot:")
            //print(snapshot.value)
            if let photoString = snapshot.value["Photo String"] as? String {
                if imageView != nil {
                    imageView!.image = decodePhoto(photoString)
                } else {
                    tempUserPhoto = decodePhoto(photoString)
                }
            }
            removeObservers(userRef)
        }
    })
}

func decodePhoto (photoString:String) -> UIImage {
    var decodedImage = UIImage(named: "DefaultProfilePhoto.png")
    
    // If user has selected image other than default image, decode the image
    if photoString.characters.count > 1 {
        let decodedData = NSData(base64EncodedString: photoString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        decodedImage = UIImage(data: decodedData!)!
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

public class AlertController: UIAlertController {
    
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

public class ClearViewController: UIViewController {
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIApplication.sharedApplication().statusBarStyle
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return UIApplication.sharedApplication().statusBarHidden
    }
}
