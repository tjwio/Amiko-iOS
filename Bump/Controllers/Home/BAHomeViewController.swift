//
//  BSHomeViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/13/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BAHomeViewController: UIViewController {
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("\u{F013}", for: .normal)
        button.setTitleColor(UIColor(hexColor: 0x9DA3AD), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(size: 18.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let accountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("\u{F0C0}", for: .normal)
        button.setTitleColor(UIColor(hexColor: 0x9DA3AD), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(size: 18.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexColor: 0xFAFBFD)
        
        self.view.addSubview(self.settingsButton)
        self.view.addSubview(self.accountButton)
    }
    
    private func setupConstraints() {
        self.settingsButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(16.0)
            make.top.equalTo(self.view).offset(16.0)
        }
        
        self.accountButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view).offset(-16.0)
            make.top.equalTo(self.view).offset(16.0)
        }
    }
}
