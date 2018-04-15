//
//  BALocationManager.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import MapKit

class BALocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = BALocationManager()
    
    let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?
    
    class func initialize() -> BALocationManager {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse && CLLocationManager.authorizationStatus() != .authorizedAlways  {
            shared.locationManager.requestWhenInUseAuthorization()
            shared.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            shared.locationManager.delegate = shared
            shared.locationManager.startUpdatingLocation()
        }
        
        return shared
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = manager.location
    }
}
