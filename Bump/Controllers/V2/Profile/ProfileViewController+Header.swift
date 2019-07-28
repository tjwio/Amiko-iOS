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
        let avatarImageView: UIImageView = {
            let imageView = UIImageView(image: .blankAvatar)
            imageView.layer.cornerRadius = 45.0
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let uploadLabel: UILabel = {
            let label = UILabel()
            label.font = .featherFont(size: 14.0)
            label.text = .featherIcon(name: .arrowUp)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let uploadHolderView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.Matcha.dusk
            view.clipsToBounds = true
            view.layer.cornerRadius = 10.0
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
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
                avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
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
            uploadHolderView.addSubview(uploadLabel)
            addSubview(avatarImageView)
            addSubview(uploadHolderView)
            addSubview(nameLabel)
            addSubview(bioLabel)
            
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            avatarImageView.snp.makeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
                make.height.width.equalTo(90.0)
            }
            
            uploadLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            uploadHolderView.snp.makeConstraints { make in
                make.trailing.bottom.equalTo(avatarImageView)
                make.height.width.equalTo(20.0)
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
