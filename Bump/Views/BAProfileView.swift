//
//  BAProfileView.swift
//  Bump
//
//  Created by Tim Wong on 8/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BAProfileView: UIView {
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.35)
        button.setTitle(String.featherIcon(name: .x), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.featherFont(size: 20.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22.0
        
        return button
    }()
    
    let saveButton: BALoadingButton = {
        let button = BALoadingButton(type: .custom)
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.35)
        button.setTitle(String.featherIcon(name: .check), for: .normal)
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
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
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
    }
}
