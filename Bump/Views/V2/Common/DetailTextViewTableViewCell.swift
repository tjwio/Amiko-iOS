//
//  DetailTextViewTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 8/16/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class DetailTextViewTableViewCell: UITableViewCell {
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .avenirRegular(size: 14.0)
        textView.isScrollEnabled = false
        textView.textColor = UIColor.Grayscale.light
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirRegular(size: 14.0)
        label.textColor = UIColor.Grayscale.light
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        
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
        contentView.addSubview(textView)
        contentView.addSubview(placeholderLabel)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.equalToSuperview().offset(-20.0)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(self.textView.snp.bottom).offset(4.0)
            make.trailing.equalToSuperview().offset(-24.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
        
        super.updateConstraints()
    }
}
