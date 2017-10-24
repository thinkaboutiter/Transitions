//
//  MainTableViewHeaderFooterView.swift
//  Transitions
//
//  Created by boyankov on W43 24/Oct/2017 Tue.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import UIKit

class MainTableViewHeaderFooterView: UITableViewHeaderFooterView {

    // MARK: - Properties
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var customBackgroundView: UIView!
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configure_ui()
    }
}

// MARK: - UI configurations
extension MainTableViewHeaderFooterView {
    
    fileprivate func configure_ui() {
        self.customBackgroundView.backgroundColor = UIColor.darkGray
        self.titleLabel?.textColor = UIColor.white
    }
    
    func configure(with title: String?) {
        self.titleLabel.text = title
    }
}
