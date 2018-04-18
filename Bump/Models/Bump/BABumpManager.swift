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
    private static let ACCELERATION_DELTA_THRESHOLD = 2.0
    
    public static let shared = BABumpManager()
    
    public var bumpHandler: BABumpHandler?
    public var errorHandler: BAErrorHandler?
    
    private var prev = CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
    private var skipTimes = 0
    
    private let motionManager: CMMotionManager = {
        let manager = CMMotionManager()
        manager.deviceMotionUpdateInterval = 0.001
        
        return manager
    }()
    
    public func start() {
        motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
            if let data = motion {
                let curr = data.userAcceleration
                
                if self.skipTimes > 0 {
                    self.prev = curr
                    self.skipTimes -= 1
                    return
                }
                
                let deltaX = abs(curr.x - self.prev.x)
                let deltaY = abs(curr.y - self.prev.y)
                let deltaZ = abs(curr.z - self.prev.z)
                
                if deltaX > BABumpManager.ACCELERATION_DELTA_THRESHOLD || deltaY > BABumpManager.ACCELERATION_DELTA_THRESHOLD || deltaZ > BABumpManager.ACCELERATION_DELTA_THRESHOLD {
                    self.skipTimes = 20
                    self.bumpHandler?(BABumpEvent(acceleration: data.userAcceleration))
                }
                
                print("x: \(abs(data.userAcceleration.x - self.prev.x).roundTo(2)), y: \(abs(data.userAcceleration.y - self.prev.y).roundTo(2)), z: \(abs(data.userAcceleration.z - self.prev.z).roundTo(2))")
                self.prev = data.userAcceleration
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
