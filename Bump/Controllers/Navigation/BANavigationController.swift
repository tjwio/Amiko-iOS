//
//  BANavigationController.swift
//  Bump
//
//  Created by Tim Wong on 8/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BANavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        (navigationBar as? BANavigationBar)?.isTransitioning = true
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        (navigationBar as? BANavigationBar)?.isTransitioning = true
        return super.popViewController(animated: animated)
    }
}
