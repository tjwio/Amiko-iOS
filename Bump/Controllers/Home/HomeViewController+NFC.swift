//
//  HomeViewController+NFC.swift
//  Bump
//
//  Created by Tim Wong on 6/15/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import CoreNFC

extension BAHomeViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        self.showLeftMessage("Failed to scan NFC card, please try again", type: .error)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        messages.forEach { (nfcndefMessage) in
            nfcndefMessage.records.forEach({ (nfcndefPayload) in
                result += String.init(data: nfcndefPayload.payload.advanced(by: 3), encoding: .utf8)!
            })
        }
        
        guard result.contains("ciao.haus://"), let url = URL(string: result), UIApplication.shared.canOpenURL(url) else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            session.invalidate()
            UIApplication.shared.open(url)
        }
    }
    
    func openProfileController(id: String) {
        let viewController = LoadProfileViewController(userId: id)
        viewController.successCallback = { [weak self] message in
            DispatchQueue.main.async {
                self?.showLeftMessage(message, type: .success)
            }
        }
        
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        
        self.present(viewController, animated: false, completion: nil)
    }
}
