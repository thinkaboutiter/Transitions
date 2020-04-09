//
//  SideTransitionDirection.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation

/// The direction form where the transition is starting.
enum SideTransitionDirection {
    case top(Coverage)
    case left(Coverage)
    case bottom(Coverage)
    case right(Coverage)
    
    var stringValues: (direction: String, coverage: String) {
        let result: (direction: String, coverage: String)
        switch self {
        case .top(let coverage):
            result = ("top", "\(Int(coverage.rawValue * 100)) \u{25}")
        case .left(let coverage):
            result = ("left", "\(Int(coverage.rawValue * 100)) \u{25}")
        case .bottom(let coverage):
            result = ("bottom", "\(Int(coverage.rawValue * 100)) \u{25}")
        case .right(let coverage):
            result = ("right", "\(Int(coverage.rawValue * 100)) \u{25}")
        }
        return result
    }
    
    /// Utility type holding the % coverage of the screen for presentation.
    struct Coverage {
        
        static let full: Coverage = Coverage(rawValue: 1.0)!
        static let half: Coverage = Coverage(rawValue: 1.0 / 2.0)!
        static let oneThird: Coverage = Coverage(rawValue: 1.0 / 3.0)!
        static let twoThirds: Coverage = Coverage(rawValue: 2.0 / 3.0)!
        static let oneQuarter: Coverage = Coverage(rawValue: 1.0 / 4.0)!
        static let threeQuarters: Coverage = Coverage(rawValue: 3.0 / 4.0)!
        
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
