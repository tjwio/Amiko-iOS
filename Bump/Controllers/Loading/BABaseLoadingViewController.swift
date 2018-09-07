//
//  BABaseLoadingViewController.swift
//  Bump
//
//  Created by Tim Wong on 9/6/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import Lottie
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class BABaseLoadingViewController: UIViewController {
    
    private struct Constants {
        static let logoAnimation = "ciao_logo"
    }
    
    let animationComplete = MutableProperty<Bool>(false)
    
    let bumpAnimation: LOTAnimationView = {
        let animation = LOTAnimationView(name: Constants.logoAnimation)
        animation.contentMode = .scaleAspectFit
        animation.loopAnimation = false
        animation.isHidden = false
        animation.animationSpeed = 1.0
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        return animation
    }()
    
    var onAnimationFinished: BAEmptyHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexColor: 0xFBFCFD)
        
        bumpAnimation.play { [weak self] _ in
            self?.animationComplete.value = true
            self?.onAnimationFinished?()
        }
        
        view.addSubview(bumpAnimation)
        
        bumpAnimation.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.height.equalTo(356.0)
        }
    }
}
