//
//  BaseViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 14/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
