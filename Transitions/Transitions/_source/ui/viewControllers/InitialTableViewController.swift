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
    
    fileprivate let cellTitles: [String] = [
        "Transitioning Left",
        "Transitioning Right",
        "Transitioning Up",
        "Transitioning Down"
    ]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAppearance()
        self.configureTableView(self.tableView)
    }
    
    // MARK: - UITableViewDataSource protocol
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell
        
        if let validCell: BaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BaseTableViewCell), for: indexPath) as? BaseTableViewCell {
            cell = validCell
        }
        else {
            cell = BaseTableViewCell(style: .default, reuseIdentifier: NSStringFromClass(BaseTableViewCell))
        }
        
        cell.isFirstCell = indexPath.row == 0
        cell.isLastCell = indexPath.row == (self.cellTitles.count - 1)
        cell.textLabel?.text = self.cellTitles[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    // MARK: - UITableViewDelegate protocol
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // `validStoryboard`
        guard let validStoryboard: UIStoryboard = self.storyboard else {
            Logger.logError("\(self) \(#function) » `validStoryboard`is not available", item: self.storyboard)
            return
        }
        
        // `finalVC` is the `presentedOne`
        let finalVC: FinalViewController = validStoryboard.instantiateViewController(withIdentifier: NSStringFromClass(FinalViewController)) as! FinalViewController
        
        // configure `modalPresentationStyle`
        self.modalPresentationStyle = .custom
        finalVC.modalPresentationStyle = .custom
        
        // reset `transitioningDelegate`
        self.transitioningDelegate = nil
        finalVC.transitioningDelegate = nil
        
        // `transitioningDelegate`
        let transitioningDelegate: UIViewControllerTransitioningDelegate
        
        // do presentations with their directions here
        switch indexPath.row {
        case 0:
            // Left
            Logger.logInfo("\(self) \(#function) » Transition `Horizontal.Left`", item: nil)
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .left).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .left))
            
        case 1:
            // Right
            Logger.logInfo("\(self) \(#function) » Transition `Horizontal.Right`", item: nil)
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .right).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .right))
            
        case 2:
            // Up
            Logger.logInfo("\(self) \(#function) » Transition `Vertical.Top`", item: nil)
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .up).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .up))
            
        case 3:
            // Down
            Logger.logInfo("\(self) \(#function) » Transition `Vertical.Bottom`", item: nil)
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .down).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .down))
            
        default:
            Logger.logError("\(self) \(#function) » Unsupported Transition", item: nil)
            // TODO: show alert
            return
        }
        
        // assign `transitioningDelegate`
        self.transitioningDelegate = transitioningDelegate
        finalVC.transitioningDelegate = transitioningDelegate
        finalVC.customTransitioningDelegate = transitioningDelegate
        
        self.present(finalVC, animated: true, completion: nil)
    }
    
    // MARK: - Configuration
    
    fileprivate func configureAppearance() {
        self.title = "Transitions"
    }
    
    fileprivate func configureTableView(_ tableView: UITableView) {
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(BaseTableViewCell))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
    }
    
    // MARK: - Helpers
}
