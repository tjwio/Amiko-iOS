//
//  CardView.swift
//  Bump
//
//  Created by Tim Wong on 7/27/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class CardView: UIView {
    let imageView: UIImageView = {
        let view = UIImageView(image: .defaultCardEnabled)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirRegular(size: 14.0)
        label.text = "Card Name"
        label.textColor = UIColor.Grayscale.lighter
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 14.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 14.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let actionToolbar: ActionToolbar = {
        let toolbar = ActionToolbar(icons: [.featherIcon(name: .trash2), .featherIcon(name: .minus)])
        toolbar.backgroundColor = UIColor.Matcha.sky
        toolbar.isHidden = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        return toolbar
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
        clipsToBounds = true
        
        addSubview(imageView)
        addSubview(detailLabel)
        addSubview(nameLabel)
        addSubview(numberLabel)
        addSubview(actionToolbar)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nameLabel)
            make.bottom.equalTo(self.nameLabel.snp.top)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        actionToolbar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-24.0)
        }
        
        super.updateConstraints()
    }
}
