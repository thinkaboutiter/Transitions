//
//  BaseTransitioningAnimator.swift
//  Transitions
//
//  Created by boyankov on W43 24/Oct/2017 Tue.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

// MARK: - BaseTransitioningAnimator
class BaseTransitioningAnimator: NSObject {
    
    fileprivate(set) var isPresenting: Bool = false
    
    // MARK: - Animations
    func animatePresentationalTransition(using transitionContext: UIViewControllerContextTransitioning) throws {
        fatalError("Subclasses should implement")
    }
    
    func animateDismissalTransition(using transitionContext: UIViewControllerContextTransitioning) throws {
        fatalError("Subclasses should implement")
    }
    
    // MARK: - Animation objects
    // MARK: Frames
    func toView_presentationalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("Subclasses should implement")
    }
    
    func toView_dismissalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("Subclasses should implement")
    }
    
    func fromView_dismissalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("Subclasses should implement")
    }
    
    // MARK: containerView
    func containerView(using transitionContext: UIViewControllerContextTransitioning) -> UIView {
        let validContainerView: UIView = transitionContext.containerView
        return validContainerView
    }
    
    // MARK: to UIs
    func toViewController(using transitionContext: UIViewControllerContextTransitioning) throws -> UIViewController {
        guard let validToVC: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            throw TransitioningAnimatorError.generalError(errorReason: "`transitionContext` has no `ToViewController`")
        }
        return validToVC
    }
    
    func toView(using transitionContext: UIViewControllerContextTransitioning) throws -> UIView {
        guard let validToView: UIView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            throw TransitioningAnimatorError.generalError(errorReason: "`transitionContext` has no `ToView`")
        }
        return validToView
    }
    
    // MARK: from UIs
    func fromViewController(using transitionContext: UIViewControllerContextTransitioning) throws -> UIViewController {
        guard let validFromVC: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            throw TransitioningAnimatorError.generalError(errorReason: "`transitionContext`has no `FromViewController`")
        }
        return validFromVC
    }
    
    func fromView(using transitionContext: UIViewControllerContextTransitioning) throws -> UIView {
        guard let validFromView: UIView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            throw TransitioningAnimatorError.generalError(errorReason: "`transitionContext` has no `FromView`")
        }
        return validFromView
    }
}

// MARK: - UIViewControllerAnimatedTransitioning protocol
extension BaseTransitioningAnimator: UIViewControllerAnimatedTransitioning {
    
    /** This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to synchronize with the main animation. */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /** This method can only be a nop if the transition is interactive and not a percentDriven interactive transition. */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // non-interactive animation
        do {
            try self.animateTranstion(isPresentation: self.isPresenting, using: transitionContext)
        }
        catch TransitioningAnimatorError.generalError(let errorReason) {
            Logger.error.message("Transitioning Animator Error:").object(errorReason)
        }
        catch {
            Logger.error.message("TransactionError:").object(error.localizedDescription)
        }
    }
    
    // Non-interactive transitioning animation
    fileprivate func animateTranstion(isPresentation: Bool, using transitionContext: UIViewControllerContextTransitioning) throws -> Void {
        
        if isPresentation {
            try self.animatePresentationalTransition(using: transitionContext)
        }
        else {
            try self.animateDismissalTransition(using: transitionContext)
        }
    }
    
    /** This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked. */
    func animationEnded(_ transitionCompleted: Bool) {
        // clean up
    }
}

// MARK: - Errors
extension BaseTransitioningAnimator {
    
    enum TransitioningAnimatorError: Error {
        case generalError (errorReason: String)
    }
}

// MARK: - Directions
extension BaseTransitioningAnimator {

    enum TransitioningDirection: UInt {
        case left
        case right
        case up
        case down
    }
}
