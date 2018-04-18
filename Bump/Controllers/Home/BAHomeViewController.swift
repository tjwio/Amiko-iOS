//
//  BSHomeViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/13/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import CoreMotion
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
        
        cameraButton.addTarget(self, action: #selector(self.showCamera(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(self.showSettings(_:)), for: .touchUpInside)
        
        let userHolder = BAUserHolder.shared
        let locationManager = BALocationManager.shared
        locationManager.initialize()
        
        BAUserHolder.shared.bumpMatchCallback = { [weak self] user in
            DispatchQueue.main.async {
                self?.showAddUser(user)
            }
        }
        
        BABumpManager.shared.bumpHandler = { [weak userHolder, weak locationManager]  bump in
            if let currentLocation = locationManager?.currentLocation {
                userHolder?.sendBumpReceivedEvent(bump: bump, location: currentLocation)
            }
        }
        BABumpManager.shared.start()
        
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
            make.height.width.equalTo(125.0)
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
    
    //MARK: add user
    
    private func showAddUser(_ userToAdd: BAUser) {
        let viewController = BAAddUserViewController(userToAdd: userToAdd)
        viewController.successCallback = { [weak self] in
            DispatchQueue.main.async {
                self?.showLeftMessage("Successfully added contact to address book and all accounts!", type: .success)
            }
        }
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    //MARK: camera button
    @objc private func showCamera(_ sender: UIButton?) {
        BAUserHolder.shared.sendBumpReceivedEvent(bump: BABumpEvent(acceleration: CMAcceleration(x: 0.0, y: 2.0, z: 27.0)), location: BALocationManager.shared.currentLocation!)
    }
    
    //MARK: settings button
    
    @objc private func showSettings(_ sender: UIButton?) {
        BAAppManager.shared.logOut()
    }
}
