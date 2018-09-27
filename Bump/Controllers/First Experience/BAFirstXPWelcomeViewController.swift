 //
//  BAFirstXPWelcomeViewController.swift
//  Bump
//
//  Created by Tim Wong on 9/26/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BAFirstXPWelcomeViewController: BAProfileBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        profileView.isHidden = false
        profileView.titleLabel.text = "Welcome to Ciao"
        profileView.cancelButton.isHidden = true
        
        view.addSubview(profileView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-16.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
