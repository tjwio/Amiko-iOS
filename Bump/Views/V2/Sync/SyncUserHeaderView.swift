//
//  SyncUserHeaderView.swift
//  Bump
//
//  Created by Tim Wong on 7/8/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class UserInfoView: UIView {
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
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .blankAvatar)
        imageView.layer.cornerRadius = 45.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
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
        backgroundColor = UIColor.Grayscale.background
        
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
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(self.avatarImageView.snp.trailing).offset(18.0)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(12.0)
            make.leading.equalTo(self.avatarImageView)
            make.trailing.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}

class MutualUsersView: UIView {
    var mutualImageUrls = [String]() {
        didSet {
            updateMutualAvatars(urls: mutualImageUrls)
        }
    }
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Matcha.dusk
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .avenirRegular(size: 14.0)
        label.textColor = UIColor.Matcha.dusk
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private var imageViews = [UIImageView]()
    
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
        backgroundColor = UIColor.Grayscale.background
        
        addSubview(separatorView)
        addSubview(label)
        addSubview(scrollView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        separatorView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(4.0)
            make.width.equalTo(32.0)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(self.separatorView.snp.bottom).offset(9.0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.label.snp.bottom).offset(12.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    private func updateMutualAvatars(urls: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []
        
        let imageViews = urls.map { url -> UIImageView in
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage.blankAvatar, completed: nil)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }
        
        var previousImageView: UIImageView?
        
        imageViews.forEach { imageView in
            scrollView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                if let previous = previousImageView {
                    make.leading.equalTo(previous).offset(8.0)
                } else {
                    make.leading.equalToSuperview()
                }
                
                make.top.bottom.equalToSuperview()
                make.height.width.equalTo(32.0)
            }
            
            previousImageView = imageView
        }
        
        if let previous = previousImageView {
            previous.snp.makeConstraints { make in
                make.trailing.lessThanOrEqualToSuperview()
            }
        }
    }
}

class SyncUserHeaderView: UIView {
    let infoView: UserInfoView = {
        let view = UserInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let mutualUsersView: MutualUsersView = {
        let view = MutualUsersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        backgroundColor = UIColor.Grayscale.background
        
        addSubview(infoView)
        addSubview(mutualUsersView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(56.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.lessThanOrEqualToSuperview().offset(-32.0)
        }
        
        mutualUsersView.snp.makeConstraints { make in
            make.top.equalTo(self.infoView.snp.bottom).offset(32.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
            make.bottom.equalToSuperview().offset(-12.0)
        }
        
        super.updateConstraints()
    }
}
