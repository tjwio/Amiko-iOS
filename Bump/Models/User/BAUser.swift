//
//  BAUser.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Gloss

public class BAUser: NSObject, JSONDecodable {
    var userId: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var imageUrl: String?
    
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
        
        super.init()
    }
}
