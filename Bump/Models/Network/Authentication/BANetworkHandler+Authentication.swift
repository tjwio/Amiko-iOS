//
//  BANetworkHandler+Authentication.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import Gloss

extension BANetworkHandler {
    public func signup(firstName: String, lastName: String, email: String, phone: String, password: String, success: BAJSONHandler?, failure: BAErrorHandler?) {
        let parameters = [
            BAConstants.User.FIRST_NAME : firstName,
            BAConstants.User.LAST_NAME : lastName,
            BAConstants.User.EMAIL : email,
            BAConstants.User.PHONE : phone,
            BAConstants.User.PASSWORD : password
        ]
        
        self.sessionManager.request(BAURLRouter.signup(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success:
                success?(response.result.value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    public func login(email: String, password: String, success: BAJSONHandler?, failure: BAErrorHandler?) {
        let parameters = [
            BAConstants.User.EMAIL : email,
            BAConstants.User.PASSWORD : password
        ]
        
        self.sessionManager.request(BAURLRouter.login(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success:
                success?(response.result.value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
}
