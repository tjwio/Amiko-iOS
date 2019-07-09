//
//  BAProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import AVKit
import Photos
import ReactiveCocoa
import ReactiveSwift

class BAProfileBaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    struct Constants {
        static let cellIdentifier = "BAProfileDetailValueTableViewCellIdentifier"
        static let headers = [2, 4, 7]
        static let maxLabelIndex = 6
        
        static let firstNameIndex = 0
        static let lastNameIndex = 1
        static let jobIndex = 2
        static let companyIndex = 3
        static let phoneIndex = 4
        static let emailIndex = 5
        static let websiteIndex = 6
        
        static let facebookIndex = 7
        static let linkedinIndex = 8
        static let instagramIndex = 9
        static let twitterIndex = 10
    }
    
    var successCallback: BAEmptyHandler?
    
    let user: User
    
    let image = MutableProperty<UIImage?>(nil)
    let firstName = MutableProperty<String?>(nil)
    let lastName = MutableProperty<String?>(nil)
    let jobTitle = MutableProperty<String?>(nil)
    let company = MutableProperty<String?>(nil)
    let phone = MutableProperty<String?>(nil)
    let email = MutableProperty<String?>(nil)
    let website = MutableProperty<String?>(nil)
    
    let facebook = MutableProperty<String?>(nil)
    let linkedin = MutableProperty<String?>(nil)
    let instagram = MutableProperty<String?>(nil)
    let twitter = MutableProperty<String?>(nil)
    
    let imageDidUpdate = MutableProperty<Bool>(false)
    
    var originalProfileFrame: CGRect?
    
    let profileView: BAProfileView = {
        let view = BAProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var origContentInset: UIEdgeInsets?
    
    private var disposables = CompositeDisposable()
    
    init(user: User) {
        self.user = user
        
        firstName.value = user.firstName
        lastName.value = user.lastName
        jobTitle.value = user.profession
        company.value = user.company
        website.value = user.website
        phone.value = user.phone
        email.value = user.email
        
        facebook.value = user.facebook
        linkedin.value = user.linkedin
        instagram.value = user.instagram
        twitter.value = user.twitter
        
        super.init(nibName: nil, bundle: nil)
        
        user.loadImage(success: { (image, _) in
            self.image.value = image
        }, failure: {_ in
            self.image.value = .blankAvatar
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposables.dispose()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        disposables += (profileView.avatarImageView.imageView.reactive.image <~ self.image)
        profileView.saveButton.addTarget(self, action: #selector(self.saveProfileView(_:)), for: .touchUpInside)
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        profileView.layer.cornerRadius = 20.0
        profileView.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.avatarPressed(_:)))
        profileView.avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: dismiss
    
    func dismissViewController() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: save
    
    @objc private func saveProfileView(_ sender: BALoadingButton?) {
        user.updateUser(firstName: firstName.value ?? "", lastName: lastName.value ?? "", profession: jobTitle.value ?? "", company: company.value ?? "", phone: phone.value ?? "", email: email.value ?? "", website: website.value ?? "", facebook: facebook.value ?? "", linkedin: linkedin.value ?? "", instagram: instagram.value ?? "", twitter: twitter.value ?? "", success: {
            if self.imageDidUpdate.value, let newImage = self.image.value {
                self.user.updateImage(newImage, success: {
                    self.dismissViewController()
                    self.successCallback?()
                }, failure: { error in
                    self.showLeftMessage("Failed to update user image, please try again.", type: .error)
                })
            }
            else {
                self.dismissViewController()
                self.successCallback?()
            }
            
            NotificationCenter.default.post(name: .bumpDidUpdateUser, object: nil)
        }) { _ in
            self.showLeftMessage("Failed to update info", type: .error, view: self.profileView)
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? BAProfileDetailValueTableViewCell ?? BAProfileDetailValueTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        let attributes: [NSAttributedString.Key : Any] = [ .foregroundColor :  UIColor.Grayscale.placeholderColor]
        
        if indexPath.section <= Constants.maxLabelIndex {
            cell.detailLabel.isHidden = false
            cell.accountHolderView.isHidden = true
            cell.iconLabel.isHidden = true
            cell.textField.isEnabled = true
            cell.textField.autocapitalizationType = .words
            cell.textField.autocorrectionType = .default
            
            switch indexPath.section {
            case Constants.firstNameIndex:
                cell.detailLabel.text = "First Name"
                cell.textField.attributedPlaceholder = NSAttributedString(string: "Muhammad", attributes: attributes)
                cell.textField.text = self.firstName.value
                disposables += (self.firstName <~ cell.textField.reactive.continuousTextValues)
            case Constants.lastNameIndex:
                cell.detailLabel.text = "Last Name"
                cell.textField.attributedPlaceholder = NSAttributedString(string: "Nakamura", attributes: attributes)
                cell.textField.text = self.lastName.value
                disposables += (self.lastName <~ cell.textField.reactive.continuousTextValues)
            case Constants.jobIndex:
                cell.detailLabel.text = "Job Title"
                cell.textField.attributedPlaceholder = NSAttributedString(string: "Product Designer", attributes: attributes)
                cell.textField.text = self.jobTitle.value
                disposables += (self.jobTitle <~ cell.textField.reactive.continuousTextValues)
            case Constants.companyIndex:
                cell.detailLabel.text = "Company"
                cell.textField.attributedPlaceholder = NSAttributedString(string: "Ciao", attributes: attributes)
                cell.textField.text = self.company.value
                disposables += (self.company <~ cell.textField.reactive.continuousTextValues)
            case Constants.phoneIndex:
                cell.detailLabel.text = "Phone"
                cell.textField.attributedPlaceholder = NSAttributedString(string: "800.700.6000", attributes: attributes)
                cell.textField.text = self.phone.value
                disposables += (self.phone <~ cell.textField.reactive.continuousTextValues)
            case Constants.emailIndex:
                cell.detailLabel.text = "Email"
                cell.textField.attributedPlaceholder = NSAttributedString(string: "muhammad.nakmura@ciao.haus", attributes: attributes)
                cell.textField.text = self.email.value
                disposables += (self.email <~ cell.textField.reactive.continuousTextValues)
            case Constants.websiteIndex:
                cell.detailLabel.text = "Website"
                cell.textField.attributedPlaceholder = NSAttributedString(string: "https://ciao.haus", attributes: attributes)
                cell.textField.text = self.website.value
                disposables += (self.website <~ cell.textField.reactive.continuousTextValues)
            default: break
            }
            
            if indexPath.section == Constants.phoneIndex {
                cell.textField.autocapitalizationType = .none
                cell.textField.autocorrectionType = .no
                cell.textField.keyboardType = .phonePad
            }
            else if indexPath.section == Constants.emailIndex {
                cell.textField.autocapitalizationType = .none
                cell.textField.autocorrectionType = .no
                cell.textField.keyboardType = .emailAddress
            }
            else if indexPath.section == Constants.websiteIndex {
                cell.textField.autocapitalizationType = .none
                cell.textField.autocorrectionType = .no
                cell.textField.keyboardType = .URL
            }
            else {
                cell.textField.keyboardType = .default
            }
        }
        else {
            let exampleHandle = "muhammad.nakmura"
            
            cell.detailLabel.isHidden = true
            cell.accountHolderView.isHidden = false
            cell.iconLabel.isHidden = false
            cell.textField.isEnabled = true
            
            switch indexPath.section {
            case Constants.facebookIndex:
                let contact = AccountContact.facebook
                
                cell.iconLabel.text = contact.icon
                cell.textField.attributedPlaceholder = NSAttributedString(string: "/\(exampleHandle)", attributes: attributes)
                cell.textField.text = facebook.value
                cell.textIconColor = contact.color
                
                disposables += facebook <~ cell.textField.reactive.continuousTextValues
            case Constants.linkedinIndex:
                let contact = AccountContact.linkedin
                
                cell.iconLabel.text = contact.icon
                cell.textField.attributedPlaceholder = NSAttributedString(string: "/\(exampleHandle)", attributes: attributes)
                cell.textField.text = linkedin.value
                cell.textIconColor = contact.color
                
                disposables += linkedin <~ cell.textField.reactive.continuousTextValues
            case Constants.instagramIndex:
                let contact = AccountContact.instagram
                
                cell.iconLabel.text = contact.icon
                cell.textField.attributedPlaceholder = NSAttributedString(string: "@\(exampleHandle)", attributes: attributes)
                cell.textField.text = instagram.value
                cell.textIconColor = contact.color
                
                disposables += instagram <~ cell.textField.reactive.continuousTextValues
            case Constants.twitterIndex:
                let contact = AccountContact.twitter
                
                cell.iconLabel.text = contact.icon
                cell.textField.attributedPlaceholder = NSAttributedString(string: "@\(exampleHandle)", attributes: attributes)
                cell.textField.text = twitter.value
                cell.textIconColor = contact.color
                
                disposables += twitter <~ cell.textField.reactive.continuousTextValues
            default: break
            }
        }
        
        return cell
    }
    
    //MARK: photo/camera delegate
    
    @objc private func avatarPressed(_ sender: UIGestureRecognizer?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            if authStatus == .authorized {
                self.showCameraController()
            }
            else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    if granted {
                        self.showCameraController()
                    }
                })
            }
        }
        let choosePhoto = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            let authStatus = PHPhotoLibrary.authorizationStatus()
            
            if authStatus == .authorized {
                self.showImageController()
            }
            else {
                PHPhotoLibrary.requestAuthorization { newStatus in
                    if newStatus == .authorized {
                        self.showImageController()
                    }
                    else {
                        self.showLeftMessage("Failed to gain access to photo library", type: .error)
                    }
                }
            }
        }
        
        alertController.addAction(cancel)
        alertController.addAction(choosePhoto)
        alertController.addAction(takePhoto)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            self.image.value = image
            imageDidUpdate.value = true
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    private func showCameraController() {
        let cameraController = UIImagePickerController()
        cameraController.allowsEditing = true
        cameraController.delegate = self
        cameraController.sourceType = .camera
        
        present(cameraController, animated: true, completion: nil)
    }
    
    private func showImageController() {
        let cameraController = UIImagePickerController()
        cameraController.allowsEditing = true
        cameraController.delegate = self
        cameraController.sourceType = .photoLibrary
        
        present(cameraController, animated: true, completion: nil)
    }
    
    // MARK: Keyboard Notifications
    
    @objc private func keyboardWillShow(notification: NSNotification?) {
        if self.isViewLoaded && self.view.window != nil {
            if let keyboardSize = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                var contentInsets: UIEdgeInsets
                
                if UIApplication.shared.statusBarOrientation.isPortrait {
                    contentInsets = UIEdgeInsets(top: profileView.tableView.contentInset.top, left: 0.0, bottom: keyboardSize.height, right: 0.0)
                } else {
                    contentInsets = UIEdgeInsets(top: profileView.tableView.contentInset.top, left: 0.0, bottom: keyboardSize.width, right: 0.0)
                }
                
                self.origContentInset = profileView.tableView.contentInset
                
                UIView.animate(withDuration: (notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
                    self.profileView.tableView.contentInset = contentInsets
                    self.profileView.tableView.scrollIndicatorInsets = contentInsets
                    self.profileView.tableView.setNeedsDisplay()
                }, completion: nil)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification?) {
        if self.isViewLoaded && self.view.window != nil {
            UIView.animate(withDuration: (notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3, animations: {
                if let contentInset = self.origContentInset {
                    self.profileView.tableView.contentInset = contentInset
                    self.profileView.tableView.scrollIndicatorInsets = contentInset
                }
            })
        }
    }
}