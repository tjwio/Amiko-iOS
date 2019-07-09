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

class SyncUserHeaderView: UIView {
    var mutualImageUrls = [String]() {
        didSet {
            updateMutualAvatars(urls: mutualImageUrls)
        }
    }
    
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
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Matcha.dusk
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let mutualLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirRegular(size: 14.0)
        label.textColor = UIColor.Matcha.dusk
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let mutualScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, bioLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var mutualImageViews = [UIImageView]()
    
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
        
        addSubview(labelStackView)
        addSubview(avatarImageView)
        addSubview(separatorView)
        addSubview(mutualLabel)
        addSubview(mutualScrollView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(90.0)
            make.width.equalTo(90.0)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).offset(18.0)
            make.centerY.equalTo(self.avatarImageView)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(32.0)
            make.height.equalTo(4.0)
            make.width.equalTo(32.0)
        }
        
        mutualLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(self.separatorView.snp.bottom).offset(9.0)
        }
        
        mutualScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.mutualLabel.snp.bottom).offset(12.0)
        }
        
        super.updateConstraints()
    }
    
    private func updateMutualAvatars(urls: [String]) {
        mutualImageViews.forEach { $0.removeFromSuperview() }
        mutualImageViews = []
        
        let imageViews = urls.map { url -> UIImageView in
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage.blankAvatar, completed: nil)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }
        
        var previousImageView: UIImageView?
        
        imageViews.forEach { imageView in
            self.labelStackView.addSubview(imageView)
            
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
