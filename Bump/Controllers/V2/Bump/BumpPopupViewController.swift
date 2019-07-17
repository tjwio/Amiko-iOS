//
//  BumpPopupViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/17/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BumpPopupViewController: UIViewController {
    
    let bumpView: BumpView = {
        let view = BumpView()
        view.backgroundColor = .white
        view.isHidden = true
        view.layer.cornerRadius = 30.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        bumpView.cancelButton.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        
        view.addSubview(bumpView)
        
        bumpView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().offset(-8.0)
            make.bottom.equalToSuperview().offset(-6.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bumpView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        bumpView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor(hexColor: 0x262A2F, alpha: 0.90)
            
            self.bumpView.transform = .identity
        }) { _ in
            self.bumpView.logoAnimation.play()
        }
    }
    
    @objc func dismissViewController() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = .clear
            self.bumpView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        }) { completed in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
