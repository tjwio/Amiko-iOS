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
    
    public class func mainRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "TitilliumWeb-Regular", size: size)
    }
    
    public class func mainSemiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "TitilliumWeb-SemiBold", size: size)
    }
    
    public class func fontAwesome(size: CGFloat) -> UIFont? {
        return UIFont(name: "FontAwesome", size: size)
    }
    
    //MARK: headers
    
    public class func mainHeader() -> UIFont? {
        return mainSemiBold(size: 24.0)
    }
    
    public class func mediumHeader() -> UIFont? {
        return mainSemiBold(size: 20.0)
    }
    
    public class func smallheader() -> UIFont? {
        return mainSemiBold(size: 16.0)
    }
    
    //MARK: regular
    
    public class func regularText() -> UIFont? {
        return mainRegular(size: 16.0)
    }
    
    //MARK: detail
    
    public class func detailText() -> UIFont? {
        return mainRegular(size: 14.0)
    }
}
