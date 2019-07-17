//
//  ShipDetailViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import FeatherIcon
import SnapKit

class ShipDetailViewController: UIViewController, ShipManageSyncViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    private struct Constants {
        static let cellIdentifier = "ShipDetailTableViewCellIdentifier"
    }
    
    let user: User
    let ship: Ship
    let accounts: [(AccountContact, String)]
    
    lazy var headerView: HeaderView = {
        let view = HeaderView()
        if let imageUrl = ship.user.imageUrl {
            view.infoView.avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
        }
        
        view.infoView.nameLabel.text = ship.user.fullName
        view.infoView.bioLabel.text = ship.user.publicBio
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets.init(top: 24.0, left: 0.0, bottom: 64.0, right: 0.0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var mutualUsersView: MutualUsersView?
    
    lazy var footerView: FooterView = {
        let view = FooterView()
        view.manageButton.addTarget(self, action: #selector(self.manageAccounts(_:)), for: .touchUpInside)
        view.manageButton.setTitle("MANAGE YOUR SHARE WITH \(ship.user.firstName)".uppercased(), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(user: User, ship: Ship) {
        self.user = user
        self.ship = ship
        self.accounts = ship.user.allAccounts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        headerView.closeButton.addTarget(self, action: #selector(self.close(_:)), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        if !ship.user.mutualFriends.isEmpty {
            let mutualUsersView = MutualUsersView(mutualImageUrls: ship.user.mutualFriends.compactMap { $0.imageUrl })
            mutualUsersView.backgroundColor = .clear
            self.mutualUsersView = mutualUsersView
        }
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
            make.bottom.equalToSuperview()
        }
        
        footerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(64.0)
        }
    }
    
    // MARK: buttons
    
    @objc private func manageAccounts(_ sender: LoadingButton) {
        NetworkHandler.shared.loadSpecificUserShip(userId: ship.user.id, success: { ship in
            DispatchQueue.main.async {
                self.showManageAccountsController(currShip: ship)
                sender.isLoading = false
            }
        }) { _ in
            sender.isLoading = false
        }
    }
    
    private func showManageAccountsController(currShip: Ship) {
        guard let coordinate = LocationManager.shared.currentLocation?.coordinate else { return }
        
        let viewController = ShipManageSyncViewController(ship: currShip, currUser: user, userToAdd: ship.user, coordinate: coordinate, buttonTitle: "COMPLETE")
        viewController.delegate = self
        viewController.headerHeight = headerView.frame.size.height
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        
        present(viewController, animated: false, completion: nil)
    }
    
    @objc private func close(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 24.0 : 12.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? SyncUserAccountsView.TableViewCell ?? SyncUserAccountsView.TableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        let account = accounts[indexPath.section]
        
        cell.iconLabel.text = account.0.icon
        cell.valueLabel.text = account.1
        
        cell.accessoryType = .none
        cell.backgroundColor = UIColor.Grayscale.background
        cell.iconLabel.textColor = UIColor.Matcha.dusk
        cell.valueLabel.textColor = UIColor.Matcha.dusk
        cell.actionLabel.isHidden = false
        cell.actionLabel.text = .featherIcon(name: .arrowUpRight)
        cell.actionLabel.textColor = UIColor.Matcha.dusk
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.0
        cell.layer.cornerRadius = 20.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let account = accounts[indexPath.section].0
        let value = accounts[indexPath.section].1
        
        if let urlStr = account.appUrl(id: value), let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let urlStr = account.webUrl(id: value), let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: table header view
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let header = mutualUsersView else { return }
        
        header.frame.size.height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableView.tableHeaderView = header
        tableView.layoutIfNeeded()
    }
    
    // MARK: ship delegate
    
    func shipManageController(_ viewController: ShipManageSyncViewController, didUpdate ship: Ship) {
        showLeftMessage("Successfully updated shared info!", type: .success)
        viewController.dismissViewController(completion: nil)
    }
}
