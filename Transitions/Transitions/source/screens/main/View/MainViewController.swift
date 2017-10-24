//
//  MainViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 19/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

import SimpleLogger

class MainViewController: BaseViewController, MainViewModelConsumable {
    
    fileprivate let cellTitles: [String] = [
        "Transitioning Left",
        "Transitioning Right",
        "Transitioning Up",
        "Transitioning Down"
    ]
    
    // MARK: - Properties
    @IBOutlet weak var functionalitesTableView: UITableView!
    
    // MARK: - MainViewModelConsumable protocol
    fileprivate(set) var viewModel: MainViewModelable?
    func updateViewModel(_ viewModel: MainViewModelable?) {
        self.viewModel = viewModel
    }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        Logger.debug.message("\(String(describing: MainViewController.self)) deinitialized")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure_appearance()
        self.configure(self.functionalitesTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}

// MARK: - UI configurations
fileprivate extension MainViewController {
    
    fileprivate func configure_appearance() {
        self.title = "Transitions"
    }
    
    fileprivate func configure(_ tableView: UITableView) {
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(BaseTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource protocol
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell
        
        if let validCell: BaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BaseTableViewCell.self), for: indexPath) as? BaseTableViewCell {
            cell = validCell
        }
        else {
            cell = BaseTableViewCell(style: .default, reuseIdentifier: NSStringFromClass(BaseTableViewCell.self))
        }
        
        cell.isFirst = indexPath.row == 0
        cell.isLast = indexPath.row == (self.cellTitles.count - 1)
        cell.textLabel?.text = self.cellTitles[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
}

// MARK: - UITableViewDelegate protocol
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // `validStoryboard`
        guard let validStoryboard: UIStoryboard = self.storyboard else {
            Logger.error.message("`validStoryboard`is not available")
            return
        }
        
        // `finalVC` is the `presentedOne`
        let finalVC: FinalViewController = validStoryboard.instantiateViewController(withIdentifier: NSStringFromClass(FinalViewController.self)) as! FinalViewController
        
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
            Logger.debug.message("Transition `Horizontal.Left`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .left).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .left))
            
        case 1:
            // Right
            Logger.debug.message("Transition `Horizontal.Right`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .right).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .right))
            
        case 2:
            // Up
            Logger.debug.message("Transition `Vertical.Top`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .up).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .up))
            
        case 3:
            // Down
            Logger.debug.message("Transition `Vertical.Bottom`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .down).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .down))
            
        default:
            Logger.debug.message("Unsupported Transition")
            // TODO: show alert
            return
        }
        
        // assign `transitioningDelegate`
        self.transitioningDelegate = transitioningDelegate
        finalVC.transitioningDelegate = transitioningDelegate
        finalVC.customTransitioningDelegate = transitioningDelegate
        
        self.present(finalVC, animated: true, completion: nil)
    }
}
