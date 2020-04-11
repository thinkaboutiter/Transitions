//
//  UIColor+Extensions.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W15-11-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

extension UIColor {
    
    enum AppColor {
        static var dimmingViewBackgroundColor: UIColor {
            var result: UIColor = UIColor.black.withAlphaComponent(0.5)
            if #available(iOS 13.0, *),
                (UITraitCollection.current.userInterfaceStyle == .dark)
            {
                result = UIColor.white.withAlphaComponent(0.5)
            }
            return result
        }
    }
}
