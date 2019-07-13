//
//  BAUserPinAnnotation.swift
//  Bump
//
//  Created by Tim Wong on 8/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import MapKit

class UserPinAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let ship: Ship
    
    var isShowing = false
    
    init(ship: Ship) {
        self.coordinate = ship.coordinate
        self.ship = ship
    }
}
