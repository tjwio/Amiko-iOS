//
//  SyncUserViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/8/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon
import MapKit
import ReactiveCocoa
import ReactiveSwift
import SnapKit

class SyncUserBaseViewController: UIViewController {
    let currUser: User
    var userToAdd: User!
    
    let coordinate: CLLocationCoordinate2D
    
    let accountsView: SyncUserAccountsView
    let buttonTitle: String
    
    let userToAddShip = MutableProperty<Ship?>(nil)
    let ownShip = MutableProperty<Ship?>(nil)
    
    private var disposables = CompositeDisposable()
    
    var isWaiting = false {
        didSet {
            if isWaiting {
                cancelButton.backgroundColor = .clear
                let attributedTitle = NSMutableAttributedString(string: "\(String.featherIcon(name: .x)) CANCEL", attributes: [.foregroundColor: UIColor.white])
                attributedTitle.addAttribute(.font, value: UIFont.featherFont(size: 20.0)!, range: NSMakeRange(0, 1))
                attributedTitle.addAttribute(.font, value: UIFont.avenirDemi(size: 14.0)!, range: NSMakeRange(1, attributedTitle.length-1))
                attributedTitle.addAttribute(.baselineOffset, value: 2.0, range: NSMakeRange(1, attributedTitle.length-1))
                cancelButton.setAttributedTitle(attributedTitle, for: .normal)
                
                confirmButton.isHidden = true
            }
        }
    }
    
    let headerView: SyncUserHeaderView = {
        let view = SyncUserHeaderView()
        view.backgroundColor = UIColor.Grayscale.background
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        
        let attributedTitle = NSMutableAttributedString(string: "\(String.featherIcon(name: .x)) CANCEL", attributes: [.foregroundColor: UIColor.Matcha.dusk])
        attributedTitle.addAttribute(.font, value: UIFont.featherFont(size: 20.0)!, range: NSMakeRange(0, 1))
        attributedTitle.addAttribute(.font, value: UIFont.avenirDemi(size: 14.0)!, range: NSMakeRange(1, attributedTitle.length-1))
        attributedTitle.addAttribute(.baselineOffset, value: 2.0, range: NSMakeRange(1, attributedTitle.length-1))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let fullView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let messageBanner: MessageBannerView = {
        let banner = MessageBannerView()
        banner.backgroundColor = UIColor.Matcha.sky
        banner.iconLabel.text = .featherIcon(name: .loader)
        banner.textColor = UIColor.Matcha.dusk
        banner.translatesAutoresizingMaskIntoConstraints = false
        
        return banner
    }()
    
    lazy var confirmButton: LoadingButton = {
        let button = LoadingButton(type: .custom)
        button.backgroundColor = UIColor.Matcha.dusk
        
        let attributedTitle = NSMutableAttributedString(string: "\(buttonTitle) \(String.featherIcon(name: .arrowRight))", attributes: [.foregroundColor: UIColor.white])
        attributedTitle.addAttribute(.font, value: UIFont.featherFont(size: 20.0)!, range: NSMakeRange(attributedTitle.length-1, 1))
        attributedTitle.addAttribute(.font, value: UIFont.avenirDemi(size: 14.0)!, range: NSMakeRange(0, attributedTitle.length-1))
        attributedTitle.addAttribute(.baselineOffset, value: 2.0, range: NSMakeRange(0, attributedTitle.length-1))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let backgroundFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    init(currUser: User, coordinate: CLLocationCoordinate2D, buttonTitle: String) {
        self.currUser = currUser
        accountsView = SyncUserAccountsView(user: currUser)
        self.coordinate = coordinate
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
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
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        accountsView.backgroundColor = .white
        accountsView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed(_:)), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(self.confirmButtonPressed(_:)), for: .touchUpInside)
        
        view.addSubview(headerView)
        view.addSubview(fullView)
        fullView.addSubview(accountsView)
        fullView.addSubview(backgroundFooterView)
        fullView.addSubview(overlayView)
        fullView.addSubview(buttonStackView)
        
        setupConstraints()
        
        disposables += NotificationCenter.default.reactive.notifications(forName: .shipAdded).observeValues { [unowned self] notification in
            guard let ship = notification.object as? Ship else { return }
            self.userToAddShip.value = ship
            
            self.messageBanner.iconLabel.text = .featherIcon(name: .checkCircle)
            self.messageBanner.messageLabel.text = "Done! \(self.userToAdd.firstName) is waiting to be your Amiko!"
            self.messageBanner.textColor = .white
            self.messageBanner.backgroundColor = UIColor.Matcha.dusk
        }
        
        disposables += Signal.combineLatest(userToAddShip.signal, ownShip.signal).observeValues { (userToAddShip, ownShip) in
            guard let userToAddShip = userToAddShip, ownShip != nil else { return }
            
            self.currUser.ships.append(userToAddShip)
            NotificationCenter.default.post(name: .connectionAdded, object: userToAddShip)
            
            let manageController = ShipDetailViewController(user: self.currUser, ship: userToAddShip)
            self.navigationController?.setViewControllers([manageController], animated: true)
            
            let successController = SyncSuccessViewController(name: self.userToAdd.fullName, imageUrl: self.userToAdd.imageUrl)
            successController.providesPresentationContextTransitionStyle = true
            successController.definesPresentationContext = true
            successController.modalPresentationStyle = .overCurrentContext
            self.present(successController, animated: false, completion: nil)
        }
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        accountsView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        backgroundFooterView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(64.0)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupFullViewConstraints()
    }
    
    func setupFullViewConstraints() {
        view.addSubview(messageBanner)
        
        messageBanner.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40.0)
        }
        
        fullView.snp.makeConstraints { make in
            make.top.equalTo(self.messageBanner.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if confirmButton.frame.size.height > 0.0 {
            confirmButton.roundCorners(corners: [.topLeft], radius: 36.0)
        }
    }
    
    // MARK: user info
    
    func setupUserToAddInfo() {
        headerView.infoView.isHidden = false
        headerView.mutualUsersView.isHidden = false
        
        if let imageUrl = userToAdd.imageUrl {
            headerView.infoView.avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
        } else {
            headerView.infoView.avatarImageView.image = UIImage.blankAvatar
        }
        
        headerView.infoView.nameLabel.text = userToAdd.fullName
        headerView.infoView.bioLabel.text  = userToAdd.publicBio
        headerView.mutualUsersView.mutualImageUrls = userToAdd.mutualFriends.compactMap { $0.imageUrl }
        
        messageBanner.messageLabel.text = "\(userToAdd.fullName) is picking what to share..."
    }
    
    // MARK: buttons
    
    @objc func cancelButtonPressed(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmButtonPressed(_ sender: LoadingButton) {
        currUser.addConnection(toUserId: userToAdd.id, latitude: coordinate.latitude, longitude: coordinate.longitude, accounts: accountsView.accounts.filter { $0.2 }.map { $0.0 }, success: { ship in
            sender.isLoading = false
            
            self.isWaiting = true
            
            self.messageBanner.iconLabel.text = .featherIcon(name: .checkCircle)
            self.messageBanner.messageLabel.text = "Done! Just waiting for \(self.userToAdd.firstName) to finish"
            self.messageBanner.textColor = .white
            self.messageBanner.backgroundColor = UIColor.Matcha.dusk
            
            self.overlayView.isHidden = false
            
            self.ownShip.value = ship
        }) { _ in
            sender.isLoading = false
            self.showLeftMessage("Failed to add connection, please try again", type: .error)
        }
    }
}

class SyncUserAddViewController: SyncUserBaseViewController {
    init(currUser: User, userToAdd: User, coordinate: CLLocationCoordinate2D, buttonTitle: String) {
        super.init(currUser: currUser, coordinate: coordinate, buttonTitle: buttonTitle)
        self.userToAdd = userToAdd
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserToAddInfo()
    }
}
