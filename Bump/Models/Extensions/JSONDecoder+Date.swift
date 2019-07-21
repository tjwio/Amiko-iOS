//
//  JSONDecoder+Date.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import Foundation

extension JSONDecoder {
    private static let _iso8601DateDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    class var iso8601DateDeocder:JSONDecoder {
        return _iso8601DateDecoder
    }
}
