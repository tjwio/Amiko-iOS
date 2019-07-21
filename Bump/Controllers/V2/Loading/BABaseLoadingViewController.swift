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
        static let logoAnimation = "amiko"
    }
    
    let animationComplete = MutableProperty<Bool>(false)
    
    let spinnerAnimation: AnimationView = {
        let animation = AnimationView(name: Constants.logoAnimation)
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .playOnce
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        return animation
    }()
    
    var onAnimationFinished: EmptyHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexColor: 0xFAFAFA)
        
        spinnerAnimation.play { [unowned self] _ in
            self.animationComplete.value = true
            self.onAnimationFinished?()
            
            self.spinnerAnimation.loopMode = .loop
            self.spinnerAnimation.play()
        }
        
        view.addSubview(spinnerAnimation)
        
        spinnerAnimation.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(400.0)
        }
    }
}
