//
//  ContentViewController.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

class ContentViewController: BaseViewController {
    
    // MARK: - Properties
    private let interactor: SideTransitionInteractor
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(dismissalInteractor: SideTransitionInteractor,
         title: String)
    {
        self.interactor = dismissalInteractor
        super.init(nibName: String(describing: ContentViewController.self), bundle: nil)
        self.title = title
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - BottomMenuViewModelConsumer protocol
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.titleLabel.text = "Content \(self.title ?? "")"
    }
}

extension ContentViewController: SideTransitionInteractorProvider {
    
    func sideTransitionInteractor() -> SideTransitionInteractor {
        return self.interactor
    }
}
