//
//  BANetworkHandler+Image.swift
//  Bump
//
//  Created by Tim Wong on 9/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import Gloss

extension BANetworkHandler {
    private struct Constants {
        static let name = "file"
        static let mimeType = "image/jpeg"
    }
    
    public func uploadImage(_ image: Data, success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: Constants.name, fileName: BAUserHolder.shared.user.randomImageFileName, mimeType: Constants.mimeType)
        }, with: BAURLRouter.uploadImage) { result in
            switch result {
            case .success(let upload, _, _):
                upload.validate().responseJSON(completionHandler: { response in
                    success?(response.result.value as? JSON ?? JSON())
                })
            case .failure(let error):
                failure?(error)
            }
        }
    }
}
