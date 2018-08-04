//
//  BAAppConstants.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import Gloss

public typealias BABumpHandler = (BABumpEvent) -> Void
public typealias BAUserHandler = (BAUser) -> Void

public typealias BAHistoryHandler = (BAHistory) -> Void
public typealias BAHistoryListHandler = ([BAHistory]) -> Void

public typealias BAEmptyHandler = () -> Void
public typealias BAJSONHandler = (JSON) -> Void
public typealias BAJSONListHandler = ([JSON]) -> Void
public typealias BAErrorHandler = (Error) -> Void

struct BAConstants {
    struct User {
        static let id = "id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let email = "email"
        static let phone = "phone"
        static let imageUrl = "image_url"
        static let profession = "profession"
        static let password = "password"
    }
    
    struct Channel {
        static let lobby = "bump:lobby"
        static let privateRoom = "private_room"
    }
    
    struct Events {
        static let bumped = "bumped"
        static let matched = "bump_matched"
        static let test = "bump_test"
    }
    
    struct GeoMessage {
        static let userId = "userId"
        static let timestamp = "timestamp"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
}
