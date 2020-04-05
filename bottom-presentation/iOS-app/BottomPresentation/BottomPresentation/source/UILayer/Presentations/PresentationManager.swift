//
//  PresentationManager.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-05-Apr-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

protocol PresentationManager: UIViewControllerTransitioningDelegate {
    var direction: PresentationDirection { get }
    func setDirection(_ newValue: PresentationDirection)
}

struct PresentationManagerFactory {
    static func manager(direction: PresentationDirection) -> PresentationManager {
        return PresentationManagerImpl(direction: direction)
    }
}

private class PresentationManagerImpl: NSObject {
    
    // MARK: - Properties
    private(set) var direction: PresentationDirection
    func setDirection(_ newValue: PresentationDirection) {
        self.direction = newValue
    }
    
    // MARK: - Initialization
    init(direction: PresentationDirection) {
        self.direction = direction
        super.init()
    }
    
    deinit {
        Logger.fatal.message()
    }
}

extension PresentationManagerImpl: PresentationManager {
    
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
            TransitionAnimatorFactory.animator(direction: self.direction,
                                               isPresentation: true)
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator: TransitionAnimator =
            TransitionAnimatorFactory.animator(direction: self.direction,
                                               isPresentation: false)
        return animator
    }
}
