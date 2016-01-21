//
//  BaseTableViewCell.swift
//  Transitions
//
//  Created by Boyan Yankov on 19/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit
import Masonry

class BaseTableViewCell: UITableViewCell {
        
    lazy private var topSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        view.hidden = true
        return view
    }()
    
    lazy private var bottomSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        return view
    }()
    
    var isFirstCell: Bool = false {
        didSet {
            self.topSeparatorView.hidden = !isFirstCell
        }
    }
    
    var isLastCell: Bool = false {
        didSet {
            self.positionSeparatorViews()
        }
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        self.contentView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        self.contentView.addSubview(self.topSeparatorView)
        self.contentView.addSubview(self.bottomSeparatorView)
        
        self.positionSeparatorViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    // MARK: - Helpers
    
    private let separator_offset_leading: CGFloat = 16.0
    private let separator_offset_trailing: CGFloat = 16.0
    private let separator_height: CGFloat = 0.5
    
    private func positionSeparatorViews() {
        self.topSeparatorView.mas_updateConstraints { (make: MASConstraintMaker!) -> Void in
            make.top.equalTo()(self.contentView.mas_top)
            make.leading.equalTo()(self.contentView.mas_leading).offset()(self.isFirstCell ? 0 : self.separator_offset_leading)
            make.trailing.equalTo()(self.contentView.mas_trailing).offset()(self.isFirstCell ? 0 : -self.separator_offset_trailing)
            make.height.equalTo()(self.separator_height)
        }
        
        self.bottomSeparatorView.mas_updateConstraints { (make: MASConstraintMaker!) -> Void in
            make.leading.equalTo()(self.contentView.mas_leading).offset()(self.isLastCell ? 0 : self.separator_offset_leading)
            make.bottom.equalTo()(self.contentView.mas_bottom)
            make.trailing.equalTo()(self.contentView.mas_trailing).offset()(self.isLastCell ? 0 : -self.separator_offset_trailing)
            make.height.equalTo()(self.separator_height)
        }
    }
}