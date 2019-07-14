//
//  BALoadingButton.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    var activityIndicator: UIActivityIndicatorView!;
    
    public var isLoading = false {
        didSet {
            if (isLoading) {
                self.activityIndicator.isHidden = false;
                self.titleLabel?.layer.opacity = 0.0;
                self.isEnabled = false;
                self.layer.opacity = 0.5;
                self.activityIndicator.startAnimating();
            }
            else {
                self.activityIndicator.isHidden = true;
                self.titleLabel?.layer.opacity = 1.0;
                self.isEnabled = true;
                self.layer.opacity = 1.0;
                self.activityIndicator.stopAnimating();
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero);
        commonInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        commonInit();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        commonInit();
    }
    
    private func commonInit() {
        self.activityIndicator = UIActivityIndicatorView(style: .white);
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(self.activityIndicator);
        
        self.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside);
        
        self.setNeedsUpdateConstraints();
    }
    
    override func updateConstraints() {
        let centerXConstraint = NSLayoutConstraint(item: self.activityIndicator!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0);
        let centerYConstraint = NSLayoutConstraint(item: self.activityIndicator!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0);
        
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint]);
        
        super.updateConstraints();
    }
    
    @objc private func buttonPressed() {
        self.isLoading = true;
    }
}
