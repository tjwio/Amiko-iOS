//
//  BADeleteUserViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/27/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BADeleteUserViewController: BAAddUserViewController {
    
    let currentUser: User
    let history: BAHistory
    
    init(user: User, history: BAHistory) {
        self.currentUser = user
        self.history = history
        super.init(userToAdd: history.addedUser)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userView.isDelete = true
    }
    
    override func done(_ sender: BALoadingButton?) {
        let alertController = UIAlertController(title: "Remove User", message: "Are you sure you want to remove \(self.userToAdd.fullName) from your connections", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            sender?.isLoading = false
        }
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
            self.removeUser(sender)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(removeAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func removeUser(_ sender: BALoadingButton?) {
        currentUser.deleteConnection(history: history, success: {
            self.successCallback?("Successfully removed contact")
            self.dismiss(animated: true, completion: nil)
        }) { error in
            sender?.isLoading = false
            self.showLeftMessage("Failed to remove \(self.userToAdd.fullName) from your connections", type: .error, view: self.userView)
        }
    }
}
