//
//  Card.swift
//  Bump
//
//  Created by Tim Wong on 7/27/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import Foundation

public struct Card: Codable {
    var id: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
