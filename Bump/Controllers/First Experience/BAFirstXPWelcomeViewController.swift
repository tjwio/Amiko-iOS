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
        
        _ = BAUserHolder.initialize(user: user)
        
        view.backgroundColor = .white
        
        profileView.isHidden = false
        profileView.cancelButton.isHidden = true
        profileView.titleLabel.text = "Welcome to Ciao"
        
        view.addSubview(profileView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(-16.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func dismissViewController() {
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as? AppDelegate)?.loadHomeViewController(user: self.user, shouldInitialize: false)
        }
    }
}
