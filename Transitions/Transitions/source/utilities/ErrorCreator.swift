//
//  ErrorCreator.swift
//  Transitions
//
//  Created by boyankov on W43 24/Oct/2017 Tue.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import Foundation

enum ErrorCreator {
    case generic
    case unableToParseData
    case invalidResultObject
    case invalidResponseObject
    case invalidResourcesReceived
    case custom(code: Int, message: String)
    
    static let domain: String = "ApplicationError"
    static let teapotCode: Int = 418
    
    func error() -> NSError {
        switch self {
        case .generic:
            return self.createError(message: AppConstants.ErrorMessage.generic)
            
        case .unableToParseData:
            return self.createError(message: AppConstants.ErrorMessage.unableToParseData)
            
        case .invalidResultObject:
            return self.createError(message: AppConstants.ErrorMessage.invalidResultObject)
            
        case .invalidResponseObject:
            return self.createError(message: AppConstants.ErrorMessage.invalidResponseObject)
            
        case .invalidResourcesReceived:
            return self.createError(message: AppConstants.ErrorMessage.invalidResourcesReceived)
            
        case .custom(let code, let message):
            return self.createError(code: code, message: message)
        }
    }
    
    fileprivate func createError(withDomain domain: String = ErrorCreator.domain, code: Int = ErrorCreator.teapotCode, message: String) -> NSError {
        let error: NSError = NSError(
            domain: domain,
            code: code,
            userInfo: [
                NSLocalizedDescriptionKey: message
            ])
        
        return error
    }
}
