//
//  FinalViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 14/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit
import SimpleLogger

class FinalViewController: BaseViewController, TransitioningResignable {
    
    @IBOutlet weak var transitionBackwardsButton: UIButton!
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor().colorWithAlphaComponent(1)
        self.configureButton(self.transitionBackwardsButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func transitionBackwardsPressed(sender: AnyObject) {               
        self.resignTransitionAnimated(true, sender: sender, completion: nil)
    }
    
    // MARK: - TransitioningResignable
    
    var customTransitioningDelegate: UIViewControllerTransitioningDelegate?

    func resignTransitionAnimated(animated: Bool, sender: AnyObject, completion: (() -> Void)?) {
        if let _ = self.customTransitioningDelegate {
            self.transitioningDelegate = self.customTransitioningDelegate
            self.modalPresentationStyle = .Custom
        }
        else {
            Logger.logInfo("\(self) \(__FUNCTION__) » Tansition will use default `transitioningDelegate`:", item: self.transitioningDelegate)
        }
        
        if let validPresentingVC = self.presentingViewController {
            validPresentingVC.dismissViewControllerAnimated(animated, completion: completion)
        }
    }
    
    // MARK: - Configurations
    
    private func configureButton(button: UIButton) {
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.8), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.8), forState: .Selected)
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.8), forState: .Highlighted)
        button.backgroundColor = UIColor.clearColor()
    }
}