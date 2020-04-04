//
//  SampleModel.swift
//  BottomPresentation
//
//  Created by Boyan Yankov on 2020-W14-04-Apr-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `ViewModel` to expose to `Model`
protocol SampleModelConsumer: AnyObject {}

/// APIs for `Model` to expose to `ViewModel`
protocol SampleModel: AnyObject {
    func setModelConsumer(_ newValue: SampleModelConsumer)
}

class SampleModelImpl: SampleModel {
    
    // MARK: - Properties
    private weak var modelConsumer: SampleModelConsumer!
    
    // MARK: - Initialization
    init() {
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - SampleModel protocol
    func setModelConsumer(_ newValue: SampleModelConsumer) {
        self.modelConsumer = newValue
    }
}
