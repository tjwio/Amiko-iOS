//
//  BAInitialLoadingViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BAInitialLoadingViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    init(userId: String) {
        super.init(nibName: nil, bundle: nil)
        
        BAUserHolder.loadUser(userId: userId, success: { user in
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as? AppDelegate)?.loadHomeViewController(user: user)
            }
        }) { error in
            print("failed to load user id: \(userId), logging out")
            BAAppManager.shared.logOut()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexColor: 0xFBFCFD)
        
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }
}
