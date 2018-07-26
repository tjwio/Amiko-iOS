//
//  UIBarItem+TextAttributes.swift
//  Bump
//
//  Created by Tim Wong on 7/25/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

extension UIBarItem {
    open func setAllTitleTextAttributes(_ attributes: [NSAttributedStringKey : Any]?) {
        self.setTitleTextAttributes(attributes, for: .normal);
        self.setTitleTextAttributes(attributes, for: .highlighted);
        self.setTitleTextAttributes(attributes, for: .disabled);
    }
}
