//
//  Date+Formatter.swift
//  Bump
//
//  Created by Tim Wong on 7/23/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension Date {
    public func string(formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
}
