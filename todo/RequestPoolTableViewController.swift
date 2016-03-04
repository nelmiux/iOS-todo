//
//  RequestPoolTableViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/2/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class RequestPoolTableViewController: UITableViewController {

    private var requestPool:[TutoringRequest] = [TutoringRequest]()
    private var isDataLoaded:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isDataLoaded {
            self.loadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData () {
        requestPool.append(TutoringRequest(sender: "Igor Turlough", courseName: "CS 311: Discrete Mathematics", location: "GDC Atrium", description: "Need help with set theory proofs"))
        requestPool.append(TutoringRequest(sender: "Vijaya Angel", courseName: "CH 301: Principles of Chemistry I", location: "Welch Hall", description: "I don't understand stoichiometry"))
        requestPool.append(TutoringRequest(sender: "Kristen Eluf", courseName: "CS 312: Introduction to Java Programming", location: "GDC 3rd Floor Lab", description: "How do I use recursion?"))
        requestPool.append(TutoringRequest(sender: "Alexis Israel", courseName: "CS 331: Algorithms and Complexity", location: "GDC Atrium", description: "Help with dynamic programming"))
        requestPool.append(TutoringRequest(sender: "Timothy Javan", courseName: "CS 439: Operating Systems", location: "PCL 3.002", description: "Don't understand project 3 of PintOS"))
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return requestPool.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestPoolEntry", forIndexPath: indexPath) as! RequestPoolTableViewCell
        let currRequest = self.requestPool[indexPath.row]
        cell.nameLabel.text = currRequest.getSender()
        cell.locationLabel.text = currRequest.getLocation()
        cell.courseLabel.text = currRequest.getCourseName()
        cell.detailLabel.text = currRequest.getDescription()
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
