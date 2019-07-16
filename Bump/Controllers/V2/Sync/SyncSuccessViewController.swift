//
//  SyncSuccessViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/15/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SDWebImage

class SyncSuccessViewController: UIViewController {
    let name: String
    let imageUrl: String?
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .blankAvatar)
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 14.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.isHidden = true
        stackView.spacing = 10.0
        
        return stackView
    }()
    
    init(name: String, imageUrl: String?) {
        self.name = name
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        if let imageUrl = imageUrl {
            avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
        }
        
        nameLabel.text = "Official Amiko\nwith \(name)"
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.Matcha.dusk
            self.stackView.isHidden = false
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 3.0, animations: {
                self.view.backgroundColor = .clear
                self.stackView.alpha = 0.0
            }, completion: { _ in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
