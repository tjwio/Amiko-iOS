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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Grayscale.background
        
        profileView.backgroundColor = .clear
        profileView.tableView.backgroundColor = .clear
        
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
}
