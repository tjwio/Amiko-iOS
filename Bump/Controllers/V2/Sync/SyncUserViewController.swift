//
//  SyncUserViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/8/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class SyncUserViewController: UIViewController {
    let userToAdd: User
    let accountsView: SyncUserAccountsView
    
    let headerView: SyncUserHeaderView = {
        let view = SyncUserHeaderView()
        view.backgroundColor = UIColor.Grayscale.background
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(currUser: User, userToAdd: User) {
        self.userToAdd = userToAdd
        accountsView = SyncUserAccountsView(user: currUser)
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
            headerView.avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
        } else {
            headerView.avatarImageView.image = UIImage.blankAvatar
        }
        
        headerView.nameLabel.text = userToAdd.fullName
        headerView.bioLabel.text  = userToAdd.publicBio
        
        view.addSubview(headerView)
        view.addSubview(accountsView)
        
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
    }
}
