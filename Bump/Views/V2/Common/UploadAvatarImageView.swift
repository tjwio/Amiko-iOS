//
//  UploadAvatarImageView.swift
//  Bump
//
//  Created by Tim Wong on 8/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class UploadAvatarImageView: UIView {
    let imageView: UIImageView = {
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
        clipsToBounds = false
        
        uploadHolderView.addSubview(uploadLabel)
        addSubview(imageView)
        addSubview(uploadHolderView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        uploadLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        uploadHolderView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView)
            make.height.width.equalTo(20.0)
        }
        
        super.updateConstraints()
    }
}
