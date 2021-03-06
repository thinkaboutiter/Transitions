//
//  SampleViewController.swift
//  SideTransitions
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

class SampleViewController: BaseViewController {
    
    // MARK: - Properties
    private lazy var transitioningManager: SideTransitioningManager = {
        let direction: SideTransitionDirection = .bottom(.half)
        let result: SideTransitioningManager = SideTransitioningManagerFactory.manager(for: direction)
        return result
    }()
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init() {
        super.init(nibName: String(describing: SampleViewController.self), bundle: nil)
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
    /*
    @IBAction func actionButton_touchUpInside(_ sender: UIButton) {
        let vc: ContentViewController = ContentViewController()
        self.initiatePageSheetPresentation(with: vc)
    }
    
    private func initiatePageSheetPresentation(with viewController: UIViewController) {
        viewController.modalPresentationStyle = .pageSheet
        self.present(viewController, animated: true, completion: nil)
    }
     */
    
    @IBAction func topButton_touchUpInside(_ sender: UIButton) {
        Logger.debug.message()
        let direction: SideTransitionDirection = SideTransitionDirection.top(.oneThird)
        self.slide(from: direction)
    }
    
    @IBAction func leftButton_touchUpInside(_ sender: UIButton) {
        Logger.debug.message()
        let direction: SideTransitionDirection = SideTransitionDirection.left(.threeQuarters)
        self.slide(from: direction)
    }
    
    @IBAction func bottomtButton_touchUpInside(_ sender: UIButton) {
        Logger.debug.message()
        let direction: SideTransitionDirection = SideTransitionDirection.bottom(.half)
        self.slide(from: direction)
    }
    
    @IBAction func rightButton_touchUpInside(_ sender: UIButton) {
        Logger.debug.message()
        let direction: SideTransitionDirection = SideTransitionDirection.right(.oneThird)
        self.slide(from: direction)
    }
    
    private func slide(from direction: SideTransitionDirection) {
        self.transitioningManager.setDirection(direction)
        let interactor: SideTransitionInteractor = SideTransitionInteractorFactory.percentDrivenInteractor(for: direction)
        let vc: ContentViewController = ContentViewController(dismissalInteractor: interactor,
                                                              title: "\(direction.stringValues.direction) \(direction.stringValues.coverage)")
        interactor.setViewController(vc)
        vc.transitioningDelegate = self.transitioningManager
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
}

private extension SampleViewController {
    
    func configure_ui() {}
}
