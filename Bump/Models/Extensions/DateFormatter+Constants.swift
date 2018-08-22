//
//  DateFormatter+Constants.swift
//  Bump
//
//  Created by Tim Wong on 7/23/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension DateFormatter {
    static private let iso861Format: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter
    }()
    
    static private let monthDayYearFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter
    }()
    
    class var iso861: DateFormatter {
        return DateFormatter.iso861Format
    }
    
    class var monthDayYear: DateFormatter {
        return DateFormatter.monthDayYearFormat
    }
}
