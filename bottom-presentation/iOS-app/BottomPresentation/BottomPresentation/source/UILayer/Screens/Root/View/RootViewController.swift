//
//  RootViewController.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W07-15-Feb-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

/// APIs for `DependecyContainer` to expose.
protocol RootViewControllerFactory {
    func makeRootViewController() -> RootViewController
}

class RootViewController: BaseViewController, RootViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: RootViewModel
    private let sampleViewControllerFactory: SampleViewControllerFactory
    @IBOutlet weak var testLabel: UILabel!
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?)
    {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(viewModel: RootViewModel,
         sampleViewControllerFactory: SampleViewControllerFactory)
    {
        self.viewModel = viewModel
        self.sampleViewControllerFactory = sampleViewControllerFactory
        super.init(nibName: String(describing: RootViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - RootViewModelConsumer protocol
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testLabel.text = NSLocalizedString("RootViewController.testLabel.text", comment: AppConstants.LocalizedStringComment.labelTitle)
        self.embedSampleViewController()
    }
}

// MARK: - Embedding
private extension RootViewController {
    
    func embedSampleViewController() {
        let vc: SampleViewController = self.sampleViewControllerFactory.makeSampleViewController()
        do {
            try self.embed(vc, containerView: self.view)
        }
        catch let error as NSError {
            Logger.error.message().object(error)
        }
    }
}
