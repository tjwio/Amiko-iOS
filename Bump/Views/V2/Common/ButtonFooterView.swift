//
//  ButtonFooterView.swift
//  Bump
//
//  Created by Tim Wong on 8/16/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class ButtonFooterView: UIView {
    let confirmButtonTitle: String
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        
        let attributedTitle = NSMutableAttributedString(string: "\(String.featherIcon(name: .x)) CANCEL", attributes: [.foregroundColor: UIColor.Matcha.dusk])
        attributedTitle.addAttribute(.font, value: UIFont.featherFont(size: 20.0)!, range: NSMakeRange(0, 1))
        attributedTitle.addAttribute(.font, value: UIFont.avenirDemi(size: 14.0)!, range: NSMakeRange(1, attributedTitle.length-1))
        attributedTitle.addAttribute(.baselineOffset, value: 2.0, range: NSMakeRange(1, attributedTitle.length-1))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var confirmButton: LoadingButton = {
        let button = LoadingButton(type: .custom)
        button.backgroundColor = UIColor.Matcha.dusk
        
        let attributedTitle = NSMutableAttributedString(string: "\(confirmButtonTitle) \(String.featherIcon(name: .arrowRight))", attributes: [.foregroundColor: UIColor.white])
        attributedTitle.addAttribute(.font, value: UIFont.featherFont(size: 20.0)!, range: NSMakeRange(attributedTitle.length-1, 1))
        attributedTitle.addAttribute(.font, value: UIFont.avenirDemi(size: 14.0)!, range: NSMakeRange(0, attributedTitle.length-1))
        attributedTitle.addAttribute(.baselineOffset, value: 2.0, range: NSMakeRange(0, attributedTitle.length-1))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init() {
        confirmButtonTitle = "CONFIRM"
        super.init(frame: .zero)
        commonInit()
    }
    
    init(confirmButtonTitle: String) {
        self.confirmButtonTitle = confirmButtonTitle
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        confirmButtonTitle = "CONFIRM"
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        confirmButtonTitle = "CONFIRM"
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(buttonStackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
        }
        
        super.updateConstraints()
    }
}
