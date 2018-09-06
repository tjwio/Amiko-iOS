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

class BAInitialLoadingViewController: UIViewController {
    
    private struct Constants {
        static let logoAnimation = "ciao_logo"
    }
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let bumpAnimation: LOTAnimationView = {
        let animation = LOTAnimationView(name: Constants.logoAnimation)
        animation.contentMode = .scaleAspectFit
        animation.loopAnimation = false
        animation.isHidden = false
        animation.animationSpeed = 1.0
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        return animation
    }()
    
    let userComplete = MutableProperty<Bool>(false)
    let animationComplete = MutableProperty<Bool>(false)
    
    var user: BAUser!
    
    private var disposables = CompositeDisposable()
    
    init(userId: String) {
        super.init(nibName: nil, bundle: nil)
        
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
        
        bumpAnimation.play { [weak self] _ in
            self?.animationComplete.value = true
            self?.activityIndicator.startAnimating()
        }
        
        view.addSubview(activityIndicator)
        view.addSubview(bumpAnimation)
        
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
        
        bumpAnimation.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.height.equalTo(356.0)
        }
    }
}
