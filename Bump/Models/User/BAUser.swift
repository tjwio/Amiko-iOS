//
//  BAUser.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import Gloss
import ReactiveCocoa
import ReactiveSwift
import SDWebImage

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
    
    let image = MutableProperty<UIImage?>(nil)
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var history = [BAHistory]()
    
    public required init?(json: JSON) {
        guard let userId: String = BAConstants.User.id <~~ json else { return nil }
        guard let firstName: String = BAConstants.User.firstName <~~ json else { return nil }
        guard let lastName: String = BAConstants.User.lastName <~~ json else { return nil }
        guard let email: String = BAConstants.User.email <~~ json else { return nil }
        guard let phone: String = BAConstants.User.phone <~~ json else { return nil }
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.imageUrl = BAConstants.User.imageUrl <~~ json
        self.profession = BAConstants.User.profession <~~ json
        
        super.init()
    }
    
    //MARK: load/get
    
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
    
    func loadImage(success: BAImageHandler?, failure: BAErrorHandler?) {
        guard image.value == nil else { success?(image.value!); return; }
        
        if let imageUrl = self.imageUrl {
            SDWebImageManager.shared().loadImage(with: URL(string: imageUrl), options: .retryFailed, progress: nil) { (image, _, error, _, _, _) in
                if let image = image {
                    self.image.value = image
                    success?(image)
                }
                else {
                    failure?(error ?? BAError.nilOrEmpty)
                }
            }
        }
        else {
            failure?(BAError.nilOrEmpty)
        }
    }
    
    //MARK: add/post
    
    func addConnection(addedUserId: String, latitude: Double, longitude: Double, success: BAHistoryHandler?, failure: BAErrorHandler?) {
        let parameters: JSON = [
            BAHistory.Constants.userId : addedUserId,
            BAHistory.Constants.latitude : latitude,
            BAHistory.Constants.longitude : longitude
        ]
        
        BANetworkHandler.shared.addConnection(parameters: parameters, success: { json in
            if let entry = BAHistory(json: json, user: self) {
                self.history.append(entry)
                success?(entry)
            }
            else {
                failure?(BAError.invalidJson)
            }
        }) { error in
            print("failed to add connection with error: \(error)")
            failure?(error)
        }
    }
}
