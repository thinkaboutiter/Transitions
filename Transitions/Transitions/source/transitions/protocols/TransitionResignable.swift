//
//  TransitionResignable.swift
//  Transitions
//
//  Created by Boyan Yankov on 22/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

public protocol TransitionResignable: UIGestureRecognizerDelegate {
    
    // Custom resign flow (dismissal animation and transition)
    func resignTransitionAnimated(_ animated: Bool, sender: AnyObject, completion: (() -> Void)?)
    
    var customTransitioningDelegate: UIViewControllerTransitioningDelegate? { get }
    var resignTransitioningGestureRecognizer: UIGestureRecognizer? { get }
    var resignTransitioningSwipeGestureRecognizer: UISwipeGestureRecognizer? { get }
}
