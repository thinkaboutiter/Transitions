//
//  TransitioningDelegates.swift
//  Transitions
//
//  Created by Boyan Yankov on 13/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - BaseTransitioningDelegate

class BaseTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
   
    // MARK: Presentation configuration
    
    private(set) var isPresentationEnabled: Bool = false
    private(set) var presentationalAnimator: BaseTransitioningAnimator?
    private(set) var dismissalAnimator: BaseTransitioningAnimator?
    
    /** Chainable */
    func shouldUsePresentations(shouldUsePresentations: Bool) -> BaseTransitioningDelegate {
        self.isPresentationEnabled = shouldUsePresentations
        return self
    }
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    init(withPresentationalAnimator presentationalAnimator: BaseTransitioningAnimator, andDismissalAnimator dismissalAnimator: BaseTransitioningAnimator, shouldUsePresentations: Bool = false) {
        self.presentationalAnimator = presentationalAnimator
        self.dismissalAnimator = dismissalAnimator
        self.isPresentationEnabled = shouldUsePresentations
        
        super.init()
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol
    
    // @available(iOS 2.0, *)
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.presentationalAnimator
    }
    // @available(iOS 2.0, *)
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissalAnimator
    }
    
//    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
//    }
    
//    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
//    }
    
    // @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if self.isPresentationEnabled {
            let basePC = BasePresentationController(presentedViewController: presented, presentingViewController: presenting)
            return basePC
        }
        else {
            return nil
        }
    }
}