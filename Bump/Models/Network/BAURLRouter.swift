//
//  BAURLRouters.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Alamofire

enum BAURLRouter: URLRequestConvertible {
    //MARK: GET
    case loadUser(userId: String)
    
    //MARK: PUT
    
    //MARK: POST
    case signup(parameters: Parameters)
    case login(parameters: Parameters)
    
    //MARK: DELETE
    
    var method: HTTPMethod {
        switch self {
        case .loadUser:
            return .get
        case .signup, .login:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .loadUser(let userId):
            return "/users/\(userId)"
        case .signup:
            return "/signup"
        case .login:
            return "/login"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try BAAppManager.shared.environment.apiUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .signup(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        case .login(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        default: break
        }
        
        return urlRequest
    }
}
