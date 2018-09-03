//
//  String+Null.swift
//  Bump
//
//  Created by Tim Wong on 9/3/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension String {
    var nullOrValue: Any {
        return isEmpty ? NSNull() : self
    }
}
