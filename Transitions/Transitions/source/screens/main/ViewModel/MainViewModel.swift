//
//  MainViewModel.swift
//  Transitions
//
//  Created by boyankov on W43 24/Oct/2017 Tue.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import Foundation
import SimpleLogger

/// Functionality for `View` object to implement
protocol MainViewModelConsumable: class {
    var viewModel: MainViewModelable? { get }
    func updateViewModel(_ viewModel: MainViewModelable?)
}

/// Functionality for `ViewModel` object to implement and expose to `View` object
protocol MainViewModelable {
    var sectionsData: [MainViewModel.StaticSectionData] { get }
    var title: String { get }
}

class MainViewModel: MainViewModelable {
    
    // MARK: - Properties
    let sectionsData: [MainViewModel.StaticSectionData] = MainViewModel.StaticSectionData.allSectionsData()
    let title: String = NSLocalizedString("Transitions", comment: AppConstants.LocalizedStringComment.screenTitle)
    
    // MARK: - Initialization
    init() {
        
    }
    
    deinit {
        Logger.debug.message("\(String(describing: MainViewModel.self)) deinitialized")
    }
}

// MARK: - TableView static data
extension MainViewModel {
    
    // MARK: Static sections data
    enum StaticSectionData {
        case nonInteractiveTransitions
        case interactiveTransitions
        
        static func allSectionsData() -> [MainViewModel.StaticSectionData] {
            return [
                .nonInteractiveTransitions,
                .interactiveTransitions
            ]
        }
        
        func staticRowData() -> [MainViewModel.StaticRowData] {
            let staticRowData: [MainViewModel.StaticRowData]
            
            switch self {
            case .nonInteractiveTransitions:
                staticRowData = [
                    .nonInteractive_left,
                    .nonInteractive_right,
                    .nonInteractive_up,
                    .nonInteractive_down
                ]
                
            case .interactiveTransitions:
                staticRowData = [
                    .interactive_left,
                    .interactive_rigth,
                    .interactive_up,
                    .interactive_down
                ]
            }
            return staticRowData
        }
        
        func title() -> String {
            let title: String
            
            switch self {
            case .nonInteractiveTransitions:
                title = NSLocalizedString("Noninteractive Transitions", comment: AppConstants.LocalizedStringComment.sectionTitle)
                
            case .interactiveTransitions:
                title = NSLocalizedString("Interactive Transitions", comment: AppConstants.LocalizedStringComment.sectionTitle)
            }
            return title
        }
        
        func height() -> CGFloat {
            let height: CGFloat
            
            switch self {
            default:
                height = 30
            }
            return height
        }
    }
    
    // MARK: Static rows data
    enum StaticRowData {
        case nonInteractive_left
        case nonInteractive_right
        case nonInteractive_up
        case nonInteractive_down
        
        case interactive_left
        case interactive_rigth
        case interactive_up
        case interactive_down
        
        func title() -> String {
            let title: String
            
            switch self {
            case .nonInteractive_left,
                 .interactive_left:
                title = NSLocalizedString("Left", comment: AppConstants.LocalizedStringComment.rowTitle)
            case .nonInteractive_right,
                 .interactive_rigth:
                title = NSLocalizedString("Right", comment: AppConstants.LocalizedStringComment.rowTitle)
                
            case .nonInteractive_up,
                 .interactive_up:
                title = NSLocalizedString("Up", comment: AppConstants.LocalizedStringComment.rowTitle)
                
            case .nonInteractive_down,
                 .interactive_down:
                title = NSLocalizedString("Down", comment: AppConstants.LocalizedStringComment.rowTitle)
            }
            return title
        }
        
        func height() -> CGFloat {
            let height: CGFloat
            
            switch self {
            default:
                height = 60
            }
            return height
        }
    }
}
