//
//  SyncUserViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/8/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon
import SnapKit

class SyncUserBaseViewController: UIViewController {
    var userToAdd: User!
    let accountsView: SyncUserAccountsView
    let buttonTitle: String
    
    let headerView: SyncUserHeaderView = {
        let view = SyncUserHeaderView()
        view.backgroundColor = UIColor.Grayscale.background
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
    
    let fullView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let messageBanner: MessageBannerView = {
        let banner = MessageBannerView()
        banner.backgroundColor = UIColor.Matcha.sky
        banner.iconLabel.text = .featherIcon(name: .loader)
        banner.textColor = UIColor.Matcha.dusk
        banner.translatesAutoresizingMaskIntoConstraints = false
        
        return banner
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Matcha.dusk
        
        let attributedTitle = NSMutableAttributedString(string: "\(buttonTitle) \(String.featherIcon(name: .arrowRight))", attributes: [.foregroundColor: UIColor.white])
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
    
    let backgroundFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    init(currUser: User, buttonTitle: String) {
        accountsView = SyncUserAccountsView(user: currUser)
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        accountsView.backgroundColor = .white
        accountsView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed(_:)), for: .touchUpInside)
        
        view.addSubview(headerView)
        view.addSubview(fullView)
        fullView.addSubview(accountsView)
        fullView.addSubview(backgroundFooterView)
        fullView.addSubview(buttonStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        accountsView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        backgroundFooterView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(64.0)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
        }
        
        setupFullViewConstraints()
    }
    
    func setupFullViewConstraints() {
        view.addSubview(messageBanner)
        
        messageBanner.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40.0)
        }
        
        fullView.snp.makeConstraints { make in
            make.top.equalTo(self.messageBanner.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if confirmButton.frame.size.height > 0.0 {
            confirmButton.roundCorners(corners: [.topLeft], radius: 36.0)
        }
    }
    
    // MARK: user info
    
    func setupUserToAddInfo() {
        headerView.infoView.isHidden = false
        headerView.mutualUsersView.isHidden = false
        
        if let imageUrl = userToAdd.imageUrl {
            headerView.infoView.avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
        } else {
            headerView.infoView.avatarImageView.image = UIImage.blankAvatar
        }
        
        headerView.infoView.nameLabel.text = userToAdd.fullName
        headerView.infoView.bioLabel.text  = userToAdd.publicBio
        headerView.mutualUsersView.mutualImageUrls = userToAdd.mutualFriends.compactMap { $0.imageUrl }
        
        messageBanner.messageLabel.text = "\(userToAdd.fullName) is picking what to share..."
    }
    
    // MARK: buttons
    
    @objc func cancelButtonPressed(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmButtonPressed(_ sender: UIButton?) {
        
    }
}

class SyncUserAddViewController: SyncUserBaseViewController {
    init(currUser: User, userToAdd: User, buttonTitle: String) {
        super.init(currUser: currUser, buttonTitle: buttonTitle)
        self.userToAdd = userToAdd
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserToAddInfo()
    }
}
