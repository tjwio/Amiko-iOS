//
//  BAAddUserView.swift
//  Bump
//
//  Created by Tim Wong on 4/16/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class BAAddUserView: UIView, UITableViewDelegate, UITableViewDataSource {
    private struct Constants {
        static let buttonHeight: CGFloat = 54.0
        static let selectableCellIdentifier = "BASelectableAccountTableViewCellIdentifier"
        static let socialCellIdentifier = "BASocialDrawerTableViewCellIdentifier"
    }
    
    var mainItems: [(BAAccountContact, String)]
    var socialItems: [(BAAccountContact, String)]
    
    let contactHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let avatarImageView: BAAvatarView = {
        let imageView = BAAvatarView(image: .blankAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexColor: 0x656A6F)
        label.font = UIFont.avenirDemi(size: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let jobLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Designer at Tesla"
        label.textColor = UIColor(hexColor: 0xA7ADB6)
        label.font = UIFont.avenirRegular(size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: Constants.buttonHeight, right: 0.0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let doneButton: BALoadingButton = {
        let button = BALoadingButton(type: .custom)
        button.backgroundColor = UIColor.Blue.normal
        button.setTitle("Connect", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.reactive.controlEvents(UIControlEvents(rawValue: UIControlEvents.touchUpInside.rawValue | UIControlEvents.touchUpOutside.rawValue | UIControlEvents.touchCancel.rawValue)).observeValues { button in
            button.backgroundColor = UIColor.Blue.normal
        }
        
        button.reactive.controlEvents(UIControlEvents(rawValue: UIControlEvents.touchDown.rawValue | UIControlEvents.touchDragInside.rawValue)).observeValues { button in
            button.backgroundColor = UIColor.Blue.darker
        }
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Grayscale.lighter
        button.setTitle("Not Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.reactive.controlEvents(UIControlEvents(rawValue: UIControlEvents.touchUpInside.rawValue | UIControlEvents.touchUpOutside.rawValue | UIControlEvents.touchCancel.rawValue)).observeValues { button in
            button.backgroundColor = UIColor.Grayscale.lighter
        }
        
        button.reactive.controlEvents(UIControlEvents(rawValue: UIControlEvents.touchDown.rawValue | UIControlEvents.touchDragInside.rawValue)).observeValues { button in
            button.backgroundColor = UIColor.Grayscale.light
        }
        
        return button
    }()
    
    private var buttonStackView: UIStackView!
    
    init(mainItems: [(BAAccountContact, String)], socialItems: [(BAAccountContact, String)]) {
        self.mainItems = mainItems
        self.socialItems = socialItems
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = UIColor(hexColor: 0xFBFCFD)
        
        clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        buttonStackView = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        buttonStackView.alignment = .center
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 0.0
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contactHolderView.addSubview(avatarImageView)
        contactHolderView.addSubview(nameLabel)
        contactHolderView.addSubview(jobLabel)
        addSubview(contactHolderView)
        addSubview(tableView)
        addSubview(buttonStackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.contactHolderView).offset(40.0)
            make.centerX.equalTo(self.contactHolderView)
            make.height.width.equalTo(100.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(20.0)
            make.centerX.equalTo(self.contactHolderView)
        }
        
        jobLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(4.0)
            make.centerX.equalTo(self.contactHolderView)
        }
        
        contactHolderView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.contactHolderView.snp.bottom).offset(20.0)
            make.leading.equalTo(self).offset(20.0)
            make.trailing.equalTo(self).offset(-20.0)
            make.bottom.equalTo(self)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(Constants.buttonHeight)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
        
        super.updateConstraints()
    }
    
    //MARK: table view methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainItems.count + (socialItems.isEmpty ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < mainItems.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.selectableCellIdentifier) as? BASelectAccountTableViewCell ?? BASelectAccountTableViewCell(style: .default, reuseIdentifier: Constants.selectableCellIdentifier)
            
            let item = mainItems[indexPath.section]
            
            cell.accountLabel.text = item.1
            
            if let imageName = item.0.image, let image = UIImage(named: imageName) {
                cell.accountImageView.image = image
                cell.accountImageView.isHidden = false
                cell.iconLabel.isHidden = true
            }
            else if let iconHex = item.0.icon {
                cell.iconLabel.text = iconHex
                cell.iconLabel.font = item.0.font
                cell.iconLabel.isHidden = false
                cell.accountImageView.isHidden = true
            }
            
            cell.layer.cornerRadius = 32.0
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.socialCellIdentifier) as? BASocialDrawerTableViewCell ?? BASocialDrawerTableViewCell(style: .default, reuseIdentifier: Constants.socialCellIdentifier)
            
            cell.items = socialItems
            
            return cell
        }
    }
}
