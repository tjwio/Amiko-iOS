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

class ProfileEditInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
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
        
        navigationItem.title = "EDIT INFO"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.Matcha.dusk,
            .font: .avenirDemi(size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16.0)
        ]
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0.0, left: 32.0, bottom: 0.0, right: 32.0))
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
