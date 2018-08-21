//
//  BAUserPinAnnotation.swift
//  Bump
//
//  Created by Tim Wong on 8/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import MapKit

class BAUserPinAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    weak var history: BAHistory?
    
    var isShowing = false
    
    init(coordinate: CLLocationCoordinate2D, history: BAHistory) {
        self.coordinate = coordinate
        self.history = history
    }
}
