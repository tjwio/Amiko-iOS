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
        
        let actionToolbar: ActionToolbar = {
            let toolbar = ActionToolbar(icons: [.featherIcon(name: .trash2), .featherIcon(name: .minus)])
            toolbar.backgroundColor = UIColor.Matcha.sky
            toolbar.isHidden = true
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            
            return toolbar
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
            
            menuButton.addTarget(self, action: #selector(self.showMore(_:)), for: .touchUpInside)
            
            addSubview(closeButton)
            addSubview(menuButton)
            addSubview(infoView)
            addSubview(actionToolbar)
            
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            closeButton.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().offset(44.0)
            }
            
            menuButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(44.0)
                make.trailing.equalToSuperview().offset(-24.0)
            }
            
            infoView.snp.makeConstraints { make in
                make.top.equalTo(self.closeButton.snp.bottom).offset(24.0)
                make.leading.equalToSuperview().offset(36.0)
                make.trailing.equalToSuperview().offset(-36.0)
                make.bottom.equalToSuperview().offset(-24.0)
            }
            
            actionToolbar.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40.0)
                make.trailing.equalToSuperview().offset(-12.0)
            }
            
            super.updateConstraints()
        }
        
        @objc private func showMore(_ sender: UIButton) {
            let frame = actionToolbar.frame
            let t0 = CGAffineTransform(translationX: -frame.origin.x, y: -frame.origin.y)
            let ts = CGAffineTransform(scaleX: 0.0, y: 1.0)
            let t1 = CGAffineTransform(translationX: frame.origin.x, y: frame.origin.y)
            
            actionToolbar.transform = t0.concatenating(ts).concatenating(t1)
            actionToolbar.isHidden = false
            actionToolbar.alpha = 0.0
            
            UIView.animate(withDuration: 0.50, animations: {
                self.actionToolbar.alpha = 1.0
                self.actionToolbar.transform = .identity
                self.menuButton.alpha = 0.0
                self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
            }) { _ in
                self.menuButton.isHidden = true
                self.menuButton.alpha = 1.0
            }
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
