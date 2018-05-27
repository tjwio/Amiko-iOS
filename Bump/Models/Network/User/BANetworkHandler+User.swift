//
//  BANetworkHandler+User.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import Gloss

extension BANetworkHandler {
    public func loadUser(success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(BAURLRouter.loadUser()).validate().responseJSON { response in
            switch response.result {
            case .success:
                success?(response.result.value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
}
