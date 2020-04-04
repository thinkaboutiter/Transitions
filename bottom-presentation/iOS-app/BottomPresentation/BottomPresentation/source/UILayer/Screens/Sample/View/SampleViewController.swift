//
//  SampleViewController.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

/// APIs for `DependecyContainer` to expose.
protocol SampleViewControllerFactory {
    func makeSampleViewController() -> SampleViewController
}

class SampleViewController: UIViewController, SampleViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: SampleViewModel
    @IBOutlet private weak var actionButton: UIButton!
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(viewModel: SampleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: SampleViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - SampleViewModelConsumer protocol
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure_ui()
    }
    
    // MARK: - actions
    @IBAction func actionButton_touchUpInside(_ sender: UIButton) {
        Logger.debug.message()
    }
}

private extension SampleViewController {
    
    func configure_ui() {
        self.configure_actionButton(self.actionButton)
    }
    
    func configure_actionButton(_ button: UIButton) {
        let title: String = NSLocalizedString("SampleViewController.actionButton.title", comment: AppConstants.LocalizedStringComment.buttonTitle)
        button.setTitle(title, for: .normal)
    }
}
