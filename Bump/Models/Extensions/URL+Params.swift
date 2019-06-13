//
//  URL+Params.swift
//  Bump
//
//  Created by Tim Wong on 6/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import Foundation

extension URL {
    var paramaters: [String: String] {
        var parameters = [String: String]()
        URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        
        return parameters
    }
}
