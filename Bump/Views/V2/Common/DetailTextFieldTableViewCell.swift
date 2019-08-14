//
//  DetailTextFieldTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 8/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class DetailTextFieldTableViewCell: UITableViewCell {
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = .avenirRegular(size: 14.0)
        textField.textColor = UIColor.Grayscale.light
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirRegular(size: 14.0)
        label.textColor = UIColor.Grayscale.light
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
        contentView.addSubview(textField)
        contentView.addSubview(placeholderLabel)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24.0)
            make.centerY.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(self.textField.snp.trailing).offset(16.0)
            make.trailing.equalToSuperview().offset(-24.0)
            make.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
