//
//  OptionsPopoverViewController.swift
//  todo
//
//  Created by Quyen Castellanos on 3/9/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
    
    class OptionsPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
        
        var optionsListViewController:OptionsListViewController? = nil
        private var parentButton:UIButton? = nil
        private var cellId:String = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        func setCellId (cellId:String) {
            self.cellId = cellId
        }
        
        func setParentButton (button:UIButton) {
            self.parentButton = button
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func presentPopover(sourceController sourceController:UIViewController, sourceView:UIView, sourceRect:CGRect) {
            
            // Create the view controller we want to display as the popup.
            self.optionsListViewController = OptionsListViewController(title: "Options", preferredContentSize: CGSize(width: 350, height: 180))
            self.optionsListViewController?.setCellId("optionCell")
            self.optionsListViewController?.setParentButton(self.parentButton!)
            let options:[String] = ["Upper", "Lower"]
            self.optionsListViewController?.setOptions(options)
            
            // Cause the views to be created in this view controller. Gets them added to the view hierarchy.
            self.optionsListViewController?.view
            self.optionsListViewController?.tableView.layoutIfNeeded()
            
            // Set attributes for the popover controller.
            // Notice we're get an existing object from the view controller we want to popup!
            let popoverMenuViewController = self.optionsListViewController!.popoverPresentationController
            popoverMenuViewController?.permittedArrowDirections = .Any
            popoverMenuViewController?.delegate = self
            popoverMenuViewController?.sourceView = sourceView
            popoverMenuViewController?.sourceRect = sourceRect
            
            // Show the popup.
            // Notice we are presenting form a view controller passed in. We need to present from a view controller
            // that has views that are already in the view hierarchy.
            sourceController.presentViewController(self.optionsListViewController!, animated: true, completion: nil)
        }
        
        func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
            // Indicate we want the same presentation behavior on both iPhone and iPad.
            return UIModalPresentationStyle.None
        }
        
}


