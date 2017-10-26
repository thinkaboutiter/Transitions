//
//  BaseTransitioningDelegate.swift
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
    fileprivate(set) var isPresentationEnabled: Bool = false
    fileprivate(set) var presentationalAnimator: BaseTransitioningAnimator?
    fileprivate(set) var dismissalAnimator: BaseTransitioningAnimator?
    
    /** Chainable */
    func shouldUsePresentations(_ shouldUsePresentations: Bool) -> BaseTransitioningDelegate {
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
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.presentationalAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissalAnimator
    }
    
//    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
//    }
    
//    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
//    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        if self.isPresentationEnabled {
            let basePC = BasePresentationController(presentedViewController: presented, presenting: presenting!)
            return basePC
        }
        else {
            return nil
        }
    }
}
