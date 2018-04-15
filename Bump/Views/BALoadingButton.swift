//
//  BALoadingButton.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BALoadingButton: UIButton {
    var activityIndicator: UIActivityIndicatorView!;
    
    public var isLoading: Bool! {
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
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white);
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(self.activityIndicator);
        
        self.addTarget(self, action: #selector(self.buttonPressed), for: UIControlEvents.touchUpInside);
        
        self.setNeedsUpdateConstraints();
    }
    
    override func updateConstraints() {
        let centerXConstraint = NSLayoutConstraint(item: self.activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0);
        let centerYConstraint = NSLayoutConstraint(item: self.activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0);
        
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint]);
        
        super.updateConstraints();
    }
    
    @objc private func buttonPressed() {
        self.isLoading = true;
    }
}
