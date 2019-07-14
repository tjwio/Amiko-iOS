//
//  BAMainTabBarViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

protocol ShipViewTypeDelegate: class {
    func shipControllerDidSwitchToListView(_ controller: ShipController)
    func shipControllerDidSwitchToMapView(_ controller: ShipController)
}

class MainTabBarViewController: UITabBarController, ShipViewTypeDelegate {
    private var disposables = CompositeDisposable()
    
    private var listNavigationController: UINavigationController!
    private var mapNavigationController: UINavigationController!
    private var profileController: ProfileTabViewController!
    
    deinit {
        disposables.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = UserHolder.shared.user
        
        let shipListController = ShipListViewController(user: user, ships: user.ships)
        shipListController.delegate = self
        listNavigationController = UINavigationController(rootViewController: shipListController)
        
        let shipMapController = ShipMapViewController(user: user, ships: user.ships)
        shipMapController.delegate = self
        mapNavigationController = UINavigationController(rootViewController: shipMapController)
        
        profileController = ProfileTabViewController(user: user)
        
        let homeTabBarItem = UITabBarItem(title: nil, image: .homeTabInactive, selectedImage: .homeTabActive)
        let profileTabBarItem = UITabBarItem(title: nil, image: .profileTabInactive, selectedImage: .profileTabActive)
        
        let offset: CGFloat = DeviceUtil.IS_IPHONE_X ? 12.0 : 6.0
        
        homeTabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0.0, bottom: -offset, right: 0.0)
        profileTabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0.0, bottom: -offset, right: 0.0)
        
        shipListController.tabBarItem = homeTabBarItem
        shipMapController.tabBarItem = homeTabBarItem
        profileController.tabBarItem = profileTabBarItem
        
        viewControllers = [listNavigationController, profileController]
        tabBar.tintColor = .black
        
        disposables += NotificationCenter.default.reactive.notifications(forName: .bumpOpenProfile).observeValues { [unowned self] notification in
            guard let id = notification.object as? String else { return }
            DispatchQueue.main.async {
                self.openProfileController(id: id)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let id = AppManager.shared.deepLinkId {
            openProfileController(id: id)
            AppManager.shared.deepLinkId = nil
        }
    }
    
    private func openProfileController(id: String) {
        let viewController = LoadProfileViewController(userId: id)
        viewController.successCallback = { [weak self] message in
            DispatchQueue.main.async {
                self?.showLeftMessage(message, type: .success)
            }
        }
        
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    // MARK: ship delegate
    
    func shipControllerDidSwitchToListView(_ controller: ShipController) {
        viewControllers = [listNavigationController, profileController]
    }
    
    func shipControllerDidSwitchToMapView(_ controller: ShipController) {
        viewControllers = [mapNavigationController, profileController]
    }
}
