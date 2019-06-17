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

class BAMainTabBarViewController: UITabBarController {
    private var disposables = CompositeDisposable()
    
    deinit {
        disposables.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeController = BAHomeViewController()
        let historyController = BAHistoryHolderViewController(user: BAUserHolder.shared.user)
        
        let homeTabBarItem = UITabBarItem(title: nil, image: .homeTabActive, selectedImage: .homeTabGray)
        let historyTabBarItem = UITabBarItem(title: nil, image: .activityTabActive, selectedImage: .activityTabGray)
        
        let offset: CGFloat = BADeviceUtil.IS_IPHONE_X ? 12.0 : 6.0
        
        homeTabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0.0, bottom: -offset, right: 0.0)
        historyTabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0.0, bottom: -offset, right: 0.0)
        
        homeController.tabBarItem = homeTabBarItem
        historyController.tabBarItem = historyTabBarItem
        
        viewControllers = [homeController, historyController]
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
        
        if let id = BAAppManager.shared.deepLinkId {
            openProfileController(id: id)
            BAAppManager.shared.deepLinkId = nil
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
}
