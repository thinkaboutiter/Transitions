//
//  UIWindow+Extensions.swift
//  Transitions
//
//  Created by boyankov on W43 24/Oct/2017 Tue.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

// MARK: - Replacing root view controllers
extension UIWindow {
    
    // inspiration source
    // http://stackoverflow.com/questions/15774003/changing-root-view-controller-of-a-ios-window
    /**
     * Replace `rootViewController` object with snapshot cover image
     */
    @objc func replaceRootViewController(with replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        // we need a valid `rootViewController`
        guard let validRootViewController: UIViewController = self.rootViewController else {
            Logger.error.message("invalid rootViewController")
            return
        }
        
        // create snapshot
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)
        
        // check for modally presented view controllers
        if let _ = validRootViewController.presentedViewController {
            // dismiss them
            validRootViewController.dismiss(animated: false, completion: {
                self.transitionTo(replacementController,
                                  snapshotImageView: snapshotImageView,
                                  animated: animated,
                                  completion: completion)
            })
        }
        else {
            self.transitionTo(replacementController,
                              snapshotImageView: snapshotImageView,
                              animated: animated,
                              completion: completion)
        }
    }
    
    fileprivate func transitionTo(_ replacementViewController: UIViewController,
                                  snapshotImageView: UIImageView,
                                  animated: Bool,
                                  completion: (() -> Void)?)
    {
        self.rootViewController = replacementViewController
        self.bringSubview(toFront: snapshotImageView)
        
        // configure animation
        let animationDuration: TimeInterval = 0.3
        let animationDelay: TimeInterval = 0
        let animationOptions: UIViewAnimationOptions = UIViewAnimationOptions.curveEaseInOut
        
        if animated {
            UIView.animate(
                withDuration: animationDuration,
                delay: animationDelay,
                options: animationOptions,
                animations: {
                    snapshotImageView.alpha = 0
            },
                completion: { (success: Bool) in
                    snapshotImageView.removeFromSuperview()
                    completion?()
            })
        }
        else {
            snapshotImageView.removeFromSuperview()
            completion?()
        }
    }
}
