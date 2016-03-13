//
//  CoursesListViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/9/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

    class OptionsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        private var parentButton:UIButton? = nil
        private var cellId:String = ""
        private var options:[String] = [String]()
        var tableView:UITableView = UITableView()
        private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        convenience init(title:String, preferredContentSize:CGSize) {
            self.init()
            
            // Set some view controller attributes
            self.preferredContentSize = preferredContentSize
            self.title = title
            
            self.modalPresentationStyle = UIModalPresentationStyle.Popover
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.tableView.frame         =   CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
            self.tableView.delegate      =   self
            self.tableView.dataSource    =   self
            
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
            
            self.view.addSubview(self.tableView)
        }
        
        func setCellId (cellId:String) {
            self.cellId = cellId
        }
        
        func setParentButton (button:UIButton) {
            self.parentButton = button
        }
        
        func setOptions (options:[String]) {
            self.options = options
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Table view data source
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.options.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath)
            cell.textLabel!.text = options[indexPath.row]
            return cell
        }
        
        // MARK: - Table view delegate
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            parentButton?.setTitle(options[indexPath.row], forState: UIControlState.Normal)
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
        
}
