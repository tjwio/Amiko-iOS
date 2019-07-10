//
//  BANetworkHandler+Authentication.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation

extension NetworkHandler {
    public func signup(firstName: String, lastName: String, email: String, phone: String, password: String, success: BAJSONHandler?, failure: BAErrorHandler?) {
        let parameters = [
            AppConstants.User.firstName : firstName,
            AppConstants.User.lastName : lastName,
            AppConstants.User.email : email,
            AppConstants.User.phone : phone,
            AppConstants.User.password : password
        ]
        
        self.sessionManager.request(URLRouter.signup(parameters: parameters)).validate().responseJSON { response in
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
            AppConstants.User.email : email,
            AppConstants.User.password : password
        ]
        
        self.sessionManager.request(URLRouter.login(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                success?(value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
}
