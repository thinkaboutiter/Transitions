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
        
        self.view.backgroundColor = UIColor.red.withAlphaComponent(1)
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
    
    @IBAction func transitionBackwardsPressed(_ sender: AnyObject) {               
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
            case .left:
                Logger.debug.message("Horizontal.Left")
                
                // configure `swipeGR`
                swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(FinalViewController.transitionBackwardsPressed(_:)))
                swipeGR?.direction = .right
                
            case .right:
                Logger.debug.message("Horizontal.Right")
                
                // configure `swipeGR`
                swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(FinalViewController.transitionBackwardsPressed(_:)))
                swipeGR?.direction = .left
                
            case .up:
                Logger.debug.message("Vertical.Top")
                
                // configure `swipeGR`
                swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(FinalViewController.transitionBackwardsPressed(_:)))
                swipeGR?.direction = .down
                
            case .down:
                Logger.debug.message("Vertical.Bottom")
                
                // configure `swipeGR`
                swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(FinalViewController.transitionBackwardsPressed(_:)))
                swipeGR?.direction = .up
            }
            
            return swipeGR
        }
        return nil
    }()

    func resignTransitionAnimated(_ animated: Bool, sender: AnyObject, completion: (() -> Void)?) {
        if let _ = self.customTransitioningDelegate {
            self.transitioningDelegate = self.customTransitioningDelegate
            self.modalPresentationStyle = .custom
        }
        else {
            Logger.debug.message("Tansition will use default `transitioningDelegate`").object(self.transitioningDelegate)
        }
        
        if let validPresentingVC = self.presentingViewController {
            validPresentingVC.dismiss(animated: animated, completion: completion)
        }
    }
    
    // MARK: - Configurations
    
    fileprivate func configureButton(_ button: UIButton) {
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: UIControlState())
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .selected)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.backgroundColor = UIColor.clear
    }
}
