//
//  BAMainTabBarViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import CoreMotion
#if canImport(CoreNFC)
import CoreNFC
#endif
import ReactiveCocoa
import ReactiveSwift

protocol ShipViewTypeDelegate: class {
    func shipControllerDidSwitchToListView(_ controller: ShipController)
    func shipControllerDidSwitchToMapView(_ controller: ShipController)
}

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate, ShipViewTypeDelegate, SyncUserLoadViewControllerDelegate {
    let user: User
    
    private var disposables = CompositeDisposable()
    
    private var listNavigationController: UINavigationController!
    private var mapNavigationController: UINavigationController!
    private var bumpController: BumpViewController!
    private var profileController: ProfileTabViewController!
    
    private var activeBumpPopupController: BumpPopupViewController?
    
    #if canImport(CoreNFC)
    weak var nfcSession: NFCNDEFReaderSession?
    #endif
    
    deinit {
        disposables.dispose()
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let shipListController = ShipListViewController(user: user, ships: user.ships)
        shipListController.delegate = self
        listNavigationController = UINavigationController(rootViewController: shipListController)
        
        let shipMapController = ShipMapViewController(user: user, ships: user.ships)
        shipMapController.delegate = self
        mapNavigationController = UINavigationController(rootViewController: shipMapController)
        
        bumpController = BumpViewController()
        
        profileController = ProfileTabViewController(user: user)
        
        let homeTabBarItem = UITabBarItem(title: nil, image: .homeTabInactive, selectedImage: .homeTabActive)
        let bumpTabBarItem = UITabBarItem(title: nil, image: .logoTabInactive, selectedImage: .logoTabActive)
        let profileTabBarItem = UITabBarItem(title: nil, image: .profileTabInactive, selectedImage: .profileTabActive)
        
        let offset: CGFloat = DeviceUtil.IS_IPHONE_X ? 12.0 : 6.0
        
        homeTabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0.0, bottom: -offset, right: 0.0)
        bumpTabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0.0, bottom: -offset, right: 0.0)
        profileTabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0.0, bottom: -offset, right: 0.0)
        
        shipListController.tabBarItem = homeTabBarItem
        shipMapController.tabBarItem = homeTabBarItem
        bumpController.tabBarItem = bumpTabBarItem
        profileController.tabBarItem = profileTabBarItem
        
        viewControllers = [listNavigationController, bumpController, profileController]
        tabBar.tintColor = .black
        
        LocationManager.shared.initialize()
        
        setupBumpCallbacks()
        
        disposables += NotificationCenter.default.reactive.notifications(forName: .bumpOpenProfile).observeValues { [unowned self] notification in
            guard let id = notification.object as? String else { return }
            DispatchQueue.main.async {
                self.openProfileController(id: id, animated: true)
            }
        }
    }
    
    private func setupBumpCallbacks() {
        UserHolder.shared.bumpMatchCallback = { [unowned self] userToAdd in
            DispatchQueue.main.async {
                #if canImport(CoreNFC)
                self.nfcSession?.invalidate()
                self.nfcSession = nil
                #endif
                
                self.activeBumpPopupController?.dismissViewController()
                self.activeBumpPopupController = nil
                
                self.openSyncController(userToAdd: userToAdd)
            }
        }
        
        BumpManager.shared.bumpHandler = { bump in
            if let currentLocation = LocationManager.shared.currentLocation {
                UserHolder.shared.sendBumpReceivedEvent(bump: bump, location: currentLocation)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let id = AppManager.shared.deepLinkId {
            openProfileController(id: id, animated: false)
            AppManager.shared.deepLinkId = nil
        }
    }
    
    private func openProfileController(id: String, animated: Bool) {
        guard let coordinate = LocationManager.shared.currentLocation?.coordinate else { return }
        
        let viewController = SyncUserLoadViewController(currUser: user, cardId: id, coordinate: coordinate, buttonTitle: "COMPLETE")
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: animated, completion: nil)
    }
    
    private func openSyncController(userToAdd: User) {
        guard let coordinate = LocationManager.shared.currentLocation?.coordinate else { return }
        
        let viewController = SyncUserAddViewController(currUser: user, userToAdd: userToAdd, coordinate: coordinate, buttonTitle: "COMPLETE")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func startBumpAndNFC() {
        BumpManager.shared.start()
        
        #if canImport(CoreNFC)
        if NFCNDEFReaderSession.readingAvailable {
            showNFCScanner()
        } else {
            showBumpPopup()
        }
        #else
        showBumpPopup()
        #endif
        
        
//        openProfileController(id: "ec40d042-9f99-11e9-a2a3-2a2ae2dbcce4", animated: true)
//        UserHolder.shared.sendBumpReceivedEvent(bump: BumpEvent(acceleration: CMAcceleration(x: 0.0, y: 2.0, z: 27.0)), location: LocationManager.shared.currentLocation!)
    }
    
    // MARK: tab delegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController === bumpController {
            startBumpAndNFC()
            
            return false
        }
        
        return true
    }
    
    // MARK: ship delegate
    
    func shipControllerDidSwitchToListView(_ controller: ShipController) {
        viewControllers = [listNavigationController, bumpController, profileController]
    }
    
    func shipControllerDidSwitchToMapView(_ controller: ShipController) {
        viewControllers = [mapNavigationController, bumpController, profileController]
    }
    
    // MARK: sync delegate
    
    func syncCardController(_ viewController: SyncUserLoadViewController, didAdd ship: Ship, userToAdd: User) {
        self.showLeftMessage("Successfully sent request to \(userToAdd.fullName)!", type: .success)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: nfc
    
    private func showNFCScanner() {
        #if canImport(CoreNFC)
        guard NFCNDEFReaderSession.readingAvailable else { return }
        
        let nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession.alertMessage = "Bump phones with another user or scan an Amiko Card"
        nfcSession.begin()
        
        self.nfcSession = nfcSession
        #endif
    }
    
    // MARK: bump popup
    
    private func showBumpPopup() {
        let viewController = BumpPopupViewController()
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        
        present(viewController, animated: false, completion: nil)
    }
}
