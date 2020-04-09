//
//  SideTransitioningManager.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W14-05-Apr-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

protocol SideTransitioningManager: UIViewControllerTransitioningDelegate {
    var direction: SideTransitionDirection { get }
    func setDirection(_ newValue: SideTransitionDirection)
}

struct SideTransitioningManagerFactory {
    static func manager(for direction: SideTransitionDirection) -> SideTransitioningManager {
        return SideTransitioningManagerImpl(direction: direction)
    }
}

private class SideTransitioningManagerImpl: NSObject {
    
    // MARK: - Properties
    private(set) var direction: SideTransitionDirection
    func setDirection(_ newValue: SideTransitionDirection) {
        self.direction = newValue
    }
    
    // MARK: - Initialization
    init(direction: SideTransitionDirection) {
        self.direction = direction
        super.init()
        Logger.success.message("direction=\(direction)")
    }
    
    deinit {
        Logger.fatal.message("direction=\(self.direction)")
    }
}

// MARK: - SideTransitioningManager protocol
extension SideTransitioningManagerImpl: SideTransitioningManager {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController?
    {
        let controller: SidePresentationController =
            SidePresentationController(presentedViewController: presented,
                                   presenting: presenting,
                                   direction: self.direction)
        return controller
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let animator: SideTransitionAnimator =
            SideTransitionAnimatorFactory.animator(for: self.direction,
                                                   isPresentation: true)
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator: SideTransitionAnimator
        if let provider: SideTransitionInteractorProvider = dismissed as? SideTransitionInteractorProvider {
            let interactor: SideTransitionInteractor = provider.sideTransitionInteractor()
            animator = SideTransitionAnimatorFactory.dismissalAnimator(for: self.direction,
                                                                       with: interactor)
        }
        else {
            animator = SideTransitionAnimatorFactory.animator(for: self.direction,
                                                              isPresentation: false)
        }
        return animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transitionAnimator: SideTransitionAnimator = animator as? SideTransitionAnimator else {
            let message: String = "Unable to obtain valid \(String(describing: SideTransitionAnimator.self)) object!"
            Logger.error.message(message)
            return nil
        }
        guard let interactor: SideTransitionInteractor = transitionAnimator.interactor else {
            let message: String = "Unable to obtain valid \(String(describing: SideTransitionInteractor.self)) object!"
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
