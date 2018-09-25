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
    
    private var didInitialize = false
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    func initialize() {
        guard !didInitialize else { return }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if isAuthorized {
            didInitialize = true
            locationManager.startUpdatingLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            didInitialize = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLoc = manager.location {
            if let curr = currentLocation {
                print("distance: \(curr.distance(from: newLoc))")
                if shouldUpdateLocation(curr: curr, next: newLoc) {
                    currentLocation = newLoc
                }
                else {
                    print("not updating location")
                }
            }
            else {
                currentLocation = newLoc
            }
            
            print("latitude: \(newLoc.coordinate.latitude), longitude: \(newLoc.coordinate.longitude), horizontal accuracy: \(newLoc.horizontalAccuracy), timestamp: \(newLoc.timestamp.timeIntervalSinceNow)\n")
        }
    }
    
    //MARK: helper methods
    
    private func shouldUpdateLocation(curr: CLLocation, next: CLLocation) -> Bool {
        guard next.horizontalAccuracy >= 0 && -next.timestamp.timeIntervalSinceNow < 10 else { return false }
        
        let hDelta = curr.horizontalAccuracy - next.horizontalAccuracy
        
        return hDelta > -10
    }
}
