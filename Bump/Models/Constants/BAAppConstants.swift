//
//  BAAppConstants.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

public typealias BABumpHandler = (BABumpEvent) -> Void
public typealias BAErrorHandler = (Error) -> Void

struct BAConstants {
    struct User {
        static let NAME = "name"
        static let EMAIL = "email"
        static let PHONE = "phone"
        static let IMAGE_URL = "imageUrl"
    }
}
