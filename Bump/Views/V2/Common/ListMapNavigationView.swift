//
//  ListMapNavigationView.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class ListMapNavigationView: UIView {
    let listButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isSelected = true
        button.setTitle("LIST", for: .normal)
        button.setTitleColor(UIColor.Grayscale.light, for: .normal)
        button.setTitleColor(UIColor.Grayscale.dark, for: .highlighted)
        button.setTitleColor(UIColor.Grayscale.dark, for: .selected)
        button.titleLabel?.font = .avenirDemi(size: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let mapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isSelected = false
        button.setTitle("MAP", for: .normal)
        button.setTitleColor(UIColor.Grayscale.light, for: .normal)
        button.setTitleColor(UIColor.Grayscale.dark, for: .highlighted)
        button.setTitleColor(UIColor.Grayscale.dark, for: .selected)
        button.titleLabel?.font = .avenirDemi(size: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let dividerLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 16.0)
        label.text = "/"
        label.textColor = UIColor.Grayscale.light
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [listButton, dividerLabel, mapButton])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
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
        addSubview(stackView)
    }
    
    override func updateConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
