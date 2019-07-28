//
//  ProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/27/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import Lottie
import SnapKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private struct Constants {
        static let basicCellIdentifier = "ProfileBasicTableViewCellIdentifier"
        static let cardCellIdentifier = "ProfileCardTableViewCellIdentifier"
        static let logoAnimation = "amiko"
    }
    
    let user: User
    var cards: [Card]!
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets.init(top: 32.0, left: 0.0, bottom: 16.0, right: 0.0)
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let spinnerAnimation: AnimationView = {
        let animation = AnimationView(name: Constants.logoAnimation)
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        return animation
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        spinnerAnimation.play()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Grayscale.background
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = HeaderView(user: user)
        
        view.addSubview(tableView)
        view.addSubview(spinnerAnimation)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0.0, left: 32.0, bottom: 0.0, right: 32.0))
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 1
        case 3: return 2
        case 4: return 2
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DetailButtonHeaderView()
        
        switch section {
        case 0:
            header.detailLabel.text = "MANAGE YOUR CARDS"
            header.button.isHidden = false
        case 1:
            header.detailLabel.text = "ACCOUNT SETTINGS"
            header.button.isHidden = true
        case 2:
            header.detailLabel.text = "MY ACTIVITIES"
            header.button.isHidden = true
        case 3:
            header.detailLabel.text = "STOCK UP"
            header.button.isHidden = true
        case 4:
            header.detailLabel.text = "LOG IN"
            header.button.isHidden = true
        default: break
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 182.0 : 56.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cardCellIdentifier) as? CardTableViewCell ?? CardTableViewCell(style: .default, reuseIdentifier: Constants.cardCellIdentifier)
            
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: Constants.basicCellIdentifier)
            
            return cell
        }
    }
}
