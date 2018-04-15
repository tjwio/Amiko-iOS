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
        return "http://localhost:5678/webapi"
    }
    
    var streamUrl: String {
        return "http://localhost:9092"
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
}
