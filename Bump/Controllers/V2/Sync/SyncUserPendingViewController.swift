//
//  SyncUserPendingViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/15/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import MapKit

protocol SyncUserPendingViewControllerDelegate: class {
    func syncPendingController(_ viewController: SyncUserPendingViewController, didConfirm ship: Ship)
}

class SyncUserPendingViewController: SyncUserBaseViewController {
    let ship: Ship
    
    weak var delegate: SyncUserPendingViewControllerDelegate?
    
    init(currUser: User, ship: Ship, coordinate: CLLocationCoordinate2D, buttonTitle: String) {
        self.ship = ship
        super.init(currUser: currUser, coordinate: coordinate, buttonTitle: buttonTitle)
        self.userToAdd = ship.user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupFullViewConstraints() {
        fullView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserToAddInfo()
    }
    
    override func confirmButtonPressed(_ sender: LoadingButton) {
        currUser.addConnection(toUserId: userToAdd.id, latitude: coordinate.latitude, longitude: coordinate.longitude, accounts: accountsView.accounts.filter { $0.2 }.map { $0.0 }, success: { ship in
            let confirmedShip = self.currUser.confirmPendingShip(self.ship)
            self.delegate?.syncPendingController(self, didConfirm: confirmedShip)
        }) { _ in
            sender.isLoading = false
            self.showLeftMessage("Failed to add connection, please try again", type: .error)
        }
    }
}
