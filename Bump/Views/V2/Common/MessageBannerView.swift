//
//  MessageBannerView.swift
//  Bump
//
//  Created by Tim Wong on 7/15/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class MessageBannerView: UIView {
    let iconLabel: UILabel = {
        let label = UILabel()
        label.font = .featherFont(size: 14.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 14.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var textColor: UIColor = .white {
        didSet {
            iconLabel.textColor = textColor
            messageLabel.textColor = textColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(iconLabel)
        addSubview(messageLabel)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        iconLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32.0)
            make.centerY.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconLabel.snp.trailing).offset(6.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-32.0)
            make.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
