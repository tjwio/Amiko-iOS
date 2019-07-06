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
    weak var user: User?
    
    var id: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var date: Date
    var addedUser: User
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    struct Constants {
        static let id = "id"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let insertedAt = "inserted_at"
        static let addedUser = "added_user"
        static let userId = "user_id"
    }
    
    required public init?(json: JSON) {
        guard let id: String = Constants.id <~~ json,
            let latitude: Double = Constants.latitude <~~ json,
            let longitude: Double = Constants.longitude <~~ json,
            let date = Gloss.Decoder.decode(dateForKey: Constants.insertedAt, dateFormatter: .iso861)(json),
            let addedUserJson: JSON = Constants.addedUser <~~ json,
            let addedUser = User(json: addedUserJson)
            else { return nil}
        
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.addedUser = addedUser
    }
    
    convenience public init?(json: JSON, user: User) {
        self.init(json: json)
        self.user = user
    }
}
