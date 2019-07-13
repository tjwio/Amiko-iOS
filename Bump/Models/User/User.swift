//
//  BAUser.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon
import ReactiveCocoa
import ReactiveSwift
import SDWebImage

public enum AccountContact: String {
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
        case .facebook: return "fb://profile?id=\(id)"
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

public class User: NSObject, Codable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String?
    var phone: String?
    var imageUrl: String?
    var profession: String?
    var company: String?
    var bio: String?
    var website: String?
    
    var facebook: String?
    var linkedin: String?
    var instagram: String?
    var twitter: String?
    
    var mutualFriends: [User]
    
    var fullJobCompany: String? {
        if let profession = profession, let company = company {
            return profession.appending(" at \(company)")
        } else if let profession = profession {
            return profession
        } else if let company = company {
            return company
        }
        
        return nil
    }
    
    var publicBio: String {
        let jobDesc = (fullJobCompany ?? "")
        
        if let bio = bio {
            return jobDesc.appending("\n\(bio)")
        } else {
            return jobDesc
        }
    }
    
    var allAccounts: [(AccountContact, String)] {
        return mainAccounts + socialAccounts
    }
    
    var mainAccounts: [(AccountContact, String)] {
        var ret = [(AccountContact, String)]()
        
        if let phone = phone, !phone.isEmpty {
            ret.append((.phone, phone))
        }
        
        if let email = email, !email.isEmpty {
            ret.append((.email, email))
        }
        
        return ret
    }
    
    var socialAccounts: [(AccountContact, String)] {
        var ret = [(AccountContact, String)]()
        
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
    
    var ships = [Ship]()
    
    private let availableSocial = [AppConstants.User.facebook, AppConstants.User.instagram, AppConstants.User.linkedin, AppConstants.User.twitter]
    
    enum CodingKeys: String, CodingKey {
        case id, email, phone, profession, company, bio, website, facebook, instagram, linkedin, twitter
        case firstName = "first_name"
        case lastName = "last_name"
        case imageUrl = "image_url"
        case mutualFriends = "mutual_friends"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        profession = try container.decodeIfPresent(String.self, forKey: .profession)
        company = try container.decodeIfPresent(String.self, forKey: .company)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        facebook = try container.decodeIfPresent(String.self, forKey: .facebook)
        instagram = try container.decodeIfPresent(String.self, forKey: .instagram)
        linkedin = try container.decodeIfPresent(String.self, forKey: .linkedin)
        twitter = try container.decodeIfPresent(String.self, forKey: .twitter)
        mutualFriends = try container.decodeIfPresent([User].self, forKey: .mutualFriends) ?? []
    }
    
    public class func json(firstName: String, lastName: String, profession: String, company: String, bio: String, phone: String, email: String, website: String, facebook: String, linkedin: String, instagram: String, twitter: String) -> JSON {
        return [
            CodingKeys.firstName.rawValue: firstName,
            CodingKeys.lastName.rawValue: lastName,
            CodingKeys.profession.rawValue: profession,
            CodingKeys.company.rawValue: company,
            CodingKeys.bio.rawValue: bio,
            CodingKeys.phone.rawValue: phone,
            CodingKeys.email.rawValue: email,
            CodingKeys.website.rawValue: website,
            CodingKeys.facebook.rawValue: facebook,
            CodingKeys.linkedin.rawValue: linkedin,
            CodingKeys.instagram.rawValue: instagram,
            CodingKeys.twitter.rawValue: twitter
        ]
    }
    
    //MARK: load/get
    
    func loadShips(success: ShipListHandler?, failure: ErrorHandler?) {
        NetworkHandler.shared.loadHistory(success: { ships in
            let sortedShips = ships.sorted { (first, last) -> Bool in
                return first.insertedAt > last.insertedAt
            }
            
            self.ships = sortedShips
            success?(sortedShips)
        }) { error in
            AppLogger.log("failed to parse ships with error: \(error)")
            failure?(error)
        }
    }
    
    func loadImage(success: BAImageHandler?, failure: ErrorHandler?) {
        if let image = image.value, let imageColors = imageColors.value {
            success?(image, imageColors)
            return
        }
        
        if let imageUrl = self.imageUrl {
            SDWebImageManager.shared.loadImage(with: URL(string: imageUrl), options: .retryFailed, progress: nil) { (image, _, error, _, _, _) in
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
    
    func addConnection(toUserId: String, latitude: Double, longitude: Double, accounts: [AccountContact], success: ShipHandler?, failure: ErrorHandler?) {
        let parameters: JSON = [
            "from_user_id": id,
            "to_user_id": toUserId,
            Ship.CodingKeys.latitude.rawValue: latitude,
            Ship.CodingKeys.longitude.rawValue : longitude,
            "shared_info": accounts.map { $0.rawValue }
        ]
        
        NetworkHandler.shared.addConnection(parameters: parameters, success: { ship in
            if ship.user.id != self.id, !ship.pending {
                self.ships.append(ship)
            }
            
            success?(ship)
        }) { error in
            print("failed to add connection with error: \(error)")
            failure?(error)
        }
    }
    
    //MARK: update/put
    
    func updateUser(firstName: String, lastName: String, profession: String, company: String, bio: String, phone: String, email: String, website: String, facebook: String, linkedin: String, instagram: String, twitter: String, success: EmptyHandler?, failure: ErrorHandler?) {
        let parameters = User.json(firstName: firstName, lastName: lastName, profession: profession, company: company, bio: bio, phone: phone, email: email, website: website, facebook: facebook, linkedin: linkedin, instagram: instagram, twitter: twitter)
        
        NetworkHandler.shared.updateUser(parameters: parameters, success: { _ in
            self.firstName = firstName
            self.lastName = lastName
            self.profession = profession
            self.company = company
            self.bio = bio
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
    
    func deleteConnection(ship: Ship, success: EmptyHandler?, failure: ErrorHandler?) {
        NetworkHandler.shared.deleteConnection(id: ship.id, success: {
            self.ships.remove { $0.id == ship.id }
            
            success?()
        }) { error in
            print("failed to delete connection: \(ship.id) with error: \(error)")
            failure?(error)
        }
    }
}
