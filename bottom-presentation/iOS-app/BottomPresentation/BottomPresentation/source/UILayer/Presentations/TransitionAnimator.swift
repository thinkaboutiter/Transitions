//
//  TransitionAnimator.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

protocol TransitionAnimator: UIViewControllerAnimatedTransitioning {
    var direction: PresentationDirection { get }
    var isPresentation: Bool { get }
    var interactor: TransitionInteractor? { get }
}

struct TransitionAnimatorFactory {
    static func animator(for direction: PresentationDirection,
                         isPresentation: Bool) -> TransitionAnimator
    {
        return TransitionAnimatorImpl(direction: direction,
                                      isPresentation: isPresentation,
                                      interactor: nil)
    }
    
    static func dismissalAnimator(for direction: PresentationDirection,
                                  with interactor: TransitionInteractor) -> TransitionAnimator
    {
        return TransitionAnimatorImpl(direction: direction,
                                      isPresentation: false,
                                      interactor: interactor)
    }
}

private class TransitionAnimatorImpl: NSObject, TransitionAnimator {
    
    // MARK: - TransitionAnimator protocol
    let direction: PresentationDirection
    let isPresentation: Bool
    private(set) var interactor: TransitionInteractor?
    
    // MARK: - Initializers
    init(direction: PresentationDirection,
         isPresentation: Bool,
         interactor: TransitionInteractor?)
    {
        self.direction = direction
        self.isPresentation = isPresentation
        self.interactor = interactor
        super.init()
        Logger.success.message("direction=\(self.direction)")
    }
    
    deinit {
        Logger.fatal.message("direction=\(self.direction)")
    }

    // MARK: - UIViewControllerAnimatedTransitioning protocol
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
private extension TransitionAnimatorImpl {
    
    enum Constants {
        static let transitionDuration: TimeInterval = 0.3
    }
}
