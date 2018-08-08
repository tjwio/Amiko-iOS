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
    weak var user: BAUser?
    
    init(coordinate: CLLocationCoordinate2D, user: BAUser) {
        self.coordinate = coordinate
        self.user = user
    }
}
