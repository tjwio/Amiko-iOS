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

class BAUserHolder: NSObject {
    private static let BUMP_RECEIVED_EVENT = "bump_received"
    private static let BUMP_MATCHED_EVENT = "bump_matched"
    private static let BUMP_TEST_EVENT = "bump_test"
    
    private(set) static var shared: BAUserHolder!
    private(set) var user: BAUser
    
    let socket: Socket
    
    var bumpMatchCallback: BAUserHandler?
    
    init(user: BAUser) {
        self.user = user
        socket = Socket(url: BAAppManager.shared.environment.streamUrl, params: ["token" : BAAuthenticationManager.shared.authToken ?? ""])
        super.init()
        
        self.addSocketEvents()
    }
    
    class func initialize(user: BAUser) -> BAUserHolder {
        shared = BAUserHolder(user: user)
        
        return shared
    }
    
    //MARK: LOAD
    class func loadUser(userId: String, success: BAUserHandler?, failure: BAErrorHandler?) {
        BANetworkHandler.shared.loadUser(success: { response in
            if let user = BAUser(json: response) {
                success?(user)
            }
            else {
                failure?(BAError.invalidJson)
            }
        }, failure: failure)
    }
    
    //MARK: bump events
    
    private func addSocketEvents() {
        socket.onOpen = { print("socket connected") }
        socket.onClose = { print("socket disconnected") }
        socket.onError = { error in print("socket error: \(error)") }
        
        let lobby = socket.channel(BAConstants.Channel.lobby)
        let privateRoom = socket.channel("\(BAConstants.Channel.privateRoom):\(user.userId)")
        
        socket.onMessage = { payload in
            print("socket message: \(payload)")
        }
        
        privateRoom.on(BAConstants.Events.matched) { [weak self] payload in
            if let user = BAUser(json: payload) {
                if let bumpCallback = self?.bumpMatchCallback {
                    bumpCallback(user)
                }
            }
        }
        
        socket.connect()
        _ = lobby.join()
            .receive("ok", handler: { _ in
                print("lobby connected")
            })
            .receive("error", handler: { error in
                print("lobby error: \(error)")
            })
            .receive("timeout", handler: { error in
                print("lobby timeout: \(error)")
            })
        _ = privateRoom.join()
            .receive("ok", handler: { _ in
                print("private room connected")
            })
            .receive("error", handler: { error in
                print("private room error: \(error)")
            })
            .receive("timeout", handler: { error in
                print("private room timeout: \(error)")
            })
    }
    
    private func addPrivateRoom() {
        
    }
    
    func sendBumpReceivedEvent(bump: BABumpEvent, location: CLLocation) {
        let params: [String : Any] = [
            BAConstants.GeoMessage.TIMESTAMP : bump.date.timeIntervalSince1970 * 1000.0,
            BAConstants.GeoMessage.LATITUDE : location.coordinate.latitude,
            BAConstants.GeoMessage.LONGITUDE : location.coordinate.longitude
        ]
        
        print("bumping with params: \(params)")
        
        _ = socket.channel(BAConstants.Channel.lobby).push(BAConstants.Events.test, payload: params)
    }
}
