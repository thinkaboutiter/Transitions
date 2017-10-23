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

enum TransitioningAnimatorError: Error {
    case generalError (errorReason: String)
}

enum TransitioningDirection: UInt {
    case left
    case right
    case up
    case down
}

// MARK: - BaseTransitioningAnimator

class BaseTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate(set) var isPresenting: Bool = false
    
    /** Chainable */
    func shouldPresentViewController(_ isPresenting: Bool) -> BaseTransitioningAnimator {
        self.isPresenting = isPresenting
        return self
    }
    
    // MARK: UIViewControllerAnimatedTransitioning protocol
    
    /** This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to synchronize with the main animation. */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /** This method can only be a nop if the transition is interactive and not a percentDriven interactive transition. */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // non-interactive animation
        do {
            try self.animateTranstion(isPresentation: self.isPresenting, withTransitionContext: transitionContext)
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
    
    // MARK: - Private
    
    /** Non-interactive transitioning animation */
    fileprivate func animateTranstion(isPresentation: Bool, withTransitionContext transitionContext: UIViewControllerContextTransitioning) throws -> Void {
        
        if isPresentation {
            try self.animatePresentationalTransition(transitionContext)
        }
        else {
            try  self.animateDismissalTransition(transitionContext)
        }
    }
    
    // MARK: Presentation
    
    fileprivate func animatePresentationalTransition(_ transitionContext: UIViewControllerContextTransitioning) throws {
        // Get the set of relevant objects.
        let containerView: UIView = self.containerViewForContext(transitionContext)
        let toView: UIView = try self.toViewForContext(transitionContext)
        let (toView_StartFrame, toView_FinalFrame) = try self.toView_PresentationalAnimationFrames(transitionContext)
        
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
    
    // MARK: Dismissal
    
    fileprivate func animateDismissalTransition(_ transitionContext: UIViewControllerContextTransitioning) throws {
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
    
    // MARK: - Animation objects (helpers)
    // MARK: Frames
    fileprivate func toView_PresentationalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`toView_PresentationalAnimationFrames(_:)` has not been implemented")
    }
    
    fileprivate func toView_DismissalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`toView_DismissalAnimationFrames(_:)` has not been implemented")
    }
    
    fileprivate func fromView_DismissalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        fatalError("`fromView_DismissalAnimationFrames(_:)` has not been implemented")
    }
    
    // MARK: containerView
    
    fileprivate func containerViewForContext(_ transitionContext: UIViewControllerContextTransitioning) -> UIView {
        let validContainerView: UIView = transitionContext.containerView
        return validContainerView
    }
    
    // MARK: toViewController
    
    fileprivate func toViewControllerForContext(_ transitionContext: UIViewControllerContextTransitioning) throws -> UIViewController {
        guard let validToVC: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            throw TransitioningAnimatorError.generalError(errorReason: "`transitionContext` has no `ToViewController`")
        }
        return validToVC
    }
    
    // MARK: toView
    
    fileprivate func toViewForContext(_ transitionContext: UIViewControllerContextTransitioning) throws -> UIView {
        guard let validToView: UIView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            throw TransitioningAnimatorError.generalError(errorReason: "`transitionContext` has no `ToView`")
        }
        return validToView
    }
    
    // MARK: fromViewController
    
    fileprivate func fromViewControllerForContext(_ transitionContext: UIViewControllerContextTransitioning) throws -> UIViewController {
        guard let validFromVC: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            throw TransitioningAnimatorError.generalError(errorReason: "`transitionContext`has no `FromViewController`")
        }
        return validFromVC
    }
    
    // MARK: fromView
    
    fileprivate func fromViewForContext(_ transitionContext: UIViewControllerContextTransitioning) throws -> UIView {
        guard let validFromView: UIView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            throw TransitioningAnimatorError.generalError(errorReason: "`transitionContext` has no `FromView`")
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
    
    fileprivate override func toView_PresentationalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> ( CGRect, CGRect) {
        
        // Get the set of relevant objects.
        let containerView: UIView = self.containerViewForContext(transitionContext)
        let toVC: UIViewController = try self.toViewControllerForContext(transitionContext)
        
        var toView_InitialFrame: CGRect
        let toView_FinalFrame: CGRect = transitionContext.finalFrame(for: toVC)
        
        switch self.transitioningDirection {
        case .left:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.x = containerView.frame.width
            toView_InitialFrame.size.width = toVC.view.frame.width
            toView_InitialFrame.size.height = toVC.view.frame.height
            
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Left Transition `toView_InitialFrame`:", item: toView_InitialFrame)
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Left Transition `toView_FinalFrame`:", item: toView_FinalFrame)
            
        case .right:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.x = -containerView.frame.width
            toView_InitialFrame.size.width = toVC.view.frame.width
            toView_InitialFrame.size.height = toVC.view.frame.height
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Right Transition `toView_InitialFrame`:", item: toView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Right Transition `toView_FinalFrame`:", item: toView_FinalFrame)
            
        case .up:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.y = containerView.frame.height
            toView_InitialFrame.size.width = toVC.view.frame.width
            toView_InitialFrame.size.height = toVC.view.frame.height
            
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Up Transition `toView_InitialFrame`:", item: toView_InitialFrame)
            //            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Up Transition `toView_FinalFrame`:", item: toView_FinalFrame)
            
        case .down:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.y = -containerView.frame.height
            toView_InitialFrame.size.width = toVC.view.frame.width
            toView_InitialFrame.size.height = toVC.view.frame.height
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Down Transition `toView_InitialFrame`:", item: toView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Presentation.Down Transition `toView_FinalFrame`:", item: toView_FinalFrame)
        }
        
        return (toView_InitialFrame, toView_FinalFrame)
    }
    
    fileprivate override func toView_DismissalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        // Get the set of relevant objects.
        let toVC: UIViewController = try self.toViewControllerForContext(transitionContext)
        let toView_InitialFrame: CGRect = transitionContext.initialFrame(for: toVC)
        let toView_FinalFrame: CGRect = transitionContext.finalFrame(for: toVC)
        
//        Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal Transition `toView_InitialFrame`:", item: toView_InitialFrame)
//        Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal Transition `toView_FinalFrame`:", item: toView_FinalFrame)
        
        return (toView_InitialFrame, toView_FinalFrame)
    }
    
    fileprivate override func fromView_DismissalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        let containerView: UIView = self.containerViewForContext(transitionContext)
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
        
        let fromView_InitialFrame: CGRect = transitionContext.initialFrame(for: fromVC)
        let fromView_FinalFrame: CGRect
        
        switch self.transitioningDirection {
        case .left:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRect(
                x: containerView.frame.width,
                y: containerView.frame.minY,
                width: toView.frame.width,
                height: toView.frame.height)
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismission.Left Transition `fromView_InitialFrame`:", item: fromView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismission.Left Transition `fromView_FinalFrame`:", item: fromView_FinalFrame)
            
        case .right:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRect(
                x: -containerView.frame.width,
                y: containerView.frame.minY,
                width: toView.frame.width,
                height: toView.frame.height)
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismission.Right Transition `fromView_InitialFrame`:", item: fromView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismission.Right Transition `fromView_FinalFrame`:", item: fromView_FinalFrame)
            
        case .up:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRect(
                x: containerView.frame.minX,
                y: containerView.frame.height,
                width: toView.frame.width,
                height: toView.frame.height)
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal.Up Transition `fromView_InitialFrame`:", item: fromView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal.Up Transition `fromView_FinalFrame`:", item: fromView_FinalFrame)
        
        case .down:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRect(
                x: containerView.frame.minX,
                y: -containerView.frame.height,
                width: toView.frame.width,
                height: toView.frame.height)
            
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal.Down Transition `fromView_InitialFrame`:", item: fromView_InitialFrame)
//            Logger.logDebug("\(self) \(__FUNCTION__) » Dismissal.Down Transition `fromView_FinalFrame`:", item: fromView_FinalFrame)
        }
        
        return (fromView_InitialFrame, fromView_FinalFrame)
    }
}
