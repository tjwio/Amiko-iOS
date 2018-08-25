//
//  BAAddUserViewController.swift
//  Bump
//
//  Created by Tim Wong on 4/16/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import Contacts
import SnapKit

class BAAddUserViewController: UIViewController {
    
    let userToAdd: BAUser
    let store = CNContactStore()
    
    let userView: BAAddUserView
    private let dummyShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    var successCallback: BAEmptyHandler?
    var failureCallback: BAErrorHandler?
    
    init(userToAdd: BAUser) {
        self.userToAdd = userToAdd
        self.userView = BAAddUserView(mainItems: [
            (.phone, userToAdd.phone),
            (.email, userToAdd.email)
            ], socialItems: userToAdd.socialAccounts)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        userView.nameLabel.text = userToAdd.fullName
        if let profession = userToAdd.profession {
            userView.jobLabel.text = profession
        }
        if let imageUrl = userToAdd.imageUrl {
            userView.avatarImageView.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar, options: .retryFailed, completed: { (image, error, cache, url) in
                self.userToAdd.image.value = image
            })
        }
        userView.doneButton.addTarget(self, action: #selector(self.done(_:)), for: .touchUpInside)
        userView.cancelButton.addTarget(self, action: #selector(self.cancel(_:)), for: .touchUpInside)
        userView.isHidden = false
        userView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        userView.layer.cornerRadius = 8.0
        userView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dummyShadowView)
        dummyShadowView.addSubview(userView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor(hexColor: 0xA7ADB6, alpha: 0.60);
            
            self.userView.transform = .identity
            self.dummyShadowView.layer.applySketchShadow(color: UIColor(hexColor: 0x3D3F42), alpha: 0.40, x: 0.0, y: 1.0, blur: 12.0, spread: 0.0)
        }, completion: nil);
    }
    
    private func setupConstraints() {
        dummyShadowView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(100.0)
            make.leading.equalTo(self.view).offset(22.0)
            make.trailing.equalTo(self.view).offset(-22.0)
            make.bottom.equalTo(self.view).offset(-60.0)
        }
        
        userView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: cancel
    
    @objc private func cancel(_ sender: UIButton?) {
        dismissViewController()
    }
    
    //MARK: done
    
    @objc private func done(_ sender: UIButton?) {
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            do { try self.addNewContact() }
            catch {
                print("failed to save contact")
            }
        }
        else {
            store.requestAccess(for: .contacts) { (granted, error) in
                if granted && error == nil {
                    do { try self.addNewContact() }
                    catch {
                        print("failed to save contact")
                    }
                }
                else if let error = error {
                    print("failed to get contact access with error: \(error)")
                }
            }
        }
    }
    
    //MARK: add new contact
    private func addNewContact() throws {
        try addContactToStore()
        
        if let coordinate = BALocationManager.shared.currentLocation?.coordinate {
            BAUserHolder.shared.user.addConnection(addedUserId: userToAdd.userId, latitude: coordinate.latitude, longitude: coordinate.longitude, success: { _ in
                self.successCallback?()
                self.dismissViewController()
            }) { error in
                self.failureCallback?(error)
                self.dismissViewController()
            }
        }
    }
    
    private func addContactToStore() throws {
        let contactToAdd = CNMutableContact()
        contactToAdd.givenName = userToAdd.firstName
        contactToAdd.familyName = userToAdd.lastName
        contactToAdd.phoneNumbers = [CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: userToAdd.phone))]
        contactToAdd.emailAddresses = [CNLabeledValue<NSString>(label: CNLabelHome, value: userToAdd.email as NSString)]
        if let profession = userToAdd.profession {
            contactToAdd.organizationName = profession
        }
        if let image = self.userToAdd.image.value, let data = UIImageJPEGRepresentation(image, 0.5) {
            contactToAdd.imageData = data
        }
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
        
        try store.execute(saveRequest)
    }
    
    //MARK: dismiss
    
    private func dismissViewController() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = .clear
            self.userView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        }) { completed in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
