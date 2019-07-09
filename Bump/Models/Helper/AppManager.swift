//
//  BAAppManager.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    enum Environment {
        case development, staging, production
        
        var apiUrl: String {
            return "http://localhost:4000/api/v1"
        }
        
        var streamUrl: String {
            return "ws://localhost:4000/socket/websocket"
        }
    }
    
    static private(set) var shared = AppManager(environment: .production)
    
    private(set) var environment: Environment
    
    var deepLinkId: String?
    
    private init(environment: Environment) {
        self.environment = environment
        super.init()
    }
    
    class func initialize(environment: Environment) -> AppManager {
        shared = AppManager(environment: environment)
        
        return shared
    }
    
    func logOut() {
        AuthenticationManager.shared.logOut()
        UserHolder.logOut()
        (UIApplication.shared.delegate as? AppDelegate)?.loadWelcomeViewController()
    }
}