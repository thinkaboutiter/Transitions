//
//  InitialTableViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 19/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit
import SimpleLogger

class InitialTableViewController: BaseTableViewController {
    
    private let cellTitles: [String] = [
        "Horizontal left",
        "Horizontal right",
        "Vertical top",
        "Vertical bottom"
    ]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAppearance()
        self.configureTableView(self.tableView)
    }
    
    // MARK: - UITableViewDataSource protocol
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTitles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell
        
        if let validCell: BaseTableViewCell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(BaseTableViewCell), forIndexPath: indexPath) as? BaseTableViewCell {
            cell = validCell
        }
        else {
            cell = BaseTableViewCell(style: .Default, reuseIdentifier: NSStringFromClass(BaseTableViewCell))
        }
        
        cell.isFirstCell = indexPath.row == 0
        cell.isLastCell = indexPath.row == (self.cellTitles.count - 1)
        cell.textLabel?.text = self.cellTitles[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    // MARK: - UITableViewDelegate protocol
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // `validStoryboard`
        guard let validStoryboard: UIStoryboard = self.storyboard else {
            Logger.logError("\(self) \(__FUNCTION__) » `validStoryboard`is not available", item: self.storyboard)
            return
        }
        
        // `finalVC` is the `presentedOne`
        let finalVC: FinalViewController = validStoryboard.instantiateViewControllerWithIdentifier(NSStringFromClass(FinalViewController)) as! FinalViewController
        
        // configure `modalPresentationStyle`
        self.modalPresentationStyle = .Custom
        finalVC.modalPresentationStyle = .Custom
        
        // reset `transitioningDelegate`
        self.transitioningDelegate = nil
        finalVC.transitioningDelegate = nil
        
        // `transitioningDelegate`
        let transitioningDelegate: UIViewControllerTransitioningDelegate
        
        // do presentations here
        switch indexPath.row {
        case 0:
            // Horizontal Left
            Logger.logInfo("\(self) \(__FUNCTION__) » Transition `Horizontal.Left`", item: nil)
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: HorizontalTransitioningAnimator(withHorizontalTransitioningDirection: .Left).shouldPresentViewController(true),
                andDismissalAnimator: HorizontalTransitioningAnimator(withHorizontalTransitioningDirection: .Left))
            
        case 1:
            // Horizontal Right
            Logger.logInfo("\(self) \(__FUNCTION__) » Transition `Horizontal.Right`", item: nil)
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: HorizontalTransitioningAnimator(withHorizontalTransitioningDirection: .Right).shouldPresentViewController(true),
                andDismissalAnimator: HorizontalTransitioningAnimator(withHorizontalTransitioningDirection: .Right))
            
        case 2:
            // Vertical Top
            Logger.logInfo("\(self) \(__FUNCTION__) » Transition `Vertical.Top`", item: nil)
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: VerticalTransitioningAnimator(withVerticalTransitioningDirection: .Top).shouldPresentViewController(true),
                andDismissalAnimator: VerticalTransitioningAnimator(withVerticalTransitioningDirection: .Top))
            
        case 3:
            // Vertical Bottom
            Logger.logInfo("\(self) \(__FUNCTION__) » Transition `Vertical.Bottom`", item: nil)
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: VerticalTransitioningAnimator(withVerticalTransitioningDirection: .Bottom).shouldPresentViewController(true),
                andDismissalAnimator: VerticalTransitioningAnimator(withVerticalTransitioningDirection: .Bottom))
            
        default:
            Logger.logError("\(self) \(__FUNCTION__) » Unsupported Transition", item: nil)
            // TODO: show alert
            return
        }
        
        // assign `transitioningDelegate`
        self.transitioningDelegate = transitioningDelegate
        finalVC.transitioningDelegate = transitioningDelegate
        finalVC.customTransitioningDelegate = transitioningDelegate
        
        self.presentViewController(finalVC, animated: true, completion: nil)
    }
    
    // MARK: - Configuration
    
    private func configureAppearance() {
        self.title = "Transitions"
    }
    
    private func configureTableView(tableView: UITableView) {
        tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(BaseTableViewCell))
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.blackColor()
    }
    
    // MARK: - Helpers
}