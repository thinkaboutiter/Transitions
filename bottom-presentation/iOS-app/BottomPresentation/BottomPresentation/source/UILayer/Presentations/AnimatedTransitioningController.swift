//
//  AnimatedTransitioningController.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

protocol AnimatedTransitioningController: UIViewControllerAnimatedTransitioning {
    var direction: PresentationDirection { get }
    var isPresentation: Bool { get }
}

struct AnimatedTransitioningControllerFactory {
    static func controller(for direction: PresentationDirection,
                           isPresentation: Bool) -> AnimatedTransitioningController
    {
        return AnimatedTransitioningControllerImpl(direction: direction,
                                      isPresentation: isPresentation)
    }
}

private class AnimatedTransitioningControllerImpl: NSObject {
    
    // MARK: - Properties
    let direction: PresentationDirection
    let isPresentation: Bool
    
    // MARK: - Initializers
    init(direction: PresentationDirection,
         isPresentation: Bool)
    {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
}

// MARK: - AnimatedTransitioningController protocol
extension AnimatedTransitioningControllerImpl: AnimatedTransitioningController {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = self.isPresentation ? .to : .from
        guard let controller: UIViewController = transitionContext.viewController(forKey: key) else {
            return
        }
        if self.isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame: CGRect = transitionContext.finalFrame(for: controller)
        var dismissedFrame: CGRect = presentedFrame
        
        switch self.direction {
        case .left:
            dismissedFrame.origin.x = -transitionContext.containerView.frame.size.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -transitionContext.containerView.frame.size.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
        let initialFrame: CGRect = self.isPresentation ? dismissedFrame : presentedFrame
        let finalFrame: CGRect = self.isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration: TimeInterval = self.transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                controller.view.frame = finalFrame
        },
            completion: { finished in
                if !self.isPresentation {
                    controller.view.removeFromSuperview()
                }
                transitionContext.completeTransition(finished)
        })
    }
}

// MARK: - Constants
private extension AnimatedTransitioningControllerImpl {
    
    enum Constants {
        static let transitionDuration: TimeInterval = 0.3
    }
}
