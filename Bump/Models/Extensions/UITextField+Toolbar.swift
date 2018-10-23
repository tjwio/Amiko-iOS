//
//  UITextField+Toolbar.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

extension UITextField {
    func addDoneToolbar(target: Any?, selector: Selector?, toolbarStyle: UIBarStyle! = UIBarStyle.default) {
        let doneToolbar = UITextField.getDoneToolbar(target: target, selector: selector, toolbarStyle: toolbarStyle);
        
        self.inputAccessoryView = doneToolbar;
    }
    
    func addShowButton() {
        let button = UIButton(type: .custom);
        button.setTitle("SHOW", for: .normal);
        button.setTitleColor(.white, for: .normal);
        button.titleLabel?.font = UIFont.avenirDemi(size: 14.0);
        button.addTarget(self, action: #selector(self.showPassword(_:)), for: .touchUpInside);
        button.frame = CGRect(x: 0.0, y: 0.0, width: button.intrinsicContentSize.width, height: button.intrinsicContentSize.height);
        
        self.rightView = button;
        self.rightViewMode = .always;
    }
    
    @objc func showPassword(_ sender: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry;
        sender.setTitle(self.isSecureTextEntry ? "SHOW" : "HIDE", for: .normal);
    }
    
    class func getDoneToolbar(target: Any?, selector: Selector?, toolbarStyle: UIBarStyle! = UIBarStyle.default) -> UIToolbar {
        let doneToolbar = UIToolbar();
        doneToolbar.backgroundColor = UIColor.clear;
        doneToolbar.sizeToFit();
        doneToolbar.barStyle = toolbarStyle;
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: target, action: selector);
        
        if var items = doneToolbar.items {
            items.append(doneBarButtonItem);
            doneToolbar.items = items;
        }
        else {
            doneToolbar.items = [doneBarButtonItem];
        }
        
        return doneToolbar;
    }
}
