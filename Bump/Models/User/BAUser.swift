//
//  BAUser.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Gloss

enum BAAccountContact: String {
    case phone = "phone"
    case email = "email"
    case linkedin = "linkedin"
    case facebook = "facebook"
    case twitter = "twitter"
    case instagram = "instagram"
    case resume = "resume"
    
    var name: String {
        switch self {
        case .phone: return "Phone"
        case .email: return "Email"
        case .linkedin: return "LinkedIn"
        case .facebook: return "Facebook"
        case .twitter: return "Twitter"
        case .instagram: return "Instagram"
        case .resume: return "Resume"
        }
    }
    
    var isImage: Bool {
        switch self {
        case .phone: return true
        default: return false
        }
    }
    
    var image: String? {
        switch self {
        case .phone: return "phone_icon"
        default: return nil
        }
    }
    
    var iconHex: String? {
        switch self {
        case .email: return "\u{F0E0}"
        case .linkedin: return "\u{F08C}"
        case .facebook: return "\u{F09A}"
        case .twitter: return "\u{f099}"
        case .instagram: return "\u{F16D}"
        case .resume: return "\u{F15C}"
        default: return nil
        }
    }
}

public class BAUser: NSObject, JSONDecodable {
    var userId: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var imageUrl: String?
    var profession: String?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var history = [BAHistory]()
    
    public required init?(json: JSON) {
        guard let userId: String = BAConstants.User.ID <~~ json else { return nil }
        guard let firstName: String = BAConstants.User.FIRST_NAME <~~ json else { return nil }
        guard let lastName: String = BAConstants.User.LAST_NAME <~~ json else { return nil }
        guard let email: String = BAConstants.User.EMAIL <~~ json else { return nil }
        guard let phone: String = BAConstants.User.PHONE <~~ json else { return nil }
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.imageUrl = BAConstants.User.IMAGE_URL <~~ json
        self.profession = BAConstants.User.PROFESSION <~~ json
        
        super.init()
    }
    
    func loadHistory(success: BAHistoryListHandler?, failure: BAErrorHandler?) {
        BANetworkHandler.shared.loadHistory(success: { response in
            guard let historyList = [BAHistory].from(jsonArray: response) else {
                self.history = []
                failure?(BAError.invalidJson)
                return
            }
            
            self.history = historyList
            
            success?(historyList)
        }) { error in
            BALogger.log("failed to parse history with error: \(error)")
            failure?(error)
        }
    }
}
