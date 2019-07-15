//
//  BumpViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/14/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

#if canImport(CoreNFC)
import CoreNFC
#endif

protocol BumpViewControllerDelegate: class {
    func bumpControllerDidDismissScanner(_ viewController: BumpViewController)
}

class BumpViewController: UIViewController {
    
    weak var delegate: BumpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Matcha.dusk
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showNFCScanner()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: nfc
    
    private func showNFCScanner() {
        #if canImport(CoreNFC)
        guard NFCNDEFReaderSession.readingAvailable else { return }
        
        let nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession.alertMessage = "Please scan an Amiko Card"
        nfcSession.begin()
        #endif
    }
}
