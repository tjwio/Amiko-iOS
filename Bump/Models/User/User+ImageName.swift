//
//  BAUser+ImageName.swift
//  Bump
//
//  Created by Tim Wong on 9/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import UIKit

extension User {
    var randomImageFileName: String {
        let randomNum = Int(arc4random_uniform(10000))
        
        return "\(fullName.replacingOccurrences(of: " ", with: "_"))_\(randomNum).jpeg"
    }
    
    func updateImage(_ image: UIImage, success: BAEmptyHandler?, failure: BAErrorHandler?) {
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            failure?(BAError.imageData)
            return
        }
        
        NetworkHandler.shared.uploadImage(data, success: { _ in
            image.getColors { colors in
                self.image.value = image
                self.imageColors.value = colors
                success?()
            }
        }) { error in
            print("failed to upload image with error: \(error)")
            failure?(error)
        }
    }
}