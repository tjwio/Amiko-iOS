//
//  BAUserHolder.swift
//  Bump
//
//  Created by Tim Wong on 4/14/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import Foundation
import MapKit
import SocketIO

class BAUserHolder: NSObject {
    private static let BUMP_RECEIVED_EVENT = "bump_received"
    private static let BUMP_MATCHED_EVENT = "bump_matched"
    
    private(set) static var shared: BAUserHolder!
    private(set) var user: BAUser
    
    let socket: SocketManager
    
    init(user: BAUser) {
        self.user = user
        self.socket = SocketManager(socketURL: URL(string: BAAppManager.shared.environment.streamUrl)!, config: ["connectParams" : ["userId" : user.userId]])
        super.init()
        
        self.addSocketEvents()
        self.socket.defaultSocket.connect()
    }
    
    class func initialize(user: BAUser) -> BAUserHolder {
        shared = BAUserHolder(user: user)
        
        return shared
    }
    
    //MARK: LOAD
    class func loadUser(userId: String, success: BAUserHandler?, failure: BAErrorHandler?) {
        BANetworkHandler.shared.loadUser(userId, success: { response in
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
        self.socket.defaultSocket.on(BAUserHolder.BUMP_MATCHED_EVENT) { (data, ack) in
            
        }
    }
    
    func sendBumpReceivedEvent(bump: BABumpEvent, location: CLLocation) {
        let params: [String : Any] = [
            BAConstants.GeoMessage.USER_ID : user.userId,
            BAConstants.GeoMessage.TIMESTAMP : bump.date.timeIntervalSince1970 * 1000.0,
            BAConstants.GeoMessage.LATITUDE : location.coordinate.latitude,
            BAConstants.GeoMessage.LONGITUDE : location.coordinate.longitude
        ]
        
        self.socket.defaultSocket.emit(BAUserHolder.BUMP_RECEIVED_EVENT, with: [params])
    }
}
