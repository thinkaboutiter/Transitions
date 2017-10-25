//
//  AppConstants.swift
//  Transitions
//
//  Created by boyankov on W43 24/Oct/2017 Tue.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import Foundation

struct AppConstants {
        
    // MARK: - Storyboard names
    struct StoryboardName {
        static let initial: String = "Initial"
        static let main: String = "Main"
        static let final: String = "Final"
    }
    
    // MARK: - Error messages
    struct ErrorMessage {
        static let generic: String = NSLocalizedString("Something went wrong!", comment: AppConstants.LocalizedStringComment.errorMessage)
        
        /*
         network
         */
        static let unableToParseData: String = NSLocalizedString("Unable to parse data!", comment: AppConstants.LocalizedStringComment.errorMessage)
        static let invalidResultObject: String = NSLocalizedString("Invalid result object!", comment: AppConstants.LocalizedStringComment.errorMessage)
        static let invalidResponseObject: String = NSLocalizedString("Invalid response object!", comment: AppConstants.LocalizedStringComment.errorMessage)
        static let invalidResourcesReceived: String = NSLocalizedString("Invalid resources received!", comment: AppConstants.LocalizedStringComment.errorMessage)
        static let invalidStatusCode: String = NSLocalizedString("Invalid status code!", comment: AppConstants.LocalizedStringComment.errorMessage)
    }
    
    // MARK: - Localized strings comments
    struct LocalizedStringComment {
        static let errorMessage: String = "Error message"
        static let sectionTitle: String = "Section title"
        static let rowTitle: String = "Row title"
        static let screenTitle: String = "Screen title"
    }
}
