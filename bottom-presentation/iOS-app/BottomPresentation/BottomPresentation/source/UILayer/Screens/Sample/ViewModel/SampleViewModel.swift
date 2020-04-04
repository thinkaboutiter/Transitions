//
//  SampleViewModel.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `View` to expose to `ViewModel`
protocol SampleViewModelConsumer: AnyObject {}

/// APIs for `ViewModel` to expose to `View`
protocol SampleViewModel: AnyObject {
    func setViewModelConsumer(_ newValue: SampleViewModelConsumer)
}

class SampleViewModelImpl: SampleViewModel, SampleModelConsumer {
    
    // MARK: - Properties
    private let model: SampleModel
    private weak var viewModelConsumer: SampleViewModelConsumer!
    
    // MARK: - Initialization
    required init(model: SampleModel) {
        self.model = model
        self.model.setModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - SampleViewModel protocol
    func setViewModelConsumer(_ newValue: SampleViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    // MARK: - SampleModelConsumer protocol
}

