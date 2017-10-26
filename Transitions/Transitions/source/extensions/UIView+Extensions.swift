//
//  UIView+Extensions.swift
//  Transitions
//
//  Created by boyankov on W43 24/Oct/2017 Tue.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import UIKit

// MARK: - Taking snapshot form `UIView` object
extension UIView {
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return result!
    }
}

// MARK: - Rounding `UIView` object
extension UIView {
    
    func round(borderWidth width: CGFloat = 0, borderColor color: UIColor = UIColor.clear) {
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
