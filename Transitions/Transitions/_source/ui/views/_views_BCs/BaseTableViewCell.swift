//
//  BaseTableViewCell.swift
//  Transitions
//
//  Created by Boyan Yankov on 19/01/2016.
//  Copyright © 2016 Boyan Yankov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    lazy fileprivate var topSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.isHidden = true
        return view
    }()
    
    lazy fileprivate var bottomSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return view
    }()
    
    var isFirstCell: Bool = false {
        didSet {
            self.topSeparatorView.isHidden = !isFirstCell
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
        
        self.confugure_ui()
        self.positionSeparatorViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    override func updateConstraints() {
        super.updateConstraints()
    }
}

// MARK: - UI configurations
fileprivate extension BaseTableViewCell {
    
    func confugure_ui() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        self.contentView.addSubview(self.topSeparatorView)
        self.contentView.addSubview(self.bottomSeparatorView)
    }
    
    func positionSeparatorViews() {
        self.topSeparatorView.snp.updateConstraints { (maker: ConstraintMaker) in
            maker.top.equalTo(self.contentView.snp.top)
            maker.leading.equalTo(self.contentView.snp.leading).offset(self.isFirstCell ? 0 : Dimensions.Separator.Offset.leading)
            maker.trailing.equalTo(self.contentView.snp.trailing).offset(self.isFirstCell ? 0 : -Dimensions.Separator.Offset.trailing)
            maker.height.equalTo(Dimensions.Separator.height)
        }
        
        self.bottomSeparatorView.snp.updateConstraints { (maker: ConstraintMaker) in
            maker.leading.equalTo(self.contentView.snp.leading).offset(self.isLastCell ? 0 : Dimensions.Separator.Offset.leading)
            maker.bottom.equalTo(self.contentView.snp.bottom)
            maker.trailing.equalTo(self.contentView.snp.trailing).offset(self.isLastCell ? 0 : -Dimensions.Separator.Offset.trailing)
            maker.height.equalTo(Dimensions.Separator.height)
        }
    }
}

// MARK: - Dimensions
fileprivate extension BaseTableViewCell {
    
    struct Dimensions {
        
        struct Separator {
            static let height: CGFloat = 0.5
            
            struct Offset {
                static let leading: CGFloat = 16.0
                static let trailing: CGFloat = 16.0
            }
        }
    }
}
