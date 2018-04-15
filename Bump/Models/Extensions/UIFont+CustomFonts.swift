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
        return UIFont(name: "AvenirNext-Regular", size: size)
    }
    
    public class func mainMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-Medium", size: size)
    }
    
    public class func mainDemi(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-DemiBold", size: size)
    }
    
    public class func mainBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-Bold", size: size)
    }
    
    public class func mainItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-Italic", size: size)
    }
    
    public class func mainLight(size: CGFloat) -> UIFont? {
        return UIFont(name: "AvenirNext-UltraLight", size: size)
    }
    
    public class func fontAwesome(size: CGFloat) -> UIFont? {
        return UIFont(name: "FontAwesome", size: size)
    }
    
    //MARK: headers
    
    public class func mainHeader() -> UIFont? {
        return mainMedium(size: 24.0)
    }
    
    public class func mediumHeader() -> UIFont? {
        return mainMedium(size: 20.0)
    }
    
    public class func smallheader() -> UIFont? {
        return mainMedium(size: 16.0)
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
