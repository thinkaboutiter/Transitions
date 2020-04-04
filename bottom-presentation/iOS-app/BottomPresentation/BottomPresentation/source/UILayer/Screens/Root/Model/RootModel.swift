//
//  RootModel.swift
//  CharacterXplorer
//
//  Created by Boyan Yankov on 2020-W07-15-Feb-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `ViewModel` to expose to `Model`
protocol RootModelConsumer: AnyObject {}

/// APIs for `Model` to expose to `ViewModel`
protocol RootModel: AnyObject {
    func setModelConsumer(_ newValue: RootModelConsumer)
}

class RootModelImpl: RootModel {
    
    // MARK: - Properties
    private weak var modelConsumer: RootModelConsumer!
    
    // MARK: - Initialization
    init() {
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - RootModel protocol
    func setModelConsumer(_ newValue: RootModelConsumer) {
        self.modelConsumer = newValue
    }
}
