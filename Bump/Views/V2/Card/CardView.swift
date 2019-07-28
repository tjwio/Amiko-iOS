//
//  CardView.swift
//  Bump
//
//  Created by Tim Wong on 7/27/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class CardView: UIView, ActionToolbarDelegate {
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
    
    let menuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(.featherIcon(name: .moreVertical), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .featherFont(size: 24.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        
        menuButton.addTarget(self, action: #selector(self.showMore(_:)), for: .touchUpInside)
        actionToolbar.delegate = self
        
        addSubview(imageView)
        addSubview(detailLabel)
        addSubview(nameLabel)
        addSubview(numberLabel)
        addSubview(menuButton)
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
        
        menuButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.trailing.equalToSuperview().offset(-24.0)
        }
        
        actionToolbar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-12.0)
        }
        
        super.updateConstraints()
    }
    
    @objc private func showMore(_ sender: UIButton) {
        let frame = actionToolbar.frame
        let t0 = CGAffineTransform(translationX: -frame.origin.x, y: -frame.origin.y)
        let ts = CGAffineTransform(scaleX: 0.0, y: 1.0)
        let t1 = CGAffineTransform(translationX: frame.origin.x, y: frame.origin.y)
        
        actionToolbar.transform = t0.concatenating(ts).concatenating(t1)
        actionToolbar.isHidden = false
        actionToolbar.alpha = 0.0
        
        UIView.animate(withDuration: 0.50, animations: {
            self.actionToolbar.alpha = 1.0
            self.actionToolbar.transform = .identity
            self.menuButton.alpha = 0.0
            self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        }) { _ in
            self.menuButton.isHidden = true
            self.menuButton.alpha = 1.0
        }
    }
    
    func actionToolbar(_ actionToolbar: ActionToolbar, didTap button: LoadingButton, at index: Int) {
        if index == 1 {
            button.isLoading = false
            menuButton.isHidden = false
            
            UIView.animate(withDuration: 0.50, animations: {
                actionToolbar.alpha = 0.0
                self.menuButton.alpha = 1.0
                self.menuButton.transform = .identity
            }) { _ in
                actionToolbar.isHidden = true
                actionToolbar.alpha = 1.0
            }
        }
    }
}
