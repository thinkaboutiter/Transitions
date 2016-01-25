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
        
        // attach `resignTransitioningSwipeGestureRecognizer`
        if let _ = self.resignTransitioningSwipeGestureRecognizer {
            self.view.addGestureRecognizer(self.resignTransitioningSwipeGestureRecognizer!)
        }
        
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
    lazy var resignTransitioningGestureRecognizer: UIGestureRecognizer? = {
        // TODO: implement `resignTransitioningGestureRecognizer`
        
        return nil
    }()
    
    lazy var resignTransitioningSwipeGestureRecognizer: UISwipeGestureRecognizer? = {
        // configure `resignTransitioningSwipeGestureRecognizer`
        let swipeGR: UISwipeGestureRecognizer?
        
        if let validCustomTransitioningDelegate = self.customTransitioningDelegate as? BaseTransitioningDelegate, let validAnimator = validCustomTransitioningDelegate.presentationalAnimator as? AxialTransitioningAnimator {
            switch validAnimator.transitioningDirection {
            case .Left:
//                Logger.logDebug("\(self) \(__FUNCTION__) » Horizontal.Left", item: nil)
                
                // configure `swipeGR`
                swipeGR = UISwipeGestureRecognizer(target: self, action: "transitionBackwardsPressed:")
                swipeGR?.direction = .Right
                
            case .Right:
//                Logger.logDebug("\(self) \(__FUNCTION__) » Horizontal.Right", item: nil)
                
                // configure `swipeGR`
                swipeGR = UISwipeGestureRecognizer(target: self, action: "transitionBackwardsPressed:")
                swipeGR?.direction = .Left
                
            case .Up:
//                Logger.logDebug("\(self) \(__FUNCTION__) » Vertical.Top", item: nil)
                
                // configure `swipeGR`
                swipeGR = UISwipeGestureRecognizer(target: self, action: "transitionBackwardsPressed:")
                swipeGR?.direction = .Down
                
            case .Down:
//                Logger.logDebug("\(self) \(__FUNCTION__) » Vertical.Bottom", item: nil)
                
                // configure `swipeGR`
                swipeGR = UISwipeGestureRecognizer(target: self, action: "transitionBackwardsPressed:")
                swipeGR?.direction = .Up
            }
            
            return swipeGR
        }
        return nil
    }()

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