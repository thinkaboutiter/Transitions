//
//  TransitioningManager.swift
//  BottomPresentation
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
    }
    
    deinit {
        Logger.fatal.message()
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
        let controller: AnimatedTransitioningController =
            AnimatedTransitioningControllerFactory.controller(for: self.direction,
                                                              isPresentation: true)
        return controller
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller: AnimatedTransitioningController =
            AnimatedTransitioningControllerFactory.controller(for: self.direction,
                                                              isPresentation: false)
        return controller
    }
}
