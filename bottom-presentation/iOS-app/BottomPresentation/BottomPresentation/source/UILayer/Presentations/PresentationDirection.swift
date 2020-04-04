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
        
        static let full: Coverage = Coverage(rawValue: 1.000)!
        static let half: Coverage = Coverage(rawValue: 0.500)!
        static let oneThird: Coverage = Coverage(rawValue: 0.333)!
        static let twoThirds: Coverage = Coverage(rawValue: 0.666)!
        static let oneQuarter: Coverage = Coverage(rawValue: 0.250)!
        static let threeQuarters: Coverage = Coverage(rawValue: 0.750)!
        
        /// The value of the coverage in 0.0...1.0 interval.
        private(set) var rawValue: Double
        private static let range: ClosedRange = 0.0...1.0
        
        init?(rawValue: Double) {
            guard Coverage.range ~= rawValue else {
                assert(false, "value=\(rawValue) out of range=\(Coverage.range)!")
                return nil
            }
            self.rawValue = rawValue
        }
    }
}
