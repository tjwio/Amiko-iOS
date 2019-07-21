//
//  BAAuthenticationManager.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import KeychainSwift

class AuthenticationManager: NSObject {
    private struct Constants {
        static let passwordKeychainKey = "BA_USER_PASSWORD"
        static let emailKeychainKey = "BA_USER_EMAIL"
        static let userIdKeychainKey = "BA_USER_ID"
        static let authTokenKeychainKey = "BA_AUTH_TOKEN"
    }
    
    static let shared = AuthenticationManager()
    
    private let keychain = KeychainSwift()
    var userId: String?
    var authToken: String?
    
    override init() {
        super.init()
        
        userId = getUserId()
        authToken = getAuthToken()
    }
    
    //MARK: SIGNUP
    func signup(firstName: String, lastName: String, email: String, phone: String, password: String, success: UserHandler?, failure: ErrorHandler?) {
        NetworkHandler.shared.signup(firstName: firstName, lastName: lastName, email: email, phone: phone, password: password, success: { response in
            if let userDict = response["user"] as? [String : Any], let authToken = response["token"] as? String, let user = userDict.decodeJson(User.self) {
                self.save(userId: user.id, email: email, password: password, authToken: authToken)
                
                success?(user)
            }
            else {
                failure?(BAError.invalidJson)
            }
        }, failure: failure)
    }
    
    //MARK: LOGIN
    func login(email: String, password: String, success: UserHandler?, failure: ErrorHandler?) {
        NetworkHandler.shared.login(email: email, password: password, success: { response in
            if let userDict = response["user"] as? [String : Any], let authToken = response["token"] as? String, let user = userDict.decodeJson(User.self) {
                self.save(userId: user.id, email: email, password: password, authToken: authToken)
                
                success?(user)
            }
            else {
                failure?(BAError.invalidJson)
            }
        }, failure: failure)
    }
    
    //MARK: ACCESSORS
    private func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: Constants.userIdKeychainKey)
    }
    
    private func getEmail() -> String? {
        return keychain.get(Constants.emailKeychainKey)
    }
    
    private func getPassword() -> String? {
        return keychain.get(Constants.passwordKeychainKey)
    }
    
    private func getAuthToken() -> String? {
        return keychain.get(Constants.authTokenKeychainKey)
    }
    
    //MARK: SAVE
    func save(userId: String, email: String, password: String, authToken: String) {
        self.userId = userId
        self.authToken = authToken
        
        UserDefaults.standard.set(userId, forKey: Constants.userIdKeychainKey)
        keychain.set(email, forKey: Constants.emailKeychainKey)
        keychain.set(password, forKey: Constants.passwordKeychainKey)
        keychain.set(authToken, forKey: Constants.authTokenKeychainKey)
    }
    
    //MARK: LOG OUT
    func logOut() {
        userId = nil
        UserDefaults.standard.set(nil, forKey: Constants.userIdKeychainKey)
        keychain.delete(Constants.emailKeychainKey)
        keychain.delete(Constants.passwordKeychainKey)
        keychain.delete(Constants.authTokenKeychainKey)
    }
}
