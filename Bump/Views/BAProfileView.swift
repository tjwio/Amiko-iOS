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
        button.setTitle(String.featherIcon(name: .x), for: .normal)
        button.setTitleColor(UIColor.Grayscale.dark, for: .normal)
        button.titleLabel?.font = UIFont.featherFont(size: 24.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let saveButton: BALoadingButton = {
        let button = BALoadingButton(type: .custom)
        button.activityIndicator.color = UIColor.Grayscale.dark
        button.setTitle(String.featherIcon(name: .check), for: .normal)
        button.setTitleColor(UIColor.Grayscale.dark, for: .normal)
        button.titleLabel?.font = UIFont.featherFont(size: 24.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Profile"
        label.textColor = UIColor.Grayscale.dark
        label.font = UIFont.avenirBold(size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let avatarImageView: BAAvatarView = {
        let imageView = BAAvatarView(image: .blankAvatar, shadowHidden: true)
        imageView.imageView.layer.borderWidth = 0.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
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
        
        addSubview(cancelButton)
        addSubview(saveButton)
        addSubview(titleLabel)
        addSubview(avatarImageView)
        addSubview(tableView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        cancelButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16.0)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32.0)
            make.centerX.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12.0)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(12.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
