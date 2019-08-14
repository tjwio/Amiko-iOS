//
//  ProfileEditInfoViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class ProfileEditInfoViewController: TextFieldTableViewController, UITableViewDelegate, UITableViewDataSource {
    private struct Constants {
        static let cellIdentifier = "ProfileEditTextFieldTableViewCell"
    }
    
    let user: User
    
    let firstName: MutableProperty<String>
    let lastName: MutableProperty<String>
    let email: MutableProperty<String>
    let company: MutableProperty<String>
    let job: MutableProperty<String>
    let bio: MutableProperty<String>
    let image: MutableProperty<UIImage?>
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .avenirDemi(size: 16.0)
        label.text = "EDIT INFO"
        label.textColor = UIColor.Grayscale.dark
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var cellDisposables = [Int: Disposable]()
    
    init(user: User) {
        self.user = user
        firstName = MutableProperty(user.firstName)
        lastName = MutableProperty(user.lastName)
        email = MutableProperty(user.email ?? "")
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
        
        addBackButtonToView(dark: true)
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44.0)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(0.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
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
            
            let avatarImageView: UIImageView = {
                let imageView = UIImageView(image: .blankAvatar)
                imageView.layer.cornerRadius = 48.0
                imageView.clipsToBounds = true
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                return imageView
            }()
            
            if let image = image.value {
                avatarImageView.image = image
            } else if let url = user.imageUrl {
                avatarImageView.sd_setImage(with: URL(string: url), placeholderImage: .blankAvatar) { (image, _, _, _) in
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
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? DetailTextFieldTableViewCell ?? DetailTextFieldTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        cellDisposables[indexPath.section]?.dispose()
        
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
            cell.textField.text = company.value
            cell.placeholderLabel.text = "Company"
            cellDisposables[indexPath.section] = company <~ cell.textField.reactive.continuousTextValues
        case 4:
            cell.textField.text = job.value
            cell.placeholderLabel.text = "Job Title"
            cellDisposables[indexPath.section] = job <~ cell.textField.reactive.continuousTextValues
        case 5:
            cell.textField.text = bio.value
            cell.placeholderLabel.text = "Introduction"
            cellDisposables[indexPath.section] = bio <~ cell.textField.reactive.continuousTextValues
        default: break
        }
        
        cell.backgroundColor = UIColor.Grayscale.background
        cell.layer.cornerRadius = 10.0
        
        return cell
    }
}
