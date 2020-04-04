//
//  RootViewModel.swift
//  CharacterXplorer
//
//  Created by Boyan Yankov on 2020-W07-15-Feb-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `View` to expose to `ViewModel`
protocol RootViewModelConsumer: AnyObject {
}

/// APIs for `ViewModel` to expose to `View`
protocol RootViewModel: AnyObject {
    func setViewModelConsumer(_ newValue: RootViewModelConsumer)
}

class RootViewModelImpl: RootViewModel, RootModelConsumer {
    
    // MARK: - Properties
    private let model: RootModel
    private weak var viewModelConsumer: RootViewModelConsumer!
    
    // MARK: - Initialization
    required init(model: RootModel) {
        self.model = model
        self.model.setModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - RootViewModel protocol
    func setViewModelConsumer(_ newValue: RootViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    // MARK: - RootModelConsumer protocol
}


