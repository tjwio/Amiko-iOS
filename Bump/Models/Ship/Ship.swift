//
//  Ship.swift
//  Bump
//
//  Created by Tim Wong on 7/10/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import Foundation
import MapKit

public struct Ship: Codable {
    var id: String
    var user: User
    var latitude: Double
    var longitude: Double
    var sharedInfo: [AccountContact]
    var pending: Bool
    var insertedAt: Date
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, user, latitude, longitude, pending
        case sharedInfo = "shared_info"
        case insertedAt = "inserted_at"
    }
}
