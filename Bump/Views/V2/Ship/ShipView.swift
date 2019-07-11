//
//  ShipView.swift
//  Bump
//
//  Created by Tim Wong on 7/10/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class ShipTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 20.0)
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirRegular(size: 14.0)
        label.numberOfLines = 3
        label.textColor = UIColor.Grayscale.light
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .blankAvatar)
        imageView.layer.cornerRadius = 45.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Grayscale.background
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let accountsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bioLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(accountsScrollView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(24.0)
            make.height.width.equalTo(60.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView)
            make.leading.equalTo(self.avatarImageView.snp.trailing).offset(16.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-16.0)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8.0)
            make.leading.trailing.equalTo(self.nameLabel)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(44.0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2.0)
        }
        
        accountsScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.separatorView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(36.0)
        }
        
        super.updateConstraints()
    }
}
