//
//  BALocalizationStrings.swift
//  Bump
//
//  Created by Tim Wong on 7/13/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

protocol BALocalizable {
    var tableName: String { get }
    var localized: String { get }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
    }
}

extension BALocalizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}

struct BAStrings {
    enum Global: String, BALocalizable {
        case title = "title"
        
        var tableName: String {
            return "Global"
        }
    }
    
    enum FirstExp: String, BALocalizable {
        case bumpTitle = "bump_title"
        case bumpDescription = "bump_description"
        case getStarted = "get_started"
        case introDescription = "intro_description"
        case skipThisStep = "skip_this_step"
        case socialTitle = "social_title"
        case socialDescription = "social_description"
        case swipeLeft = "swipe_left"
        
        var tableName: String {
            return "FirstExp"
        }
    }
}
