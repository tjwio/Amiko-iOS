//
//  BANetworkHandler+User.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

extension NetworkHandler {
    //MARK: GET
    
    public func loadUser(success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(URLRouter.loadUser).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                success?(value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    public func loadSpecificUser(id: String, success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(URLRouter.loadSpecificUser(id: id)).validate().responseJSON { response in
            switch response.result {
            case .success(let value): success?(value as? JSON ?? JSON())
            case .failure(let error): failure?(error)
            }
        }
    }
    
    public func loadHistory(success: BAJSONListHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(URLRouter.loadHistory).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                success?(value as? [JSON] ?? [JSON]())
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    //MARK: POST
    
    public func addConnection(parameters: Parameters, success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(URLRouter.addConnection(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success(let value): success?(value as? JSON ?? JSON())
            case .failure(let error): failure?(error)
            }
        }
    }
    
    //MARK: PUT
    
    public func updateUser(parameters: Parameters, success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(URLRouter.updateUser(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success(let value): success?(value as? JSON ?? JSON())
            case .failure(let error): failure?(error)
            }
        }
    }
    
    //MARK: DELETE
    
    public func deleteConnection(historyId: String, success: BAEmptyHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(URLRouter.deleteConnection(historyId: historyId)).validate().responseData { response in
            switch response.result {
            case .success(_): success?()
            case .failure(let error): failure?(error)
            }
        }
    }
}
