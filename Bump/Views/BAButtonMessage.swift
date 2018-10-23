//
//  BAButtonMessage.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import GSMessages

class BAButtonMessage: GSMessage {
    let closeButton: UIButton = {
        let button = UIButton(type: .custom);
        button.backgroundColor = .clear;
        button.setImage(UIImage(named: "close-x"), for: .normal);
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        return button;
    }()
    
    var nextButton: UIButton?
    
    convenience init(text: String, buttonText: String?, type: GSMessageType, options: [GSMessageOption]?, inView: UIView, inViewController: UIViewController?, target: Any?, selector: Selector) {
        self.init(text: text, type: type, options: options, inView: inView, inViewController: inViewController);
        
        self.closeButton.addTarget(self, action: #selector(self.closeButtonPressed(_:)), for: .touchUpInside);
        self.messageView.addSubview(self.closeButton);
        
        if let buttonText = buttonText {
            let button = UIButton(type: .custom);
            button.backgroundColor = .clear;
            button.setTitleColor(.white, for: .normal);
            button.titleLabel?.font = UIFont.avenirDemi(size: 14.0);
            button.translatesAutoresizingMaskIntoConstraints = false;
            
            let attributedString = NSAttributedString(string: buttonText, attributes: [
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor : UIColor.white
                ])
            
            button.setAttributedTitle(attributedString, for: .normal);
            
            if target != nil {
                button.addTarget(target, action: selector, for: .touchUpInside);
            }
            
            self.messageView.addSubview(button);
            self.nextButton = button;
        }
        
        self.setupConstraints();
    }
    
    private func setupConstraints() {
        let closeTrailingConstraint = NSLayoutConstraint(item: self.messageView, attribute: .trailing, relatedBy: .equal, toItem: self.closeButton, attribute: .trailing, multiplier: 1.0, constant: 0.0);
        let closeCenterYConstraint = NSLayoutConstraint(item: self.closeButton, attribute: .centerY, relatedBy: .equal, toItem: self.messageText, attribute: .centerY, multiplier: 1.0, constant: 0.0);
        let closeHeightConstraint = NSLayoutConstraint(item: self.closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0);
        let closeWidthConstraint = NSLayoutConstraint(item: self.closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0);
        
        if let nextButton = self.nextButton {
            let nextLeadingConstraint = NSLayoutConstraint(item: nextButton, attribute: .leading, relatedBy: .equal, toItem: self.messageView, attribute: .leading, multiplier: 1.0, constant: self.textPadding + self.messageText.intrinsicContentSize.width);
            let nextCenterYConstraint = NSLayoutConstraint(item: nextButton, attribute: .centerY, relatedBy: .equal, toItem: self.messageText, attribute: .centerY, multiplier: 1.0, constant: 0.0);
            
            NSLayoutConstraint.activate([nextLeadingConstraint, nextCenterYConstraint]);
        }
        
        NSLayoutConstraint.activate([closeTrailingConstraint, closeCenterYConstraint, closeHeightConstraint, closeWidthConstraint]);
    }
    
    @objc private func closeButtonPressed(_ sender: Any?) {
        self.hide();
    }
}

extension UIViewController {
    public func showCloseMessage(_ text: String, buttonText: String?, type: GSMessageType, options: [GSMessageOption]? = nil, view: UIView? = nil, target: Any?, selector: Selector) {
        var optionsToSend:[GSMessageOption]? = options
        if var options = options {
            options.append(.hideOnTap(false));
            options.append(.autoHide(false));
            options.append(.textAlignment(.left));
            options.append(.textPadding(16.0));
            optionsToSend = options;
        }
        
        let message = BAButtonMessage(text: text, buttonText: buttonText, type: type, options: optionsToSend, inView: view ?? self.view, inViewController: self, target: target, selector: selector);
        message.show();
    }
    
    public func showLeftMessage(_ text: String, type: GSMessageType, options: [GSMessageOption]? = nil, view: UIView? = nil) {
        var optionsToSend = [GSMessageOption]()
        optionsToSend.append(.textAlignment(.left))
        optionsToSend.append(.textPadding(16.0))
        optionsToSend.append(.height(44.0))
        if let options = options {
            optionsToSend.append(contentsOf: options)
        }
        
        GSMessage.showMessageAddedTo(text, type: type, options: optionsToSend, inView: view ?? self.view, inViewController: self)
    }
}
