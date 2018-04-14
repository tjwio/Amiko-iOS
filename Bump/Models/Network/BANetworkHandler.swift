//
//  BANetworkHandler.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

final class BANetworkHandler: NSObject {
    static let shared = BANetworkHandler()
    private(set) var sessionManager = SessionManager(configuration: .default)
    
    private override init() { super.init() }
}
