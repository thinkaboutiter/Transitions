//
//  BasePresentationController.swift
//  Transitions
//
//  Created by Boyan Yankov on 16/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit
import SimpleLogger

class BasePresentationController: UIPresentationController {
    
    fileprivate let dimmingView: UIView
    
    // MARK: - Initialization
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        self.dimmingView = UIView()
        self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.dimmingView.alpha = 0.0
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    // MARK: - Presentations
    override func presentationTransitionWillBegin() {
        // Get critical information about the presentation.
        
        if let validCV = self.containerView {
            let presentedVC = self.presentedViewController
            
            // Set the dimming view to the size of the container's bounds, and make it transparent initially
            self.dimmingView.frame = validCV.bounds
            self.dimmingView.alpha = 0.0
            
            // Insert the dimming view below everything else.
            validCV.insertSubview(self.dimmingView, at: 0)
            
            // Set up the animations for fading in the dimming view
            if let validTC = presentedVC.transitionCoordinator {
                validTC.animate(
                    alongsideTransition: { (transitioningContext: UIViewControllerTransitionCoordinatorContext) -> Void in
                        self.dimmingView.alpha = 1.0
                    },
                    completion: nil)
            }
            else {
                self.dimmingView.alpha = 1.0
            }
        }
        else {
            Logger.error.message("`containerView` is not valid")
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        // If the presentation was canceled, remove the dimming view
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    // MARK: - Dismissals
    override func dismissalTransitionWillBegin() {
        if let validTC = self.presentedViewController.transitionCoordinator {
            validTC.animate(
                alongsideTransition: { (transitioningContext: UIViewControllerTransitionCoordinatorContext) -> Void in
                    self.dimmingView.alpha = 0.0
                },
                completion: nil)
        }
        else {
            self.dimmingView.alpha = 0.0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    // MARK: - Configurations
    override var shouldPresentInFullscreen : Bool {
        return true
    }
    
    override var shouldRemovePresentersView : Bool {
        return false
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        var presentedView_frame = CGRect.zero
        if let validContainerView_bounds = self.containerView?.bounds {
            presentedView_frame.size = CGSize(width: validContainerView_bounds.size.width / CGFloat(2.0), height: validContainerView_bounds.size.height)
            presentedView_frame.origin.x = validContainerView_bounds.size.width - presentedView_frame.size.width
            
            return presentedView_frame
        }
        else {
            return CGRect.zero
        }
    }
}
