//
//  SyncUserAccountsView+Cell.swift
//  Bump
//
//  Created by Tim Wong on 7/9/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon
import SnapKit

extension SyncUserAccountsView {
    class TableViewCell: UITableViewCell {
        let iconLabel: UILabel = {
            let label = UILabel()
            label.font = .featherFont(size: 24.0)
            label.textColor = UIColor.Matcha.dusk
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let valueLabel: UILabel = {
            let label = UILabel()
            label.font = .avenirRegular(size: 16.0)
            label.textColor = UIColor.Matcha.dusk
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let actionLabel: UILabel = {
            let label = UILabel()
            label.isHidden = true
            label.font = .featherFont(size: 24.0)
            label.textColor = UIColor.Matcha.dusk
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        private func commonInit() {
            contentView.addSubview(iconLabel)
            contentView.addSubview(valueLabel)
            contentView.addSubview(actionLabel)
            
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            iconLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(24.0)
                make.centerY.equalToSuperview()
            }
            
            valueLabel.snp.makeConstraints { make in
                make.leading.equalTo(self.iconLabel.snp.trailing).offset(16.0)
                make.trailing.lessThanOrEqualToSuperview().offset(-24.0)
                make.centerY.equalToSuperview()
            }
            
            actionLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16.0)
                make.centerY.equalToSuperview()
            }
            
            super.updateConstraints()
        }
    }
}
