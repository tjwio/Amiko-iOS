//
//  BAHistoryHolderViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BAHistoryHolderViewController: UIViewController {
    
    let listController: BAHistoryListViewController
    let listNav: BANavigationController
    
    let mapController: BAHistoryMapViewController
    
    init(user: BAUser) {
        listController = BAHistoryListViewController(user: user)
        listNav = BANavigationController(navigationBarClass: BANavigationBar.classForCoder(), toolbarClass: nil)
        listNav.setViewControllers([listController], animated: false)
        
        mapController = BAHistoryMapViewController(user: user)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        addChildHelper(mapController)
        addChildHelper(listNav)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized(_:)))
        listNav.view.addGestureRecognizer(panGestureRecognizer)
        
        _ = addBackButtonToView(dark: true)
    }
    
    //MARK: pan gesture
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let translatedPoint = sender.translation(in: view)
            
            listNav.view.frame.origin.y += translatedPoint.y
            listNav.view.frame.origin.y = max(listNav.view.frame.origin.y, 0.0)
            listNav.view.frame.origin.y = min(listNav.view.frame.origin.y, view.bounds.height - 54.0)
            listController.isListVisible = listNav.view.frame.origin.y != view.bounds.height - 54.0
            sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: view)
        }
        else if sender.state == .ended {
            
        }
    }
    
    //MARK: helper
    
    private func addChildHelper(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
}
