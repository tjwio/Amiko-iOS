//
//  UIFont+CustomFonts.swift
//  Bump
//
//  Created by Tim Wong on 3/8/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

extension UIFont {
    //MARK: basic fonts
    
    public func mainRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "TitilliumWeb-Regular", size: size)
    }
    
    public func mainSemiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "TitilliumWeb-SemiBold", size: size)
    }
    
    //MARK: headers
    
    public func mainHeader() -> UIFont? {
        return mainSemiBold(size: 24.0)
    }
    
    public func mediumHeader() -> UIFont? {
        return mainSemiBold(size: 20.0)
    }
    
    public func smallheader() -> UIFont? {
        return mainSemiBold(size: 16.0)
    }
    
    //MARK: regular
    
    public func regularText() -> UIFont? {
        return mainRegular(size: 16.0)
    }
    
    //MARK: detail
    
    public func detailText() -> UIFont? {
        return mainRegular(size: 14.0)
    }
}
