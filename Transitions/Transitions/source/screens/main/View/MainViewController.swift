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
        // we need a valid `viewModel` object
        guard let valid_viewModel: MainViewModelable = self.viewModel else {
            Logger.error.message("Invalid \(String(describing: MainViewModelable.self))")
            return UITableViewCell()
        }
        
        // section index check
        guard indexPath.section < valid_viewModel.sectionsData.count else {
            Logger.error.message("Invalid section index")
            return UITableViewCell()
        }
        
        // obtain section data
        let sectionData: MainViewModel.StaticSectionData = valid_viewModel.sectionsData[indexPath.section]
        
        // cell section check
        guard indexPath.row < sectionData.rowsData().count else {
            Logger.error.message("Invalid cell index")
            return UITableViewCell()
        }
        
        // obtain cell data
        let rowData: MainViewModel.StaticRowData = sectionData.rowsData()[indexPath.row]
        
        // cell creation
        let cell: BaseTableViewCell
        
        if let validCell: BaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BaseTableViewCell.self), for: indexPath) as? BaseTableViewCell {
            cell = validCell
        }
        else {
            cell = BaseTableViewCell(style: .default, reuseIdentifier: NSStringFromClass(BaseTableViewCell.self))
        }
        
        cell.configure(with: rowData,
                       isFirst: indexPath.row == 0,
                       isLast: indexPath.row == (sectionData.rowsData().count - 1))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let valid_header: MainTableViewHeaderFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MainTableViewHeaderFooterView.self)) as? MainTableViewHeaderFooterView else {
            Logger.error.message("Unable to dequeue \(String(describing: MainTableViewHeaderFooterView.self)) object")
            return nil
        }
        
        // we need a valid `viewModel` object
        guard let valid_viewModel: MainViewModelable = self.viewModel else {
            Logger.error.message("Invalid \(String(describing: MainViewModelable.self))")
            return nil
        }
        
        // section index check
        guard section < valid_viewModel.sectionsData.count else {
            Logger.error.message("Invalid section index")
            return nil
        }
        
        // obtain section data
        let sectionData: MainViewModel.StaticSectionData = valid_viewModel.sectionsData[section]
        
        valid_header.configure(with: sectionData.title())
        return valid_header
    }
}

// MARK: - UITableViewDelegate protocol
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // `validStoryboard`
        guard let validStoryboard: UIStoryboard = self.storyboard else {
            Logger.error.message("`validStoryboard`is not available")
            return
        }
        
        // `finalVC` is the `presentedOne`
        let finalVC: FinalViewController = validStoryboard.instantiateViewController(withIdentifier: NSStringFromClass(FinalViewController.self)) as! FinalViewController
        
        // configure `modalPresentationStyle`
        self.modalPresentationStyle = .custom
        finalVC.modalPresentationStyle = .custom
        
        // reset `transitioningDelegate`
        self.transitioningDelegate = nil
        finalVC.transitioningDelegate = nil
        
        // `transitioningDelegate`
        let transitioningDelegate: UIViewControllerTransitioningDelegate
        
        // do presentations with their directions here
        switch indexPath.row {
        case 0:
            // Left
            Logger.debug.message("Transition `Horizontal.Left`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .left).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .left))
            
        case 1:
            // Right
            Logger.debug.message("Transition `Horizontal.Right`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .right).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .right))
            
        case 2:
            // Up
            Logger.debug.message("Transition `Vertical.Top`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .up).shouldPresentViewController(true),
                andDismissalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .up))
            
        case 3:
            // Down
            Logger.debug.message("Transition `Vertical.Bottom`")
            
            // create `transitioningDelegate` object
            transitioningDelegate = BaseTransitioningDelegate(
                withPresentationalAnimator: AxialTransitioningAnimator(withTransitioningDirection: .down).shouldPresentViewController(true),
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
        // we need a valid `viewModel` object
        guard let valid_viewModel: MainViewModelable = self.viewModel else {
            Logger.error.message("Invalid \(String(describing: MainViewModelable.self))")
            return BaseTableView.Dimensions.rowHeight
        }
        
        // section index check
        guard indexPath.section < valid_viewModel.sectionsData.count else {
            Logger.error.message("Invalid section index")
            return BaseTableView.Dimensions.rowHeight
        }
        
        // obtain section data
        let sectionData: MainViewModel.StaticSectionData = valid_viewModel.sectionsData[indexPath.section]
        
        // cell section check
        guard indexPath.row < sectionData.rowsData().count else {
            Logger.error.message("Invalid cell index")
            return BaseTableView.Dimensions.rowHeight
        }
        
        // obtain cell data
        let rowData: MainViewModel.StaticRowData = sectionData.rowsData()[indexPath.row]
        return rowData.height()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // we need a valid `viewModel` object
        guard let valid_viewModel: MainViewModelable = self.viewModel else {
            Logger.error.message("Invalid \(String(describing: MainViewModelable.self))")
            return BaseTableView.Dimensions.sectionHeight
        }
        
        // section index check
        guard section < valid_viewModel.sectionsData.count else {
            Logger.error.message("Invalid section index")
            return BaseTableView.Dimensions.sectionHeight
        }
        
        // obtain section data
        let sectionData: MainViewModel.StaticSectionData = valid_viewModel.sectionsData[section]
        return sectionData.height()
    }
}
