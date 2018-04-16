//
//  BSHomeViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/13/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class BAHomeViewController: UIViewController {
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("\u{F013}", for: .normal)
        button.setTitleColor(UIColor(hexColor: 0x9DA3AD), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(size: 24.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let accountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("\u{F007}", for: .normal)
        button.setTitleColor(UIColor(hexColor: 0x9DA3AD), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(size: 24.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "example_avatar"))
        imageView.layer.cornerRadius = 62.5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexColor: 0x656A6F)
        label.font = UIFont.avenirDemi(size: 22.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "Lead Designer at Spotify"
        label.textColor = UIColor(hexColor: 0xA7ADB6)
        label.font = UIFont.avenirRegular(size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera_button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = UIColor(hexColor: 0xFBFCFD)
        
        let user = BAUserHolder.shared.user
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        if let imageUrl = user.imageUrl {
            avatarImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        
        BALocationManager.shared.initialize()
        
        view.addSubview(settingsButton)
        view.addSubview(accountButton)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(jobLabel)
        view.addSubview(cameraButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(36.0)
            make.leading.equalTo(self.view).offset(16.0)
        }
        
        accountButton.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(36.0)
            make.trailing.equalTo(self.view).offset(-16.0)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(60.0)
            make.centerX.equalTo(self.view)
            make.width.height.equalTo(125.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(20.0)
            make.centerX.equalTo(self.view)
        }
        
        jobLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(4.0)
            make.centerX.equalTo(self.view)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-30.0)
            make.centerX.equalTo(self.view)
        }
    }
}
