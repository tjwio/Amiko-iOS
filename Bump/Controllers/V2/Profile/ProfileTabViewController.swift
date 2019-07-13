//
//  ProfileTabViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class ProfileTabViewController: BAProfileBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        profileView.isHidden = false
        profileView.cancelButton.isHidden = true
        
        view.addSubview(profileView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func dismissViewController() {
        // pass through
    }
}
