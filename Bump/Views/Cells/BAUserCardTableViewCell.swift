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
    
    private let holderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        label.font = UIFont.avenirMedium(size: 10.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.dark
        label.font = UIFont.avenirMedium(size: 10.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.light
        label.font = UIFont.avenirDemi(size: 10.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Grayscale.light
        label.font = UIFont.avenirDemi(size: 10.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let avatarView: BAAvatarView = {
        let view = BAAvatarView()
        view.imageView.layer.cornerRadius = 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var labelStackView: UIStackView!
    
    private var didSetupInitialConstraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        layer.borderColor = Constants.borderColor.cgColor
        layer.cornerRadius = 6.0
        
        labelStackView = UIStackView(arrangedSubviews: [nameLabel, jobLabel, phoneLabel, dateLabel, locationLabel])
        labelStackView.alignment = .leading
        labelStackView.axis = .vertical
        labelStackView.distribution = .fill
        labelStackView.spacing = 0.0
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        holderView.addSubview(labelStackView)
        contentView.addSubview(holderView)
        contentView.addSubview(avatarView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupInitialConstraints {
            avatarView.snp.makeConstraints { make in
                make.leading.equalTo(self.contentView).offset(15.0)
                make.centerY.equalTo(self.contentView)
                make.height.width.equalTo(30.0)
            }
            
            labelStackView.snp.makeConstraints { make in
                make.top.equalTo(self.holderView).offset(20.0)
                make.leading.equalTo(holderView).offset(40.0)
                make.trailing.equalTo(self.holderView).offset(-20.0)
                make.bottom.equalTo(self.holderView).offset(-20.0)
            }
            
            holderView.snp.makeConstraints { make in
                make.top.trailing.bottom.equalTo(self.contentView)
                make.leading.equalTo(self.avatarView.snp.centerX)
            }
            
            didSetupInitialConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        coordinator.addCoordinatedFocusingAnimations({ [weak self] context in
            guard let strongSelf = self else { return }
            
            strongSelf.phoneLabel.isHidden = true
            strongSelf.dateLabel.isHidden = true
            strongSelf.locationLabel.isHidden = true
            
            strongSelf.layer.borderWidth = 0.0
            strongSelf.layer.shadowColor = Constants.shadowColor.cgColor
            strongSelf.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            strongSelf.layer.shadowOpacity = Constants.shadowOpacity
            strongSelf.layer.shadowRadius = 4.0
            
            strongSelf.holderView.addSubview(strongSelf.headerView)
            
            strongSelf.headerView.snp.makeConstraints({ make in
                make.top.leading.trailing.equalTo(strongSelf.holderView)
                make.height.equalTo(30.0)
            })
            
            strongSelf.labelStackView.snp.updateConstraints({ make in
                make.top.equalTo(strongSelf.holderView).offset(40.0)
                make.bottom.equalTo(strongSelf.holderView).offset(-25.0)
            })
            
            strongSelf.avatarView.snp.updateConstraints({ make in
                make.leading.equalTo(strongSelf.contentView).offset(0.0)
                make.height.width.equalTo(60.0)
            })
            
            strongSelf.layoutIfNeeded()
        }, completion: nil)
        
        coordinator.addCoordinatedUnfocusingAnimations({ [weak self] context in
            guard let strongSelf = self else { return }
            
            strongSelf.phoneLabel.isHidden = false
            strongSelf.dateLabel.isHidden = false
            strongSelf.locationLabel.isHidden = false
            
            strongSelf.layer.borderWidth = 0.30
            strongSelf.layer.shadowOpacity = 0.0
            strongSelf.layer.shadowRadius = 0.0
            
            strongSelf.headerView.removeFromSuperview()
            
            strongSelf.labelStackView.snp.updateConstraints({ make in
                make.top.equalTo(strongSelf.holderView).offset(20.0)
                make.bottom.equalTo(strongSelf.holderView).offset(-20.0)
            })
            
            strongSelf.avatarView.snp.updateConstraints({ make in
                make.leading.equalTo(strongSelf.contentView).offset(15.0)
                make.height.width.equalTo(30.0)
            })
            
            strongSelf.layoutIfNeeded()
        }, completion: nil)
    }
}
