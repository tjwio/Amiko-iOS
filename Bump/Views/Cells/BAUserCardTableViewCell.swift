//
//  BAUserCardTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 7/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BAUserCardTableViewCell: UITableViewCell {
    private struct Constants {
        static let borderColor = UIColor(hexColor: 0x979797)
        static let shadowColor = UIColor(hexColor: 0xCECECE)
        static let shadowOpacity: Float = 0.5
    }
    
    private(set) var isMain = false
    
    private let holderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = Constants.borderColor.cgColor
        view.layer.borderWidth = 0.30
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Blue.normal
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.dark
        label.font = UIFont.avenirBold(size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.dark
        label.font = UIFont.avenirMedium(size: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.dark
        label.font = UIFont.avenirMedium(size: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.light
        label.font = UIFont.avenirDemi(size: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.light
        label.font = UIFont.avenirDemi(size: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let avatarView: BAAvatarView = {
        let view = BAAvatarView()
        view.shadowHidden = true
        view.imageView.layer.cornerRadius = 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let socialDrawer: BASocialDrawerView = {
        let view = BASocialDrawerView(scale: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var labelStackView: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        labelStackView = UIStackView(arrangedSubviews: [nameLabel, jobLabel, phoneLabel, dateLabel, locationLabel])
        labelStackView.alignment = .leading
        labelStackView.axis = .vertical
        labelStackView.distribution = .fill
        labelStackView.spacing = 0.0
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        phoneLabel.isHidden = true
        dateLabel.isHidden = true
        locationLabel.isHidden = true
        socialDrawer.isHidden = true
        
        holderView.addSubview(labelStackView)
        contentView.addSubview(holderView)
        contentView.addSubview(avatarView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if isMain {
            self.headerView.snp.makeConstraints({ make in
                make.top.leading.bottom.equalTo(self.holderView)
                make.width.equalTo(20.0)
            })
            
            avatarView.snp.remakeConstraints({ make in
                make.leading.equalTo(self.contentView).offset(10.0)
                make.centerY.equalTo(self.contentView)
                make.height.width.equalTo(70.0)
            })
            
            labelStackView.snp.remakeConstraints({ make in
                make.top.equalTo(self.holderView).offset(16.0)
                make.leading.equalTo(holderView).offset(50.0)
                make.trailing.equalTo(self.holderView).offset(-20.0)
            })
            
            socialDrawer.snp.remakeConstraints { make in
                make.top.equalTo(self.labelStackView.snp.bottom).offset(6.0)
                make.leading.trailing.equalTo(self.labelStackView)
                make.height.equalTo(32.0)
                make.bottom.equalTo(self.holderView).offset(-16.0)
            }
        }
        else {
            avatarView.snp.remakeConstraints { make in
                make.leading.equalTo(self.contentView).offset(25.0)
                make.centerY.equalTo(self.contentView)
                make.height.width.equalTo(35.0)
            }
            
            labelStackView.snp.remakeConstraints { make in
                make.top.equalTo(self.holderView).offset(20.0)
                make.leading.equalTo(holderView).offset(40.0)
                make.trailing.equalTo(self.holderView).offset(-20.0)
                make.bottom.equalTo(self.holderView).offset(-20.0)
            }
        }
        
        holderView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(self.contentView)
            make.leading.equalTo(self.avatarView.snp.centerX)
        }
        
        super.updateConstraints()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.setHolderBackgroundColor(selected: highlighted)
            }
        }
        else {
            setHolderBackgroundColor(selected: highlighted)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.setHolderBackgroundColor(selected: selected)
            }
        }
        else {
            setHolderBackgroundColor(selected: selected)
        }
    }
    
    //MARK: layout helper
    
    func setIsMain(_ isMain: Bool, animted: Bool) {
        self.isMain = isMain
        
        if isMain {
            self.phoneLabel.isHidden = false
            self.dateLabel.isHidden = false
            self.locationLabel.isHidden = false
            self.socialDrawer.isHidden = socialDrawer.items.isEmpty
            
            self.layer.shadowColor = Constants.shadowColor.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.layer.shadowOpacity = Constants.shadowOpacity
            self.layer.shadowRadius = 4.0
            
            self.holderView.addSubview(self.headerView)
            self.holderView.addSubview(self.socialDrawer)
        }
        else {
            self.phoneLabel.isHidden = true
            self.dateLabel.isHidden = true
            self.locationLabel.isHidden = true
            
            holderView.layer.borderWidth = 0.30
            holderView.layer.shadowOpacity = 0.0
            holderView.layer.shadowRadius = 0.0
            
            self.headerView.removeFromSuperview()
            self.socialDrawer.removeFromSuperview()
        }
        
        setNeedsUpdateConstraints()
        
        if animted {
            UIView.animate(withDuration: 0.15) {
                self.layoutIfNeeded()
            }
        }
        else {
            layoutIfNeeded()
        }
    }
    
    private func setHolderBackgroundColor(selected: Bool) {
        if (selected) {
            holderView.backgroundColor = UIColor.Grayscale.lighter
        }
        else {
            holderView.backgroundColor = .white
        }
    }
}
