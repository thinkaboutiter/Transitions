//
//  SampleDependencyContainer.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol SampleDependencyContainer: AnyObject {}

class SampleDependencyContainerImpl: SampleDependencyContainer, SampleViewControllerFactory {
    
    // MARK: - Properties
    private let parent: RootDependencyContainer
    
    // MARK: - Initialization
    init(parent: RootDependencyContainer) {
        self.parent = parent
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - SampleViewControllerFactory protocol
    func makeSampleViewController() -> SampleViewController {
        let vm: SampleViewModel = self.makeSampleViewModel()
        let vc: SampleViewController = SampleViewController(viewModel: vm)
        return vc
    }
    
    private func makeSampleViewModel() -> SampleViewModel {
        let model: SampleModel = SampleModelImpl()
        let result: SampleViewModel = SampleViewModelImpl(model: model)
        return result
    }
}
