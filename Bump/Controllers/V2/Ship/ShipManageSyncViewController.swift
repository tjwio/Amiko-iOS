//
//  ShipManageSyncViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import MapKit

protocol ShipManageSyncViewControllerDelegate: class {
    func shipManageController(_ viewController: ShipManageSyncViewController, didUpdate ship: Ship)
}

class ShipManageSyncViewController: SyncUserAddViewController {
    let ship: Ship
    weak var delegate: ShipManageSyncViewControllerDelegate?
    var headerHeight: CGFloat = 247.0
    
    let blankHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(ship: Ship, currUser: User, userToAdd: User, coordinate: CLLocationCoordinate2D, buttonTitle: String) {
        self.ship = ship
        super.init(currUser: currUser, userToAdd: userToAdd, coordinate: coordinate, buttonTitle: buttonTitle)
        accountsView.accounts = currUser.allAccounts.map { ($0.0, $0.1, ship.sharedInfo.contains($0.0)) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        accountsView.headerLabel = "Manage your share with \(userToAdd.firstName)".uppercased()
        
        fullView.isHidden = true
        headerView.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognized(_:)))
        blankHeader.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(blankHeader)
        setupConstraints()
    }
    
    private func setupConstraints() {
        blankHeader.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        fullView.snp.makeConstraints { make in
            make.top.equalTo(self.blankHeader.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupFullViewConstraints() {
        // pass thru
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
    
    // MARK: override
    
    override func confirmButtonPressed(_ sender: LoadingButton) {
        currUser.updateConnection(ship: ship, toUserId: userToAdd.id, latitude: coordinate.latitude, longitude: coordinate.longitude, accounts: accountsView.accounts.filter { $0.2 }.map { $0.0 }, success: { ship in
            sender.isLoading = false
            self.delegate?.shipManageController(self, didUpdate: ship)
        }) { _ in
            sender.isLoading = false
            self.showLeftMessage("Failed to add connection, please try again", type: .error)
        }
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
