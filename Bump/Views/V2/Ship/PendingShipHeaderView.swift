//
//  ShipListViewController+Pending.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class PendingShipHeaderView: UIView {
    class AvatarView: UIView {
        let avatarImageView: UIImageView = {
            let imageView = UIImageView(image: .blankAvatar)
            imageView.layer.cornerRadius = 30.0
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.font = .avenirRegular(size: 14.0)
            label.textColor = UIColor.Grayscale.light
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        init() {
            super.init(frame: .zero)
            commonInit()
        }
        
        init(name: String, imageUrl: String?) {
            super.init(frame: .zero)
            
            if let imageUrl = imageUrl {
                avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
            }
            
            nameLabel.text = name
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
            addSubview(avatarImageView)
            addSubview(nameLabel)
            
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            avatarImageView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.width.equalTo(60.0)
            }
            
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(self.avatarImageView.snp.bottom).offset(8.0)
                make.bottom.centerY.equalToSuperview()
            }
            
            super.updateConstraints()
        }
    }
    
    var pendingShips = [Ship]() {
        didSet {
            
        }
    }
    
    var avatarViews = [AvatarView]()
    
    let pendingLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 14.0)
        label.text = "PENDING"
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    init(pendingShips: [Ship]) {
        self.pendingShips = pendingShips
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
        addSubview(pendingLabel)
        addSubview(scrollView)
        
        setupAvatarViews(ships: pendingShips)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        pendingLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.pendingLabel.snp.bottom).offset(12.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    private func setupAvatarViews(ships: [Ship]) {
        avatarViews.forEach { $0.removeFromSuperview() }
        avatarViews = []
        
        avatarViews = ships.map { ship in
            let view = AvatarView(name: ship.user.fullName, imageUrl: ship.user.imageUrl)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        var previousAvatarView: AvatarView?
        
        avatarViews.forEach { avatarView in
            scrollView.addSubview(avatarView)
            
            avatarView.snp.makeConstraints { make in
                if let previousAvatarView = previousAvatarView {
                    make.leading.equalTo(previousAvatarView.snp.trailing).offset(32.0)
                } else {
                    make.leading.equalToSuperview()
                }
                
                make.top.bottom.equalToSuperview()
            }
            
            previousAvatarView = avatarView
        }
        
        previousAvatarView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
    }
}
