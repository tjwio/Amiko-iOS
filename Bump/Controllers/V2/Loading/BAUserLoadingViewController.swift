//
//  BAInitialLoadingViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import Lottie
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class BAUserLoadingViewController: BABaseLoadingViewController {
    
    let userComplete = MutableProperty<Bool>(false)
    
    var user: User!
    
    private var disposables = CompositeDisposable()
    
    init(userId: String) {
        super.init(nibName: nil, bundle: nil)
        
        UserHolder.loadUser(userId: userId, success: { user in
            self.user = user
            self.userComplete.value = true
        }) { error in
            print("failed to load user id: \(userId), logging out")
            AppManager.shared.logOut()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposables.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposables += SignalProducer.combineLatest(userComplete.producer, animationComplete.producer).startWithValues { [weak self] (userComplete, animationComplete) in
            guard let strongSelf = self else { return }
            if userComplete && animationComplete {
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as? AppDelegate)?.loadHomeViewController(user: strongSelf.user)
                }
            }
        }
    }
}
