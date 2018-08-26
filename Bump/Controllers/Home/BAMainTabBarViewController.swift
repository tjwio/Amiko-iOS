//
//  BAMainTabBarViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BAMainTabBarViewController: UITabBarController {
    
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
    }
}