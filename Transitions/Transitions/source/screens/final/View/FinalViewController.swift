//
//  FinalViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 14/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

class FinalViewController: BaseViewController, TransitionResignable {
    
    // MARK: - Properties
    @IBOutlet weak var transitionBackwardsButton: UIButton!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure(self.view)
        self.configure(self.transitionBackwardsButton)
        self.attach(self.resignTransitioningSwipeGestureRecognizer, to: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TransitionResignable protocol
    var customTransitioningDelegate: UIViewControllerTransitioningDelegate?
    lazy var resignTransitioningGestureRecognizer: UIGestureRecognizer? = {
        // TODO: implement `resignTransitioningGestureRecognizer`
        return nil
    }()
    
    lazy var resignTransitioningSwipeGestureRecognizer: UISwipeGestureRecognizer? = {
        // configure `resignTransitioningSwipeGestureRecognizer`
        let swipeGR: UISwipeGestureRecognizer
        
        if
            let validCustomTransitioningDelegate = self.customTransitioningDelegate as? BaseTransitioningDelegate,
            let validAnimator = validCustomTransitioningDelegate.presentationalAnimator as? AxialTransitioningAnimator
        {
            switch validAnimator.transitioningDirection {
            case .left:
                swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(FinalViewController.transitionBackwardsPressed(_:)))
                swipeGR.direction = .right
                
            case .right:
                swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(FinalViewController.transitionBackwardsPressed(_:)))
                swipeGR.direction = .left
                
            case .up:
                swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(FinalViewController.transitionBackwardsPressed(_:)))
                swipeGR.direction = .down
                
            case .down:
                swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(FinalViewController.transitionBackwardsPressed(_:)))
                swipeGR.direction = .up
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
        
        if let valid_presentingVC = self.presentingViewController {
            valid_presentingVC.dismiss(animated: animated, completion: completion)
        }
    }
    
    // MARK: - Actions
    @IBAction func transitionBackwardsPressed(_ sender: AnyObject) {
        self.resignTransitionAnimated(true, sender: sender, completion: nil)
    }
}

// MARK: - UI configurations
fileprivate extension FinalViewController {
   
    func configure(_ aButton: UIButton) {
        aButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: UIControlState())
        aButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .selected)
        aButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        aButton.backgroundColor = UIColor.clear
    }
    
    func configure(_ aView: UIView) {
        aView.backgroundColor = UIColor.red.withAlphaComponent(1)
    }
    
    func attach(_ recognizer: UIGestureRecognizer?, to aView: UIView) {
        guard let valid_recognizer: UIGestureRecognizer = recognizer else {
            Logger.error.message("Invalid \(String(describing: UIGestureRecognizer.self)) object!")
            return
        }
        aView.addGestureRecognizer(valid_recognizer)
    }
}
