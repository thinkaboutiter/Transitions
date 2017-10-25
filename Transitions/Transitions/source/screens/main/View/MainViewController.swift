//
//  MainViewController.swift
//  Transitions
//
//  Created by Boyan Yankov on 19/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

import SimpleLogger

class MainViewController: BaseViewController, MainViewModelConsumable {
    
    // MARK: - Properties
    @IBOutlet weak var functionalitesTableView: BaseTableView!
    
    // MARK: - MainViewModelConsumable protocol
    fileprivate(set) var viewModel: MainViewModelable?
    func updateViewModel(_ viewModel: MainViewModelable?) {
        self.viewModel = viewModel
    }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        Logger.debug.message("\(String(describing: MainViewController.self)) deinitialized")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // we need a valid `viewModel` object
        if self.viewModel == nil {
            self.viewModel = MainViewModel()
        }
        
        self.configure_appearance()
        self.configure(self.functionalitesTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}

// MARK: - UI configurations
fileprivate extension MainViewController {
    
    fileprivate func configure_appearance() {
        self.title = self.viewModel?.title
    }
    
    fileprivate func configure(_ tableView: UITableView) {
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(BaseTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: MainTableViewHeaderFooterView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: MainTableViewHeaderFooterView.self))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource protocol
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // we need a valid `viewModel` object
        guard let valid_viewModel: MainViewModelable = self.viewModel else {
            Logger.error.message("Invalid \(String(describing: MainViewModelable.self))")
            return 0
        }
        
        return valid_viewModel.sectionsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // we need a valid `viewModel` object
        guard let valid_viewModel: MainViewModelable = self.viewModel else {
            Logger.error.message("Invalid \(String(describing: MainViewModelable.self))")
            return 0
        }
        
        // section index check
        guard section < valid_viewModel.sectionsData.count else {
            Logger.error.message("Invalid section index")
            return 0
        }
        
        // obtain section data
        let sectionData: MainViewModel.StaticSectionData = valid_viewModel.sectionsData[section]
        
        return sectionData.rowsData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // we need a valid `StaticSectionData` object
        guard let valid_sectionData: MainViewModel.StaticSectionData = self.sectionData(for: indexPath.section) else {
            Logger.error.message("Unable to obtain \(String(describing: MainViewModel.StaticSectionData.self)) object!")
            return UITableViewCell()
        }

        // we need a valid `StaticRowData` object
        guard let valid_rowData: MainViewModel.StaticRowData = self.rowData(for: indexPath, from: valid_sectionData) else {
            Logger.error.message("Unable to obtain \(String(describing: MainViewModel.StaticRowData.self)) object!")
            return UITableViewCell()
        }
        
        // cell creation
        let cell: BaseTableViewCell
        
        if let validCell: BaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BaseTableViewCell.self), for: indexPath) as? BaseTableViewCell {
            cell = validCell
        }
        else {
            cell = BaseTableViewCell(style: .default, reuseIdentifier: NSStringFromClass(BaseTableViewCell.self))
        }
        
        cell.configure(with: valid_rowData,
                       isFirst: indexPath.row == 0,
                       isLast: indexPath.row == (valid_sectionData.rowsData().count - 1))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let valid_header: MainTableViewHeaderFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainTableViewHeaderFooterView.self)) as? MainTableViewHeaderFooterView else {
            Logger.error.message("Unable to dequeue \(String(describing: MainTableViewHeaderFooterView.self)) object")
            return nil
        }
        
        // we need a valid `StaticSectionData` object
        guard let valid_sectionData: MainViewModel.StaticSectionData = self.sectionData(for: section) else {
            Logger.error.message("Unable to obtain \(String(describing: MainViewModel.StaticSectionData.self)) object!")
            return nil
        }
        
        valid_header.configure(with: valid_sectionData.title())
        return valid_header
    }
}

// MARK: - UITableViewDelegate protocol
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let finalVC: FinalViewController = UIStoryboard(name: AppConstants.StoryboardName.final, bundle: nil).instantiateViewController(withIdentifier: String(describing: FinalViewController.self)) as? FinalViewController else {
            Logger.error.message("Unable to instantiate \(String(describing: FinalViewController.self))")
            return
        }
        
        guard let valid_rowData: MainViewModel.StaticRowData = self.rowData(for: indexPath) else {
            Logger.error.message("Unable to obtain \(String(describing: MainViewModel.StaticRowData.self)) object!")
            return
        }
        
        // configure `modalPresentationStyle`
        self.modalPresentationStyle = .custom
        finalVC.modalPresentationStyle = .custom
        
        // reset `transitioningDelegate`
        self.transitioningDelegate = nil
        finalVC.transitioningDelegate = nil
        
        // we need a `transitioningDelegate` for the transition
        let transitioningDelegate: UIViewControllerTransitioningDelegate
        
        // configure `transitioningDelegate`
        switch valid_rowData {
        case .nonInteractive_left:
            Logger.debug.message("Transition `Horizontal.Left`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .left).shouldPresentViewController(true),
                                                              andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .left))
            
        case .nonInteractive_right:
            Logger.debug.message("Transition `Horizontal.Right`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .right).shouldPresentViewController(true),
                                                              andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .right))
            
        case .nonInteractive_up:
            Logger.debug.message("Transition `Vertical.Up`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .up).shouldPresentViewController(true),
                                                              andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .up))
            
        case .nonInteractive_down:
            Logger.debug.message("Transition `Vertical.Down`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .down).shouldPresentViewController(true),
                                                              andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .down))
            
        default:
            Logger.debug.message("Unsupported Transition")
            // TODO: show alert
            return
        }
        
        // assign `transitioningDelegate`
        self.transitioningDelegate = transitioningDelegate
        finalVC.transitioningDelegate = transitioningDelegate
        finalVC.customTransitioningDelegate = transitioningDelegate
        
        self.present(finalVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // we need a valid `StaticRowData` object
        guard let valid_rowData: MainViewModel.StaticRowData = self.rowData(for: indexPath) else {
            Logger.error.message("Unable to obtain \(String(describing: MainViewModel.StaticRowData.self)) object!")
            return 0
        }
        return valid_rowData.height()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // we need a valid `StaticSectionData` object
        guard let valid_sectionData: MainViewModel.StaticSectionData = self.sectionData(for: section) else {
            Logger.error.message("Unable to obtain \(String(describing: MainViewModel.StaticSectionData.self)) object!")
            return 0
        }
        return valid_sectionData.height()
    }
}

// MARK: - Static data (obtaining)
fileprivate extension MainViewController {
    
    // this optional `sectionData` parameter with default nil value is added (and used) only for the additional
    // knowledge needed to determine whether the cell is last in a section (UI related)
    func rowData(for indexPath: IndexPath, from sectionData: MainViewModel.StaticSectionData? = nil) -> MainViewModel.StaticRowData? {
        let valid_sectionData: MainViewModel.StaticSectionData
        
        // we need to know if there is a valid `sectionData` parameter passed in
        if let passed_sectionData: MainViewModel.StaticSectionData = sectionData {
            valid_sectionData = passed_sectionData
        }
        else {
            // or we should obtain one from passed `indexPath`
            guard let obtained_sectionData: MainViewModel.StaticSectionData = self.sectionData(for: indexPath.section) else {
                Logger.error.message("Unable to obtain \(String(describing: MainViewModel.StaticSectionData.self)) object")
                return nil
            }
            valid_sectionData = obtained_sectionData
        }
        
        // row index check
        let rowIndex: Int = indexPath.row
        guard rowIndex < valid_sectionData.rowsData().count else {
            Logger.error.message("Invalid row index")
            return nil
        }
        
        // obtain cell data
        let rowData: MainViewModel.StaticRowData = valid_sectionData.rowsData()[rowIndex]
        return rowData
    }
    
    func sectionData(for sectionIndex: Int) -> MainViewModel.StaticSectionData? {
        // we need a valid `viewModel` object
        guard let valid_viewModel: MainViewModelable = self.viewModel else {
            Logger.error.message("Invalid \(String(describing: MainViewModelable.self))")
            return nil
        }
        
        // section index check
        guard sectionIndex < valid_viewModel.sectionsData.count else {
            Logger.error.message("Invalid section index")
            return nil
        }
        
        // obtain section data
        let sectionData: MainViewModel.StaticSectionData = valid_viewModel.sectionsData[sectionIndex]
        return sectionData
    }
}
