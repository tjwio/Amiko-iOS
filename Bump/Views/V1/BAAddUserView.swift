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
    
    var socialCallback: BASocialHandler?
    var actionCallback: BAContactActionHandler?
    
    var mainItems: [(AccountContact, String)]
    var socialItems: [(AccountContact, String)]
    
    var isDelete = false {
        didSet {
            if isDelete {
                doneButton.backgroundColor = UIColor.Red.normal
                doneButton.setTitle("Remove", for: .normal)
                cancelButton.setTitle("Cancel", for: .normal)
            }
            else {
                doneButton.backgroundColor = UIColor.Blue.normal
                doneButton.setTitle("Connect", for: .normal)
                cancelButton.setTitle("Not Now", for: .normal)
            }
        }
    }
    
    let contactHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let backgroundHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let avatarImageView: BAAvatarView = {
        let imageView = BAAvatarView(image: .blankAvatar, shadowHidden: true)
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
        tableView.allowsSelection = true
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
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Grayscale.lighter
        button.setTitle("Not Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 17.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var buttonStackView: UIStackView!
    
    init(mainItems: [(AccountContact, String)], socialItems: [(AccountContact, String)]) {
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
        
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressedUp(_:)), for: UIControl.Event(rawValue: UIControl.Event.touchUpInside.rawValue | UIControl.Event.touchUpOutside.rawValue | UIControl.Event.touchCancel.rawValue))
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressedDown(_:)), for: UIControl.Event(rawValue: UIControl.Event.touchDown.rawValue | UIControl.Event.touchDragInside.rawValue))
        
        doneButton.addTarget(self, action: #selector(self.doneButtonPressedUp(_:)), for: UIControl.Event(rawValue: UIControl.Event.touchUpInside.rawValue | UIControl.Event.touchUpOutside.rawValue | UIControl.Event.touchCancel.rawValue))
        doneButton.addTarget(self, action: #selector(self.doneButtonPressedDown(_:)), for: UIControl.Event(rawValue: UIControl.Event.touchDown.rawValue | UIControl.Event.touchDragInside.rawValue))
        
        buttonStackView = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        buttonStackView.alignment = .center
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 0.0
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contactHolderView.addSubview(backgroundHeaderView)
        contactHolderView.addSubview(avatarImageView)
        contactHolderView.addSubview(nameLabel)
        contactHolderView.addSubview(jobLabel)
        addSubview(contactHolderView)
        addSubview(tableView)
        addSubview(buttonStackView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        backgroundHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.avatarImageView.snp.centerY).offset(20.0)
        }
        
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
            
            cell.iconLabel.text = item.0.icon
            cell.iconLabel.font = item.0.font
            cell.iconLabel.isHidden = false
            cell.accountImageView.isHidden = true
            
            cell.accountHolderView.backgroundColor = item.0.color
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.socialCellIdentifier) as? BASocialDrawerTableViewCell ?? BASocialDrawerTableViewCell(style: .default, reuseIdentifier: Constants.socialCellIdentifier)
            
            cell.drawerView.items = socialItems
            cell.drawerView.selectCallback = socialCallback
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .white
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(hexColor: 0xE6E9ED).cgColor
        cell.layer.cornerRadius = 32.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section < mainItems.count ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let account = mainItems[indexPath.section]
        
        actionCallback?(account.0, account.1)
    }
    
    //MARK: done
    
    @objc func doneButtonPressedUp(_ sender: UIButton?) {
        sender?.backgroundColor = isDelete ? UIColor.Red.normal : UIColor.Blue.normal
    }
    
    @objc func doneButtonPressedDown(_ sender: UIButton?) {
        sender?.backgroundColor = isDelete ? UIColor.Red.darker : UIColor.Blue.darker
    }
    
    //MARK: cancel
    
    @objc func cancelButtonPressedUp(_ sender: UIButton?) {
        sender?.backgroundColor = UIColor.Grayscale.lighter
    }
    
    @objc func cancelButtonPressedDown(_ sender: UIButton?) {
        sender?.backgroundColor = UIColor.Grayscale.light
    }
}