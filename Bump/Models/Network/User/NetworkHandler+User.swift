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
    
    public func loadUser(success: UserHandler?, failure: ErrorHandler?) {
        self.sessionManager.request(URLRouter.loadUser).validate().responseDecodable { (response: DataResponse<User>) in
            switch response.result {
            case .success(let value): success?(value)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    public func loadSpecificUser(id: String, success: UserHandler?, failure: ErrorHandler?) {
        self.sessionManager.request(URLRouter.loadSpecificUser(id: id)).validate().responseDecodable { (response: DataResponse<User>) in
            switch response.result {
            case .success(let value): success?(value)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    public func loadUserFromCard(id: String, success: UserHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.loadUserFromCard(id: id)).validate().responseDecodable { (response: DataResponse<User>) in
            switch response.result {
            case .success(let value): success?(value)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    public func loadHistory(success: ShipListHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.loadHistory).validate().responseDecodable(decoder: JSONDecoder.iso8601DateDeocder) { (response: DataResponse<[Ship]>) in
            switch response.result {
            case .success(let value): success?(value)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    public func loadSpecificUserShip(userId: String, success: ShipHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.loadSpecificUserShip(userId: userId)).validate().responseDecodable(decoder: JSONDecoder.iso8601DateDeocder) { (response: DataResponse<Ship>) in
            switch response.result {
            case .success(let value): success?(value)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    //MARK: POST
    
    public func addConnection(parameters: Parameters, success: ShipHandler?, failure: ErrorHandler?) {
        self.sessionManager.request(URLRouter.addConnection(parameters: parameters)).validate().responseDecodable(decoder: JSONDecoder.iso8601DateDeocder) { (response: DataResponse<Ship>) in
            switch response.result {
            case .success(let value): success?(value)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    //MARK: PUT
    
    public func updateUser(parameters: Parameters, success: JSONHandler?, failure: ErrorHandler?) {
        self.sessionManager.request(URLRouter.updateUser(parameters: parameters)).validate().responseJSON { response in
            switch response.result {
            case .success(let value): success?(value as? JSON ?? JSON())
            case .failure(let error): failure?(error)
            }
        }
    }
    
    public func updateConnection(id: String, parameters: Parameters, success: ShipHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.updateConnection(id: id, parameters: parameters)).validate().responseDecodable(decoder: JSONDecoder.iso8601DateDeocder) { (response: DataResponse<Ship>) in
            switch response.result {
            case .success(let value): success?(value)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    //MARK: DELETE
    
    public func deleteConnection(id: String, success: EmptyHandler?, failure: ErrorHandler?) {
        self.sessionManager.request(URLRouter.deleteConnection(historyId: id)).validate().responseData { response in
            switch response.result {
            case .success(_): success?()
            case .failure(let error): failure?(error)
            }
        }
    }
}
