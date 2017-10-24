//
//  AppUtilities.swift
//  Transitions
//
//  Created by boyankov on W43 24/Oct/2017 Tue.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import Foundation

/**
 Execute closure on main thread after delay (in seconds)
 - parameter delay: Time interval (in seconds) after which closure will be executed
 - parameter completion: Closure to be executed on `main` thread
 */
public func executeOnMainQueue(afterDelay delay: Double, _ completion: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        completion()
    }
}

public func executeOnMainQueue(async: Bool, block: @escaping () -> Void) {
    if async {
        DispatchQueue.main.async {
            block()
        }
    }
    else {
        DispatchQueue.main.sync {
            block()
        }
    }
}
