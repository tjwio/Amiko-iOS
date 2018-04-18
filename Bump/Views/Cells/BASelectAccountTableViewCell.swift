//
//  BASelectAccountTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 4/16/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BASelectAccountTableViewCell: UITableViewCell {
    let accountHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexColor: 0xD8DBE0)
        view.layer.cornerRadius = 21.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkmark_dark"))
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let accountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let iconLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.fontAwesome(size: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let accountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexColor: 0x656A6F)
        label.font = UIFont.avenirRegular(size: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(hexColor: 0xE6E9ED).cgColor
        
        accountHolderView.addSubview(accountImageView)
        accountHolderView.addSubview(iconLabel)
        contentView.addSubview(accountHolderView)
        contentView.addSubview(accountLabel)
        contentView.addSubview(checkmarkImageView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        accountImageView.snp.makeConstraints { make in
            make.center.equalTo(self.accountHolderView)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.center.equalTo(self.accountHolderView)
        }
        
        accountHolderView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView).offset(11.0)
            make.centerY.equalTo(self.contentView)
            make.height.width.equalTo(42.0)
        }
        
        accountLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.accountHolderView.snp.trailing).offset(13.0)
            make.centerY.equalTo(self.contentView)
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView).offset(-24.0)
            make.leading.greaterThanOrEqualTo(self.accountLabel.snp.trailing).offset(8.0)
            make.centerY.equalTo(self.contentView)
        }
        
        super.updateConstraints()
    }
}
