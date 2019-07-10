//
//  BAAppConstants.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

public typealias JSON = [String: Any]

public typealias BABumpHandler = (BumpEvent) -> Void
public typealias BAUserHandler = (User) -> Void

public typealias BAHistoryHandler = (BAHistory) -> Void
public typealias BAHistoryListHandler = ([BAHistory]) -> Void

public typealias BAContactActionHandler = (AccountContact, String) -> Void

public typealias BASocialHandler = (AccountContact, String) -> Void

public typealias BAEmptyHandler = () -> Void
public typealias BAStringHandler = (String) -> Void
public typealias BAJSONHandler = (JSON) -> Void
public typealias BAJSONListHandler = ([JSON]) -> Void
public typealias BAErrorHandler = (Error) -> Void

public typealias BAImageHandler = (UIImage, UIImageColors) -> Void

struct AppConstants {
    struct User {
        static let id = "id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let email = "email"
        static let phone = "phone"
        static let imageUrl = "image_url"
        static let profession = "profession"
        static let company = "company"
        static let website = "website"
        static let facebook = "facebook"
        static let instagram = "instagram"
        static let linkedin = "linkedin"
        static let twitter = "twitter"
        static let password = "password"
        static let mutualFriends = "mutual_friends"
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
        static let accuracy = "accuracy"
    }
    
    struct HockeyApp {
        static let id = "89a0b16ec7df40e798c9dafc196235a1"
    }
    
    static let defaultSocialCallback: BASocialHandler = { (account, value) in
        var validUrl: URL?
        
        if let str = account.appUrl(id: value), let url = URL(string: str), UIApplication.shared.canOpenURL(url) {
            validUrl = url
        }
        else if let str = account.webUrl(id: value), let url = URL(string: str), UIApplication.shared.canOpenURL(url) {
            validUrl = url
        }
        
        if let url = validUrl {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
}

struct DeviceUtil {
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
