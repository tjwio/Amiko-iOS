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
    var name: String
    var email: String
    var phone: String
    var imageUrl: String?
    
    public required init?(json: JSON) {
        guard let userId: String = BAConstants.User.ID <~~ json else { return nil }
        guard let name: String = BAConstants.User.NAME <~~ json else { return nil }
        guard let email: String = BAConstants.User.EMAIL <~~ json else { return nil }
        guard let phone: String = BAConstants.User.PHONE <~~ json else { return nil }
        
        self.userId = userId
        self.name = name
        self.email = email
        self.phone = phone
        self.imageUrl = BAConstants.User.IMAGE_URL <~~ json
        
        super.init()
    }
}
