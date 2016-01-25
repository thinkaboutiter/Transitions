//
//  TransitioningAnimators.swift
//  Transitions
//
//  Created by Boyan Yankov on 13/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit
import SimpleLogger

enum TransitioningAnimatorError: ErrorType {
    case GeneralError (errorReason: String)
}

enum TransitioningDirection: UInt {
    case Left
    case Right
    case Up
    case Down
}

// MARK: - BaseTransitioningAnimator

class BaseTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private(set) var isPresenting: Bool = false
    
    /** Chainable */
    func shouldPresentViewController(isPresenting: Bool) -> BaseTransitioningAnimator {
        self.isPresenting = isPresenting
        return self
    }
    
    // MARK: UIViewControllerAnimatedTransitioning protocol
    
    /** This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to synchronize with the main animation. */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    /** This method can only be a nop if the transition is interactive and not a percentDriven interactive transition. */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // non-interactive animation
        do {
            try self.animateTranstion(isPresentation: self.isPresenting, withTransitionContext: transitionContext)
        }
        catch TransitioningAnimatorError.GeneralError(let errorReason) {
            Logger.logError("\(self) \(__FUNCTION__) » General TransitionError:", item: errorReason)
        }
        catch {
            Logger.logError("\(self) \(__FUNCTION__) » TransactionError:", item: error)
        }
    }
    
    /** This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked. */
    func animationEnded(transitionCompleted: Bool) {
        // clean up
    }
    
    // MARK: - Private
    
    /** Non-interactive transitioning animation */
    private func animateTranstion(isPresentation isPresentation: Bool, withTransitionContext transitionContext: UIViewControllerContextTransitioning) throws -> Void {
        
        if isPresentation {
            try self.animatePresentationalTransition(transitionContext)
        }
        else {
            try  self.animateDismissalTransition(transitionContext)
        }
    }
    
//    let horizontalAnimation: (UIViewControllerContextTransitioning) throws -> (CGRect) = { (transitionContext: UIViewControllerContextTransitioning) in
//        let containerView: UIView = try self.containerViewForContext(transitionContext)
//        let toVC: UIViewController = try self.toViewControllerForContext(transitionContext)
//        let toView: UIView = try self.toViewForContext(transitionContext)
//        
//        // Set up some variables for the animation.
//        var toView_StartFrame: CGRect = transitionContext.initialFrameForViewController(toVC)
//        let toView_FinalFrame: CGRect = transitionContext.finalFrameForViewController(toVC)
//        
//        // Set up the animation parameters.
//        toView_StartFrame.origin.x = CGRectGetWidth(containerView.frame)
//        toView_StartFrame.origin.y = CGRectGetHeight(containerView.frame)
//        
//        return toView_StartFrame
//    }
    
    // MARK: Presentation
    
    private func animatePresentationalTransition(transitionContext: UIViewControllerContextTransitioning) throws {
        // Get the set of relevant objects.
        let containerView: UIView = try self.containerViewForContext(transitionContext)
        let toView: UIView = try self.toViewForContext(transitionContext)
        let (toView_StartFrame, toView_FinalFrame) = try self.toView_PresentationalAnimationFrames(transitionContext)
        
        // Always add the "to" view to the container. And it doesn't hurt to set its start frame.
        containerView.addSubview(toView)
        toView.frame = toView_StartFrame
        
        // Animate using the animator's own duration value.
        UIView.animateWithDuration(
            self.transitionDuration(transitionContext),
            animations: { () -> Void in
                toView.frame = toView_FinalFrame
            },
            completion: { (finished: Bool) -> Void in
                let transitionWasCancelled: Bool = transitionContext.transitionWasCancelled()
                
                // After a failed presentation remove the view.
                if (transitionWasCancelled) {
                    toView.removeFromSuperview()
                }
                
                // Notify UIKit that the transition has finished
                transitionContext.completeTransition(!transitionWasCancelled)
            })
    }
    
    // MARK: Dismissal
    
    private func animateDismissalTransition(transitionContext: UIViewControllerContextTransitioning) throws {
        // Get the set of relevant objects.
        let toVC: UIViewController = try self.toViewControllerForContext(transitionContext)
        let fromVC: UIViewController = try self.fromViewControllerForContext(transitionContext)
        
        // try to obtain the `toView` either from `toVC`, or via `transitionContext` `viewForKey(UITransitionContextToViewKey)`
        let toView: UIView = {
            if let validToView = try? self.toViewForContext(transitionContext) {
                return validToView
            }
            else {
                return toVC.view
            }
        }()
        
        let fromView: UIView = {
            if let validFromView = try? self.fromViewForContext(transitionContext) {
                return validFromView
            }
            else {
                return fromVC.view
            }
        }()
        
        // Set up some variables for the animation.
        let (_, toView_FinalFrame) = try self.toView_DismissalAnimationFrames(transitionContext)
        let (_, fromView_FinalFrame) = try self.fromView_DismissalAnimationFrames(transitionContext)
        
        // Always add the "to" view to the container. And it doesn't hurt to set its start frame.
        /** we don't need to add the `toView` if it is already added - this is dismissal animation */
/*
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
*/
        toView.frame = toView_FinalFrame
        
        // Animate using the animator's own duration value.
        UIView.animateWithDuration(
            self.transitionDuration(transitionContext),
            animations: { () -> Void in
                fromView.frame = fromView_FinalFrame
            },
            completion: { (finished: Bool) -> Void in
                let transitionWasCancelled: Bool = transitionContext.transitionWasCancelled()
                
                // After a successful dismissal remove the view.
                if (!transitionWasCancelled) {
                    /** we don't need to remove the `toView` if it is not added */
//                    toView.removeFromSuperview()
                }
                
                // Notify UIKit that the transition has finished
                transitionContext.completeTransition(!transitionWasCancelled)
        })
    }
    
    // MARK: - Animation objects (helpers)
    // MARK: Frames
    private func toView_PresentationalAnimationFrames(transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`toView_PresentationalAnimationFrames(_:)` has not been implemented")
    }
    
    private func toView_DismissalAnimationFrames(transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`toView_DismissalAnimationFrames(_:)` has not been implemented")
    }
    
    private func fromView_DismissalAnimationFrames(transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`fromView_DismissalAnimationFrames(_:)` has not been implemented")
    }
    
    // MARK: containerView
    
    private func containerViewForContext(transitionContext: UIViewControllerContextTransitioning) throws -> UIView {
        guard let validContainerView: UIView = transitionContext.containerView() else {
            throw TransitioningAnimatorError.GeneralError(errorReason: "`transitionContext` has no `containerView`")
        }
        return validContainerView
    }
    
    // MARK: toViewController
    
    private func toViewControllerForContext(transitionContext: UIViewControllerContextTransitioning) throws -> UIViewController {
        guard let validToVC: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
            throw TransitioningAnimatorError.GeneralError(errorReason: "`transitionContext` has no `ToViewController`")
        }
        return validToVC
    }
    
    // MARK: toView
    
    private func toViewForContext(transitionContext: UIViewControllerContextTransitioning) throws -> UIView {
        guard let validToView: UIView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            throw TransitioningAnimatorError.GeneralError(errorReason: "`transitionContext` has no `ToView`")
        }
        return validToView
    }
    
    // MARK: fromViewController
    
    private func fromViewControllerForContext(transitionContext: UIViewControllerContextTransitioning) throws -> UIViewController {
        guard let validFromVC: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            throw TransitioningAnimatorError.GeneralError(errorReason: "`transitionContext`has no `FromViewController`")
        }
        return validFromVC
    }
    
    // MARK: fromView
    
    private func fromViewForContext(transitionContext: UIViewControllerContextTransitioning) throws -> UIView {
        guard let validFromView: UIView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
            throw TransitioningAnimatorError.GeneralError(errorReason: "`transitionContext` has no `FromView`")
        }
        return validFromView
    }
}

// MARK: - AxialTransitioningAnimator

class AxialTransitioningAnimator: BaseTransitioningAnimator {
    let transitioningDirection: TransitioningDirection
    
    // MARK: Initializers
    
    init(withTransitioningDirection transitioningDirection: TransitioningDirection) {
        self.transitioningDirection = transitioningDirection
        super.init()
    }
    
    // MARK: - Animation objects (helpers)
    // MARK: Presentation
    
    private override func toView_PresentationalAnimationFrames(transitionContext: UIViewControllerContextTransitioning) throws -> ( CGRect, CGRect) {
        
        // Get the set of relevant objects.
        let containerView: UIView = try self.containerViewForContext(transitionContext)
        let toVC: UIViewController = try self.toViewControllerForContext(transitionContext)
        
        var toView_InitialFrame: CGRect
        let toView_FinalFrame: CGRect = transitionContext.finalFrameForViewController(toVC)
        
        switch self.transitioningDirection {
        case .Left:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrameForViewController(toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.x = CGRectGetWidth(containerView.frame)
            toView_InitialFrame.size.width = CGRectGetWidth(toVC.view.frame)
            toView_InitialFrame.size.height = CGRectGetHeight(toVC.view.frame)
            
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Left Transition `toView_InitialFrame`:", item: toView_InitialFrame)
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Left Transition `toView_FinalFrame`:", item: toView_FinalFrame)
            
        case .Right:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrameForViewController(toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.x = -CGRectGetWidth(containerView.frame)
            toView_InitialFrame.size.width = CGRectGetWidth(toVC.view.frame)
            toView_InitialFrame.size.height = CGRectGetHeight(toVC.view.frame)
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Right Transition `toView_InitialFrame`:", item: toView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Right Transition `toView_FinalFrame`:", item: toView_FinalFrame)

            
        case .Up:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrameForViewController(toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.y = CGRectGetHeight(containerView.frame)
            toView_InitialFrame.size.width = CGRectGetWidth(toVC.view.frame)
            toView_InitialFrame.size.height = CGRectGetHeight(toVC.view.frame)
            
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Up Transition `toView_InitialFrame`:", item: toView_InitialFrame)
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Up Transition `toView_FinalFrame`:", item: toView_FinalFrame)
            
        case .Down:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrameForViewController(toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.y = -CGRectGetHeight(containerView.frame)
            toView_InitialFrame.size.width = CGRectGetWidth(toVC.view.frame)
            toView_InitialFrame.size.height = CGRectGetHeight(toVC.view.frame)
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Down Transition `toView_InitialFrame`:", item: toView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Down Transition `toView_FinalFrame`:", item: toView_FinalFrame)
        }
        
        return (toView_InitialFrame, toView_FinalFrame)
    }
    
    private override func toView_DismissalAnimationFrames(transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        // Get the set of relevant objects.
        let toVC: UIViewController = try self.toViewControllerForContext(transitionContext)
        let toView_InitialFrame: CGRect = transitionContext.initialFrameForViewController(toVC)
        let toView_FinalFrame: CGRect = transitionContext.finalFrameForViewController(toVC)
        
//        Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal Transition `toView_InitialFrame`:", item: toView_InitialFrame)
//        Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal Transition `toView_FinalFrame`:", item: toView_FinalFrame)
        
        return (toView_InitialFrame, toView_FinalFrame)
    }
    
    private override func fromView_DismissalAnimationFrames(transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        let containerView: UIView = try self.containerViewForContext(transitionContext)
        let toVC: UIViewController = try self.toViewControllerForContext(transitionContext)
        let fromVC: UIViewController = try self.fromViewControllerForContext(transitionContext)
        
        // try to obtain the `toView` either from `toVC`, or via `transitionContext` `viewForKey(UITransitionContextToViewKey)`
        let toView: UIView = {
            if let validToView = try? self.toViewForContext(transitionContext) {
                return validToView
            }
            else {
                return toVC.view
            }
        }()
        
        let fromView_InitialFrame: CGRect = transitionContext.initialFrameForViewController(fromVC)
        let fromView_FinalFrame: CGRect
        
        switch self.transitioningDirection {
        case .Left:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRectMake(
                CGRectGetWidth(containerView.frame),
                CGRectGetMinY(containerView.frame),
                CGRectGetWidth(toView.frame),
                CGRectGetHeight(toView.frame))
            
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Dismission.Left Transition `fromView_InitialFrame`:", item: fromView_InitialFrame)
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Dismission.Left Transition `fromView_FinalFrame`:", item: fromView_FinalFrame)
            
        case .Right:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRectMake(
                -CGRectGetWidth(containerView.frame),
                CGRectGetMinY(containerView.frame),
                CGRectGetWidth(toView.frame),
                CGRectGetHeight(toView.frame))
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismission.Right Transition `fromView_InitialFrame`:", item: fromView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismission.Right Transition `fromView_FinalFrame`:", item: fromView_FinalFrame)
            
        case .Up:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRectMake(
                CGRectGetMinX(containerView.frame),
                CGRectGetHeight(containerView.frame),
                CGRectGetWidth(toView.frame),
                CGRectGetHeight(toView.frame))
            
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal.Up Transition `fromView_InitialFrame`:", item: fromView_InitialFrame)
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal.Up Transition `fromView_FinalFrame`:", item: fromView_FinalFrame)
        
        case .Down:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRectMake(
                CGRectGetMinX(containerView.frame),
                -CGRectGetHeight(containerView.frame),
                CGRectGetWidth(toView.frame),
                CGRectGetHeight(toView.frame))
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal.Down Transition `fromView_InitialFrame`:", item: fromView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal.Down Transition `fromView_FinalFrame`:", item: fromView_FinalFrame)
        }
        
        return (fromView_InitialFrame, fromView_FinalFrame)
    }
}
