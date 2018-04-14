//
//  BABumpManager.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import CoreMotion

public struct BABumpEvent {
    var acceleration: CMAcceleration
    var date: Date
    
    init(acceleration: CMAcceleration, date: Date = Date()) {
        self.acceleration = acceleration
        self.date = date
    }
}

public class BABumpManager: NSObject {
    public static let shared = BABumpManager()
    
    public var bumpHandler: BABumpHandler?
    public var errorHandler: BAErrorHandler?
    
    private var prev = 0.0
    private var skipTimes = 0
    
    private let motionManager: CMMotionManager = {
        let manager = CMMotionManager()
        manager.deviceMotionUpdateInterval = 0.001
        
        return manager
    }()
    
    public func start() {
        motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
            if let data = motion {
                let curr = data.userAcceleration.z
                
                if self.skipTimes > 0 {
                    self.prev = curr
                    self.skipTimes -= 1
                    return
                }
                
                let delta = abs(curr - self.prev)
                
                if delta > 4 {
                    self.skipTimes = 20
                    self.bumpHandler?(BABumpEvent(acceleration: data.userAcceleration))
                }
            }
            else if let error = error {
                self.errorHandler?(error)
            }
        }
    }
    
    public func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
}
