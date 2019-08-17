//
//  ProfileEditInfoViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import Photos
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class ProfileEditInfoViewController: TextFieldTableViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private struct Constants {
        static let textFieldCellIdentifier = "ProfileEditTextFieldTableViewCell"
        static let textViewCellIdentifier = "ProfileEditTextViewTableViewCell"
    }
    
    let user: User
    
    let firstName: MutableProperty<String>
    let lastName: MutableProperty<String>
    let email: MutableProperty<String>
    let phone: MutableProperty<String>
    let company: MutableProperty<String>
    let job: MutableProperty<String>
    let bio: MutableProperty<String>
    let image: MutableProperty<UIImage?>
    
    let imageDidUpdate = MutableProperty<Bool>(false)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 16.0)
        label.text = "EDIT INFO"
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let buttonFooterView: ButtonFooterView = {
        let view = ButtonFooterView(confirmButtonTitle: "UPDATE")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var cellDisposables = [Int: Disposable]()
    
    init(user: User) {
        self.user = user
        firstName = MutableProperty(user.firstName)
        lastName = MutableProperty(user.lastName)
        email = MutableProperty(user.email ?? "")
        phone = MutableProperty(user.phone ?? "")
        company = MutableProperty(user.company ?? "")
        job = MutableProperty(user.profession ?? "")
        bio = MutableProperty(user.bio ?? "")
        image = MutableProperty(user.image.value)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cellDisposables.values.forEach { $0.dispose() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buttonFooterView.cancelButton.addTarget(self, action: #selector(self.dismissViewController(_:)), for: .touchUpInside)
        buttonFooterView.confirmButton.addTarget(self, action: #selector(self.save(_:)), for: .touchUpInside)
        
        tableView.contentInset.bottom = 72.0
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(buttonFooterView)
        
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if buttonFooterView.confirmButton.frame.size.height > 0.0 {
            buttonFooterView.confirmButton.roundCorners(corners: [.topLeft], radius: 36.0)
        }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44.0)
            make.centerX.equalToSuperview()
        }
        
        buttonFooterView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(0.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: button
    
    @objc private func dismissViewController(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func save(_ sender: LoadingButton) {
        user.updateUser(firstName: firstName.value, lastName: lastName.value, profession: job.value, company: company.value, bio: bio.value, phone: phone.value, email: email.value, success: {
            if self.imageDidUpdate.value, let newImage = self.image.value {
                self.user.updateImage(newImage, success: {
                    sender.isLoading = false
                    self.showLeftMessage("Successfully updated user info!", type: .success)
                }, failure: { error in
                    self.showLeftMessage("Failed to update user image, please try again.", type: .error)
                })
            } else {
                sender.isLoading = false
                self.showLeftMessage("Successfully updated user info!", type: .success)
            }
            
            NotificationCenter.default.post(name: .bumpDidUpdateUser, object: nil)
        }) { _ in
            self.showLeftMessage("Failed to update info", type: .error)
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 144.0
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView()
            
            let avatarImageView = UploadAvatarImageView()
            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.avatarPressed(_:)))
            avatarImageView.addGestureRecognizer(tapGestureRecognizer)
            
            if let image = image.value {
                avatarImageView.imageView.image = image
            } else if let url = user.imageUrl {
                avatarImageView.imageView.sd_setImage(with: URL(string: url), placeholderImage: .blankAvatar) { (image, _, _, _) in
                    self.image.value = image
                }
            }
            
            headerView.addSubview(avatarImageView)
            
            avatarImageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.width.equalTo(95.0)
            }
            
            return headerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 6 ? 96.0 : 48.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellDisposables[indexPath.section]?.dispose()
        
        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.textViewCellIdentifier) as? DetailTextViewTableViewCell ?? DetailTextViewTableViewCell(style: .default, reuseIdentifier: Constants.textViewCellIdentifier)
            
            cell.textView.text = bio.value
            cell.placeholderLabel.text = "Introduction"
            cellDisposables[indexPath.section] = bio <~ cell.textView.reactive.continuousTextValues
            
            cell.backgroundColor = UIColor.Grayscale.background
            cell.layer.cornerRadius = 10.0
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.textFieldCellIdentifier) as? DetailTextFieldTableViewCell ?? DetailTextFieldTableViewCell(style: .default, reuseIdentifier: Constants.textFieldCellIdentifier)
            
            switch indexPath.section {
            case 0:
                cell.textField.text = firstName.value
                cell.placeholderLabel.text = "First Name"
                cellDisposables[indexPath.section] = firstName <~ cell.textField.reactive.continuousTextValues
            case 1:
                cell.textField.text = lastName.value
                cell.placeholderLabel.text = "Last Name"
                cellDisposables[indexPath.section] = lastName <~ cell.textField.reactive.continuousTextValues
            case 2:
                cell.textField.text = email.value
                cell.placeholderLabel.text = "Email"
                cellDisposables[indexPath.section] = email <~ cell.textField.reactive.continuousTextValues
            case 3:
                cell.textField.text = phone.value
                cell.placeholderLabel.text = "Phone Number"
                cellDisposables[indexPath.section] = phone <~ cell.textField.reactive.continuousTextValues
            case 4:
                cell.textField.text = company.value
                cell.placeholderLabel.text = "Company"
                cellDisposables[indexPath.section] = company <~ cell.textField.reactive.continuousTextValues
            case 5:
                cell.textField.text = job.value
                cell.placeholderLabel.text = "Job Title"
                cellDisposables[indexPath.section] = job <~ cell.textField.reactive.continuousTextValues
            default: break
            }
            
            cell.backgroundColor = UIColor.Grayscale.background
            cell.layer.cornerRadius = 10.0
            
            return cell
        }
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
}
