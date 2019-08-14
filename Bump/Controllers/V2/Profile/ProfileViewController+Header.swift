//
//  ProfileViewController+Header.swift
//  Bump
//
//  Created by Tim Wong on 7/27/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon
import SDWebImage
import SnapKit

extension ProfileViewController {
    class HeaderView: UIView {
        let avatarImageView: UploadAvatarImageView = {
            let imageView = UploadAvatarImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.font = .avenirDemi(size: 24.0)
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
        
        init() {
            super.init(frame: .zero)
            commonInit()
        }
        
        convenience init(user: User) {
            self.init()
            
            if let imageUrl = user.imageUrl {
                avatarImageView.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
            }
            
            nameLabel.text = user.fullName
            bioLabel.text = user.publicBio
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
            addSubview(avatarImageView)
            addSubview(nameLabel)
            addSubview(bioLabel)
            
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            avatarImageView.snp.makeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
                make.height.width.equalTo(90.0)
            }
            
            nameLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalTo(self.avatarImageView.snp.trailing).offset(18.0)
                make.trailing.lessThanOrEqualToSuperview()
            }
            
            bioLabel.snp.makeConstraints { make in
                make.top.equalTo(self.nameLabel.snp.bottom)
                make.leading.equalTo(self.nameLabel)
                make.trailing.lessThanOrEqualToSuperview()
            }
            
            super.updateConstraints()
        }
    }
}
