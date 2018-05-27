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
        
        let channel = socket.channel(BAConstants.Server.channel)
        
        channel.on(BAConstants.Events.matched) { [weak self] payload in
            if let user = BAUser(json: payload) {
                if let bumpCallback = self?.bumpMatchCallback {
                    bumpCallback(user)
                }
            }
        }
        
        socket.connect()
        _ = channel.join()
            .receive("ok", handler: { _ in
                print("channel connected")
            })
            .receive("error", handler: { error in
                print("channel error: \(error)")
            })
            .receive("timeout", handler: { error in
                print("channel timeout: \(error)")
            })
    }
    
    func sendBumpReceivedEvent(bump: BABumpEvent, location: CLLocation) {
        let params: [String : Any] = [
            BAConstants.GeoMessage.USER_ID : user.userId,
            BAConstants.GeoMessage.TIMESTAMP : bump.date.timeIntervalSince1970 * 1000.0,
            BAConstants.GeoMessage.LATITUDE : location.coordinate.latitude,
            BAConstants.GeoMessage.LONGITUDE : location.coordinate.longitude
        ]
        
        print("bumping with params: \(params)")
        
        _ = socket.channel(BAConstants.Server.channel).push("bumped", payload: params)
    }
}
