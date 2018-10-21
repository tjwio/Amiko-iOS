//
//  BAUser.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import Gloss
import FeatherIcon
import ReactiveCocoa
import ReactiveSwift
import SDWebImage

public enum BAAccountContact: String {
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
    
    var icon: String {
        switch self {
        case .email: return String.featherIcon(name: .mail)
        case .phone: return String.featherIcon(name: .smartphone)
        case .facebook: return String.featherIcon(name: .facebook)
        case .instagram: return String.featherIcon(name: .instagram)
        case .linkedin: return String.featherIcon(name: .linkedin)
        case .twitter: return String.featherIcon(name: .twitter)
        case .resume: return String.featherIcon(name: .paperclip)
        }
    }
    
    var font: UIFont? {
        return UIFont.featherFont(size: 24.0)
    }
    
    var color: UIColor {
        switch self {
        case .facebook: return UIColor(hexColor: 0x7B86E1)
        case .instagram: return UIColor(hexColor: 0xD48EE8)
        case .linkedin: return UIColor(hexColor: 0x678EC2)
        case .twitter: return UIColor(hexColor: 0x8DBEFA)
        default: return UIColor.Blue.normal
        }
    }
    
    func appUrl(id: String) -> String? {
        switch self {
        case .email: return "mailto:\(id)"
        case .phone: return "tel://\(id)"
        case .facebook: return "fb://profile/\(id)"
        case .instagram: return "instagram://user?username=\(id)"
        case .linkedin: return "linkedin://profile/\(id)"
        case .twitter: return "twitter://user?screen_name=\(id)"
        default: return nil
        }
    }
    
    func webUrl(id: String) -> String? {
        switch self {
        case .facebook: return "https://www.facebook.com/\(id)"
        case .instagram: return "https://www.instagram.com/\(id)"
        case .linkedin: return "https://www.linkedin.com/in/\(id)"
        case .twitter: return "https://twitter.com/\(id)"
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
    var company: String?
    var website: String?
    
    var facebook: String?
    var linkedin: String?
    var instagram: String?
    var twitter: String?
    
    var fullJobCompany: String? {
        if let profession = profession, let company = company {
            return profession.appending(" at \(company)")
        }
        else if let profession = profession {
            return profession
        }
        else if let company = company {
            return company
        }
        
        return nil
    }
    
    var socialAccounts: [(BAAccountContact, String)] {
        var ret = [(BAAccountContact, String)]()
        
        if !(facebook?.isEmpty ?? true) {
            ret.append((.facebook, facebook!))
        }
        if !(linkedin?.isEmpty ?? true) {
            ret.append((.linkedin, linkedin!))
        }
        if !(instagram?.isEmpty ?? true) {
            ret.append((.instagram, instagram!))
        }
        if !(twitter?.isEmpty ?? true) {
            ret.append((.twitter, twitter!))
        }
        
        return ret
    }
    
    let image = MutableProperty<UIImage?>(nil)
    let imageColors = MutableProperty<UIImageColors?>(nil)
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var history = [BAHistory]()
    
    private let availableSocial = [BAConstants.User.facebook, BAConstants.User.instagram, BAConstants.User.linkedin, BAConstants.User.twitter]
    
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
        self.company = BAConstants.User.company <~~ json
        self.website = BAConstants.User.website <~~ json
        
        self.facebook = BAConstants.User.facebook <~~ json
        self.linkedin = BAConstants.User.linkedin <~~ json
        self.instagram = BAConstants.User.instagram <~~ json
        self.twitter = BAConstants.User.twitter <~~ json
        
        super.init()
    }
    
    class func json(firstName: String, lastName: String, profession: String, company: String, phone: String, email: String, website: String, facebook: String, linkedin: String, instagram: String, twitter: String) -> JSON {
        return jsonify([
            BAConstants.User.firstName ~~> firstName.nullOrValue,
            BAConstants.User.lastName ~~> lastName.nullOrValue,
            BAConstants.User.profession ~~> profession.nullOrValue,
            BAConstants.User.company ~~> company.nullOrValue,
            BAConstants.User.phone ~~> phone.nullOrValue,
            BAConstants.User.email ~~> email.nullOrValue,
            BAConstants.User.website ~~> website.nullOrValue,
            BAConstants.User.facebook ~~> facebook.nullOrValue,
            BAConstants.User.linkedin ~~> linkedin.nullOrValue,
            BAConstants.User.instagram ~~> instagram.nullOrValue,
            BAConstants.User.twitter ~~> twitter.nullOrValue
            ]) ?? [:]
    }
    
    //MARK: load/get
    
    func loadHistory(success: BAHistoryListHandler?, failure: BAErrorHandler?) {
        BANetworkHandler.shared.loadHistory(success: { response in
            guard let historyList = [BAHistory].from(jsonArray: response) else {
                self.history = []
                failure?(BAError.invalidJson)
                return
            }
            
            self.history = historyList.sorted { (first, last) -> Bool in
                return first.date > last.date
            }
            
            success?(historyList)
        }) { error in
            BALogger.log("failed to parse history with error: \(error)")
            failure?(error)
        }
    }
    
    func loadImage(success: BAImageHandler?, failure: BAErrorHandler?) {
        if let image = image.value, let imageColors = imageColors.value {
            success?(image, imageColors)
            return
        }
        
        if let imageUrl = self.imageUrl {
            SDWebImageManager.shared().loadImage(with: URL(string: imageUrl), options: .retryFailed, progress: nil) { (image, _, error, _, _, _) in
                if let image = image {
                    image.getColors { [weak self] colors in
                        self?.image.value = image
                        self?.imageColors.value = colors
                        success?(image, colors)
                    }
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
                self.history.insert(entry, at: 0)
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
    
    //MARK: update/put
    
    func updateUser(firstName: String, lastName: String, profession: String, company: String, phone: String, email: String, website: String, facebook: String, linkedin: String, instagram: String, twitter: String, success: BAEmptyHandler?, failure: BAErrorHandler?) {
        let parameters = BAUser.json(firstName: firstName, lastName: lastName, profession: profession, company: company, phone: phone, email: email, website: website, facebook: facebook, linkedin: linkedin, instagram: instagram, twitter: twitter)
        
        BANetworkHandler.shared.updateUser(parameters: parameters, success: { _ in
            self.firstName = firstName
            self.lastName = lastName
            self.profession = profession
            self.company = company
            self.phone = phone
            self.email = email
            self.website = website
            
            self.facebook = facebook
            self.linkedin = linkedin
            self.instagram = instagram
            self.twitter = twitter
            success?()
        }) { error in
            print("failed to update user with error: \(error)")
            failure?(error)
        }
    }
    
    //MARK: delete
    
    func deleteConnection(history: BAHistory, success: BAEmptyHandler?, failure: BAErrorHandler?) {
        BANetworkHandler.shared.deleteConnection(historyId: history.id, success: {
            self.history.remove(object: history)
            
            success?()
        }) { error in
            print("failed to delete connection: \(history.id) with error: \(error)")
            failure?(error)
        }
    }
}
