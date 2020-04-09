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
    var shouldCompleteTransition: Bool { get }
    func setViewController(_ newValue: UIViewController)
}

struct TransitionInteractorFactory {
    static func percentDrivenInteractor(for direction: PresentationDirection) -> TransitionInteractor {
        return PercentDrivenTransitionInteractor(direction: direction)
    }
}

private class PercentDrivenTransitionInteractor: UIPercentDrivenInteractiveTransition, TransitionInteractor, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    private(set) var isInteractionInProgress: Bool = false
    private(set) var shouldCompleteTransition: Bool = false
    private weak var viewController: UIViewController!
    func setViewController(_ newValue: UIViewController) {
        self.viewController = newValue
        self.prepareGestureRecognizer(in: newValue.view)
    }
    private let direction: PresentationDirection
    
    // MARK: - Initialization
    init(direction: PresentationDirection) {
        self.direction = direction
        super.init()
        Logger.success.message("direction=\(self.direction)")
    }
    
    deinit {
        Logger.fatal.message("direction=\(self.direction)")
    }
    
    // MARK: - Gesture setup
    private func prepareGestureRecognizer(in view: UIView) {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(self.handleGesture(_:)))
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view: UIView = gestureRecognizer.view else {
            return
        }
        let translation: CGPoint = gestureRecognizer.translation(in: gestureRecognizer.view)
        
        Logger.debug.message("==========================")
        Logger.debug.message("translation=\(translation)")
        
        var progress: CGFloat
        switch self.direction {
        case .top:
            progress = (-translation.y / view.bounds.height)
        case .left:
            progress = (-translation.x / view.bounds.width)
        case .bottom:
            progress = (translation.y / view.bounds.height)
        case .right:
            progress = (translation.x / view.bounds.width)
        }
        
        Logger.debug.message("real progress=\(progress)")
         
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        Logger.debug.message("computed progress=\(progress)")
        
        switch gestureRecognizer.state {
        case .began:
            self.isInteractionInProgress = true
            self.viewController.dismiss(animated: true, completion: nil)
        case .changed:
            self.shouldCompleteTransition = (Constants.completionRange ~= progress)
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
        static let completionRange: ClosedRange<CGFloat> = 0.35...1.0
    }
}
