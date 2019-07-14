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

class SyncUserViewController: UIViewController {
    let userToAdd: User
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
        
        let attributedTitle = NSMutableAttributedString(string: "\(String.featherIcon(name: .x)) Cancel", attributes: [.foregroundColor: UIColor.Matcha.dusk])
        attributedTitle.addAttribute(.font, value: UIFont.featherFont(size: 20.0)!, range: NSMakeRange(0, 1))
        attributedTitle.addAttribute(.font, value: UIFont.avenirDemi(size: 14.0)!, range: NSMakeRange(1, attributedTitle.length-1))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Matcha.dusk
        
        let attributedTitle = NSMutableAttributedString(string: "\(buttonTitle) \(String.featherIcon(name: .x))", attributes: [.foregroundColor: UIColor.Matcha.dusk])
        attributedTitle.addAttribute(.font, value: UIFont.featherFont(size: 20.0)!, range: NSMakeRange(attributedTitle.length-2, 1))
        attributedTitle.addAttribute(.font, value: UIFont.avenirDemi(size: 14.0)!, range: NSMakeRange(0, attributedTitle.length-1))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.roundCorners(corners: [.topLeft], radius: 40.0)
        
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
    
    init(currUser: User, userToAdd: User, buttonTitle: String) {
        self.userToAdd = userToAdd
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
        
        if let imageUrl = userToAdd.imageUrl {
            headerView.infoView.avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
        } else {
            headerView.infoView.avatarImageView.image = UIImage.blankAvatar
        }
        
        headerView.infoView.nameLabel.text = userToAdd.fullName
        headerView.infoView.bioLabel.text  = userToAdd.publicBio
        
        view.addSubview(headerView)
        view.addSubview(accountsView)
        view.addSubview(buttonStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        accountsView.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
            make.bottom.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
        }
    }
}
