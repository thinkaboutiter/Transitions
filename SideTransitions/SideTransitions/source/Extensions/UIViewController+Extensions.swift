//
//  UIViewController+Extensions.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

// MARK: - Embedding
extension UIViewController {
    
    /// Embeds a child view controller.
    /// - Parameters:
    ///   - child: the child view controller that we want to embed.
    ///   - containerView: the container view into which `child` view controller's view will be added as subview.
    ///   - positionChildViewIntoContainerView: configuration function to position `child` view controller's view into passed `containerView`. Caller is also responsible to add `child` view controller's view as subview of passed `containerView`. Defaults to `nil` which will add `child` view controller's view fully constraint to passed `containerView`.
    func embed(_ child: UIViewController,
               containerView: UIView,
               positionChildViewIntoContainerView:((_ childView: UIView, _ containerView: UIView) -> Void)? = nil) throws
    {
        guard child.parent == nil else {
            let error: NSError = NSError(domain: EmbeddingError.domain,
                                         code: EmbeddingError.CodeDescription.parentNotNil.code,
                                         userInfo: [
                                            NSLocalizedDescriptionKey: EmbeddingError.CodeDescription.parentNotNil.description
            ])
            throw error
        }
        self.addChild(child)
        if let _ = positionChildViewIntoContainerView {
            positionChildViewIntoContainerView!(child.view, containerView)
            guard child.view.superview === containerView else {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                let error: NSError = NSError(domain: EmbeddingError.domain,
                                             code: EmbeddingError.CodeDescription.containerViewIsNotUsedAsSuperView.code,
                                             userInfo: [
                                                NSLocalizedDescriptionKey: EmbeddingError.CodeDescription.containerViewIsNotUsedAsSuperView.description
                ])
                throw error
            }
            child.didMove(toParent: self)
        }
        else {
            containerView.addSubview(child.view)
            child.view.translatesAutoresizingMaskIntoConstraints = false
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            child.didMove(toParent: self)
        }
    }
    
    /// Removes a child view controller.
    /// - Parameter child: the child view controller that we want to remove.
    func remove(_ child: UIViewController) throws {
        guard child.parent === self else {
            let error: NSError = NSError(domain: EmbeddingError.domain,
                                         code: EmbeddingError.CodeDescription.childHasDifferentParent.code,
                                         userInfo: [
                                            NSLocalizedDescriptionKey: EmbeddingError.CodeDescription.childHasDifferentParent.description
            ])
            throw error
        }
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    /// Caseless container for all constants and subtypes used to describe embedding errors.
    private enum EmbeddingError {
        static let domain: String = "UIViewController.Embedding"
        
        /// Caseless container of tuples containing error code and description.
        enum CodeDescription {
            static let parentNotNil: (code: Int, description: String)
                = (9001, "Trying to embed a view controller that already has its parent set!")
            static let containerViewIsNotUsedAsSuperView: (code: Int, description: String)
                = (9002, "Passed container_view is not used as child's super_view!")
            static let childHasDifferentParent: (code: Int, description: String)
                = (9003, "Passed child_view_controller is not child of this view controller, that is - it has different parent and can not be removed form this veiw controller!")
        }
    }
}
