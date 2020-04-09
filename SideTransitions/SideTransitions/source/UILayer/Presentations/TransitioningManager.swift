//
//  TransitioningManager.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W14-05-Apr-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

protocol TransitioningManager: UIViewControllerTransitioningDelegate {
    var direction: PresentationDirection { get }
    func setDirection(_ newValue: PresentationDirection)
}

struct TransitioningManagerFactory {
    static func manager(for direction: PresentationDirection) -> TransitioningManager {
        return TransitioningManagerImpl(direction: direction)
    }
}

private class TransitioningManagerImpl: NSObject {
    
    // MARK: - Properties
    private(set) var direction: PresentationDirection
    func setDirection(_ newValue: PresentationDirection) {
        self.direction = newValue
    }
    
    // MARK: - Initialization
    init(direction: PresentationDirection) {
        self.direction = direction
        super.init()
        Logger.success.message("direction=\(direction)")
    }
    
    deinit {
        Logger.fatal.message("direction=\(self.direction)")
    }
}

extension TransitioningManagerImpl: TransitioningManager {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController?
    {
        let controller: PresentationController =
            PresentationController(presentedViewController: presented,
                                   presenting: presenting,
                                   direction: self.direction)
        return controller
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let animator: TransitionAnimator =
            TransitionAnimatorFactory.animator(for: self.direction,
                                               isPresentation: true)
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator: TransitionAnimator
        if let provider: TransitionInteractorProvider = dismissed as? TransitionInteractorProvider {
            let interactor: TransitionInteractor = provider.transitionInteractor()
            animator = TransitionAnimatorFactory.dismissalAnimator(for: self.direction,
                                                                   with: interactor)
        }
        else {
            animator = TransitionAnimatorFactory.animator(for: self.direction,
                                                          isPresentation: false)
        }
        return animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transitionAnimator: TransitionAnimator = animator as? TransitionAnimator else {
            let message: String = "Unable to obtain valid \(String(describing: TransitionAnimator.self)) object!"
            Logger.error.message(message)
            return nil
        }
        guard let interactor: TransitionInteractor = transitionAnimator.interactor else {
            let message: String = "Unable to obtain valid \(String(describing: TransitionInteractor.self)) object!"
            Logger.error.message(message)
            return nil
        }
        guard interactor.isInteractionInProgress else {
            let message: String = "Interaction is not in progress!"
            Logger.error.message(message)
            return nil
        }
        return interactor
    }
}
