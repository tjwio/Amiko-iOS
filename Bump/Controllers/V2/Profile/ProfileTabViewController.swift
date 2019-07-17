//
//  ProfileTabViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class ProfileTabViewController: ProfileBaseViewController {
    let logOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(UIColor.Red.normal, for: .normal)
        button.setTitleColor(UIColor.Red.darker, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 15.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Grayscale.background
        
        logOutButton.addTarget(self, action: #selector(self.logOut(_:)), for: .touchUpInside)
        
        profileView.backgroundColor = .clear
        profileView.tableView.backgroundColor = .clear
        profileView.tableView.tableFooterView = getTableFooterView()
        
        profileView.isHidden = false
        profileView.cancelButton.isHidden = true
        
        view.addSubview(profileView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0))
        }
    }
    
    override func dismissViewController() {
        // pass through
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    //MARK: log out
    
    @objc private func logOut(_ sender: UIButton?) {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logOut = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            DispatchQueue.main.async {
                AppManager.shared.logOut()
            }
        }
        
        alertController.addAction(cancel)
        alertController.addAction(logOut)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func getTableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: profileView.tableView.bounds.size.width, height: 100.0))
        
        footerView.addSubview(logOutButton)
        
        logOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return footerView
    }
}
