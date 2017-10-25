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
    
    // chainable
    func shouldPresentViewController(_ isPresenting: Bool) -> BaseTransitioningAnimator {
        self.isPresenting = isPresenting
        return self
    }
    
    // MARK: - Animation objects
    // MARK: Frames
    func toView_presentationalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`toView_PresentationalAnimationFrames(_:)` has not been implemented")
    }
    
    func toView_dismissalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`toView_DismissalAnimationFrames(_:)` has not been implemented")
    }
    
    func fromView_dismissalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`fromView_DismissalAnimationFrames(_:)` has not been implemented")
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
    
    /** This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked. */
    func animationEnded(_ transitionCompleted: Bool) {
        // clean up
    }
}

// MARK: - Animations
fileprivate extension BaseTransitioningAnimator {
    
    /** Non-interactive transitioning animation */
    func animateTranstion(isPresentation: Bool, using transitionContext: UIViewControllerContextTransitioning) throws -> Void {
        
        if isPresentation {
            try self.animatePresentationalTransition(using: transitionContext)
        }
        else {
            try self.animateDismissalTransition(using: transitionContext)
        }
    }
    
    func animatePresentationalTransition(using transitionContext: UIViewControllerContextTransitioning) throws {
        // Get the set of relevant objects.
        let containerView: UIView = self.containerView(using: transitionContext)
        let toView: UIView = try self.toView(using: transitionContext)
        let (toView_StartFrame, toView_FinalFrame) = try self.toView_presentationalAnimationFrames(using: transitionContext)
        
        // Always add the "to" view to the container. And it doesn't hurt to set its start frame.
        containerView.addSubview(toView)
        toView.frame = toView_StartFrame
        
        // Animate using the animator's own duration value.
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            animations: { () -> Void in
                toView.frame = toView_FinalFrame
        },
            completion: { (finished: Bool) -> Void in
                let transitionWasCancelled: Bool = transitionContext.transitionWasCancelled
                
                // After a failed presentation remove the view.
                if (transitionWasCancelled) {
                    toView.removeFromSuperview()
                }
                
                // Notify UIKit that the transition has finished
                transitionContext.completeTransition(!transitionWasCancelled)
        })
    }
    
    func animateDismissalTransition(using transitionContext: UIViewControllerContextTransitioning) throws {
        // Get the set of relevant objects.
        let toVC: UIViewController = try self.toViewController(using: transitionContext)
        let fromVC: UIViewController = try self.fromViewController(using: transitionContext)
        
        // try to obtain the `toView` either from `toVC`, or via `transitionContext` `viewForKey(UITransitionContextToViewKey)`
        let toView: UIView = {
            if let validToView = try? self.toView(using: transitionContext) {
                return validToView
            }
            else {
                return toVC.view
            }
        }()
        
        let fromView: UIView = {
            if let validFromView = try? self.fromView(using: transitionContext) {
                return validFromView
            }
            else {
                return fromVC.view
            }
        }()
        
        // Set up some variables for the animation.
        let (_, toView_FinalFrame) = try self.toView_dismissalAnimationFrames(using: transitionContext)
        let (_, fromView_FinalFrame) = try self.fromView_dismissalAnimationFrames(using: transitionContext)
        
        // Always add the "to" view to the container. And it doesn't hurt to set its start frame.
        /** we don't need to add the `toView` if it is already added - this is dismissal animation */
        /*
         containerView.addSubview(toView)
         containerView.addSubview(fromView)
         */
        toView.frame = toView_FinalFrame
        
        // Animate using the animator's own duration value.
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            animations: { () -> Void in
                fromView.frame = fromView_FinalFrame
        },
            completion: { (finished: Bool) -> Void in
                let transitionWasCancelled: Bool = transitionContext.transitionWasCancelled
                
                // After a successful dismissal remove the view.
                if (!transitionWasCancelled) {
                    /** we don't need to remove the `toView` if it is not added */
                    //                    toView.removeFromSuperview()
                }
                
                // Notify UIKit that the transition has finished
                transitionContext.completeTransition(!transitionWasCancelled)
        })
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
