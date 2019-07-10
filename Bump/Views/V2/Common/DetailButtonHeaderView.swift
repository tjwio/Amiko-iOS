//
//  DetailButtonHeaderView.swift
//  Bump
//
//  Created by Tim Wong on 7/9/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class DetailButtonHeaderView: UIView {
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Matcha.dusk
        label.font = .avenirDemi(size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.Blue.normal, for: .normal)
        button.setTitleColor(UIColor(hexColor: 0x1C77C4), for: .highlighted)
        button.titleLabel?.font = .avenirDemi(size: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //constraints
    private var didSetupInitialConstraints = false
    
    init() {
        super.init(frame: .zero)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .white
        
        self.addSubview(self.detailLabel)
        self.addSubview(self.button)
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if !self.didSetupInitialConstraints {
            let detailLeadingConstraint = NSLayoutConstraint(item: self.detailLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
            let detailCenterYConstraint = NSLayoutConstraint(item: self.detailLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            
            let buttonTrailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.button, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let buttonCenterYConstraint = NSLayoutConstraint(item: self.button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            
            NSLayoutConstraint.activate([detailLeadingConstraint, detailCenterYConstraint, buttonTrailingConstraint, buttonCenterYConstraint])
            
            self.didSetupInitialConstraints = true
        }
        
        super.updateConstraints()
    }
}
