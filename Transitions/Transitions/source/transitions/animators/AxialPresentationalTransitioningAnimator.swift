//
//  AxialPresentationalTransitioningAnimator.swift
//  Transitions
//
//  Created by boyankov on W43 25/Oct/2017 Wed.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import UIKit

class AxialPresentationalTransitioningAnimator: BaseTransitioningAnimator {

    // MARK: - Properties
    override var isPresenting: Bool {
        return true
    }
    
    let transitioningDirection: TransitioningDirection
    
    // MARK: - Initialization
    init(withTransitioningDirection transitioningDirection: TransitioningDirection) {
        self.transitioningDirection = transitioningDirection
        super.init()
    }
    
    // MARK: - Presentational animation frames
    override func toView_presentationalAnimationFrames(using transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        
        // Get the set of relevant objects.
        let containerView: UIView = self.containerView(using: transitionContext)
        let toVC: UIViewController = try self.toViewController(using: transitionContext)
        
        var toView_initialFrame: CGRect
        let toView_finalFrame: CGRect = transitionContext.finalFrame(for: toVC)
        
        switch self.transitioningDirection {
        case .left:
            // Set up some variables for the animation.
            toView_initialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_initialFrame.origin.x = containerView.frame.width
            toView_initialFrame.size.width = toVC.view.frame.width
            toView_initialFrame.size.height = toVC.view.frame.height
            
        case .right:
            // Set up some variables for the animation.
            toView_initialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_initialFrame.origin.x = -containerView.frame.width
            toView_initialFrame.size.width = toVC.view.frame.width
            toView_initialFrame.size.height = toVC.view.frame.height
            
        case .up:
            // Set up some variables for the animation.
            toView_initialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_initialFrame.origin.y = containerView.frame.height
            toView_initialFrame.size.width = toVC.view.frame.width
            toView_initialFrame.size.height = toVC.view.frame.height
            
        case .down:
            // Set up some variables for the animation.
            toView_initialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_initialFrame.origin.y = -containerView.frame.height
            toView_initialFrame.size.width = toVC.view.frame.width
            toView_initialFrame.size.height = toVC.view.frame.height
        }
        
        return (toView_initialFrame, toView_finalFrame)
    }
    
    // MARK: - Animations
    override func animatePresentationalTransition(using transitionContext: UIViewControllerContextTransitioning) throws {
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
}
