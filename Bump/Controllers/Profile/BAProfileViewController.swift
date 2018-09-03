//
//  BAProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class BAProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let user: BAUser
    
    let image = MutableProperty<UIImage?>(nil)
    let firstName = MutableProperty<String?>(nil)
    let lastName = MutableProperty<String?>(nil)
    let jobTitle = MutableProperty<String?>(nil)
    let company = MutableProperty<String?>(nil)
    let phone = MutableProperty<String?>(nil)
    let email = MutableProperty<String?>(nil)
    
    let facebook = MutableProperty<String?>(nil)
    let linkedin = MutableProperty<String?>(nil)
    let instagram = MutableProperty<String?>(nil)
    let twitter = MutableProperty<String?>(nil)
    
    let profileView: BAProfileView = {
        let view = BAProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dummyShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    init(user: BAUser) {
        self.user = user
        
        image.value = user.image.value
        firstName.value = user.firstName
        lastName.value = user.lastName
        jobTitle.value = user.profession
        company.value = user.company
        phone.value = user.phone
        email.value = user.email
        
        for account in user.socialAccounts {
            switch account.0 {
            case .facebook:
                facebook.value = account.1
            case .linkedin:
                linkedin.value = account.1
            case .instagram:
                instagram.value = account.1
            case .twitter:
                twitter.value = account.1
            default: break
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        profileView.cancelButton.addTarget(self, action: #selector(self.cancelProfileView(_:)), for: .touchUpInside)
        profileView.saveButton.addTarget(self, action: #selector(self.saveProfileView(_:)), for: .touchUpInside)
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        profileView.isHidden = false
        profileView.transform = CGAffineTransform(translationX: 0.0, y: view.frame.size.height)
        profileView.layer.cornerRadius = 20.0
        
        view.addSubview(dummyShadowView)
        dummyShadowView.addSubview(profileView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor(hexColor: 0xA7ADB6, alpha: 0.60);
            
            self.profileView.transform = .identity
            self.dummyShadowView.layer.applySketchShadow(color: UIColor(hexColor: 0x3D3F42), alpha: 0.40, x: 0.0, y: 1.0, blur: 12.0, spread: 0.0)
        }, completion: nil)
    }
    
    private func setupConstraints() {
        dummyShadowView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(40.0)
            make.leading.equalTo(self.view).offset(12.0)
            make.trailing.equalTo(self.view).offset(12.0)
            make.bottom.equalTo(self.view).offset(6.0)
        }
        
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: cancel
    
    @objc private func cancelProfileView(_ sender: UIButton?) {
        
    }
    
    //MARK: save
    
    @objc private func saveProfileView(_ sender: BALoadingButton?) {
        
    }
    
    //MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
}
