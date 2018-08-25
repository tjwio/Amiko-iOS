//
//  BASocialDrawerTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 8/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BASocialDrawerTableViewCell: UITableViewCell {
    var selectCallback: ((BAAccountContact, String) -> Void)?
    var items = [(BAAccountContact, String)]() {
        didSet {
            addSocialButtons()
        }
    }
    
    var socialViews = [(UIView, UILabel)]()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
        contentView.addSubview(scrollView)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupInitialConstraints {
            scrollView.snp.makeConstraints { make in
                make.edges.equalTo(self.contentView)
            }
            
            for (index, (holder, label)) in socialViews.enumerated() {
                label.snp.makeConstraints { make in
                    make.center.equalTo(holder)
                }
                
                holder.snp.makeConstraints { make in
                    make.centerY.equalTo(self.scrollView)
                }
                
                if index > 0 {
                    holder.snp.makeConstraints { make in
                        make.leading.equalTo(self.socialViews[index].0.snp.trailing).offset(16.0)
                    }
                }
                else {
                    holder.snp.makeConstraints { make in
                        make.leading.equalTo(self.scrollView).offset(16.0)
                    }
                }
                
                if index == (socialViews.count - 1) {
                    holder.snp.makeConstraints { make in
                        make.trailing.equalTo(self.scrollView).offset(-16.0)
                    }
                }
            }
            
            didSetupInitialConstraints = true
        }
        
        super.updateConstraints()
    }
    
    private func addSocialButtons() {
        socialViews.forEach { $0.0.removeFromSuperview() }
        socialViews = []
        
        for socialItem in items {
            let accountHolderView: UIView = {
                let view = UIView()
                view.backgroundColor = socialItem.0.color
                view.layer.cornerRadius = 21.0
                view.translatesAutoresizingMaskIntoConstraints = false
                
                return view
            }()
            
            let iconLabel: UILabel = {
                let label = UILabel()
                label.text = socialItem.0.icon
                label.textColor = .white
                label.font = socialItem.0.font
                label.translatesAutoresizingMaskIntoConstraints = false
                
                return label
            }()
            
            accountHolderView.addSubview(iconLabel)
            scrollView.addSubview(accountHolderView)
            
            socialViews.append((accountHolderView, iconLabel))
        }
        
        setNeedsUpdateConstraints()
    }
}
