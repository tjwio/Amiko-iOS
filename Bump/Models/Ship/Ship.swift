//
//  Ship.swift
//  Bump
//
//  Created by Tim Wong on 7/10/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import Foundation

struct Ship: Codable {
    var user: User
    var latitude: Double
    var longitude: Double
    var pending: Bool
    var insertedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case user, latitude, longitude, pending
        case insertedAt = "inserted_at"
    }
}
