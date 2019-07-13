//
//  HomeViewController+NFC.swift
//  Bump
//
//  Created by Tim Wong on 6/15/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
#if canImport(CoreNFC)
import CoreNFC

extension BAHomeViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        self.showLeftMessage("Failed to scan NFC card, please try again", type: .error)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var result = ""
        messages.forEach { (nfcndefMessage) in
            nfcndefMessage.records.forEach({ (nfcndefPayload) in
                result += (String(data: nfcndefPayload.payload, encoding: .utf8) ?? "").replacingOccurrences(of: "\0", with: "")
            })
        }
        
        guard result.contains("ciaohaus://"), let url = URL(string: result) else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard UIApplication.shared.canOpenURL(url) else { return }
            
            session.invalidate()
            UIApplication.shared.open(url)
        }
    }
    
    func openProfileController(id: String) {
//        let viewController = LoadProfileViewController(id: id)
//        viewController.successCallback = { [weak self] message in
//            DispatchQueue.main.async {
//                self?.showLeftMessage(message, type: .success)
//            }
//        }
//        
//        viewController.providesPresentationContextTransitionStyle = true
//        viewController.definesPresentationContext = true
//        viewController.modalPresentationStyle = .overCurrentContext
//        
//        self.present(viewController, animated: false, completion: nil)
    }
}

#endif
