//
//  BAHistory.swift
//  Bump
//
//  Created by Tim Wong on 7/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import MapKit
import Gloss

public class BAHistory: NSObject, JSONDecodable {
    weak var user: BAUser?
    
    var id: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var addedUser: BAUser
    
    struct Constants {
        static let id = "id"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let addedUser = "added_user"
    }
    
    required public init?(json: JSON) {
        guard let id: String = Constants.id <~~ json,
            let latitude: Double = Constants.latitude <~~ json,
            let longitude: Double = Constants.longitude <~~ json,
            let addedUserJson: JSON = Constants.addedUser <~~ json,
            let addedUser = BAUser(json: addedUserJson)
            else { return nil}
        
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.addedUser = addedUser
    }
    
    convenience public init?(json: JSON, user: BAUser) {
        self.init(json: json)
        self.user = user
    }
}
