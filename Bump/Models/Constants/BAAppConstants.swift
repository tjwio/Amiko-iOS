//
//  BAAppConstants.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import Gloss

public typealias BABumpHandler = (BABumpEvent) -> Void
public typealias BAUserHandler = (BAUser) -> Void

public typealias BAHistoryHandler = (BAHistory) -> Void
public typealias BAHistoryListHandler = ([BAHistory]) -> Void

public typealias BASocialCallback = (BAAccountContact, String) -> Void

public typealias BAEmptyHandler = () -> Void
public typealias BAJSONHandler = (JSON) -> Void
public typealias BAJSONListHandler = ([JSON]) -> Void
public typealias BAErrorHandler = (Error) -> Void

public typealias BAImageHandler = (UIImage, UIImageColors) -> Void

struct BAConstants {
    struct User {
        static let id = "id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let email = "email"
        static let phone = "phone"
        static let imageUrl = "image_url"
        static let profession = "profession"
        static let facebook = "facebook"
        static let instagram = "instagram"
        static let linkedin = "linkedin"
        static let twitter = "twitter"
        static let password = "password"
    }
    
    struct Channel {
        static let lobby = "bump:lobby"
        static let privateRoom = "private_room"
    }
    
    struct Events {
        static let bumped = "bumped"
        static let matched = "bump_matched"
        static let test = "bump_test"
    }
    
    struct GeoMessage {
        static let userId = "userId"
        static let timestamp = "timestamp"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    struct HockeyApp {
        static let id = "89a0b16ec7df40e798c9dafc196235a1"
    }
    
    static let defaultSocialCallback: BASocialCallback = { (account, value) in
        var validUrl: URL?
        
        if let str = account.appUrl(id: value), let url = URL(string: str), UIApplication.shared.canOpenURL(url) {
            validUrl = url
        }
        else if let str = account.webUrl(id: value), let url = URL(string: str), UIApplication.shared.canOpenURL(url) {
            validUrl = url
        }
        
        if let url = validUrl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct BADeviceUtil {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}
