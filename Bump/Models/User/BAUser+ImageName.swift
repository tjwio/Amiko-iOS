//
//  BAUser+ImageName.swift
//  Bump
//
//  Created by Tim Wong on 9/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import UIKit

extension BAUser {
    var randomImageFileName: String {
        let randomNum = Int(arc4random_uniform(10000))
        
        return "\(fullName)_\(randomNum).jpeg"
    }
    
    func updateImage(_ image: UIImage, success: BAEmptyHandler?, failure: BAErrorHandler?) {
        guard let data = UIImageJPEGRepresentation(image, 0.7) else {
            failure?(BAError.imageData)
            return
        }
        
        BANetworkHandler.shared.uploadImage(data, success: { _ in
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
