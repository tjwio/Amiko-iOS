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
    case loadUser
    case loadHistory
    
    //MARK: PUT
    
    //MARK: POST
    case signup(parameters: Parameters)
    case login(parameters: Parameters)
    case addConnection(parameters: Parameters)
    
    //MARK: DELETE
    case deleteConnection(historyId: String)
    
    var method: HTTPMethod {
        switch self {
        case .loadUser, .loadHistory:
            return .get
        case .signup, .login, .addConnection:
            return .post
        case .deleteConnection:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .loadUser:
            return "/users/me"
        case .loadHistory:
            return "/users/connections"
        case .signup:
            return "/signup"
        case .login:
            return "/login"
        case .addConnection:
            return "/users/connections"
        case .deleteConnection(let historyId):
            return "/users/connections/\(historyId)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try BAAppManager.shared.environment.apiUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        if let authHeader = BAAuthenticationManager.shared.authToken {
            urlRequest.setValue("Bearer \(authHeader)", forHTTPHeaderField: "Authorization");
        }
        
        switch self {
        case .signup(let parameters), .login(let parameters), .addConnection(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        default: break
        }
        
        print("\(urlRequest.cURL)")
        
        return urlRequest
    }
}
