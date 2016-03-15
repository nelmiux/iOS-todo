//
//  CoursesListView.swift
//  todo
//
//  Created by Nelma Perera on 3/15/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class CoursesListView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var courses = []
    
    let cellId:String = "CellId"
    
    var tableView:UITableView = UITableView()
    
    convenience init(title:String, preferredContentSize:CGSize) {
        self.init()
        
        // Set some view controller attributes
        self.preferredContentSize = preferredContentSize
        self.title = title
        
        self.modalPresentationStyle = UIModalPresentationStyle.Popover
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = true;
        
        self.tableView.frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
        
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.superview?.layer.cornerRadius = 0
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
        return self.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath)
        
        let row = indexPath.row
        
        let course = courses[row]
        
        if courses.count > 0 {
            cell.textLabel?.text = course as? String
        }
        
        return cell
    }

}
