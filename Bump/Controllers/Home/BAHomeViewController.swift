//
//  BSHomeViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/13/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import CoreMotion
import Lottie
import SnapKit
import SDWebImage

class BAHomeViewController: UIViewController {
    private struct Constants {
        static let instructionsHold = "Hold anywhere to bump"
        static let instructionsBump = "Bump now"
        static let firstFrame = NSNumber(value: 36.0)
    }
    
    let accountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.35)
        button.setTitle(String.featherIcon(name: .edit2), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.featherFont(size: 20.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22.0
        
        return button
    }()
    
    let avatarImageView: BAAvatarView = {
        let imageView = BAAvatarView(image: .blankAvatar, shadowHidden: true)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let backgroundHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let bumpAnimation: LOTAnimationView = {
        let animation = LOTAnimationView(name: "bump")
        animation.contentMode = .scaleAspectFit
        animation.loopAnimation = true
        animation.setProgressWithFrame(Constants.firstFrame)
        animation.isHidden = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        return animation
    }()
    
    let bumpImageView: UIImageView = {
        let view = UIImageView(image: .bumpGray)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let bumpInstructionsLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.instructionsHold
        label.textColor = UIColor.Grayscale.light
        label.font = UIFont.avenirUltraLightItalic(size: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let holderAnimationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var isHoldingToBump = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = UIColor(hexColor: 0xFBFCFD)
        
        let holdGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.holdGestureRecognized(_:)))
        holdGestureRecognizer.minimumPressDuration = 0.0
        holdGestureRecognizer.delegate = self
        view.addGestureRecognizer(holdGestureRecognizer)
        
        let user = BAUserHolder.shared.user
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        
        if let fullJobCompany = user.fullJobCompany {
            jobLabel.isHidden = false
            jobLabel.text = fullJobCompany
        }
        else {
            jobLabel.isHidden = true
        }
        
        if user.imageUrl != nil {
            avatarImageView.imageView.sd_setIndicatorStyle(.gray)
            avatarImageView.imageView.sd_addActivityIndicator()
            avatarImageView.imageView.sd_showActivityIndicatorView()
            
            user.loadImage(success: { (image, colors) in
                self.avatarImageView.imageView.image = image
                self.avatarImageView.imageView.sd_removeActivityIndicator()
                self.backgroundHeaderView.backgroundColor = colors.background
            }) { _ in
                self.avatarImageView.imageView.sd_removeActivityIndicator()
            }
        }
        
        cameraButton.addTarget(self, action: #selector(self.showCamera(_:)), for: .touchUpInside)
        accountButton.addTarget(self, action: #selector(self.showAccount(_:)), for: .touchUpInside)
        
        let userHolder = BAUserHolder.shared
        let locationManager = BALocationManager.shared
        locationManager.initialize()
        
        BAUserHolder.shared.bumpMatchCallback = { [weak self] user in
            DispatchQueue.main.async {
                self?.showAddUser(user)
            }
        }
        
        BABumpManager.shared.bumpHandler = { [weak userHolder, weak locationManager, weak self]  bump in
            if self?.isHoldingToBump ?? false, let currentLocation = locationManager?.currentLocation {
                userHolder?.sendBumpReceivedEvent(bump: bump, location: currentLocation)
            }
        }
        BABumpManager.shared.start()
        
        holderAnimationView.addSubview(bumpImageView)
        holderAnimationView.addSubview(bumpAnimation)
        holderAnimationView.addSubview(bumpInstructionsLabel)
        view.addSubview(backgroundHeaderView)
        view.addSubview(accountButton)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(jobLabel)
        view.addSubview(holderAnimationView)
        view.addSubview(cameraButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        accountButton.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(36.0)
            make.leading.equalTo(self.view).offset(16.0)
            make.height.width.equalTo(44.0)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(85.0)
            make.centerX.equalTo(self.view)
            make.height.width.equalTo(125.0)
        }
        
        backgroundHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.avatarImageView.snp.centerY)
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30.0)
            make.centerX.equalTo(self.view)
        }
        
        holderAnimationView.snp.makeConstraints { make in
            make.top.equalTo(self.jobLabel.snp.bottom).offset(16.0)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
        
        bumpAnimation.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(250.0)
            make.width.equalTo(250.0)
        }
        
        bumpImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(135.0)
            make.width.equalTo(135.0)
        }
        
        bumpInstructionsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.bumpImageView.snp.top).offset(30.0)
            make.centerX.equalToSuperview()
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
    
    //MARK: hold gesture
    
    @objc private func holdGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            isHoldingToBump = true
            bumpInstructionsLabel.text = Constants.instructionsBump
            
            bumpAnimation.loopAnimation = true
            bumpAnimation.isHidden = false
            bumpAnimation.alpha = 0.0
            bumpAnimation.setProgressWithFrame(Constants.firstFrame)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bumpAnimation.alpha = 1.0
                self.bumpImageView.alpha = 0.0
            }) { _ in
                self.bumpAnimation.play(fromProgress: 0.0, toProgress: 1.0, withCompletion: nil)
                self.bumpImageView.isHidden = true
            }
        }
        else if sender.state == .ended {
            isHoldingToBump = false
            bumpInstructionsLabel.text = Constants.instructionsHold
            bumpImageView.alpha = 0.0
            bumpImageView.isHidden = false
            
            bumpAnimation.pause()
            bumpAnimation.loopAnimation = false
            bumpAnimation.play(toFrame: Constants.firstFrame, withCompletion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.bumpImageView.alpha = 1.0
                    self.bumpAnimation.alpha = 0.0
                }) { _ in
                    self.bumpAnimation.isHidden = true
                    self.bumpImageView.isHidden = false
                }
            })
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isKind(of: UIControl.classForCoder()) ?? false {
            return false
        }
        
        return true
    }
    
    //MARK: camera button
    @objc private func showCamera(_ sender: UIButton?) {
//        let mockLocation = CLLocation(latitude: 34.029526415497742, longitude: -118.28915680636308)
        
        BAUserHolder.shared.sendBumpReceivedEvent(bump: BABumpEvent(acceleration: CMAcceleration(x: 0.0, y: 2.0, z: 27.0)), location: BALocationManager.shared.currentLocation!)
        
//        let viewController = BACameraViewController()
//        self.present(viewController, animated: true, completion: nil)
        
//        let viewController = BAAddUserViewController(userToAdd: BAUserHolder.shared.user)
//        viewController.providesPresentationContextTransitionStyle = true
//        viewController.definesPresentationContext = true
//        viewController.modalPresentationStyle = .overCurrentContext
//
//        self.present(viewController, animated: false, completion: nil)
    }
    
    //MARK: account button
    
    @objc private func showAccount(_ sender: UIButton?) {
        let viewController = BAProfileViewController(user: BAUserHolder.shared.user)
        viewController.successCallback = { [weak self] in
            DispatchQueue.main.async {
                self?.showLeftMessage("Successfully updated profile", type: .success)
            }
        }
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        
        self.present(viewController, animated: false, completion: nil)
    }
}
