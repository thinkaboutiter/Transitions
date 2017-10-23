//
//  InitialViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 14/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: BaseViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    @IBAction func startTransitionPressed(_ sender: UIButton) {
        if let validStoryboard: UIStoryboard = self.storyboard {
            let finalVC: FinalViewController = validStoryboard.instantiateViewController(withIdentifier: NSStringFromClass(FinalViewController.self)) as! FinalViewController
            
            if let _ = self.transitioningDelegate {
                self.modalPresentationStyle = .custom
            }
            
            if let _ = finalVC.transitioningDelegate {
                finalVC.modalPresentationStyle = .custom
            }
            
            self.present(finalVC, animated: true, completion: nil)
        }
    }
}
