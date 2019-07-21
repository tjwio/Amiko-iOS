//
//  BACameraViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/21/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import AVFoundation

class BACameraViewController: UIViewController {
    
    let borderView = UIImageView(image: UIImage(named: "scanner_box"))
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom);
        button.setTitle("Cancel", for: .normal);
        button.setTitleColor(.white, for: .normal);
        button.titleLabel?.font = UIFont.avenirRegular(size: 17.0);
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        return button;
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Contact"
        label.textColor = .white
        label.font = UIFont.avenirDemi(size: 26.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan the profile image of the contact\nyou want to add."
        label.textColor = .white
        label.font = UIFont.avenirDemi(size: 18.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label;
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let captureSession: AVCaptureSession? = {
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice);
                
                let session = AVCaptureSession();
                session.addInput(input);
                
                return session;
            }
            catch {
                print(error);
                return nil;
            }
        }
        else {
            return nil
        }
    }()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let captureSession = self.captureSession {
            self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer?.videoGravity = .resizeAspectFill
            self.previewLayer?.frame = self.view.layer.bounds
            if let preview = self.previewLayer {
                self.view.layer.addSublayer(preview)
            }
            
            self.captureSession?.startRunning()
        }
        else {
            self.view.backgroundColor = .black
        }
        
        self.cancelButton.addTarget(self, action: #selector(self.dismissViewController(_:)), for: .touchUpInside)
        
        self.borderView.alpha = 0.60
        self.borderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.borderView)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.borderView)
        
        self.setupConstraints();
    }
    
    private func setupConstraints() {
        let backgroundTopConstraint = NSLayoutConstraint(item: self.backgroundView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let backgroundLeadingConstraint = NSLayoutConstraint(item: self.backgroundView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let backgroundTrailingConstraint = NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: self.backgroundView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let backgroundBottomConstraint = NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: self.backgroundView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let headerTopConstraint = NSLayoutConstraint(item: self.headerLabel, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide.topAnchor, attribute: .bottom, multiplier: 1.0, constant: 13.0)
        let headerCenterXConstraint = NSLayoutConstraint(item: self.headerLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let cancelLeadingConstraint = NSLayoutConstraint(item: self.cancelButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 16.0)
        let cancelCenterYConstraint = NSLayoutConstraint(item: self.cancelButton, attribute: .centerY, relatedBy: .equal, toItem: self.headerLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        let messageTopConstraint = NSLayoutConstraint(item: self.messageLabel, attribute: .top, relatedBy: .equal, toItem: self.headerLabel, attribute: .bottom, multiplier: 1.0, constant: 24.0)
        let messageCenterXConstraint = NSLayoutConstraint(item: self.messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let borderCenterXConstraint = NSLayoutConstraint(item: self.borderView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let borderCenterYConstraint = NSLayoutConstraint(item: self.borderView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([backgroundTopConstraint, backgroundLeadingConstraint, backgroundTrailingConstraint, backgroundBottomConstraint, headerTopConstraint, headerCenterXConstraint, cancelLeadingConstraint, cancelCenterYConstraint, messageTopConstraint, messageCenterXConstraint, borderCenterXConstraint, borderCenterYConstraint]);
    }
    
    //MARK: cancel
    
    @objc func dismissViewController(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
}
