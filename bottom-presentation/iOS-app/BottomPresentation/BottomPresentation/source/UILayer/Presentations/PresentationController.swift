//
//  PresentationController.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-05-Apr-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

class PresentationController: UIPresentationController {
    
    // MARK: - Properties
    private let direction: PresentationDirection
    private lazy var dimmingView: UIView = {
//        let effect: UIBlurEffect = UIBlurEffect.init(style: .dark)
//        let result: UIVisualEffectView = UIVisualEffectView(effect: effect)
        let result: UIView = UIView()
        result.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        result.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGestureRecognizer: UITapGestureRecognizer =
        UITapGestureRecognizer(target: self,
                               action: #selector(self.handleTap(recognizer:)))
        result.addGestureRecognizer(tapGestureRecognizer)
        result.isUserInteractionEnabled = true
        result.alpha = 0.0
        return result
    }()
    override var frameOfPresentedViewInContainerView: CGRect {
        var result: CGRect = .zero
        guard let containerView: UIView = self.containerView else {
            assert(false, "Invalid containerView object!")
            return result
        }
        result.size = self.size(forChildContentContainer: self.presentedViewController,
                                withParentContainerSize: containerView.bounds.size)
        switch self.direction {
        case .right(let coverage):
            result.origin.x = containerView.frame.width * (1.0 - CGFloat(coverage.rawValue))
        case .bottom(let coverage):
            result.origin.y = containerView.frame.height * (1.0 - CGFloat(coverage.rawValue))
        default:
            break
        }
        return result
    }
    
    // MARK: - Initialization
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         direction: PresentationDirection)
    {
        self.direction = direction
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        Logger.success.message("direction=\(self.direction)")
    }
    
    deinit {
        Logger.fatal.message("direction=\(self.direction)")
    }
    
    // MARK: - Customization
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize
    {
        let result: CGSize
        switch self.direction {
        case .left(let coverage):
            result = CGSize(width: parentSize.width * CGFloat(coverage.rawValue),
                            height: parentSize.height)
        case .right(let coverage):
            result = CGSize(width: parentSize.width * CGFloat(coverage.rawValue),
                            height: parentSize.height)
        case .top(let coverage):
            result = CGSize(width: parentSize.width,
                            height: parentSize.height * CGFloat(coverage.rawValue))
        case .bottom(let coverage):
            result = CGSize(width: parentSize.width,
                            height: parentSize.height * CGFloat(coverage.rawValue))
        }
        return result
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView: UIView = self.containerView else {
            assert(false, "Invalid containerView object!")
            return
        }
        self.dimmingView.frame = containerView.bounds
        containerView.insertSubview(self.dimmingView, at: 0)
        let reveal: (UIView) -> Void = { view in
            view.alpha = 1.0
        }
        guard let coordinator: UIViewControllerTransitionCoordinator = self.presentedViewController.transitionCoordinator else {
            reveal(self.dimmingView)
            return
        }
        coordinator.animate(
            alongsideTransition: { _ in
                reveal(self.dimmingView)
        },
            completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        let conceal: (UIView) -> Void = { view in
            view.alpha = 0.0
        }
        guard let coordinator: UIViewControllerTransitionCoordinator = self.presentedViewController.transitionCoordinator else {
            conceal(self.dimmingView)
            return
        }
        coordinator.animate(
            alongsideTransition: { _ in
                conceal(self.dimmingView)
        },
            completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        self.presentedView?.layer.masksToBounds = true
        self.presentedView?.layer.cornerRadius = Constants.presentedViewCornerRadius
    }
    
    // MARK: - Gestures
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.presentingViewController.dismiss(animated: true,
                                              completion: nil)
    }
}

// MARK: - Constants
private extension PresentationController {
    enum Constants {
        static let presentedViewCornerRadius: CGFloat = 16
    }
}
