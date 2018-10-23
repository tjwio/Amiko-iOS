//
//  Double+Round.swift
//  Bump
//
//  Created by Tim Wong on 4/17/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places));
        return (self * divisor).rounded() / divisor;
    }
}
