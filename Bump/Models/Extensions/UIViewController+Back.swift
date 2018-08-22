//
//  UIViewController+Back.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

extension UIViewController: UIGestureRecognizerDelegate {
    
    func addBackInfoBarButtons() {
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(self.goBack));
        backBarButtonItem.tintColor = UIColor(hexColor: 0x434A54);
        
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }
    
    func removeBackInfoBarButton() {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
    }
    
    func addBackButtonToView(dark: Bool, shouldAddText: Bool = true) -> UIButton {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(dark ? .backArrowDark : .backArrowWhite, for: .normal)
        if shouldAddText {
            backButton.setTitle("Back", for: .normal)
            backButton.setTitleColor(.white, for: .normal)
            backButton.titleLabel?.font = UIFont.avenirRegular(size: 16.0)
            backButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        }
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backButton)
        
        let topConstraint = NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 44.0)
        let leadingConstraint = NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 19.0)
        let widthConstraint = NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: backButton.intrinsicContentSize.width+10.0)
        
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, widthConstraint])
        
        return backButton
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true);
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
