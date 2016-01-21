//
//  FinalViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 14/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit

class FinalViewController: BaseViewController {
    
    @IBOutlet weak var transitionBackwardsButton: UIButton!
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor().colorWithAlphaComponent(1)
        self.configureButton(self.transitionBackwardsButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func transitionBackwardsPressed(sender: AnyObject) {               
        if let _ = self.customTransitioningDelegate {
            self.transitioningDelegate = self.customTransitioningDelegate
            self.modalPresentationStyle = .Custom
        }
        
        if let validPresentingVC = self.presentingViewController {
            validPresentingVC.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Configurations
    
    private func configureButton(button: UIButton) {
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.8), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.8), forState: .Selected)
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.8), forState: .Highlighted)
        button.backgroundColor = UIColor.clearColor()
    }
}