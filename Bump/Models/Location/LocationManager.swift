//
//  BALocationManager.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import MapKit
import ReactiveCocoa
import ReactiveSwift

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    let currentLocation = MutableProperty<CLLocation?>(nil)
    
    private var disposables = CompositeDisposable()
    
    private var didInitialize = false
    
    let didReceiveFirstLocation = MutableProperty<Bool>(false)
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    deinit {
        disposables.dispose()
    }
    
    func initialize() {
        guard !didInitialize else { return }
        
        disposables += currentLocation.signal.observeValues { [unowned self] location in
            guard location != nil else { return }
            
            if !self.didReceiveFirstLocation.value {
                self.didReceiveFirstLocation.value = true
            }
        }
        
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
            if let curr = currentLocation.value {
                print("distance: \(curr.distance(from: newLoc))")
                if shouldUpdateLocation(curr: curr, next: newLoc) {
                    currentLocation.value = newLoc
                }
                else {
                    print("not updating location")
                }
            }
            else {
                currentLocation.value = newLoc
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
    
    func startUpdatingLocation() {
        didReceiveFirstLocation.value = false
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        currentLocation.value = nil
        didReceiveFirstLocation.value = false
        locationManager.stopUpdatingLocation()
    }
}
