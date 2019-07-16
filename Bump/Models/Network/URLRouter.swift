//
//  BAURLRouters.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

enum URLRouter: URLRequestConvertible {
    //MARK: GET
    case loadUser
    case loadSpecificUser(id: String)
    case loadUserFromCard(id: String)
    case loadHistory
    case loadSpecificUserShip(userId: String)
    
    //MARK: POST
    case signup(parameters: Parameters)
    case login(parameters: Parameters)
    case addConnection(parameters: Parameters)
    case uploadImage
    
    //MARK: PUT
    case updateUser(parameters: Parameters)
    
    //MARK: DELETE
    case deleteConnection(historyId: String)
    
    var method: HTTPMethod {
        switch self {
        case .loadUser, .loadSpecificUser, .loadUserFromCard, .loadHistory, .loadSpecificUserShip:
            return .get
        case .signup, .login, .addConnection, .uploadImage:
            return .post
        case .updateUser:
            return .put
        case .deleteConnection:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .loadUser, .updateUser:
            return "/users/me"
        case .loadSpecificUser(let id):
            return "/users/profile/\(id)"
        case .loadUserFromCard(let id):
            return "/cards/public/\(id)"
        case .loadHistory:
            return "/ships"
        case .loadSpecificUserShip(let userId):
            return "/ships/users/\(userId)"
        case .signup:
            return "/signup"
        case .login:
            return "/login"
        case .addConnection:
            return "/ships"
        case .uploadImage:
            return "/upload/image"
        case .deleteConnection(let historyId):
            return "/ships/\(historyId)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try AppManager.shared.environment.apiUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        if let authHeader = AuthenticationManager.shared.authToken {
            urlRequest.setValue("Bearer \(authHeader)", forHTTPHeaderField: "Authorization");
        }
        
        switch self {
        case .signup(let parameters), .login(let parameters), .addConnection(let parameters), .updateUser(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        default: break
        }
        
        AppLogger.log("\(urlRequest.cURL)")
        
        return urlRequest
    }
}
