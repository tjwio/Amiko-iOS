//
//  BumpView.swift
//  Bump
//
//  Created by Tim Wong on 7/17/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import Lottie
import SnapKit

class BumpView: UIView {
    private struct Constants {
        static let logoAnimationFile = "amiko"
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready to Bump"
        label.textColor = UIColor.Grayscale.light
        label.font = .avenirMedium(size: 28.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Bump phone with another user"
        label.textColor = UIColor.Matcha.dusk
        label.font = .avenirRegular(size: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let logoAnimation: AnimationView = {
        let animation = AnimationView(name: Constants.logoAnimationFile)
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 1.0
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        return animation
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Grayscale.background
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(UIColor.Matcha.dusk, for: .normal)
        button.titleLabel?.font = .avenirDemi(size: 14.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10.0
        
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
        
        addSubview(titleLabel)
        addSubview(instructionsLabel)
        addSubview(logoAnimation)
        addSubview(cancelButton)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44.0)
            make.centerX.equalToSuperview()
        }
        
        instructionsLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20.0)
            make.centerX.equalToSuperview()
        }
        
        logoAnimation.snp.makeConstraints { make in
            make.top.equalTo(self.instructionsLabel.snp.bottom).offset(-64.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(300.0)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(self.instructionsLabel.snp.bottom).offset(186.0)
            make.leading.equalToSuperview().offset(50.0)
            make.trailing.equalToSuperview().offset(-50.0)
            make.bottom.equalToSuperview().offset(-32.0)
            make.height.equalTo(48.0)
        }
        
        super.updateConstraints()
    }
}
