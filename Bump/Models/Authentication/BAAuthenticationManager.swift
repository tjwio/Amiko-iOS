//
//  BAAuthenticationManager.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import KeychainSwift

class BAAuthenticationManager: NSObject {
    private static let PASSWORD_KEYCHAIN_KEY = "BA_USER_PASSWORD"
    private static let EMAIL_KEYCHAIN_KEY = "BA_USER_EMAIL"
    private static let USER_ID_KEYCHAIN_KEY = "BA_USER_ID"
    
    static let shared = BAAuthenticationManager()
    
    private let keychain = KeychainSwift()
    var userId: String?
    
    override init() {
        super.init()
        
        userId = getUserId()
    }
    
    //MARK: SIGNUP
    func signup(name: String, email: String, phone: String, password: String, success: BAUserHandler?, failure: BAErrorHandler?) {
        BANetworkHandler.shared.signup(name: name, email: email, phone: phone, password: password, success: { response in
            if let user = BAUser(json: response) {
                self.save(userId: user.userId, email: email, password: password)
                
                success?(user)
            }
            else {
                failure?(BAError.invalidJson)
            }
        }, failure: failure)
    }
    
    //MARK: LOGIN
    func login(email: String, password: String, success: BAUserHandler?, failure: BAErrorHandler?) {
        BANetworkHandler.shared.login(email: email, password: password, success: { response in
            if let user = BAUser(json: response) {
                self.save(userId: user.userId, email: email, password: password)
                
                success?(user)
            }
            else {
                failure?(BAError.invalidJson)
            }
        }, failure: failure)
    }
    
    //MARK: ACCESSORS
    private func getUserId() -> String? {
        return keychain.get(BAAuthenticationManager.USER_ID_KEYCHAIN_KEY)
    }
    
    private func getEmail() -> String? {
        return keychain.get(BAAuthenticationManager.EMAIL_KEYCHAIN_KEY)
    }
    
    private func getPassword() -> String? {
        return keychain.get(BAAuthenticationManager.PASSWORD_KEYCHAIN_KEY)
    }
    
    //MARK: SAVE
    func save(userId: String, email: String, password: String) {
        keychain.set(userId, forKey: BAAuthenticationManager.USER_ID_KEYCHAIN_KEY)
        keychain.set(userId, forKey: BAAuthenticationManager.EMAIL_KEYCHAIN_KEY)
        keychain.set(userId, forKey: BAAuthenticationManager.PASSWORD_KEYCHAIN_KEY)
    }
}