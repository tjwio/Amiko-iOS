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
        static let NAME = "name"
        static let EMAIL = "email"
        static let PHONE = "phone"
        static let IMAGE_URL = "imageUrl"
        static let PASSWORD = "password"
    }
}