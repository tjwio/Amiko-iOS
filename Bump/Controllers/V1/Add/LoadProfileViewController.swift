//
//  LoadProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 6/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class LoadProfileViewController: BaseUserViewController {
    class LoadingView: UIView {
        let activityIndicator: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView(style: .gray)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
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
            backgroundColor = .white
            
            activityIndicator.startAnimating()
            
            addSubview(activityIndicator)
            setNeedsUpdateConstraints()
        }
        
        override func updateConstraints() {
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            super.updateConstraints()
        }
    }
    
    let userId: String
    
    let loadingView: LoadingView = {
        let view = LoadingView()
        view.layer.cornerRadius = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
        UserHolder.loadSpecificUser(id: userId, success: { user in
            DispatchQueue.main.async {
                self.userToAdd = user
                self.setupUser(user)
            }
        }) { _ in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        
        view.addSubview(dummyShadowView)
        dummyShadowView.addSubview(loadingView)
        
        dummyShadowView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(100.0)
            make.leading.equalTo(self.view).offset(22.0)
            make.trailing.equalTo(self.view).offset(-22.0)
            make.bottom.equalTo(self.view).offset(-60.0)
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor(hexColor: 0xA7ADB6, alpha: 0.60);
            
            self.loadingView.transform = .identity
            self.dummyShadowView.layer.applySketchShadow(color: UIColor(hexColor: 0x3D3F42), alpha: 0.40, x: 0.0, y: 1.0, blur: 12.0, spread: 0.0)
        }, completion: nil)
    }
    
    private func setupUser(_ user: User) {
        userToAdd = user
        userView = BAAddUserView(mainItems: [
            (.phone, userToAdd.phone),
            (.email, userToAdd.email)
            ], socialItems: userToAdd.socialAccounts)
        
        setupUserView()
        
        loadingView.removeFromSuperview()
        dummyShadowView.addSubview(userView)
        
        userView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
