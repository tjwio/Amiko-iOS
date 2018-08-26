//
//  BASocialDrawerTableViewCell.swift
//  Bump
//
//  Created by Tim Wong on 8/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift

class BASocialDrawerTableViewCell: UITableViewCell {    
    let drawerView: BASocialDrawerView = {
        let view = BASocialDrawerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(drawerView)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        drawerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.contentView)
            make.leading.equalTo(self.contentView).offset(16.0)
            make.trailing.equalTo(self.contentView).offset(-16.0)
        }
        
        super.updateConstraints()
    }
}
