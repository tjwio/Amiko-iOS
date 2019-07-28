//
//  CustomCornerTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 7/27/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class CustomCornerTableViewCell: UITableViewCell {
    var corners: (UIRectCorner, CGFloat) = (.allCorners, 0) {
        didSet {
            roundCorners(corners: corners.0, radius: corners.1)
        }
    }
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Grayscale.lighter
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(separatorView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        separatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24.0)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCorners(corners: corners.0, radius: corners.1)
    }
}
