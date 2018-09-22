//
//  BAHistoryHolderViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

protocol BAHistoryChangeDelegate: class {
    func historyController(_ controller: BAHistoryViewController, didSelect entry: BAHistory)
}

protocol BAHistoryViewController: class {
    func showEntry(_ entry: BAHistory)
}

class BAHistoryHolderViewController: UIViewController, BAHistoryChangeDelegate {
    
    private struct Constants {
        static let defaultOriginY: CGFloat = 200.0
        static let minOriginY: CGFloat = 20.0
    }
    
    let listController: BAHistoryListViewController
    let listNav: BANavigationController
    
    let mapController: BAHistoryMapViewController
    
    init(user: BAUser) {
        listController = BAHistoryListViewController(user: user)
        listNav = BANavigationController(navigationBarClass: BANavigationBar.classForCoder(), toolbarClass: nil)
        listNav.setViewControllers([listController], animated: false)
        
        mapController = BAHistoryMapViewController(user: user)
        
        super.init(nibName: nil, bundle: nil)
        
        listController.delegate = self
        mapController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        addChildHelper(mapController)
        addChildHelper(listNav)
        
        listNav.view.frame.origin.y = Constants.defaultOriginY
        mapController.bottomOffset = view.frame.size.height - Constants.defaultOriginY
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized(_:)))
        listNav.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    //MARK: pan gesture
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let translatedPoint = sender.translation(in: view)
            let tabBarHeight = (self.tabBarController?.tabBar.frame.height ?? 0.0)
            let maxBottom = 54.0 + tabBarHeight
            
            listNav.view.frame.origin.y += translatedPoint.y
            listNav.view.frame.origin.y = max(listNav.view.frame.origin.y, Constants.defaultOriginY)
            listNav.view.frame.origin.y = min(listNav.view.frame.origin.y, view.bounds.height - maxBottom)
            listController.isListVisible = listNav.view.frame.origin.y != view.bounds.height - maxBottom
            sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: view)
        }
        else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            
            if velocity.y > 500 {
                self.hideList(duration: 0.25)
            }
            else if velocity.y < -500 {
                self.showList(duration: 0.25)
            }
            
            mapController.bottomOffset = view.frame.size.height - listNav.view.frame.minY
        }
    }
    
    //MARK: history delegate
    
    func historyController(_ controller: BAHistoryViewController, didSelect entry: BAHistory) {
        if controller === listController {
            mapController.showEntry(entry)
        }
        else if controller === mapController {
            listController.showEntry(entry)
        }
    }
    
    //MARK: helper
    
    private func showList(duration: TimeInterval = 0.5, originY: CGFloat? = nil, completion: ((Bool) -> Void)? = nil) {
        self.listController.isListVisible = true
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            self.listNav.view.frame.origin.y = originY ?? Constants.defaultOriginY
            
//            self.zoomMapOut()
        }, completion: completion)
    }
    
    private func hideList(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        self.listController.isListVisible = false
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            self.listNav.view.frame.origin.y = self.view.bounds.height - 54.0 - (self.tabBarController?.tabBar.frame.height ?? 0.0)
        }, completion: completion)
    }
    
    private func addChildHelper(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
