//
//  BANetworkHandler+Image.swift
//  Bump
//
//  Created by Tim Wong on 9/7/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

extension NetworkHandler {
    private struct Constants {
        static let name = "file"
        static let mimeType = "image/jpeg"
    }
    
    public func uploadImage(_ image: Data, success: BAJSONHandler?, failure: BAErrorHandler?) {
        let multipartFormData = MultipartFormData(fileManager: .default, boundary: nil)
        multipartFormData.append(image, withName: Constants.name, fileName: UserHolder.shared.user.randomImageFileName, mimeType: Constants.mimeType)
        
        sessionManager.upload(multipartFormData: multipartFormData, with: URLRouter.uploadImage).validate().responseJSON { response in
            switch response.result {
            case .success(let value): success?(value as? JSON ?? JSON())
            case .failure(let error): failure?(error)
            }
        }
    }
}
