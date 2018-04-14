//
//  UIColor+HexRGB.swift
//  Bump
//
//  Created by Tim Wong on 4/13/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(hexColor: UInt, alpha: CGFloat = 1.0) {
        self.init(red: ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0,
                  green: ((CGFloat)((hexColor & 0x00FF00) >>  8))/255.0,
                  blue: ((CGFloat)((hexColor & 0x0000FF) >>  0))/255.0,
                  alpha: alpha);
    }
}
