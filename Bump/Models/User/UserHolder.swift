//
//  BAUserHolder.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import MapKit
import SwiftPhoenixClient

class UserHolder: NSObject {
    private static let BUMP_RECEIVED_EVENT = "bump_received"
    private static let BUMP_MATCHED_EVENT = "bump_matched"
    private static let BUMP_TEST_EVENT = "bump_test"
    
    static var initialized = false
    
    private(set) static var shared: UserHolder!
    private(set) var user: User
    
    let socket: Socket
    var lobby: Channel!
    
    var bumpMatchCallback: BAUserHandler?
    
    init(user: User) {
        self.user = user
        socket = Socket(AppManager.shared.environment.streamUrl, params: ["token" : AuthenticationManager.shared.authToken ?? ""])
        super.init()
        
        self.addSocketEvents()
    }
    
    class func initialize(user: User) -> UserHolder {
        shared = UserHolder(user: user)
        
        initialized = true
        
        return shared
    }
    
    class func logOut() {
        shared = nil
        initialized = false
    }
    
    //MARK: load
    class func loadUser(userId: String, success: BAUserHandler?, failure: BAErrorHandler?) {
        NetworkHandler.shared.loadUser(success: { response in
            if let user = User(json: response) {
                user.loadHistory(success: { _ in
                    success?(user)
                }, failure: { _ in
                    success?(user)
                })
            }
            else {
                failure?(BAError.invalidJson)
            }
        }, failure: failure)
    }
    
    class func loadSpecificUser(id: String, success: BAUserHandler?, failure: BAErrorHandler?) {
        NetworkHandler.shared.loadSpecificUser(id: id, success: { response in
            if let user = User(json: response) {
                user.loadHistory(success: { _ in
                    success?(user)
                }, failure: { _ in
                    success?(user)
                })
            }
            else {
                failure?(BAError.invalidJson)
            }
        }, failure: failure)
    }
    
    //MARK: bump events
    
    private func addSocketEvents() {
        socket.onOpen { print("socket connected") }
        socket.onClose { print("socket disconnected") }
        socket.onError { error in print("socket error: \(error)") }
        
        lobby = socket.channel(AppConstants.Channel.lobby)
        let privateRoom = socket.channel("\(AppConstants.Channel.privateRoom):\(user.id)")
        
        socket.onMessage { payload in
            print("socket message: \(payload)")
        }
        
        privateRoom.on(AppConstants.Events.matched) { [weak self] message in
            if let user = User(json: message.payload) {
                if let bumpCallback = self?.bumpMatchCallback {
                    bumpCallback(user)
                }
            }
        }
        
        socket.connect()
        _ = lobby.join()
            .receive("ok", callback: { _ in
                print("lobby connected")
            })
            .receive("error", callback: { error in
                print("lobby error: \(error)")
            })
            .receive("timeout", callback: { error in
                print("lobby timeout: \(error)")
            })
        _ = privateRoom.join()
            .receive("ok", callback: { _ in
                print("private room connected")
            })
            .receive("error", callback: { error in
                print("private room error: \(error)")
            })
            .receive("timeout", callback: { error in
                print("private room timeout: \(error)")
            })
    }
    
    private func addPrivateRoom() {
        
    }
    
    func sendBumpReceivedEvent(bump: BumpEvent, location: CLLocation) {
        let params: [String : Any] = [
            AppConstants.GeoMessage.timestamp : bump.date.timeIntervalSince1970 * 1000.0,
            AppConstants.GeoMessage.latitude : location.coordinate.latitude,
            AppConstants.GeoMessage.longitude : location.coordinate.longitude,
            AppConstants.GeoMessage.accuracy : location.horizontalAccuracy
        ]
        
        print("bumping with params: \(params)")
        
        _ = lobby.push(AppConstants.Events.bumped, payload: params)
    }
    
    //MARK: reconnect
    
    func reconnect() {
        socket.disconnect()
        addSocketEvents()
    }
}
