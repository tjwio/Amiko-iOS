//
//  UIImage+Resize.swift
//  Bump
//
//  Created by Tim Wong on 8/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
