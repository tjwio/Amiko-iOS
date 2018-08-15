//
//  BANavigationBar.swift
//  Bump
//
//  Created by Tim Wong on 8/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BANavigationBar: UINavigationBar {
    
    private struct Constants {
        static let barBackground = "UIBarBackground"
        static let barContentView = "UINavigationBarContentView"
    }
    
    override var frame: CGRect {
        didSet {
            checkIfShouldIncreaseHeight()
            isTransitioning = false
        }
    }
    
    var addExtraPadding = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var isTransitioning = false
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if addExtraPadding {
            sizeThatFits.height = 54.0
        }
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.checkIfShouldIncreaseHeight()
    }
    
    private func checkIfShouldIncreaseHeight() {
        if addExtraPadding, #available(iOS 11.0, *) {
            for subview in subviews {
                let className = NSStringFromClass(subview.classForCoder)
                
                if className.contains(Constants.barBackground) {
                    if isTransitioning && subview.frame.size.height + subview.frame.origin.y == 54.0 {
                        subview.frame.size.height = subview.frame.size.height - 10.0
                    }
                    else if !isTransitioning && subview.frame.size.height + subview.frame.origin.y <= 44.0 {
                        subview.frame.size.height = subview.frame.size.height + 10.0
                    }
                }
                else if className.contains(Constants.barContentView) && subview.frame.origin.y == 0.0 {
                    subview.frame.origin.y = subview.frame.origin.y + 5.0
                }
            }
        }
    }
}
