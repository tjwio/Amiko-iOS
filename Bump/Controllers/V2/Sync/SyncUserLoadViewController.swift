//
//  SyncUserLoadViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/14/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import MapKit

protocol SyncUserLoadViewControllerDelegate: class {
    func syncCardController(_ viewController: SyncUserLoadViewController, didAdd ship: Ship, userToAdd: User)
}

class SyncUserLoadViewController: SyncUserBaseViewController {
    let cardId: String
    
    weak var delegate: SyncUserLoadViewControllerDelegate?
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(currUser: User, cardId: String, coordinate: CLLocationCoordinate2D, buttonTitle: String) {
        self.cardId = cardId
        super.init(currUser: currUser, coordinate: coordinate, buttonTitle: buttonTitle)
        
        NetworkHandler.shared.loadUserFromCard(id: cardId, success: { user in
            self.userToAdd = user
            DispatchQueue.main.async {
                self.setupUserToAddInfo()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
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
        
        headerView.infoView.isHidden = true
        headerView.mutualUsersView.isHidden = true
        
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self.headerView)
        }
    }
    
    override func setupFullViewConstraints() {
        fullView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func confirmButtonPressed(_ sender: LoadingButton) {
        currUser.addConnection(toUserId: userToAdd.id, latitude: coordinate.latitude, longitude: coordinate.longitude, accounts: accountsView.accounts.filter { $0.2 }.map { $0.0 }, success: { ship in
            self.delegate?.syncCardController(self, didAdd: ship, userToAdd: self.userToAdd)
        }) { _ in
            sender.isLoading = false
            self.showLeftMessage("Failed to add connection, please try again", type: .error)
        }
    }
}
