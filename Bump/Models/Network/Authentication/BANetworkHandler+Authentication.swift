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
            BAConstants.User.firstName : firstName,
            BAConstants.User.lastName : lastName,
            BAConstants.User.email : email,
            BAConstants.User.phone : phone,
            BAConstants.User.password : password
        ]
        
        self.sessionManager.request(BAURLRouter.signup(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                success?(value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    public func login(email: String, password: String, success: BAJSONHandler?, failure: BAErrorHandler?) {
        let parameters = [
            BAConstants.User.email : email,
            BAConstants.User.password : password
        ]
        
        self.sessionManager.request(BAURLRouter.login(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                success?(value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
}
