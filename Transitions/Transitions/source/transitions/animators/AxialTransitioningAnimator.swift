//
//  AxialTransitioningAnimator.swift
//  Transitions
//
//  Created by Boyan Yankov on 13/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

class AxialTransitioningAnimator: BaseTransitioningAnimator {
    let transitioningDirection: TransitioningDirection
    
    // MARK: Initializers
    init(withTransitioningDirection transitioningDirection: TransitioningDirection) {
        self.transitioningDirection = transitioningDirection
        super.init()
    }
    
    // MARK: - Animations
    // MARK: Presentation
    override func toView_presentationalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        
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
            
        case .right:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.x = -containerView.frame.width
            toView_InitialFrame.size.width = toVC.view.frame.width
            toView_InitialFrame.size.height = toVC.view.frame.height
            
        case .up:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.y = containerView.frame.height
            toView_InitialFrame.size.width = toVC.view.frame.width
            toView_InitialFrame.size.height = toVC.view.frame.height
            
        case .down:
            // Set up some variables for the animation.
            toView_InitialFrame = transitionContext.initialFrame(for: toVC)
            
            // Set up the animation parameters.
            toView_InitialFrame.origin.y = -containerView.frame.height
            toView_InitialFrame.size.width = toVC.view.frame.width
            toView_InitialFrame.size.height = toVC.view.frame.height
        }
        
        return (toView_InitialFrame, toView_FinalFrame)
    }
    
    override func toView_dismissalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
        // Get the set of relevant objects.
        let toVC: UIViewController = try self.toViewControllerForContext(transitionContext)
        let toView_InitialFrame: CGRect = transitionContext.initialFrame(for: toVC)
        let toView_FinalFrame: CGRect = transitionContext.finalFrame(for: toVC)
        
        return (toView_InitialFrame, toView_FinalFrame)
    }
    
    override func fromView_dismissalAnimationFrames(_ transitionContext: UIViewControllerContextTransitioning) throws -> (CGRect, CGRect) {
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
            fromView_FinalFrame = CGRect(x: containerView.frame.width,
                                         y: containerView.frame.minY,
                                         width: toView.frame.width,
                                         height: toView.frame.height)
            
        case .right:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRect(x: -containerView.frame.width,
                                         y: containerView.frame.minY,
                                         width: toView.frame.width,
                                         height: toView.frame.height)
            
        case .up:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRect(x: containerView.frame.minX,
                                         y: containerView.frame.height,
                                         width: toView.frame.width,
                                         height: toView.frame.height)
            
        case .down:
            // Set up some variables for the animation.
            fromView_FinalFrame = CGRect(x: containerView.frame.minX,
                                         y: -containerView.frame.height,
                                         width: toView.frame.width,
                                         height: toView.frame.height)

        }
        
        return (fromView_InitialFrame, fromView_FinalFrame)
    }
}
