//
//  PresentationDirection.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation

enum PresentationDirection {
    case top(Coverage)
    case left(Coverage)
    case bottom(Coverage)
    case right(Coverage)
    
    
    /// Utility type holding the % coverage of the screen for presentation.
    struct Coverage {
        
        /// The value of the coverage in 0.0...1.0 interval.
        private(set) var value: Double
        private static let range: ClosedRange = 0.0...1.0
        
        init?(value: Double) {
            guard Coverage.range ~= value else {
                assert(false, "value=\(value) out of range=\(Coverage.range)!")
                return nil
            }
            self.value = value
        }
    }
}
