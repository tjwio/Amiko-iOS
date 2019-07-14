//
//  ShipManageSyncViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class ShipManageSyncViewController: SyncUserViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        accountsView.headerLabel = "Manage your share with \(userToAdd.firstName)".uppercased()
        
        fullView.isHidden = true
        headerView.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognized(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fullView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        fullView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor(hexColor: 0x262A2F, alpha: 0.90)
            
            self.fullView.transform = .identity
        }, completion: nil)
    }
    
    override func cancelButtonPressed(_ sender: UIButton?) {
        dismissViewController(completion: nil)
    }
    
    @objc private func tapGestureRecognized(_ gestureRecognizer: UITapGestureRecognizer) {
        dismissViewController(completion: nil)
    }
    
    func dismissViewController(completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = .clear
            self.fullView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        }) { completed in
            self.dismiss(animated: false, completion: nil)
            completion?(completed)
        }
    }
}
