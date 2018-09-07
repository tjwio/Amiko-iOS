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
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let userComplete = MutableProperty<Bool>(false)
    
    var user: BAUser!
    
    private var disposables = CompositeDisposable()
    
    init(userId: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.onAnimationFinished = { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        
        BAUserHolder.loadUser(userId: userId, success: { user in
            self.user = user
            self.userComplete.value = true
        }) { error in
            print("failed to load user id: \(userId), logging out")
            BAAppManager.shared.logOut()
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
        
        view.backgroundColor = UIColor(hexColor: 0xFBFCFD)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        
        setupConstraints()
        
        disposables += SignalProducer.combineLatest(userComplete.producer, animationComplete.producer).startWithValues { [weak self] (userComplete, animationComplete) in
            guard let strongSelf = self else { return }
            if userComplete && animationComplete {
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as? AppDelegate)?.loadHomeViewController(user: strongSelf.user)
                }
            }
        }
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-200.0)
            make.centerX.equalTo(self.view)
        }
    }
}
