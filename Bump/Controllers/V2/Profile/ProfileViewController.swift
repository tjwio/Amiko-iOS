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
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0)
        tableView.separatorStyle = .none
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
        NetworkHandler.shared.loadCards(success: { cards in
            self.cards = cards
            self.spinnerAnimation.stop()
            self.spinnerAnimation.removeFromSuperview()
            self.tableView.reloadData()
        }) { error in
            AppLogger.log("failed to load cards with error: \(error)")
            self.cards = []
            self.spinnerAnimation.stop()
            self.spinnerAnimation.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.Grayscale.background
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = HeaderView(user: user)
        headerView.frame.size.height = 90.0
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        
        if spinnerAnimation.isAnimationPlaying {
            view.addSubview(spinnerAnimation)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0.0, left: 32.0, bottom: 0.0, right: 32.0))
        }
        
        if spinnerAnimation.isAnimationPlaying {
            spinnerAnimation.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.width.equalTo(150.0)
            }
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return spinnerAnimation.isAnimationPlaying ? 0 : 5
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
        header.backgroundColor = UIColor.Grayscale.background
        
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
            
            cell.cards = cards
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 30.0
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.basicCellIdentifier) as? CustomCornerTableViewCell ?? CustomCornerTableViewCell(style: .default, reuseIdentifier: Constants.basicCellIdentifier)
            
            cell.accessoryType = .disclosureIndicator
            cell.indentationLevel = 1
            cell.indentationWidth = 12.0
            cell.textLabel?.font = .avenirRegular(size: 14.0)
            cell.textLabel?.textColor = UIColor.Grayscale.dark
            
            cell.layer.cornerRadius = 0.0
            cell.layer.masksToBounds = true
            
            cell.separatorView.isHidden = false
            
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Edit Info"
                    cell.corners = ([.topLeft, .topRight], 20.0)
                case 1:
                    cell.textLabel?.text = "Manage Connected Accounts"
                    cell.corners = (.allCorners, 0.0)
                case 2:
                    cell.textLabel?.text = "Change Theme"
                    cell.corners = ([.bottomLeft, .bottomRight], 20.0)
                    cell.separatorView.isHidden = true
                default: break
                }
            case 2:
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "View Pending Requests"
                    cell.layer.cornerRadius = 20.0
                    cell.separatorView.isHidden = true
                default: break
                }
            case 3:
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Get More Cards"
                    cell.corners = ([.topLeft, .topRight], 20.0)
                case 1:
                    cell.textLabel?.text = "Amiko Merch"
                    cell.corners = ([.bottomLeft, .bottomRight], 20.0)
                    cell.separatorView.isHidden = true
                default: break
                }
            case 4:
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Change Password"
                    cell.corners = ([.topLeft, .topRight], 20.0)
                case 1:
                    cell.textLabel?.text = "Log Out"
                    cell.textLabel?.textColor = UIColor.Red.normal
                    cell.corners = ([.bottomLeft, .bottomRight], 20.0)
                    cell.separatorView.isHidden = true
                default: break
                }
            default: break
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            let viewController = ProfileEditInfoViewController(user: user)
            navigationController?.pushViewController(viewController, animated: true)
        default: break
        }
    }
}
