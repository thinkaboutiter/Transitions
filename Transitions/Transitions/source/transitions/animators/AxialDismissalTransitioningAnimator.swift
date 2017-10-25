//
//  AxialDismissalTransitioningAnimator.swift
//  Transitions
//
//  Created by boyankov on W43 25/Oct/2017 Wed.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import UIKit

class AxialDismissalTransitioningAnimator: BaseTransitioningAnimator {

    // MARK: - Properties
    override var isPresenting: Bool {
        return false
    }
    
    let transitioningDirection: TransitioningDirection
    
    // MARK: - Initialization
    init(withTransitioningDirection transitioningDirection: TransitioningDirection) {
        self.transitioningDirection = transitioningDirection
        super.init()
    }
    
    // MARK: - Dismissal animation frames
    override func toView_dismissalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        // Get the set of relevant objects.
        let toVC: UIViewController = try self.toViewController(using: transitionContext)
        let toView_initialFrame: CGRect = transitionContext.initialFrame(for: toVC)
        let toView_finalFrame: CGRect = transitionContext.finalFrame(for: toVC)
        
        return (toView_initialFrame, toView_finalFrame)
    }
    
    override func fromView_dismissalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        let containerView: UIView = self.containerView(using: transitionContext)
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
        
        let fromView_initialFrame: CGRect = transitionContext.initialFrame(for: fromVC)
        let fromView_finalFrame: CGRect
        
        switch self.transitioningDirection {
        case .left:
            // Set up some variables for the animation.
            fromView_finalFrame = CGRect(x: containerView.frame.width,
                                         y: containerView.frame.minY,
                                         width: toView.frame.width,
                                         height: toView.frame.height)
            
        case .right:
            // Set up some variables for the animation.
            fromView_finalFrame = CGRect(x: -containerView.frame.width,
                                         y: containerView.frame.minY,
                                         width: toView.frame.width,
                                         height: toView.frame.height)
            
        case .up:
            // Set up some variables for the animation.
            fromView_finalFrame = CGRect(x: containerView.frame.minX,
                                         y: containerView.frame.height,
                                         width: toView.frame.width,
                                         height: toView.frame.height)
            
        case .down:
            // Set up some variables for the animation.
            fromView_finalFrame = CGRect(x: containerView.frame.minX,
                                         y: -containerView.frame.height,
                                         width: toView.frame.width,
                                         height: toView.frame.height)
            
        }
        
        return (fromView_initialFrame, fromView_finalFrame)
    }
    
    // MARK: - Animations
    override func animateDismissalTransition(using transitionContext: UIViewControllerContextTransitioning) throws {
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
