//
//  BAAppManager.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

enum BAEnvironment {
    case development, staging, production
    
    var apiUrl: String {
        return "http://localhost:4000/api/v1"
    }
    
    var streamUrl: String {
        return "ws://localhost:4000/socket/websocket"
//        return "https://ciao-bump.herokuapp.com"
    }
}

class BAAppManager: NSObject {
    static private(set) var shared = BAAppManager(environment: .production)
    
    private(set) var environment: BAEnvironment
    
    private init(environment: BAEnvironment) {
        self.environment = environment
        super.init()
    }
    
    class func initialize(environment: BAEnvironment) -> BAAppManager {
        shared = BAAppManager(environment: environment)
        
        return shared
    }
    
    func logOut() {
        BAAuthenticationManager.shared.logOut()
        (UIApplication.shared.delegate as? AppDelegate)?.loadInitialViewController()
    }
}
