//
//  BAWelcomeLoadingViewController.swift
//  Bump
//
//  Created by Tim Wong on 9/6/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BAWelcomeLoadingViewController: BABaseLoadingViewController {
    
    var goToWelcomeScreen: EmptyHandler = {
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as? AppDelegate)?.loadWelcomeViewController()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        onAnimationFinished = goToWelcomeScreen
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        onAnimationFinished = goToWelcomeScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onAnimationFinished = goToWelcomeScreen
    }
}
