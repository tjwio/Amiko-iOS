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
    
    struct Grayscale {
        static var dark: UIColor {
            return UIColor(hexColor: 0x656A6F)
        }
        
        static var light: UIColor {
            return UIColor(hexColor: 0xA7ADB6)
        }
        
        static var lighter: UIColor {
            return UIColor(hexColor: 0xD8D8D8)
        }
        
        static var lightest: UIColor {
            return UIColor(hexColor: 0xFBFCFD)
        }
    }
    
    struct Blue {
        static var normal: UIColor {
            return UIColor(hexColor: 0x77B0FD)
        }
        
        static var darker: UIColor {
            return UIColor(hexColor: 0x658DF8)
        }
    }
}
