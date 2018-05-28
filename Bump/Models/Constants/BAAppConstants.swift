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

public typealias BAEmptyHandler = () -> Void
public typealias BAJSONHandler = (JSON) -> Void
public typealias BAArrayHandler = ([JSON]) -> Void
public typealias BAErrorHandler = (Error) -> Void

struct BAConstants {
    struct User {
        static let ID = "id"
        static let FIRST_NAME = "first_name"
        static let LAST_NAME = "last_name"
        static let EMAIL = "email"
        static let PHONE = "phone"
        static let IMAGE_URL = "image_url"
        static let PROFESSION = "profession"
        static let PASSWORD = "password"
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
        static let USER_ID = "userId"
        static let TIMESTAMP = "timestamp"
        static let LATITUDE = "latitude"
        static let LONGITUDE = "longitude"
    }
}
