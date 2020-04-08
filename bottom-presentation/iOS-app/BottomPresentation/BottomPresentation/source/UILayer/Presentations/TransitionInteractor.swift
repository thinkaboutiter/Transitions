//
//  TransitionInteractor.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W15-08-Apr-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

protocol TransitionInteractorProvider: AnyObject {
    func transitionInteractor() -> TransitionInteractor
}

protocol TransitionInteractor: UIViewControllerInteractiveTransitioning {
    var isInteractionInProgress: Bool { get }
}

struct TransitionInteractorFactory {
    static func percentDrivenInteractor(for viewController: UIViewController) -> TransitionInteractor {
        return PercentDrivenTransitionInteractor(viewController: viewController)
    }
}

private class PercentDrivenTransitionInteractor: UIPercentDrivenInteractiveTransition, TransitionInteractor {
    
    // MARK: - Properties
    private(set) var isInteractionInProgress: Bool = false
    private var shouldCompleteTransition: Bool = false
    private weak var viewController: UIViewController!
    
    // MARK: - Initialization
    override init() {
        super.init()
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - Gesture setup
    private func prepareGestureRecognizer(in view: UIView) {
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                          action: #selector(self.handleGesture(_:)))
        recognizer.edges = .left
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation: CGPoint = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress: CGFloat = (translation.x / Constants.progressRatio)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            self.isInteractionInProgress = true
            self.viewController.dismiss(animated: true, completion: nil)
        case .changed:
            self.shouldCompleteTransition = progress > Constants.progressThreshold
            self.update(progress)
        case .cancelled:
            self.isInteractionInProgress = false
            self.cancel()
        case .ended:
            self.isInteractionInProgress = false
            if self.shouldCompleteTransition {
                self.finish()
            }
            else {
                self.cancel()
            }
        default:
            break
        }
    }
}

// MARK: - Constants
private extension PercentDrivenTransitionInteractor {
    
    enum Constants {
        static let progressRatio: CGFloat = 200
        static let progressThreshold: CGFloat = 0.5
    }
}
