//
//  InitialViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 14/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

class InitialViewController: BaseViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.continueApplicationFlow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Application flow
fileprivate extension InitialViewController {
    
    func continueApplicationFlow() {
        guard let valid_appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            Logger.error.message("Unable to obtain \(String(describing: AppDelegate.self)) shared instance")
            return
        }
        executeOnMainQueue(afterDelay: 0.5) {
            valid_appDelegate.switchRootViewControllerToMainScreen()
        }
    }
}
