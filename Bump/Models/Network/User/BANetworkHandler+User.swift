//
//  BANetworkHandler+User.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

extension BANetworkHandler {
    //MARK: GET
    
    public func loadUser(success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(BAURLRouter.loadUser).validate().responseJSON { response in
            switch response.result {
            case .success:
                success?(response.result.value as? JSON ?? JSON())
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    public func loadHistory(success: BAJSONListHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(BAURLRouter.loadHistory).validate().responseJSON { response in
            switch response.result {
            case .success:
                success?(response.result.value as? [JSON] ?? [JSON]())
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    //MARK: POST
    
    public func addConnection(parameters: Parameters, success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(BAURLRouter.addConnection(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success: success?(response.result.value as? JSON ?? JSON())
            case .failure(let error): failure?(error)
            }
        }
    }
    
    //MARK: PUT
    
    public func updateUser(parameters: Parameters, success: BAJSONHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(BAURLRouter.updateUser(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success: success?(response.result.value as? JSON ?? JSON())
            case .failure(let error): failure?(error)
            }
        }
    }
    
    //MARK: DELETE
    
    public func deleteConnection(historyId: String, success: BAEmptyHandler?, failure: BAErrorHandler?) {
        self.sessionManager.request(BAURLRouter.deleteConnection(historyId: historyId)).validate().responseData { response in
            switch response.result {
            case .success: success?()
            case .failure(let error): failure?(error)
            }
        }
    }
}
