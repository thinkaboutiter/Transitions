//
//  TransitioningProtocols.swift
//  Transitions
//
//  Created by Boyan Yankov on 22/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit
import SimpleLogger

public protocol TransitioningResignable: UIGestureRecognizerDelegate {
    /** Custom resign flow (dismissal animation and transition) */
    func resignTransitionAnimated(animated: Bool, sender: AnyObject, completion: (() -> Void)?)
    var customTransitioningDelegate: UIViewControllerTransitioningDelegate? { get }
    var resignTransitioningGestureRecognizer: UIGestureRecognizer? { get }
    var resignTransitioningSwipeGestureRecognizer: UISwipeGestureRecognizer? { get }
}