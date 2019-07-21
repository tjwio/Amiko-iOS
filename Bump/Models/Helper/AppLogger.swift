//
//  BALogger.swift
//  Bump
//
//  Created by Tim Wong on 7/23/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

public class AppLogger: NSObject {
    public class func log(_ string: Any) {
        print("[Amiko]: \(string)")
    }
}
