//
//  BAProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import AVKit
import MMSCameraViewController
import MMSProfileImagePicker
import Photos
import ReactiveCocoa
import ReactiveSwift

class BAProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MMSProfileImagePickerDelegate {
    
    private struct Constants {
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
    
    let user: BAUser
    
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
    
    let profilePicker = MMSProfileImagePicker()
    
    let profileView: BAProfileView = {
        let view = BAProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let logOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(UIColor.Red.normal, for: .normal)
        button.setTitleColor(UIColor.Red.darker, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 15.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let dummyHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dummyShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private var disposables = CompositeDisposable()
    
    init(user: BAUser) {
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
        }, failure: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposables.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        profilePicker.delegate = self
        
        logOutButton.addTarget(self, action: #selector(self.logOut(_:)), for: .touchUpInside)
        
        disposables += (profileView.avatarImageView.imageView.reactive.image <~ self.image)
        profileView.cancelButton.addTarget(self, action: #selector(self.cancelProfileView(_:)), for: .touchUpInside)
        profileView.saveButton.addTarget(self, action: #selector(self.saveProfileView(_:)), for: .touchUpInside)
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        profileView.tableView.tableFooterView = getTableFooterView()
        profileView.isHidden = false
        profileView.transform = CGAffineTransform(translationX: 0.0, y: view.frame.size.height)
        profileView.layer.cornerRadius = 20.0
        profileView.clipsToBounds = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized(_:)))
        panGestureRecognizer.delegate = self
        dummyHeaderView.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.avatarPressed(_:)))
        profileView.avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        profileView.insertSubview(dummyHeaderView, at: 0)
        view.addSubview(dummyShadowView)
        dummyShadowView.addSubview(profileView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor(hexColor: 0xA7ADB6, alpha: 0.60);
            
            self.profileView.transform = .identity
            self.dummyShadowView.layer.applySketchShadow(color: UIColor(hexColor: 0x3D3F42), alpha: 0.40, x: 0.0, y: 1.0, blur: 12.0, spread: 0.0)
        }, completion: nil)
    }
    
    private func setupConstraints() {
        dummyShadowView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(40.0)
            make.leading.equalTo(self.view).offset(12.0)
            make.trailing.equalTo(self.view).offset(-12.0)
            make.bottom.equalTo(self.view).offset(6.0)
        }
        
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dummyHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(profileView.tableView.snp.top)
        }
    }
    
    private func dismissViewController() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = .clear
            self.profileView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        }) { completed in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK: cancel
    
    @objc private func cancelProfileView(_ sender: UIButton?) {
        dismissViewController()
    }
    
    //MARK: save
    
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
    
    //MARK: log out
    
    @objc private func logOut(_ sender: UIButton?) {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logOut = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            DispatchQueue.main.async {
                BAAppManager.shared.logOut()
            }
        }
        
        alertController.addAction(cancel)
        alertController.addAction(logOut)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: pan gesture recognizer
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if originalProfileFrame == nil { originalProfileFrame = profileView.frame }
        }
        else if sender.state == .changed {
            guard let minFrame = originalProfileFrame else { return }
            
            let translatedPoint = sender.translation(in: profileView)
            let newY = profileView.frame.origin.y + translatedPoint.y
            profileView.frame.origin.y = max(newY, minFrame.minY)
            
            sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: profileView)
        }
        else if sender.state == .ended {
            let velocity = sender.velocity(in: profileView)
            
            if velocity.y > 500 || profileView.frame.minY > view.frame.midY {
                dismissViewController()
            }
            else {
                UIView.animate(withDuration: 0.25) {
                    self.profileView.frame.origin.y = self.originalProfileFrame?.minY ?? 20.0
                }
            }
        }
    }
    
    //MARK: table view
    
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
            cell.textField.isEnabled = false
            
            switch indexPath.section {
            case Constants.facebookIndex:
                let contact = BAAccountContact.facebook
                
                cell.accountHolderView.backgroundColor = self.facebook.value?.isEmpty ?? true ? UIColor.Grayscale.placeholderColor : contact.color
                cell.iconLabel.text = contact.icon
                cell.textField.attributedPlaceholder = NSAttributedString(string: "/\(exampleHandle)", attributes: attributes)
                cell.textField.text = self.facebook.value
            case Constants.linkedinIndex:
                let contact = BAAccountContact.linkedin
                
                cell.accountHolderView.backgroundColor = self.linkedin.value?.isEmpty ?? true ? UIColor.Grayscale.placeholderColor : contact.color
                cell.iconLabel.text = contact.icon
                cell.textField.attributedPlaceholder = NSAttributedString(string: "/\(exampleHandle)", attributes: attributes)
                cell.textField.text = self.linkedin.value
            case Constants.instagramIndex:
                let contact = BAAccountContact.instagram
                
                cell.accountHolderView.backgroundColor = self.instagram.value?.isEmpty ?? true ? UIColor.Grayscale.placeholderColor : contact.color
                cell.iconLabel.text = contact.icon
                cell.textField.attributedPlaceholder = NSAttributedString(string: "@\(exampleHandle)", attributes: attributes)
                cell.textField.text = self.instagram.value
            case Constants.twitterIndex:
                let contact = BAAccountContact.twitter
                
                cell.accountHolderView.backgroundColor = self.twitter.value?.isEmpty ?? true ? UIColor.Grayscale.placeholderColor : contact.color
                cell.iconLabel.text = contact.icon
                cell.textField.attributedPlaceholder = NSAttributedString(string: "@\(exampleHandle)", attributes: attributes)
                cell.textField.text = self.twitter.value
            default: break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section > Constants.maxLabelIndex ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getTableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: profileView.tableView.bounds.size.width, height: 100.0))
        
        footerView.addSubview(logOutButton)
        
        logOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return footerView
    }
    
    //MARK: photo/camera delegate
    
    @objc private func avatarPressed(_ sender: UIGestureRecognizer?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            if authStatus == .authorized {
                self.profilePicker.select(fromCamera: self)
            }
            else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    if granted {
                        self.profilePicker.select(fromCamera: self)
                    }
                })
            }
        }
        let choosePhoto = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            let authStatus = PHPhotoLibrary.authorizationStatus()
            
            if authStatus == .authorized {
                self.profilePicker.select(fromPhotoLibrary: self)
            }
            else {
                PHPhotoLibrary.requestAuthorization { newStatus in
                    if newStatus == .authorized {
                        self.profilePicker.select(fromPhotoLibrary: self)
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
    
    func mmsImagePickerControllerDidCancel(_ picker: MMSProfileImagePicker) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func mmsImagePickerController(_ picker: MMSProfileImagePicker, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.image.value = image
            imageDidUpdate.value = true
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
