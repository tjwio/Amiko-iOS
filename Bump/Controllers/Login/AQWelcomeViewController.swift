//
//  AQWelcomeViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class AQWelcomeViewController: UIViewController {
    
    let ciaoLabel: UILabel = {
        let label = UILabel()
        label.text = "Ciao."
        label.textColor = .white
        label.font = UIFont.mainBold(size: 60.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "login_background"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let backgroundOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexColor: 0x003F65, alpha: 0.80)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.textColor = .white
        label.font = UIFont.mainDemi(size: 28.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Get set up and running in seconds"
        label.textColor = .white
        label.font = UIFont.mainDemi(size: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(hexColor: 0x2895F1)
        button.setTitle("CREATE ACCOUNT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.mainDemi(size: 17.0)
        button.layer.cornerRadius = 4.0
        
        return button
    }()
    
    let loginButton: UIButton = {
        let loginAttString = NSMutableAttributedString(string: "Log in");
        loginAttString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, loginAttString.length));
        loginAttString.addAttribute(.foregroundColor, value: UIColor.white, range: NSMakeRange(0, loginAttString.length));
        
        let button = UIButton(type: .custom)
        button.setAttributedTitle(loginAttString, for: .normal)
        button.titleLabel?.font = UIFont.mainDemi(size: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let rocketImageView = UIImageView(image: UIImage(named: "welcome_rocketship"))
    var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labelStackView = UIStackView(arrangedSubviews: [welcomeLabel, detailLabel])
        labelStackView.alignment = .center
        labelStackView.axis = .vertical
        labelStackView.distribution = .fill
        labelStackView.spacing = 6.0
        
        stackView = UIStackView(arrangedSubviews: [rocketImageView, labelStackView])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.addSubview(backgroundOverlayView)
        view.addSubview(backgroundImageView)
        view.addSubview(ciaoLabel)
        view.addSubview(stackView)
        view.addSubview(createAccountButton)
        view.addSubview(loginButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundOverlayView.snp.makeConstraints { make in
            make.edges.equalTo(self.backgroundImageView)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        ciaoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(105.0)
            make.centerX.equalTo(self.view)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-30.0)
            make.centerX.equalTo(self.view)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(48.0)
            make.trailing.equalTo(self.view).offset(-48.0)
            make.bottom.equalTo(self.loginButton.snp.top).offset(-20.0)
            make.centerX.equalTo(self.view)
            make.height.equalTo(48.0)
        }
    }
}
