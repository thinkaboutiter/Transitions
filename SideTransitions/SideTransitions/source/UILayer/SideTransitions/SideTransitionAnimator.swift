//
//  SideTransitionAnimator.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

protocol SideTransitionAnimator: UIViewControllerAnimatedTransitioning {
    var direction: SideTransitionDirection { get }
    var isPresentation: Bool { get }
    var interactor: SideTransitionInteractor? { get }
}

struct SideTransitionAnimatorFactory {
    static func animator(for direction: SideTransitionDirection,
                         isPresentation: Bool) -> SideTransitionAnimator
    {
        return SideTransitionAnimatorImpl(direction: direction,
                                          isPresentation: isPresentation,
                                          interactor: nil)
    }
    
    static func dismissalAnimator(for direction: SideTransitionDirection,
                                  with interactor: SideTransitionInteractor) -> SideTransitionAnimator
    {
        return SideTransitionAnimatorImpl(direction: direction,
                                          isPresentation: false,
                                          interactor: interactor)
    }
}

private class SideTransitionAnimatorImpl: NSObject, SideTransitionAnimator {
    
    // MARK: - Constants
    private enum Constants {
        static let transitionDurationPresentation: TimeInterval = 0.25
        static let transitionDurationDismissal: TimeInterval = 0.5
    }
    
    // MARK: - SideTransitionAnimator protocol
    let direction: SideTransitionDirection
    let isPresentation: Bool
    private(set) var interactor: SideTransitionInteractor?
    
    // MARK: - Initializers
    init(direction: SideTransitionDirection,
         isPresentation: Bool,
         interactor: SideTransitionInteractor?)
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
        let result: TimeInterval
        if self.isPresentation {
            result = Constants.transitionDurationPresentation
        }
        else {
            result = Constants.transitionDurationDismissal
        }
        return result
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
                if !self.isPresentation,
                   let interactor = self.interactor
                {
                    self.completeDismissalAnimation(with: interactor,
                                                    using: transitionContext,
                                                    for: controller)
                }
                else {
                    self.completeNoneInteractiveAnimation(using: transitionContext,
                                                          for: controller,
                                                          shouldFinish: finished)
                }
            })
    }
    
    // MARK: - Animation Completion Utilites
    private func completeDismissalAnimation(with interactor: SideTransitionInteractor,
                                            using transitionContext: UIViewControllerContextTransitioning,
                                            for controller: UIViewController)
    {
        guard !self.isPresentation else {
            let message: String = "This animation is not supporting for presentation!"
            Logger.error.message(message)
            return
        }
        let shouldRemoveView: Bool
        let shouldCompleteTransition: Bool
        if transitionContext.transitionWasCancelled {
            shouldRemoveView = interactor.shouldCompleteTransition
            shouldCompleteTransition = interactor.shouldCompleteTransition
        }
        else {
            shouldRemoveView = true
            shouldCompleteTransition = true
        }
        if shouldRemoveView {
            controller.view.removeFromSuperview()
        }
        transitionContext.completeTransition(shouldCompleteTransition)
    }
    
    private func completeNoneInteractiveAnimation(using transitionContext: UIViewControllerContextTransitioning,
                                                  for controller: UIViewController,
                                                  shouldFinish finished: Bool)
    {
        if !self.isPresentation {
            controller.view.removeFromSuperview()
        }
        transitionContext.completeTransition(finished)
    }
}
