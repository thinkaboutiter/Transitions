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
    
    // MARK: - Initializers
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
}
