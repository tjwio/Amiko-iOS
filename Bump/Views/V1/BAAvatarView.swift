//
//  BAAvatarView.swift
//  Bump
//
//  Created by Tim Wong on 7/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BAAvatarView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView(image: .blankAvatar)
        imageView.layer.cornerRadius = 62.5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.0
        
        return imageView
    }()
    
    var shadowHidden = false {
        didSet {
            updateShadow()
            setNeedsLayout()
        }
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    init(image: UIImage?, shadowHidden: Bool = false) {
        self.shadowHidden = shadowHidden
        super.init(frame: .zero)
        imageView.image = image
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
        updateShadow()
        
        addSubview(imageView)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = bounds.size.height / 2.0
        
        if shadowHidden {
            layer.shadowPath = nil
        }
        else {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.height / 2.0).cgPath
        }
        
    }
    
    private func updateShadow() {
        if shadowHidden {
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOffset = .zero
            layer.shadowRadius = 0.0
            layer.shadowOpacity = 0.0
        }
        else {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            layer.shadowRadius = 4.0
            layer.shadowOpacity = 0.5
        }
    }
}
