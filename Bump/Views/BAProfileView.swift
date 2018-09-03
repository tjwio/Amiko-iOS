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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 16.0, 0.0)
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
            make.height.width.equalTo(44.0)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.height.width.equalTo(44.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32.0)
            make.centerX.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12.0)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(12.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
            make.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
