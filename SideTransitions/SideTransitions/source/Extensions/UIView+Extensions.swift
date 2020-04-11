//
//  UIView+Extensions.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W15-11-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func round(_ corners: Corners,
               cornerRadius: CGFloat) -> UIView
    {
        self.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = cornerRadius
            self.layer.maskedCorners = corners.cornerMask
        }
        else {
            let path: UIBezierPath = UIBezierPath(roundedRect: self.bounds,
                                                  byRoundingCorners: corners.rectCorner,
                                                  cornerRadii: CGSize(width: cornerRadius,
                                                                      height: cornerRadius))
            let mask: CAShapeLayer = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
        return self
    }
    
    struct Corners: OptionSet {
        typealias RawValue = UInt
        let rawValue: UInt
        
        init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        // MARK: - Constants
        static let minXminYCorner: Corners  = Corners(rawValue: 1 << 0)   // topLeft
        static let minXMaxYCorner: Corners  = Corners(rawValue: 1 << 1)   // bottomLeft
        static let maxXminYCorner: Corners  = Corners(rawValue: 1 << 2)   // topRight
        static let maxXmaxYCorner: Corners  = Corners(rawValue: 1 << 3)   // bottomRigh
        static let topCorners: Corners      = [.minXminYCorner, .maxXminYCorner]
        static let leftCorners: Corners     = [.minXminYCorner, .minXMaxYCorner]
        static let bottomCorners: Corners   = [.minXMaxYCorner, .maxXmaxYCorner]
        static let rightRorners: Corners    = [.maxXminYCorner, .maxXmaxYCorner]
        static let all: Corners             = [.topCorners, .bottomCorners]
        static let none: Corners            = []
        
        // MARK: - Converters
        var cornerMask: CACornerMask {
            var result: CACornerMask = []
            if self.contains(.minXminYCorner) {
                result.insert(.layerMinXMinYCorner)
            }
            if self.contains(.minXMaxYCorner) {
                result.insert(.layerMinXMaxYCorner)
            }
            if self.contains(.maxXminYCorner) {
                result.insert(.layerMaxXMinYCorner)
            }
            if self.contains(.maxXmaxYCorner) {
                result.insert(.layerMaxXMaxYCorner)
            }
            return result
        }
        
        var rectCorner: UIRectCorner {
            var result: UIRectCorner = []
            if self.contains(.minXminYCorner) {
                result.insert(.topLeft)
            }
            if self.contains(.minXMaxYCorner) {
                result.insert(.bottomLeft)
            }
            if self.contains(.maxXminYCorner) {
                result.insert(.topRight)
            }
            if self.contains(.maxXmaxYCorner) {
                result.insert(.bottomRight)
            }
            return result
        }
    }
}

// MARK: - Direction Factory
extension UIView.Corners {
    
    static func `for`(_ direction: SideTransitionDirection) -> UIView.Corners {
        let result: UIView.Corners
        switch direction {
        case .top:
            result = UIView.Corners.bottomCorners
        case .left:
            result = UIView.Corners.rightRorners
        case .bottom:
            result = UIView.Corners.topCorners
        case .right:
            result = UIView.Corners.leftCorners
        }
        return result
    }
}
