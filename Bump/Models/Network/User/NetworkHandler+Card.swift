//
//  NetworkHandler+Cards.swift
//  Bump
//
//  Created by Tim Wong on 7/27/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import Alamofire

extension NetworkHandler {
    public func loadCards(success: CardListHandler?, failure: ErrorHandler?) {
        sessionManager.request(URLRouter.loadCards).validate().responseDecodable { (response: DataResponse<[Card]>) in
            switch response.result {
            case .success(let cards): success?(cards)
            case .failure(let error): failure?(error)
            }
        }
    }
}
