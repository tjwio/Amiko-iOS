//
//  UIViewController+Message.swift
//  Bump
//
//  Created by Tim Wong on 4/9/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import GSMessages

extension UIViewController {
    public func showLeftMessage(_ text: String, type: GSMessageType, options: [GSMessageOption]? = nil, view: UIView? = nil) {
        var optionsToSend = [GSMessageOption]()
        optionsToSend.append(.textAlignment(.left))
        optionsToSend.append(.padding(UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)))
        optionsToSend.append(.height(44.0))
        if let options = options {
            optionsToSend.append(contentsOf: options)
        }
        
        GSMessage.showMessageAddedTo(text: text, type: type, options: optionsToSend, inView: view ?? self.view, inViewController: self)
    }
}
