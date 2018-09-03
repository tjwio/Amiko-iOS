//
//  BAProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class BAProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private struct Constants {
        static let cellIdentifier = "BAProfileDetailValueTableViewCellIdentifier"
        static let headers = [0, 1, 3, 7]
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
    
    let profileView: BAProfileView = {
        let view = BAProfileView()
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
        
        image.value = user.image.value
        firstName.value = user.firstName
        lastName.value = user.lastName
        jobTitle.value = user.profession
        company.value = user.company
        phone.value = user.phone
        email.value = user.email
        
        for account in user.socialAccounts {
            switch account.0 {
            case .facebook:
                facebook.value = account.1
            case .linkedin:
                linkedin.value = account.1
            case .instagram:
                instagram.value = account.1
            case .twitter:
                twitter.value = account.1
            default: break
            }
        }
        
        super.init(nibName: nil, bundle: nil)
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
        
        profileView.cancelButton.addTarget(self, action: #selector(self.cancelProfileView(_:)), for: .touchUpInside)
        profileView.saveButton.addTarget(self, action: #selector(self.saveProfileView(_:)), for: .touchUpInside)
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        profileView.isHidden = false
        profileView.transform = CGAffineTransform(translationX: 0.0, y: view.frame.size.height)
        profileView.layer.cornerRadius = 20.0
        
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
    }
    
    //MARK: cancel
    
    @objc private func cancelProfileView(_ sender: UIButton?) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = .clear
            self.profileView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        }) { completed in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK: save
    
    @objc private func saveProfileView(_ sender: BALoadingButton?) {
        
    }
    
    //MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headers.contains(section) ? 0.5 : 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return Constants.headers.contains(section) ? UIView() : nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? BAProfileDetailValueTableViewCell ?? BAProfileDetailValueTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        let attributes: [NSAttributedStringKey : Any] = [ .foregroundColor :  UIColor.Grayscale.placeholderColor]
        
        if indexPath.section <= Constants.maxLabelIndex {
            cell.detailLabel.isHidden = false
            cell.accountHolderView.isHidden = true
            cell.iconLabel.isHidden = true
            cell.textField.isEnabled = true
            
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
                cell.textField.keyboardType = .phonePad
            }
            else if indexPath.section == Constants.emailIndex {
                cell.textField.keyboardType = .emailAddress
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
}
