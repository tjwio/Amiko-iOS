//
//  ShipDetailViewController+Views.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon
import SnapKit

extension ShipDetailViewController {
    class HeaderView: UIView {
        let infoView: UserInfoView = {
            let view = UserInfoView()
            view.backgroundColor = .clear
            view.bioLabel.textColor = .white
            view.nameLabel.textColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let closeButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle(.featherIcon(name: .x), for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .featherFont(size: 28.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        let menuButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle(.featherIcon(name: .moreVertical), for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .featherFont(size: 24.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
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
            backgroundColor = UIColor.Matcha.dusk
            
            addSubview(closeButton)
            addSubview(menuButton)
            addSubview(infoView)
            
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            closeButton.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().offset(32.0)
            }
            
            menuButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(32.0)
                make.trailing.equalToSuperview().offset(-24.0)
            }
            
            infoView.snp.makeConstraints { make in
                make.top.equalTo(self.closeButton.snp.bottom).offset(24.0)
                make.leading.equalToSuperview().offset(36.0)
                make.trailing.equalToSuperview().offset(-36.0)
                make.bottom.equalToSuperview().offset(-24.0)
            }
            
            super.updateConstraints()
        }
    }
    
    class FooterView: UIView {
        let manageButton: LoadingButton = {
            let button = LoadingButton(type: .custom)
            button.setTitleColor(UIColor.Matcha.dusk, for: .normal)
            button.setTitleColor(UIColor.Matcha.dusk.withAlphaComponent(0.75), for: .highlighted)
            button.titleLabel?.font = .avenirDemi(size: 14.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
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
            backgroundColor = .white
            
            addSubview(manageButton)
            
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            manageButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(6.0)
                make.centerX.equalToSuperview()
            }
            
            super.updateConstraints()
        }
    }
}
