//
//  BasePresentationController.swift
//  Transitions
//
//  Created by Boyan Yankov on 16/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

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
        guard let valid_containerView = self.containerView else {
            Logger.error.message("`containerView` is not valid")
            return
        }
        
        let presentedVC = self.presentedViewController
        
        // Set the dimming view to the size of the container's bounds, and make it transparent initially
        self.dimmingView.frame = valid_containerView.bounds
        self.dimmingView.alpha = 0.0
        
        // Insert the dimming view below everything else.
        valid_containerView.insertSubview(self.dimmingView, at: 0)
        
        // Set up the animations for fading in the dimming view
        guard let valid_transitionCoordinator: UIViewControllerTransitionCoordinator = presentedVC.transitionCoordinator else {
            Logger.error.message("Unable to obtain \(String(describing: UIViewControllerTransitionCoordinator.self))")

            self.dimmingView.alpha = 1.0
            return
        }
        
        valid_transitionCoordinator
            .animate(
                alongsideTransition: { (transitioningContext: UIViewControllerTransitionCoordinatorContext) -> Void in
                    self.dimmingView.alpha = 1.0
            },
                completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        // If the presentation was canceled, remove the dimming view
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    // MARK: - Dismissals
    override func dismissalTransitionWillBegin() {
        guard let valid_transitionCoordinator: UIViewControllerTransitionCoordinator = self.presentedViewController.transitionCoordinator else {
            Logger.error.message("Unable to obtain \(String(describing: UIViewControllerTransitionCoordinator.self))")
            
            self.dimmingView.alpha = 0.0
            return
        }
        
        valid_transitionCoordinator
            .animate(
                alongsideTransition: { (transitioningContext: UIViewControllerTransitionCoordinatorContext) -> Void in
                    self.dimmingView.alpha = 0.0
            },
                completion: nil)
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
        guard let valid_containerView_bounds: CGRect = self.containerView?.bounds else {
            Logger.error.message("Unable ot obtain container view's bounds")
            return CGRect.zero
        }
        
        var presentedView_frame: CGRect = CGRect.zero
        presentedView_frame.size = CGSize(width: valid_containerView_bounds.size.width / CGFloat(2.0),
                                          height: valid_containerView_bounds.size.height)
        presentedView_frame.origin.x = valid_containerView_bounds.size.width - presentedView_frame.size.width
        
        return presentedView_frame
    }
}
