//
//  Array+RemoveObject.swift
//  Bump
//
//  Created by Tim Wong on 8/27/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Array {
    
    /// Helper method to remove first object which isEqual block returns true
    ///
    /// - Parameter isEqual: block to compare objects
    mutating func remove(where isEqual: ((_ object: Element) -> Bool)) {
        for (index, object) in enumerated() {
            if isEqual(object) {
                remove(at: index)
                return
            }
        }
    }
}
