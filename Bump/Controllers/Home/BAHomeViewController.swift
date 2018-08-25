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
        button.setTitle(String.fontAwesomeIcon(name: .cog), for: .normal)
        button.setTitleColor(UIColor(hexColor: 0x9DA3AD), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 24.0, style: .solid)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let accountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(String.fontAwesomeIcon(name: .user), for: .normal)
        button.setTitleColor(UIColor(hexColor: 0x9DA3AD), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 24.0, style: .solid)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: .upwardDoubleArrow)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let avatarImageView: BAAvatarView = {
        let imageView = BAAvatarView()
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
    
    let firstRing = UIImageView(image: UIImage(named: "interstitial-ring1"))
    let secondRing = UIImageView(image: UIImage(named: "interstitial-ring2"))
    let thirdRing = UIImageView(image: UIImage(named: "interstitial-ring3"))
    let pin = UIImageView(image: UIImage(named: "interstitial-pin"))
    let holderView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = UIColor(hexColor: 0xFBFCFD)
        
        let user = BAUserHolder.shared.user
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        if let profession = user.profession {
            jobLabel.text = profession
        }
        if let imageUrl = user.imageUrl {
            avatarImageView.imageView.sd_setIndicatorStyle(.gray)
            avatarImageView.imageView.sd_showActivityIndicatorView()
            avatarImageView.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar, options: .retryFailed) { (image, _, _, _) in
                user.image.value = image
            }
        }
        
        cameraButton.addTarget(self, action: #selector(self.showCamera(_:)), for: .touchUpInside)
        accountButton.addTarget(self, action: #selector(self.showAccount(_:)), for: .touchUpInside)
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
        
        holderView.backgroundColor = .clear
        holderView.translatesAutoresizingMaskIntoConstraints = false
        firstRing.alpha = 0.0;
        firstRing.translatesAutoresizingMaskIntoConstraints = false;
        secondRing.alpha = 0.0;
        secondRing.translatesAutoresizingMaskIntoConstraints = false;
        thirdRing.alpha = 0.0;
        thirdRing.translatesAutoresizingMaskIntoConstraints = false;
        pin.alpha = 0.0;
        pin.translatesAutoresizingMaskIntoConstraints = false;
        
        self.animateRingsAndPin();
        
        holderView.addSubview(self.thirdRing)
        holderView.addSubview(self.secondRing)
        holderView.addSubview(self.firstRing)
        holderView.addSubview(self.pin)
        view.addSubview(settingsButton)
        view.addSubview(accountButton)
        view.addSubview(arrowImageView)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(jobLabel)
        view.addSubview(cameraButton)
        view.addSubview(holderView)
        
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
        
        arrowImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(46.0)
            make.centerX.equalTo(self.view)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.arrowImageView.snp.bottom).offset(16.0)
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
        
        holderView.snp.makeConstraints { make in
            make.top.equalTo(self.jobLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.cameraButton.snp.top).offset(-16.0)
        }
        
        pin.snp.makeConstraints { make in
            make.centerX.equalTo(self.holderView)
            make.centerY.equalTo(self.holderView).offset(-40.0)
        }
        
        firstRing.snp.makeConstraints { make in
            make.centerX.equalTo(self.holderView)
            make.centerY.equalTo(self.pin).offset(16.0)
        }
        
        secondRing.snp.makeConstraints { make in
            make.centerX.equalTo(self.holderView)
            make.centerY.equalTo(self.firstRing)
        }
        
        thirdRing.snp.makeConstraints { make in
            make.centerX.equalTo(self.holderView)
            make.centerY.equalTo(self.secondRing)
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
//        let mockLocation = CLLocation(latitude: 34.029526415497742, longitude: -118.28915680636308)
        
//        BAUserHolder.shared.sendBumpReceivedEvent(bump: BABumpEvent(acceleration: CMAcceleration(x: 0.0, y: 2.0, z: 27.0)), location: BALocationManager.shared.currentLocation!)
        
//        let viewController = BACameraViewController()
//        self.present(viewController, animated: true, completion: nil)
        
        let viewController = BAAddUserViewController(userToAdd: BAUserHolder.shared.user)
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    //MARK: account button
    
    @objc private func showAccount(_ sender: UIButton?) {
        let viewController = BAHistoryHolderViewController(user: BAUserHolder.shared.user)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: settings button
    
    @objc private func showSettings(_ sender: UIButton?) {
        BAAppManager.shared.logOut()
    }
    
    //MARK: animation helper
    
    private func animateRingsAndPin() {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.pin.alpha = 1.0;
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.25, animations: {
                self.firstRing.alpha = 1.0;
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.25, animations: {
                self.secondRing.alpha = 1.0;
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.25, animations: {
                self.thirdRing.alpha = 1.0;
            })
        }) { _ in
            UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                    self.thirdRing.alpha = 0.0;
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.25, animations: {
                    self.secondRing.alpha = 0.0;
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.25, animations: {
                    self.firstRing.alpha = 0.0;
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.25, animations: {
                    self.pin.alpha = 0.0;
                })
            }) { _ in
                self.animateRingsAndPin();
            }
        }
    }
}
