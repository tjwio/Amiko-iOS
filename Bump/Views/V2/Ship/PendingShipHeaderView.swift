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

protocol PendingShipHeaderViewDelegate: class {
    func pendingHeaderView(_ view: PendingShipHeaderView, didSelect ship: Ship)
}

class PendingShipHeaderView: UIView {
    weak var delegate: PendingShipHeaderViewDelegate?
    
    class AvatarView: UIView {
        let avatarButton: UIButton = {
            let imageView = UIButton(type: .custom)
            imageView.setImage(.blankAvatar, for: .normal)
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
                avatarButton.sd_setImage(with: URL(string: imageUrl), for: .normal, placeholderImage: .blankAvatar)
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
            addSubview(avatarButton)
            addSubview(nameLabel)
            
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            avatarButton.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.width.equalTo(60.0)
            }
            
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(self.avatarButton.snp.bottom).offset(8.0)
                make.bottom.centerX.equalToSuperview()
            }
            
            super.updateConstraints()
        }
    }
    
    var pendingShips = [Ship]() {
        didSet {
            setupAvatarViews(ships: pendingShips)
        }
    }
    
    var avatarViews = [AvatarView]()
    
    let pendingLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 16.0)
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
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Grayscale.light
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        addSubview(separatorView)
        
        setupAvatarViews(ships: pendingShips)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        pendingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.leading.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.pendingLabel.snp.bottom).offset(12.0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(91.0)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.snp.bottom).offset(16.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    private func setupAvatarViews(ships: [Ship]) {
        avatarViews.forEach { $0.removeFromSuperview() }
        avatarViews = []
        
        avatarViews = ships.map { ship in
            let view = AvatarView(name: ship.user.firstName, imageUrl: ship.user.imageUrl)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        var previousAvatarView: AvatarView?
        
        avatarViews.forEach { avatarView in
            avatarView.avatarButton.addTarget(self, action: #selector(self.avatarButtonTapped(_:)), for: .touchUpInside)
            
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
    
    @objc private func avatarButtonTapped(_ sender: UIButton) {
        let temp = avatarViews.map { $0.avatarButton }.firstIndex(of: sender)
        guard let index = temp else { return }
        
        delegate?.pendingHeaderView(self, didSelect: pendingShips[index])
    }
}
